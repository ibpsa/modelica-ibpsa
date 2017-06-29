-------------------
Annex60 Pipe models 
-------------------


.. Fixme: Math notation

Introduction
============

This file contains information about the aim of the ``Annex60.Experimental.Pipe`` subpackage and an overview of the development history of the plug flow pipe models. The ``Pipe`` package is developed within the IEA EBC Annex 60. [#f1]_



Aim
======

The ``Pipe`` package is intended as an improvement of the Modelica Standard Library pipes for the specific case of thermal network (district heating and cooling) simulations. The pipe model aims at improving the representation of the delay effects in longer pipes and at accelerating the simulation of such pipes.

Problems that were previously encountered with the existing pipe models include the inability to represent the delay of temperature changes at the inlet of the pipe and the corresponding heat losses.
The current MSL implementation uses one or more mixing volumes (more in case of discretization). This way of modelling is not able to represent the plug flow behaviour, which requires a time delay depending on the fluid velocity and the length of the pipe. The mixing volume approach shows an exponential transition between temperatures instead, whereas the discretized approach causes numerical diffusion effects in the outlet temperature.

After simplification, the equation that has to be solved comes down to the following advection (without diffusion) equation with a sink term (namely the heat losses :math:`\dot{Q}_e`):

.. math::

	\frac{\partial\left(\rho h A\right)}{\partial t} + \frac{\partial\left(\rho vAh\\right)}{\partial x}  = - \dot{Q}_e

In Modelica, the `spatialDistribution` operator allows for solving the left hand side of this equation. To account for the heat loss, the enthalpy (or, for an assumingly incompressible fluid, the temperature) is changed when the fluid exits the pipe. The change in enthalpy or temperature is generally a function of the inlet temperature, the boundary conditions (i.e. mainly the surroundings and possibly other pipes that run in the same direction) and the delay. 

The next section elaborates on the initial contributions to the pipe model and the subsequent developments.

Development history
===================

The development of the ``Pipe`` models was started simultaneously by different participants of Annex 60.

First implementations
---------------------

.. FIXME: please tell me if more precise reference to the actual contributors is needed. I thought the institution would be okay.

The first version in the Annex 60 library, developed at *RWTH Aachen* comprised an adiabatic pipe that implemented the advection equation (the plug flow delay), later extended with heat loss operators at both sides of the pipe. The heat operators implement an exponential temperature decay for a single pipe and known heat transfer coefficient to the surrounding (with ambient temperature as the boundary condition). The instantaneous outlet velocity is used as a proxy for the delay time, and the model allows flow reversal.

At *ULg*, the focus was on the improvement of the pipe model irrespective of the modelling language. A numerical scheme was implemented in MatLab and here the necessity of accounting for the heat capacity of the pipe material and surroundings was realized. 

At *KU Leuven*, the focus lied on a supply and return pipe ensemble. The numerical and computational issues with the current models were pinpointed during a study of the behaviour of a district heating network with time modulation of the supply temperature (temporarily increasing the temperature in the low temperature network in order to charge the DHW buffers). This implementation based its heat loss calculations on the multipole method of Wallentén [Wal1991]_, while calculating the time delay by keeping track of the previous mass flows for each fluid parcel. This model however lacked the ability of modelling reverse flows.

During the Annex 60 Expert Meeting of September 2015 in Leuven, it was decided to gather these contributions and combine them into one model for the Annex 60 Modelica Library.

Joint development
-----------------

In a first step, the two existing versions in Modelica (referred to as the Annex60 or A60 and KUL model, see above) were compared. The first tests that were run identified a number of problems. The test firstly applied a forward flow, then a period of zero flow, and finally a reverse flow, as can be seen in the figure below.

.. image:: img/FirstTest.png
	:width: 12cm

Delay after reverse flow
''''''''''''''''''''''''

The problems encountered included an inability to represent the cooling effects during zero flow for both pipes, a wrong solution when the KUL pipe was operated in reverse flow due to negative delay times, strange initialization behaviour for the KUL pipe. 

The negative delay times were attended by changing the initial code for the delay calculation [#f2]_: ::

	der(x) = velocity;
	(  ,tout) = spatialDistribution(time,     
					0,      
					x/length,      
					true,      
					{0.0, 1},      
					{0.0, 0});
	tau = td;
	td = time - tout ;

to a version that keeps track of the entrance time from both sides of the pipe: ::

    der(x) = velocity;
    (TimeOut_a,TimeOut_b) = spatialDistribution(tin,
    						tin,
    						x/L,
    						velocity>=0,
    						{0, 1},
    						{0, 0});
    if velocity>=0 then
      delay = tin - TimeOut_b;
    else
      delay = tin- TimeOut_a;
    end if;

This last implementation allowed to account for flow in two directions, however on flow reversal, a jump to a delay of 0 seconds appeared, as shown in the figure below:

.. image:: img/ZeroDrop.png
	:width: 12cm

In order to avoid this jump to 0s delay, a tracking value was added to the delay operator: ::

	v_a =  u >0; 			// True if flow is positive
  	v_b =  u <0; 			// True if flow is negative
  	when change(v_a) then		// Save time at which flow drops to 0
    	    track1 = pre(time);
  	end when;
  	when change(v_b) then		// Save time at which flow drops to 0
    	    track2 = pre(time);
  	end when;
  	when time-TimeOut_a > (track2-track1) and v_b then
  					// Reinitialize track values when current delay for 
  					// negative flow is greater than the difference 
  					// between tracked values
    	    reinit(track1,0);
    	    reinit(track2,0);
  	end when;

  	tau_a = Annex60.Utilities.Math.Functions.smoothMax(time - TimeOut_a,track2-track1,1);

These changes imply that when the flow becomes negative, the simulation should take the tracked delay instead of calculating the delay based on the difference between the input time and the current time, which are the same as a consequence of the definition of the ``spatialDelay`` operator. 

Outlet temperature after zero flow
''''''''''''''''''''''''''''''''''

In a next step, the ``HeatLoss`` operator, originally in the A60 model, was updated so as to use the tracked delay instead of the propagation time based on the instantaneous velocity. The difference with the previous version can be seen in the graph below:

.. image:: img/HeatLossZero.png
	:width: 12cm

The red line shows a decreasing output temperature after increasingly longer zero flow periods. The previous A60 implementation does not show this behaviour yet because of the instantaneous delay time calculation :math:`T_{out} = T_env + (T_{in} - T_{env})*exp(-UA/(mass_flow*cp))`, but this has been adapted.

Temperature update at outlet
''''''''''''''''''''''''''''

In the original A60 pipe, the temperature change at the outlet was implemented as a change of the outlet enthalpy by means of the equations below: ::

	a = Annex60.Utilities.Math.Functions.inverseXRegularized(
                                          (m_flow * cp_default)/
                                          (thermTransmissionCoeff * A_surf), 1e-5);
  	theta = Annex60.Utilities.Math.Functions.smoothExponential(a, 1e-5);

  	Tin_a * cp_default = inStream(port_a.h_outflow);

  	Tout_b - Tenv = theta * (Tin_a - Tenv);

 	port_a.h_outflow = inStream(port_b.h_outflow);
  	port_b.h_outflow = Tout_b * cp_default;

While the ``inStream`` operator enables reverse flow to pass through the ``HeatLoss`` module without any change, the outlet temperature for forward flow is updated using an exponential difference in function of the mass flow. 

In the KUL pipe, the temperature change was actuated with a mixing volume with a calculated outlet temperature (using a prescribed temperature block at the Mixing Volume heat port) as in the figure below. The downside of this implementation was the difficulty to make it operate in two directions, which made the balance tip in the direction of the A60 implementation with its ``inStream`` operator.

.. image:: img/KULVolume.png
	:width: 12cm

As mentioned before, the A60 implementation was altered in order to take the actual delay after zero flow into account as well, namely with the following equation: ::
	
	Tout_b = T_env + (Tin_a - T_env) * Modelica.Math.exp(-tau/tau_char);

In this last equation, ``tau_char`` is the time constant of the pipe, namely :math:`R*C` over the length of the pipe.

Bumps in delay time
'''''''''''''''''''

The new implementation of the delay time operator introduced a number of bumps in the output of the ``spatialDistribution`` function that are difficult to explain, as can be seen in following figure:

.. image:: img/TimeOutBump.png
	:width: 12cm

This problem was attended by using a small threshold value ``epsilon`` for (nearly) zero mass flow. [#f3]_ ::

	epsilon = 1000000*Modelica.Constants.eps;
  	if v  >= -epsilon then
	    vBoolean = true;
  	else
	    vBoolean = false;
  	end if;
  	der(x) = v;
  	v = (V_flow / A_cross); 	// flow speed = volume flow/cross area
  	(, time_out_b) = spatialDistribution(time,time,x/length,vBoolean,{0.0, 1.0},{0.0, 0.0});

However, this was no complete solution for the problem, as can be seen by the sudden drop to zero of the time delay built up during zero flow periods: 

.. image:: img/Epsilon.png
	:width: 12cm

A large improvement came from a slightly different implementation of the ``epsilon`` test: ::

	if abs(v) >= epsilon then
		flat_v = v;
	else
		flat_v = 0;
	end if;
	der(x) = flat_v;

.. image:: img/EpsilonImpr.png
	:width: 12cm

Although the solution looks better now, there are still some instabilities which cause the delay to drop to 0 during one time step at certain times. 

One delay operator per pipe ensemble
''''''''''''''''''''''''''''''''''''

It appeared better to use only one delay operator per pipe ensemble. Since the mass flow is the same for both sides of the pipe and even for the supply and return pipe for double pipe systems, only one time delay operator is necessary,  whereas previously each ``HeatLoss`` module included a delay operator. Because of the memory needed for the ``spatialDistribution`` function, it is predicted that this might reduce the needed calculation power. 

The pipe level time delay operator is implemented with the following code: ::

	//Speed
	der(x) = velocity;
	(timeOut_a,timeOut_b) = spatialDistribution(
					inp_a,
					inp_b,
					x/length,
					velocity >= 0,
					{0.0,1.0},
					{0.0,0.0});

	v_a = velocity > eps;
	v_b = velocity < -eps;
	v_0 = abs(velocity) < eps;

	when edge(v_0) then
		track_a = pre(timeOut_a);
		track_b = pre(timeOut_b);
	end when;
	when v_a then
		reinit(inp_b, pre(track_b));
	end when;
	when v_b then
		reinit(inp_a, pre(track_a));
	end when;

	if v_0 then
		inp_a = track_a;
		inp_b = track_b;
		tau_a = time - track_a;
		tau_b = time - track_b;
	else
		inp_a = time;
		inp_b = time;
		tau_a = time - timeOut_a;
		tau_b = time - timeOut_b;
	end if;

	tau = max(tau_a, tau_b);

It requires only input for the mass flow in the entire pipe section. However, the influence on the computational speed due to the relatively large amount of if- and when-clauses remains to be seen. The result of this block can be seen below:

.. image:: img/PipeLevel.png
	:width: 12cm

Although the example is not exactly the same, the right half of above image can be easily compared to the previous figure, and it can be seen that the current model combines the forward and reverse flow delays. 

Problems still to be addressed
------------------------------

* Initialization of time delay ``spatialDistribution`` operator
* Comparison of results for two pipes modelled independently or jointly (coupled solition of DoublePipe)
* Assess influence of axial diffusion during zero flow



File history
============

- First version by Bram van der Heijde, November 8 2015.

References
==========
.. [Wal1991] Wallentén, P. (1991). Steady-state heat loss from insulated pipes. Lund Institute of Technology, Sweden.

Footnotes
---------

.. [#f1] Fixmes can be found in the source text.
.. [#f2] This delay operator stores the entrance time for each fluid parcel that flows into the pipe. The ``spatialDistribution`` operator makes the entrance time propagate through the pipe in the same way as the fluid does. When the fluid parcel exits the pipe, this tracked entrance time is compared to the current time, which is the delay ``tau``. 
.. [#f3] This code was included in each ``HeatLoss`` block, which means that only the delay time in one flow direction needs to be logged in this block.


