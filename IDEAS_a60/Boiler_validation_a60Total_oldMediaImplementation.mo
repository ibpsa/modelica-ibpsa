package ModelicaServices
  "(version = 3.2.1, target = \"Dymola\") Models and functions used in the Modelica Standard Library requiring a tool specific implementation"

package Machine

  final constant Real eps=1.e-15 "Biggest number such that 1.0 + eps = 1.0";

  final constant Real small=1.e-60
  "Smallest number such that small and -small are representable on the machine";

  final constant Real inf=1.e+60
  "Biggest Real number such that inf and -inf are representable on the machine";
  annotation (Documentation(info="<html>
<p>
Package in which processor specific constants are defined that are needed
by numerical algorithms. Typically these constants are not directly used,
but indirectly via the alias definition in
<a href=\"modelica://Modelica.Constants\">Modelica.Constants</a>.
</p>
</html>"));
end Machine;
annotation (
  Protection(access=Access.hide),
  preferredView="info",
  version="3.2.1",
  versionDate="2013-01-17",
  versionBuild=1,
  uses(Modelica(version="3.2.1")),
  conversion(
    noneFromVersion="1.0",
    noneFromVersion="1.1",
    noneFromVersion="1.2"),
  Documentation(info="<html>
<p>
This package contains a set of functions and models to be used in the
Modelica Standard Library that requires a tool specific implementation.
These are:
</p>

<ul>
<li> <a href=\"modelica://ModelicaServices.Animation.Shape\">Shape</a>
     provides a 3-dim. visualization of elementary
     mechanical objects. It is used in
<a href=\"modelica://Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape\">Modelica.Mechanics.MultiBody.Visualizers.Advanced.Shape</a>
     via inheritance.</li>

<li> <a href=\"modelica://ModelicaServices.Animation.Surface\">Surface</a>
     provides a 3-dim. visualization of
     moveable parameterized surface. It is used in
<a href=\"modelica://Modelica.Mechanics.MultiBody.Visualizers.Advanced.Surface\">Modelica.Mechanics.MultiBody.Visualizers.Advanced.Surface</a>
     via inheritance.</li>

<li> <a href=\"modelica://ModelicaServices.ExternalReferences.loadResource\">loadResource</a>
     provides a function to return the absolute path name of an URI or a local file name. It is used in
<a href=\"modelica://Modelica.Utilities.Files.loadResource\">Modelica.Utilities.Files.loadResource</a>
     via inheritance.</li>

<li> <a href=\"modelica://ModelicaServices.Machine\">ModelicaServices.Machine</a>
     provides a package of machine constants. It is used in
<a href=\"modelica://Modelica.Constants\">Modelica.Constants</a>.</li>

<li> <a href=\"modelica://ModelicaServices.Types.SolverMethod\">Types.SolverMethod</a>
     provides a string defining the integration method to solve differential equations in
     a clocked discretized continuous-time partition (see Modelica 3.3 language specification).
     It is not yet used in the Modelica Standard Library, but in the Modelica_Synchronous library
     that provides convenience blocks for the clock operators of Modelica version &ge; 3.3.</li>
</ul>

<p>
This implementation is targeted for Dymola.
</p>

<p>
<b>Licensed by DLR and Dassault Syst&egrave;mes AB under the Modelica License 2</b><br>
Copyright &copy; 2009-2013, DLR and Dassault Syst&egrave;mes AB.
</p>

<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"http://www.modelica.org/licenses/ModelicaLicense2\"> http://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>

</html>"));
end ModelicaServices;

package Buildings "Library with models for building energy and control systems"
  extends Modelica.Icons.Package;

  package Fluid "Package with models for fluid flow systems"
    extends Modelica.Icons.Package;

    package Delays "Package with delay models"
      extends Modelica.Icons.VariantsPackage;

      model DelayFirstOrder
      "Delay element, approximated by a first order differential equation"
        extends Buildings.Fluid.MixingVolumes.MixingVolume(final V=V_nominal);

        parameter Modelica.SIunits.Time tau = 60
        "Time constant at nominal flow"
          annotation (Dialog(tab="Dynamics", group="Nominal condition"));

    protected
         parameter Modelica.SIunits.Volume V_nominal = m_flow_nominal*tau/rho_default
        "Volume of delay element";
        annotation (Diagram(graphics),
          Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
                  100}}), graphics={Ellipse(
                extent={{-100,98},{100,-102}},
                lineColor={0,0,0},
                fillPattern=FillPattern.Sphere,
                fillColor={170,213,255}), Text(
                extent={{-72,22},{68,-18}},
                lineColor={0,0,0},
                textString="tau=%tau")}),
      defaultComponentName="del",
          Documentation(info="<html>
<p>
This model approximates a transport delay using a first order differential equations.
</p>
<p>
The model consists of a mixing volume with two ports. The size of the
mixing volume is such that at the nominal mass flow rate 
<code>m_flow_nominal</code>,
the time constant of the volume is equal to the parameter <code>tau</code>.
</p>
<p>
The heat flux connector is optional, it need not be connnected.
</p>
</html>",
      revisions="<html>
<ul>
<li>
September 14, 2013, by Michael Wetter:<br/>
Renamed <code>V0</code> to <code>V_nominal</code> to use consistent notation.
</li>
<li>
September 24, 2008, by Michael Wetter:<br/>
Changed base class from <code>Modelica.Fluid</code> to <code>Buildings</code> library.
This was done to track the auxiliary species flow <code>mC_flow</code>.
</li>
<li>
September 4, 2008, by Michael Wetter:<br/>
Fixed bug in assignment of parameter <code>sta0</code>. 
The earlier implementation
required temperature to be a state, which is not always the case.
</li>
<li>
March 17, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
      end DelayFirstOrder;
    annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains components models for transport delays in
piping networks.
</p>
<p>
The model 
<a href=\"modelica://Buildings.Fluid.Delays.DelayFirstOrder\">
Buildings.Fluid.Delays.DelayFirstOrder</a>
approximates transport delays using a first order differential equation.
</p>
<p>
For a discretized model of a pipe or duct, see
<a href=\"modelica://Buildings.Fluid.FixedResistances.Pipe\">
Buildings.Fluid.FixedResistances.Pipe</a>.
</p>
</html>"));
    end Delays;

    package MixingVolumes "Package with mixing volumes"
      extends Modelica.Icons.VariantsPackage;

      model MixingVolume
      "Mixing volume with inlet and outlet ports (flow reversal is allowed)"
        extends Buildings.Fluid.MixingVolumes.BaseClasses.PartialMixingVolume;
    protected
        Modelica.Blocks.Sources.Constant masExc(k=0)
        "Block to set mass exchange in volume"
          annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
      equation
        connect(masExc.y, dynBal.mWat_flow) annotation (Line(
            points={{-59,60},{20,60},{20,12},{38,12}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(masExc.y, steBal.mWat_flow) annotation (Line(
            points={{-59,60},{-40,60},{-40,14},{-22,14}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(QSen_flow.y, steBal.Q_flow) annotation (Line(
            points={{-59,88},{-30,88},{-30,18},{-22,18}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(QSen_flow.y, dynBal.Q_flow) annotation (Line(
            points={{-59,88},{28,88},{28,16},{38,16}},
            color={0,0,127},
            smooth=Smooth.None));
        annotation (
      defaultComponentName="vol",
      Documentation(info="<html>
<p>
This model represents an instantaneously mixed volume. 
Potential and kinetic energy at the port are neglected,
and there is no pressure drop at the ports.
The volume can exchange heat through its <code>heatPort</code>.
</p>
<p>
The volume can be parameterized as a steady-state model or as
dynamic model.</p>
<p>
To increase the numerical robustness of the model, the parameter
<code>prescribedHeatFlowRate</code> can be set by the user. 
This parameter only has an effect if the model has exactly two fluid ports connected,
and if it is used as a steady-state model.
Use the following settings:
</p>
<ul>
<li>Set <code>prescribedHeatFlowRate=true</code> if there is a model connected to <code>heatPort</code>
that computes the heat flow rate <i>not</i> as a function of the temperature difference
between the medium and an ambient temperature. Examples include an ideal electrical heater,
a pump that rejects heat into the fluid stream, or a chiller that removes heat based on a performance curve.
</li>
<li>Set <code>prescribedHeatFlowRate=true</code> if the only means of heat flow at the <code>heatPort</code>
is computed as <i>K * (T-heatPort.T)</i>, for some temperature <i>T</i> and some conductance <i>K</i>,
which may itself be a function of temperature or mass flow rate.
</li>
</ul>

<h4>Implementation</h4>
<p>
If the model is operated in steady-state and has two fluid ports connected,
then the same energy and mass balance implementation is used as in
steady-state component models, i.e., the use of <code>actualStream</code>
is not used for the properties at the port.
</p>
<p>
The implementation of these balance equations is done in the instances
<code>dynBal</code> for the dynamic balance and <code>steBal</code>
for the steady-state balance. Both models use the same input variables:
</p>
<ul>
<li>
The variable <code>Q_flow</code> is used to add sensible <i>and</i> latent heat to the fluid.
For example, <code>Q_flow</code> participates in the steady-state energy balance<pre>
    port_b.h_outflow = inStream(port_a.h_outflow) + Q_flow * m_flowInv;
</pre>
where <code>m_flowInv</code> approximates the expression <code>1/m_flow</code>.
</li>
<li>
The variable <code>mXi_flow</code> is used to add a species mass flow rate to the fluid.
</li>
</ul>

<p>
For simple models that uses this model, see
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeaterCoolerPrescribed\">
Buildings.Fluid.HeatExchangers.HeaterCoolerPrescribed</a> and
<a href=\"modelica://Buildings.Fluid.MassExchangers.HumidifierPrescribed\">
Buildings.Fluid.MassExchangers.HumidifierPrescribed</a>.
</p>

</html>",       revisions="<html>
<ul>
February 11, 2014 by Michael Wetter:<br/>
Redesigned implementation of latent and sensible heat flow rates 
as port of the correction of issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/197\">#197</a>.
</li>
<li>
February 7, 2012 by Michael Wetter:<br/>
Revised base classes for conservation equations in <code>Buildings.Fluid.Interfaces</code>.
</li>
<li>
September 17, 2011 by Michael Wetter:<br/>
Removed instance <code>medium</code> as this is already used in <code>dynBal</code>.
Removing the base properties led to 30% faster computing time for a solar thermal system
that contains many fluid volumes. 
</li>
<li>
September 13, 2011 by Michael Wetter:<br/>
Changed in declaration of <code>medium</code> the parameter assignment
<code>preferredMediumStates=true</code> to
<code>preferredMediumStates= not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)</code>.
Otherwise, for a steady-state model, Dymola 2012 may differentiate the model to obtain <code>T</code>
as a state. See ticket Dynasim #13596.
</li>
<li>
July 26, 2011 by Michael Wetter:<br/>
Revised model to use new declarations from
<a href=\"Buildings.Fluid.Interfaces.LumpedVolumeDeclarations\">
Buildings.Fluid.Interfaces.LumpedVolumeDeclarations</a>.
</li>
<li>
July 14, 2011 by Michael Wetter:<br/>
Added start values for mass and internal energy of dynamic balance
model.
</li>
<li>
May 25, 2011 by Michael Wetter:<br/>
<ul>
<li>
Changed implementation of balance equation. The new implementation uses a different model if 
exactly two fluid ports are connected, and in addition, the model is used as a steady-state
component. For this model configuration, the same balance equations are used as were used
for steady-state component models, i.e., instead of <code>actualStream(...)</code>, the
<code>inStream(...)</code> formulation is used.
This changed required the introduction of a new parameter <code>m_flow_nominal</code> which
is used for smoothing in the steady-state balance equations of the model with two fluid ports.
</li>
<li>
Another revision was the removal of the parameter <code>use_HeatTransfer</code> as there is
no noticable overhead in always having the <code>heatPort</code> connector present.
</li>
</ul>
</li>
<li>
July 30, 2010 by Michael Wetter:<br/>
Added nominal value for <code>mC</code> to avoid wrong trajectory 
when concentration is around 1E-7.
See also <a href=\"https://trac.modelica.org/Modelica/ticket/393\">
https://trac.modelica.org/Modelica/ticket/393</a>.
</li>
<li>
February 7, 2010 by Michael Wetter:<br/>
Simplified model and its base classes by removing the port data
and the vessel area.
Eliminated the base class <code>PartialLumpedVessel</code>.
</li>
<li>
October 12, 2009 by Michael Wetter:<br/>
Changed base class to
<a href=\"modelica://Buildings.Fluid.MixingVolumes.BaseClasses.ClosedVolume\">
Buildings.Fluid.MixingVolumes.BaseClasses.ClosedVolume</a>.
</li>
</ul>
</html>"),Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
                  100}}), graphics={Ellipse(
                extent={{-100,98},{100,-102}},
                lineColor={0,0,0},
                fillPattern=FillPattern.Sphere,
                fillColor={170,213,255}), Text(
                extent={{-58,14},{58,-18}},
                lineColor={0,0,0},
                textString="V=%V"),         Text(
                extent={{-152,100},{148,140}},
                textString="%name",
                lineColor={0,0,255})}),
          Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
                  100,100}}), graphics));
      end MixingVolume;

      package BaseClasses
      "Package with base classes for Buildings.Fluid.MixingVolumes"
        extends Modelica.Icons.BasesPackage;

        partial model PartialMixingVolume
        "Partial mixing volume with inlet and outlet ports (flow reversal is allowed)"
          outer Modelica.Fluid.System system "System properties";
          extends Buildings.Fluid.Interfaces.LumpedVolumeDeclarations;
          parameter Modelica.SIunits.MassFlowRate m_flow_nominal(min=0)
          "Nominal mass flow rate"
            annotation(Dialog(group = "Nominal condition"));
          // Port definitions
          parameter Integer nPorts=0 "Number of ports"
            annotation(Evaluate=true, Dialog(connectorSizing=true, tab="General",group="Ports"));
          parameter Modelica.SIunits.MassFlowRate m_flow_small(min=0) = 1E-4*abs(m_flow_nominal)
          "Small mass flow rate for regularization of zero flow"
            annotation(Dialog(tab = "Advanced"));
          parameter Boolean homotopyInitialization = true
          "= true, use homotopy method"
            annotation(Evaluate=true, Dialog(tab="Advanced"));
          parameter Boolean allowFlowReversal = system.allowFlowReversal
          "= true to allow flow reversal in medium, false restricts to design direction (ports[1] -> ports[2]). Used only if model has two ports."
            annotation(Dialog(tab="Assumptions"), Evaluate=true);
          parameter Modelica.SIunits.Volume V "Volume";
          parameter Boolean prescribedHeatFlowRate=false
          "Set to true if the model has a prescribed heat flow at its heatPort"
           annotation(Evaluate=true, Dialog(tab="Assumptions",
              enable=use_HeatTransfer,
              group="Heat transfer"));
          Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b ports[nPorts](
              redeclare each package Medium = Medium)
          "Fluid inlets and outlets"
            annotation (Placement(transformation(extent={{-40,-10},{40,10}},
              origin={0,-100})));
          Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
          "Heat port for sensible heat input"
            annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
          Modelica.SIunits.Temperature T "Temperature of the fluid";
          Modelica.SIunits.Pressure p "Pressure of the fluid";
          Modelica.SIunits.MassFraction Xi[Medium.nXi]
          "Species concentration of the fluid";
          Medium.ExtraProperty C[Medium.nC](nominal=C_nominal)
          "Trace substance mixture content";
           // Models for the steady-state and dynamic energy balance.
      protected
          Buildings.Fluid.Interfaces.StaticTwoPortConservationEquation steBal(
            sensibleOnly = true,
            redeclare final package Medium=Medium,
            final m_flow_nominal = m_flow_nominal,
            final allowFlowReversal = allowFlowReversal,
            final m_flow_small = m_flow_small,
            final homotopyInitialization = homotopyInitialization) if
                useSteadyStateTwoPort
          "Model for steady-state balance if nPorts=2"
                annotation (Placement(transformation(extent={{-20,0},{0,20}})));
          Buildings.Fluid.Interfaces.ConservationEquation dynBal(
            redeclare final package Medium = Medium,
            final energyDynamics=energyDynamics,
            final massDynamics=massDynamics,
            final p_start=p_start,
            final T_start=T_start,
            final X_start=X_start,
            final C_start=C_start,
            final C_nominal=C_nominal,
            final fluidVolume = V,
            m(start=V*rho_start),
            U(start=V*rho_start*Medium.specificInternalEnergy(
                state_start)),
            nPorts=nPorts) if
                not useSteadyStateTwoPort "Model for dynamic energy balance"
            annotation (Placement(transformation(extent={{40,0},{60,20}})));

          // Density at medium default values, used to compute the size of control volumes
          parameter Modelica.SIunits.Density rho_default=Medium.density(
            state=state_default) "Density, used to compute fluid mass"
          annotation (Evaluate=true);
          // Density at start values, used to compute initial values and start guesses
          parameter Modelica.SIunits.Density rho_start=Medium.density(
           state=state_start) "Density, used to compute start and guess values"
          annotation (Evaluate=true);

          final parameter Medium.ThermodynamicState state_default = Medium.setState_pTX(
              T=Medium.T_default,
              p=Medium.p_default,
              X=Medium.X_default[1:Medium.nXi])
          "Medium state at default values";
          final parameter Medium.ThermodynamicState state_start = Medium.setState_pTX(
              T=T_start,
              p=p_start,
              X=X_start[1:Medium.nXi]) "Medium state at start values";
          final parameter Boolean useSteadyStateTwoPort=(nPorts == 2) and
              prescribedHeatFlowRate and (
              energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) and (
              massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) and (
              substanceDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) and (
              traceDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)
          "Flag, true if the model has two ports only and uses a steady state balance"
            annotation (Evaluate=true);
          // Outputs that are needed to assign the medium properties
          Modelica.Blocks.Interfaces.RealOutput hOut_internal(unit="J/kg")
          "Internal connector for leaving temperature of the component";
          Modelica.Blocks.Interfaces.RealOutput XiOut_internal[Medium.nXi](each unit="1")
          "Internal connector for leaving species concentration of the component";
          Modelica.Blocks.Interfaces.RealOutput COut_internal[Medium.nC](each unit="1")
          "Internal connector for leaving trace substances of the component";

          Modelica.Blocks.Sources.RealExpression QSen_flow(y=heatPort.Q_flow)
          "Block to set sensible heat input into volume"
            annotation (Placement(transformation(extent={{-60,78},{-40,98}})));
        equation
          ///////////////////////////////////////////////////////////////////////////
          // asserts
          if not allowFlowReversal then
            assert(ports[1].m_flow > -m_flow_small,
        "Model has flow reversal, but the parameter allowFlowReversal is set to false.
  m_flow_small    = "         + String(m_flow_small) + "
  ports[1].m_flow = "         + String(ports[1].m_flow) + "
");
          end if;
          // Actual definition of port variables.
          //
          // If the model computes the energy and mass balances as steady-state,
          // and if it has only two ports,
          // then we use the same base class as for all other steady state models.
          if useSteadyStateTwoPort then
          connect(steBal.port_a, ports[1]) annotation (Line(
              points={{-20,10},{-22,10},{-22,-60},{0,-60},{0,-100}},
              color={0,127,255},
              smooth=Smooth.None));

          connect(steBal.port_b, ports[2]) annotation (Line(
              points={{5.55112e-16,10},{8,10},{8,10},{8,-88},{0,-88},{0,-100}},
              color={0,127,255},
              smooth=Smooth.None));

            connect(hOut_internal,  steBal.hOut);
            connect(XiOut_internal, steBal.XiOut);
            connect(COut_internal,  steBal.COut);
          else
              connect(dynBal.ports, ports) annotation (Line(
              points={{50,-5.55112e-16},{50,-34},{2.22045e-15,-34},{2.22045e-15,-100}},
              color={0,127,255},
              smooth=Smooth.None));

            connect(hOut_internal,  dynBal.hOut);
            connect(XiOut_internal, dynBal.XiOut);
            connect(COut_internal,  dynBal.COut);
          end if;
          // Medium properties
          p = if nPorts > 0 then ports[1].p else p_start;
          T = Medium.temperature_phX(p=p, h=hOut_internal, X=cat(1,Xi,{1-sum(Xi)}));
          Xi = XiOut_internal;
          C = COut_internal;
          // Port properties
          heatPort.T = T;

          annotation (
        defaultComponentName="vol",
        Documentation(info="<html>
<p>
This is a partial model of an instantaneously mixed volume.
It is used as the base class for all fluid volumes of the package
<a href=\"modelica://Buildings.Fluid.MixingVolumes\">
Buildings.Fluid.MixingVolumes</a>.
</p>

<h4>Implementation</h4>
<p>
If the model is operated in steady-state and has two fluid ports connected,
then the same energy and mass balance implementation is used as in
steady-state component models, i.e., the use of <code>actualStream</code>
is not used for the properties at the port.
</p>
<p>
For simple models that uses this model, see
<a href=\"modelica://Buildings.Fluid.MixingVolumes\">
Buildings.Fluid.MixingVolumes</a>.
</p>
</html>",         revisions="<html>
<ul>
<li>
February 11, 2014 by Michael Wetter:<br/>
Removed <code>Q_flow</code> and added <code>QSen_flow</code>.
This was done to clarify what is sensible and total heat flow rate
as part of the correction of issue 
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/197\">#197</a>.
</li>
<li>
October 8, 2013 by Michael Wetter:<br/>
Removed propagation of <code>show_V_flow</code>
to instance <code>steBal</code> as it has no longer this parameter.
</li>
<li>
September 13, 2013 by Michael Wetter:<br/>
Renamed <code>rho_nominal</code> to <code>rho_start</code>
because this quantity is computed using start values and not
nominal values.
</li>
<li>
April 18, 2013 by Michael Wetter:<br/>
Removed the check of multiple connections to the same element
of a fluid port, as this check required the use of the deprecated
<code>cardinality</code> function.
</li>
<li>
February 7, 2012 by Michael Wetter:<br/>
Revised base classes for conservation equations in <code>Buildings.Fluid.Interfaces</code>.
</li>
<li>
September 17, 2011 by Michael Wetter:<br/>
Removed instance <code>medium</code> as this is already used in <code>dynBal</code>.
Removing the base properties led to 30% faster computing time for a solar thermal system
that contains many fluid volumes. 
</li>
<li>
September 13, 2011 by Michael Wetter:<br/>
Changed in declaration of <code>medium</code> the parameter assignment
<code>preferredMediumStates=true</code> to
<code>preferredMediumStates= not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)</code>.
Otherwise, for a steady-state model, Dymola 2012 may differentiate the model to obtain <code>T</code>
as a state. See ticket Dynasim #13596.
</li>
<li>
July 26, 2011 by Michael Wetter:<br/>
Revised model to use new declarations from
<a href=\"Buildings.Fluid.Interfaces.LumpedVolumeDeclarations\">
Buildings.Fluid.Interfaces.LumpedVolumeDeclarations</a>.
</li>
<li>
July 14, 2011 by Michael Wetter:<br/>
Added start values for mass and internal energy of dynamic balance
model.
</li>
<li>
May 25, 2011 by Michael Wetter:<br/>
<ul>
<li>
Changed implementation of balance equation. The new implementation uses a different model if 
exactly two fluid ports are connected, and in addition, the model is used as a steady-state
component. For this model configuration, the same balance equations are used as were used
for steady-state component models, i.e., instead of <code>actualStream(...)</code>, the
<code>inStream(...)</code> formulation is used.
This changed required the introduction of a new parameter <code>m_flow_nominal</code> which
is used for smoothing in the steady-state balance equations of the model with two fluid ports.
This implementation also simplifies the implementation of 
<a href=\"modelica://Buildings.Fluid.MixingVolumes.BaseClasses.PartialMixingVolumeWaterPort\">
Buildings.Fluid.MixingVolumes.BaseClasses.PartialMixingVolumeWaterPort</a>,
which now uses the same equations as this model.
</li>
<li>
Another revision was the removal of the parameter <code>use_HeatTransfer</code> as there is
no noticable overhead in always having the <code>heatPort</code> connector present.
</li>
</ul>
</li>
<li>
July 30, 2010 by Michael Wetter:<br/>
Added nominal value for <code>mC</code> to avoid wrong trajectory 
when concentration is around 1E-7.
See also <a href=\"https://trac.modelica.org/Modelica/ticket/393\">
https://trac.modelica.org/Modelica/ticket/393</a>.
</li>
<li>
February 7, 2010 by Michael Wetter:<br/>
Simplified model and its base classes by removing the port data
and the vessel area.
Eliminated the base class <code>PartialLumpedVessel</code>.
</li>
<li>
October 12, 2009 by Michael Wetter:<br/>
Changed base class to
<a href=\"modelica://Buildings.Fluid.MixingVolumes.BaseClasses.ClosedVolume\">
Buildings.Fluid.MixingVolumes.BaseClasses.ClosedVolume</a>.
</li>
</ul>
</html>"),  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
                    100}}), graphics={Ellipse(
                  extent={{-100,98},{100,-102}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.Sphere,
                  fillColor={170,213,255}), Text(
                  extent={{-58,14},{58,-18}},
                  lineColor={0,0,0},
                  textString="V=%V"),         Text(
                  extent={{-152,100},{148,140}},
                  textString="%name",
                  lineColor={0,0,255})}));
        end PartialMixingVolume;
      annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains base classes that are used to construct the models in
<a href=\"modelica://Buildings.Fluid.MixingVolumes\">Buildings.Fluid.MixingVolumes</a>.
</p>
</html>"));
      end BaseClasses;
    annotation (Documentation(info="<html>
<p>
This package contains models for completely mixed volumes.
</p>
<p>
For most situations, the model
<a href=\"modelica://Buildings.Fluid.MixingVolumes.MixingVolume\">
Buildings.Fluid.MixingVolumes.MixingVolume</a> should be used.
The other models are only of interest if water should be added to
or subtracted from the fluid volume, such as in a 
coil with water vapor condensation.
</p>
</html>"));
    end MixingVolumes;

    package Movers "Package with fan and pump models"
      extends Modelica.Icons.VariantsPackage;

      model FlowMachine_m_flow
      "Fan or pump with ideally controlled mass flow rate as input signal"
        extends Buildings.Fluid.Movers.BaseClasses.ControlledFlowMachine(
        final control_m_flow=true, preSou(m_flow_start=m_flow_start, m_flow_small=
                m_flow_small));
        Modelica.Blocks.Interfaces.RealInput m_flow_in(final unit="kg/s",
                                                       nominal=m_flow_nominal)
        "Prescribed mass flow rate"
          annotation (Placement(transformation(
              extent={{-20,-20},{20,20}},
              rotation=-90,
              origin={0,120}),   iconTransformation(
              extent={{-20,-20},{20,20}},
              rotation=-90,
              origin={-2,120})));

        // Classes used to implement the filtered speed
        parameter Boolean filteredSpeed=true
        "= true, if speed is filtered with a 2nd order CriticalDamping filter"
          annotation(Dialog(tab="Dynamics", group="Filtered speed"));
        parameter Modelica.SIunits.Time riseTime=30
        "Rise time of the filter (time to reach 99.6 % of the speed)"
          annotation(Dialog(tab="Dynamics", group="Filtered speed",enable=filteredSpeed));
        parameter Modelica.Blocks.Types.Init init=Modelica.Blocks.Types.Init.InitialOutput
        "Type of initialization (no init/steady state/initial state/initial output)"
          annotation(Dialog(tab="Dynamics", group="Filtered speed",enable=filteredSpeed));
        parameter Modelica.SIunits.MassFlowRate m_flow_start(min=0)=0
        "Initial value of mass flow rate"
          annotation(Dialog(tab="Dynamics", group="Filtered speed"));

        Modelica.Blocks.Interfaces.RealOutput m_flow_actual(final unit="kg/s",
                                                             nominal=m_flow_nominal)
        "Actual mass flow rate"
          annotation (Placement(transformation(extent={{40,60},{60,80}})));

    protected
        Modelica.Blocks.Continuous.Filter filter(
           order=2,
           f_cut=5/(2*Modelica.Constants.pi*riseTime),
           final init=init,
           final y_start=m_flow_start,
           u_nominal=m_flow_nominal,
           x(each stateSelect=StateSelect.always),
           u(final unit="kg/s"),
           y(final unit="kg/s"),
           final analogFilter=Modelica.Blocks.Types.AnalogFilter.CriticalDamping,
           final filterType=Modelica.Blocks.Types.FilterType.LowPass) if
              filteredSpeed
        "Second order filter to approximate transient of rotor, and to improve numerics"
          annotation (Placement(transformation(extent={{20,81},{34,95}})));

        Modelica.Blocks.Interfaces.RealOutput m_flow_filtered(final unit="kg/s") if
           filteredSpeed "Filtered mass flow rate"
          annotation (Placement(transformation(extent={{40,78},{60,98}}),
              iconTransformation(extent={{60,50},{80,70}})));

      equation
        if filteredSpeed then
          connect(m_flow_in, filter.u) annotation (Line(
            points={{1.11022e-15,120},{0,120},{0,88},{18.6,88}},
            color={0,0,127},
            smooth=Smooth.None));
          connect(filter.y, m_flow_actual) annotation (Line(
            points={{34.7,88},{38,88},{38,70},{50,70}},
            color={0,0,127},
            smooth=Smooth.None));
        else
          connect(m_flow_in, m_flow_actual) annotation (Line(
            points={{1.11022e-15,120},{0,120},{0,70},{50,70}},
            color={0,0,127},
            smooth=Smooth.None));
        end if;
          connect(filter.y, m_flow_filtered) annotation (Line(
            points={{34.7,88},{50,88}},
            color={0,0,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));
              connect(m_flow_actual, preSou.m_flow_in) annotation (Line(
            points={{50,70},{60,70},{60,40},{24,40},{24,8}},
            color={0,0,127},
            pattern=LinePattern.None,
            smooth=Smooth.None));

        annotation (defaultComponentName="fan",
        Documentation(
         info="<html>
<p>
This model describes a fan or pump with prescribed mass flow rate.
The efficiency of the device is computed based
on the efficiency curves that take as an argument
the actual volume flow rate divided by the maximum possible volume flow rate.
</p>
<p>
See the 
<a href=\"modelica://Buildings.Fluid.Movers.UsersGuide\">
User's Guide</a> for more information.
</p>
</html>",   revisions="<html>
<ul>
<li>
February 14, 2012, by Michael Wetter:<br/>
Added filter for start-up and shut-down transient.
</li>
<li>
May 25, 2011, by Michael Wetter:<br/>
Revised implementation of energy balance to avoid having to use conditionally removed models.
</li>
<li>
July 27, 2010, by Michael Wetter:<br/>
Redesigned model to fix bug in medium balance.
</li>
<li>March 24, 2010, by Michael Wetter:<br/>
Revised implementation to allow zero flow rate.
</li>
<li>October 1, 2009
    by Michael Wetter:<br/>
       Model added to the Buildings library.
</ul>
</html>"),Icon(graphics={Text(extent={{22,146},{114,102}},textString="m_flow_in")}),
          Diagram(graphics));
      end FlowMachine_m_flow;

      package BaseClasses
      "Package with base classes for Buildings.Fluid.Movers"
        extends Modelica.Icons.BasesPackage;

        package Characteristics "Functions for fan or pump characteristics"

          record efficiencyParameters "Record for efficiency parameters"
            extends Modelica.Icons.Record;
            parameter Real  r_V[:](each min=0, each max=1, each displayUnit="1")
            "Volumetric flow rate divided by nominal flow rate at user-selected operating points";
            parameter Real eta[size(r_V,1)](
               each min=0, each max=1, each displayUnit="1")
            "Fan or pump efficiency at these flow rates";
            annotation (Documentation(info="<html>
<p>
Data record for performance data that describe volume flow rate versus
efficiency.
The volume flow rate <code>r_V</code> must be increasing, i.e.,
<code>r_V[i] &lt; r_V[i+1]</code>.
Both vectors, <code>r_V</code> and <code>eta</code>
must have the same size.
</p>
</html>", revisions="<html>
<ul>
<li>
September 28, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
          end efficiencyParameters;

          function efficiency
          "Flow vs. efficiency characteristics for fan or pump"
            extends Modelica.Icons.Function;
            input
            Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters
              data "Efficiency performance data";
            input Real r_V(unit="1")
            "Volumetric flow rate divided by nominal flow rate";
            input Real d[:]
            "Derivatives at support points for spline interpolation";
            output Real eta(min=0, unit="1") "Efficiency";

        protected
            Integer n = size(data.r_V, 1) "Number of data points";
            Integer i "Integer to select data interval";
          algorithm
            if n == 1 then
              eta := data.eta[1];
            else
              i :=1;
              for j in 1:n-1 loop
                 if r_V > data.r_V[j] then
                   i := j;
                 end if;
              end for;
              // Extrapolate or interpolate the data
              eta:=Buildings.Utilities.Math.Functions.cubicHermiteLinearExtrapolation(
                          x=r_V,
                          x1=data.r_V[i],
                          x2=data.r_V[i + 1],
                          y1=data.eta[i],
                          y2=data.eta[i + 1],
                          y1d=d[i],
                          y2d=d[i+1]);
            end if;

            annotation(smoothOrder=1,
                        Documentation(info="<html>
<p>
This function computes the fan or pump efficiency for given normalized volume flow rate
and performance data. The efficiency is
</p>
<p align=\"center\" style=\"font-style:italic;\">
  &eta; = s(r<sub>V</sub>, d),
</p>
<p>
where
<i>&eta;</i> is the efficiency,
<i>r<sub>V</sub></i> is the normalized volume flow rate, and
<i>d</i> are performance data for fan or pump efficiency.
</p>
<h4>Implementation</h4>
<p>
The function <i>s(&middot;, &middot;)</i> is a cubic hermite spline.
If the data <i>d</i> define a monotone decreasing sequence, then 
<i>s(&middot;, d)</i> is a monotone decreasing function.
</p>
</html>",         revisions="<html>
<ul>
<li>
September 28, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),             smoothOrder=1);
          end efficiency;
          annotation (Documentation(info="<html>
<p>
This package implements performance curves for fans and pumps,
and records for parameter that can be used with these performance
curves.
</p>

The following performance curves are implemented:<br/>
<table summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
<tr>
<th>Independent variable</th>
<th>Dependent variable</th>
<th>Record for performance data</th>
<th>Function</th>
</tr>
<tr>
<td>Volume flow rate</td>
<td>Pressure</td>
<td><a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters\">
flowParameters</a></td>
<td><a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.pressure\">
pressure</a></td>
</tr>
<tr>
<td>Relative volumetric flow rate</td>
<td>Efficiency</td>
<td><a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters\">
efficiencyParameters</a></td>
<td><a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiency\">
efficiency</a></td>
</tr>
<tr>
<td>Volume flow rate</td>
<td>Power</td>
<td><a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.powerParameters\">
powerParameters</a></td>
<td><a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.power\">
power</a></td>
</tr>
</table>
</html>",
        revisions="<html>
<ul>
<li>
September 29, 2011, by Michael Wetter:<br/>
New implementation due to changes from polynomial to cubic hermite splines.
</li>
</ul>
</html>"));
        end Characteristics;

        model ControlledFlowMachine
        "Partial model for fan or pump with ideally controlled mass flow rate or head as input signal"
          extends Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine(
           preSou(final control_m_flow=control_m_flow));

          extends Buildings.Fluid.Movers.BaseClasses.PowerInterface(
             final use_powerCharacteristic = false,
             final rho_default = Medium.density(sta_default));

          import cha = Buildings.Fluid.Movers.BaseClasses.Characteristics;
        //  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
        //    "Nominal mass flow rate, used as flow rate if control_m_flow";
        //  parameter Modelica.SIunits.MassFlowRate m_flow_max = m_flow_nominal
        //    "Maximum mass flow rate (at zero head)";
          // what to control
          constant Boolean control_m_flow
          "= false to control head instead of m_flow"
            annotation(Evaluate=true);

          Real r_V(start=1)
          "Ratio V_flow/V_flow_max = V_flow/V_flow(dp=0, N=N_nominal)";

      protected
          final parameter Medium.AbsolutePressure p_a_default(displayUnit="Pa") = Medium.p_default
          "Nominal inlet pressure for predefined fan or pump characteristics";
          parameter Medium.ThermodynamicState sta_default = Medium.setState_pTX(
             T=Medium.T_default,
             p=Medium.p_default,
             X=Medium.X_default[1:Medium.nXi]) "Default medium state";

          Modelica.Blocks.Sources.RealExpression PToMedium_flow(y=Q_flow + WFlo) if  addPowerToMedium
          "Heat and work input into medium"
            annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
        initial equation
          V_flow_max=m_flow_nominal/rho_default;
        equation
          r_V = VMachine_flow/V_flow_max;
          etaHyd = cha.efficiency(data=hydraulicEfficiency, r_V=r_V, d=hydDer);
          etaMot = cha.efficiency(data=motorEfficiency,     r_V=r_V, d=motDer);
          dpMachine = -dp;
          VMachine_flow = -port_b.m_flow/rho_in;
          // To compute the electrical power, we set a lower bound for eta to avoid
          // a division by zero.
          P = WFlo / Buildings.Utilities.Math.Functions.smoothMax(x1=eta, x2=1E-5, deltaX=1E-6);

          connect(PToMedium_flow.y, prePow.Q_flow) annotation (Line(
              points={{-79,20},{-70,20}},
              color={0,0,127},
              smooth=Smooth.None));
          annotation (defaultComponentName="fan",
            Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
                    100}}), graphics={
                Line(
                  points={{0,70},{40,70}},
                  color={0,0,0},
                  smooth=Smooth.None),
                Ellipse(
                  visible=filteredSpeed,
                  extent={{-34,100},{32,40}},
                  lineColor={0,0,0},
                  fillColor={135,135,135},
                  fillPattern=FillPattern.Solid),
                Text(
                  visible=filteredSpeed,
                  extent={{-22,92},{20,46}},
                  lineColor={0,0,0},
                  fillColor={135,135,135},
                  fillPattern=FillPattern.Solid,
                  textString="M",
                  textStyle={TextStyle.Bold})}),
            Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{
                    100,100}})),
            Documentation(info="<html>
<p>
This model describes a fan or pump that takes as an input
the head or the mass flow rate.
</p>
</html>",     revisions="<html>
<ul>
<li>
October 8, 2013, by Michael Wetter:<br/>
Removed parameter <code>show_V_flow</code>.
</li>
<li>
September 13, 2013 by Michael Wetter:<br/>
Corrected computation of <code>sta_default</code> to use medium default
values instead of medium start values.
</li>
<li>
December 14, 2012 by Michael Wetter:<br/>
Renamed protected parameters for consistency with the naming conventions.
</li>
<li>
October 11, 2012, by Michael Wetter:<br/>
Added implementation of <code>WFlo = eta * P</code> with
guard against division by zero.
</li>
<li>
May 25, 2011, by Michael Wetter:<br/>
Revised implementation of energy balance to avoid having to use conditionally removed models.
</li>
<li>
November 11, 2010, by Michael Wetter:<br/>
Changed <code>V_flow_max=m_flow_nominal/rho_nominal;</code> to <code>V_flow_max=m_flow_max/rho_nominal;</code>
</li>
<li>
July 27, 2010, by Michael Wetter:<br/>
Redesigned model to fix bug in medium balance.
</li>
<li>
March 24, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
        end ControlledFlowMachine;

        partial model PartialFlowMachine
        "Partial model to interface fan or pump models with the medium"
          extends Buildings.Fluid.Interfaces.LumpedVolumeDeclarations;
          import Modelica.Constants;

          extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(show_T=false,
            port_a(
              h_outflow(start=h_outflow_start),
              final m_flow(min = if allowFlowReversal then -Constants.inf else 0)),
            port_b(
              h_outflow(start=h_outflow_start),
              p(start=p_start),
              final m_flow(max = if allowFlowReversal then +Constants.inf else 0)),
              final showDesignFlowDirection=false);

          Delays.DelayFirstOrder vol(
            redeclare package Medium = Medium,
            tau=tau,
            energyDynamics=if dynamicBalance then energyDynamics else Modelica.Fluid.Types.Dynamics.SteadyState,
            massDynamics=if dynamicBalance then massDynamics else Modelica.Fluid.Types.Dynamics.SteadyState,
            T_start=T_start,
            X_start=X_start,
            C_start=C_start,
            m_flow_nominal=m_flow_nominal,
            p_start=p_start,
            prescribedHeatFlowRate=true,
            allowFlowReversal=allowFlowReversal,
            nPorts=2) "Fluid volume for dynamic model"
            annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
           parameter Boolean dynamicBalance = true
          "Set to true to use a dynamic balance, which often leads to smaller systems of equations"
            annotation (Evaluate=true, Dialog(tab="Dynamics", group="Equations"));

          parameter Boolean addPowerToMedium=true
          "Set to false to avoid any power (=heat and flow work) being added to medium (may give simpler equations)";

          parameter Modelica.SIunits.Time tau=1
          "Time constant of fluid volume for nominal flow, used if dynamicBalance=true"
            annotation (Dialog(tab="Dynamics", group="Nominal condition", enable=dynamicBalance));

          // Models
          Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
          "Heat dissipation to environment"
            annotation (Placement(transformation(extent={{-70,-90},{-50,-70}}),
                iconTransformation(extent={{-10,-78},{10,-58}})));

      protected
          Modelica.SIunits.Density rho_in "Density of inflowing fluid";

          Buildings.Fluid.Movers.BaseClasses.IdealSource preSou(
          redeclare package Medium = Medium,
            allowFlowReversal=allowFlowReversal) "Pressure source"
            annotation (Placement(transformation(extent={{20,-10},{40,10}})));

          Buildings.HeatTransfer.Sources.PrescribedHeatFlow prePow if addPowerToMedium
          "Prescribed power (=heat and flow work) flow for dynamic model"
            annotation (Placement(transformation(extent={{-70,10},{-50,30}})));

          parameter Medium.ThermodynamicState sta_start=Medium.setState_pTX(
              T=T_start, p=p_start, X=X_start) "Medium state at start values";
          parameter Modelica.SIunits.SpecificEnthalpy h_outflow_start = Medium.specificEnthalpy(sta_start)
          "Start value for outflowing enthalpy";

        equation
          // For computing the density, we assume that the fan operates in the design flow direction.
          rho_in = Medium.density(
               Medium.setState_phX(port_a.p, inStream(port_a.h_outflow), inStream(port_a.Xi_outflow)));
          connect(prePow.port, vol.heatPort) annotation (Line(
              points={{-50,20},{-44,20},{-44,10},{-40,10}},
              color={191,0,0},
              smooth=Smooth.None));

          connect(vol.heatPort, heatPort) annotation (Line(
              points={{-40,10},{-40,-80},{-60,-80}},
              color={191,0,0},
              smooth=Smooth.None));
          connect(port_a, vol.ports[1]) annotation (Line(
              points={{-100,5.55112e-16},{-66,5.55112e-16},{-66,-5.55112e-16},{-32,
                  -5.55112e-16}},
              color={0,127,255},
              smooth=Smooth.None));
          connect(vol.ports[2], preSou.port_a) annotation (Line(
              points={{-28,-5.55112e-16},{-5,-5.55112e-16},{-5,6.10623e-16},{20,
                  6.10623e-16}},
              color={0,127,255},
              smooth=Smooth.None));
          connect(preSou.port_b, port_b) annotation (Line(
              points={{40,6.10623e-16},{70,6.10623e-16},{70,5.55112e-16},{100,
                  5.55112e-16}},
              color={0,127,255},
              smooth=Smooth.None));
          annotation (
            Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,100}}),
                            graphics={
                Line(
                  visible=not filteredSpeed,
                  points={{0,100},{0,40}},
                  color={0,0,0},
                  smooth=Smooth.None),
                Rectangle(
                  extent={{-100,16},{100,-14}},
                  lineColor={0,0,0},
                  fillColor={0,127,255},
                  fillPattern=FillPattern.HorizontalCylinder),
                Ellipse(
                  extent={{-58,50},{54,-58}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.Sphere,
                  fillColor={0,100,199}),
                Polygon(
                  points={{0,50},{0,-56},{54,2},{0,50}},
                  lineColor={0,0,0},
                  pattern=LinePattern.None,
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={255,255,255}),
                Ellipse(
                  extent={{4,14},{34,-16}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.Sphere,
                  visible=dynamicBalance,
                  fillColor={0,100,199}),
                Rectangle(
                  visible=filteredSpeed,
                  extent={{-34,40},{32,100}},
                  lineColor={0,0,0},
                  fillColor={135,135,135},
                  fillPattern=FillPattern.Solid),
                Ellipse(
                  visible=filteredSpeed,
                  extent={{-34,100},{32,40}},
                  lineColor={0,0,0},
                  fillColor={135,135,135},
                  fillPattern=FillPattern.Solid),
                Text(
                  visible=filteredSpeed,
                  extent={{-22,92},{20,46}},
                  lineColor={0,0,0},
                  fillColor={135,135,135},
                  fillPattern=FillPattern.Solid,
                  textString="M",
                  textStyle={TextStyle.Bold})}),
            Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
                    100}}),
                    graphics),
            Documentation(info="<html>
<p>This is the base model for fans and pumps.
It provides an interface
between the equations that compute head and power consumption,
and the implementation of the energy and pressure balance
of the fluid.
</p>
<p>
Depending on the value of
the parameter <code>dynamicBalance</code>, the fluid volume
is computed using a dynamic balance or a steady-state balance.
</p>
<p>
The parameter <code>addPowerToMedium</code> determines whether 
any power is added to the fluid. The default is <code>addPowerToMedium=true</code>,
and hence the outlet enthalpy is higher than the inlet enthalpy if the
flow device is operating.
The setting <code>addPowerToMedium=false</code> is physically incorrect
(since the flow work, the flow friction and the fan heat do not increase
the enthalpy of the medium), but this setting does in some cases lead to simpler equations
and more robust simulation, in particular if the mass flow is equal to zero.
</p>
</html>",     revisions="<html>
<ul>
<li>
May 25, 2011, by Michael Wetter:<br/>
Revised implementation of energy balance to avoid having to use conditionally removed models.
</li>
<li>
July 29, 2010, by Michael Wetter:<br/>
Reduced fan time constant from 10 to 1 second.
</li>
<li>
July 27, 2010, by Michael Wetter:<br/>
Redesigned model to fix bug in medium balance.
</li>
<li>March 24 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
        end PartialFlowMachine;

        model IdealSource
        "Base class for pressure and mass flow source with optional power input"
          extends Modelica.Fluid.Interfaces.PartialTwoPortTransport(show_T=false);

          // what to control
          parameter Boolean control_m_flow
          "= false to control dp instead of m_flow"
            annotation(Evaluate = true);
          Modelica.Blocks.Interfaces.RealInput m_flow_in if control_m_flow
          "Prescribed mass flow rate"
            annotation (Placement(transformation(
                extent={{-20,-20},{20,20}},
                rotation=-90,
                origin={-50,82}), iconTransformation(
                extent={{-20,-20},{20,20}},
                rotation=-90,
                origin={-60,80})));
          Modelica.Blocks.Interfaces.RealInput dp_in if not control_m_flow
          "Prescribed outlet pressure"
            annotation (Placement(transformation(
                extent={{-20,-20},{20,20}},
                rotation=-90,
                origin={50,82}), iconTransformation(
                extent={{-20,-20},{20,20}},
                rotation=-90,
                origin={60,80})));

      protected
          Modelica.Blocks.Interfaces.RealInput m_flow_internal
          "Needed to connect to conditional connector";
          Modelica.Blocks.Interfaces.RealInput dp_internal
          "Needed to connect to conditional connector";
        equation

          // Ideal control
          if control_m_flow then
            m_flow = m_flow_internal;
            dp_internal = 0;
          else
            dp = dp_internal;
            m_flow_internal = 0;
          end if;

          connect(dp_internal, dp_in);
          connect(m_flow_internal, m_flow_in);

          // Energy balance (no storage)
          port_a.h_outflow = inStream(port_b.h_outflow);
          port_b.h_outflow = inStream(port_a.h_outflow);

          annotation (Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
                    -100},{100,100}}), graphics={
                Rectangle(
                  extent={{-100,60},{100,-60}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={192,192,192}),
                Rectangle(
                  extent={{-100,50},{100,-48}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={0,127,255}),
                Text(
                  visible=not control_m_flow,
                  extent={{24,44},{80,24}},
                  lineColor={255,255,255},
                  textString="dp"),
                Text(
                  visible=control_m_flow,
                  extent={{-80,44},{-24,24}},
                  lineColor={255,255,255},
                  textString="m")}),
            Documentation(info="<html>
<p>
Model of a fictious pipe that is used as a base class
for a pressure source or to prescribe a mass flow rate.
</p>
<p>
Note that for fans and pumps with dynamic balance,
both the heat and the flow work are added to the volume of
air or water. This simplifies the equations compared to 
adding heat to the volume, and flow work to this model.
</p>
</html>",
        revisions="<html>
<ul>
<li>
October 8, 2013, by Michael Wetter:<br/>
Removed parameter <code>show_V_flow</code>.
</li>
<li>
May 25, 2011 by Michael Wetter:<br/>
Removed the option to add power to the medium, as this is dealt with in the volume
that is used in the mover model.
</li>
<li>
July 27, 2010 by Michael Wetter:<br/>
Redesigned model to fix bug in medium balance.
</li>
<li>
April 13, 2010 by Michael Wetter:<br/>
Made heat connector optional.
</li>
<li>
March 23, 2010 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),  Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{
                    100,100}}),
                            graphics));
        end IdealSource;

        partial model PowerInterface
        "Partial model to compute power draw and heat dissipation of fans and pumps"

          import Modelica.Constants;

          parameter Boolean use_powerCharacteristic = false
          "Use powerCharacteristic (vs. efficiencyCharacteristic)"
             annotation(Evaluate=true,Dialog(group="Characteristics"));

          parameter Boolean motorCooledByFluid = true
          "If true, then motor heat is added to fluid stream"
            annotation(Dialog(group="Characteristics"));
          parameter Boolean homotopyInitialization = true
          "= true, use homotopy method"
            annotation(Evaluate=true, Dialog(tab="Advanced"));

          parameter
          Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters
              motorEfficiency(r_V={1}, eta={0.7})
          "Normalized volume flow rate vs. efficiency"
            annotation(Placement(transformation(extent={{60,-40},{80,-20}})),
                       Dialog(group="Characteristics"),
                       enable = not use_powerCharacteristic);
          parameter
          Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters
              hydraulicEfficiency(r_V={1}, eta={0.7})
          "Normalized volume flow rate vs. efficiency"
            annotation(Placement(transformation(extent={{60,-80},{80,-60}})),
                       Dialog(group="Characteristics"),
                       enable = not use_powerCharacteristic);

          parameter Modelica.SIunits.Density rho_default
          "Fluid density at medium default state";

          Modelica.Blocks.Interfaces.RealOutput P(quantity="Modelica.SIunits.Power",
           unit="W") "Electrical power consumed"
          annotation (Placement(transformation(extent={{100,70},{120,90}},
                rotation=0)));

          Modelica.SIunits.Power WHyd
          "Hydraulic power input (converted to flow work and heat)";
          Modelica.SIunits.Power WFlo "Flow work";
          Modelica.SIunits.HeatFlowRate Q_flow
          "Heat input from fan or pump to medium";
          Real eta(min=0, max=1) "Global efficiency";
          Real etaHyd(min=0, max=1) "Hydraulic efficiency";
          Real etaMot(min=0, max=1) "Motor efficiency";

          Modelica.SIunits.Pressure dpMachine(displayUnit="Pa")
          "Pressure increase";
          Modelica.SIunits.VolumeFlowRate VMachine_flow "Volume flow rate";
      protected
          parameter Modelica.SIunits.VolumeFlowRate V_flow_max(fixed=false)
          "Maximum volume flow rate, used for smoothing";
          //Modelica.SIunits.HeatFlowRate QThe_flow "Heat input into the medium";
          parameter Modelica.SIunits.VolumeFlowRate delta_V_flow = 1E-3*V_flow_max
          "Factor used for setting heat input into medium to zero at very small flows";
          final parameter Real motDer[size(motorEfficiency.r_V, 1)](each fixed=false)
          "Coefficients for polynomial of pressure vs. flow rate"
            annotation (Evaluate=true);
          final parameter Real hydDer[size(hydraulicEfficiency.r_V,1)](each fixed=false)
          "Coefficients for polynomial of pressure vs. flow rate"
            annotation (Evaluate=true);

          Modelica.SIunits.HeatFlowRate QThe_flow
          "Heat input from fan or pump to medium";

        initial algorithm
         // Compute derivatives for cubic spline
         motDer :=
           if use_powerCharacteristic then
             zeros(size(motorEfficiency.r_V, 1))
           elseif ( size(motorEfficiency.r_V, 1) == 1)  then
               {0}
           else
              Buildings.Utilities.Math.Functions.splineDerivatives(
              x=motorEfficiency.r_V,
              y=motorEfficiency.eta,
              ensureMonotonicity=Buildings.Utilities.Math.Functions.isMonotonic(x=motorEfficiency.eta,
                                                                                strict=false));
          hydDer :=
             if use_powerCharacteristic then
               zeros(size(hydraulicEfficiency.r_V, 1))
             elseif ( size(hydraulicEfficiency.r_V, 1) == 1)  then
               {0}
             else
               Buildings.Utilities.Math.Functions.splineDerivatives(
                           x=hydraulicEfficiency.r_V,
                           y=hydraulicEfficiency.eta);
        equation
          eta = etaHyd * etaMot;
        //  WFlo = eta * P;
          // Flow work
          WFlo = dpMachine*VMachine_flow;
          // Hydraulic power (transmitted by shaft), etaHyd = WFlo/WHyd
          etaHyd * WHyd   = WFlo;
          // Heat input into medium
          QThe_flow +  WFlo = if motorCooledByFluid then P else WHyd;
          // At m_flow = 0, the solver may still obtain positive values for QThe_flow.
          // The next statement sets the heat input into the medium to zero for very small flow rates.
          if homotopyInitialization then
            Q_flow = homotopy(actual=Buildings.Utilities.Math.Functions.spliceFunction(pos=QThe_flow, neg=0,
                               x=noEvent(abs(VMachine_flow))-2*delta_V_flow, deltax=delta_V_flow),
                             simplified=0);
          else
            Q_flow = Buildings.Utilities.Math.Functions.spliceFunction(pos=QThe_flow, neg=0,
                               x=noEvent(abs(VMachine_flow))-2*delta_V_flow, deltax=delta_V_flow);
          end if;
          annotation (
            Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
                    100}}), graphics={
                Text(extent={{64,86},{114,72}},   textString="P",
                  lineColor={0,0,127})}),
            Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{
                    100,100}}),
                    graphics),
            Documentation(info="<html>
<p>This is an interface that implements the functions to compute the power draw and the
heat dissipation of fans and pumps. It is used by the model 
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface\">
Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface</a>.
</p>
<h4>Implementation</h4>
<p>
Models that extend this model need to provide an implementation of
<code>WFlo = eta * P</code>.
This equation is not implemented in this model to allow other models
to properly guard against division by zero.
</p>
</html>",     revisions="<html>
<ul>
<li>
September 17, 2013, by Michael Wetter:<br/>
Added missing <code>each</code> keyword in declaration of parameters
that are an array.
</li>
<li>
December 14, 2012 by Michael Wetter:<br/>
Renamed protected parameters for consistency with the naming conventions.
</li>
<li><i>October 11, 2012</i> by Michael Wetter:<br/>
    Removed <code>WFlo = eta * P</code> so that classes that use this partial model
    can properly implement the equation so it guards against division by zero.
</li>
<li><i>March 1, 2010</i>
    by Michael Wetter:<br/>
    Revised implementation to allow <code>N=0</code>.
<li><i>October 1, 2009</i>
    by Michael Wetter:<br/>
    Changed model so that it is based on total pressure in Pascals instead of the pump head in meters.
    This change is needed if the device is used with air as a medium. The original formulation in Modelica.Fluid
    converts head to pressure using the density medium.d. Therefore, for fans, head would be converted to pressure
    using the density of air. However, for fans, manufacturers typically publish the head in 
    millimeters water (mmH20). Therefore, to avoid confusion and to make this model applicable for any medium,
    the model has been changed to use total pressure in Pascals instead of head in meters.
</li>
<li><i>31 Oct 2005</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br/>
       Model added to the Fluid library</li>
</ul>
</html>"));
        end PowerInterface;
      annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains base classes that are used to construct the models in
<a href=\"modelica://Buildings.Fluid.Movers\">Buildings.Fluid.Movers</a>.
</p>
</html>"));
      end BaseClasses;
    annotation (preferredView="info", Documentation(info="<html>
This package contains components models for fans and pumps.
</html>"));
    end Movers;

    package Storage "Package with thermal energy storage models"
      extends Modelica.Icons.VariantsPackage;

      model ExpansionVessel "Pressure expansion vessel with fixed gas cushion"
       extends Buildings.Fluid.Interfaces.LumpedVolumeDeclarations;
       parameter Modelica.SIunits.Volume VTot
        "Total volume of vessel (water and gas side)";
       parameter Modelica.SIunits.Volume VGas0 = VTot/2 "Initial volume of gas";

      //////////////////////////////////////////////////////////////
        Modelica.Fluid.Interfaces.FluidPort_a port_a(
          redeclare package Medium = Medium) "Fluid port"
          annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));

        parameter Modelica.SIunits.Pressure pMax = 5E5
        "Maximum pressure before simulation stops with an error";

       Modelica.SIunits.Volume VLiq "Volume of liquid in the vessel";
        // We set m(start=(VTot-VGas0)*1000, stateSelect=StateSelect.always)
        // since the mass accumulated in the volume should be a state.
        // This often leads to smaller systems of equations.
    protected
        Buildings.Fluid.Interfaces.ConservationEquation vol(
          redeclare final package Medium = Medium,
          m(start=(VTot-VGas0)*1000, stateSelect=StateSelect.always),
          final nPorts=1,
          final energyDynamics=energyDynamics,
          final massDynamics=massDynamics,
          final p_start=p_start,
          final T_start=T_start,
          final X_start=X_start,
          final C_start=C_start,
          final C_nominal=C_nominal,
          final fluidVolume = VLiq)
        "Model for mass and energy balance of water in expansion vessel"
          annotation (Placement(transformation(extent={{-10,-20},{10,0}})));
        Modelica.Blocks.Sources.Constant heaInp(final k=0)
        "Block to set heat input into volume"
          annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

        Modelica.Blocks.Sources.Constant masExc(final k=0)
        "Block to set mass exchange in volume"
          annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
      equation
        assert(port_a.p < pMax, "Pressure exceeds maximum pressure.\n" +
             "You may need to increase VTot of the ExpansionVessel.");

        // Water content and pressure
        port_a.p * (VTot-VLiq) = p_start * VGas0;

        connect(heaInp.y, vol.Q_flow) annotation (Line(
            points={{-59,70},{-20,70},{-20,-4},{-12,-4}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(port_a, vol.ports[1]) annotation (Line(
            points={{5.55112e-16,-100},{5.55112e-16,-60},{6.66134e-16,-60},{
                6.66134e-16,-20}},
            color={0,127,255},
            smooth=Smooth.None));
        connect(masExc.y, vol.mWat_flow) annotation (Line(
            points={{-59,40},{-40,40},{-40,-8},{-12,-8}},
            color={0,0,127},
            smooth=Smooth.None));
         annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                  -100},{100,100}}), graphics={
              Ellipse(
                extent={{-96,-96},{96,96}},
                lineColor={0,0,0},
                fillColor={215,215,215},
                fillPattern=FillPattern.Solid),
              Ellipse(
                extent={{-40,-94},{40,96}},
                fillColor={0,0,127},
                fillPattern=FillPattern.Solid,
                pattern=LinePattern.None),
              Text(
                extent={{-148,98},{152,138}},
                textString="%name",
                lineColor={0,0,255})}),
      defaultComponentName="exp",
      Documentation(info="<html>
<p>
This is a model of a pressure expansion vessel. The vessel has a fixed total volume. 
A fraction of the volume is occupied by a fixed mass of gas, and the other fraction is occupied 
by the liquid that flows through the port.
The pressure <code>p</code> in the vessel is
</p>
<pre>
 VGas0 * p_start = (VTot-VLiquid) * p
</pre>
<p>
where <code>VGas0</code> is the initial volume occupied by the gas, 
<code>p_start</code> is the initial pressure,
<code>VTot</code> is the total volume of the vessel and
<code>VLiquid</code> is the amount of liquid in the vessel.
</p>
<p>
Optionally, a heat port can be activated by setting <code>use_HeatTransfer=true</code>.
This heat port connects directly to the liquid. The gas does not participate in the energy 
balance.
</p>
<p>
The expansion vessel needs to be used in closed loops that contain
water to set a reference pressure and, for liquids where the
density is modeled as a function of temperature, to allow for
the thermal expansion of the liquid.
</p>
<p>
Note that alternatively, the model
<a href=\"modelica://Buildings.Fluid.Sources.FixedBoundary\">
Buildings.Fluid.Sources.FixedBoundary</a> may be used to set 
a reference pressure. The main difference between these two models
is that in this model, there is an energy and mass balance for the volume.
In contrast, for
<a href=\"modelica://Buildings.Fluid.Sources.FixedBoundary\">
Buildings.Fluid.Sources.FixedBoundary</a>, 
any mass flow rate that flows out of the model will be at a user-specified temperature.
Therefore, <a href=\"modelica://Buildings.Fluid.Sources.FixedBoundary\">
Buildings.Fluid.Sources.FixedBoundary</a> leads to smaller systems
of equations, which may result in faster simulation.
</p>
</html>",       revisions="<html>
<ul>
<li>
August 1, 2013 by Michael Wetter:<br/>
Updated model to use new connector <code>mWat_flow</code>.
</li>
<li>
February 7, 2012 by Michael Wetter:<br/>
Revised due to changes in conservation equations in <code>Buildings.Fluid.Interfaces</code>.
</li>
<li>
September 16, 2011 by Michael Wetter:<br/>
Set <code>m(stateSelect=StateSelect.always)</code>, since
setting the <code>stateSelect</code> attribute leads to smaller systems of equations.
</li>
<li>
July 26, 2011 by Michael Wetter:<br/>
Revised model to use new declarations from
<a href=\"Buildings.Fluid.Interfaces.LumpedVolumeDeclarations\">
Buildings.Fluid.Interfaces.LumpedVolumeDeclarations</a>.
</li>
<li>
May 25, 2011 by Michael Wetter:<br/>
Revised model due to a change in the fluid volume model.
</li>
<li>
Nov. 4, 2009 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
                  100}}), graphics));
      end ExpansionVessel;
    annotation (preferredView="info", Documentation(info="<html>
This package contains thermal energy storage models.
</html>"));
    end Storage;

    package Interfaces "Package with interfaces for fluid models"
      extends Modelica.Icons.InterfacesPackage;

      partial model PartialTwoPortInterface
      "Partial model transporting fluid between two ports without storing mass or energy"
        import Modelica.Constants;
        extends Modelica.Fluid.Interfaces.PartialTwoPort(
          port_a(p(start=Medium.p_default,
                   nominal=Medium.p_default)),
          port_b(p(start=Medium.p_default,
                 nominal=Medium.p_default)));

        parameter Modelica.SIunits.MassFlowRate m_flow_nominal
        "Nominal mass flow rate"
          annotation(Dialog(group = "Nominal condition"));
        parameter Modelica.SIunits.MassFlowRate m_flow_small(min=0) = 1E-4*abs(m_flow_nominal)
        "Small mass flow rate for regularization of zero flow"
          annotation(Dialog(tab = "Advanced"));
        parameter Boolean homotopyInitialization = true
        "= true, use homotopy method"
          annotation(Evaluate=true, Dialog(tab="Advanced"));

        // Diagnostics
         parameter Boolean show_T = false
        "= true, if actual temperature at port is computed"
          annotation(Dialog(tab="Advanced",group="Diagnostics"));

        Modelica.SIunits.MassFlowRate m_flow(start=0) = port_a.m_flow
        "Mass flow rate from port_a to port_b (m_flow > 0 is design flow direction)";
        Modelica.SIunits.Pressure dp(start=0, displayUnit="Pa")
        "Pressure difference between port_a and port_b";

        Medium.ThermodynamicState sta_a=
            Medium.setState_phX(port_a.p,
                                noEvent(actualStream(port_a.h_outflow)),
                                noEvent(actualStream(port_a.Xi_outflow))) if
               show_T "Medium properties in port_a";

        Medium.ThermodynamicState sta_b=
            Medium.setState_phX(port_b.p,
                                noEvent(actualStream(port_b.h_outflow)),
                                noEvent(actualStream(port_b.Xi_outflow))) if
                show_T "Medium properties in port_b";
      equation
        dp = port_a.p - port_b.p;
        annotation (
          preferredView="info",
          Diagram(coordinateSystem(
              preserveAspectRatio=false,
              extent={{-100,-100},{100,100}},
              grid={1,1})),
          Documentation(info="<html>
<p>
This component defines the interface for models that 
transports a fluid between two ports. It is similar to 
<a href=\"Modelica://Modelica.Fluid.Interfaces.PartialTwoPortTransport\">
Modelica.Fluid.Interfaces.PartialTwoPortTransport</a>, but it does not 
include the species balance
</p> 
<pre>
  port_b.Xi_outflow = inStream(port_a.Xi_outflow);
</pre>
<p>
Thus, it can be used as a base class for a heat <i>and</i> mass transfer component
</p>
<p>
The model is used by other models in this package that add heat transfer,
mass transfer and pressure drop equations. See for example
<a href=\"modelica://Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger\">
Buildings.Fluid.Interfaces.StaticTwoPortHeatMassExchanger</a>.
</p>
</html>",       revisions="<html>
<ul>
<li>
November 10, 2013 by Michael Wetter:<br/>
In the computation of <code>sta_a</code> and <code>sta_b</code>,
removed the branch that uses the homotopy operator.
The rational is that these variables are conditionally enables (because
of <code>... if show_T</code>. Therefore, the Modelica Language Specification
does not allow for these variables to be used in any equation. Hence,
the use of the homotopy operator is not needed here.
</li>
<li>
October 10, 2013 by Michael Wetter:<br/>
Added <code>noEvent</code> to the computation of the states at the port.
This is correct, because the states are only used for reporting, but not
to compute any other variable. 
Use of the states to compute other variables would violate the Modelica 
language, as conditionally removed variables must not be used in any equation.
</li>
<li>
October 8, 2013 by Michael Wetter:<br/>
Removed the computation of <code>V_flow</code> and removed the parameter
<code>show_V_flow</code>.
The reason is that the computation of <code>V_flow</code> required
the use of <code>sta_a</code> (to compute the density), 
but <code>sta_a</code> is also a variable that is conditionally
enabled. However, this was not correct Modelica syntax as conditional variables 
can only be used in a <code>connect</code>
statement, not in an assignment. Dymola 2014 FD01 beta3 is checking
for this incorrect syntax. Hence, <code>V_flow</code> was removed as its 
conditional implementation would require a rather cumbersome implementation
that uses a new connector that carries the state of the medium.
</li>
<li>
April 26, 2013 by Marco Bonvini:<br/>
Moved the definition of <code>dp</code> because it causes some problem with PyFMI.
</li>
<li>
March 27, 2012 by Michael Wetter:<br/>
Changed condition to remove <code>sta_a</code> to also
compute the state at the inlet port if <code>show_V_flow=true</code>. 
The previous implementation resulted in a translation error
if <code>show_V_flow=true</code>, but worked correctly otherwise
because the erroneous function call is removed if  <code>show_V_flow=false</code>.
</li>
<li>
March 27, 2011 by Michael Wetter:<br/>
Added <code>homotopy</code> operator.
</li>
<li>
March 21, 2010 by Michael Wetter:<br/>
Changed pressure start value from <code>system.p_start</code>
to <code>Medium.p_default</code> since HVAC models may have water and 
air, which are typically at different pressures.
</li>
<li>
September 19, 2008 by Michael Wetter:<br/>
Added equations for the mass balance of extra species flow,
i.e., <code>C</code> and <code>mC_flow</code>.
</li>
<li>
March 11, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
      end PartialTwoPortInterface;

      model ConservationEquation "Lumped volume with mass and energy balance"

      //  outer Modelica.Fluid.System system "System properties";
        extends Buildings.Fluid.Interfaces.LumpedVolumeDeclarations;
        // Port definitions
        parameter Integer nPorts=0 "Number of ports"
          annotation(Evaluate=true, Dialog(connectorSizing=true, tab="General",group="Ports"));
        Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b ports[nPorts](
            redeclare each package Medium = Medium) "Fluid inlets and outlets"
          annotation (Placement(transformation(extent={{-40,-10},{40,10}},
            origin={0,-100})));

        // Set nominal attributes where literal values can be used.
        Medium.BaseProperties medium(
          preferredMediumStates= not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState),
          p(start=p_start,
            nominal=Medium.p_default,
            stateSelect=if not (massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)
                           then StateSelect.prefer else StateSelect.default),
          h(start=hStart),
          T(start=T_start,
            nominal=Medium.T_default,
            stateSelect=if (not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState))
                           then StateSelect.prefer else StateSelect.default),
          Xi(start=X_start[1:Medium.nXi],
             nominal=Medium.X_default[1:Medium.nXi],
             each stateSelect=if (not (substanceDynamics == Modelica.Fluid.Types.Dynamics.SteadyState))
                           then StateSelect.prefer else StateSelect.default),
          d(start=rho_nominal)) "Medium properties";

        Modelica.SIunits.Energy U "Internal energy of fluid";
        Modelica.SIunits.Mass m "Mass of fluid";
        Modelica.SIunits.Mass[Medium.nXi] mXi
        "Masses of independent components in the fluid";
        Modelica.SIunits.Mass[Medium.nC] mC
        "Masses of trace substances in the fluid";
        // C need to be added here because unlike for Xi, which has medium.Xi,
        // there is no variable medium.C
        Medium.ExtraProperty C[Medium.nC](nominal=C_nominal)
        "Trace substance mixture content";

        Modelica.SIunits.MassFlowRate mb_flow "Mass flows across boundaries";
        Modelica.SIunits.MassFlowRate[Medium.nXi] mbXi_flow
        "Substance mass flows across boundaries";
        Medium.ExtraPropertyFlowRate[Medium.nC] mbC_flow
        "Trace substance mass flows across boundaries";
        Modelica.SIunits.EnthalpyFlowRate Hb_flow
        "Enthalpy flow across boundaries or energy source/sink";

        // Inputs that need to be defined by an extending class
        input Modelica.SIunits.Volume fluidVolume "Volume";

        Modelica.Blocks.Interfaces.RealInput Q_flow(unit="W")
        "Sensible plus latent heat flow rate transfered into the medium"
          annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
        Modelica.Blocks.Interfaces.RealInput mWat_flow(unit="kg/s")
        "Moisture mass flow rate added to the medium"
          annotation (Placement(transformation(extent={{-140,0},{-100,40}})));

        // Outputs that are needed in models that extend this model
        Modelica.Blocks.Interfaces.RealOutput hOut(unit="J/kg",
                                                   start=hStart)
        "Leaving enthalpy of the component"
           annotation (Placement(transformation(extent={{-10,-10},{10,10}},
              rotation=90,
              origin={-50,110})));
        Modelica.Blocks.Interfaces.RealOutput XiOut[Medium.nXi](each unit="1",
                                                                each min=0,
                                                                each max=1)
        "Leaving species concentration of the component"
          annotation (Placement(transformation(extent={{-10,-10},{10,10}},
              rotation=90,
              origin={0,110})));
        Modelica.Blocks.Interfaces.RealOutput COut[Medium.nC](each min=0)
        "Leaving trace substances of the component"
          annotation (Placement(transformation(extent={{-10,-10},{10,10}},
              rotation=90,
              origin={50,110})));
    protected
        parameter Boolean initialize_p = not Medium.singleState
        "= true to set up initial equations for pressure";

        Medium.EnthalpyFlowRate ports_H_flow[nPorts];
        Modelica.SIunits.MassFlowRate ports_mXi_flow[nPorts,Medium.nXi];
        Medium.ExtraPropertyFlowRate ports_mC_flow[nPorts,Medium.nC];

        parameter Modelica.SIunits.Density rho_nominal=Medium.density(
         Medium.setState_pTX(
           T=T_start,
           p=p_start,
           X=X_start[1:Medium.nXi])) "Density, used to compute fluid mass"
        annotation (Evaluate=true);

        // Parameter that is used to construct the vector mXi_flow
        final parameter Real s[Medium.nXi] = {if Modelica.Utilities.Strings.isEqual(string1=Medium.substanceNames[i],
                                                  string2="Water",
                                                  caseSensitive=false)
                                                  then 1 else 0 for i in 1:Medium.nXi}
        "Vector with zero everywhere except where species is";
        parameter Modelica.SIunits.SpecificEnthalpy hStart=
          Medium.specificEnthalpy_pTX(p_start, T_start, X_start)
        "Start value for specific enthalpy";
      initial equation
        // Assert that the substance with name 'water' has been found.
        assert(Medium.nXi == 0 or abs(sum(s)-1) < 1e-5,
            "If Medium.nXi > 1, then substance 'water' must be present for one component.'"
               + Medium.mediumName + "'.\n"
               + "Check medium model.");

        // Make sure that if energyDynamics is SteadyState, then
        // massDynamics is also SteadyState.
        // Otherwise, the system of ordinary differential equations may be inconsistent.
        if energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then
          assert(massDynamics == energyDynamics, "
         If 'massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState', then it is 
         required that 'energyDynamics==Modelica.Fluid.Types.Dynamics.SteadyState'.
         Otherwise, the system of equations may not be consistent.
         You need to select other parameter values.");
        end if;

        // initialization of balances
        if energyDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial then
            medium.T = T_start;
        else
          if energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial then
              der(medium.T) = 0;
          end if;
        end if;

        if massDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial then
          if initialize_p then
            medium.p = p_start;
          end if;
        else
          if massDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial then
            if initialize_p then
              der(medium.p) = 0;
            end if;
          end if;
        end if;

        if substanceDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial then
          medium.Xi = X_start[1:Medium.nXi];
        else
          if substanceDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial then
            der(medium.Xi) = zeros(Medium.nXi);
          end if;
        end if;

        if traceDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial then
          C = C_start[1:Medium.nC];
        else
          if traceDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial then
            der(C) = zeros(Medium.nC);
          end if;
        end if;

      equation
        // Total quantities
        m = fluidVolume*medium.d;
        mXi = m*medium.Xi;
        U = m*medium.u;
        mC = m*C;

        hOut = medium.h;
        XiOut = medium.Xi;
        COut = C;

        for i in 1:nPorts loop
          ports_H_flow[i]     = ports[i].m_flow * actualStream(ports[i].h_outflow)
          "Enthalpy flow";
          ports_mXi_flow[i,:] = ports[i].m_flow * actualStream(ports[i].Xi_outflow)
          "Component mass flow";
          ports_mC_flow[i,:]  = ports[i].m_flow * actualStream(ports[i].C_outflow)
          "Trace substance mass flow";
        end for;

        for i in 1:Medium.nXi loop
          mbXi_flow[i] = sum(ports_mXi_flow[:,i]);
        end for;

        for i in 1:Medium.nC loop
          mbC_flow[i]  = sum(ports_mC_flow[:,i]);
        end for;

        mb_flow = sum(ports.m_flow);
        Hb_flow = sum(ports_H_flow);

        // Energy and mass balances
        if energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then
          0 = Hb_flow + Q_flow;
        else
          der(U) = Hb_flow + Q_flow;
        end if;

        if massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then
          0 = mb_flow + mWat_flow;
        else
          der(m) = mb_flow + mWat_flow;
        end if;

        if substanceDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then
          zeros(Medium.nXi) = mbXi_flow + mWat_flow * s;
        else
          der(mXi) = mbXi_flow + mWat_flow * s;
        end if;

        if traceDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then
          zeros(Medium.nC)  = mbC_flow;
        else
          der(mC)  = mbC_flow;
        end if;

        // Properties of outgoing flows
        for i in 1:nPorts loop
            ports[i].p          = medium.p;
            ports[i].h_outflow  = medium.h;
            ports[i].Xi_outflow = medium.Xi;
            ports[i].C_outflow  = C;
        end for;

        annotation (
          Documentation(info="<html>
<p>
Basic model for an ideally mixed fluid volume with the ability to store mass and energy.
It implements a dynamic or a steady-state conservation equation for energy and mass fractions.
The model has zero pressure drop between its ports.
</p>
<h4>Implementation</h4>
<p>
When extending or instantiating this model, the input 
<code>fluidVolume</code>, which is the actual volume occupied by the fluid,
needs to be assigned.
For most components, this can be set to a parameter. However, for components such as 
expansion vessels, the fluid volume can change in time.
</p>
Input connectors of the model are
<ul>
<li>
<code>Q_flow</code>, which is the sensible plus latent heat flow rate added to the medium, and
</li>
<li>
<code>mWat_flow</code>, which is the moisture mass flow rate added to the medium.
</li>
</ul>
<p>
The model can be used as a dynamic model or as a steady-state model.
However, for a steady-state model with exactly two fluid ports connected, 
the model
<a href=\"modelica://Buildings.Fluid.Interfaces.StaticTwoPortConservationEquation\">
Buildings.Fluid.Interfaces.StaticTwoPortConservationEquation</a>
provides a more efficient implementation.
</p>
<p>
For models that instantiates this model, see
<a href=\"modelica://Buildings.Fluid.MixingVolumes.MixingVolume\">
Buildings.Fluid.MixingVolumes.MixingVolume</a> and
<a href=\"modelica://Buildings.Fluid.Storage.ExpansionVessel\">
Buildings.Fluid.Storage.ExpansionVessel</a>.
</p>
</html>",       revisions="<html>
<ul>
<li>
February 11, 2014 by Michael Wetter:<br/>
Improved documentation for <code>Q_flow</code> input.
</li>
<li>
September 17, 2013 by Michael Wetter:<br/>
Added start value for <code>hOut</code>.
</li>
<li>September 10, 2013 by Michael Wetter:<br/>
Removed unrequired parameter <code>i_w</code>.<br/>
Corrected the syntax error
<code>Medium.ExtraProperty C[Medium.nC](each nominal=C_nominal)</code>
to
<code>Medium.ExtraProperty C[Medium.nC](nominal=C_nominal)</code>
because <code>C_nominal</code> is a vector. 
This syntax error caused a compilation error in OpenModelica.
</li>
<li>
July 30, 2013 by Michael Wetter:<br/>
Changed connector <code>mXi_flow[Medium.nXi]</code>
to a scalar input connector <code>mWat_flow</code>.
The reason is that <code>mXi_flow</code> does not allow
to compute the other components in <code>mX_flow</code> and
therefore leads to an ambiguous use of the model.
By only requesting <code>mWat_flow</code>, the mass balance
and species balance can be implemented correctly.
</li>
<li>
March 27, 2013 by Michael Wetter:<br/>
Removed wrong unit attribute of <code>COut</code>,
and added min and max attributes for <code>XiOut</code>.
</li>
<li>
July 31, 2011 by Michael Wetter:<br/>
Added test to stop model translation if the setting for
<code>energyBalance</code> and <code>massBalance</code>
can lead to inconsistent equations.
</li>
<li>
July 26, 2011 by Michael Wetter:<br/>
Removed the option to use <code>h_start</code>, as this
is not needed for building simulation. 
Also removed the reference to <code>Modelica.Fluid.System</code>.
Moved parameters and medium to 
<a href=\"Buildings.Fluid.Interfaces.LumpedVolumeDeclarations\">
Buildings.Fluid.Interfaces.LumpedVolumeDeclarations</a>.
<li>
July 14, 2011 by Michael Wetter:<br/>
Added start value for medium density.
</li>
<li>
March 29, 2011 by Michael Wetter:<br/>
Changed default value for <code>substanceDynamics</code> and
<code>traceDynamics</code> from <code>energyDynamics</code>
to <code>massDynamics</code>.
</li>
<li>
September 28, 2010 by Michael Wetter:<br/>
Changed array index for nominal value of <code>Xi</code>.
<li>
September 13, 2010 by Michael Wetter:<br/>
Set nominal attributes for medium based on default medium values.
</li>
<li>
July 30, 2010 by Michael Wetter:<br/>
Added parameter <code>C_nominal</code> which is used as the nominal attribute for <code>C</code>.
Without this value, the ODE solver gives wrong results for concentrations around 1E-7.
</li>
<li>
March 21, 2010 by Michael Wetter:<br/>
Changed pressure start value from <code>system.p_start</code>
to <code>Medium.p_default</code> since HVAC models may have water and 
air, which are typically at different pressures.
</li>
<li><i>February 6, 2010</i> by Michael Wetter:<br/>
Added to <code>Medium.BaseProperties</code> the initialization 
<code>X(start=X_start[1:Medium.nX])</code>. Previously, the initialization
was only done for <code>Xi</code> but not for <code>X</code>, which caused the
medium to be initialized to <code>reference_X</code>, ignoring the value of <code>X_start</code>.
</li>
<li><i>October 12, 2009</i> by Michael Wetter:<br/>
Implemented first version in <code>Buildings</code> library, based on model from
<code>Modelica.Fluid 1.0</code>.
</li>
</ul>
</html>"),Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{
                  100,100}}),
                  graphics),
          Icon(graphics={            Rectangle(
                extent={{-100,100},{100,-100}},
                fillColor={135,135,135},
                fillPattern=FillPattern.Solid,
                pattern=LinePattern.None),
              Text(
                extent={{-89,17},{-54,34}},
                lineColor={0,0,127},
                textString="mWat_flow"),
              Text(
                extent={{-89,52},{-54,69}},
                lineColor={0,0,127},
                textString="Q_flow"),
              Line(points={{-56,-73},{81,-73}}, color={255,255,255}),
              Line(points={{-42,55},{-42,-84}}, color={255,255,255}),
              Polygon(
                points={{-42,67},{-50,45},{-34,45},{-42,67}},
                lineColor={255,255,255},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Polygon(
                points={{87,-73},{65,-65},{65,-81},{87,-73}},
                lineColor={255,255,255},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Line(
                points={{-42,-28},{-6,-28},{18,4},{40,12},{66,14}},
                color={255,255,255},
                smooth=Smooth.Bezier),
              Text(
                extent={{-155,-120},{145,-160}},
                lineColor={0,0,255},
                textString="%name")}));
      end ConservationEquation;

      model StaticTwoPortConservationEquation
      "Partial model for static energy and mass conservation equations"
        extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
        showDesignFlowDirection = false);

        constant Boolean sensibleOnly "Set to true if sensible exchange only";

        Modelica.Blocks.Interfaces.RealInput Q_flow(unit="W")
        "Sensible plus latent heat flow rate transfered into the medium"
          annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
        Modelica.Blocks.Interfaces.RealInput mWat_flow(unit="kg/s")
        "Moisture mass flow rate added to the medium"
          annotation (Placement(transformation(extent={{-140,20},{-100,60}})));

        // Outputs that are needed in models that extend this model
        Modelica.Blocks.Interfaces.RealOutput hOut(unit="J/kg",
                                                   start=Medium.specificEnthalpy_pTX(
                                                           p=Medium.p_default,
                                                           T=Medium.T_default,
                                                           X=Medium.X_default))
        "Leaving temperature of the component"
          annotation (Placement(transformation(extent={{-10,-10},{10,10}},
              rotation=90,
              origin={-50,110}), iconTransformation(
              extent={{-10,-10},{10,10}},
              rotation=90,
              origin={-50,110})));

        Modelica.Blocks.Interfaces.RealOutput XiOut[Medium.nXi](each unit="1",
                                                                each min=0,
                                                                each max=1)
        "Leaving species concentration of the component"
          annotation (Placement(transformation(extent={{-10,-10},{10,10}},
              rotation=90,
              origin={0,110})));
        Modelica.Blocks.Interfaces.RealOutput COut[Medium.nC](each min=0)
        "Leaving trace substances of the component"
          annotation (Placement(transformation(extent={{-10,-10},{10,10}},
              rotation=90,
              origin={50,110})));

        constant Boolean use_safeDivision=true
        "Set to true to improve numerical robustness";
    protected
        Real m_flowInv(unit="s/kg") "Regularization of 1/m_flow";

        Modelica.SIunits.MassFlowRate mXi_flow[Medium.nXi]
        "Mass flow rates of independent substances added to the medium";

        // Parameters that is used to construct the vector mXi_flow
        final parameter Real s[Medium.nXi] = {if Modelica.Utilities.Strings.isEqual(string1=Medium.substanceNames[i],
                                                  string2="Water",
                                                  caseSensitive=false)
                                                  then 1 else 0 for i in 1:Medium.nXi}
        "Vector with zero everywhere except where species is";

      initial equation
        // Assert that the substance with name 'water' has been found.
        assert(Medium.nXi == 0 or abs(sum(s)-1) < 1e-5,
            "If Medium.nXi > 1, then substance 'water' must be present for one component.'"
               + Medium.mediumName + "'.\n"
               + "Check medium model.");

      equation
       // Species flow rate from connector mWat_flow
       mXi_flow = mWat_flow * s;
        // Regularization of m_flow around the origin to avoid a division by zero
       if use_safeDivision then
          m_flowInv = Buildings.Utilities.Math.Functions.inverseXRegularized(x=port_a.m_flow, delta=m_flow_small/1E3);
       else
           m_flowInv = 0; // m_flowInv is not used if use_safeDivision = false.
       end if;

       if allowFlowReversal then
         // Formulate hOut using spliceFunction. This avoids an event iteration.
         // The introduced error is small because deltax=m_flow_small/1e3
         hOut = Buildings.Utilities.Math.Functions.spliceFunction(pos=port_b.h_outflow,
                                                                  neg=port_a.h_outflow,
                                                                  x=port_a.m_flow,
                                                                  deltax=m_flow_small/1E3);
         XiOut = Buildings.Utilities.Math.Functions.spliceFunction(pos=port_b.Xi_outflow,
                                                                  neg=port_a.Xi_outflow,
                                                                  x=port_a.m_flow,
                                                                  deltax=m_flow_small/1E3);
         COut = Buildings.Utilities.Math.Functions.spliceFunction(pos=port_b.C_outflow,
                                                                  neg=port_a.C_outflow,
                                                                  x=port_a.m_flow,
                                                                  deltax=m_flow_small/1E3);
       else
         hOut =  port_b.h_outflow;
         XiOut = port_b.Xi_outflow;
         COut =  port_b.C_outflow;
       end if;

        //////////////////////////////////////////////////////////////////////////////////////////
        // Energy balance and mass balance
        if sensibleOnly then
          // Mass balance
          port_a.m_flow = -port_b.m_flow;
          // Energy balance
          if use_safeDivision then
            port_b.h_outflow = inStream(port_a.h_outflow) + Q_flow * m_flowInv;
            port_a.h_outflow = inStream(port_b.h_outflow) - Q_flow * m_flowInv;
          else
            port_a.m_flow * (inStream(port_a.h_outflow) - port_b.h_outflow) = -Q_flow;
            port_a.m_flow * (inStream(port_b.h_outflow) - port_a.h_outflow) = +Q_flow;
          end if;
          // Transport of species
          port_a.Xi_outflow = inStream(port_b.Xi_outflow);
          port_b.Xi_outflow = inStream(port_a.Xi_outflow);
          // Transport of trace substances
          port_a.C_outflow = inStream(port_b.C_outflow);
          port_b.C_outflow = inStream(port_a.C_outflow);
        else
          // Mass balance (no storage)
          port_a.m_flow + port_b.m_flow = -mWat_flow;
          // Energy balance.
          // This equation is approximate since m_flow = port_a.m_flow is used for the mass flow rate
          // at both ports. Since mWat_flow << m_flow, the error is small.
          if use_safeDivision then
            port_b.h_outflow = inStream(port_a.h_outflow) + Q_flow * m_flowInv;
            port_a.h_outflow = inStream(port_b.h_outflow) - Q_flow * m_flowInv;
            // Transport of species
            port_b.Xi_outflow = inStream(port_a.Xi_outflow) + mXi_flow * m_flowInv;
            port_a.Xi_outflow = inStream(port_b.Xi_outflow) - mXi_flow * m_flowInv;
           else
            port_a.m_flow * (inStream(port_a.h_outflow) - port_b.h_outflow) = -Q_flow;
            port_a.m_flow * (inStream(port_b.h_outflow) - port_a.h_outflow) = +Q_flow;
            // Transport of species
            port_a.m_flow * (inStream(port_a.Xi_outflow) - port_b.Xi_outflow) = -mXi_flow;
            port_a.m_flow * (inStream(port_b.Xi_outflow) - port_a.Xi_outflow) = +mXi_flow;
           end if;

          // Transport of trace substances
         port_a.m_flow*port_a.C_outflow = -port_b.m_flow*inStream(port_b.C_outflow);
         port_b.m_flow*port_b.C_outflow = -port_a.m_flow*inStream(port_a.C_outflow);

        end if; // sensibleOnly

        //////////////////////////////////////////////////////////////////////////////////////////
        // No pressure drop in this model
        port_a.p = port_b.p;

        annotation (
          preferredView="info",
          Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={1,1})),
          Documentation(info="<html>
<p>
This model transports fluid between its two ports, without storing mass or energy. 
It implements a steady-state conservation equation for energy and mass fractions.
The model has zero pressure drop between its ports.
</p>
<h4>Implementation</h4>
Input connectors of the model are
<ul>
<li>
<code>Q_flow</code>, which is the sensible plus latent heat flow rate added to the medium, and
</li>
<li>
<code>mWat_flow</code>, which is the moisture mass flow rate added to the medium.
</li>
</ul>

<p>
The model can only be used as a steady-state model with two fluid ports.
For a model with a dynamic balance, and more fluid ports, use
<a href=\"modelica://Buildings.Fluid.Interfaces.ConservationEquation\">
Buildings.Fluid.Interfaces.ConservationEquation</a>.
</p>
<p>
Set the constant <code>sensibleOnly=true</code> if the model that extends
or instantiates this model sets <code>mWat_flow = 0</code>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
February 11, 2014 by Michael Wetter:<br/>
Improved documentation for <code>Q_flow</code> input.
</li>
<li>
October 21, 2013 by Michael Wetter:<br/>
Corrected sign error in the equation that is used if <code>use_safeDivision=false</code>
and <code>sensibleOnly=true</code>.
This only affects internal numerical tests, but not any examples in the library
as the constant <code>use_safeDivision</code> is set to <code>true</code> by default.
</li>
<li>
September 25, 2013 by Michael Wetter:<br/>
Reformulated computation of outlet properties to avoid an event at zero mass flow rate.
</li>
<li>
September 17, 2013 by Michael Wetter:<br/>
Added start value for <code>hOut</code>.
</li>
<li>September 10, 2013 by Michael Wetter:<br/>
Removed unrequired parameter <code>i_w</code>.
</li>
<li>
May 7, 2013 by Michael Wetter:<br/>
Removed <code>for</code> loops for species balance and trace substance balance, 
as they cause the error <code>Error: Operand port_a.Xi_outflow[1] to operator inStream is not a stream variable.</code>
in OpenModelica.
</li>
<li>
March 27, 2013 by Michael Wetter:<br/>
Removed wrong unit attribute of <code>COut</code>,
and added min and max attributes for <code>XiOut</code>.
</li>
<li>
June 22, 2012 by Michael Wetter:<br/>
Reformulated implementation with <code>m_flowInv</code> to use <code>port_a.m_flow * ...</code>
if <code>use_safeDivision=false</code>. This avoids a division by zero if 
<code>port_a.m_flow=0</code>.
</li>
<li>
February 7, 2012 by Michael Wetter:<br/>
Revised base classes for conservation equations in <code>Buildings.Fluid.Interfaces</code>.
</li>
<li>
December 14, 2011 by Michael Wetter:<br/>
Changed assignment of <code>hOut</code>, <code>XiOut</code> and
<code>COut</code> to no longer declare that it is continuous. 
The declaration of continuity, i.e, the 
<code>smooth(0, if (port_a.m_flow >= 0) then ...</code> declaration,
was required for Dymola 2012 to simulate, but it is no longer needed 
for Dymola 2012 FD01.
</li>
<li>
August 19, 2011, by Michael Wetter:<br/>
Changed assignment of <code>hOut</code>, <code>XiOut</code> and
<code>COut</code> to declare that it is not differentiable.
</li>
<li>
August 4, 2011, by Michael Wetter:<br/>
Moved linearized pressure drop equation from the function body to the equation
section. With the previous implementation, 
the symbolic processor may not rearrange the equations, which can lead 
to coupled equations instead of an explicit solution.
</li>
<li>
March 29, 2011, by Michael Wetter:<br/>
Changed energy and mass balance to avoid a division by zero if <code>m_flow=0</code>.
</li>
<li>
March 27, 2011, by Michael Wetter:<br/>
Added <code>homotopy</code> operator.
</li>
<li>
August 19, 2010, by Michael Wetter:<br/>
Fixed bug in energy and moisture balance that affected results if a component
adds or removes moisture to the air stream. 
In the old implementation, the enthalpy and species
outflow at <code>port_b</code> was multiplied with the mass flow rate at 
<code>port_a</code>. The old implementation led to small errors that were proportional
to the amount of moisture change. For example, if the moisture added by the component
was <code>0.005 kg/kg</code>, then the error was <code>0.5%</code>.
Also, the results for forward flow and reverse flow differed by this amount.
With the new implementation, the energy and moisture balance is exact.
</li>
<li>
March 22, 2010, by Michael Wetter:<br/>
Added constant <code>sensibleOnly</code> to 
simplify species balance equation.
</li>
<li>
April 10, 2009, by Michael Wetter:<br/>
Added model to compute flow friction.
</li>
<li>
April 22, 2008, by Michael Wetter:<br/>
Revised to add mass balance.
</li>
<li>
March 17, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),Icon(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={1,1}), graphics={Rectangle(
                extent={{-100,100},{100,-100}},
                fillColor={135,135,135},
                fillPattern=FillPattern.Solid,
                pattern=LinePattern.None),
              Text(
                extent={{-93,72},{-58,89}},
                lineColor={0,0,127},
                textString="Q_flow"),
              Text(
                extent={{-93,37},{-58,54}},
                lineColor={0,0,127},
                textString="mWat_flow"),
              Text(
                extent={{-41,103},{-10,117}},
                lineColor={0,0,127},
                textString="hOut"),
              Text(
                extent={{10,103},{41,117}},
                lineColor={0,0,127},
                textString="XiOut"),
              Text(
                extent={{61,103},{92,117}},
                lineColor={0,0,127},
                textString="COut"),
              Line(points={{-42,55},{-42,-84}}, color={255,255,255}),
              Polygon(
                points={{-42,67},{-50,45},{-34,45},{-42,67}},
                lineColor={255,255,255},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Polygon(
                points={{87,-73},{65,-65},{65,-81},{87,-73}},
                lineColor={255,255,255},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Line(points={{-56,-73},{81,-73}}, color={255,255,255}),
              Line(points={{6,14},{6,-37}},     color={255,255,255}),
              Line(points={{54,14},{6,14}},     color={255,255,255}),
              Line(points={{6,-37},{-42,-37}},  color={255,255,255})}));
      end StaticTwoPortConservationEquation;

      record LumpedVolumeDeclarations "Declarations for lumped volumes"
        replaceable package Medium =
          Modelica.Media.Interfaces.PartialMedium "Medium in the component"
            annotation (choicesAllMatching = true);

        // Assumptions
        parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
        "Formulation of energy balance"
          annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
        parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
        "Formulation of mass balance"
          annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
        final parameter Modelica.Fluid.Types.Dynamics substanceDynamics=energyDynamics
        "Formulation of substance balance"
          annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
        final parameter Modelica.Fluid.Types.Dynamics traceDynamics=energyDynamics
        "Formulation of trace substance balance"
          annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));

        // Initialization
        parameter Medium.AbsolutePressure p_start = Medium.p_default
        "Start value of pressure"
          annotation(Dialog(tab = "Initialization"));
        parameter Medium.Temperature T_start=Medium.T_default
        "Start value of temperature"
          annotation(Dialog(tab = "Initialization"));
        parameter Medium.MassFraction X_start[Medium.nX] = Medium.X_default
        "Start value of mass fractions m_i/m"
          annotation (Dialog(tab="Initialization", enable=Medium.nXi > 0));
        parameter Medium.ExtraProperty C_start[Medium.nC](
             quantity=Medium.extraPropertiesNames)=fill(0, Medium.nC)
        "Start value of trace substances"
          annotation (Dialog(tab="Initialization", enable=Medium.nC > 0));
        parameter Medium.ExtraProperty C_nominal[Medium.nC](
             quantity=Medium.extraPropertiesNames) = fill(1E-2, Medium.nC)
        "Nominal value of trace substances. (Set to typical order of magnitude.)"
         annotation (Dialog(tab="Initialization", enable=Medium.nC > 0));

      annotation (preferredView="info",
      Documentation(info="<html>
<p>
This class contains parameters and medium properties
that are used in the lumped  volume model, and in models that extend the 
lumped volume model.
</p>
<p>
These parameters are used by
<a href=\"modelica://Buildings.Fluid.Interfaces.ConservationEquation\">
Buildings.Fluid.Interfaces.ConservationEquation</a>,
<a href=\"modelica://Buildings.Fluid.MixingVolumes.MixingVolume\">
Buildings.Fluid.MixingVolumes.MixingVolume</a>,
<a href=\"modelica://Buildings.Rooms.MixedAir\">
Buildings.Rooms.MixedAir</a>, and by
<a href=\"modelica://Buildings.Rooms.BaseClasses.MixedAir\">
Buildings.Rooms.BaseClasses.MixedAir</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
August 2, 2011, by Michael Wetter:<br/>
Set <code>substanceDynamics</code> and <code>traceDynamics</code> to final
and equal to <code>energyDynamics</code>, 
as there is no need to make them different from <code>energyDynamics</code>.
</li>
<li>
August 1, 2011, by Michael Wetter:<br/>
Changed default value for <code>energyDynamics</code> to
<code>Modelica.Fluid.Types.Dynamics.DynamicFreeInitial</code> because
<code>Modelica.Fluid.Types.Dynamics.SteadyStateInitial</code> leads
to high order DAE that Dymola cannot reduce.
</li>
<li>
July 31, 2011, by Michael Wetter:<br/>
Changed default value for <code>energyDynamics</code> to
<code>Modelica.Fluid.Types.Dynamics.SteadyStateInitial</code>.
</li>
<li>
April 13, 2009, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
      end LumpedVolumeDeclarations;
    annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains basic classes that are used to build
component models that change the state of the
fluid. The classes are not directly usable, but can
be extended when building a new model.
</p>
</html>"));
    end Interfaces;
  annotation (
  preferredView="info", Documentation(info="<html>
This package contains components for fluid flow systems such as
pumps, valves and sensors. For other fluid flow models, see 
<a href=\"modelica://Modelica.Fluid\">Modelica.Fluid</a>.
</html>"));
  end Fluid;

  package HeatTransfer "Package with heat transfer models"
    extends Modelica.Icons.Package;

    package Sources "Thermal sources"
    extends Modelica.Icons.SourcesPackage;

      model PrescribedHeatFlow "Prescribed heat flow boundary condition"
        Modelica.Blocks.Interfaces.RealInput Q_flow
              annotation (Placement(transformation(
              origin={-100,0},
              extent={{20,-20},{-20,20}},
              rotation=180)));
        Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port annotation (Placement(transformation(extent={{90,
                  -10},{110,10}}, rotation=0)));
      equation
        port.Q_flow = -Q_flow;
        annotation (
          Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                  100,100}}), graphics={
              Line(
                points={{-60,-20},{40,-20}},
                color={191,0,0},
                thickness=0.5),
              Line(
                points={{-60,20},{40,20}},
                color={191,0,0},
                thickness=0.5),
              Line(
                points={{-80,0},{-60,-20}},
                color={191,0,0},
                thickness=0.5),
              Line(
                points={{-80,0},{-60,20}},
                color={191,0,0},
                thickness=0.5),
              Polygon(
                points={{40,0},{40,40},{70,20},{40,0}},
                lineColor={191,0,0},
                fillColor={191,0,0},
                fillPattern=FillPattern.Solid),
              Polygon(
                points={{40,-40},{40,0},{70,-20},{40,-40}},
                lineColor={191,0,0},
                fillColor={191,0,0},
                fillPattern=FillPattern.Solid),
              Rectangle(
                extent={{70,40},{90,-40}},
                lineColor={191,0,0},
                fillColor={191,0,0},
                fillPattern=FillPattern.Solid),
              Text(
                extent={{-150,100},{150,60}},
                textString="%name",
                lineColor={0,0,255})}),
          Documentation(info="<HTML>
<p>
This model allows a specified amount of heat flow rate to be \"injected\"
into a thermal system at a given port.  The amount of heat
is given by the input signal Q_flow into the model. The heat flows into the
component to which the component PrescribedHeatFlow is connected,
if the input signal is positive.
</p>
<p>
This model is identical to
<a href=\"modelica://Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow\">
Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow</a>, except that
the parameters <code>alpha</code> and <code>T_ref</code> have
been deleted as these can cause division by zero in some fluid flow models.
</p>
</HTML>
",    revisions="<html>
<ul>
<li>
March 29 2011, by Michael Wetter:<br/>
First implementation based on <a href=\"modelica://Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow\">
Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow</a>.
</li>
</ul>
</html>"),       Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
                  {100,100}}), graphics={
              Line(
                points={{-60,-20},{68,-20}},
                color={191,0,0},
                thickness=0.5),
              Line(
                points={{-60,20},{68,20}},
                color={191,0,0},
                thickness=0.5),
              Line(
                points={{-80,0},{-60,-20}},
                color={191,0,0},
                thickness=0.5),
              Line(
                points={{-80,0},{-60,20}},
                color={191,0,0},
                thickness=0.5),
              Polygon(
                points={{60,0},{60,40},{90,20},{60,0}},
                lineColor={191,0,0},
                fillColor={191,0,0},
                fillPattern=FillPattern.Solid),
              Polygon(
                points={{60,-40},{60,0},{90,-20},{60,-40}},
                lineColor={191,0,0},
                fillColor={191,0,0},
                fillPattern=FillPattern.Solid)}));
      end PrescribedHeatFlow;
      annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                -100},{100,100}})),   Documentation(info="<html>
This package is identical to
<a href=\"modelica://Modelica.Thermal.HeatTransfer.Sources\">
Modelica.Thermal.HeatTransfer.Sources</a>, except that
the parameters <code>alpha</code> and <code>T_ref</code> have
been deleted in the models
<a href=\"modelica://Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow\">
Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow</a> and
<a href=\"modelica://Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow\">
Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow</a>
 as these can cause division by zero in some fluid flow models.
</html>"));
    end Sources;
  annotation (preferredView="info", Documentation(info="<html>
This package contains models for heat transfer elements.
</html>"));
  end HeatTransfer;

  package Utilities "Package with utility functions such as for I/O"
    extends Modelica.Icons.Package;

    package Math "Library with functions such as for smoothing"
      extends Modelica.Icons.VariantsPackage;

      package Functions "Package with mathematical functions"
        extends Modelica.Icons.BasesPackage;

        function cubicHermiteLinearExtrapolation
        "Interpolate using a cubic Hermite spline with linear extrapolation"
          input Real x "Abscissa value";
          input Real x1 "Lower abscissa value";
          input Real x2 "Upper abscissa value";
          input Real y1 "Lower ordinate value";
          input Real y2 "Upper ordinate value";
          input Real y1d "Lower gradient";
          input Real y2d "Upper gradient";
          output Real y "Interpolated ordinate value";
        algorithm
          if (x > x1 and x < x2) then
            y:=Modelica.Fluid.Utilities.cubicHermite(
              x=x,
              x1=x1,
              x2=x2,
              y1=y1,
              y2=y2,
              y1d=y1d,
              y2d=y2d);
          elseif x <= x1 then
            // linear extrapolation
            y:=y1 + (x - x1)*y1d;
          else
            y:=y2 + (x - x2)*y2d;
          end if;
          annotation(smoothOrder=1,
              Documentation(info="<html>
<p>
For <i>x<sub>1</sub> &lt; x &lt; x<sub>2</sub></i>, this function interpolates
using cubic hermite spline. For <i>x</i> outside this interval, the function 
linearly extrapolates.
</p>
<p>
For how to use this function, see
<a href=\"modelica://Buildings.Utilities.Math.Functions.Examples.CubicHermite\">
Buildings.Utilities.Math.Functions.Examples.CubicHermite</a>.
</p>
</html>",
        revisions="<html>
<ul>
<li>
September 27, 2011 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
        end cubicHermiteLinearExtrapolation;

        function smoothMax
        "Once continuously differentiable approximation to the maximum function"
          input Real x1 "First argument";
          input Real x2 "Second argument";
          input Real deltaX "Width of transition interval";
          output Real y "Result";
        algorithm
          y := Buildings.Utilities.Math.Functions.spliceFunction(
                 pos=x1, neg=x2, x=x1-x2, deltax=deltaX);
          annotation (
        Documentation(info="<html>
<p>
Once continuously differentiable approximation to the <code>max(.,.)</code> function.
</p>
</html>",
        revisions="<html>
<ul>
<li>
August 15, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
        end smoothMax;

        function spliceFunction
            input Real pos "Argument of x > 0";
            input Real neg "Argument of x < 0";
            input Real x "Independent value";
            input Real deltax "Half width of transition interval";
            output Real out "Smoothed value";
      protected
            Real scaledX1;
            Real y;
            constant Real asin1 = Modelica.Math.asin(1);
        algorithm
            scaledX1 := x/deltax;
            if scaledX1 <= -0.999999999 then
              out := neg;
            elseif scaledX1 >= 0.999999999 then
              out := pos;
            else
              y := (Modelica.Math.tanh(Modelica.Math.tan(scaledX1*asin1)) + 1)/2;
              out := pos*y + (1 - y)*neg;
            end if;

            annotation (
        smoothOrder=1,
        derivative=BaseClasses.der_spliceFunction,
        Documentation(info="<html>
<p>
Function to provide a once continuously differentialbe transition between 
to arguments.
</p><p>
The function is adapted from 
<a href=\"modelica://Modelica.Media.Air.MoistAir.Utilities.spliceFunction\">
Modelica.Media.Air.MoistAir.Utilities.spliceFunction</a> and provided here
for easier accessability to model developers.
</html>",         revisions="<html>
<ul>
<li>
May 10, 2013, by Michael Wetter:<br/>
Reformulated implementation to avoid unrequired computations.
</li>
<li>
May 11, 2010, by Michael Wetter:<br/>
Removed default value for transition interval as this is problem dependent.
</li>
<li>
May 20, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
        end spliceFunction;

        function splineDerivatives
        "Function to compute the derivatives for cubic hermite spline interpolation"
          input Real x[:] "Support point, strict monotone increasing";
          input Real y[size(x, 1)] "Function values at x";
          input Boolean ensureMonotonicity=isMonotonic(y, strict=false)
          "Set to true to ensure monotonicity of the cubic hermite";
          output Real d[size(x, 1)] "Derivative at the support points";
      protected
          Integer n=size(x, 1) "Number of data points";
          Real delta[n - 1] "Slope of secant line between data points";
          Real alpha "Coefficient to ensure monotonicity";
          Real beta "Coefficient to ensure monotonicity";
          Real tau "Coefficient to ensure monotonicity";

        algorithm
          if (n>1) then
            assert(x[1] < x[n], "x must be strictly increasing.
  Received x[1] = "         + String(x[1]) + "
           x["         + String(n) + "] = " + String(x[n]));
          // Check data
            assert(isMonotonic(x, strict=true),
              "x-values must be strictly monontone increasing or decreasing.");
            if ensureMonotonicity then
              assert(isMonotonic(y, strict=false),
                "If ensureMonotonicity=true, y-values must be monontone increasing or decreasing.");
            end if;
          end if;

          // Compute derivatives at the support points
          if n == 1 then
            // only one data point
            d[1] :=0;
          elseif n == 2 then
            // linear function
            d[1] := (y[2] - y[1])/(x[2] - x[1]);
            d[2] := d[1];
          else
            // Slopes of the secant lines between i and i+1
            for i in 1:n - 1 loop
              delta[i] := (y[i + 1] - y[i])/(x[i + 1] - x[i]);
            end for;
            // Initial values for tangents at the support points.
            // End points use one-sided derivatives
            d[1] := delta[1];
            d[n] := delta[n - 1];

            for i in 2:n - 1 loop
              d[i] := (delta[i - 1] + delta[i])/2;
            end for;

          end if;
          // Ensure monotonicity
          if n > 2 and ensureMonotonicity then
            for i in 1:n - 1 loop
              if (abs(delta[i]) < Modelica.Constants.small) then
                d[i] := 0;
                d[i + 1] := 0;
              else
                alpha := d[i]/delta[i];
                beta := d[i + 1]/delta[i];
                // Constrain derivative to ensure monotonicity in this interval
                if (alpha^2 + beta^2) > 9 then
                  tau := 3/(alpha^2 + beta^2)^(1/2);
                  d[i] := delta[i]*alpha*tau;
                  d[i + 1] := delta[i]*beta*tau;
                end if;
              end if;
            end for;
          end if;
          annotation (Documentation(info="<html>
<p>
This function computes the derivatives at the support points <i>x<sub>i</sub></i>
that can be used as input for evaluating a cubic hermite spline.
If <code>ensureMonotonicity=true</code>, then the support points <i>y<sub>i</sub></i>
need to be monotone increasing (or increasing), and the computed derivatives
<i>d<sub>i</sub></i> are such that the cubic hermite is monotone increasing (or decreasing).
The algorithm to ensure monotonicity is based on the method described in Fritsch and Carlson (1980) for
<i>&rho; = &rho;<sub>2</sub></i>.
</p>
<p>
This function is typically used with
<a href=\"modelica://Buildings.Utilities.Math.Functions.cubicHermiteLinearExtrapolation\">
Buildings.Utilities.Math.Functions.cubicHermiteLinearExtrapolation</a>
which is used to evaluate the cubic spline.
Because in many applications, the shape of the spline depends on parameters,
this function has been implemented in such a way that all derivatives can be 
computed at once and then stored for use during the time stepping,
in which the above function may be called.
</p>
<h4>References</h4>
<p>
F.N. Fritsch and R.E. Carlson, <a href=\"http://dx.doi.org/10.1137/0717021\">Monotone piecewise cubic interpolation</a>. 
<i>SIAM J. Numer. Anal.</i>, 17 (1980), pp. 238?246.
</p>
</html>",         revisions="<html>
<ul>
<li>
September 29, 2011 by Michael Wetter:<br/>
Added special case for one data point and two data points.
</li>
<li>
September 27, 2011 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
        end splineDerivatives;

        function inverseXRegularized
        "Function that approximates 1/x by a twice continuously differentiable function"
         input Real x "Abscissa value";
         input Real delta(min=0)
          "Abscissa value below which approximation occurs";
         output Real y "Function value";
      protected
         Real delta2 "Delta^2";
         Real x2_d2 "=x^2/delta^2";
        algorithm
          if (abs(x) > delta) then
            y := 1/x;
          else
            delta2 :=delta*delta;
            x2_d2  := x*x/delta2;
            y      := x/delta2 + x*abs(x/delta2/delta*(2 - x2_d2*(3 - x2_d2)));
          end if;

          annotation (
            Documentation(info="<html>
<p>
Function that approximates <i>y=1 &frasl; x</i> 
inside the interval <i>-&delta; &le; x &le; &delta;</i>.
The approximation is twice continuously differentiable with a bounded derivative on the whole 
real line.
<p>
See the package <code>Examples</code> for the graph.
</p>
</html>",         revisions="<html>
<ul>
<li>
May 10, 2013, by Michael Wetter:<br/>
Reformulated implementation to avoid unrequired computations.
</li>
<li>
April 18, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),          smoothOrder=2, Inline=true);
        end inverseXRegularized;

        function isMonotonic
        "Returns true if the argument is a monotonic sequence"
          input Real x[:] "Sequence to be tested";
          input Boolean strict=false
          "Set to true to test for strict monotonicity";
          output Boolean monotonic
          "True if x is monotonic increasing or decreasing";
      protected
          Integer n=size(x, 1) "Number of data points";

        algorithm
          if n == 1 then
            monotonic := true;
          else
            monotonic := true;
            if strict then
              if (x[1] >= x[n]) then
                for i in 1:n - 1 loop
                  if (not x[i] > x[i + 1]) then
                    monotonic := false;
                  end if;
                end for;
              else
                for i in 1:n - 1 loop
                  if (not x[i] < x[i + 1]) then
                    monotonic := false;
                  end if;
                end for;
              end if;
            else
              // not strict
              if (x[1] >= x[n]) then
                for i in 1:n - 1 loop
                  if (not x[i] >= x[i + 1]) then
                    monotonic := false;
                  end if;
                end for;
              else
                for i in 1:n - 1 loop
                  if (not x[i] <= x[i + 1]) then
                    monotonic := false;
                  end if;
                end for;
              end if;
            end if;
            // strict
          end if;

          annotation (Documentation(info="<html>
<p>
This function returns <code>true</code> if its argument is 
monotonic increasing or decreasing, and <code>false</code> otherwise.
If <code>strict=true</code>, then strict monotonicity is tested,
otherwise weak monotonicity is tested.
</p>
</html>",         revisions="<html>
<ul>
<li>
September 28, 2011 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
        end isMonotonic;

        package BaseClasses
        "Package with base classes for Buildings.Utilities.Math.Functions"
          extends Modelica.Icons.BasesPackage;

          function der_spliceFunction "Derivative of splice function"
              input Real pos;
              input Real neg;
              input Real x;
              input Real deltax=1;
              input Real dpos;
              input Real dneg;
              input Real dx;
              input Real ddeltax=0;
              output Real out;
        protected
              Real scaledX;
              Real scaledX1;
              Real dscaledX1;
              Real y;
              constant Real asin1 = Modelica.Math.asin(1);
          algorithm
              scaledX1 := x/deltax;
              if scaledX1 <= -0.99999999999 then
                out := dneg;
              elseif scaledX1 >= 0.9999999999 then
                out := dpos;
              else
                scaledX := scaledX1*asin1;
                dscaledX1 := (dx - scaledX1*ddeltax)/deltax;
                y := (Modelica.Math.tanh(Modelica.Math.tan(scaledX)) + 1)/2;
                out := dpos*y + (1 - y)*dneg;
                out := out + (pos - neg)*dscaledX1*asin1/2/(
                  Modelica.Math.cosh(Modelica.Math.tan(scaledX))*Modelica.Math.cos(
                  scaledX))^2;
              end if;

          annotation (
          Documentation(
          info="<html>
<p>
Implementation of the first derivative of the function
<a href=\"modelica://Buildings.Utilities.Math.Functions.spliceFunction\">
Buildings.Utilities.Math.Functions.spliceFunction</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
May 10, 2013, by Michael Wetter:<br/>
Reformulated implementation to avoid unrequired computations.
</li>
<li>
April 7, 2009, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
          end der_spliceFunction;
        annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains base classes that are used to construct the models in
<a href=\"modelica://Buildings.Utilities.Math.Functions\">Buildings.Utilities.Math.Functions</a>.
</p>
</html>"));
        end BaseClasses;
      annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains functions for commonly used
mathematical operations. The functions are used in 
the blocks
<a href=\"modelica://Buildings.Utilities.Math\">
Buildings.Utilities.Math</a>.
</p>
</html>"));
      end Functions;
    annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains blocks and functions for commonly used
mathematical operations. 
The classes in this package augment the classes
<a href=\"modelica://Modelica.Blocks\">
Modelica.Blocks</a>.
</p>
</html>"));
    end Math;
  annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains utility models such as for thermal comfort calculation, input/output, co-simulation, psychrometric calculations and various functions that are used throughout the library.
</p>
</html>"));
  end Utilities;
annotation (
preferredView="info",
version="1.6",
versionBuild=0,
versionDate="2013-10-24",
dateModified = "2013-10-24",
uses(Modelica(version="3.2.1")),
uses(Modelica_StateGraph2(version="2.0.2")),
conversion(
 from(version="1.5",
      script="modelica://Buildings/Resources/Scripts/Dymola/ConvertBuildings_from_1.5_to_1.6.mos"),
 from(version="1.4",
      script="modelica://Buildings/Resources/Scripts/Dymola/ConvertBuildings_from_1.4_to_1.5.mos"),
 noneFromVersion="1.3",
 noneFromVersion="1.2",
 from(version="1.1",
      script="modelica://Buildings/Resources/Scripts/Dymola/ConvertBuildings_from_1.1_to_1.2.mos"),
 from(version="1.0",
      script="modelica://Buildings/Resources/Scripts/Dymola/ConvertBuildings_from_1.0_to_1.1.mos"),
 from(version="0.12",
      script="modelica://Buildings/Resources/Scripts/Dymola/ConvertBuildings_from_0.12_to_1.0.mos")),
revisionId="$Id$",
preferredView="info",
Documentation(info="<html>
<p>
The <code>Buildings</code> library is a free library
for modeling building energy and control systems. 
Many models are based on models from the package
<code>Modelica.Fluid</code> and use
the same ports to ensure compatibility with the Modelica Standard
Library.
</p>
<p>
The figure below shows a section of the schematic view of the model 
<a href=\"modelica://Buildings.Examples.HydronicHeating\">
Buildings.Examples.HydronicHeating</a>.
In the lower part of the figure, there is a dynamic model of a boiler, a pump and a stratified energy storage tank. Based on the temperatures of the storage tank, a finite state machine switches the boiler and its pump on and off. 
The heat distribution is done using a hydronic heating system with a three way valve and a pump with variable revolutions. The upper right hand corner shows a room model that is connected to a radiator whose flow is controlled by a thermostatic valve.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/UsersGuide/HydronicHeating.png\" border=\"1\"/>
</p>
<p>
The web page for this library is
<a href=\"http://simulationresearch.lbl.gov/modelica\">http://simulationresearch.lbl.gov/modelica</a>,
and the development page is
<a href=\"https://github.com/lbl-srg/modelica-buildings\">https://github.com/lbl-srg/modelica-buildings</a>.
Contributions to further advance the library are welcomed.
Contributions may not only be in the form of model development, but also
through model use, model testing,
requirements definition or providing feedback regarding the model applicability
to solve specific problems.
</p>
</html>"));
end Buildings;

package Annex60 "Library with models for building energy and control systems"
  extends Modelica.Icons.Package;

  package Fluid "Package with models for fluid flow systems"
    extends Modelica.Icons.Package;

    package FixedResistances
    "Package with models for fixed flow resistances (pipes, diffusers etc.)"
      extends Modelica.Icons.VariantsPackage;

      model FixedResistanceDpM
      "Fixed flow resistance with dp and m_flow as parameter"
        extends Annex60.Fluid.BaseClasses.PartialResistance(
          final m_flow_turbulent = if (computeFlowResistance and use_dh) then
                             eta_default*dh/4*Modelica.Constants.pi*ReC
                             elseif (computeFlowResistance) then
                             deltaM * m_flow_nominal_pos
               else 0);
        parameter Boolean use_dh = false
        "Set to true to specify hydraulic diameter"
             annotation(Evaluate=true, Dialog(enable = not linearized));
        parameter Modelica.SIunits.Length dh=1 "Hydraulic diameter"
             annotation(Evaluate=true, Dialog(enable = use_dh and not linearized));
        parameter Real ReC(min=0)=4000
        "Reynolds number where transition to turbulent starts"
             annotation(Evaluate=true, Dialog(enable = use_dh and not linearized));
        parameter Real deltaM(min=0.01) = 0.3
        "Fraction of nominal mass flow rate where transition to turbulent occurs"
             annotation(Evaluate=true, Dialog(enable = not use_dh and not linearized));

        final parameter Real k(unit="") = if computeFlowResistance then
              m_flow_nominal_pos / sqrt(dp_nominal_pos) else 0
        "Flow coefficient, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)";
    protected
        final parameter Boolean computeFlowResistance=(dp_nominal_pos > Modelica.Constants.eps)
        "Flag to enable/disable computation of flow resistance"
         annotation(Evaluate=true);
      initial equation
       if computeFlowResistance then
         assert(m_flow_turbulent > 0, "m_flow_turbulent must be bigger than zero.");
       end if;

       assert(m_flow_nominal_pos > 0, "m_flow_nominal_pos must be non-zero. Check parameters.");
       if ( m_flow_turbulent > m_flow_nominal_pos) then
         Modelica.Utilities.Streams.print("Warning: In FixedResistanceDpM, m_flow_nominal is smaller than m_flow_turbulent."
                 + "\n"
                 + "  m_flow_nominal = " + String(m_flow_nominal) + "\n"
                 + "  dh      = " + String(dh) + "\n"
                 + "  To fix, set dh < " +
                      String(     4*m_flow_nominal/eta_default/Modelica.Constants.pi/ReC) + "\n"
                 + "  Suggested value: dh = " +
                      String(1/10*4*m_flow_nominal/eta_default/Modelica.Constants.pi/ReC));
       end if;

      equation
        // Pressure drop calculation
        if computeFlowResistance then
          if linearized then
            m_flow*m_flow_nominal_pos = k^2*dp;
          else
            if homotopyInitialization then
              if from_dp then
                m_flow=homotopy(actual=Annex60.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(dp=dp, k=k,
                                         m_flow_turbulent=m_flow_turbulent),
                                         simplified=m_flow_nominal_pos*dp/dp_nominal_pos);
              else
                dp=homotopy(actual=Annex60.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(m_flow=m_flow, k=k,
                                         m_flow_turbulent=m_flow_turbulent),
                          simplified=dp_nominal_pos*m_flow/m_flow_nominal_pos);
               end if;  // from_dp
            else // do not use homotopy
              if from_dp then
                m_flow=Annex60.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(dp=dp, k=k,
                                         m_flow_turbulent=m_flow_turbulent);
              else
                dp=Annex60.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(m_flow=m_flow, k=k,
                                         m_flow_turbulent=m_flow_turbulent);
              end if;  // from_dp
            end if; // homotopyInitialization
          end if; // linearized
        else // do not compute flow resistance
          dp = 0;
        end if;  // computeFlowResistance

        annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
                  -100},{100,100}}),
                            graphics),
      defaultComponentName="res",
      Documentation(info="<html>
<p>
This is a model of a resistance with a fixed flow coefficient.
The mass flow rate is computed as
</p>
<p align=\"center\" style=\"font-style:italic;\">
m&#775; = k  
&radic;<span style=\"text-decoration:overline;\">&Delta;P</span>,
</p>
<p>
where 
<i>k</i> is a constant and 
<i>&Delta;P</i> is the pressure drop.
The constant <i>k</i> is equal to
<code>k=m_flow_nominal/dp_nominal</code>,
where <code>m_flow_nominal</code> and <code>dp_nominal</code>
are parameters.
In the region
<code>abs(m_flow) &lt; m_flow_turbulent</code>, 
the square root is replaced by a differentiable function
with finite slope.
The value of <code>m_flow_turbulent</code> is
computed as follows:
</p>
<ul>
<li>
If the parameter <code>use_dh</code> is <code>false</code>
(the default setting), 
the equation 
<code>m_flow_turbulent = deltaM * abs(m_flow_nominal)</code>,
where <code>deltaM=0.3</code> and 
<code>m_flow_nominal</code> are parameters that can be set by the user.
</li>
<li>
Otherwise, the equation
<code>m_flow_turbulent = eta_nominal*dh/4*&pi;*ReC</code> is used,
where 
<code>eta_nominal</code> is the dynamic viscosity, obtained from
the medium model. The parameter
<code>dh</code> is the hydraulic diameter and
<code>ReC=4000</code> is the critical Reynolds number, which both
can be set by the user.
</li>
</ul>
<p>
The figure below shows the pressure drop for the parameters
<code>m_flow_nominal=5</code> kg/s,
<code>dp_nominal=10</code> Pa and
<code>deltaM=0.3</code>.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Annex60/Resources/Images/Fluid/FixedResistances/FixedResistanceDpM.png\"/>
</p>
<p>
If the parameter
<code>show_T</code> is set to <code>true</code>,
then the model will compute the
temperature at its ports. Note that this can lead to state events
when the mass flow rate approaches zero,
which can increase computing time.
</p>
<p>
The parameter <code>from_dp</code> is used to determine
whether the mass flow rate is computed as a function of the 
pressure drop (if <code>from_dp=true</code>), or vice versa.
This setting can affect the size of the nonlinear system of equations.
</p>
<p>
If the parameter <code>linearized</code> is set to <code>true</code>,
then the pressure drop is computed as a linear function of the
mass flow rate.
</p>
<p>
Setting <code>allowFlowReversal=false</code> can lead to simpler
equations. However, this should only be set to <code>false</code>
if one can guarantee that the flow never reverses its direction.
This can be difficult to guarantee, as pressure imbalance after 
the initialization, or due to medium expansion and contraction,
can lead to reverse flow.
</p>
<h4>Notes</h4>
<p>
For more detailed models that compute the actual flow friction, 
models from the package 
<a href=\"modelica://Modelica.Fluid\">
Modelica.Fluid</a>
can be used and combined with models from the 
<code>Buildings</code> library.
</p>
<h4>Implementation</h4>
<p>
The pressure drop is computed by calling a function in the package
<a href=\"modelica://Annex60.Fluid.BaseClasses.FlowModels\">
Annex60.Fluid.BaseClasses.FlowModels</a>,
This package contains regularized implementations of the equation
</p>
<p align=\"center\" style=\"font-style:italic;\">
  m = sign(&Delta;p) k  &radic;<span style=\"text-decoration:overline;\">&nbsp;&Delta;p &nbsp;</span>
</p>
<p>
and its inverse function.
</p>
<p>
To decouple the energy equation from the mass equations,
the pressure drop is a function of the mass flow rate,
and not the volume flow rate.
This leads to simpler equations.
</p>
</html>",       revisions="<html>
<ul>
<li>
October 8, 2013, by Michael Wetter:<br/>
Removed parameter <code>show_V_flow</code>.
</li>
<li>
December 14, 2012 by Michael Wetter:<br/>
Renamed protected parameters for consistency with the naming conventions.
</li>
<li>
January 16, 2012 by Michael Wetter:<br/>
To simplify object inheritance tree, revised base classes
<code>Annex60.Fluid.BaseClasses.PartialResistance</code>,
<code>Annex60.Fluid.Actuators.BaseClasses.PartialTwoWayValve</code>,
<code>Annex60.Fluid.Actuators.BaseClasses.PartialDamperExponential</code>,
<code>Annex60.Fluid.Actuators.BaseClasses.PartialActuator</code>
and model
<code>Annex60.Fluid.FixedResistances.FixedResistanceDpM</code>.
</li>
<li>
May 30, 2008 by Michael Wetter:<br/>
Added parameters <code>use_dh</code> and <code>deltaM</code> for easier parameterization.
</li>
<li>
July 20, 2007 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
                  100}}), graphics={Text(
                extent={{-102,86},{-4,22}},
                lineColor={0,0,255},
                textString="dp_nominal=%dp_nominal"), Text(
                extent={{-106,106},{6,60}},
                lineColor={0,0,255},
                textString="m0=%m_flow_nominal")}));
      end FixedResistanceDpM;
    annotation (preferredView="info", Documentation(info="<html>
This package contains components models for fixed flow resistances. 
By fixed flow resistance, we mean resistances that do not change the 
flow coefficient
<p align=\"center\" style=\"font-style:italic;\">
k = m &frasl; 
&radic;<span style=\"text-decoration:overline;\">&Delta;P</span>.
</p>
<p>
For models of valves and air dampers, see
<a href=\"modelica://Annex60.Fluid.Actuators\">
Annex60.Fluid.Actuators</a>.
For models of flow resistances as part of the building constructions, see 
<a href=\"modelica://Annex60.Airflow.Multizone\">
Annex60.Airflow.Multizone</a>.
</p>
<p>
The model
<a href=\"modelica://Annex60.Fluid.FixedResistances.FixedResistanceDpM\">
Annex60.Fluid.FixedResistances.FixedResistanceDpM</a>
is a fixed flow resistance that takes as parameter a nominal flow rate and a nominal pressure drop. The actual resistance is scaled using the above equation.
</p>
<p>
The model
<a href=\"modelica://Annex60.Fluid.FixedResistances.LosslessPipe\">
Annex60.Fluid.FixedResistances.LosslessPipe</a>
is an ideal pipe segment with no pressure drop. It is primarily used
in models in which the above pressure drop model need to be replaced by a model with no pressure drop.
</p>
<p>
The model
<a href=\"modelica://Annex60.Fluid.FixedResistances.SplitterFixedResistanceDpM\">
Annex60.Fluid.FixedResistances.SplitterFixedResistanceDpM</a>
can be used to model flow splitters or flow merges.
</p>
</html>"));
    end FixedResistances;

    package MixingVolumes "Package with mixing volumes"
      extends Modelica.Icons.VariantsPackage;

      model MixingVolume
      "Mixing volume with inlet and outlet ports (flow reversal is allowed)"
        extends Annex60.Fluid.MixingVolumes.BaseClasses.PartialMixingVolume;
    protected
        Modelica.Blocks.Sources.Constant masExc(k=0)
        "Block to set mass exchange in volume"
          annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
        Modelica.Blocks.Sources.RealExpression heaInp(y=heatPort.Q_flow)
        "Block to set heat input into volume"
          annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
      equation
        connect(heaInp.y, steBal.Q_flow) annotation (Line(
            points={{-59,90},{-30,90},{-30,18},{-22,18}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(heaInp.y, dynBal.Q_flow) annotation (Line(
            points={{-59,90},{28,90},{28,16},{38,16}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(masExc.y, dynBal.mWat_flow) annotation (Line(
            points={{-59,70},{20,70},{20,12},{38,12}},
            color={0,0,127},
            smooth=Smooth.None));
        connect(masExc.y, steBal.mWat_flow) annotation (Line(
            points={{-59,70},{-40,70},{-40,14},{-22,14}},
            color={0,0,127},
            smooth=Smooth.None));
        annotation (
      defaultComponentName="vol",
      Documentation(info="<html>
<p>
This model represents an instantaneously mixed volume. 
Potential and kinetic energy at the port are neglected,
and there is no pressure drop at the ports.
The volume can exchange heat through its <code>heatPort</code>.
</p>
<p>
The volume can be parameterized as a steady-state model or as
dynamic model.</p>
<p>
To increase the numerical robustness of the model, the parameter
<code>prescribedHeatFlowRate</code> can be set by the user. 
This parameter only has an effect if the model has exactly two fluid ports connected,
and if it is used as a steady-state model.
Use the following settings:
</p>
<ul>
<li>Set <code>prescribedHeatFlowRate=true</code> if there is a model connected to <code>heatPort</code>
that computes the heat flow rate <i>not</i> as a function of the temperature difference
between the medium and an ambient temperature. Examples include an ideal electrical heater,
a pump that rejects heat into the fluid stream, or a chiller that removes heat based on a performance curve.
</li>
<li>Set <code>prescribedHeatFlowRate=true</code> if the only means of heat flow at the <code>heatPort</code>
is computed as <i>K * (T-heatPort.T)</i>, for some temperature <i>T</i> and some conductance <i>K</i>,
which may itself be a function of temperature or mass flow rate.
</li>
</ul>

<h4>Implementation</h4>
<p>
If the model is operated in steady-state and has two fluid ports connected,
then the same energy and mass balance implementation is used as in
steady-state component models, i.e., the use of <code>actualStream</code>
is not used for the properties at the port.
</p>
<p>
The implementation of these balance equations is done in the instances
<code>dynBal</code> for the dynamic balance and <code>steBal</code>
for the steady-state balance. Both models use the same input variables:
</p>
<ul>
<li>
The variable <code>Q_flow</code> is used to add sensible <i>and</i> latent heat to the fluid.
For example, <code>Q_flow</code> participates in the steady-state energy balance<pre>
    port_b.h_outflow = inStream(port_a.h_outflow) + Q_flow * m_flowInv;
</pre>
where <code>m_flowInv</code> approximates the expression <code>1/m_flow</code>.
</li>
<li>
The variable <code>mXi_flow</code> is used to add a species mass flow rate to the fluid.
</li>
</ul>

<p>
For simple models that uses this model, see
<a href=\"modelica://Annex60.Fluid.HeatExchangers.HeaterCoolerPrescribed\">
Annex60.Fluid.HeatExchangers.HeaterCoolerPrescribed</a> and
<a href=\"modelica://Annex60.Fluid.MassExchangers.HumidifierPrescribed\">
Annex60.Fluid.MassExchangers.HumidifierPrescribed</a>.
</p>

</html>",       revisions="<html>
<ul>
<li>
February 7, 2012 by Michael Wetter:<br/>
Revised base classes for conservation equations in <code>Annex60.Fluid.Interfaces</code>.
</li>
<li>
September 17, 2011 by Michael Wetter:<br/>
Removed instance <code>medium</code> as this is already used in <code>dynBal</code>.
Removing the base properties led to 30% faster computing time for a solar thermal system
that contains many fluid volumes. 
</li>
<li>
September 13, 2011 by Michael Wetter:<br/>
Changed in declaration of <code>medium</code> the parameter assignment
<code>preferredMediumStates=true</code> to
<code>preferredMediumStates= not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)</code>.
Otherwise, for a steady-state model, Dymola 2012 may differentiate the model to obtain <code>T</code>
as a state. See ticket Dynasim #13596.
</li>
<li>
July 26, 2011 by Michael Wetter:<br/>
Revised model to use new declarations from
<a href=\"Annex60.Fluid.Interfaces.LumpedVolumeDeclarations\">
Annex60.Fluid.Interfaces.LumpedVolumeDeclarations</a>.
</li>
<li>
July 14, 2011 by Michael Wetter:<br/>
Added start values for mass and internal energy of dynamic balance
model.
</li>
<li>
May 25, 2011 by Michael Wetter:<br/>
<ul>
<li>
Changed implementation of balance equation. The new implementation uses a different model if 
exactly two fluid ports are connected, and in addition, the model is used as a steady-state
component. For this model configuration, the same balance equations are used as were used
for steady-state component models, i.e., instead of <code>actualStream(...)</code>, the
<code>inStream(...)</code> formulation is used.
This changed required the introduction of a new parameter <code>m_flow_nominal</code> which
is used for smoothing in the steady-state balance equations of the model with two fluid ports.
</li>
<li>
Another revision was the removal of the parameter <code>use_HeatTransfer</code> as there is
no noticable overhead in always having the <code>heatPort</code> connector present.
</li>
</ul>
</li>
<li>
July 30, 2010 by Michael Wetter:<br/>
Added nominal value for <code>mC</code> to avoid wrong trajectory 
when concentration is around 1E-7.
See also <a href=\"https://trac.modelica.org/Modelica/ticket/393\">
https://trac.modelica.org/Modelica/ticket/393</a>.
</li>
<li>
February 7, 2010 by Michael Wetter:<br/>
Simplified model and its base classes by removing the port data
and the vessel area.
Eliminated the base class <code>PartialLumpedVessel</code>.
</li>
<li>
October 12, 2009 by Michael Wetter:<br/>
Changed base class to
<a href=\"modelica://Annex60.Fluid.MixingVolumes.BaseClasses.ClosedVolume\">
Annex60.Fluid.MixingVolumes.BaseClasses.ClosedVolume</a>.
</li>
</ul>
</html>"),Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
                  100}}), graphics={Ellipse(
                extent={{-100,98},{100,-102}},
                lineColor={0,0,0},
                fillPattern=FillPattern.Sphere,
                fillColor={170,213,255}), Text(
                extent={{-58,14},{58,-18}},
                lineColor={0,0,0},
                textString="V=%V"),         Text(
                extent={{-152,100},{148,140}},
                textString="%name",
                lineColor={0,0,255})}),
          Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
                  100}}),     graphics));
      end MixingVolume;

      package BaseClasses
      "Package with base classes for Annex60.Fluid.MixingVolumes"
        extends Modelica.Icons.BasesPackage;

        partial model PartialMixingVolume
        "Partial mixing volume with inlet and outlet ports (flow reversal is allowed)"
          outer Modelica.Fluid.System system "System properties";
          extends Annex60.Fluid.Interfaces.LumpedVolumeDeclarations;
          parameter Modelica.SIunits.MassFlowRate m_flow_nominal(min=0)
          "Nominal mass flow rate"
            annotation(Dialog(group = "Nominal condition"));
          // Port definitions
          parameter Integer nPorts=0 "Number of ports"
            annotation(Evaluate=true, Dialog(connectorSizing=true, tab="General",group="Ports"));
          parameter Modelica.SIunits.MassFlowRate m_flow_small(min=0) = 1E-4*abs(m_flow_nominal)
          "Small mass flow rate for regularization of zero flow"
            annotation(Dialog(tab = "Advanced"));
          parameter Boolean allowFlowReversal = system.allowFlowReversal
          "= true to allow flow reversal in medium, false restricts to design direction (ports[1] -> ports[2]). Used only if model has two ports."
            annotation(Dialog(tab="Assumptions"), Evaluate=true);
          parameter Modelica.SIunits.Volume V "Volume";
          parameter Boolean prescribedHeatFlowRate=false
          "Set to true if the model has a prescribed heat flow at its heatPort"
           annotation(Evaluate=true, Dialog(tab="Assumptions",
              enable=use_HeatTransfer,
              group="Heat transfer"));
          Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b ports[nPorts](
              redeclare each package Medium = Medium)
          "Fluid inlets and outlets"
            annotation (Placement(transformation(extent={{-40,-10},{40,10}},
              origin={0,-100})));
          Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
          "Heat port connected to outflowing medium"
            annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
          Modelica.SIunits.Temperature T "Temperature of the fluid";
          Modelica.SIunits.Pressure p "Pressure of the fluid";
          Modelica.SIunits.MassFraction Xi[Medium.nXi]
          "Species concentration of the fluid";
          Medium.ExtraProperty C[Medium.nC](nominal=C_nominal)
          "Trace substance mixture content";
           // Models for the steady-state and dynamic energy balance.
      protected
          Annex60.Fluid.Interfaces.StaticTwoPortConservationEquation steBal(
            sensibleOnly = true,
            redeclare final package Medium=Medium,
            final m_flow_nominal = m_flow_nominal,
            final allowFlowReversal = allowFlowReversal,
            final m_flow_small = m_flow_small) if
                useSteadyStateTwoPort
          "Model for steady-state balance if nPorts=2"
                annotation (Placement(transformation(extent={{-20,0},{0,20}})));
          Annex60.Fluid.Interfaces.ConservationEquation dynBal(
            redeclare final package Medium = Medium,
            final energyDynamics=energyDynamics,
            final massDynamics=massDynamics,
            final p_start=p_start,
            final T_start=T_start,
            final X_start=X_start,
            final C_start=C_start,
            final C_nominal=C_nominal,
            final fluidVolume = V,
            m(start=V*rho_start),
            U(start=V*rho_start*u_start),
            nPorts=nPorts) if
                not useSteadyStateTwoPort "Model for dynamic energy balance"
            annotation (Placement(transformation(extent={{40,0},{60,20}})));

          // Density at medium default values, used to compute the size of control volumes
          parameter Modelica.SIunits.Density rho_default=Medium.density(
            state=state_default) "Density, used to compute fluid mass"
          annotation (Evaluate=true);
          // Density at start values, used to compute initial values and start guesses
          parameter Modelica.SIunits.Density rho_start=Medium.density(
           state=state_start) "Density, used to compute start and guess values"
          annotation (Evaluate=true);

          parameter Modelica.SIunits.SpecificInternalEnergy u_start=
            Medium.specificInternalEnergy(Medium.setState_pTX(
              T=T_start,
              p=p_start,
              X=X_start[1:Medium.nXi]))
          "Start value for specific internal energy";
          final parameter Medium.ThermodynamicState state_default = Medium.setState_pTX(
              T=Medium.T_default,
              p=Medium.p_default,
              X=Medium.X_default[1:Medium.nXi])
          "Medium state at default values";
          final parameter Medium.ThermodynamicState state_start = Medium.setState_pTX(
              T=T_start,
              p=p_start,
              X=X_start[1:Medium.nXi]) "Medium state at start values";
          final parameter Boolean useSteadyStateTwoPort=(nPorts == 2) and
              prescribedHeatFlowRate and (
              energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) and (
              massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) and (
              substanceDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) and (
              traceDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)
          "Flag, true if the model has two ports only and uses a steady state balance"
            annotation (Evaluate=true);
          Modelica.SIunits.HeatFlowRate Q_flow
          "Heat flow across boundaries or energy source/sink";
          // Outputs that are needed to assign the medium properties
          Modelica.Blocks.Interfaces.RealOutput hOut_internal(unit="J/kg")
          "Internal connector for leaving temperature of the component";
          Modelica.Blocks.Interfaces.RealOutput XiOut_internal[Medium.nXi](each unit="1")
          "Internal connector for leaving species concentration of the component";
          Modelica.Blocks.Interfaces.RealOutput COut_internal[Medium.nC](each unit="1")
          "Internal connector for leaving trace substances of the component";

        equation
          ///////////////////////////////////////////////////////////////////////////
          // asserts
          if not allowFlowReversal then
            assert(ports[1].m_flow > -m_flow_small,
        "Model has flow reversal, but the parameter allowFlowReversal is set to false.
  m_flow_small    = "         + String(m_flow_small) + "
  ports[1].m_flow = "         + String(ports[1].m_flow) + "
");
          end if;
          // actual definition of port variables
          // If the model computes the energy and mass balances as steady-state,
          // and if it has only two ports,
          // then we use the same base class as for all other steady state models.
          if useSteadyStateTwoPort then
          connect(steBal.port_a, ports[1]) annotation (Line(
              points={{-20,10},{-22,10},{-22,-60},{0,-60},{0,-100}},
              color={0,127,255},
              smooth=Smooth.None));

          connect(steBal.port_b, ports[2]) annotation (Line(
              points={{5.55112e-16,10},{8,10},{8,10},{8,-88},{0,-88},{0,-100}},
              color={0,127,255},
              smooth=Smooth.None));

            connect(hOut_internal,  steBal.hOut);
            connect(XiOut_internal, steBal.XiOut);
            connect(COut_internal,  steBal.COut);
          else
              connect(dynBal.ports, ports) annotation (Line(
              points={{50,-5.55112e-16},{50,-34},{2.22045e-15,-34},{2.22045e-15,-100}},
              color={0,127,255},
              smooth=Smooth.None));

            connect(hOut_internal,  dynBal.hOut);
            connect(XiOut_internal, dynBal.XiOut);
            connect(COut_internal,  dynBal.COut);
          end if;
          // Medium properties
          p = if nPorts > 0 then ports[1].p else p_start;
          T = Medium.temperature_phX(p=p, h=hOut_internal, X=cat(1,Xi,{1-sum(Xi)}));
          Xi = XiOut_internal;
          C = COut_internal;
          // Port properties
          heatPort.T = T;
          heatPort.Q_flow = Q_flow;

          annotation (
        defaultComponentName="vol",
        Documentation(info="<html>
<p>
This is a partial model of an instantaneously mixed volume.
It is used as the base class for all fluid volumes of the package
<a href=\"modelica://Annex60.Fluid.MixingVolumes\">
Annex60.Fluid.MixingVolumes</a>.
</p>

<h4>Implementation</h4>
<p>
If the model is operated in steady-state and has two fluid ports connected,
then the same energy and mass balance implementation is used as in
steady-state component models, i.e., the use of <code>actualStream</code>
is not used for the properties at the port.
</p>
<p>
For simple models that uses this model, see
<a href=\"modelica://Annex60.Fluid.MixingVolumes\">
Annex60.Fluid.MixingVolumes</a>.
</p>
</html>",         revisions="<html>
<ul>
<li>
October 8, 2013 by Michael Wetter:<br/>
Removed propagation of <code>show_V_flow</code>
to instance <code>steBal</code> as it has no longer this parameter.
</li>
<li>
September 13, 2013 by Michael Wetter:<br/>
Renamed <code>rho_nominal</code> to <code>rho_start</code>
because this quantity is computed using start values and not
nominal values.
</li>
<li>
April 18, 2013 by Michael Wetter:<br/>
Removed the check of multiple connections to the same element
of a fluid port, as this check required the use of the deprecated
<code>cardinality</code> function.
</li>
<li>
February 7, 2012 by Michael Wetter:<br/>
Revised base classes for conservation equations in <code>Annex60.Fluid.Interfaces</code>.
</li>
<li>
September 17, 2011 by Michael Wetter:<br/>
Removed instance <code>medium</code> as this is already used in <code>dynBal</code>.
Removing the base properties led to 30% faster computing time for a solar thermal system
that contains many fluid volumes. 
</li>
<li>
September 13, 2011 by Michael Wetter:<br/>
Changed in declaration of <code>medium</code> the parameter assignment
<code>preferredMediumStates=true</code> to
<code>preferredMediumStates= not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)</code>.
Otherwise, for a steady-state model, Dymola 2012 may differentiate the model to obtain <code>T</code>
as a state. See ticket Dynasim #13596.
</li>
<li>
July 26, 2011 by Michael Wetter:<br/>
Revised model to use new declarations from
<a href=\"Annex60.Fluid.Interfaces.LumpedVolumeDeclarations\">
Annex60.Fluid.Interfaces.LumpedVolumeDeclarations</a>.
</li>
<li>
July 14, 2011 by Michael Wetter:<br/>
Added start values for mass and internal energy of dynamic balance
model.
</li>
<li>
May 25, 2011 by Michael Wetter:<br/>
<ul>
<li>
Changed implementation of balance equation. The new implementation uses a different model if 
exactly two fluid ports are connected, and in addition, the model is used as a steady-state
component. For this model configuration, the same balance equations are used as were used
for steady-state component models, i.e., instead of <code>actualStream(...)</code>, the
<code>inStream(...)</code> formulation is used.
This changed required the introduction of a new parameter <code>m_flow_nominal</code> which
is used for smoothing in the steady-state balance equations of the model with two fluid ports.
This implementation also simplifies the implementation of 
<a href=\"modelica://Annex60.Fluid.MixingVolumes.BaseClasses.PartialMixingVolumeWaterPort\">
Annex60.Fluid.MixingVolumes.BaseClasses.PartialMixingVolumeWaterPort</a>,
which now uses the same equations as this model.
</li>
<li>
Another revision was the removal of the parameter <code>use_HeatTransfer</code> as there is
no noticable overhead in always having the <code>heatPort</code> connector present.
</li>
</ul>
</li>
<li>
July 30, 2010 by Michael Wetter:<br/>
Added nominal value for <code>mC</code> to avoid wrong trajectory 
when concentration is around 1E-7.
See also <a href=\"https://trac.modelica.org/Modelica/ticket/393\">
https://trac.modelica.org/Modelica/ticket/393</a>.
</li>
<li>
February 7, 2010 by Michael Wetter:<br/>
Simplified model and its base classes by removing the port data
and the vessel area.
Eliminated the base class <code>PartialLumpedVessel</code>.
</li>
<li>
October 12, 2009 by Michael Wetter:<br/>
Changed base class to
<a href=\"modelica://Annex60.Fluid.MixingVolumes.BaseClasses.ClosedVolume\">
Annex60.Fluid.MixingVolumes.BaseClasses.ClosedVolume</a>.
</li>
</ul>
</html>"),  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
                    100}}), graphics={Ellipse(
                  extent={{-100,98},{100,-102}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.Sphere,
                  fillColor={170,213,255}), Text(
                  extent={{-58,14},{58,-18}},
                  lineColor={0,0,0},
                  textString="V=%V"),         Text(
                  extent={{-152,100},{148,140}},
                  textString="%name",
                  lineColor={0,0,255})}));
        end PartialMixingVolume;
      annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains base classes that are used to construct the models in
<a href=\"modelica://Annex60.Fluid.MixingVolumes\">Annex60.Fluid.MixingVolumes</a>.
</p>
</html>"));
      end BaseClasses;
    annotation (Documentation(info="<html>
<p>
This package contains models for completely mixed volumes.
</p>
<p>
For most situations, the model
<a href=\"modelica://Annex60.Fluid.MixingVolumes.MixingVolume\">
Annex60.Fluid.MixingVolumes.MixingVolume</a> should be used.
The other models are only of interest if water should be added to
or subtracted from the fluid volume, such as in a 
coil with water vapor condensation.
</p>
</html>"));
    end MixingVolumes;

    package BaseClasses "Package with base classes for Annex60.Fluid"
      extends Modelica.Icons.BasesPackage;

      package FlowModels "Flow models for pressure drop calculations"
        extends Modelica.Icons.BasesPackage;

        function basicFlowFunction_dp "Basic class for flow models"

          input Modelica.SIunits.Pressure dp(displayUnit="Pa")
          "Pressure difference between port_a and port_b (= port_a.p - port_b.p)";
          input Real k(min=0, unit="")
          "Flow coefficient, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)";
          input Modelica.SIunits.MassFlowRate m_flow_turbulent(min=0)
          "Mass flow rate";
          output Modelica.SIunits.MassFlowRate m_flow
          "Mass flow rate in design flow direction";
      protected
          Modelica.SIunits.Pressure dp_turbulent(displayUnit="Pa")
          "Turbulent flow if |dp| >= dp_small, not a parameter because k can be a function of time";
      protected
         Real kSqu(unit="kg.m") "Flow coefficient, kSqu=k^2=m_flow^2/|dp|";
        algorithm
         kSqu:=k*k;
         dp_turbulent :=m_flow_turbulent^2/kSqu;
         m_flow :=Modelica.Fluid.Utilities.regRoot2(x=dp, x_small=dp_turbulent, k1=kSqu, k2=kSqu);

        annotation(LateInline=true,
                   inverse(dp=Annex60.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(m_flow=m_flow, k=k, m_flow_turbulent=m_flow_turbulent)),
                   smoothOrder=2,
                   Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
                    {100,100}}), graphics={Line(
                  points={{-80,-40},{-80,60},{80,-40},{80,60}},
                  color={0,0,255},
                  smooth=Smooth.None,
                  thickness=1), Text(
                  extent={{-40,-40},{40,-80}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.Sphere,
                  fillColor={232,0,0},
                  textString="%name")}),
        Documentation(info="<html>
<p>
Function that computes the pressure drop of flow elements as
</p>
<p align=\"center\" style=\"font-style:italic;\">
  m = sign(&Delta;p) k  &radic;<span style=\"text-decoration:overline;\">&nbsp;&Delta;p &nbsp;</span>
</p>
<p>
with regularization near the origin.
Therefore, the flow coefficient is
</p>
<p align=\"center\" style=\"font-style:italic;\">
  k = m &frasl; &radic;<span style=\"text-decoration:overline;\">&nbsp;&Delta;p &nbsp;</span> 
</p>
<p>
The input <code>m_flow_turbulent</code> determines the location of the regularization.
</p>
</html>",         revisions="<html>
<ul>
<li>
August 10, 2011, by Michael Wetter:<br/>
Removed <code>if-then</code> optimization that set <code>m_flow=0</code> if <code>dp=0</code>,
as this causes the derivative to be discontinuous at <code>dp=0</code>.
</li>
<li>
August 4, 2011, by Michael Wetter:<br/>
Implemented linearized model in this model instead of 
in the functions
<a href=\"modelica://Annex60.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp\">
Annex60.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp</a>
and
<a href=\"modelica://Annex60.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow\">
Annex60.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow</a>. 
With the previous implementation, 
the symbolic processor may not rearrange the equations, which can lead 
to coupled equations instead of an explicit solution.
</li>
<li>
March 29, 2010 by Michael Wetter:<br/>
Changed implementation to allow <code>k=0</code>, which is
the case for a closed valve with no leakage
</li>
</ul>
</html>"),
        revisions="<html>
<ul>
<li>
August 4, 2011, by Michael Wetter:<br/>
Removed option to use a linear function. The linear implementation is now done
in models that call this function. With the previous implementation, 
the symbolic processor may not rearrange the equations, which can lead 
to coupled equations instead of an explicit solution.
</li>
<li>
April 13, 2009, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>");
        end basicFlowFunction_dp;

        function basicFlowFunction_m_flow "Basic class for flow models"

          input Modelica.SIunits.MassFlowRate m_flow
          "Mass flow rate in design flow direction";
          input Real k(unit="")
          "Flow coefficient, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)";
          input Modelica.SIunits.MassFlowRate m_flow_turbulent(min=0)
          "Mass flow rate";
          output Modelica.SIunits.Pressure dp(displayUnit="Pa")
          "Pressure difference between port_a and port_b (= port_a.p - port_b.p)";
      protected
         Real kSquInv(unit="1/(kg.m)") "Flow coefficient";
        algorithm
         kSquInv:=1/k^2;
         dp :=Modelica.Fluid.Utilities.regSquare2(x=m_flow, x_small=m_flow_turbulent, k1=kSquInv, k2=kSquInv);

         annotation (LateInline=true,
                     inverse(m_flow=Annex60.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(dp=dp, k=k, m_flow_turbulent=m_flow_turbulent)),
                     smoothOrder=2,
                     Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                    -100},{100,100}}), graphics={Line(
                  points={{-80,-40},{-80,60},{80,-40},{80,60}},
                  color={0,0,255},
                  smooth=Smooth.None,
                  thickness=1), Text(
                  extent={{-40,-40},{40,-80}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.Sphere,
                  fillColor={232,0,0},
                  textString="%name")}),
        Documentation(info="<html>
<p>
Function that computes the pressure drop of flow elements as
</p>
<p align=\"center\" style=\"font-style:italic;\">
  &Delta;p = sign(m) (m &frasl; k)<sup>2</sup> 
</p>
<p>
with regularization near the origin.
Therefore, the flow coefficient is
</p>
<p align=\"center\" style=\"font-style:italic;\">
  k = m &frasl; &radic;<span style=\"text-decoration:overline;\">&nbsp;&Delta;p &nbsp;</span> 
</p>
<p>
The input <code>m_flow_turbulent</code> determines the location of the regularization.
</p>
</html>"),
        revisions="<html>
<ul>
<li>
August 10, 2011, by Michael Wetter:<br/>
Removed <code>if-then</code> optimization that set <code>dp=0</code> if <code>m_flow=0</code>,
as this causes the derivative to be discontinuous at <code>m_flow=0</code>.
</li>
<li>
August 4, 2011, by Michael Wetter:<br/>
Removed option to use a linear function. The linear implementation is now done
in models that call this function. With the previous implementation, 
the symbolic processor may not rearrange the equations, which can lead 
to coupled equations instead of an explicit solution.
</li>
<li>
April 13, 2009, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>");
        end basicFlowFunction_m_flow;
      annotation (Documentation(info="<html>
This package contains a basic flow model that is used by the 
various models that compute pressure drop.
Because the density does not change signficantly in heating,
ventilation and air conditioning systems for buildings,
this model computes the pressure drop based on the mass flow
rate and not the volume flow rate. This typically leads to simpler
equations because it does not require
the mass density, which changes when the flow is reversed. 
Although, for conceptual design of building energy system, there is
in general not enough information available that would warrant a more
detailed pressure drop calculation.
If a more detailed computation of the flow resistance is needed,
then a user can use models from the 
<code>Modelica.Fluid</code> library.
</html>",       revisions="<html>
<ul>
<li>
April 10, 2009 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
      end FlowModels;

      partial model PartialResistance
      "Partial model for a hydraulic resistance"
          extends Annex60.Fluid.Interfaces.PartialTwoPortInterface(
           show_T=false,
           m_flow(start=0, nominal=m_flow_nominal_pos),
           dp(start=0, nominal=dp_nominal_pos),
           final m_flow_small = 1E-4*abs(m_flow_nominal));

        parameter Boolean from_dp = false
        "= true, use m_flow = f(dp) else dp = f(m_flow)"
          annotation (Evaluate=true, Dialog(tab="Advanced"));

        parameter Modelica.SIunits.Pressure dp_nominal(displayUnit="Pa")
        "Pressure drop at nominal mass flow rate"                                  annotation(Dialog(group = "Nominal condition"));
        parameter Boolean homotopyInitialization = true
        "= true, use homotopy method"
          annotation(Evaluate=true, Dialog(tab="Advanced"));
        parameter Boolean linearized = false
        "= true, use linear relation between m_flow and dp for any flow rate"
          annotation(Evaluate=true, Dialog(tab="Advanced"));

        parameter Modelica.SIunits.MassFlowRate m_flow_turbulent(min=0)
        "Turbulent flow if |m_flow| >= m_flow_turbulent";

    protected
        parameter Medium.ThermodynamicState sta_default=
           Medium.setState_pTX(T=Medium.T_default, p=Medium.p_default, X=Medium.X_default);
        parameter Modelica.SIunits.DynamicViscosity eta_default=Medium.dynamicViscosity(sta_default)
        "Dynamic viscosity, used to compute transition to turbulent flow regime";
    protected
        final parameter Modelica.SIunits.MassFlowRate m_flow_nominal_pos = abs(m_flow_nominal)
        "Absolute value of nominal flow rate";
        final parameter Modelica.SIunits.Pressure dp_nominal_pos = abs(dp_nominal)
        "Absolute value of nominal pressure";
      equation
        // Isenthalpic state transformation (no storage and no loss of energy)
        port_a.h_outflow = inStream(port_b.h_outflow);
        port_b.h_outflow = inStream(port_a.h_outflow);

        // Mass balance (no storage)
        port_a.m_flow + port_b.m_flow = 0;

        // Transport of substances
        port_a.Xi_outflow = inStream(port_b.Xi_outflow);
        port_b.Xi_outflow = inStream(port_a.Xi_outflow);

        port_a.C_outflow = inStream(port_b.C_outflow);
        port_b.C_outflow = inStream(port_a.C_outflow);

        annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                  -100},{100,100}}), graphics={
              Rectangle(
                extent={{-100,40},{100,-42}},
                lineColor={0,0,0},
                fillPattern=FillPattern.HorizontalCylinder,
                fillColor={192,192,192}),
              Rectangle(
                extent={{-100,22},{100,-24}},
                lineColor={0,0,0},
                fillPattern=FillPattern.HorizontalCylinder,
                fillColor={0,127,255}),
              Rectangle(
                visible=linearized,
                extent={{-100,22},{100,-24}},
                fillPattern=FillPattern.Backward,
                fillColor={0,128,255},
                pattern=LinePattern.None,
                lineColor={255,255,255})}),
                defaultComponentName="res",
      Documentation(info="<html>
<p>
Partial model for a flow resistance, possible with variable flow coefficient.
Models that extend this class need to implement an equation that relates
<code>m_flow</code> and <code>dp</code>, and they need to assign the parameter
<code>m_flow_turbulent</code>.
</p>
<p>
See for example
<a href=\"modelica://Annex60.Fluid.FixedResistances.FixedResistanceDpM\">
Annex60.Fluid.FixedResistances.FixedResistanceDpM</a> for a model that extends
this base class.
</p>
</html>",       revisions="<html>
<ul>
<li>
October 8, 2013 by Michael Wetter:<br/>
Removed propagation of <code>show_V_flow</code>
to base class as it has no longer this parameter.
</li>
<li>
December 14, 2012 by Michael Wetter:<br/>
Renamed protected parameters for consistency with the naming conventions.
</li>
<li>
February 12, 2012, by Michael Wetter:<br/>
Removed duplicate declaration of <code>m_flow_nominal</code>.
</li>
<li>
February 3, 2012, by Michael Wetter:<br/>
Made assignment of <code>m_flow_small</code> <code>final</code> as it is no
longer used in the base class.
</li>
<li>
January 16, 2012, by Michael Wetter:<br/>
To simplify object inheritance tree, revised base classes
<code>Annex60.Fluid.BaseClasses.PartialResistance</code>,
<code>Annex60.Fluid.Actuators.BaseClasses.PartialTwoWayValve</code>,
<code>Annex60.Fluid.Actuators.BaseClasses.PartialDamperExponential</code>,
<code>Annex60.Fluid.Actuators.BaseClasses.PartialActuator</code>
and model
<code>Annex60.Fluid.FixedResistances.FixedResistanceDpM</code>.
</li>
<li>
August 5, 2011, by Michael Wetter:<br/>
Moved linearized pressure drop equation from the function body to the equation
section. With the previous implementation, 
the symbolic processor may not rearrange the equations, which can lead 
to coupled equations instead of an explicit solution.
</li>
<li>
June 20, 2011, by Michael Wetter:<br/>
Set start values for <code>m_flow</code> and <code>dp</code> to zero, since
most HVAC systems start at zero flow. With this change, the start values
appear in the GUI and can be set by the user.
</li>
<li>
April 2, 2011 by Michael Wetter:<br/>
Added <code>m_flow_nominal_pos</code> and <code>dp_nominal_pos</code> to allow
providing negative nominal values which will be used, for example, to set start
values of flow splitters which may have negative flow rates and pressure drop
at the initial condition.
</li>
<li>
March 23, 2011 by Michael Wetter:<br/>
Added homotopy operator.
</li>
<li>
March 30, 2010 by Michael Wetter:<br/>
Changed base classes to allow easier initialization.
</li>
<li>
July 20, 2007 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
      revisions="<html>
<ul>
<li>
March 27, 2011, by Michael Wetter:<br/>
Added <code>homotopy</code> operator.
</li>
<li>
April 13, 2009, by Michael Wetter:<br/>
Extracted pressure drop computation and implemented it in the
new model
<a href=\"modelica://Annex60.Fluid.BaseClasses.FlowModels.BasicFlowModel\">
Annex60.Fluid.BaseClasses.FlowModels.BasicFlowModel</a>.
</li>
<li>
September 18, 2008, by Michael Wetter:<br/>
Added equations for the mass balance of extra species flow,
i.e., <code>C</code> and <code>mC_flow</code>.
</li>
<li>
July 20, 2007 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>");
      end PartialResistance;
    annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains base classes that are used to construct the models in
<a href=\"modelica://Annex60.Fluid\">Annex60.Fluid</a>.
</p>
</html>"));
    end BaseClasses;

    package Interfaces "Package with interfaces for fluid models"
      extends Modelica.Icons.InterfacesPackage;

      model TwoPortHeatMassExchanger
      "Partial model transporting one fluid stream with storing mass or energy"
        extends Annex60.Fluid.Interfaces.PartialTwoPortInterface(
          port_a(h_outflow(start=h_outflow_start)),
          port_b(h_outflow(start=h_outflow_start)));
        extends Annex60.Fluid.Interfaces.TwoPortFlowResistanceParameters(
          final computeFlowResistance=true);

        parameter Modelica.SIunits.Time tau = 30
        "Time constant at nominal flow (if energyDynamics <> SteadyState)"
           annotation (Evaluate=true, Dialog(tab = "Dynamics", group="Nominal condition"));

        // Advanced
        parameter Boolean homotopyInitialization = true
        "= true, use homotopy method"
          annotation(Evaluate=true, Dialog(tab="Advanced"));

        // Dynamics
        parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
        "Formulation of energy balance"
          annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
        parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
        "Formulation of mass balance"
          annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));

        // Initialization
        parameter Medium.AbsolutePressure p_start = Medium.p_default
        "Start value of pressure"
          annotation(Dialog(tab = "Initialization"));
        parameter Medium.Temperature T_start = Medium.T_default
        "Start value of temperature"
          annotation(Dialog(tab = "Initialization"));
        parameter Medium.MassFraction X_start[Medium.nX] = Medium.X_default
        "Start value of mass fractions m_i/m"
          annotation (Dialog(tab="Initialization", enable=Medium.nXi > 0));
        parameter Medium.ExtraProperty C_start[Medium.nC](
             quantity=Medium.extraPropertiesNames)=fill(0, Medium.nC)
        "Start value of trace substances"
          annotation (Dialog(tab="Initialization", enable=Medium.nC > 0));

        replaceable Annex60.Fluid.MixingVolumes.MixingVolume vol
        constrainedby
        Annex60.Fluid.MixingVolumes.BaseClasses.PartialMixingVolume(
          redeclare final package Medium = Medium,
          nPorts = 2,
          V=m_flow_nominal*tau/rho_default,
          final m_flow_nominal = m_flow_nominal,
          final energyDynamics=energyDynamics,
          final massDynamics=massDynamics,
          final p_start=p_start,
          final T_start=T_start,
          final X_start=X_start,
          final C_start=C_start) "Volume for fluid stream"
           annotation (Placement(transformation(extent={{-9,0},{11,-20}},
               rotation=0)));

        Annex60.Fluid.FixedResistances.FixedResistanceDpM preDro(
          redeclare package Medium = Medium,
          final use_dh=false,
          final m_flow_nominal=m_flow_nominal,
          final deltaM=deltaM,
          final allowFlowReversal=allowFlowReversal,
          final show_T=false,
          final from_dp=from_dp,
          final linearized=linearizeFlowResistance,
          final homotopyInitialization=homotopyInitialization,
          final dp_nominal=dp_nominal) "Pressure drop model"
          annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

    protected
        parameter Medium.ThermodynamicState sta_default=Medium.setState_pTX(
            T=Medium.T_default, p=Medium.p_default, X=Medium.X_default);
        parameter Modelica.SIunits.Density rho_default=Medium.density(sta_default)
        "Density, used to compute fluid volume";
        parameter Medium.ThermodynamicState sta_start=Medium.setState_pTX(
            T=T_start, p=p_start, X=X_start);
        parameter Modelica.SIunits.SpecificEnthalpy h_outflow_start = Medium.specificEnthalpy(sta_start)
        "Start value for outflowing enthalpy";

      initial algorithm
        assert((energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) or
                tau > Modelica.Constants.eps,
      "The parameter tau, or the volume of the model from which tau may be derived, is unreasonably small.
 Set energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState to model steady-state.
 Received tau = "       + String(tau) + "\n");
        assert((massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) or
                tau > Modelica.Constants.eps,
      "The parameter tau, or the volume of the model from which tau may be derived, is unreasonably small.          
 Set massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState to model steady-state.
 Received tau = "       + String(tau) + "\n");

      equation
        connect(vol.ports[2], port_b) annotation (Line(
            points={{1,0},{100,0}},
            color={0,127,255},
            smooth=Smooth.None));
        connect(port_a, preDro.port_a) annotation (Line(
            points={{-100,0},{-90,0},{-90,0},{-80,0},{-80,0},{-60,0}},
            color={0,127,255},
            smooth=Smooth.None));
        connect(preDro.port_b, vol.ports[1]) annotation (Line(
            points={{-40,0},{1,0}},
            color={0,127,255},
            smooth=Smooth.None));
        annotation (
          Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={1,1})),
          Documentation(info="<html>
<p>
This component transports one fluid stream. 
It provides the basic model for implementing dynamic and steady-state
models that exchange heat and water vapor with the fluid stream.
The model also computes the pressure drop due to the flow resistance.
By setting the parameter <code>dp_nominal=0</code>, the computation
of the pressure drop can be avoided.
The variable <code>vol.heatPort.T</code> always has the value of
the temperature of the medium that leaves the component.
For the actual temperatures at the port, the variables <code>sta_a.T</code>
and <code>sta_b.T</code> can be used. These two variables are provided by 
the base class
<a href=\"modelica://Annex60.Fluid.Interfaces.PartialTwoPortInterface\">
Annex60.Fluid.Interfaces.PartialTwoPortInterface</a>.
</p>

For models that extend this model, see for example
<ul>
<li>
the ideal heater or cooler
<a href=\"modelica://Annex60.Fluid.HeatExchangers.HeaterCoolerPrescribed\">
Annex60.Fluid.HeatExchangers.HeaterCoolerPrescribed</a>,
</li>
<li>
the ideal humidifier
<a href=\"modelica://Annex60.Fluid.MassExchangers.HumidifierPrescribed\">
Annex60.Fluid.MassExchangers.HumidifierPrescribed</a>, and
</li>
<li>
the boiler
<a href=\"modelica://Annex60.Fluid.Boilers.BoilerPolynomial\">
Annex60.Fluid.Boilers.BoilerPolynomial</a>.
</li>
</ul>

<h4>Implementation</h4>
<p>
The variable names follow the conventions used in 
<a href=\"modelica://Modelica.Fluid.Examples.HeatExchanger.BaseClasses.BasicHX\">
Modelica.Fluid.Examples.HeatExchanger.BaseClasses.BasicHX
</a>.
</p>
</html>",       revisions="<html>
<ul>
<li>
November 12, 2013, by Michael Wetter:<br/>
Removed <code>import Modelica.Constants</code> statement.
</li>
<li>
October 8, 2013, by Michael Wetter:<br/>
Removed parameter <code>show_V_flow</code>.
</li>
<li>
December 14, 2012 by Michael Wetter:<br/>
Renamed protected parameters for consistency with the naming conventions.
</li>
<li>
October 17, 2012, by Michael Wetter:<br/>
Fixed broken link in documentation.
</li>
<li>
February 3, 2012, by Michael Wetter:<br/>
Removed assignment of <code>m_flow_small</code> as it is no
longer used in the pressure drop model.
</li>
<li>
January 15, 2011, by Michael Wetter:<br/>
Fixed wrong class reference in information section.
</li>
<li>
September 13, 2011, by Michael Wetter:<br/>
Changed assignment of <code>vol(mass/energyDynamics=...)</code> as the
previous assignment caused a non-literal start value that was ignored.
</li>
<li>
July 29, 2011, by Michael Wetter:<br/>
Added start value for outflowing enthalpy.
</li>
<li>
July 11, 2011, by Michael Wetter:<br/>
Changed parameterization of fluid volume so that steady-state balance is
used when <code>tau = 0</code>.
</li>
<li>
May 25, 2011, by Michael Wetter:<br/>
Removed temperature sensor and changed implementation of fluid volume
to allow use of this model for the steady-state and dynamic humidifier
<a href=\"modelica://Annex60.Fluid.MassExchangers.HumidifierPrescribed\">
Annex60.Fluid.MassExchangers.HumidifierPrescribed</a>.
</li>
<li>
March 25, 2011, by Michael Wetter:<br/>
Added homotopy operator.
</li>
<li>
March 21, 2010 by Michael Wetter:<br/>
Changed pressure start value from <code>system.p_start</code>
to <code>Medium.p_default</code> since HVAC models may have water and 
air, which are typically at different pressures.
</li>
<li>
April 13, 2009, by Michael Wetter:<br/>
Added model to compute flow friction.
</li>
<li>
January 29, 2009 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),Icon(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={1,1}), graphics={
              Rectangle(
                extent={{-70,60},{70,-60}},
                lineColor={0,0,255},
                pattern=LinePattern.None,
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid),
              Rectangle(
                extent={{-101,6},{100,-4}},
                lineColor={0,0,255},
                pattern=LinePattern.None,
                fillColor={0,0,255},
                fillPattern=FillPattern.Solid),
              Rectangle(
                extent={{0,-4},{100,6}},
                lineColor={0,0,255},
                pattern=LinePattern.None,
                fillColor={255,0,0},
                fillPattern=FillPattern.Solid)}));
      end TwoPortHeatMassExchanger;

      partial model PartialTwoPortInterface
      "Partial model transporting fluid between two ports without storing mass or energy"
        extends Modelica.Fluid.Interfaces.PartialTwoPort(
          port_a(p(start=Medium.p_default,
                   nominal=Medium.p_default)),
          port_b(p(start=Medium.p_default,
                 nominal=Medium.p_default)));

        parameter Modelica.SIunits.MassFlowRate m_flow_nominal
        "Nominal mass flow rate"
          annotation(Dialog(group = "Nominal condition"));
        parameter Modelica.SIunits.MassFlowRate m_flow_small(min=0) = 1E-4*abs(m_flow_nominal)
        "Small mass flow rate for regularization of zero flow"
          annotation(Dialog(tab = "Advanced"));
        // Diagnostics
         parameter Boolean show_T = false
        "= true, if actual temperature at port is computed"
          annotation(Dialog(tab="Advanced",group="Diagnostics"));

        Modelica.SIunits.MassFlowRate m_flow(start=0) = port_a.m_flow
        "Mass flow rate from port_a to port_b (m_flow > 0 is design flow direction)";
        Modelica.SIunits.Pressure dp(start=0, displayUnit="Pa")
        "Pressure difference between port_a and port_b";

        Medium.ThermodynamicState sta_a=
            Medium.setState_phX(port_a.p,
                                noEvent(actualStream(port_a.h_outflow)),
                                noEvent(actualStream(port_a.Xi_outflow))) if
               show_T "Medium properties in port_a";

        Medium.ThermodynamicState sta_b=
            Medium.setState_phX(port_b.p,
                                noEvent(actualStream(port_b.h_outflow)),
                                noEvent(actualStream(port_b.Xi_outflow))) if
                show_T "Medium properties in port_b";
      equation
        dp = port_a.p - port_b.p;
        annotation (
          preferredView="info",
          Diagram(coordinateSystem(
              preserveAspectRatio=false,
              extent={{-100,-100},{100,100}},
              grid={1,1})),
          Documentation(info="<html>
<p>
This component defines the interface for models that 
transports a fluid between two ports. It is similar to 
<a href=\"Modelica://Modelica.Fluid.Interfaces.PartialTwoPortTransport\">
Modelica.Fluid.Interfaces.PartialTwoPortTransport</a>, but it does not 
include the species balance
</p> 
<pre>
  port_b.Xi_outflow = inStream(port_a.Xi_outflow);
</pre>
<p>
Thus, it can be used as a base class for a heat <i>and</i> mass transfer component
</p>
<p>
The model is used by other models in this package that add heat transfer,
mass transfer and pressure drop equations. See for example
<a href=\"modelica://Annex60.Fluid.Interfaces.StaticTwoPortHeatMassExchanger\">
Annex60.Fluid.Interfaces.StaticTwoPortHeatMassExchanger</a>.
</p>
</html>",       revisions="<html>
<ul>
<li>
November 12, 2013 by Michael Wetter:<br/>
Removed <code>import Modelica.Constants;</code> statement.
</li>
<li>
November 11, 2013 by Michael Wetter:<br/>
Removed the parameter <code>homotopyInitialization</code>
as it is no longer used in this model.
</li>
<li>
November 10, 2013 by Michael Wetter:<br/>
In the computation of <code>sta_a</code> and <code>sta_b</code>,
removed the branch that uses the homotopy operator.
The rational is that these variables are conditionally enables (because
of <code>... if show_T</code>. Therefore, the Modelica Language Specification
does not allow for these variables to be used in any equation. Hence,
the use of the homotopy operator is not needed here.
</li>
<li>
October 10, 2013 by Michael Wetter:<br/>
Added <code>noEvent</code> to the computation of the states at the port.
This is correct, because the states are only used for reporting, but not
to compute any other variable. 
Use of the states to compute other variables would violate the Modelica 
language, as conditionally removed variables must not be used in any equation.
</li>
<li>
October 8, 2013 by Michael Wetter:<br/>
Removed the computation of <code>V_flow</code> and removed the parameter
<code>show_V_flow</code>.
The reason is that the computation of <code>V_flow</code> required
the use of <code>sta_a</code> (to compute the density), 
but <code>sta_a</code> is also a variable that is conditionally
enabled. However, this was not correct Modelica syntax as conditional variables 
can only be used in a <code>connect</code>
statement, not in an assignment. Dymola 2014 FD01 beta3 is checking
for this incorrect syntax. Hence, <code>V_flow</code> was removed as its 
conditional implementation would require a rather cumbersome implementation
that uses a new connector that carries the state of the medium.
</li>
<li>
April 26, 2013 by Marco Bonvini:<br/>
Moved the definition of <code>dp</code> because it causes some problem with PyFMI.
</li>
<li>
March 27, 2012 by Michael Wetter:<br/>
Changed condition to remove <code>sta_a</code> to also
compute the state at the inlet port if <code>show_V_flow=true</code>. 
The previous implementation resulted in a translation error
if <code>show_V_flow=true</code>, but worked correctly otherwise
because the erroneous function call is removed if  <code>show_V_flow=false</code>.
</li>
<li>
March 27, 2011 by Michael Wetter:<br/>
Added <code>homotopy</code> operator.
</li>
<li>
March 21, 2010 by Michael Wetter:<br/>
Changed pressure start value from <code>system.p_start</code>
to <code>Medium.p_default</code> since HVAC models may have water and 
air, which are typically at different pressures.
</li>
<li>
September 19, 2008 by Michael Wetter:<br/>
Added equations for the mass balance of extra species flow,
i.e., <code>C</code> and <code>mC_flow</code>.
</li>
<li>
March 11, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
      end PartialTwoPortInterface;

      model ConservationEquation "Lumped volume with mass and energy balance"

      //  outer Modelica.Fluid.System system "System properties";
        extends Annex60.Fluid.Interfaces.LumpedVolumeDeclarations;
        // Port definitions
        parameter Integer nPorts=0 "Number of ports"
          annotation(Evaluate=true, Dialog(connectorSizing=true, tab="General",group="Ports"));
        Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b ports[nPorts](
            redeclare each package Medium = Medium) "Fluid inlets and outlets"
          annotation (Placement(transformation(extent={{-40,-10},{40,10}},
            origin={0,-100})));

        // Set nominal attributes where literal values can be used.
        Medium.BaseProperties medium(
          preferredMediumStates= not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState),
          p(start=p_start,
            nominal=Medium.p_default,
            stateSelect=if not (massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)
                           then StateSelect.prefer else StateSelect.default),
          h(start=hStart),
          T(start=T_start,
            nominal=Medium.T_default,
            stateSelect=if (not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState))
                           then StateSelect.prefer else StateSelect.default),
          Xi(start=X_start[1:Medium.nXi],
             nominal=Medium.X_default[1:Medium.nXi],
             each stateSelect=if (not (substanceDynamics == Modelica.Fluid.Types.Dynamics.SteadyState))
                           then StateSelect.prefer else StateSelect.default),
          d(start=rho_nominal)) "Medium properties";

        Modelica.SIunits.Energy U "Internal energy of fluid";
        Modelica.SIunits.Mass m "Mass of fluid";
        Modelica.SIunits.Mass[Medium.nXi] mXi
        "Masses of independent components in the fluid";
        Modelica.SIunits.Mass[Medium.nC] mC
        "Masses of trace substances in the fluid";
        // C need to be added here because unlike for Xi, which has medium.Xi,
        // there is no variable medium.C
        Medium.ExtraProperty C[Medium.nC](nominal=C_nominal)
        "Trace substance mixture content";

        Modelica.SIunits.MassFlowRate mb_flow "Mass flows across boundaries";
        Modelica.SIunits.MassFlowRate[Medium.nXi] mbXi_flow
        "Substance mass flows across boundaries";
        Medium.ExtraPropertyFlowRate[Medium.nC] mbC_flow
        "Trace substance mass flows across boundaries";
        Modelica.SIunits.EnthalpyFlowRate Hb_flow
        "Enthalpy flow across boundaries or energy source/sink";

        // Inputs that need to be defined by an extending class
        input Modelica.SIunits.Volume fluidVolume "Volume";

        Modelica.Blocks.Interfaces.RealInput Q_flow(unit="W")
        "Heat transfered into the medium"
          annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
        Modelica.Blocks.Interfaces.RealInput mWat_flow(unit="kg/s")
        "Moisture mass flow rate added to the medium"
          annotation (Placement(transformation(extent={{-140,0},{-100,40}})));

        // Outputs that are needed in models that extend this model
        Modelica.Blocks.Interfaces.RealOutput hOut(unit="J/kg",
                                                   start=hStart)
        "Leaving enthalpy of the component"
           annotation (Placement(transformation(extent={{-10,-10},{10,10}},
              rotation=90,
              origin={-50,110})));
        Modelica.Blocks.Interfaces.RealOutput XiOut[Medium.nXi](each unit="1",
                                                                each min=0,
                                                                each max=1)
        "Leaving species concentration of the component"
          annotation (Placement(transformation(extent={{-10,-10},{10,10}},
              rotation=90,
              origin={0,110})));
        Modelica.Blocks.Interfaces.RealOutput COut[Medium.nC](each min=0)
        "Leaving trace substances of the component"
          annotation (Placement(transformation(extent={{-10,-10},{10,10}},
              rotation=90,
              origin={50,110})));
    protected
        parameter Boolean initialize_p = not Medium.singleState
        "= true to set up initial equations for pressure";

        Medium.EnthalpyFlowRate ports_H_flow[nPorts];
        Modelica.SIunits.MassFlowRate ports_mXi_flow[nPorts,Medium.nXi];
        Medium.ExtraPropertyFlowRate ports_mC_flow[nPorts,Medium.nC];

        final parameter Medium.ThermodynamicState state_start = Medium.setState_pTX(
           p=p_start,
           T=T_start,
           X=X_start[1:Medium.nXi]) "Start value of medium state";

        parameter Modelica.SIunits.Density rho_nominal=Medium.density(
          state=state_start) "Density, used to compute fluid mass"
        annotation (Evaluate=true);

        // Parameter that is used to construct the vector mXi_flow
        final parameter Real s[Medium.nXi] = {if Modelica.Utilities.Strings.isEqual(string1=Medium.substanceNames[i],
                                                  string2="Water",
                                                  caseSensitive=false)
                                                  then 1 else 0 for i in 1:Medium.nXi}
        "Vector with zero everywhere except where species is";
        parameter Modelica.SIunits.SpecificEnthalpy hStart=
          Medium.specificEnthalpy(state_start)
        "Start value for specific enthalpy";
      initial equation
        // Assert that the substance with name 'water' has been found.
        assert(Medium.nXi == 0 or abs(sum(s)-1) < 1e-5,
            "If Medium.nXi > 1, then substance 'water' must be present for one component.'"
               + Medium.mediumName + "'.\n"
               + "Check medium model.");

        // Make sure that if energyDynamics is SteadyState, then
        // massDynamics is also SteadyState.
        // Otherwise, the system of ordinary differential equations may be inconsistent.
        if energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then
          assert(massDynamics == energyDynamics, "
         If 'massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState', then it is 
         required that 'energyDynamics==Modelica.Fluid.Types.Dynamics.SteadyState'.
         Otherwise, the system of equations may not be consistent.
         You need to select other parameter values.");
        end if;

        // initialization of balances
        if energyDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial then
            medium.T = T_start;
        else
          if energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial then
              der(medium.T) = 0;
          end if;
        end if;

        if massDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial then
          if initialize_p then
            medium.p = p_start;
          end if;
        else
          if massDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial then
            if initialize_p then
              der(medium.p) = 0;
            end if;
          end if;
        end if;

        if substanceDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial then
          medium.Xi = X_start[1:Medium.nXi];
        else
          if substanceDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial then
            der(medium.Xi) = zeros(Medium.nXi);
          end if;
        end if;

        if traceDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial then
          C = C_start[1:Medium.nC];
        else
          if traceDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial then
            der(C) = zeros(Medium.nC);
          end if;
        end if;

      equation
        // Total quantities
        m = fluidVolume*medium.d;
        mXi = m*medium.Xi;
        U = m*medium.u;
        mC = m*C;

        hOut = medium.h;
        XiOut = medium.Xi;
        COut = C;

        for i in 1:nPorts loop
          ports_H_flow[i]     = ports[i].m_flow * actualStream(ports[i].h_outflow)
          "Enthalpy flow";
          ports_mXi_flow[i,:] = ports[i].m_flow * actualStream(ports[i].Xi_outflow)
          "Component mass flow";
          ports_mC_flow[i,:]  = ports[i].m_flow * actualStream(ports[i].C_outflow)
          "Trace substance mass flow";
        end for;

        for i in 1:Medium.nXi loop
          mbXi_flow[i] = sum(ports_mXi_flow[:,i]);
        end for;

        for i in 1:Medium.nC loop
          mbC_flow[i]  = sum(ports_mC_flow[:,i]);
        end for;

        mb_flow = sum(ports.m_flow);
        Hb_flow = sum(ports_H_flow);

        // Energy and mass balances
        if energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then
          0 = Hb_flow + Q_flow;
        else
          der(U) = Hb_flow + Q_flow;
        end if;

        if massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then
          0 = mb_flow + mWat_flow;
        else
          der(m) = mb_flow + mWat_flow;
        end if;

        if substanceDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then
          zeros(Medium.nXi) = mbXi_flow + mWat_flow * s;
        else
          der(mXi) = mbXi_flow + mWat_flow * s;
        end if;

        if traceDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then
          zeros(Medium.nC)  = mbC_flow;
        else
          der(mC)  = mbC_flow;
        end if;

        // Properties of outgoing flows
        for i in 1:nPorts loop
            ports[i].p          = medium.p;
            ports[i].h_outflow  = medium.h;
            ports[i].Xi_outflow = medium.Xi;
            ports[i].C_outflow  = C;
        end for;

        annotation (
          Documentation(info="<html>
<p>
Basic model for an ideally mixed fluid volume with the ability to store mass and energy.
It implements a dynamic or a steady-state conservation equation for energy and mass fractions.
The model has zero pressure drop between its ports.
</p>
<h4>Implementation</h4>
<p>
When extending or instantiating this model, the input 
<code>fluidVolume</code>, which is the actual volume occupied by the fluid,
needs to be assigned.
For most components, this can be set to a parameter. However, for components such as 
expansion vessels, the fluid volume can change in time.
</p>
Input connectors of the model are
<ul>
<li>
<code>Q_flow</code>, which is the sensible plus latent heat flow rate added to the medium, and
</li>
<li>
<code>mWat_flow</code>, which is the moisture mass flow rate added to the medium.
</li>
</ul>
<p>
The model can be used as a dynamic model or as a steady-state model.
However, for a steady-state model with exactly two fluid ports connected, 
the model
<a href=\"modelica://Annex60.Fluid.Interfaces.StaticTwoPortConservationEquation\">
Annex60.Fluid.Interfaces.StaticTwoPortConservationEquation</a>
provides a more efficient implementation.
</p>
<p>
For models that instantiates this model, see
<a href=\"modelica://Annex60.Fluid.MixingVolumes.MixingVolume\">
Annex60.Fluid.MixingVolumes.MixingVolume</a> and
<a href=\"modelica://Annex60.Fluid.Storage.ExpansionVessel\">
Annex60.Fluid.Storage.ExpansionVessel</a>.
</p>
</html>",       revisions="<html>
<ul>
<li>
September 17, 2013 by Michael Wetter:<br/>
Added start value for <code>hOut</code>.
</li>
<li>September 10, 2013 by Michael Wetter:<br/>
Removed unrequired parameter <code>i_w</code>.<br/>
Corrected the syntax error
<code>Medium.ExtraProperty C[Medium.nC](each nominal=C_nominal)</code>
to
<code>Medium.ExtraProperty C[Medium.nC](nominal=C_nominal)</code>
because <code>C_nominal</code> is a vector. 
This syntax error caused a compilation error in OpenModelica.
</li>
<li>
July 30, 2013 by Michael Wetter:<br/>
Changed connector <code>mXi_flow[Medium.nXi]</code>
to a scalar input connector <code>mWat_flow</code>.
The reason is that <code>mXi_flow</code> does not allow
to compute the other components in <code>mX_flow</code> and
therefore leads to an ambiguous use of the model.
By only requesting <code>mWat_flow</code>, the mass balance
and species balance can be implemented correctly.
</li>
<li>
March 27, 2013 by Michael Wetter:<br/>
Removed wrong unit attribute of <code>COut</code>,
and added min and max attributes for <code>XiOut</code>.
</li>
<li>
July 31, 2011 by Michael Wetter:<br/>
Added test to stop model translation if the setting for
<code>energyBalance</code> and <code>massBalance</code>
can lead to inconsistent equations.
</li>
<li>
July 26, 2011 by Michael Wetter:<br/>
Removed the option to use <code>h_start</code>, as this
is not needed for building simulation. 
Also removed the reference to <code>Modelica.Fluid.System</code>.
Moved parameters and medium to 
<a href=\"Annex60.Fluid.Interfaces.LumpedVolumeDeclarations\">
Annex60.Fluid.Interfaces.LumpedVolumeDeclarations</a>.
<li>
July 14, 2011 by Michael Wetter:<br/>
Added start value for medium density.
</li>
<li>
March 29, 2011 by Michael Wetter:<br/>
Changed default value for <code>substanceDynamics</code> and
<code>traceDynamics</code> from <code>energyDynamics</code>
to <code>massDynamics</code>.
</li>
<li>
September 28, 2010 by Michael Wetter:<br/>
Changed array index for nominal value of <code>Xi</code>.
<li>
September 13, 2010 by Michael Wetter:<br/>
Set nominal attributes for medium based on default medium values.
</li>
<li>
July 30, 2010 by Michael Wetter:<br/>
Added parameter <code>C_nominal</code> which is used as the nominal attribute for <code>C</code>.
Without this value, the ODE solver gives wrong results for concentrations around 1E-7.
</li>
<li>
March 21, 2010 by Michael Wetter:<br/>
Changed pressure start value from <code>system.p_start</code>
to <code>Medium.p_default</code> since HVAC models may have water and 
air, which are typically at different pressures.
</li>
<li><i>February 6, 2010</i> by Michael Wetter:<br/>
Added to <code>Medium.BaseProperties</code> the initialization 
<code>X(start=X_start[1:Medium.nX])</code>. Previously, the initialization
was only done for <code>Xi</code> but not for <code>X</code>, which caused the
medium to be initialized to <code>reference_X</code>, ignoring the value of <code>X_start</code>.
</li>
<li><i>October 12, 2009</i> by Michael Wetter:<br/>
Implemented first version in <code>Buildings</code> library, based on model from
<code>Modelica.Fluid 1.0</code>.
</li>
</ul>
</html>"),Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{
                  100,100}}),
                  graphics),
          Icon(graphics={            Rectangle(
                extent={{-100,100},{100,-100}},
                fillColor={135,135,135},
                fillPattern=FillPattern.Solid,
                pattern=LinePattern.None),
              Text(
                extent={{-89,17},{-54,34}},
                lineColor={0,0,127},
                textString="mWat_flow"),
              Text(
                extent={{-89,52},{-54,69}},
                lineColor={0,0,127},
                textString="Q_flow"),
              Line(points={{-56,-73},{81,-73}}, color={255,255,255}),
              Line(points={{-42,55},{-42,-84}}, color={255,255,255}),
              Polygon(
                points={{-42,67},{-50,45},{-34,45},{-42,67}},
                lineColor={255,255,255},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Polygon(
                points={{87,-73},{65,-65},{65,-81},{87,-73}},
                lineColor={255,255,255},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Line(
                points={{-42,-28},{-6,-28},{18,4},{40,12},{66,14}},
                color={255,255,255},
                smooth=Smooth.Bezier),
              Text(
                extent={{-155,-120},{145,-160}},
                lineColor={0,0,255},
                textString="%name")}));
      end ConservationEquation;

      model StaticTwoPortConservationEquation
      "Partial model for static energy and mass conservation equations"
        extends Annex60.Fluid.Interfaces.PartialTwoPortInterface(
        showDesignFlowDirection = false);

        constant Boolean sensibleOnly "Set to true if sensible exchange only";

        Modelica.Blocks.Interfaces.RealInput Q_flow(unit="W")
        "Heat transfered into the medium"
          annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
        Modelica.Blocks.Interfaces.RealInput mWat_flow(unit="kg/s")
        "Moisture mass flow rate added to the medium"
          annotation (Placement(transformation(extent={{-140,20},{-100,60}})));

        // Outputs that are needed in models that extend this model
        Modelica.Blocks.Interfaces.RealOutput hOut(unit="J/kg",
                                                   start=Medium.specificEnthalpy_pTX(
                                                           p=Medium.p_default,
                                                           T=Medium.T_default,
                                                           X=Medium.X_default))
        "Leaving temperature of the component"
          annotation (Placement(transformation(extent={{-10,-10},{10,10}},
              rotation=90,
              origin={-50,110}), iconTransformation(
              extent={{-10,-10},{10,10}},
              rotation=90,
              origin={-50,110})));

        Modelica.Blocks.Interfaces.RealOutput XiOut[Medium.nXi](each unit="1",
                                                                each min=0,
                                                                each max=1)
        "Leaving species concentration of the component"
          annotation (Placement(transformation(extent={{-10,-10},{10,10}},
              rotation=90,
              origin={0,110})));
        Modelica.Blocks.Interfaces.RealOutput COut[Medium.nC](each min=0)
        "Leaving trace substances of the component"
          annotation (Placement(transformation(extent={{-10,-10},{10,10}},
              rotation=90,
              origin={50,110})));

        constant Boolean use_safeDivision=true
        "Set to true to improve numerical robustness";
    protected
        Real m_flowInv(unit="s/kg") "Regularization of 1/m_flow";

        Modelica.SIunits.MassFlowRate mXi_flow[Medium.nXi]
        "Mass flow rates of independent substances added to the medium";

        // Parameters that is used to construct the vector mXi_flow
        final parameter Real s[Medium.nXi] = {if Modelica.Utilities.Strings.isEqual(string1=Medium.substanceNames[i],
                                                  string2="Water",
                                                  caseSensitive=false)
                                                  then 1 else 0 for i in 1:Medium.nXi}
        "Vector with zero everywhere except where species is";

      initial equation
        // Assert that the substance with name 'water' has been found.
        assert(Medium.nXi == 0 or abs(sum(s)-1) < 1e-5,
            "If Medium.nXi > 1, then substance 'water' must be present for one component.'"
               + Medium.mediumName + "'.\n"
               + "Check medium model.");

      equation
       // Species flow rate from connector mWat_flow
       mXi_flow = mWat_flow * s;
        // Regularization of m_flow around the origin to avoid a division by zero
       if use_safeDivision then
          m_flowInv = Annex60.Utilities.Math.Functions.inverseXRegularized(x=port_a.m_flow, delta=m_flow_small/1E3);
       else
           m_flowInv = 0; // m_flowInv is not used if use_safeDivision = false.
       end if;

       if allowFlowReversal then
         // Formulate hOut using spliceFunction. This avoids an event iteration.
         // The introduced error is small because deltax=m_flow_small/1e3
         hOut = Annex60.Utilities.Math.Functions.spliceFunction(pos=port_b.h_outflow,
                                                                  neg=port_a.h_outflow,
                                                                  x=port_a.m_flow,
                                                                  deltax=m_flow_small/1E3);
         XiOut = Annex60.Utilities.Math.Functions.spliceFunction(pos=port_b.Xi_outflow,
                                                                  neg=port_a.Xi_outflow,
                                                                  x=port_a.m_flow,
                                                                  deltax=m_flow_small/1E3);
         COut = Annex60.Utilities.Math.Functions.spliceFunction(pos=port_b.C_outflow,
                                                                  neg=port_a.C_outflow,
                                                                  x=port_a.m_flow,
                                                                  deltax=m_flow_small/1E3);
       else
         hOut =  port_b.h_outflow;
         XiOut = port_b.Xi_outflow;
         COut =  port_b.C_outflow;
       end if;

        //////////////////////////////////////////////////////////////////////////////////////////
        // Energy balance and mass balance
        if sensibleOnly then
          // Mass balance
          port_a.m_flow = -port_b.m_flow;
          // Energy balance
          if use_safeDivision then
            port_b.h_outflow = inStream(port_a.h_outflow) + Q_flow * m_flowInv;
            port_a.h_outflow = inStream(port_b.h_outflow) - Q_flow * m_flowInv;
          else
            port_a.m_flow * (inStream(port_a.h_outflow) - port_b.h_outflow) = -Q_flow;
            port_a.m_flow * (inStream(port_b.h_outflow) - port_a.h_outflow) = +Q_flow;
          end if;
          // Transport of species
          port_a.Xi_outflow = inStream(port_b.Xi_outflow);
          port_b.Xi_outflow = inStream(port_a.Xi_outflow);
          // Transport of trace substances
          port_a.C_outflow = inStream(port_b.C_outflow);
          port_b.C_outflow = inStream(port_a.C_outflow);
        else
          // Mass balance (no storage)
          port_a.m_flow + port_b.m_flow = -mWat_flow;
          // Energy balance.
          // This equation is approximate since m_flow = port_a.m_flow is used for the mass flow rate
          // at both ports. Since mWat_flow << m_flow, the error is small.
          if use_safeDivision then
            port_b.h_outflow = inStream(port_a.h_outflow) + Q_flow * m_flowInv;
            port_a.h_outflow = inStream(port_b.h_outflow) - Q_flow * m_flowInv;
            // Transport of species
            port_b.Xi_outflow = inStream(port_a.Xi_outflow) + mXi_flow * m_flowInv;
            port_a.Xi_outflow = inStream(port_b.Xi_outflow) - mXi_flow * m_flowInv;
           else
            port_a.m_flow * (inStream(port_a.h_outflow) - port_b.h_outflow) = -Q_flow;
            port_a.m_flow * (inStream(port_b.h_outflow) - port_a.h_outflow) = +Q_flow;
            // Transport of species
            port_a.m_flow * (inStream(port_a.Xi_outflow) - port_b.Xi_outflow) = -mXi_flow;
            port_a.m_flow * (inStream(port_b.Xi_outflow) - port_a.Xi_outflow) = +mXi_flow;
           end if;

          // Transport of trace substances
         port_a.m_flow*port_a.C_outflow = -port_b.m_flow*inStream(port_b.C_outflow);
         port_b.m_flow*port_b.C_outflow = -port_a.m_flow*inStream(port_a.C_outflow);

        end if; // sensibleOnly

        //////////////////////////////////////////////////////////////////////////////////////////
        // No pressure drop in this model
        port_a.p = port_b.p;

        annotation (
          preferredView="info",
          Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={1,1})),
          Documentation(info="<html>
<p>
This model transports fluid between its two ports, without storing mass or energy. 
It implements a steady-state conservation equation for energy and mass fractions.
The model has zero pressure drop between its ports.
</p>
<h4>Implementation</h4>
Input connectors of the model are
<ul>
<li>
<code>Q_flow</code>, which is the sensible plus latent heat flow rate added to the medium, and
</li>
<li>
<code>mWat_flow</code>, which is the moisture mass flow rate added to the medium.
</li>
</ul>

<p>
The model can only be used as a steady-state model with two fluid ports.
For a model with a dynamic balance, and more fluid ports, use
<a href=\"modelica://Annex60.Fluid.Interfaces.ConservationEquation\">
Annex60.Fluid.Interfaces.ConservationEquation</a>.
</p>
<p>
Set the constant <code>sensibleOnly=true</code> if the model that extends
or instantiates this model sets <code>mWat_flow = 0</code>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
October 21, 2013 by Michael Wetter:<br/>
Corrected sign error in the equation that is used if <code>use_safeDivision=false</code>
and <code>sensibleOnly=true</code>.
This only affects internal numerical tests, but not any examples in the library
as the constant <code>use_safeDivision</code> is set to <code>true</code> by default.
</li>
<li>
September 25, 2013 by Michael Wetter:<br/>
Reformulated computation of outlet properties to avoid an event at zero mass flow rate.
</li>
<li>
September 17, 2013 by Michael Wetter:<br/>
Added start value for <code>hOut</code>.
</li>
<li>September 10, 2013 by Michael Wetter:<br/>
Removed unrequired parameter <code>i_w</code>.
</li>
<li>
May 7, 2013 by Michael Wetter:<br/>
Removed <code>for</code> loops for species balance and trace substance balance, 
as they cause the error <code>Error: Operand port_a.Xi_outflow[1] to operator inStream is not a stream variable.</code>
in OpenModelica.
</li>
<li>
March 27, 2013 by Michael Wetter:<br/>
Removed wrong unit attribute of <code>COut</code>,
and added min and max attributes for <code>XiOut</code>.
</li>
<li>
June 22, 2012 by Michael Wetter:<br/>
Reformulated implementation with <code>m_flowInv</code> to use <code>port_a.m_flow * ...</code>
if <code>use_safeDivision=false</code>. This avoids a division by zero if 
<code>port_a.m_flow=0</code>.
</li>
<li>
February 7, 2012 by Michael Wetter:<br/>
Revised base classes for conservation equations in <code>Annex60.Fluid.Interfaces</code>.
</li>
<li>
December 14, 2011 by Michael Wetter:<br/>
Changed assignment of <code>hOut</code>, <code>XiOut</code> and
<code>COut</code> to no longer declare that it is continuous. 
The declaration of continuity, i.e, the 
<code>smooth(0, if (port_a.m_flow >= 0) then ...</code> declaration,
was required for Dymola 2012 to simulate, but it is no longer needed 
for Dymola 2012 FD01.
</li>
<li>
August 19, 2011, by Michael Wetter:<br/>
Changed assignment of <code>hOut</code>, <code>XiOut</code> and
<code>COut</code> to declare that it is not differentiable.
</li>
<li>
August 4, 2011, by Michael Wetter:<br/>
Moved linearized pressure drop equation from the function body to the equation
section. With the previous implementation, 
the symbolic processor may not rearrange the equations, which can lead 
to coupled equations instead of an explicit solution.
</li>
<li>
March 29, 2011, by Michael Wetter:<br/>
Changed energy and mass balance to avoid a division by zero if <code>m_flow=0</code>.
</li>
<li>
March 27, 2011, by Michael Wetter:<br/>
Added <code>homotopy</code> operator.
</li>
<li>
August 19, 2010, by Michael Wetter:<br/>
Fixed bug in energy and moisture balance that affected results if a component
adds or removes moisture to the air stream. 
In the old implementation, the enthalpy and species
outflow at <code>port_b</code> was multiplied with the mass flow rate at 
<code>port_a</code>. The old implementation led to small errors that were proportional
to the amount of moisture change. For example, if the moisture added by the component
was <code>0.005 kg/kg</code>, then the error was <code>0.5%</code>.
Also, the results for forward flow and reverse flow differed by this amount.
With the new implementation, the energy and moisture balance is exact.
</li>
<li>
March 22, 2010, by Michael Wetter:<br/>
Added constant <code>sensibleOnly</code> to 
simplify species balance equation.
</li>
<li>
April 10, 2009, by Michael Wetter:<br/>
Added model to compute flow friction.
</li>
<li>
April 22, 2008, by Michael Wetter:<br/>
Revised to add mass balance.
</li>
<li>
March 17, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),Icon(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={1,1}), graphics={Rectangle(
                extent={{-100,100},{100,-100}},
                fillColor={135,135,135},
                fillPattern=FillPattern.Solid,
                pattern=LinePattern.None),
              Text(
                extent={{-93,72},{-58,89}},
                lineColor={0,0,127},
                textString="Q_flow"),
              Text(
                extent={{-93,37},{-58,54}},
                lineColor={0,0,127},
                textString="mWat_flow"),
              Text(
                extent={{-41,103},{-10,117}},
                lineColor={0,0,127},
                textString="hOut"),
              Text(
                extent={{10,103},{41,117}},
                lineColor={0,0,127},
                textString="XiOut"),
              Text(
                extent={{61,103},{92,117}},
                lineColor={0,0,127},
                textString="COut"),
              Line(points={{-42,55},{-42,-84}}, color={255,255,255}),
              Polygon(
                points={{-42,67},{-50,45},{-34,45},{-42,67}},
                lineColor={255,255,255},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Polygon(
                points={{87,-73},{65,-65},{65,-81},{87,-73}},
                lineColor={255,255,255},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Line(points={{-56,-73},{81,-73}}, color={255,255,255}),
              Line(points={{6,14},{6,-37}},     color={255,255,255}),
              Line(points={{54,14},{6,14}},     color={255,255,255}),
              Line(points={{6,-37},{-42,-37}},  color={255,255,255})}));
      end StaticTwoPortConservationEquation;

      record TwoPortFlowResistanceParameters
      "Parameters for flow resistance for models with two ports"

        parameter Boolean computeFlowResistance = true
        "=true, compute flow resistance. Set to false to assume no friction"
          annotation (Evaluate=true, Dialog(tab="Flow resistance"));

        parameter Boolean from_dp = false
        "= true, use m_flow = f(dp) else dp = f(m_flow)"
          annotation (Evaluate=true, Dialog(enable = computeFlowResistance,
                      tab="Flow resistance"));
        parameter Modelica.SIunits.Pressure dp_nominal(min=0, displayUnit="Pa")
        "Pressure"                                  annotation(Dialog(group = "Nominal condition"));
        parameter Boolean linearizeFlowResistance = false
        "= true, use linear relation between m_flow and dp for any flow rate"
          annotation(Dialog(enable = computeFlowResistance,
                     tab="Flow resistance"));
        parameter Real deltaM = 0.1
        "Fraction of nominal flow rate where flow transitions to laminar"
          annotation(Dialog(enable = computeFlowResistance, tab="Flow resistance"));

      annotation (preferredView="info",
      Documentation(info="<html>
This class contains parameters that are used to
compute the pressure drop in models that have one fluid stream.
Note that the nominal mass flow rate is not declared here because
the model 
<a href=\"modelica://Annex60.Fluid.Interfaces.PartialTwoPortInterface\">
PartialTwoPortInterface</a>
already declares it.
</html>",
      revisions="<html>
<ul>
<li>
April 13, 2009, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
      end TwoPortFlowResistanceParameters;

      record LumpedVolumeDeclarations "Declarations for lumped volumes"
        replaceable package Medium =
          Modelica.Media.Interfaces.PartialMedium "Medium in the component"
            annotation (choicesAllMatching = true);

        // Assumptions
        parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
        "Formulation of energy balance"
          annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
        parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
        "Formulation of mass balance"
          annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
        final parameter Modelica.Fluid.Types.Dynamics substanceDynamics=energyDynamics
        "Formulation of substance balance"
          annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
        final parameter Modelica.Fluid.Types.Dynamics traceDynamics=energyDynamics
        "Formulation of trace substance balance"
          annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));

        // Initialization
        parameter Medium.AbsolutePressure p_start = Medium.p_default
        "Start value of pressure"
          annotation(Dialog(tab = "Initialization"));
        parameter Medium.Temperature T_start=Medium.T_default
        "Start value of temperature"
          annotation(Dialog(tab = "Initialization"));
        parameter Medium.MassFraction X_start[Medium.nX] = Medium.X_default
        "Start value of mass fractions m_i/m"
          annotation (Dialog(tab="Initialization", enable=Medium.nXi > 0));
        parameter Medium.ExtraProperty C_start[Medium.nC](
             quantity=Medium.extraPropertiesNames)=fill(0, Medium.nC)
        "Start value of trace substances"
          annotation (Dialog(tab="Initialization", enable=Medium.nC > 0));
        parameter Medium.ExtraProperty C_nominal[Medium.nC](
             quantity=Medium.extraPropertiesNames) = fill(1E-2, Medium.nC)
        "Nominal value of trace substances. (Set to typical order of magnitude.)"
         annotation (Dialog(tab="Initialization", enable=Medium.nC > 0));

      annotation (preferredView="info",
      Documentation(info="<html>
<p>
This class contains parameters and medium properties
that are used in the lumped  volume model, and in models that extend the 
lumped volume model.
</p>
<p>
These parameters are used by
<a href=\"modelica://Annex60.Fluid.Interfaces.ConservationEquation\">
Annex60.Fluid.Interfaces.ConservationEquation</a>,
<a href=\"modelica://Annex60.Fluid.MixingVolumes.MixingVolume\">
Annex60.Fluid.MixingVolumes.MixingVolume</a>,
<a href=\"modelica://Annex60.Rooms.MixedAir\">
Annex60.Rooms.MixedAir</a>, and by
<a href=\"modelica://Annex60.Rooms.BaseClasses.MixedAir\">
Annex60.Rooms.BaseClasses.MixedAir</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
August 2, 2011, by Michael Wetter:<br/>
Set <code>substanceDynamics</code> and <code>traceDynamics</code> to final
and equal to <code>energyDynamics</code>, 
as there is no need to make them different from <code>energyDynamics</code>.
</li>
<li>
August 1, 2011, by Michael Wetter:<br/>
Changed default value for <code>energyDynamics</code> to
<code>Modelica.Fluid.Types.Dynamics.DynamicFreeInitial</code> because
<code>Modelica.Fluid.Types.Dynamics.SteadyStateInitial</code> leads
to high order DAE that Dymola cannot reduce.
</li>
<li>
July 31, 2011, by Michael Wetter:<br/>
Changed default value for <code>energyDynamics</code> to
<code>Modelica.Fluid.Types.Dynamics.SteadyStateInitial</code>.
</li>
<li>
April 13, 2009, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
      end LumpedVolumeDeclarations;
    annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains basic classes that are used to build
component models that change the state of the
fluid. The classes are not directly usable, but can
be extended when building a new model.
</p>
</html>"));
    end Interfaces;
  annotation (
  preferredView="info", Documentation(info="<html>
This package contains components for fluid flow systems such as
pumps, valves and sensors. For other fluid flow models, see 
<a href=\"modelica://Modelica.Fluid\">Modelica.Fluid</a>.
</html>"));
  end Fluid;

  package Media "Package with medium models"
    extends Modelica.Icons.MaterialPropertiesPackage;

    package ConstantPropertyLiquidWater
    "Package with model for liquid water with constant properties"
       extends Modelica.Media.Water.ConstantPropertyLiquidWater(
         final cp_const=4184,
         final cv_const=4148);

      redeclare model BaseProperties "Base properties"
        Modelica.SIunits.Temperature T(stateSelect=if
              preferredMediumStates then StateSelect.prefer else StateSelect.default)
        "Temperature of medium";
        InputAbsolutePressure p(stateSelect=if
              preferredMediumStates then StateSelect.prefer else StateSelect.default)
        "Absolute pressure of medium";
        final InputMassFraction[nXi] Xi=fill(0, 0)
        "Structurally independent mass fractions";
        InputSpecificEnthalpy h "Specific enthalpy of medium";
        Modelica.SIunits.SpecificInternalEnergy u
        "Specific internal energy of medium";
        final Modelica.SIunits.Density d=d_const "Density of medium";
        final Modelica.SIunits.MassFraction[nX] X={1}
        "Mass fractions (= (component mass)/total mass  m_i/m)";
        final Modelica.SIunits.SpecificHeatCapacity R=0
        "Gas constant (of mixture if applicable)";
        final Modelica.SIunits.MolarMass MM=MM_const
        "Molar mass (of mixture or single fluid)";
        ThermodynamicState state
        "Thermodynamic state record for optional functions";
        parameter Boolean preferredMediumStates=false
        "= true if StateSelect.prefer shall be used for the independent property variables of the medium"
          annotation (Evaluate=true, Dialog(tab="Advanced"));
        final parameter Boolean standardOrderComponents=true
        "If true, and reducedX = true, the last element of X will be computed from the other ones";
        Modelica.SIunits.Conversions.NonSIunits.Temperature_degC T_degC=
            Modelica.SIunits.Conversions.to_degC(T)
        "Temperature of medium in [degC]";
        Modelica.SIunits.Conversions.NonSIunits.Pressure_bar p_bar=
            Modelica.SIunits.Conversions.to_bar(p)
        "Absolute pressure of medium in [bar]";

        // Local connector definition, used for equation balancing check
        connector InputAbsolutePressure = input
          Modelica.SIunits.AbsolutePressure
        "Pressure as input signal connector";
        connector InputSpecificEnthalpy = input
          Modelica.SIunits.SpecificEnthalpy
        "Specific enthalpy as input signal connector";
        connector InputMassFraction = input Modelica.SIunits.MassFraction
        "Mass fraction as input signal connector";

      equation
        assert(T >= T_min and T <= T_max, "
Temperature T (= "   + String(T) + " K) is not
in the allowed range ("   + String(T_min) + " K <= T <= " + String(T_max) + " K)
required from medium model \""   + mediumName + "\".
");

        h = cp_const*(T-T0);
        //h = specificEnthalpy_pTX(p, T, X);
        u = h;
        state.T = T;
        state.p = p;
        annotation (Documentation(info="<html>
    <p>
    This base properties model is identical to
    <a href=\"modelica://Modelica.Media.Water.ConstantPropertyLiquidWater\">
    Modelica.Media.Water.ConstantPropertyLiquidWater</a>,
    except that the equation
    <code>    u = cv_const*(T - T0);</code>
    has been replaced by <code>u=h</code> because
    <code>cp_const=cv_const</code>.
    </p>
</html>"));
      end BaseProperties;
      annotation (preferredView="info", Documentation(info="<html>
This medium model is identical to 
<a href=\"modelica://Modelica.Media.Water.ConstantPropertyLiquidWater\">
Modelica.Media.Water.ConstantPropertyLiquidWater</a>.
</html>",     revisions="<html>
<ul>
<li>
November 15, 2013, by Michael Wetter:<br/>
Complete new reimplementation because the previous version
had the option to add a compressibility to the medium, which
has never been used.
</li>
</ul>
</html>"));
    end ConstantPropertyLiquidWater;
    annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains different implementations for
various media.
The media models in this package are
compatible with 
<a href=\"modelica://Modelica.Media\">
Modelica.Media</a> 
but the implementation is in general simpler, which often 
leads to easier numerical problems and better convergence of the
models.
Due to the simplifications, the media model of this package
are generally accurate for a smaller temperature range than the 
models in <a href=\"modelica://Modelica.Media\">
Modelica.Media</a>, but the smaller temperature range may often be 
sufficient for building HVAC applications.
</p>
</html>"));
  end Media;

  package Utilities "Package with utility functions such as for I/O"
    extends Modelica.Icons.Package;

    package Math "Library with functions such as for smoothing"
      extends Modelica.Icons.VariantsPackage;

      package Functions "Package with mathematical functions"
        extends Modelica.Icons.BasesPackage;

        function spliceFunction
            input Real pos "Argument of x > 0";
            input Real neg "Argument of x < 0";
            input Real x "Independent value";
            input Real deltax "Half width of transition interval";
            output Real out "Smoothed value";
      protected
            Real scaledX1;
            Real y;
            constant Real asin1 = Modelica.Math.asin(1);
        algorithm
            scaledX1 := x/deltax;
            if scaledX1 <= -0.999999999 then
              out := neg;
            elseif scaledX1 >= 0.999999999 then
              out := pos;
            else
              y := (Modelica.Math.tanh(Modelica.Math.tan(scaledX1*asin1)) + 1)/2;
              out := pos*y + (1 - y)*neg;
            end if;

            annotation (
        smoothOrder=1,
        derivative=BaseClasses.der_spliceFunction,
        Documentation(info="<html>
<p>
Function to provide a once continuously differentialbe transition between 
to arguments.
</p><p>
The function is adapted from 
<a href=\"modelica://Modelica.Media.Air.MoistAir.Utilities.spliceFunction\">
Modelica.Media.Air.MoistAir.Utilities.spliceFunction</a> and provided here
for easier accessability to model developers.
</html>",         revisions="<html>
<ul>
<li>
May 10, 2013, by Michael Wetter:<br/>
Reformulated implementation to avoid unrequired computations.
</li>
<li>
May 11, 2010, by Michael Wetter:<br/>
Removed default value for transition interval as this is problem dependent.
</li>
<li>
May 20, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
        end spliceFunction;

        function inverseXRegularized
        "Function that approximates 1/x by a twice continuously differentiable function"
         input Real x "Abscissa value";
         input Real delta(min=0)
          "Abscissa value below which approximation occurs";
         output Real y "Function value";
      protected
         Real delta2 "Delta^2";
         Real x2_d2 "=x^2/delta^2";
        algorithm
          if (abs(x) > delta) then
            y := 1/x;
          else
            delta2 :=delta*delta;
            x2_d2  := x*x/delta2;
            y      := x/delta2 + x*abs(x/delta2/delta*(2 - x2_d2*(3 - x2_d2)));
          end if;

          annotation (
            Documentation(info="<html>
<p>
Function that approximates <i>y=1 &frasl; x</i> 
inside the interval <i>-&delta; &le; x &le; &delta;</i>.
The approximation is twice continuously differentiable with a bounded derivative on the whole 
real line.
<p>
See the package <code>Examples</code> for the graph.
</p>
</html>",         revisions="<html>
<ul>
<li>
May 10, 2013, by Michael Wetter:<br/>
Reformulated implementation to avoid unrequired computations.
</li>
<li>
April 18, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),          smoothOrder=2, Inline=true);
        end inverseXRegularized;

        package BaseClasses
        "Package with base classes for Annex60.Utilities.Math.Functions"
          extends Modelica.Icons.BasesPackage;

          function der_spliceFunction "Derivative of splice function"
              input Real pos;
              input Real neg;
              input Real x;
              input Real deltax=1;
              input Real dpos;
              input Real dneg;
              input Real dx;
              input Real ddeltax=0;
              output Real out;
        protected
              Real scaledX;
              Real scaledX1;
              Real dscaledX1;
              Real y;
              constant Real asin1 = Modelica.Math.asin(1);
          algorithm
              scaledX1 := x/deltax;
              if scaledX1 <= -0.99999999999 then
                out := dneg;
              elseif scaledX1 >= 0.9999999999 then
                out := dpos;
              else
                scaledX := scaledX1*asin1;
                dscaledX1 := (dx - scaledX1*ddeltax)/deltax;
                y := (Modelica.Math.tanh(Modelica.Math.tan(scaledX)) + 1)/2;
                out := dpos*y + (1 - y)*dneg;
                out := out + (pos - neg)*dscaledX1*asin1/2/(
                  Modelica.Math.cosh(Modelica.Math.tan(scaledX))*Modelica.Math.cos(
                  scaledX))^2;
              end if;

          annotation (
          Documentation(
          info="<html>
<p>
Implementation of the first derivative of the function
<a href=\"modelica://Annex60.Utilities.Math.Functions.spliceFunction\">
Annex60.Utilities.Math.Functions.spliceFunction</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
May 10, 2013, by Michael Wetter:<br/>
Reformulated implementation to avoid unrequired computations.
</li>
<li>
April 7, 2009, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
          end der_spliceFunction;
        annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains base classes that are used to construct the models in
<a href=\"modelica://Annex60.Utilities.Math.Functions\">Annex60.Utilities.Math.Functions</a>.
</p>
</html>"));
        end BaseClasses;
      annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains functions for commonly used
mathematical operations. The functions are used in 
the blocks
<a href=\"modelica://Annex60.Utilities.Math\">
Annex60.Utilities.Math</a>.
</p>
</html>"));
      end Functions;
    annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains blocks and functions for commonly used
mathematical operations. 
The classes in this package augment the classes
<a href=\"modelica://Modelica.Blocks\">
Modelica.Blocks</a>.
</p>
</html>"));
    end Math;
  annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains utility models such as for thermal comfort calculation, input/output, co-simulation, psychrometric calculations and various functions that are used throughout the library.
</p>
</html>"));
  end Utilities;
annotation (
preferredView="info",
version="0.1",
versionBuild=0,
versionDate="2013-09-20",
dateModified = "2013-09-20",
uses(Modelica(version="3.2.1")),
preferredView="info",
Documentation(info="<html>
<p>
The <code>Annex60</code> library is a free library
that provides basic classes for the development of
Modelica libraries for building and community energy and control systems. 
Many models are based on models from the package
<code>Modelica.Fluid</code> and use
the same ports to ensure compatibility with the Modelica Standard
Library.
</p>
<p>
The web page for this library is
<a href=\"https://github.com/iea-annex60/modelica-annex60\">https://github.com/iea-annex60/modelica-annex60</a>.
Contributions to further advance the library are welcomed.
Contributions may not only be in the form of model development, but also
through model use, model testing,
requirements definition or providing feedback regarding the model applicability
to solve specific problems.
</p>
</html>"));
end Annex60;

package Modelica "Modelica Standard Library - Version 3.2.1 (Build 2)"
extends Modelica.Icons.Package;

  package Blocks
  "Library of basic input/output control blocks (continuous, discrete, logical, table blocks)"
  import SI = Modelica.SIunits;
  extends Modelica.Icons.Package;

    package Continuous
    "Library of continuous control blocks with internal states"
      import Modelica.Blocks.Interfaces;
      import Modelica.SIunits;
      extends Modelica.Icons.Package;

      block Filter
      "Continuous low pass, high pass, band pass or band stop IIR-filter of type CriticalDamping, Bessel, Butterworth or ChebyshevI"
        import Modelica.Blocks.Continuous.Internal;

        extends Modelica.Blocks.Interfaces.SISO;

        parameter Modelica.Blocks.Types.AnalogFilter analogFilter=Modelica.Blocks.Types.AnalogFilter.CriticalDamping
        "Analog filter characteristics (CriticalDamping/Bessel/Butterworth/ChebyshevI)";
        parameter Modelica.Blocks.Types.FilterType filterType=Modelica.Blocks.Types.FilterType.LowPass
        "Type of filter (LowPass/HighPass/BandPass/BandStop)";
        parameter Integer order(min=1) = 2 "Order of filter";
        parameter Modelica.SIunits.Frequency f_cut "Cut-off frequency";
        parameter Real gain=1.0
        "Gain (= amplitude of frequency response at zero frequency)";
        parameter Real A_ripple(unit="dB") = 0.5
        "Pass band ripple for Chebyshev filter (otherwise not used); > 0 required"
          annotation(Dialog(enable=analogFilter==Modelica.Blocks.Types.AnalogFilter.ChebyshevI));
        parameter Modelica.SIunits.Frequency f_min=0
        "Band of band pass/stop filter is f_min (A=-3db*gain) .. f_cut (A=-3db*gain)"
          annotation(Dialog(enable=filterType == Modelica.Blocks.Types.FilterType.BandPass or
                                   filterType == Modelica.Blocks.Types.FilterType.BandStop));
        parameter Boolean normalized=true
        "= true, if amplitude at f_cut = -3db, otherwise unmodified filter";
        parameter Modelica.Blocks.Types.Init init=Modelica.Blocks.Types.Init.SteadyState
        "Type of initialization (no init/steady state/initial state/initial output)"
          annotation(Evaluate=true, Dialog(tab="Advanced"));
        final parameter Integer nx = if filterType == Modelica.Blocks.Types.FilterType.LowPass or
                                        filterType == Modelica.Blocks.Types.FilterType.HighPass then
                                        order else 2*order;
        parameter Real x_start[nx] = zeros(nx)
        "Initial or guess values of states"
          annotation(Dialog(tab="Advanced"));
        parameter Real y_start = 0 "Initial value of output"
          annotation(Dialog(tab="Advanced"));
        parameter Real u_nominal = 1.0
        "Nominal value of input (used for scaling the states)"
        annotation(Dialog(tab="Advanced"));
        Modelica.Blocks.Interfaces.RealOutput x[nx] "Filter states";

    protected
        parameter Integer ncr = if analogFilter == Modelica.Blocks.Types.AnalogFilter.CriticalDamping then
                                   order else mod(order,2);
        parameter Integer nc0 = if analogFilter == Modelica.Blocks.Types.AnalogFilter.CriticalDamping then
                                   0 else integer(order/2);
        parameter Integer na = if filterType == Modelica.Blocks.Types.FilterType.BandPass or
                                  filterType == Modelica.Blocks.Types.FilterType.BandStop then order else
                               if analogFilter == Modelica.Blocks.Types.AnalogFilter.CriticalDamping then
                                  0 else integer(order/2);
        parameter Integer nr = if filterType == Modelica.Blocks.Types.FilterType.BandPass or
                                  filterType == Modelica.Blocks.Types.FilterType.BandStop then 0 else
                               if analogFilter == Modelica.Blocks.Types.AnalogFilter.CriticalDamping then
                                  order else mod(order,2);

        // Coefficients of prototype base filter (low pass filter with w_cut = 1 rad/s)
        parameter Real cr[ncr](each fixed=false);
        parameter Real c0[nc0](each fixed=false);
        parameter Real c1[nc0](each fixed=false);

        // Coefficients for differential equations.
        parameter Real r[nr](each fixed=false);
        parameter Real a[na](each fixed=false);
        parameter Real b[na](each fixed=false);
        parameter Real ku[na](each fixed=false);
        parameter Real k1[if filterType == Modelica.Blocks.Types.FilterType.LowPass then 0 else na](
                       each fixed = false);
        parameter Real k2[if filterType == Modelica.Blocks.Types.FilterType.LowPass then 0 else na](
                       each fixed = false);

        // Auxiliary variables
        Real uu[na+nr+1];

      initial equation
         if analogFilter == Modelica.Blocks.Types.AnalogFilter.CriticalDamping then
            cr = Internal.Filter.base.CriticalDamping(order, normalized);
         elseif analogFilter == Modelica.Blocks.Types.AnalogFilter.Bessel then
            (cr,c0,c1) = Internal.Filter.base.Bessel(order, normalized);
         elseif analogFilter == Modelica.Blocks.Types.AnalogFilter.Butterworth then
            (cr,c0,c1) = Internal.Filter.base.Butterworth(order, normalized);
         elseif analogFilter == Modelica.Blocks.Types.AnalogFilter.ChebyshevI then
            (cr,c0,c1) = Internal.Filter.base.ChebyshevI(order, A_ripple, normalized);
         end if;

         if filterType == Modelica.Blocks.Types.FilterType.LowPass then
            (r,a,b,ku) = Internal.Filter.roots.lowPass(cr,c0,c1,f_cut);
         elseif filterType == Modelica.Blocks.Types.FilterType.HighPass then
            (r,a,b,ku,k1,k2) = Internal.Filter.roots.highPass(cr,c0,c1,f_cut);
         elseif filterType == Modelica.Blocks.Types.FilterType.BandPass then
            (a,b,ku,k1,k2) = Internal.Filter.roots.bandPass(cr,c0,c1,f_min,f_cut);
         elseif filterType == Modelica.Blocks.Types.FilterType.BandStop then
            (a,b,ku,k1,k2) = Internal.Filter.roots.bandStop(cr,c0,c1,f_min,f_cut);
         end if;

         if init == Modelica.Blocks.Types.Init.InitialState then
            x = x_start;
         elseif init == Modelica.Blocks.Types.Init.SteadyState then
            der(x) = zeros(nx);
         elseif init == Modelica.Blocks.Types.Init.InitialOutput then
            y = y_start;
            if nx > 1 then
               der(x[1:nx-1]) = zeros(nx-1);
            end if;
         end if;

      equation
         assert(u_nominal > 0, "u_nominal > 0 required");
         assert(filterType == Modelica.Blocks.Types.FilterType.LowPass or
                filterType == Modelica.Blocks.Types.FilterType.HighPass or
                f_min > 0, "f_min > 0 required for band pass and band stop filter");
         assert(A_ripple > 0, "A_ripple > 0 required");
         assert(f_cut > 0, "f_cut > 0 required");

         /* All filters have the same basic differential equations:
        Real poles:
           der(x) = r*x - r*u
        Complex conjugate poles:
           der(x1) = a*x1 - b*x2 + ku*u;
           der(x2) = b*x1 + a*x2;
   */
         uu[1] = u/u_nominal;
         for i in 1:nr loop
            der(x[i]) = r[i]*(x[i] - uu[i]);
         end for;
         for i in 1:na loop
            der(x[nr+2*i-1]) = a[i]*x[nr+2*i-1] - b[i]*x[nr+2*i] + ku[i]*uu[nr+i];
            der(x[nr+2*i])   = b[i]*x[nr+2*i-1] + a[i]*x[nr+2*i];
         end for;

         // The output equation is different for the different filter types
         if filterType == Modelica.Blocks.Types.FilterType.LowPass then
            /* Low pass filter
           Real poles             :  y = x
           Complex conjugate poles:  y = x2
      */
            for i in 1:nr loop
               uu[i+1] = x[i];
            end for;
            for i in 1:na loop
               uu[nr+i+1] = x[nr+2*i];
            end for;

         elseif filterType == Modelica.Blocks.Types.FilterType.HighPass then
            /* High pass filter
           Real poles             :  y = -x + u;
           Complex conjugate poles:  y = k1*x1 + k2*x2 + u;
      */
            for i in 1:nr loop
               uu[i+1] = -x[i] + uu[i];
            end for;
            for i in 1:na loop
               uu[nr+i+1] = k1[i]*x[nr+2*i-1] + k2[i]*x[nr+2*i] + uu[nr+i];
            end for;

         elseif filterType == Modelica.Blocks.Types.FilterType.BandPass then
            /* Band pass filter
           Complex conjugate poles:  y = k1*x1 + k2*x2;
      */
            for i in 1:na loop
               uu[nr+i+1] = k1[i]*x[nr+2*i-1] + k2[i]*x[nr+2*i];
            end for;

         elseif filterType == Modelica.Blocks.Types.FilterType.BandStop then
            /* Band pass filter
           Complex conjugate poles:  y = k1*x1 + k2*x2 + u;
      */
            for i in 1:na loop
               uu[nr+i+1] = k1[i]*x[nr+2*i-1] + k2[i]*x[nr+2*i] + uu[nr+i];
            end for;

         else
            assert(false, "filterType (= " + String(filterType) + ") is unknown");
            uu = zeros(na+nr+1);
         end if;

         y = (gain*u_nominal)*uu[nr+na+1];

        annotation (
          Icon(
            coordinateSystem(preserveAspectRatio=true,
              extent={{-100.0,-100.0},{100.0,100.0}},
              initialScale=0.1),
              graphics={
            Line(visible=true,
              points={{-80.0,80.0},{-80.0,-88.0}},
              color={192,192,192}),
            Polygon(visible=true,
              lineColor={192,192,192},
              fillColor={192,192,192},
              fillPattern=FillPattern.Solid,
              points={{-80.0,92.0},{-88.0,70.0},{-72.0,70.0},{-80.0,92.0}}),
            Line(visible=true,
              points={{-90.0,-78.0},{82.0,-78.0}},
              color={192,192,192}),
            Polygon(visible=true,
              lineColor={192,192,192},
              fillColor={192,192,192},
              fillPattern=FillPattern.Solid,
              points={{90.0,-78.0},{68.0,-70.0},{68.0,-86.0},{90.0,-78.0}}),
            Text(visible=true,
              lineColor={192,192,192},
              extent={{-66.0,52.0},{88.0,90.0}},
              textString="%order"),
            Text(visible=true,
              fillPattern=FillPattern.Solid,
              extent={{-138.0,-140.0},{162.0,-110.0}},
              textString="f_cut=%f_cut"),
            Rectangle(visible=true,
              lineColor={160,160,164},
              fillColor={255,255,255},
              fillPattern=FillPattern.Backward,
              extent={{-80.0,-78.0},{22.0,10.0}}),
            Line(visible=  true, origin=  {3.333,-6.667}, points=  {{-83.333,34.667},{24.667,34.667},{42.667,-71.333}}, color=  {0,0,127}, smooth=  Smooth.Bezier)}),
          Documentation(info="<html>

<p>
This blocks models various types of filters:
</p>

<blockquote>
<b>low pass, high pass, band pass, and band stop filters</b>
</blockquote>

<p>
using various filter characteristics:
</p>

<blockquote>
<b>CriticalDamping, Bessel, Butterworth, Chebyshev Type I filters</b>
</blockquote>

<p>
By default, a filter block is initialized in <b>steady-state</b>, in order to
avoid unwanted oscillations at the beginning. In special cases, it might be
useful to select one of the other initialization options under tab
\"Advanced\".
</p>

<p>
Typical frequency responses for the 4 supported low pass filter types
are shown in the next figure:
</p>

<blockquote>
<img src=\"modelica://Modelica/Resources/Images/Blocks/LowPassOrder4Filters.png\"
     alt=\"LowPassOrder4Filters.png\">
</blockquote>

<p>
The step responses of the same low pass filters are shown in the next figure,
starting from a steady state initial filter with initial input = 0.2:
</p>

<blockquote>
<img src=\"modelica://Modelica/Resources/Images/Blocks/LowPassOrder4FiltersStepResponse.png\"
     alt=\"LowPassOrder4FiltersStepResponse.png\">
</blockquote>

<p>
Obviously, the frequency responses give a somewhat wrong impression
of the filter characteristics: Although Butterworth and Chebyshev
filters have a significantly steeper magnitude as the
CriticalDamping and Bessel filters, the step responses of
the latter ones are much better. This means for example, that
a CriticalDamping or a Bessel filter should be selected,
if a filter is mainly used to make a non-linear inverse model
realizable.
</p>

<p>
Typical frequency responses for the 4 supported high pass filter types
are shown in the next figure:
</p>

<blockquote>
<img src=\"modelica://Modelica/Resources/Images/Blocks/HighPassOrder4Filters.png\"
     alt=\"HighPassOrder4Filters.png\">
</blockquote>

<p>
The corresponding step responses of these high pass filters are
shown in the next figure:
</p>
<blockquote>
<img src=\"modelica://Modelica/Resources/Images/Blocks/HighPassOrder4FiltersStepResponse.png\"
     alt=\"HighPassOrder4FiltersStepResponse.png\">
</blockquote>

<p>
All filters are available in <b>normalized</b> (default) and non-normalized form.
In the normalized form, the amplitude of the filter transfer function
at the cut-off frequency f_cut is -3 dB (= 10^(-3/20) = 0.70794..).
Note, when comparing the filters of this function with other software systems,
the setting of \"normalized\" has to be selected appropriately. For example, the signal processing
toolbox of Matlab provides the filters in non-normalized form and
therefore a comparison makes only sense, if normalized = <b>false</b>
is set. A normalized filter is usually better suited for applications,
since filters of different orders are \"comparable\",
whereas non-normalized filters usually require to adapt the
cut-off frequency, when the order of the filter is changed.
See a comparison of \"normalized\" and \"non-normalized\" filters at hand of
CriticalDamping filters of order 1,2,3:
</p>

<blockquote>
<img src=\"modelica://Modelica/Resources/Images/Blocks/CriticalDampingNormalized.png\"
     alt=\"CriticalDampingNormalized.png\">
</blockquote>

<blockquote>
<img src=\"modelica://Modelica/Resources/Images/Blocks/CriticalDampingNonNormalized.png\"
     alt=\"CriticalDampingNonNormalized.png\">
</blockquote>

<h4>Implementation</h4>

<p>
The filters are implemented in the following, reliable way:
</p>

<ol>
<li> A prototype low pass filter with a cut-off angular frequency of 1 rad/s is constructed
     from the desired analogFilter and the desired normalization.</li>

<li> This prototype low pass filter is transformed to the desired filterType and the
     desired cut-off frequency f_cut using a transformation on the Laplace variable \"s\".</li>

<li> The resulting first and second order transfer functions are implemented in
     state space form, using the \"eigen value\" representation of a transfer function:
     <pre>

  // second order block with eigen values: a +/- jb
  <b>der</b>(x1) = a*x1 - b*x2 + (a^2 + b^2)/b*u;
  <b>der</b>(x2) = b*x1 + a*x2;
       y  = x2;
     </pre>
     The dc-gain from the input to the output of this block is one and the selected
     states are in the order of the input (if \"u\" is in the order of \"one\", then the
     states are also in the order of \"one\"). In the \"Advanced\" tab, a \"nominal\" value for
     the input \"u\" can be given. If appropriately selected, the states are in the order of \"one\" and
     then step-size control is always appropriate.</li>
</ol>

<h4>References</h4>

<dl>
<dt>Tietze U., and Schenk C. (2002):</dt>
<dd> <b>Halbleiter-Schaltungstechnik</b>.
     Springer Verlag, 12. Auflage, pp. 815-852.</dd>
</dl>

</html>",     revisions="<html>
<dl>
  <dt><b>Main Author:</b></dt>
  <dd><a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>,
      DLR Oberpfaffenhofen.</dd>
</dl>

<h4>Acknowledgement</h4>

<p>
The development of this block was partially funded by BMBF within the
     <a href=\"http://www.eurosyslib.com/\">ITEA2 EUROSYSLIB</a>
      project.
</p>

</html>"));
      end Filter;

      package Internal
      "Internal utility functions and blocks that should not be directly utilized by the user"
          extends Modelica.Icons.InternalPackage;

        package Filter
        "Internal utility functions for filters that should not be directly used"
            extends Modelica.Icons.InternalPackage;

          package base
          "Prototype low pass filters with cut-off frequency of 1 rad/s (other filters are derived by transformation from these base filters)"
              extends Modelica.Icons.InternalPackage;

          function CriticalDamping
            "Return base filter coefficients of CriticalDamping filter (= low pass filter with w_cut = 1 rad/s)"
            extends Modelica.Icons.Function;

            input Integer order(min=1) "Order of filter";
            input Boolean normalized=true
              "= true, if amplitude at f_cut = -3db, otherwise unmodified filter";

            output Real cr[order] "Coefficients of real poles";
          protected
            Real alpha=1.0 "Frequency correction factor";
            Real alpha2 "= alpha*alpha";
            Real den1[order]
              "[p] coefficients of denominator first order polynomials (a*p + 1)";
            Real den2[0,2]
              "[p^2, p] coefficients of denominator second order polynomials (b*p^2 + a*p + 1)";
            Real c0[0] "Coefficients of s^0 term if conjugate complex pole";
            Real c1[0] "Coefficients of s^1 term if conjugate complex pole";
          algorithm
            if normalized then
               // alpha := sqrt(2^(1/order) - 1);
               alpha := sqrt(10^(3/10/order)-1);
            else
               alpha := 1.0;
            end if;

            for i in 1:order loop
               den1[i] := alpha;
            end for;

            // Determine polynomials with highest power of s equal to one
              (cr,c0,c1) :=
                Modelica.Blocks.Continuous.Internal.Filter.Utilities.toHighestPowerOne(
                den1, den2);
          end CriticalDamping;

          function Bessel
            "Return base filter coefficients of Bessel filter (= low pass filter with w_cut = 1 rad/s)"
            extends Modelica.Icons.Function;

            input Integer order(min=1) "Order of filter";
            input Boolean normalized=true
              "= true, if amplitude at f_cut = -3db, otherwise unmodified filter";

            output Real cr[mod(order, 2)] "Coefficient of real pole";
            output Real c0[integer(order/2)]
              "Coefficients of s^0 term if conjugate complex pole";
            output Real c1[integer(order/2)]
              "Coefficients of s^1 term if conjugate complex pole";
          protected
            Real alpha=1.0 "Frequency correction factor";
            Real alpha2 "= alpha*alpha";
            Real den1[size(cr,1)]
              "[p] coefficients of denominator first order polynomials (a*p + 1)";
            Real den2[size(c0, 1),2]
              "[p^2, p] coefficients of denominator second order polynomials (b*p^2 + a*p + 1)";
          algorithm
              (den1,den2,alpha) :=
                Modelica.Blocks.Continuous.Internal.Filter.Utilities.BesselBaseCoefficients(
                order);
            if not normalized then
               alpha2 := alpha*alpha;
               for i in 1:size(c0, 1) loop
                 den2[i, 1] := den2[i, 1]*alpha2;
                 den2[i, 2] := den2[i, 2]*alpha;
               end for;
               if size(cr,1) == 1 then
                 den1[1] := den1[1]*alpha;
               end if;
               end if;

            // Determine polynomials with highest power of s equal to one
              (cr,c0,c1) :=
                Modelica.Blocks.Continuous.Internal.Filter.Utilities.toHighestPowerOne(
                den1, den2);
          end Bessel;

          function Butterworth
            "Return base filter coefficients of Butterworth filter (= low pass filter with w_cut = 1 rad/s)"
            extends Modelica.Icons.Function;

            input Integer order(min=1) "Order of filter";
            input Boolean normalized=true
              "= true, if amplitude at f_cut = -3db, otherwise unmodified filter";

            output Real cr[mod(order, 2)] "Coefficient of real pole";
            output Real c0[integer(order/2)]
              "Coefficients of s^0 term if conjugate complex pole";
            output Real c1[integer(order/2)]
              "Coefficients of s^1 term if conjugate complex pole";
          protected
            Real alpha=1.0 "Frequency correction factor";
            Real alpha2 "= alpha*alpha";
            Real den1[size(cr,1)]
              "[p] coefficients of denominator first order polynomials (a*p + 1)";
            Real den2[size(c0, 1),2]
              "[p^2, p] coefficients of denominator second order polynomials (b*p^2 + a*p + 1)";
            constant Real pi=Modelica.Constants.pi;
          algorithm
            for i in 1:size(c0, 1) loop
              den2[i, 1] := 1.0;
              den2[i, 2] := -2*Modelica.Math.cos(pi*(0.5 + (i - 0.5)/order));
            end for;
            if size(cr,1) == 1 then
              den1[1] := 1.0;
            end if;

            /* Transformation of filter transfer function with "new(p) = alpha*p"
     in order that the filter transfer function has an amplitude of
     -3 db at the cutoff frequency
  */
            /*
    if normalized then
      alpha := Internal.normalizationFactor(den1, den2);
      alpha2 := alpha*alpha;
      for i in 1:size(c0, 1) loop
        den2[i, 1] := den2[i, 1]*alpha2;
        den2[i, 2] := den2[i, 2]*alpha;
      end for;
      if size(cr,1) == 1 then
        den1[1] := den1[1]*alpha;
      end if;
    end if;
  */

            // Determine polynomials with highest power of s equal to one
              (cr,c0,c1) :=
                Modelica.Blocks.Continuous.Internal.Filter.Utilities.toHighestPowerOne(
                den1, den2);
          end Butterworth;

          function ChebyshevI
            "Return base filter coefficients of Chebyshev I filter (= low pass filter with w_cut = 1 rad/s)"
              import Modelica.Math.asinh;
            extends Modelica.Icons.Function;

            input Integer order(min=1) "Order of filter";
            input Real A_ripple = 0.5 "Pass band ripple in [dB]";
            input Boolean normalized=true
              "= true, if amplitude at f_cut = -3db, otherwise unmodified filter";

            output Real cr[mod(order, 2)] "Coefficient of real pole";
            output Real c0[integer(order/2)]
              "Coefficients of s^0 term if conjugate complex pole";
            output Real c1[integer(order/2)]
              "Coefficients of s^1 term if conjugate complex pole";
          protected
            Real epsilon;
            Real fac;
            Real alpha=1.0 "Frequency correction factor";
            Real alpha2 "= alpha*alpha";
            Real den1[size(cr,1)]
              "[p] coefficients of denominator first order polynomials (a*p + 1)";
            Real den2[size(c0, 1),2]
              "[p^2, p] coefficients of denominator second order polynomials (b*p^2 + a*p + 1)";
            constant Real pi=Modelica.Constants.pi;
          algorithm
              epsilon := sqrt(10^(A_ripple/10) - 1);
              fac := asinh(1/epsilon)/order;

              den1 := fill(1/sinh(fac),size(den1,1));
              if size(cr,1) == 0 then
                 for i in 1:size(c0, 1) loop
                    den2[i,1] :=1/(cosh(fac)^2 - cos((2*i - 1)*pi/(2*order))^2);
                    den2[i,2] :=2*den2[i, 1]*sinh(fac)*cos((2*i - 1)*pi/(2*order));
                 end for;
              else
                 for i in 1:size(c0, 1) loop
                    den2[i,1] :=1/(cosh(fac)^2 - cos(i*pi/order)^2);
                    den2[i,2] :=2*den2[i, 1]*sinh(fac)*cos(i*pi/order);
                 end for;
              end if;

              /* Transformation of filter transfer function with "new(p) = alpha*p"
       in order that the filter transfer function has an amplitude of
       -3 db at the cutoff frequency
    */
              if normalized then
                alpha :=
                  Modelica.Blocks.Continuous.Internal.Filter.Utilities.normalizationFactor(
                  den1, den2);
                alpha2 := alpha*alpha;
                for i in 1:size(c0, 1) loop
                  den2[i, 1] := den2[i, 1]*alpha2;
                  den2[i, 2] := den2[i, 2]*alpha;
                end for;
                den1 := den1*alpha;
              end if;

            // Determine polynomials with highest power of s equal to one
              (cr,c0,c1) :=
                Modelica.Blocks.Continuous.Internal.Filter.Utilities.toHighestPowerOne(
                den1, den2);
          end ChebyshevI;
          end base;

          package coefficients "Filter coefficients"
              extends Modelica.Icons.InternalPackage;

          function lowPass
            "Return low pass filter coefficients at given cut-off frequency"
            extends Modelica.Icons.Function;

            input Real cr_in[:] "Coefficients of real poles";
            input Real c0_in[:]
              "Coefficients of s^0 term if conjugate complex pole";
            input Real c1_in[size(c0_in,1)]
              "Coefficients of s^1 term if conjugate complex pole";
            input Modelica.SIunits.Frequency f_cut "Cut-off frequency";

            output Real cr[size(cr_in,1)] "Coefficient of real pole";
            output Real c0[size(c0_in,1)]
              "Coefficients of s^0 term if conjugate complex pole";
            output Real c1[size(c0_in,1)]
              "Coefficients of s^1 term if conjugate complex pole";

          protected
            constant Real pi=Modelica.Constants.pi;
            Modelica.SIunits.AngularVelocity w_cut=2*pi*f_cut
              "Cut-off angular frequency";
            Real w_cut2=w_cut*w_cut;

          algorithm
            assert(f_cut > 0, "Cut-off frequency f_cut must be positive");

            /* Change filter coefficients according to transformation new(s) = s/w_cut
     s + cr           -> (s/w) + cr              = (s + w*cr)/w
     s^2 + c1*s + c0  -> (s/w)^2 + c1*(s/w) + c0 = (s^2 + (c1*w)*s + (c0*w^2))/w^2
  */
            cr := w_cut*cr_in;
            c1 := w_cut*c1_in;
            c0 := w_cut2*c0_in;

          end lowPass;

          function highPass
            "Return high pass filter coefficients at given cut-off frequency"
            extends Modelica.Icons.Function;

            input Real cr_in[:] "Coefficients of real poles";
            input Real c0_in[:]
              "Coefficients of s^0 term if conjugate complex pole";
            input Real c1_in[size(c0_in,1)]
              "Coefficients of s^1 term if conjugate complex pole";
            input Modelica.SIunits.Frequency f_cut "Cut-off frequency";

            output Real cr[size(cr_in,1)] "Coefficient of real pole";
            output Real c0[size(c0_in,1)]
              "Coefficients of s^0 term if conjugate complex pole";
            output Real c1[size(c0_in,1)]
              "Coefficients of s^1 term if conjugate complex pole";

          protected
            constant Real pi=Modelica.Constants.pi;
            Modelica.SIunits.AngularVelocity w_cut=2*pi*f_cut
              "Cut-off angular frequency";
            Real w_cut2=w_cut*w_cut;

          algorithm
            assert(f_cut > 0, "Cut-off frequency f_cut must be positive");

            /* Change filter coefficients according to transformation: new(s) = 1/s
        1/(s + cr)          -> 1/(1/s + cr)                = (1/cr)*s / (s + (1/cr))
        1/(s^2 + c1*s + c0) -> 1/((1/s)^2 + c1*(1/s) + c0) = (1/c0)*s^2 / (s^2 + (c1/c0)*s + 1/c0)

     Check whether transformed roots are also conjugate complex:
        c0 - c1^2/4 > 0  -> (1/c0) - (c1/c0)^2 / 4
                            = (c0 - c1^2/4) / c0^2 > 0
        It is therefore guaranteed that the roots remain conjugate complex

     Change filter coefficients according to transformation new(s) = s/w_cut
        s + 1/cr                -> (s/w) + 1/cr                   = (s + w/cr)/w
        s^2 + (c1/c0)*s + 1/c0  -> (s/w)^2 + (c1/c0)*(s/w) + 1/c0 = (s^2 + (w*c1/c0)*s + (w^2/c0))/w^2
  */
            for i in 1:size(cr_in,1) loop
               cr[i] := w_cut/cr_in[i];
            end for;

            for i in 1:size(c0_in,1) loop
               c0[i] := w_cut2/c0_in[i];
               c1[i] := w_cut*c1_in[i]/c0_in[i];
            end for;

          end highPass;

          function bandPass
            "Return band pass filter coefficients at given cut-off frequency"
            extends Modelica.Icons.Function;

            input Real cr_in[:] "Coefficients of real poles";
            input Real c0_in[:]
              "Coefficients of s^0 term if conjugate complex pole";
            input Real c1_in[size(c0_in,1)]
              "Coefficients of s^1 term if conjugate complex pole";
            input Modelica.SIunits.Frequency f_min
              "Band of band pass filter is f_min (A=-3db) .. f_max (A=-3db)";
            input Modelica.SIunits.Frequency f_max "Upper band frequency";

            output Real cr[0] "Coefficient of real pole";
            output Real c0[size(cr_in,1) + 2*size(c0_in,1)]
              "Coefficients of s^0 term if conjugate complex pole";
            output Real c1[size(cr_in,1) + 2*size(c0_in,1)]
              "Coefficients of s^1 term if conjugate complex pole";
            output Real cn "Numerator coefficient of the PT2 terms";
          protected
            constant Real pi=Modelica.Constants.pi;
            Modelica.SIunits.Frequency f0 = sqrt(f_min*f_max);
            Modelica.SIunits.AngularVelocity w_cut=2*pi*f0
              "Cut-off angular frequency";
            Real w_band = (f_max - f_min) / f0;
            Real w_cut2=w_cut*w_cut;
            Real c;
            Real alpha;
            Integer j;
          algorithm
            assert(f_min > 0 and f_min < f_max, "Band frequencies f_min and f_max are wrong");

              /* The band pass filter is derived from the low pass filter by
       the transformation new(s) = (s + 1/s)/w   (w = w_band = (f_max - f_min)/sqrt(f_max*f_min) )

       1/(s + cr)         -> 1/((s/w + 1/s/w) + cr)
                             = w*s / (s^2 + cr*w*s + 1)

       1/(s^2 + c1*s + c0) -> 1/( (s+1/s)^2/w^2 + c1*(s + 1/s)/w + c0 )
                              = 1 /( ( s^2 + 1/s^2 + 2)/w^2 + (s + 1/s)*c1/w + c0 )
                              = w^2*s^2 / (s^4 + 2*s^2 + 1 + (s^3 + s)*c1*w + c0*w^2*s^2)
                              = w^2*s^2 / (s^4 + c1*w*s^3 + (2+c0*w^2)*s^2 + c1*w*s + 1)

                              Assume the following description with PT2:
                              = w^2*s^2 /( (s^2 + s*(c/alpha) + 1/alpha^2)*
                                           (s^2 + s*(c*alpha) + alpha^2) )
                              = w^2*s^2 / ( s^4 + c*(alpha + 1/alpha)*s^3
                                                + (alpha^2 + 1/alpha^2 + c^2)*s^2
                                                + c*(alpha + 1/alpha)*s + 1 )

                              and therefore:
                                c*(alpha + 1/alpha) = c1*w       -> c = c1*w / (alpha + 1/alpha)
                                                                      = c1*w*alpha/(1+alpha^2)
                                alpha^2 + 1/alpha^2 + c^2 = 2+c0*w^2 -> equation to determine alpha
                                alpha^4 + 1 + c1^2*w^2*alpha^4/(1+alpha^2)^2 = (2+c0*w^2)*alpha^2
                                or z = alpha^2
                                z^2 + c^1^2*w^2*z^2/(1+z)^2 - (2+c0*w^2)*z + 1 = 0

     Check whether roots remain conjugate complex
        c0 - (c1/2)^2 > 0:    1/alpha^2 - (c/alpha)^2/4
                              = 1/alpha^2*(1 - c^2/4)    -> not possible to figure this out

     Afterwards, change filter coefficients according to transformation new(s) = s/w_cut
        w_band*s/(s^2 + c1*s + c0)  -> w_band*(s/w)/((s/w)^2 + c1*(s/w) + c0 =
                                       (w_band/w)*s/(s^2 + (c1*w)*s + (c0*w^2))/w^2) =
                                       (w_band*w)*s/(s^2 + (c1*w)*s + (c0*w^2))
    */
              for i in 1:size(cr_in,1) loop
                 c1[i] := w_cut*cr_in[i]*w_band;
                 c0[i] := w_cut2;
              end for;

              for i in 1:size(c1_in,1) loop
                alpha :=
                  Modelica.Blocks.Continuous.Internal.Filter.Utilities.bandPassAlpha(
                        c1_in[i],
                        c0_in[i],
                        w_band);
                 c       := c1_in[i]*w_band / (alpha + 1/alpha);
                 j       := size(cr_in,1) + 2*i - 1;
                 c1[j]   := w_cut*c/alpha;
                 c1[j+1] := w_cut*c*alpha;
                 c0[j]   := w_cut2/alpha^2;
                 c0[j+1] := w_cut2*alpha^2;
              end for;

              cn :=w_band*w_cut;

          end bandPass;

          function bandStop
            "Return band stop filter coefficients at given cut-off frequency"
            extends Modelica.Icons.Function;

            input Real cr_in[:] "Coefficients of real poles";
            input Real c0_in[:]
              "Coefficients of s^0 term if conjugate complex pole";
            input Real c1_in[size(c0_in,1)]
              "Coefficients of s^1 term if conjugate complex pole";
            input Modelica.SIunits.Frequency f_min
              "Band of band stop filter is f_min (A=-3db) .. f_max (A=-3db)";
            input Modelica.SIunits.Frequency f_max "Upper band frequency";

            output Real cr[0] "Coefficient of real pole";
            output Real c0[size(cr_in,1) + 2*size(c0_in,1)]
              "Coefficients of s^0 term if conjugate complex pole";
            output Real c1[size(cr_in,1) + 2*size(c0_in,1)]
              "Coefficients of s^1 term if conjugate complex pole";
          protected
            constant Real pi=Modelica.Constants.pi;
            Modelica.SIunits.Frequency f0 = sqrt(f_min*f_max);
            Modelica.SIunits.AngularVelocity w_cut=2*pi*f0
              "Cut-off angular frequency";
            Real w_band = (f_max - f_min) / f0;
            Real w_cut2=w_cut*w_cut;
            Real c;
            Real ww;
            Real alpha;
            Integer j;
          algorithm
            assert(f_min > 0 and f_min < f_max, "Band frequencies f_min and f_max are wrong");

              /* The band pass filter is derived from the low pass filter by
       the transformation new(s) = (s + 1/s)/w   (w = w_band = (f_max - f_min)/sqrt(f_max*f_min) )

       1/(s + cr)         -> 1/((s/w + 1/s/w) + cr)
                             = w*s / (s^2 + cr*w*s + 1)

       1/(s^2 + c1*s + c0) -> 1/( (s+1/s)^2/w^2 + c1*(s + 1/s)/w + c0 )
                              = 1 /( ( s^2 + 1/s^2 + 2)/w^2 + (s + 1/s)*c1/w + c0 )
                              = w^2*s^2 / (s^4 + 2*s^2 + 1 + (s^3 + s)*c1*w + c0*w^2*s^2)
                              = w^2*s^2 / (s^4 + c1*w*s^3 + (2+c0*w^2)*s^2 + c1*w*s + 1)

                              Assume the following description with PT2:
                              = w^2*s^2 /( (s^2 + s*(c/alpha) + 1/alpha^2)*
                                           (s^2 + s*(c*alpha) + alpha^2) )
                              = w^2*s^2 / ( s^4 + c*(alpha + 1/alpha)*s^3
                                                + (alpha^2 + 1/alpha^2 + c^2)*s^2
                                                + c*(alpha + 1/alpha)*s + 1 )

                              and therefore:
                                c*(alpha + 1/alpha) = c1*w       -> c = c1*w / (alpha + 1/alpha)
                                                                      = c1*w*alpha/(1+alpha^2)
                                alpha^2 + 1/alpha^2 + c^2 = 2+c0*w^2 -> equation to determine alpha
                                alpha^4 + 1 + c1^2*w^2*alpha^4/(1+alpha^2)^2 = (2+c0*w^2)*alpha^2
                                or z = alpha^2
                                z^2 + c^1^2*w^2*z^2/(1+z)^2 - (2+c0*w^2)*z + 1 = 0

       The band stop filter is derived from the low pass filter by
       the transformation new(s) = w/( (s + 1/s) )   (w = w_band = (f_max - f_min)/sqrt(f_max*f_min) )

       cr/(s + cr)         -> 1/(( w/(s + 1/s) ) + cr)
                              = (s^2 + 1) / (s^2 + (w/cr)*s + 1)

       c0/(s^2 + c1*s + c0) -> c0/( w^2/(s + 1/s)^2 + c1*w/(s + 1/s) + c0 )
                               = c0*(s^2 + 1)^2 / (s^4 + c1*w*s^3/c0 + (2+w^2/b)*s^2 + c1*w*s/c0 + 1)

                               Assume the following description with PT2:
                               = c0*(s^2 + 1)^2 / ( (s^2 + s*(c/alpha) + 1/alpha^2)*
                                                    (s^2 + s*(c*alpha) + alpha^2) )
                               = c0*(s^2 + 1)^2 / (  s^4 + c*(alpha + 1/alpha)*s^3
                                                         + (alpha^2 + 1/alpha^2 + c^2)*s^2
                                                         + c*(alpha + 1/alpha)*p + 1 )

                            and therefore:
                              c*(alpha + 1/alpha) = c1*w/b         -> c = c1*w/(c0*(alpha + 1/alpha))
                              alpha^2 + 1/alpha^2 + c^2 = 2+w^2/c0 -> equation to determine alpha
                              alpha^4 + 1 + (c1*w/c0*alpha^2)^2/(1+alpha^2)^2 = (2+w^2/c0)*alpha^2
                              or z = alpha^2
                              z^2 + (c1*w/c0*z)^2/(1+z)^2 - (2+w^2/c0)*z + 1 = 0

                            same as:  ww = w/c0
                              z^2 + (c1*ww*z)^2/(1+z)^2 - (2+c0*ww)*z + 1 = 0  -> same equation as for BandPass

     Afterwards, change filter coefficients according to transformation new(s) = s/w_cut
        c0*(s^2+1)(s^2 + c1*s + c0)  -> c0*((s/w)^2 + 1) / ((s/w)^2 + c1*(s/w) + c0 =
                                        c0/w^2*(s^2 + w^2) / (s^2 + (c1*w)*s + (c0*w^2))/w^2) =
                                        (s^2 + c0*w^2) / (s^2 + (c1*w)*s + (c0*w^2))
    */
              for i in 1:size(cr_in,1) loop
                 c1[i] := w_cut*w_band/cr_in[i];
                 c0[i] := w_cut2;
              end for;

              for i in 1:size(c1_in,1) loop
                 ww      := w_band/c0_in[i];
                alpha :=
                  Modelica.Blocks.Continuous.Internal.Filter.Utilities.bandPassAlpha(
                        c1_in[i],
                        c0_in[i],
                        ww);
                 c       := c1_in[i]*ww / (alpha + 1/alpha);
                 j       := size(cr_in,1) + 2*i - 1;
                 c1[j]   := w_cut*c/alpha;
                 c1[j+1] := w_cut*c*alpha;
                 c0[j]   := w_cut2/alpha^2;
                 c0[j+1] := w_cut2*alpha^2;
              end for;

          end bandStop;
          end coefficients;

          package roots
          "Filter roots and gain as needed for block implementations"
              extends Modelica.Icons.InternalPackage;

          function lowPass
            "Return low pass filter roots as needed for block for given cut-off frequency"
            extends Modelica.Icons.Function;

            input Real cr_in[:] "Coefficients of real poles of base filter";
            input Real c0_in[:]
              "Coefficients of s^0 term of base filter if conjugate complex pole";
            input Real c1_in[size(c0_in,1)]
              "Coefficients of s^1 term of base filter if conjugate complex pole";
            input Modelica.SIunits.Frequency f_cut "Cut-off frequency";

            output Real r[size(cr_in,1)] "Real eigenvalues";
            output Real a[size(c0_in,1)]
              "Real parts of complex conjugate eigenvalues";
            output Real b[size(c0_in,1)]
              "Imaginary parts of complex conjugate eigenvalues";
            output Real ku[size(c0_in,1)] "Input gain";
          protected
            Real c0[size(c0_in,1)];
            Real c1[size(c0_in,1)];
            Real cr[size(cr_in,1)];
          algorithm
            // Get coefficients of low pass filter at f_cut
            (cr, c0, c1) :=coefficients.lowPass(cr_in, c0_in, c1_in, f_cut);

            // Transform coefficients in to root
            for i in 1:size(cr_in,1) loop
              r[i] :=-cr[i];
            end for;

            for i in 1:size(c0_in,1) loop
              a [i] :=-c1[i]/2;
              b [i] :=sqrt(c0[i] - a[i]*a[i]);
              ku[i] :=c0[i]/b[i];
            end for;

            annotation (Documentation(info="<html>

<p>
The goal is to implement the filter in the following form:
</p>

<pre>
  // real pole:
   der(x) = r*x - r*u
       y  = x

  // complex conjugate poles:
  der(x1) = a*x1 - b*x2 + ku*u;
  der(x2) = b*x1 + a*x2;
       y  = x2;

            ku = (a^2 + b^2)/b
</pre>
<p>
This representation has the following transfer function:
</p>
<pre>
// real pole:
    s*y = r*y - r*u
  or
    (s-r)*y = -r*u
  or
    y = -r/(s-r)*u

  comparing coefficients with
    y = cr/(s + cr)*u  ->  r = -cr      // r is the real eigenvalue

// complex conjugate poles
    s*x2 =  a*x2 + b*x1
    s*x1 = -b*x2 + a*x1 + ku*u
  or
    (s-a)*x2               = b*x1  ->  x2 = b/(s-a)*x1
    (s + b^2/(s-a) - a)*x1 = ku*u  ->  (s(s-a) + b^2 - a*(s-a))*x1  = ku*(s-a)*u
                                   ->  (s^2 - 2*a*s + a^2 + b^2)*x1 = ku*(s-a)*u
  or
    x1 = ku*(s-a)/(s^2 - 2*a*s + a^2 + b^2)*u
    x2 = b/(s-a)*ku*(s-a)/(s^2 - 2*a*s + a^2 + b^2)*u
       = b*ku/(s^2 - 2*a*s + a^2 + b^2)*u
    y  = x2

  comparing coefficients with
    y = c0/(s^2 + c1*s + c0)*u  ->  a  = -c1/2
                                    b  = sqrt(c0 - a^2)
                                    ku = c0/b
                                       = (a^2 + b^2)/b

  comparing with eigenvalue representation:
    (s - (a+jb))*(s - (a-jb)) = s^2 -2*a*s + a^2 + b^2
  shows that:
    a: real part of eigenvalue
    b: imaginary part of eigenvalue

  time -> infinity:
    y(s=0) = x2(s=0) = 1
             x1(s=0) = -ku*a/(a^2 + b^2)*u
                     = -(a/b)*u
</pre>

</html>"));
          end lowPass;

          function highPass
            "Return high pass filter roots as needed for block for given cut-off frequency"
            extends Modelica.Icons.Function;

            input Real cr_in[:] "Coefficients of real poles of base filter";
            input Real c0_in[:]
              "Coefficients of s^0 term of base filter if conjugate complex pole";
            input Real c1_in[size(c0_in,1)]
              "Coefficients of s^1 term of base filter if conjugate complex pole";
            input Modelica.SIunits.Frequency f_cut "Cut-off frequency";

            output Real r[size(cr_in,1)] "Real eigenvalues";
            output Real a[size(c0_in,1)]
              "Real parts of complex conjugate eigenvalues";
            output Real b[size(c0_in,1)]
              "Imaginary parts of complex conjugate eigenvalues";
            output Real ku[size(c0_in,1)] "Gains of input terms";
            output Real k1[size(c0_in,1)] "Gains of y = k1*x1 + k2*x + u";
            output Real k2[size(c0_in,1)] "Gains of y = k1*x1 + k2*x + u";
          protected
            Real c0[size(c0_in,1)];
            Real c1[size(c0_in,1)];
            Real cr[size(cr_in,1)];
            Real ba2;
          algorithm
            // Get coefficients of high pass filter at f_cut
            (cr, c0, c1) :=coefficients.highPass(cr_in, c0_in, c1_in, f_cut);

            // Transform coefficients in to roots
            for i in 1:size(cr_in,1) loop
              r[i] :=-cr[i];
            end for;

            for i in 1:size(c0_in,1) loop
              a[i]  := -c1[i]/2;
              b[i]  := sqrt(c0[i] - a[i]*a[i]);
              ku[i] := c0[i]/b[i];
              k1[i] := 2*a[i]/ku[i];
              ba2   := (b[i]/a[i])^2;
              k2[i] := (1-ba2)/(1+ba2);
            end for;

            annotation (Documentation(info="<html>

<p>
The goal is to implement the filter in the following form:
</p>

<pre>
  // real pole:
   der(x) = r*x - r*u
       y  = -x + u

  // complex conjugate poles:
  der(x1) = a*x1 - b*x2 + ku*u;
  der(x2) = b*x1 + a*x2;
       y  = k1*x1 + k2*x2 + u;

            ku = (a^2 + b^2)/b
            k1 = 2*a/ku
            k2 = (a^2 - b^2) / (b*ku)
               = (a^2 - b^2) / (a^2 + b^2)
               = (1 - (b/a)^2) / (1 + (b/a)^2)

</pre>
<p>
This representation has the following transfer function:
</p>
<pre>
// real pole:
    s*x = r*x - r*u
  or
    (s-r)*x = -r*u   -> x = -r/(s-r)*u
  or
    y = r/(s-r)*u + (s-r)/(s-r)*u
      = (r+s-r)/(s-r)*u
      = s/(s-r)*u

  comparing coefficients with
    y = s/(s + cr)*u  ->  r = -cr      // r is the real eigenvalue

// complex conjugate poles
    s*x2 =  a*x2 + b*x1
    s*x1 = -b*x2 + a*x1 + ku*u
  or
    (s-a)*x2               = b*x1  ->  x2 = b/(s-a)*x1
    (s + b^2/(s-a) - a)*x1 = ku*u  ->  (s(s-a) + b^2 - a*(s-a))*x1  = ku*(s-a)*u
                                   ->  (s^2 - 2*a*s + a^2 + b^2)*x1 = ku*(s-a)*u
  or
    x1 = ku*(s-a)/(s^2 - 2*a*s + a^2 + b^2)*u
    x2 = b/(s-a)*ku*(s-a)/(s^2 - 2*a*s + a^2 + b^2)*u
       = b*ku/(s^2 - 2*a*s + a^2 + b^2)*u
    y  = k1*x1 + k2*x2 + u
       = (k1*ku*(s-a) + k2*b*ku +  s^2 - 2*a*s + a^2 + b^2) /
         (s^2 - 2*a*s + a^2 + b^2)*u
       = (s^2 + (k1*ku - 2*a)*s + k2*b*ku - k1*ku*a + a^2 + b^2) /
         (s^2 - 2*a*s + a^2 + b^2)*u
       = (s^2 + (2*a-2*a)*s + a^2 - b^2 - 2*a^2 + a^2 + b^2) /
         (s^2 - 2*a*s + a^2 + b^2)*u
       = s^2 / (s^2 - 2*a*s + a^2 + b^2)*u

  comparing coefficients with
    y = s^2/(s^2 + c1*s + c0)*u  ->  a = -c1/2
                                     b = sqrt(c0 - a^2)

  comparing with eigenvalue representation:
    (s - (a+jb))*(s - (a-jb)) = s^2 -2*a*s + a^2 + b^2
  shows that:
    a: real part of eigenvalue
    b: imaginary part of eigenvalue
</pre>

</html>"));
          end highPass;

          function bandPass
            "Return band pass filter roots as needed for block for given cut-off frequency"
            extends Modelica.Icons.Function;

            input Real cr_in[:] "Coefficients of real poles of base filter";
            input Real c0_in[:]
              "Coefficients of s^0 term of base filter if conjugate complex pole";
            input Real c1_in[size(c0_in,1)]
              "Coefficients of s^1 term of base filter if conjugate complex pole";
            input Modelica.SIunits.Frequency f_min
              "Band of band pass filter is f_min (A=-3db) .. f_max (A=-3db)";
            input Modelica.SIunits.Frequency f_max "Upper band frequency";

            output Real a[size(cr_in,1) + 2*size(c0_in,1)]
              "Real parts of complex conjugate eigenvalues";
            output Real b[size(cr_in,1) + 2*size(c0_in,1)]
              "Imaginary parts of complex conjugate eigenvalues";
            output Real ku[size(cr_in,1) + 2*size(c0_in,1)]
              "Gains of input terms";
            output Real k1[size(cr_in,1) + 2*size(c0_in,1)]
              "Gains of y = k1*x1 + k2*x";
            output Real k2[size(cr_in,1) + 2*size(c0_in,1)]
              "Gains of y = k1*x1 + k2*x";
          protected
            Real cr[0];
            Real c0[size(a,1)];
            Real c1[size(a,1)];
            Real cn;
            Real bb;
          algorithm
            // Get coefficients of band pass filter at f_cut
            (cr, c0, c1, cn) :=coefficients.bandPass(cr_in, c0_in, c1_in, f_min, f_max);

            // Transform coefficients in to roots
            for i in 1:size(a,1) loop
              a[i]  := -c1[i]/2;
              bb    := c0[i] - a[i]*a[i];
              assert(bb >= 0, "\nNot possible to use band pass filter, since transformation results in\n"+
                              "system that does not have conjugate complex poles.\n" +
                              "Try to use another analog filter for the band pass.\n");
              b[i]  := sqrt(bb);
              ku[i] := c0[i]/b[i];
              k1[i] := cn/ku[i];
              k2[i] := cn*a[i]/(b[i]*ku[i]);
            end for;

            annotation (Documentation(info="<html>

<p>
The goal is to implement the filter in the following form:
</p>

<pre>
  // complex conjugate poles:
  der(x1) = a*x1 - b*x2 + ku*u;
  der(x2) = b*x1 + a*x2;
       y  = k1*x1 + k2*x2;

            ku = (a^2 + b^2)/b
            k1 = cn/ku
            k2 = cn*a/(b*ku)
</pre>
<p>
This representation has the following transfer function:
</p>
<pre>
// complex conjugate poles
    s*x2 =  a*x2 + b*x1
    s*x1 = -b*x2 + a*x1 + ku*u
  or
    (s-a)*x2               = b*x1  ->  x2 = b/(s-a)*x1
    (s + b^2/(s-a) - a)*x1 = ku*u  ->  (s(s-a) + b^2 - a*(s-a))*x1  = ku*(s-a)*u
                                   ->  (s^2 - 2*a*s + a^2 + b^2)*x1 = ku*(s-a)*u
  or
    x1 = ku*(s-a)/(s^2 - 2*a*s + a^2 + b^2)*u
    x2 = b/(s-a)*ku*(s-a)/(s^2 - 2*a*s + a^2 + b^2)*u
       = b*ku/(s^2 - 2*a*s + a^2 + b^2)*u
    y  = k1*x1 + k2*x2
       = (k1*ku*(s-a) + k2*b*ku) / (s^2 - 2*a*s + a^2 + b^2)*u
       = (k1*ku*s + k2*b*ku - k1*ku*a) / (s^2 - 2*a*s + a^2 + b^2)*u
       = (cn*s + cn*a - cn*a) / (s^2 - 2*a*s + a^2 + b^2)*u
       = cn*s / (s^2 - 2*a*s + a^2 + b^2)*u

  comparing coefficients with
    y = cn*s / (s^2 + c1*s + c0)*u  ->  a = -c1/2
                                        b = sqrt(c0 - a^2)

  comparing with eigenvalue representation:
    (s - (a+jb))*(s - (a-jb)) = s^2 -2*a*s + a^2 + b^2
  shows that:
    a: real part of eigenvalue
    b: imaginary part of eigenvalue
</pre>

</html>"));
          end bandPass;

          function bandStop
            "Return band stop filter roots as needed for block for given cut-off frequency"
            extends Modelica.Icons.Function;

            input Real cr_in[:] "Coefficients of real poles of base filter";
            input Real c0_in[:]
              "Coefficients of s^0 term of base filter if conjugate complex pole";
            input Real c1_in[size(c0_in,1)]
              "Coefficients of s^1 term of base filter if conjugate complex pole";
            input Modelica.SIunits.Frequency f_min
              "Band of band stop filter is f_min (A=-3db) .. f_max (A=-3db)";
            input Modelica.SIunits.Frequency f_max "Upper band frequency";

            output Real a[size(cr_in,1) + 2*size(c0_in,1)]
              "Real parts of complex conjugate eigenvalues";
            output Real b[size(cr_in,1) + 2*size(c0_in,1)]
              "Imaginary parts of complex conjugate eigenvalues";
            output Real ku[size(cr_in,1) + 2*size(c0_in,1)]
              "Gains of input terms";
            output Real k1[size(cr_in,1) + 2*size(c0_in,1)]
              "Gains of y = k1*x1 + k2*x";
            output Real k2[size(cr_in,1) + 2*size(c0_in,1)]
              "Gains of y = k1*x1 + k2*x";
          protected
            Real cr[0];
            Real c0[size(a,1)];
            Real c1[size(a,1)];
            Real cn;
            Real bb;
          algorithm
            // Get coefficients of band stop filter at f_cut
            (cr, c0, c1) :=coefficients.bandStop(cr_in, c0_in, c1_in, f_min, f_max);

            // Transform coefficients in to roots
            for i in 1:size(a,1) loop
              a[i]  := -c1[i]/2;
              bb    := c0[i] - a[i]*a[i];
              assert(bb >= 0, "\nNot possible to use band stop filter, since transformation results in\n"+
                              "system that does not have conjugate complex poles.\n" +
                              "Try to use another analog filter for the band stop filter.\n");
              b[i]  := sqrt(bb);
              ku[i] := c0[i]/b[i];
              k1[i] := 2*a[i]/ku[i];
              k2[i] := (c0[i] + a[i]^2 - b[i]^2)/(b[i]*ku[i]);
            end for;

            annotation (Documentation(info="<html>

<p>
The goal is to implement the filter in the following form:
</p>

<pre>
  // complex conjugate poles:
  der(x1) = a*x1 - b*x2 + ku*u;
  der(x2) = b*x1 + a*x2;
       y  = k1*x1 + k2*x2 + u;

            ku = (a^2 + b^2)/b
            k1 = 2*a/ku
            k2 = (c0 + a^2 - b^2)/(b*ku)
</pre>
<p>
This representation has the following transfer function:
</p>
<pre>
// complex conjugate poles
    s*x2 =  a*x2 + b*x1
    s*x1 = -b*x2 + a*x1 + ku*u
  or
    (s-a)*x2               = b*x1  ->  x2 = b/(s-a)*x1
    (s + b^2/(s-a) - a)*x1 = ku*u  ->  (s(s-a) + b^2 - a*(s-a))*x1  = ku*(s-a)*u
                                   ->  (s^2 - 2*a*s + a^2 + b^2)*x1 = ku*(s-a)*u
  or
    x1 = ku*(s-a)/(s^2 - 2*a*s + a^2 + b^2)*u
    x2 = b/(s-a)*ku*(s-a)/(s^2 - 2*a*s + a^2 + b^2)*u
       = b*ku/(s^2 - 2*a*s + a^2 + b^2)*u
    y  = k1*x1 + k2*x2 + u
       = (k1*ku*(s-a) + k2*b*ku + s^2 - 2*a*s + a^2 + b^2) / (s^2 - 2*a*s + a^2 + b^2)*u
       = (s^2 + (k1*ku-2*a)*s + k2*b*ku - k1*ku*a + a^2 + b^2) / (s^2 - 2*a*s + a^2 + b^2)*u
       = (s^2 + c0 + a^2 - b^2 - 2*a^2 + a^2 + b^2) / (s^2 - 2*a*s + a^2 + b^2)*u
       = (s^2 + c0) / (s^2 - 2*a*s + a^2 + b^2)*u

  comparing coefficients with
    y = (s^2 + c0) / (s^2 + c1*s + c0)*u  ->  a = -c1/2
                                              b = sqrt(c0 - a^2)

  comparing with eigenvalue representation:
    (s - (a+jb))*(s - (a-jb)) = s^2 -2*a*s + a^2 + b^2
  shows that:
    a: real part of eigenvalue
    b: imaginary part of eigenvalue
</pre>

</html>"));
          end bandStop;
          end roots;

          package Utilities "Utility functions for filter computations"
              extends Modelica.Icons.InternalPackage;

            function BesselBaseCoefficients
            "Return coefficients of normalized low pass Bessel filter (= gain at cut-off frequency 1 rad/s is decreased 3dB)"
              extends Modelica.Icons.Function;

              import Modelica.Utilities.Streams;
              input Integer order "Order of filter in the range 1..41";
              output Real c1[mod(order, 2)]
              "[p] coefficients of Bessel denominator polynomials (a*p + 1)";
              output Real c2[integer(order/2),2]
              "[p^2, p] coefficients of Bessel denominator polynomials (b2*p^2 + b1*p + 1)";
              output Real alpha "Normalization factor";
            algorithm
              if order == 1 then
                alpha := 1.002377293007601;
                c1[1] := 0.9976283451109835;
              elseif order == 2 then
                alpha := 0.7356641785819585;
                c2[1, 1] := 0.6159132201783791;
                c2[1, 2] := 1.359315879600889;
              elseif order == 3 then
                alpha := 0.5704770156982642;
                c1[1] := 0.7548574865985343;
                c2[1, 1] := 0.4756958028827457;
                c2[1, 2] := 0.9980615136104388;
              elseif order == 4 then
                alpha := 0.4737978580281427;
                c2[1, 1] := 0.4873729247240677;
                c2[1, 2] := 1.337564170455762;
                c2[2, 1] := 0.3877724315741958;
                c2[2, 2] := 0.7730405590839861;
              elseif order == 5 then
                alpha := 0.4126226974763408;
                c1[1] := 0.6645723262620757;
                c2[1, 1] := 0.4115231900614016;
                c2[1, 2] := 1.138349926728708;
                c2[2, 1] := 0.3234938702877912;
                c2[2, 2] := 0.6205992985771313;
              elseif order == 6 then
                alpha := 0.3705098000736233;
                c2[1, 1] := 0.3874508649098960;
                c2[1, 2] := 1.219740879520741;
                c2[2, 1] := 0.3493298843155746;
                c2[2, 2] := 0.9670265529381365;
                c2[3, 1] := 0.2747419229514599;
                c2[3, 2] := 0.5122165075105700;
              elseif order == 7 then
                alpha := 0.3393452623586350;
                c1[1] := 0.5927147125821412;
                c2[1, 1] := 0.3383379423919174;
                c2[1, 2] := 1.092630816438030;
                c2[2, 1] := 0.3001025788696046;
                c2[2, 2] := 0.8289928256598656;
                c2[3, 1] := 0.2372867471539579;
                c2[3, 2] := 0.4325128641920154;
              elseif order == 8 then
                alpha := 0.3150267393795002;
                c2[1, 1] := 0.3151115975207653;
                c2[1, 2] := 1.109403015460190;
                c2[2, 1] := 0.2969344839572762;
                c2[2, 2] := 0.9737455812222699;
                c2[3, 1] := 0.2612545921889538;
                c2[3, 2] := 0.7190394712068573;
                c2[4, 1] := 0.2080523342974281;
                c2[4, 2] := 0.3721456473047434;
              elseif order == 9 then
                alpha := 0.2953310177184124;
                c1[1] := 0.5377196679501422;
                c2[1, 1] := 0.2824689124281034;
                c2[1, 2] := 1.022646191567475;
                c2[2, 1] := 0.2626824161383468;
                c2[2, 2] := 0.8695626454762596;
                c2[3, 1] := 0.2302781917677917;
                c2[3, 2] := 0.6309047553448520;
                c2[4, 1] := 0.1847991729757028;
                c2[4, 2] := 0.3251978031287202;
              elseif order == 10 then
                alpha := 0.2789426890619463;
                c2[1, 1] := 0.2640769908255582;
                c2[1, 2] := 1.019788132875305;
                c2[2, 1] := 0.2540802639216947;
                c2[2, 2] := 0.9377020417760623;
                c2[3, 1] := 0.2343577229427963;
                c2[3, 2] := 0.7802229808216112;
                c2[4, 1] := 0.2052193139338624;
                c2[4, 2] := 0.5594176813008133;
                c2[5, 1] := 0.1659546953748916;
                c2[5, 2] := 0.2878349616233292;
              elseif order == 11 then
                alpha := 0.2650227766037203;
                c1[1] := 0.4950265498954191;
                c2[1, 1] := 0.2411858478546218;
                c2[1, 2] := 0.9567800996387417;
                c2[2, 1] := 0.2296849355380925;
                c2[2, 2] := 0.8592523717113126;
                c2[3, 1] := 0.2107851705677406;
                c2[3, 2] := 0.7040216048898129;
                c2[4, 1] := 0.1846461385164021;
                c2[4, 2] := 0.5006729207276717;
                c2[5, 1] := 0.1504217970817433;
                c2[5, 2] := 0.2575070491320295;
              elseif order == 12 then
                alpha := 0.2530051198547209;
                c2[1, 1] := 0.2268294941204543;
                c2[1, 2] := 0.9473116570034053;
                c2[2, 1] := 0.2207657387793729;
                c2[2, 2] := 0.8933728946287606;
                c2[3, 1] := 0.2087600700376653;
                c2[3, 2] := 0.7886236252756229;
                c2[4, 1] := 0.1909959101492760;
                c2[4, 2] := 0.6389263649257017;
                c2[5, 1] := 0.1675208146048472;
                c2[5, 2] := 0.4517847275162215;
                c2[6, 1] := 0.1374257286372761;
                c2[6, 2] := 0.2324699157474680;
              elseif order == 13 then
                alpha := 0.2424910397561007;
                c1[1] := 0.4608848369928040;
                c2[1, 1] := 0.2099813050274780;
                c2[1, 2] := 0.8992478823790660;
                c2[2, 1] := 0.2027250423101359;
                c2[2, 2] := 0.8328117484224146;
                c2[3, 1] := 0.1907635894058731;
                c2[3, 2] := 0.7257379204691213;
                c2[4, 1] := 0.1742280397887686;
                c2[4, 2] := 0.5830640944868014;
                c2[5, 1] := 0.1530858190490478;
                c2[5, 2] := 0.4106192089751885;
                c2[6, 1] := 0.1264090712880446;
                c2[6, 2] := 0.2114980230156001;
              elseif order == 14 then
                alpha := 0.2331902368695848;
                c2[1, 1] := 0.1986162311411235;
                c2[1, 2] := 0.8876961808055535;
                c2[2, 1] := 0.1946683341271615;
                c2[2, 2] := 0.8500754229171967;
                c2[3, 1] := 0.1868331332895056;
                c2[3, 2] := 0.7764629313723603;
                c2[4, 1] := 0.1752118757862992;
                c2[4, 2] := 0.6699720402924552;
                c2[5, 1] := 0.1598906457908402;
                c2[5, 2] := 0.5348446712848934;
                c2[6, 1] := 0.1407810153019944;
                c2[6, 2] := 0.3755841316563539;
                c2[7, 1] := 0.1169627966707339;
                c2[7, 2] := 0.1937088226304455;
              elseif order == 15 then
                alpha := 0.2248854870552422;
                c1[1] := 0.4328492272335646;
                c2[1, 1] := 0.1857292591004588;
                c2[1, 2] := 0.8496337061962563;
                c2[2, 1] := 0.1808644178280136;
                c2[2, 2] := 0.8020517898136011;
                c2[3, 1] := 0.1728264404199081;
                c2[3, 2] := 0.7247449729331105;
                c2[4, 1] := 0.1616970125901954;
                c2[4, 2] := 0.6205369315943097;
                c2[5, 1] := 0.1475257264578426;
                c2[5, 2] := 0.4929612162355906;
                c2[6, 1] := 0.1301861023357119;
                c2[6, 2] := 0.3454770708040735;
                c2[7, 1] := 0.1087810777120188;
                c2[7, 2] := 0.1784526655428406;
              elseif order == 16 then
                alpha := 0.2174105053474761;
                c2[1, 1] := 0.1765637967473151;
                c2[1, 2] := 0.8377453068635511;
                c2[2, 1] := 0.1738525357503125;
                c2[2, 2] := 0.8102988957433199;
                c2[3, 1] := 0.1684627004613343;
                c2[3, 2] := 0.7563265923413258;
                c2[4, 1] := 0.1604519074815815;
                c2[4, 2] := 0.6776082294687619;
                c2[5, 1] := 0.1498828607802206;
                c2[5, 2] := 0.5766417034027680;
                c2[6, 1] := 0.1367764717792823;
                c2[6, 2] := 0.4563528264410489;
                c2[7, 1] := 0.1209810465419295;
                c2[7, 2] := 0.3193782657322374;
                c2[8, 1] := 0.1016312648007554;
                c2[8, 2] := 0.1652419227369036;
              elseif order == 17 then
                alpha := 0.2106355148193306;
                c1[1] := 0.4093223608497299;
                c2[1, 1] := 0.1664014345826274;
                c2[1, 2] := 0.8067173752345952;
                c2[2, 1] := 0.1629839591538256;
                c2[2, 2] := 0.7712924931447541;
                c2[3, 1] := 0.1573277802512491;
                c2[3, 2] := 0.7134213666303411;
                c2[4, 1] := 0.1494828185148637;
                c2[4, 2] := 0.6347841731714884;
                c2[5, 1] := 0.1394948812681826;
                c2[5, 2] := 0.5375594414619047;
                c2[6, 1] := 0.1273627583380806;
                c2[6, 2] := 0.4241608926375478;
                c2[7, 1] := 0.1129187258461290;
                c2[7, 2] := 0.2965752009703245;
                c2[8, 1] := 0.9533357359908857e-1;
                c2[8, 2] := 0.1537041700889585;
              elseif order == 18 then
                alpha := 0.2044575288651841;
                c2[1, 1] := 0.1588768571976356;
                c2[1, 2] := 0.7951914263212913;
                c2[2, 1] := 0.1569357024981854;
                c2[2, 2] := 0.7744529690772538;
                c2[3, 1] := 0.1530722206358810;
                c2[3, 2] := 0.7335304425992080;
                c2[4, 1] := 0.1473206710524167;
                c2[4, 2] := 0.6735038935387268;
                c2[5, 1] := 0.1397225420331520;
                c2[5, 2] := 0.5959151542621590;
                c2[6, 1] := 0.1303092459809849;
                c2[6, 2] := 0.5026483447894845;
                c2[7, 1] := 0.1190627367060072;
                c2[7, 2] := 0.3956893824587150;
                c2[8, 1] := 0.1058058030798994;
                c2[8, 2] := 0.2765091830730650;
                c2[9, 1] := 0.8974708108800873e-1;
                c2[9, 2] := 0.1435505288284833;
              elseif order == 19 then
                alpha := 0.1987936248083529;
                c1[1] := 0.3892259966869526;
                c2[1, 1] := 0.1506640012172225;
                c2[1, 2] := 0.7693121733774260;
                c2[2, 1] := 0.1481728062796673;
                c2[2, 2] := 0.7421133586741549;
                c2[3, 1] := 0.1440444668388838;
                c2[3, 2] := 0.6975075386214800;
                c2[4, 1] := 0.1383101628540374;
                c2[4, 2] := 0.6365464378910025;
                c2[5, 1] := 0.1310032283190998;
                c2[5, 2] := 0.5606211948462122;
                c2[6, 1] := 0.1221431166405330;
                c2[6, 2] := 0.4713530424221445;
                c2[7, 1] := 0.1116991161103884;
                c2[7, 2] := 0.3703717538617073;
                c2[8, 1] := 0.9948917351196349e-1;
                c2[8, 2] := 0.2587371155559744;
                c2[9, 1] := 0.8475989238107367e-1;
                c2[9, 2] := 0.1345537894555993;
              elseif order == 20 then
                alpha := 0.1935761760416219;
                c2[1, 1] := 0.1443871348337404;
                c2[1, 2] := 0.7584165598446141;
                c2[2, 1] := 0.1429501891353184;
                c2[2, 2] := 0.7423000962318863;
                c2[3, 1] := 0.1400877384920004;
                c2[3, 2] := 0.7104185332215555;
                c2[4, 1] := 0.1358210369491446;
                c2[4, 2] := 0.6634599783272630;
                c2[5, 1] := 0.1301773703034290;
                c2[5, 2] := 0.6024175491895959;
                c2[6, 1] := 0.1231826501439148;
                c2[6, 2] := 0.5285332736326852;
                c2[7, 1] := 0.1148465498575254;
                c2[7, 2] := 0.4431977385498628;
                c2[8, 1] := 0.1051289462376788;
                c2[8, 2] := 0.3477444062821162;
                c2[9, 1] := 0.9384622797485121e-1;
                c2[9, 2] := 0.2429038300327729;
                c2[10, 1] := 0.8028211612831444e-1;
                c2[10, 2] := 0.1265329974009533;
              elseif order == 21 then
                alpha := 0.1887494014766075;
                c1[1] := 0.3718070668941645;
                c2[1, 1] := 0.1376151928386445;
                c2[1, 2] := 0.7364290859445481;
                c2[2, 1] := 0.1357438914390695;
                c2[2, 2] := 0.7150167318935022;
                c2[3, 1] := 0.1326398453462415;
                c2[3, 2] := 0.6798001808470175;
                c2[4, 1] := 0.1283231214897678;
                c2[4, 2] := 0.6314663440439816;
                c2[5, 1] := 0.1228169159777534;
                c2[5, 2] := 0.5709353626166905;
                c2[6, 1] := 0.1161406100773184;
                c2[6, 2] := 0.4993087153571335;
                c2[7, 1] := 0.1082959649233524;
                c2[7, 2] := 0.4177766148584385;
                c2[8, 1] := 0.9923596957485723e-1;
                c2[8, 2] := 0.3274257287232124;
                c2[9, 1] := 0.8877776108724853e-1;
                c2[9, 2] := 0.2287218166767916;
                c2[10, 1] := 0.7624076527736326e-1;
                c2[10, 2] := 0.1193423971506988;
              elseif order == 22 then
                alpha := 0.1842668221199706;
                c2[1, 1] := 0.1323053462701543;
                c2[1, 2] := 0.7262446126765204;
                c2[2, 1] := 0.1312121721769772;
                c2[2, 2] := 0.7134286088450949;
                c2[3, 1] := 0.1290330911166814;
                c2[3, 2] := 0.6880287870435514;
                c2[4, 1] := 0.1257817990372067;
                c2[4, 2] := 0.6505015800059301;
                c2[5, 1] := 0.1214765261983008;
                c2[5, 2] := 0.6015107185211451;
                c2[6, 1] := 0.1161365140967959;
                c2[6, 2] := 0.5418983553698413;
                c2[7, 1] := 0.1097755171533100;
                c2[7, 2] := 0.4726370779831614;
                c2[8, 1] := 0.1023889478519956;
                c2[8, 2] := 0.3947439506537486;
                c2[9, 1] := 0.9392485861253800e-1;
                c2[9, 2] := 0.3090996703083202;
                c2[10, 1] := 0.8420273775456455e-1;
                c2[10, 2] := 0.2159561978556017;
                c2[11, 1] := 0.7257600023938262e-1;
                c2[11, 2] := 0.1128633732721116;
              elseif order == 23 then
                alpha := 0.1800893554453722;
                c1[1] := 0.3565232673929280;
                c2[1, 1] := 0.1266275171652706;
                c2[1, 2] := 0.7072778066734162;
                c2[2, 1] := 0.1251865227648538;
                c2[2, 2] := 0.6900676345785905;
                c2[3, 1] := 0.1227944815236645;
                c2[3, 2] := 0.6617011100576023;
                c2[4, 1] := 0.1194647013077667;
                c2[4, 2] := 0.6226432315773119;
                c2[5, 1] := 0.1152132989252356;
                c2[5, 2] := 0.5735222810625359;
                c2[6, 1] := 0.1100558598478487;
                c2[6, 2] := 0.5151027978024605;
                c2[7, 1] := 0.1040013558214886;
                c2[7, 2] := 0.4482410942032739;
                c2[8, 1] := 0.9704014176512626e-1;
                c2[8, 2] := 0.3738049984631116;
                c2[9, 1] := 0.8911683905758054e-1;
                c2[9, 2] := 0.2925028692588410;
                c2[10, 1] := 0.8005438265072295e-1;
                c2[10, 2] := 0.2044134600278901;
                c2[11, 1] := 0.6923832296800832e-1;
                c2[11, 2] := 0.1069984887283394;
              elseif order == 24 then
                alpha := 0.1761838665838427;
                c2[1, 1] := 0.1220804912720132;
                c2[1, 2] := 0.6978026874156063;
                c2[2, 1] := 0.1212296762358897;
                c2[2, 2] := 0.6874139794926736;
                c2[3, 1] := 0.1195328372961027;
                c2[3, 2] := 0.6667954259551859;
                c2[4, 1] := 0.1169990987333593;
                c2[4, 2] := 0.6362602049901176;
                c2[5, 1] := 0.1136409040480130;
                c2[5, 2] := 0.5962662188435553;
                c2[6, 1] := 0.1094722001757955;
                c2[6, 2] := 0.5474001634109253;
                c2[7, 1] := 0.1045052832229087;
                c2[7, 2] := 0.4903523180249535;
                c2[8, 1] := 0.9874509806025907e-1;
                c2[8, 2] := 0.4258751523524645;
                c2[9, 1] := 0.9217799943472177e-1;
                c2[9, 2] := 0.3547079765396403;
                c2[10, 1] := 0.8474633796250476e-1;
                c2[10, 2] := 0.2774145482392767;
                c2[11, 1] := 0.7627722381240495e-1;
                c2[11, 2] := 0.1939329108084139;
                c2[12, 1] := 0.6618645465422745e-1;
                c2[12, 2] := 0.1016670147947242;
              elseif order == 25 then
                alpha := 0.1725220521949266;
                c1[1] := 0.3429735385896000;
                c2[1, 1] := 0.1172525033170618;
                c2[1, 2] := 0.6812327932576614;
                c2[2, 1] := 0.1161194585333535;
                c2[2, 2] := 0.6671566071153211;
                c2[3, 1] := 0.1142375145794466;
                c2[3, 2] := 0.6439167855053158;
                c2[4, 1] := 0.1116157454252308;
                c2[4, 2] := 0.6118378416180135;
                c2[5, 1] := 0.1082654809459177;
                c2[5, 2] := 0.5713609763370088;
                c2[6, 1] := 0.1041985674230918;
                c2[6, 2] := 0.5230289949762722;
                c2[7, 1] := 0.9942439308123559e-1;
                c2[7, 2] := 0.4674627926041906;
                c2[8, 1] := 0.9394453593830893e-1;
                c2[8, 2] := 0.4053226688298811;
                c2[9, 1] := 0.8774221237222533e-1;
                c2[9, 2] := 0.3372372276379071;
                c2[10, 1] := 0.8075839512216483e-1;
                c2[10, 2] := 0.2636485508005428;
                c2[11, 1] := 0.7282483286646764e-1;
                c2[11, 2] := 0.1843801345273085;
                c2[12, 1] := 0.6338571166846652e-1;
                c2[12, 2] := 0.9680153764737715e-1;
              elseif order == 26 then
                alpha := 0.1690795702796737;
                c2[1, 1] := 0.1133168695796030;
                c2[1, 2] := 0.6724297955493932;
                c2[2, 1] := 0.1126417845769961;
                c2[2, 2] := 0.6638709519790540;
                c2[3, 1] := 0.1112948749545606;
                c2[3, 2] := 0.6468652038763624;
                c2[4, 1] := 0.1092823986944244;
                c2[4, 2] := 0.6216337070799265;
                c2[5, 1] := 0.1066130386697976;
                c2[5, 2] := 0.5885011413992190;
                c2[6, 1] := 0.1032969057045413;
                c2[6, 2] := 0.5478864278297548;
                c2[7, 1] := 0.9934388184210715e-1;
                c2[7, 2] := 0.5002885306054287;
                c2[8, 1] := 0.9476081523436283e-1;
                c2[8, 2] := 0.4462644847551711;
                c2[9, 1] := 0.8954648464575577e-1;
                c2[9, 2] := 0.3863930785049522;
                c2[10, 1] := 0.8368166847159917e-1;
                c2[10, 2] := 0.3212074592527143;
                c2[11, 1] := 0.7710664731701103e-1;
                c2[11, 2] := 0.2510470347119383;
                c2[12, 1] := 0.6965807988411425e-1;
                c2[12, 2] := 0.1756419294111342;
                c2[13, 1] := 0.6080674930548766e-1;
                c2[13, 2] := 0.9234535279274277e-1;
              elseif order == 27 then
                alpha := 0.1658353543067995;
                c1[1] := 0.3308543720638957;
                c2[1, 1] := 0.1091618578712746;
                c2[1, 2] := 0.6577977071169651;
                c2[2, 1] := 0.1082549561495043;
                c2[2, 2] := 0.6461121666520275;
                c2[3, 1] := 0.1067479247890451;
                c2[3, 2] := 0.6267937760991321;
                c2[4, 1] := 0.1046471079537577;
                c2[4, 2] := 0.6000750116745808;
                c2[5, 1] := 0.1019605976654259;
                c2[5, 2] := 0.5662734183049320;
                c2[6, 1] := 0.9869726954433709e-1;
                c2[6, 2] := 0.5257827234948534;
                c2[7, 1] := 0.9486520934132483e-1;
                c2[7, 2] := 0.4790595019077763;
                c2[8, 1] := 0.9046906518775348e-1;
                c2[8, 2] := 0.4266025862147336;
                c2[9, 1] := 0.8550529998276152e-1;
                c2[9, 2] := 0.3689188223512328;
                c2[10, 1] := 0.7995282239306020e-1;
                c2[10, 2] := 0.3064589322702932;
                c2[11, 1] := 0.7375174596252882e-1;
                c2[11, 2] := 0.2394754504667310;
                c2[12, 1] := 0.6674377263329041e-1;
                c2[12, 2] := 0.1676223546666024;
                c2[13, 1] := 0.5842458027529246e-1;
                c2[13, 2] := 0.8825044329219431e-1;
              elseif order == 28 then
                alpha := 0.1627710671942929;
                c2[1, 1] := 0.1057232656113488;
                c2[1, 2] := 0.6496161226860832;
                c2[2, 1] := 0.1051786825724864;
                c2[2, 2] := 0.6424661279909941;
                c2[3, 1] := 0.1040917964935006;
                c2[3, 2] := 0.6282470268918791;
                c2[4, 1] := 0.1024670101953951;
                c2[4, 2] := 0.6071189030701136;
                c2[5, 1] := 0.1003105109519892;
                c2[5, 2] := 0.5793175191747016;
                c2[6, 1] := 0.9762969425430802e-1;
                c2[6, 2] := 0.5451486608855443;
                c2[7, 1] := 0.9443223803058400e-1;
                c2[7, 2] := 0.5049796971628137;
                c2[8, 1] := 0.9072460982036488e-1;
                c2[8, 2] := 0.4592270546572523;
                c2[9, 1] := 0.8650956423253280e-1;
                c2[9, 2] := 0.4083368605952977;
                c2[10, 1] := 0.8178165740374893e-1;
                c2[10, 2] := 0.3527525188880655;
                c2[11, 1] := 0.7651838885868020e-1;
                c2[11, 2] := 0.2928534570013572;
                c2[12, 1] := 0.7066010532447490e-1;
                c2[12, 2] := 0.2288185204390681;
                c2[13, 1] := 0.6405358596145789e-1;
                c2[13, 2] := 0.1602396172588190;
                c2[14, 1] := 0.5621780070227172e-1;
                c2[14, 2] := 0.8447589564915071e-1;
              elseif order == 29 then
                alpha := 0.1598706626277596;
                c1[1] := 0.3199314513011623;
                c2[1, 1] := 0.1021101032532951;
                c2[1, 2] := 0.6365758882240111;
                c2[2, 1] := 0.1013729819392774;
                c2[2, 2] := 0.6267495975736321;
                c2[3, 1] := 0.1001476175660628;
                c2[3, 2] := 0.6104876178266819;
                c2[4, 1] := 0.9843854640428316e-1;
                c2[4, 2] := 0.5879603139195113;
                c2[5, 1] := 0.9625164534591696e-1;
                c2[5, 2] := 0.5594012291050210;
                c2[6, 1] := 0.9359356960417668e-1;
                c2[6, 2] := 0.5251016150410664;
                c2[7, 1] := 0.9047086748649986e-1;
                c2[7, 2] := 0.4854024475590397;
                c2[8, 1] := 0.8688856407189167e-1;
                c2[8, 2] := 0.4406826457109709;
                c2[9, 1] := 0.8284779224069856e-1;
                c2[9, 2] := 0.3913408089298914;
                c2[10, 1] := 0.7834154620997181e-1;
                c2[10, 2] := 0.3377643999400627;
                c2[11, 1] := 0.7334628941928766e-1;
                c2[11, 2] := 0.2802710651919946;
                c2[12, 1] := 0.6780290487362146e-1;
                c2[12, 2] := 0.2189770008083379;
                c2[13, 1] := 0.6156321231528423e-1;
                c2[13, 2] := 0.1534235999306070;
                c2[14, 1] := 0.5416797446761512e-1;
                c2[14, 2] := 0.8098664736760292e-1;
              elseif order == 30 then
                alpha := 0.1571200296252450;
                c2[1, 1] := 0.9908074847842124e-1;
                c2[1, 2] := 0.6289618807831557;
                c2[2, 1] := 0.9863509708328196e-1;
                c2[2, 2] := 0.6229164525571278;
                c2[3, 1] := 0.9774542692037148e-1;
                c2[3, 2] := 0.6108853364240036;
                c2[4, 1] := 0.9641490581986484e-1;
                c2[4, 2] := 0.5929869253412513;
                c2[5, 1] := 0.9464802912225441e-1;
                c2[5, 2] := 0.5693960175547550;
                c2[6, 1] := 0.9245027206218041e-1;
                c2[6, 2] := 0.5403402396359503;
                c2[7, 1] := 0.8982754584112941e-1;
                c2[7, 2] := 0.5060948065875106;
                c2[8, 1] := 0.8678535291732599e-1;
                c2[8, 2] := 0.4669749797983789;
                c2[9, 1] := 0.8332744242052199e-1;
                c2[9, 2] := 0.4233249626334694;
                c2[10, 1] := 0.7945356393775309e-1;
                c2[10, 2] := 0.3755006094498054;
                c2[11, 1] := 0.7515543969833788e-1;
                c2[11, 2] := 0.3238400339292700;
                c2[12, 1] := 0.7040879901685638e-1;
                c2[12, 2] := 0.2686072427439079;
                c2[13, 1] := 0.6515528854010540e-1;
                c2[13, 2] := 0.2098650589782619;
                c2[14, 1] := 0.5925168237177876e-1;
                c2[14, 2] := 0.1471138832654873;
                c2[15, 1] := 0.5225913954211672e-1;
                c2[15, 2] := 0.7775248839507864e-1;
              elseif order == 31 then
                alpha := 0.1545067022920929;
                c1[1] := 0.3100206996451866;
                c2[1, 1] := 0.9591020358831668e-1;
                c2[1, 2] := 0.6172474793293396;
                c2[2, 1] := 0.9530301275601203e-1;
                c2[2, 2] := 0.6088916323460413;
                c2[3, 1] := 0.9429332655402368e-1;
                c2[3, 2] := 0.5950511595503025;
                c2[4, 1] := 0.9288445429894548e-1;
                c2[4, 2] := 0.5758534119053522;
                c2[5, 1] := 0.9108073420087422e-1;
                c2[5, 2] := 0.5514734636081183;
                c2[6, 1] := 0.8888719137536870e-1;
                c2[6, 2] := 0.5221306199481831;
                c2[7, 1] := 0.8630901440239650e-1;
                c2[7, 2] := 0.4880834248148061;
                c2[8, 1] := 0.8335074993373294e-1;
                c2[8, 2] := 0.4496225358496770;
                c2[9, 1] := 0.8001502494376102e-1;
                c2[9, 2] := 0.4070602306679052;
                c2[10, 1] := 0.7630041338037624e-1;
                c2[10, 2] := 0.3607139804818122;
                c2[11, 1] := 0.7219760885744920e-1;
                c2[11, 2] := 0.3108783301229550;
                c2[12, 1] := 0.6768185077153345e-1;
                c2[12, 2] := 0.2577706252514497;
                c2[13, 1] := 0.6269571766328638e-1;
                c2[13, 2] := 0.2014081375889921;
                c2[14, 1] := 0.5710081766945065e-1;
                c2[14, 2] := 0.1412581515841926;
                c2[15, 1] := 0.5047740914807019e-1;
                c2[15, 2] := 0.7474725873250158e-1;
              elseif order == 32 then
                alpha := 0.1520196210848210;
                c2[1, 1] := 0.9322163554339406e-1;
                c2[1, 2] := 0.6101488690506050;
                c2[2, 1] := 0.9285233997694042e-1;
                c2[2, 2] := 0.6049832320721264;
                c2[3, 1] := 0.9211494244473163e-1;
                c2[3, 2] := 0.5946969295569034;
                c2[4, 1] := 0.9101176786042449e-1;
                c2[4, 2] := 0.5793791854364477;
                c2[5, 1] := 0.8954614071360517e-1;
                c2[5, 2] := 0.5591619969234026;
                c2[6, 1] := 0.8772216763680164e-1;
                c2[6, 2] := 0.5342177994699602;
                c2[7, 1] := 0.8554440426912734e-1;
                c2[7, 2] := 0.5047560942986598;
                c2[8, 1] := 0.8301735302045588e-1;
                c2[8, 2] := 0.4710187048140929;
                c2[9, 1] := 0.8014469519188161e-1;
                c2[9, 2] := 0.4332730387207936;
                c2[10, 1] := 0.7692807528893225e-1;
                c2[10, 2] := 0.3918021436411035;
                c2[11, 1] := 0.7336507157284898e-1;
                c2[11, 2] := 0.3468890521471250;
                c2[12, 1] := 0.6944555312763458e-1;
                c2[12, 2] := 0.2987898029050460;
                c2[13, 1] := 0.6514446669420571e-1;
                c2[13, 2] := 0.2476810747407199;
                c2[14, 1] := 0.6040544477732702e-1;
                c2[14, 2] := 0.1935412053397663;
                c2[15, 1] := 0.5509478650672775e-1;
                c2[15, 2] := 0.1358108994174911;
                c2[16, 1] := 0.4881064725720192e-1;
                c2[16, 2] := 0.7194819894416505e-1;
              elseif order == 33 then
                alpha := 0.1496489351138032;
                c1[1] := 0.3009752799176432;
                c2[1, 1] := 0.9041725460994505e-1;
                c2[1, 2] := 0.5995521047364046;
                c2[2, 1] := 0.8991117804113002e-1;
                c2[2, 2] := 0.5923764112099496;
                c2[3, 1] := 0.8906941547422532e-1;
                c2[3, 2] := 0.5804822013853129;
                c2[4, 1] := 0.8789442491445575e-1;
                c2[4, 2] := 0.5639663528946501;
                c2[5, 1] := 0.8638945831033775e-1;
                c2[5, 2] := 0.5429623519607796;
                c2[6, 1] := 0.8455834602616358e-1;
                c2[6, 2] := 0.5176379938389326;
                c2[7, 1] := 0.8240517431382334e-1;
                c2[7, 2] := 0.4881921474066189;
                c2[8, 1] := 0.7993380417355076e-1;
                c2[8, 2] := 0.4548502528082586;
                c2[9, 1] := 0.7714713890732801e-1;
                c2[9, 2] := 0.4178579388038483;
                c2[10, 1] := 0.7404596598181127e-1;
                c2[10, 2] := 0.3774715722484659;
                c2[11, 1] := 0.7062702339160462e-1;
                c2[11, 2] := 0.3339432938810453;
                c2[12, 1] := 0.6687952672391507e-1;
                c2[12, 2] := 0.2874950693388235;
                c2[13, 1] := 0.6277828912909767e-1;
                c2[13, 2] := 0.2382680702894708;
                c2[14, 1] := 0.5826808305383988e-1;
                c2[14, 2] := 0.1862073169968455;
                c2[15, 1] := 0.5321974125363517e-1;
                c2[15, 2] := 0.1307323751236313;
                c2[16, 1] := 0.4724820282032780e-1;
                c2[16, 2] := 0.6933542082177094e-1;
              elseif order == 34 then
                alpha := 0.1473858373968463;
                c2[1, 1] := 0.8801537152275983e-1;
                c2[1, 2] := 0.5929204288972172;
                c2[2, 1] := 0.8770594341007476e-1;
                c2[2, 2] := 0.5884653382247518;
                c2[3, 1] := 0.8708797598072095e-1;
                c2[3, 2] := 0.5795895850253119;
                c2[4, 1] := 0.8616320590689187e-1;
                c2[4, 2] := 0.5663615383647170;
                c2[5, 1] := 0.8493413175570858e-1;
                c2[5, 2] := 0.5488825092350877;
                c2[6, 1] := 0.8340387368687513e-1;
                c2[6, 2] := 0.5272851839324592;
                c2[7, 1] := 0.8157596213131521e-1;
                c2[7, 2] := 0.5017313864372913;
                c2[8, 1] := 0.7945402670834270e-1;
                c2[8, 2] := 0.4724089864574216;
                c2[9, 1] := 0.7704133559556429e-1;
                c2[9, 2] := 0.4395276256463053;
                c2[10, 1] := 0.7434009635219704e-1;
                c2[10, 2] := 0.4033126590648964;
                c2[11, 1] := 0.7135035113853376e-1;
                c2[11, 2] := 0.3639961488919042;
                c2[12, 1] := 0.6806813160738834e-1;
                c2[12, 2] := 0.3218025212900124;
                c2[13, 1] := 0.6448214312000864e-1;
                c2[13, 2] := 0.2769235521088158;
                c2[14, 1] := 0.6056719318430530e-1;
                c2[14, 2] := 0.2294693573271038;
                c2[15, 1] := 0.5626925196925040e-1;
                c2[15, 2] := 0.1793564218840015;
                c2[16, 1] := 0.5146352031547277e-1;
                c2[16, 2] := 0.1259877129326412;
                c2[17, 1] := 0.4578069074410591e-1;
                c2[17, 2] := 0.6689147319568768e-1;
              elseif order == 35 then
                alpha := 0.1452224267615486;
                c1[1] := 0.2926764667564367;
                c2[1, 1] := 0.8551731299267280e-1;
                c2[1, 2] := 0.5832758214629523;
                c2[2, 1] := 0.8509109732853060e-1;
                c2[2, 2] := 0.5770596582643844;
                c2[3, 1] := 0.8438201446671953e-1;
                c2[3, 2] := 0.5667497616665494;
                c2[4, 1] := 0.8339191981579831e-1;
                c2[4, 2] := 0.5524209816238369;
                c2[5, 1] := 0.8212328610083385e-1;
                c2[5, 2] := 0.5341766459916322;
                c2[6, 1] := 0.8057906332198853e-1;
                c2[6, 2] := 0.5121470053512750;
                c2[7, 1] := 0.7876247299954955e-1;
                c2[7, 2] := 0.4864870722254752;
                c2[8, 1] := 0.7667670879950268e-1;
                c2[8, 2] := 0.4573736721705665;
                c2[9, 1] := 0.7432449556218945e-1;
                c2[9, 2] := 0.4250013835198991;
                c2[10, 1] := 0.7170742126011575e-1;
                c2[10, 2] := 0.3895767735915445;
                c2[11, 1] := 0.6882488171701314e-1;
                c2[11, 2] := 0.3513097926737368;
                c2[12, 1] := 0.6567231746957568e-1;
                c2[12, 2] := 0.3103999917596611;
                c2[13, 1] := 0.6223804362223595e-1;
                c2[13, 2] := 0.2670123611280899;
                c2[14, 1] := 0.5849696460782910e-1;
                c2[14, 2] := 0.2212298104867592;
                c2[15, 1] := 0.5439628409499822e-1;
                c2[15, 2] := 0.1729443731341637;
                c2[16, 1] := 0.4981540179136920e-1;
                c2[16, 2] := 0.1215462157134930;
                c2[17, 1] := 0.4439981033536435e-1;
                c2[17, 2] := 0.6460098363520967e-1;
              elseif order == 36 then
                alpha := 0.1431515914458580;
                c2[1, 1] := 0.8335881847130301e-1;
                c2[1, 2] := 0.5770670512160201;
                c2[2, 1] := 0.8309698922852212e-1;
                c2[2, 2] := 0.5731929100172432;
                c2[3, 1] := 0.8257400347039723e-1;
                c2[3, 2] := 0.5654713811993058;
                c2[4, 1] := 0.8179117911600136e-1;
                c2[4, 2] := 0.5539556343603020;
                c2[5, 1] := 0.8075042173126963e-1;
                c2[5, 2] := 0.5387245649546684;
                c2[6, 1] := 0.7945413151258206e-1;
                c2[6, 2] := 0.5198817177723069;
                c2[7, 1] := 0.7790506514288866e-1;
                c2[7, 2] := 0.4975537629595409;
                c2[8, 1] := 0.7610613635339480e-1;
                c2[8, 2] := 0.4718884193866789;
                c2[9, 1] := 0.7406012816626425e-1;
                c2[9, 2] := 0.4430516443136726;
                c2[10, 1] := 0.7176927060205631e-1;
                c2[10, 2] := 0.4112237708115829;
                c2[11, 1] := 0.6923460172504251e-1;
                c2[11, 2] := 0.3765940116389730;
                c2[12, 1] := 0.6645495833489556e-1;
                c2[12, 2] := 0.3393522147815403;
                c2[13, 1] := 0.6342528888937094e-1;
                c2[13, 2] := 0.2996755899575573;
                c2[14, 1] := 0.6013361864949449e-1;
                c2[14, 2] := 0.2577053294053830;
                c2[15, 1] := 0.5655503081322404e-1;
                c2[15, 2] := 0.2135004731531631;
                c2[16, 1] := 0.5263798119559069e-1;
                c2[16, 2] := 0.1669320999865636;
                c2[17, 1] := 0.4826589873626196e-1;
                c2[17, 2] := 0.1173807590715484;
                c2[18, 1] := 0.4309819397289806e-1;
                c2[18, 2] := 0.6245036108880222e-1;
              elseif order == 37 then
                alpha := 0.1411669104782917;
                c1[1] := 0.2850271036215707;
                c2[1, 1] := 0.8111958235023328e-1;
                c2[1, 2] := 0.5682412610563970;
                c2[2, 1] := 0.8075727567979578e-1;
                c2[2, 2] := 0.5628142923227016;
                c2[3, 1] := 0.8015440554413301e-1;
                c2[3, 2] := 0.5538087696879930;
                c2[4, 1] := 0.7931239302677386e-1;
                c2[4, 2] := 0.5412833323304460;
                c2[5, 1] := 0.7823314328639347e-1;
                c2[5, 2] := 0.5253190555393968;
                c2[6, 1] := 0.7691895211595101e-1;
                c2[6, 2] := 0.5060183741977191;
                c2[7, 1] := 0.7537237072011853e-1;
                c2[7, 2] := 0.4835036020049034;
                c2[8, 1] := 0.7359601294804538e-1;
                c2[8, 2] := 0.4579149413954837;
                c2[9, 1] := 0.7159227884849299e-1;
                c2[9, 2] := 0.4294078049978829;
                c2[10, 1] := 0.6936295002846032e-1;
                c2[10, 2] := 0.3981491350382047;
                c2[11, 1] := 0.6690857785828917e-1;
                c2[11, 2] := 0.3643121502867948;
                c2[12, 1] := 0.6422751692085542e-1;
                c2[12, 2] := 0.3280684291406284;
                c2[13, 1] := 0.6131430866206096e-1;
                c2[13, 2] := 0.2895750997170303;
                c2[14, 1] := 0.5815677249570920e-1;
                c2[14, 2] := 0.2489521814805720;
                c2[15, 1] := 0.5473023527947980e-1;
                c2[15, 2] := 0.2062377435955363;
                c2[16, 1] := 0.5098441033167034e-1;
                c2[16, 2] := 0.1612849131645336;
                c2[17, 1] := 0.4680658811093562e-1;
                c2[17, 2] := 0.1134672937045305;
                c2[18, 1] := 0.4186928031694695e-1;
                c2[18, 2] := 0.6042754777339966e-1;
              elseif order == 38 then
                alpha := 0.1392625697140030;
                c2[1, 1] := 0.7916943373658329e-1;
                c2[1, 2] := 0.5624158631591745;
                c2[2, 1] := 0.7894592250257840e-1;
                c2[2, 2] := 0.5590219398777304;
                c2[3, 1] := 0.7849941672384930e-1;
                c2[3, 2] := 0.5522551628416841;
                c2[4, 1] := 0.7783093084875645e-1;
                c2[4, 2] := 0.5421574325808380;
                c2[5, 1] := 0.7694193770482690e-1;
                c2[5, 2] := 0.5287909941093643;
                c2[6, 1] := 0.7583430534712885e-1;
                c2[6, 2] := 0.5122376814029880;
                c2[7, 1] := 0.7451020436122948e-1;
                c2[7, 2] := 0.4925978555548549;
                c2[8, 1] := 0.7297197617673508e-1;
                c2[8, 2] := 0.4699889739625235;
                c2[9, 1] := 0.7122194706992953e-1;
                c2[9, 2] := 0.4445436860615774;
                c2[10, 1] := 0.6926216260386816e-1;
                c2[10, 2] := 0.4164072786327193;
                c2[11, 1] := 0.6709399961255503e-1;
                c2[11, 2] := 0.3857341621868851;
                c2[12, 1] := 0.6471757977022456e-1;
                c2[12, 2] := 0.3526828388476838;
                c2[13, 1] := 0.6213084287116965e-1;
                c2[13, 2] := 0.3174082831364342;
                c2[14, 1] := 0.5932799638550641e-1;
                c2[14, 2] := 0.2800495563550299;
                c2[15, 1] := 0.5629672408524944e-1;
                c2[15, 2] := 0.2407078154782509;
                c2[16, 1] := 0.5301264751544952e-1;
                c2[16, 2] := 0.1994026830553859;
                c2[17, 1] := 0.4942673259817896e-1;
                c2[17, 2] := 0.1559719194038917;
                c2[18, 1] := 0.4542996716979947e-1;
                c2[18, 2] := 0.1097844277878470;
                c2[19, 1] := 0.4070720755433961e-1;
                c2[19, 2] := 0.5852181110523043e-1;
              elseif order == 39 then
                alpha := 0.1374332900196804;
                c1[1] := 0.2779468246419593;
                c2[1, 1] := 0.7715084161825772e-1;
                c2[1, 2] := 0.5543001331300056;
                c2[2, 1] := 0.7684028301163326e-1;
                c2[2, 2] := 0.5495289890712267;
                c2[3, 1] := 0.7632343924866024e-1;
                c2[3, 2] := 0.5416083298429741;
                c2[4, 1] := 0.7560141319808483e-1;
                c2[4, 2] := 0.5305846713929198;
                c2[5, 1] := 0.7467569064745969e-1;
                c2[5, 2] := 0.5165224112570647;
                c2[6, 1] := 0.7354807648551346e-1;
                c2[6, 2] := 0.4995030679271456;
                c2[7, 1] := 0.7222060351121389e-1;
                c2[7, 2] := 0.4796242430956156;
                c2[8, 1] := 0.7069540462458585e-1;
                c2[8, 2] := 0.4569982440368368;
                c2[9, 1] := 0.6897453353492381e-1;
                c2[9, 2] := 0.4317502624832354;
                c2[10, 1] := 0.6705970959388781e-1;
                c2[10, 2] := 0.4040159353969854;
                c2[11, 1] := 0.6495194541066725e-1;
                c2[11, 2] := 0.3739379843169939;
                c2[12, 1] := 0.6265098412417610e-1;
                c2[12, 2] := 0.3416613843816217;
                c2[13, 1] := 0.6015440984955930e-1;
                c2[13, 2] := 0.3073260166338746;
                c2[14, 1] := 0.5745615876877304e-1;
                c2[14, 2] := 0.2710546723961181;
                c2[15, 1] := 0.5454383762391338e-1;
                c2[15, 2] := 0.2329316824061170;
                c2[16, 1] := 0.5139340231935751e-1;
                c2[16, 2] := 0.1929604256043231;
                c2[17, 1] := 0.4795705862458131e-1;
                c2[17, 2] := 0.1509655259246037;
                c2[18, 1] := 0.4412933231935506e-1;
                c2[18, 2] := 0.1063130748962878;
                c2[19, 1] := 0.3960672309405603e-1;
                c2[19, 2] := 0.5672356837211527e-1;
              elseif order == 40 then
                alpha := 0.1356742655825434;
                c2[1, 1] := 0.7538038374294594e-1;
                c2[1, 2] := 0.5488228264329617;
                c2[2, 1] := 0.7518806529402738e-1;
                c2[2, 2] := 0.5458297722483311;
                c2[3, 1] := 0.7480383050347119e-1;
                c2[3, 2] := 0.5398604576730540;
                c2[4, 1] := 0.7422847031965465e-1;
                c2[4, 2] := 0.5309482987446206;
                c2[5, 1] := 0.7346313704205006e-1;
                c2[5, 2] := 0.5191429845322307;
                c2[6, 1] := 0.7250930053201402e-1;
                c2[6, 2] := 0.5045099368431007;
                c2[7, 1] := 0.7136868456879621e-1;
                c2[7, 2] := 0.4871295553902607;
                c2[8, 1] := 0.7004317764946634e-1;
                c2[8, 2] := 0.4670962098860498;
                c2[9, 1] := 0.6853470921527828e-1;
                c2[9, 2] := 0.4445169164956202;
                c2[10, 1] := 0.6684507689945471e-1;
                c2[10, 2] := 0.4195095960479698;
                c2[11, 1] := 0.6497570123412630e-1;
                c2[11, 2] := 0.3922007419030645;
                c2[12, 1] := 0.6292726794917847e-1;
                c2[12, 2] := 0.3627221993494397;
                c2[13, 1] := 0.6069918741663154e-1;
                c2[13, 2] := 0.3312065181294388;
                c2[14, 1] := 0.5828873983769410e-1;
                c2[14, 2] := 0.2977798532686911;
                c2[15, 1] := 0.5568964389813015e-1;
                c2[15, 2] := 0.2625503293999835;
                c2[16, 1] := 0.5288947816690705e-1;
                c2[16, 2] := 0.2255872486520188;
                c2[17, 1] := 0.4986456327645859e-1;
                c2[17, 2] := 0.1868796731919594;
                c2[18, 1] := 0.4656832613054458e-1;
                c2[18, 2] := 0.1462410193532463;
                c2[19, 1] := 0.4289867647614935e-1;
                c2[19, 2] := 0.1030361558710747;
                c2[20, 1] := 0.3856310684054106e-1;
                c2[20, 2] := 0.5502423832293889e-1;
              elseif order == 41 then
                alpha := 0.1339811106984253;
                c1[1] := 0.2713685065531391;
                c2[1, 1] := 0.7355140275160984e-1;
                c2[1, 2] := 0.5413274778282860;
                c2[2, 1] := 0.7328319082267173e-1;
                c2[2, 2] := 0.5371064088294270;
                c2[3, 1] := 0.7283676160772547e-1;
                c2[3, 2] := 0.5300963437270770;
                c2[4, 1] := 0.7221298133014343e-1;
                c2[4, 2] := 0.5203345998371490;
                c2[5, 1] := 0.7141302173623395e-1;
                c2[5, 2] := 0.5078728971879841;
                c2[6, 1] := 0.7043831559982149e-1;
                c2[6, 2] := 0.4927768111819803;
                c2[7, 1] := 0.6929049381827268e-1;
                c2[7, 2] := 0.4751250308594139;
                c2[8, 1] := 0.6797129849758392e-1;
                c2[8, 2] := 0.4550083840638406;
                c2[9, 1] := 0.6648246325101609e-1;
                c2[9, 2] := 0.4325285673076087;
                c2[10, 1] := 0.6482554675958526e-1;
                c2[10, 2] := 0.4077964789091151;
                c2[11, 1] := 0.6300169683004558e-1;
                c2[11, 2] := 0.3809299858742483;
                c2[12, 1] := 0.6101130648543355e-1;
                c2[12, 2] := 0.3520508315700898;
                c2[13, 1] := 0.5885349417435808e-1;
                c2[13, 2] := 0.3212801560701271;
                c2[14, 1] := 0.5652528148656809e-1;
                c2[14, 2] := 0.2887316252774887;
                c2[15, 1] := 0.5402021575818373e-1;
                c2[15, 2] := 0.2545001287790888;
                c2[16, 1] := 0.5132588802608274e-1;
                c2[16, 2] := 0.2186415296842951;
                c2[17, 1] := 0.4841900639702602e-1;
                c2[17, 2] := 0.1811322622296060;
                c2[18, 1] := 0.4525419574485134e-1;
                c2[18, 2] := 0.1417762065404688;
                c2[19, 1] := 0.4173260173087802e-1;
                c2[19, 2] := 0.9993834530966510e-1;
                c2[20, 1] := 0.3757210572966463e-1;
                c2[20, 2] := 0.5341611499960143e-1;
              else
                Streams.error("Input argument order (= " + String(order) +
                  ") of Bessel filter is not in the range 1..41");
              end if;

              annotation (Documentation(info="<html><p>The transfer function H(p) of a <i>n</i> 'th order Bessel filter is given by</p>
<blockquote><pre>
        Bn(0)
H(p) = -------
        Bn(p)
 </pre>
</blockquote>
<p>with the denominator polynomial</p>
<blockquote><pre>
         n             n  (2n - k)!       p^k
Bn(p) = sum c_k*p^k = sum ----------- * -------   (1)
        k=0           k=0 (n - k)!k!    2^(n-k)
</pre></blockquote>
<p>and the numerator</p>
<blockquote><pre>
               (2n)!     1
Bn(0) = c_0 = ------- * ---- .                    (2)
                n!      2^n
 </pre></blockquote>
<p>Although the coefficients c_k are integer numbers, it is not advisable to use the
polynomials in an unfactorized form because the coefficients are fast growing with order
n (c_0 is approximately 0.3e24 and 0.8e59 for order n=20 and order n=40
respectively).</p>

<p>Therefore, the polynomial Bn(p) is factorized to first and second order polynomials with
real coefficients corresponding to zeros and poles representation that is used in this library.</p>

<p>The function returns the coefficients which resulted from factorization of the normalized transfer function</p>
<blockquote><pre>
H'(p') = H(p),  p' = p/w0
</pre></blockquote>
<p>as well as</p>
<blockquote><pre>
alpha = 1/w0
</pre></blockquote>
<p>the reciprocal of the cut of frequency w0 where the gain of the transfer function is
decreased 3dB.</p>

<p>Both, coefficients and cut off frequency were calculated symbolically and were eventually evaluated
with high precision calculation. The results were stored in this function as real
numbers.</p>

<h4>Calculation of normalized Bessel filter coefficients</h4>
<p>Equation</p>
<blockquote><pre>
abs(H(j*w0)) = abs(Bn(0)/Bn(j*w0)) = 10^(-3/20)
</pre></blockquote>
<p>which must be fulfilled for cut off frequency w = w0 leads to</p>
<blockquote><pre>
[Re(Bn(j*w0))]^2 + [Im(Bn(j*w0))]^2 - (Bn(0)^2)*10^(3/10) = 0
</pre></blockquote>
<p>which has exactly one real solution w0 for each order n. This solutions of w0 are
calculated symbolically first and evaluated by using high precise values of the
coefficients c_k calculated by following (1) and (2).</p>

<p>With w0, the coefficients of the factorized polynomial can be computed by calculating the
zeros of the denominator polynomial</p>
<blockquote><pre>
        n
Bn(p) = sum w0^k*c_k*(p/w0)^k
        k=0
</pre></blockquote>
<p>of the normalized transfer function H'(p'). There exist n/2 of conjugate complex
pairs of zeros (beta +-j*gamma) if n is even and one additional real zero (alpha) if n is
odd. Finally, the coefficients a, b1_k, b2_k of the polynomials</p>
<blockquote><pre> a*p + 1,  n is odd </pre></blockquote>
<p>and</p>
<blockquote><pre>
b2_k*p^2 + b1_k*p + 1,   k = 1,... div(n,2)
</pre></blockquote>
<p>results from</p>
<blockquote><pre>
a = -1/alpha
</pre></blockquote>
<p>and</p>
<blockquote><pre>
b2_k = 1/(beta_k^2 + gamma_k^2) b1_k = -2*beta_k/(beta_k^2 + gamma_k^2)
</pre></blockquote>
</html>"));
            end BesselBaseCoefficients;

            function toHighestPowerOne
            "Transform filter to form with highest power of s equal 1"
              extends Modelica.Icons.Function;

              input Real den1[:]
              "[s] coefficients of polynomials (den1[i]*s + 1)";
              input Real den2[:,2]
              "[s^2, s] coefficients of polynomials (den2[i,1]*s^2 + den2[i,2]*s + 1)";
              output Real cr[size(den1, 1)]
              "[s^0] coefficients of polynomials cr[i]*(s+1/cr[i])";
              output Real c0[size(den2, 1)]
              "[s^0] coefficients of polynomials (s^2 + (den2[i,2]/den2[i,1])*s + (1/den2[i,1]))";
              output Real c1[size(den2, 1)]
              "[s^1] coefficients of polynomials (s^2 + (den2[i,2]/den2[i,1])*s + (1/den2[i,1]))";
            algorithm
              for i in 1:size(den1, 1) loop
                cr[i] := 1/den1[i];
              end for;

              for i in 1:size(den2, 1) loop
                c1[i] := den2[i, 2]/den2[i, 1];
                c0[i] := 1/den2[i, 1];
              end for;
            end toHighestPowerOne;

            function normalizationFactor
            "Compute correction factor of low pass filter such that amplitude at cut-off frequency is -3db (=10^(-3/20) = 0.70794...)"
              extends Modelica.Icons.Function;

              import Modelica;
              import Modelica.Utilities.Streams;

              input Real c1[:]
              "[p] coefficients of denominator polynomials (c1[i}*p + 1)";
              input Real c2[:,2]
              "[p^2, p] coefficients of denominator polynomials (c2[i,1]*p^2 + c2[i,2]*p + 1)";
              output Real alpha "Correction factor (replace p by alpha*p)";
          protected
              Real alpha_min;
              Real alpha_max;

              function normalizationResidue
              "Residue of correction factor computation"
                extends Modelica.Icons.Function;
                input Real c1[:]
                "[p] coefficients of denominator polynomials (c1[i]*p + 1)";
                input Real c2[:,2]
                "[p^2, p] coefficients of denominator polynomials (c2[i,1]*p^2 + c2[i,2]*p + 1)";
                input Real alpha;
                output Real residue;
            protected
                constant Real beta= 10^(-3/20)
                "Amplitude of -3db required, i.e., -3db = 20*log(beta)";
                Real cc1;
                Real cc2;
                Real p;
                Real alpha2=alpha*alpha;
                Real alpha4=alpha2*alpha2;
                Real A2=1.0;
              algorithm
                assert(size(c1,1) <= 1, "Internal error 2 (should not occur)");
                if size(c1, 1) == 1 then
                  cc1 := c1[1]*c1[1];
                  p := 1 + cc1*alpha2;
                  A2 := A2*p;
                end if;
                for i in 1:size(c2, 1) loop
                  cc1 := c2[i, 2]*c2[i, 2] - 2*c2[i, 1];
                  cc2 := c2[i, 1]*c2[i, 1];
                  p := 1 + cc1*alpha2 + cc2*alpha4;
                  A2 := A2*p;
                end for;
                residue := 1/sqrt(A2) - beta;
              end normalizationResidue;

              function findInterval "Find interval for the root"
                extends Modelica.Icons.Function;
                input Real c1[:]
                "[p] coefficients of denominator polynomials (a*p + 1)";
                input Real c2[:,2]
                "[p^2, p] coefficients of denominator polynomials (b*p^2 + a*p + 1)";
                output Real alpha_min;
                output Real alpha_max;
            protected
                Real alpha = 1.0;
                Real residue;
              algorithm
                alpha_min :=0;
                residue := normalizationResidue(c1, c2, alpha);
                if residue < 0 then
                   alpha_max :=alpha;
                else
                   while residue >= 0 loop
                      alpha := 1.1*alpha;
                      residue := normalizationResidue(c1, c2, alpha);
                   end while;
                   alpha_max :=alpha;
                end if;
              end findInterval;

            function solveOneNonlinearEquation
              "Solve f(u) = 0; f(u_min) and f(u_max) must have different signs"
                extends Modelica.Icons.Function;
                import Modelica.Utilities.Streams.error;

              input Real c1[:]
                "[p] coefficients of denominator polynomials (c1[i]*p + 1)";
              input Real c2[:,2]
                "[p^2, p] coefficients of denominator polynomials (c2[i,1]*p^2 + c2[i,2]*p + 1)";
              input Real u_min "Lower bound of search interval";
              input Real u_max "Upper bound of search interval";
              input Real tolerance=100*Modelica.Constants.eps
                "Relative tolerance of solution u";
              output Real u "Value of independent variable so that f(u) = 0";

            protected
              constant Real eps=Modelica.Constants.eps "machine epsilon";
              Real a=u_min "Current best minimum interval value";
              Real b=u_max "Current best maximum interval value";
              Real c "Intermediate point a <= c <= b";
              Real d;
              Real e "b - a";
              Real m;
              Real s;
              Real p;
              Real q;
              Real r;
              Real tol;
              Real fa "= f(a)";
              Real fb "= f(b)";
              Real fc;
              Boolean found=false;
            algorithm
              // Check that f(u_min) and f(u_max) have different sign
              fa := normalizationResidue(c1,c2,u_min);
              fb := normalizationResidue(c1,c2,u_max);
              fc := fb;
              if fa > 0.0 and fb > 0.0 or fa < 0.0 and fb < 0.0 then
                error(
                  "The arguments u_min and u_max to solveOneNonlinearEquation(..)\n" +
                  "do not bracket the root of the single non-linear equation:\n" +
                  "  u_min  = " + String(u_min) + "\n" + "  u_max  = " + String(u_max)
                   + "\n" + "  fa = f(u_min) = " + String(fa) + "\n" +
                  "  fb = f(u_max) = " + String(fb) + "\n" +
                  "fa and fb must have opposite sign which is not the case");
              end if;

              // Initialize variables
              c := a;
              fc := fa;
              e := b - a;
              d := e;

              // Search loop
              while not found loop
                if abs(fc) < abs(fb) then
                  a := b;
                  b := c;
                  c := a;
                  fa := fb;
                  fb := fc;
                  fc := fa;
                end if;

                tol := 2*eps*abs(b) + tolerance;
                m := (c - b)/2;

                if abs(m) <= tol or fb == 0.0 then
                  // root found (interval is small enough)
                  found := true;
                  u := b;
                else
                  // Determine if a bisection is needed
                  if abs(e) < tol or abs(fa) <= abs(fb) then
                    e := m;
                    d := e;
                  else
                    s := fb/fa;
                    if a == c then
                      // linear interpolation
                      p := 2*m*s;
                      q := 1 - s;
                    else
                      // inverse quadratic interpolation
                      q := fa/fc;
                      r := fb/fc;
                      p := s*(2*m*q*(q - r) - (b - a)*(r - 1));
                      q := (q - 1)*(r - 1)*(s - 1);
                    end if;

                    if p > 0 then
                      q := -q;
                    else
                      p := -p;
                    end if;

                    s := e;
                    e := d;
                    if 2*p < 3*m*q - abs(tol*q) and p < abs(0.5*s*q) then
                      // interpolation successful
                      d := p/q;
                    else
                      // use bi-section
                      e := m;
                      d := e;
                    end if;
                  end if;

                  // Best guess value is defined as "a"
                  a := b;
                  fa := fb;
                  b := b + (if abs(d) > tol then d else if m > 0 then tol else -tol);
                  fb := normalizationResidue(c1,c2,b);

                  if fb > 0 and fc > 0 or fb < 0 and fc < 0 then
                    // initialize variables
                    c := a;
                    fc := fa;
                    e := b - a;
                    d := e;
                  end if;
                end if;
              end while;

              annotation (Documentation(info="<html>

<p>
This function determines the solution of <b>one non-linear algebraic equation</b> \"y=f(u)\"
in <b>one unknown</b> \"u\" in a reliable way. It is one of the best numerical
algorithms for this purpose. As input, the nonlinear function f(u)
has to be given, as well as an interval u_min, u_max that
contains the solution, i.e., \"f(u_min)\" and \"f(u_max)\" must
have a different sign. If possible, a smaller interval is computed by
inverse quadratic interpolation (interpolating with a quadratic polynomial
through the last 3 points and computing the zero). If this fails,
bisection is used, which always reduces the interval by a factor of 2.
The inverse quadratic interpolation method has superlinear convergence.
This is roughly the same convergence rate as a globally convergent Newton
method, but without the need to compute derivatives of the non-linear
function. The solver function is a direct mapping of the Algol 60 procedure
\"zero\" to Modelica, from:
</p>

<dl>
<dt> Brent R.P.:</dt>
<dd> <b>Algorithms for Minimization without derivatives</b>.
     Prentice Hall, 1973, pp. 58-59.</dd>
</dl>

</html>"));
            end solveOneNonlinearEquation;

            algorithm
               // Find interval for alpha
               (alpha_min, alpha_max) :=findInterval(c1, c2);

               // Compute alpha, so that abs(G(p)) = -3db
               alpha :=solveOneNonlinearEquation(
                c1,
                c2,
                alpha_min,
                alpha_max);
            end normalizationFactor;

            encapsulated function bandPassAlpha "Return alpha for band pass"
              extends Modelica.Icons.Function;

              import Modelica;
               input Real a "Coefficient of s^1";
               input Real b "Coefficient of s^0";
               input Modelica.SIunits.AngularVelocity w
              "Bandwidth angular frequency";
               output Real alpha "Alpha factor to build up band pass";

          protected
              Real alpha_min;
              Real alpha_max;
              Real z_min;
              Real z_max;
              Real z;

              function residue "Residue of non-linear equation"
                extends Modelica.Icons.Function;
                input Real a;
                input Real b;
                input Real w;
                input Real z;
                output Real res;
              algorithm
                res := z^2 + (a*w*z/(1+z))^2 - (2+b*w^2)*z + 1;
              end residue;

            function solveOneNonlinearEquation
              "Solve f(u) = 0; f(u_min) and f(u_max) must have different signs"
                extends Modelica.Icons.Function;
                import Modelica.Utilities.Streams.error;

              input Real aa;
              input Real bb;
              input Real ww;
              input Real u_min "Lower bound of search interval";
              input Real u_max "Upper bound of search interval";
              input Real tolerance=100*Modelica.Constants.eps
                "Relative tolerance of solution u";
              output Real u "Value of independent variable so that f(u) = 0";

            protected
              constant Real eps=Modelica.Constants.eps "machine epsilon";
              Real a=u_min "Current best minimum interval value";
              Real b=u_max "Current best maximum interval value";
              Real c "Intermediate point a <= c <= b";
              Real d;
              Real e "b - a";
              Real m;
              Real s;
              Real p;
              Real q;
              Real r;
              Real tol;
              Real fa "= f(a)";
              Real fb "= f(b)";
              Real fc;
              Boolean found=false;
            algorithm
              // Check that f(u_min) and f(u_max) have different sign
              fa := residue(aa,bb,ww,u_min);
              fb := residue(aa,bb,ww,u_max);
              fc := fb;
              if fa > 0.0 and fb > 0.0 or fa < 0.0 and fb < 0.0 then
                error(
                  "The arguments u_min and u_max to solveOneNonlinearEquation(..)\n" +
                  "do not bracket the root of the single non-linear equation:\n" +
                  "  u_min  = " + String(u_min) + "\n" + "  u_max  = " + String(u_max)
                   + "\n" + "  fa = f(u_min) = " + String(fa) + "\n" +
                  "  fb = f(u_max) = " + String(fb) + "\n" +
                  "fa and fb must have opposite sign which is not the case");
              end if;

              // Initialize variables
              c := a;
              fc := fa;
              e := b - a;
              d := e;

              // Search loop
              while not found loop
                if abs(fc) < abs(fb) then
                  a := b;
                  b := c;
                  c := a;
                  fa := fb;
                  fb := fc;
                  fc := fa;
                end if;

                tol := 2*eps*abs(b) + tolerance;
                m := (c - b)/2;

                if abs(m) <= tol or fb == 0.0 then
                  // root found (interval is small enough)
                  found := true;
                  u := b;
                else
                  // Determine if a bisection is needed
                  if abs(e) < tol or abs(fa) <= abs(fb) then
                    e := m;
                    d := e;
                  else
                    s := fb/fa;
                    if a == c then
                      // linear interpolation
                      p := 2*m*s;
                      q := 1 - s;
                    else
                      // inverse quadratic interpolation
                      q := fa/fc;
                      r := fb/fc;
                      p := s*(2*m*q*(q - r) - (b - a)*(r - 1));
                      q := (q - 1)*(r - 1)*(s - 1);
                    end if;

                    if p > 0 then
                      q := -q;
                    else
                      p := -p;
                    end if;

                    s := e;
                    e := d;
                    if 2*p < 3*m*q - abs(tol*q) and p < abs(0.5*s*q) then
                      // interpolation successful
                      d := p/q;
                    else
                      // use bi-section
                      e := m;
                      d := e;
                    end if;
                  end if;

                  // Best guess value is defined as "a"
                  a := b;
                  fa := fb;
                  b := b + (if abs(d) > tol then d else if m > 0 then tol else -tol);
                  fb := residue(aa,bb,ww,b);

                  if fb > 0 and fc > 0 or fb < 0 and fc < 0 then
                    // initialize variables
                    c := a;
                    fc := fa;
                    e := b - a;
                    d := e;
                  end if;
                end if;
              end while;

              annotation (Documentation(info="<html>

<p>
This function determines the solution of <b>one non-linear algebraic equation</b> \"y=f(u)\"
in <b>one unknown</b> \"u\" in a reliable way. It is one of the best numerical
algorithms for this purpose. As input, the nonlinear function f(u)
has to be given, as well as an interval u_min, u_max that
contains the solution, i.e., \"f(u_min)\" and \"f(u_max)\" must
have a different sign. If possible, a smaller interval is computed by
inverse quadratic interpolation (interpolating with a quadratic polynomial
through the last 3 points and computing the zero). If this fails,
bisection is used, which always reduces the interval by a factor of 2.
The inverse quadratic interpolation method has superlinear convergence.
This is roughly the same convergence rate as a globally convergent Newton
method, but without the need to compute derivatives of the non-linear
function. The solver function is a direct mapping of the Algol 60 procedure
\"zero\" to Modelica, from:
</p>

<dl>
<dt> Brent R.P.:</dt>
<dd> <b>Algorithms for Minimization without derivatives</b>.
     Prentice Hall, 1973, pp. 58-59.</dd>
</dl>

</html>"));
            end solveOneNonlinearEquation;

            algorithm
              assert( a^2/4 - b <= 0,  "Band pass transformation cannot be computed");
              z :=solveOneNonlinearEquation(a, b, w, 0, 1);
              alpha := sqrt(z);

              annotation (Documentation(info="<html>
<p>
A band pass with bandwidth \"w\" is determined from a low pass
</p>

<pre>
  1/(p^2 + a*p + b)
</pre>

<p>
with the transformation
</p>

<pre>
  new(p) = (p + 1/p)/w
</pre>

<p>
This results in the following derivation:
</p>

<pre>
  1/(p^2 + a*p + b) -> 1/( (p+1/p)^2/w^2 + a*(p + 1/p)/w + b )
                     = 1 /( ( p^2 + 1/p^2 + 2)/w^2 + (p + 1/p)*a/w + b )
                     = w^2*p^2 / (p^4 + 2*p^2 + 1 + (p^3 + p)a*w + b*w^2*p^2)
                     = w^2*p^2 / (p^4 + a*w*p^3 + (2+b*w^2)*p^2 + a*w*p + 1)
</pre>

<p>
This 4th order transfer function shall be split in to two transfer functions of order 2 each
for numerical reasons. With the following formulation, the fourth order
polynomial can be represented (with the unknowns \"c\" and \"alpha\"):
</p>

<pre>
  g(p) = w^2*p^2 / ( (p*alpha)^2 + c*(p*alpha) + 1) * ( (p/alpha)^2 + c*(p/alpha) + 1)
       = w^2*p^2 / ( p^4 + c*(alpha + 1/alpha)*p^3 + (alpha^2 + 1/alpha^2 + c^2)*p^2
                                                   + c*(alpha + 1/alpha)*p + 1 )
</pre>

<p>
Comparison of coefficients:
</p>

<pre>
  c*(alpha + 1/alpha) = a*w           -> c = a*w / (alpha + 1/alpha)
  alpha^2 + 1/alpha^2 + c^2 = 2+b*w^2 -> equation to determine alpha

  alpha^4 + 1 + a^2*w^2*alpha^4/(1+alpha^2)^2 = (2+b*w^2)*alpha^2
    or z = alpha^2
  z^2 + a^2*w^2*z^2/(1+z)^2 - (2+b*w^2)*z + 1 = 0
</pre>

<p>
Therefore the last equation has to be solved for \"z\" (basically, this means to compute
a real zero of a fourth order polynomial):
</p>

<pre>
   solve: 0 = f(z)  = z^2 + a^2*w^2*z^2/(1+z)^2 - (2+b*w^2)*z + 1  for \"z\"
              f(0)  = 1  &gt; 0
              f(1)  = 1 + a^2*w^2/4 - (2+b*w^2) + 1
                    = (a^2/4 - b)*w^2  &lt; 0
                    // since b - a^2/4 > 0 requirement for complex conjugate poles
   -> 0 &lt; z &lt; 1
</pre>

<p>
This function computes the solution of this equation and returns \"alpha = sqrt(z)\";
</p>

</html>"));
            end bandPassAlpha;
          end Utilities;
        end Filter;
      end Internal;
      annotation (
        Documentation(info="<html>
<p>
This package contains basic <b>continuous</b> input/output blocks
described by differential equations.
</p>

<p>
All blocks of this package can be initialized in different
ways controlled by parameter <b>initType</b>. The possible
values of initType are defined in
<a href=\"modelica://Modelica.Blocks.Types.Init\">Modelica.Blocks.Types.Init</a>:
</p>

<table border=1 cellspacing=0 cellpadding=2>
  <tr><td valign=\"top\"><b>Name</b></td>
      <td valign=\"top\"><b>Description</b></td></tr>

  <tr><td valign=\"top\"><b>Init.NoInit</b></td>
      <td valign=\"top\">no initialization (start values are used as guess values with fixed=false)</td></tr>

  <tr><td valign=\"top\"><b>Init.SteadyState</b></td>
      <td valign=\"top\">steady state initialization (derivatives of states are zero)</td></tr>

  <tr><td valign=\"top\"><b>Init.InitialState</b></td>
      <td valign=\"top\">Initialization with initial states</td></tr>

  <tr><td valign=\"top\"><b>Init.InitialOutput</b></td>
      <td valign=\"top\">Initialization with initial outputs (and steady state of the states if possible)</td></tr>
</table>

<p>
For backward compatibility reasons the default of all blocks is
<b>Init.NoInit</b>, with the exception of Integrator and LimIntegrator
where the default is <b>Init.InitialState</b> (this was the initialization
defined in version 2.2 of the Modelica standard library).
</p>

<p>
In many cases, the most useful initial condition is
<b>Init.SteadyState</b> because initial transients are then no longer
present. The drawback is that in combination with a non-linear
plant, non-linear algebraic equations occur that might be
difficult to solve if appropriate guess values for the
iteration variables are not provided (i.e., start values with fixed=false).
However, it is often already useful to just initialize
the linear blocks from the Continuous blocks library in SteadyState.
This is uncritical, because only linear algebraic equations occur.
If Init.NoInit is set, then the start values for the states are
interpreted as <b>guess</b> values and are propagated to the
states with fixed=<b>false</b>.
</p>

<p>
Note, initialization with Init.SteadyState is usually difficult
for a block that contains an integrator
(Integrator, LimIntegrator, PI, PID, LimPID).
This is due to the basic equation of an integrator:
</p>

<pre>
  <b>initial equation</b>
     <b>der</b>(y) = 0;   // Init.SteadyState
  <b>equation</b>
     <b>der</b>(y) = k*u;
</pre>

<p>
The steady state equation leads to the condition that the input to the
integrator is zero. If the input u is already (directly or indirectly) defined
by another initial condition, then the initialization problem is <b>singular</b>
(has none or infinitely many solutions). This situation occurs often
for mechanical systems, where, e.g., u = desiredSpeed - measuredSpeed and
since speed is both a state and a derivative, it is always defined by
Init.InitialState or Init.SteadyState initialization.
</p>

<p>
In such a case, <b>Init.NoInit</b> has to be selected for the integrator
and an additional initial equation has to be added to the system
to which the integrator is connected. E.g., useful initial conditions
for a 1-dim. rotational inertia controlled by a PI controller are that
<b>angle</b>, <b>speed</b>, and <b>acceleration</b> of the inertia are zero.
</p>

</html>"),     Icon(graphics={Line(
              origin={0.061,4.184},
              points={{81.939,36.056},{65.362,36.056},{14.39,-26.199},{-29.966,
                  113.485},{-65.374,-61.217},{-78.061,-78.184}},
              color={95,95,95},
              smooth=Smooth.Bezier)}));
    end Continuous;

    package Interfaces
    "Library of connectors and partial models for input/output blocks"
      import Modelica.SIunits;
      extends Modelica.Icons.InterfacesPackage;

      connector RealInput = input Real "'input Real' as connector" annotation (
        defaultComponentName="u",
        Icon(graphics={
          Polygon(
            lineColor={0,0,127},
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid,
            points={{-100.0,100.0},{100.0,0.0},{-100.0,-100.0}})},
          coordinateSystem(extent={{-100.0,-100.0},{100.0,100.0}},
            preserveAspectRatio=true,
            initialScale=0.2)),
        Diagram(
          coordinateSystem(preserveAspectRatio=true,
            initialScale=0.2,
            extent={{-100.0,-100.0},{100.0,100.0}}),
            graphics={
          Polygon(
            lineColor={0,0,127},
            fillColor={0,0,127},
            fillPattern=FillPattern.Solid,
            points={{0.0,50.0},{100.0,0.0},{0.0,-50.0},{0.0,50.0}}),
          Text(
            lineColor={0,0,127},
            extent={{-10.0,60.0},{-10.0,85.0}},
            textString="%name")}),
        Documentation(info="<html>
<p>
Connector with one input signal of type Real.
</p>
</html>"));

      connector RealOutput = output Real "'output Real' as connector" annotation (
        defaultComponentName="y",
        Icon(
          coordinateSystem(preserveAspectRatio=true,
            extent={{-100.0,-100.0},{100.0,100.0}},
            initialScale=0.1),
            graphics={
          Polygon(
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            points={{-100.0,100.0},{100.0,0.0},{-100.0,-100.0}})}),
        Diagram(
          coordinateSystem(preserveAspectRatio=true,
            extent={{-100.0,-100.0},{100.0,100.0}},
            initialScale=0.1),
            graphics={
          Polygon(
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            points={{-100.0,50.0},{0.0,0.0},{-100.0,-50.0}}),
          Text(
            lineColor={0,0,127},
            extent={{30.0,60.0},{30.0,110.0}},
            textString="%name")}),
        Documentation(info="<html>
<p>
Connector with one output signal of type Real.
</p>
</html>"));

      partial block SO "Single Output continuous control block"
        extends Modelica.Blocks.Icons.Block;

        RealOutput y "Connector of Real output signal" annotation (Placement(
              transformation(extent={{100,-10},{120,10}}, rotation=0)));
        annotation (Documentation(info="<html>
<p>
Block has one continuous Real output signal.
</p>
</html>"));

      end SO;

      partial block SISO "Single Input Single Output continuous control block"
        extends Modelica.Blocks.Icons.Block;

        RealInput u "Connector of Real input signal" annotation (Placement(
              transformation(extent={{-140,-20},{-100,20}}, rotation=0)));
        RealOutput y "Connector of Real output signal" annotation (Placement(
              transformation(extent={{100,-10},{120,10}}, rotation=0)));
        annotation (Documentation(info="<html>
<p>
Block has one continuous Real input and one continuous Real output signal.
</p>
</html>"));
      end SISO;

      partial block SI2SO
      "2 Single Input / 1 Single Output continuous control block"
        extends Modelica.Blocks.Icons.Block;

        RealInput u1 "Connector of Real input signal 1" annotation (Placement(
              transformation(extent={{-140,40},{-100,80}}, rotation=0)));
        RealInput u2 "Connector of Real input signal 2" annotation (Placement(
              transformation(extent={{-140,-80},{-100,-40}}, rotation=0)));
        RealOutput y "Connector of Real output signal" annotation (Placement(
              transformation(extent={{100,-10},{120,10}}, rotation=0)));

        annotation (Documentation(info="<html>
<p>
Block has two continuous Real input signals u1 and u2 and one
continuous Real output signal y.
</p>
</html>"));

      end SI2SO;

      partial block partialBooleanBlockIcon
      "This icon will be removed in future Modelica versions, use Modelica.Blocks.Icons.PartialBooleanBlock instead."
        // extends Modelica.Icons.ObsoleteModel;

        annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
                  {100,100}}), graphics={Rectangle(
                extent={{-100,100},{100,-100}},
                lineColor={0,0,0},
                lineThickness=5.0,
                fillColor={210,210,210},
                fillPattern=FillPattern.Solid,
                borderPattern=BorderPattern.Raised), Text(
                extent={{-150,150},{150,110}},
                textString="%name",
                lineColor={0,0,255})}), Documentation(info="<html>
<p>
This icon will be removed in future versions of the Modelica Standard Library.
Instead the icon <a href=\"modelica://Modelica.Blocks.Icons.PartialBooleanBlock\">Modelica.Blocks.Icons.PartialBooleanBlock</a> shall be used.
</p>
</html>"));
      end partialBooleanBlockIcon;
      annotation (Documentation(info="<HTML>
<p>
This package contains interface definitions for
<b>continuous</b> input/output blocks with Real,
Integer and Boolean signals. Furthermore, it contains
partial models for continuous and discrete blocks.
</p>

</html>",     revisions="<html>
<ul>
<li><i>Oct. 21, 2002</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>
       and <a href=\"http://www.robotic.dlr.de/Christian.Schweiger/\">Christian Schweiger</a>:<br>
       Added several new interfaces.
<li><i>Oct. 24, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       RealInputSignal renamed to RealInput. RealOutputSignal renamed to
       output RealOutput. GraphBlock renamed to BlockIcon. SISOreal renamed to
       SISO. SOreal renamed to SO. I2SOreal renamed to M2SO.
       SignalGenerator renamed to SignalSource. Introduced the following
       new models: MIMO, MIMOs, SVcontrol, MVcontrol, DiscreteBlockIcon,
       DiscreteBlock, DiscreteSISO, DiscreteMIMO, DiscreteMIMOs,
       BooleanBlockIcon, BooleanSISO, BooleanSignalSource, MI2BooleanMOs.</li>
<li><i>June 30, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Realized a first version, based on an existing Dymola library
       of Dieter Moormann and Hilding Elmqvist.</li>
</ul>
</html>"));
    end Interfaces;

    package Sources
    "Library of signal source blocks generating Real and Boolean signals"
      import Modelica.Blocks.Interfaces;
      import Modelica.SIunits;
      extends Modelica.Icons.SourcesPackage;

      block RealExpression
      "Set output signal to a time varying Real expression"

        Modelica.Blocks.Interfaces.RealOutput y=0.0 "Value of Real output"
          annotation (Dialog(group="Time varying output signal"), Placement(
              transformation(extent={{100,-10},{120,10}}, rotation=0)));

        annotation (Icon(coordinateSystem(
              preserveAspectRatio=false,
              extent={{-100,-100},{100,100}}), graphics={
              Rectangle(
                extent={{-100,40},{100,-40}},
                lineColor={0,0,0},
                lineThickness=5.0,
                fillColor={235,235,235},
                fillPattern=FillPattern.Solid,
                borderPattern=BorderPattern.Raised),
              Text(
                extent={{-96,15},{96,-15}},
                lineColor={0,0,0},
                textString="%y"),
              Text(
                extent={{-150,90},{140,50}},
                textString="%name",
                lineColor={0,0,255})}), Documentation(info="<html>
<p>
The (time varying) Real output signal of this block can be defined in its
parameter menu via variable <b>y</b>. The purpose is to support the
easy definition of Real expressions in a block diagram. For example,
in the y-menu the definition \"if time &lt; 1 then 0 else 1\" can be given in order
to define that the output signal is one, if time &ge; 1 and otherwise
it is zero. Note, that \"time\" is a built-in variable that is always
accessible and represents the \"model time\" and that
Variable <b>y</b> is both a variable and a connector.
</p>
</html>"));

      end RealExpression;

      block Constant "Generate constant signal of type Real"
        parameter Real k(start=1) "Constant output value";
        extends Interfaces.SO;

      equation
        y = k;
        annotation (
          defaultComponentName="const",
          Icon(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}}), graphics={
              Line(points={{-80,68},{-80,-80}}, color={192,192,192}),
              Polygon(
                points={{-80,90},{-88,68},{-72,68},{-80,90}},
                lineColor={192,192,192},
                fillColor={192,192,192},
                fillPattern=FillPattern.Solid),
              Line(points={{-90,-70},{82,-70}}, color={192,192,192}),
              Polygon(
                points={{90,-70},{68,-62},{68,-78},{90,-70}},
                lineColor={192,192,192},
                fillColor={192,192,192},
                fillPattern=FillPattern.Solid),
              Line(points={{-80,0},{80,0}}, color={0,0,0}),
              Text(
                extent={{-150,-150},{150,-110}},
                lineColor={0,0,0},
                textString="k=%k")}),
          Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}}), graphics={
              Polygon(
                points={{-80,90},{-86,68},{-74,68},{-80,90}},
                lineColor={95,95,95},
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid),
              Line(points={{-80,68},{-80,-80}}, color={95,95,95}),
              Line(
                points={{-80,0},{80,0}},
                color={0,0,255},
                thickness=0.5),
              Line(points={{-90,-70},{82,-70}}, color={95,95,95}),
              Polygon(
                points={{90,-70},{68,-64},{68,-76},{90,-70}},
                lineColor={95,95,95},
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid),
              Text(
                extent={{-83,92},{-30,74}},
                lineColor={0,0,0},
                textString="y"),
              Text(
                extent={{70,-80},{94,-100}},
                lineColor={0,0,0},
                textString="time"),
              Text(
                extent={{-101,8},{-81,-12}},
                lineColor={0,0,0},
                textString="k")}),
          Documentation(info="<html>
<p>
The Real output y is a constant signal:
</p>

<p>
<img src=\"modelica://Modelica/Resources/Images/Blocks/Sources/Constant.png\"
     alt=\"Constant.png\">
</p>
</html>"));
      end Constant;

      block Sine "Generate sine signal"
        parameter Real amplitude=1 "Amplitude of sine wave";
        parameter SIunits.Frequency freqHz(start=1) "Frequency of sine wave";
        parameter SIunits.Angle phase=0 "Phase of sine wave";
        parameter Real offset=0 "Offset of output signal";
        parameter SIunits.Time startTime=0
        "Output = offset for time < startTime";
        extends Interfaces.SO;
    protected
        constant Real pi=Modelica.Constants.pi;

      equation
        y = offset + (if time < startTime then 0 else amplitude*Modelica.Math.sin(2
          *pi*freqHz*(time - startTime) + phase));
        annotation (
          Icon(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}}), graphics={
              Line(points={{-80,68},{-80,-80}}, color={192,192,192}),
              Polygon(
                points={{-80,90},{-88,68},{-72,68},{-80,90}},
                lineColor={192,192,192},
                fillColor={192,192,192},
                fillPattern=FillPattern.Solid),
              Line(points={{-90,0},{68,0}}, color={192,192,192}),
              Polygon(
                points={{90,0},{68,8},{68,-8},{90,0}},
                lineColor={192,192,192},
                fillColor={192,192,192},
                fillPattern=FillPattern.Solid),
              Line(points={{-80,0},{-68.7,34.2},{-61.5,53.1},{-55.1,66.4},{-49.4,
                    74.6},{-43.8,79.1},{-38.2,79.8},{-32.6,76.6},{-26.9,69.7},{-21.3,
                    59.4},{-14.9,44.1},{-6.83,21.2},{10.1,-30.8},{17.3,-50.2},{23.7,
                    -64.2},{29.3,-73.1},{35,-78.4},{40.6,-80},{46.2,-77.6},{51.9,-71.5},
                    {57.5,-61.9},{63.9,-47.2},{72,-24.8},{80,0}}, color={0,0,0}, smooth = Smooth.Bezier),
              Text(
                extent={{-147,-152},{153,-112}},
                lineColor={0,0,0},
                textString="freqHz=%freqHz")}),
          Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}}), graphics={
              Line(points={{-80,-90},{-80,84}}, color={95,95,95}),
              Polygon(
                points={{-80,97},{-84,81},{-76,81},{-80,97}},
                lineColor={95,95,95},
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid),
              Line(points={{-99,-40},{85,-40}}, color={95,95,95}),
              Polygon(
                points={{97,-40},{81,-36},{81,-45},{97,-40}},
                lineColor={95,95,95},
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid),
              Line(
                points={{-41,-2},{-31.6,34.2},{-26.1,53.1},{-21.3,66.4},{-17.1,74.6},
                    {-12.9,79.1},{-8.64,79.8},{-4.42,76.6},{-0.201,69.7},{4.02,59.4},
                    {8.84,44.1},{14.9,21.2},{27.5,-30.8},{33,-50.2},{37.8,-64.2},{
                    42,-73.1},{46.2,-78.4},{50.5,-80},{54.7,-77.6},{58.9,-71.5},{
                    63.1,-61.9},{67.9,-47.2},{74,-24.8},{80,0}},
                color={0,0,255},
                thickness=0.5,
                smooth=Smooth.Bezier),
              Line(
                points={{-41,-2},{-80,-2}},
                color={0,0,255},
                thickness=0.5),
              Text(
                extent={{-87,12},{-40,0}},
                lineColor={0,0,0},
                textString="offset"),
              Line(points={{-41,-2},{-41,-40}}, color={95,95,95}),
              Text(
                extent={{-60,-43},{-14,-54}},
                lineColor={0,0,0},
                textString="startTime"),
              Text(
                extent={{75,-47},{100,-60}},
                lineColor={0,0,0},
                textString="time"),
              Text(
                extent={{-80,99},{-40,82}},
                lineColor={0,0,0},
                textString="y"),
              Line(points={{-9,80},{43,80}}, color={95,95,95}),
              Line(points={{-41,-2},{50,-2}}, color={95,95,95}),
              Polygon(
                points={{33,80},{30,67},{36,67},{33,80}},
                lineColor={95,95,95},
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid),
              Text(
                extent={{37,57},{83,39}},
                lineColor={0,0,0},
                textString="amplitude"),
              Polygon(
                points={{33,-2},{30,11},{36,11},{33,-2},{33,-2}},
                lineColor={95,95,95},
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid),
              Line(points={{33,80},{33,-2}}, color={95,95,95})}),
          Documentation(info="<html>
<p>
The Real output y is a sine signal:
</p>

<p>
<img src=\"modelica://Modelica/Resources/Images/Blocks/Sources/Sine.png\"
     alt=\"Sine.png\">
</p>
</html>"));
      end Sine;

      block SawTooth "Generate saw tooth signal"
        parameter Real amplitude=1 "Amplitude of saw tooth";
        parameter SIunits.Time period(final min=Modelica.Constants.small,start=1)
        "Time for one period";
        parameter Integer nperiod=-1
        "Number of periods (< 0 means infinite number of periods)";
        parameter Real offset=0 "Offset of output signals";
        parameter SIunits.Time startTime=0
        "Output = offset for time < startTime";
        extends Interfaces.SO;
    protected
        SIunits.Time T_start(final start=startTime)
        "Start time of current period";
        Integer count "Period count";
      initial algorithm
        count := integer((time - startTime)/period);
        T_start := startTime + count*period;
      equation
        when integer((time - startTime)/period) > pre(count) then
          count = pre(count) + 1;
          T_start = time;
        end when;
        y = offset + (if (time < startTime or nperiod == 0 or (nperiod > 0 and
          count >= nperiod)) then 0 else amplitude*(time - T_start)/period);
        annotation (
          Icon(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}}), graphics={
              Line(points={{-80,68},{-80,-80}}, color={192,192,192}),
              Polygon(
                points={{-80,90},{-88,68},{-72,68},{-80,90}},
                lineColor={192,192,192},
                fillColor={192,192,192},
                fillPattern=FillPattern.Solid),
              Line(points={{-90,-70},{82,-70}}, color={192,192,192}),
              Polygon(
                points={{90,-70},{68,-62},{68,-78},{90,-70}},
                lineColor={192,192,192},
                fillColor={192,192,192},
                fillPattern=FillPattern.Solid),
              Line(points={{-80,-70},{-60,-70},{0,40},{0,-70},{60,41},{60,-70}},
                  color={0,0,0}),
              Text(
                extent={{-147,-152},{153,-112}},
                lineColor={0,0,0},
                textString="period=%period")}),
          Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}}), graphics={
              Polygon(
                points={{-80,90},{-86,68},{-74,68},{-80,90}},
                lineColor={95,95,95},
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid),
              Line(points={{-80,68},{-80,-80}}, color={95,95,95}),
              Line(points={{-90,-70},{82,-70}}, color={95,95,95}),
              Polygon(
                points={{90,-70},{68,-65},{68,-75},{90,-70}},
                lineColor={95,95,95},
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid),
              Polygon(
                points={{-34,-20},{-37,-33},{-31,-33},{-34,-20}},
                lineColor={95,95,95},
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid),
              Line(points={{-34,-20},{-34,-70}}, color={95,95,95}),
              Polygon(
                points={{-34,-70},{-37,-57},{-31,-57},{-34,-70},{-34,-70}},
                lineColor={95,95,95},
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid),
              Text(
                extent={{-65,-39},{-29,-47}},
                lineColor={0,0,0},
                textString="offset"),
              Text(
                extent={{-29,-72},{13,-80}},
                lineColor={0,0,0},
                textString="startTime"),
              Text(
                extent={{-82,92},{-43,76}},
                lineColor={0,0,0},
                textString="y"),
              Text(
                extent={{67,-78},{88,-87}},
                lineColor={0,0,0},
                textString="time"),
              Line(points={{-10,-20},{-10,-70}}, color={95,95,95}),
              Line(points={{-10,88},{-10,-20}}, color={95,95,95}),
              Line(points={{30,88},{30,59}}, color={95,95,95}),
              Line(points={{-10,83},{30,83}}, color={95,95,95}),
              Text(
                extent={{-12,94},{34,85}},
                lineColor={0,0,0},
                textString="period"),
              Line(points={{-44,60},{30,60}}, color={95,95,95}),
              Line(points={{-34,47},{-34,-20}},color={95,95,95}),
              Text(
                extent={{-73,25},{-36,16}},
                lineColor={0,0,0},
                textString="amplitude"),
              Polygon(
                points={{-34,60},{-37,47},{-31,47},{-34,60}},
                lineColor={95,95,95},
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid),
              Polygon(
                points={{-34,-20},{-37,-7},{-31,-7},{-34,-20},{-34,-20}},
                lineColor={95,95,95},
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid),
              Polygon(
                points={{-10,83},{-1,85},{-1,81},{-10,83}},
                lineColor={95,95,95},
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid),
              Polygon(
                points={{30,83},{22,85},{22,81},{30,83}},
                lineColor={95,95,95},
                fillColor={95,95,95},
                fillPattern=FillPattern.Solid),
              Line(
                points={{-80,-20},{-10,-20},{30,60},{30,-20},{72,60},{72,-20}},
                color={0,0,255},
                thickness=0.5)}),
          Documentation(info="<html>
<p>
The Real output y is a saw tooth signal:
</p>

<p>
<img src=\"modelica://Modelica/Resources/Images/Blocks/Sources/SawTooth.png\"
     alt=\"SawTooth.png\">
</p>
</html>"));
      end SawTooth;
      annotation (Documentation(info="<HTML>
<p>
This package contains <b>source</b> components, i.e., blocks which
have only output signals. These blocks are used as signal generators
for Real, Integer and Boolean signals.
</p>

<p>
All Real source signals (with the exception of the Constant source)
have at least the following two parameters:
</p>

<table border=1 cellspacing=0 cellpadding=2>
  <tr><td valign=\"top\"><b>offset</b></td>
      <td valign=\"top\">Value which is added to the signal</td>
  </tr>
  <tr><td valign=\"top\"><b>startTime</b></td>
      <td valign=\"top\">Start time of signal. For time &lt; startTime,
                the output y is set to offset.</td>
  </tr>
</table>

<p>
The <b>offset</b> parameter is especially useful in order to shift
the corresponding source, such that at initial time the system
is stationary. To determine the corresponding value of offset,
usually requires a trimming calculation.
</p>
</html>",     revisions="<html>
<ul>
<li><i>October 21, 2002</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>
       and <a href=\"http://www.robotic.dlr.de/Christian.Schweiger/\">Christian Schweiger</a>:<br>
       Integer sources added. Step, TimeTable and BooleanStep slightly changed.</li>
<li><i>Nov. 8, 1999</i>
       by <a href=\"mailto:clauss@eas.iis.fhg.de\">Christoph Clau&szlig;</a>,
       <a href=\"mailto:Andre.Schneider@eas.iis.fraunhofer.de\">Andre.Schneider@eas.iis.fraunhofer.de</a>,
       <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       New sources: Exponentials, TimeTable. Trapezoid slightly enhanced
       (nperiod=-1 is an infinite number of periods).</li>
<li><i>Oct. 31, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       <a href=\"mailto:clauss@eas.iis.fhg.de\">Christoph Clau&szlig;</a>,
       <a href=\"mailto:Andre.Schneider@eas.iis.fraunhofer.de\">Andre.Schneider@eas.iis.fraunhofer.de</a>,
       All sources vectorized. New sources: ExpSine, Trapezoid,
       BooleanConstant, BooleanStep, BooleanPulse, SampleTrigger.
       Improved documentation, especially detailed description of
       signals in diagram layer.</li>
<li><i>June 29, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Realized a first version, based on an existing Dymola library
       of Dieter Moormann and Hilding Elmqvist.</li>
</ul>
</html>"));
    end Sources;

    package Tables
    "Library of blocks to interpolate in one and two-dimensional tables"
      extends Modelica.Icons.Package;

      block CombiTable2D "Table look-up in two dimensions (matrix/file)"
        extends Modelica.Blocks.Interfaces.SI2SO;
        parameter Boolean tableOnFile=false
        "= true, if table is defined on file or in function usertab"
          annotation (Dialog(group="Table data definition"));
        parameter Real table[:, :] = fill(0.0, 0, 2)
        "Table matrix (grid u1 = first column, grid u2 = first row; e.g., table=[0,0;0,1])"
          annotation (Dialog(group="Table data definition",enable=not tableOnFile));
        parameter String tableName="NoName"
        "Table name on file or in function usertab (see docu)"
          annotation (Dialog(group="Table data definition",enable=tableOnFile));
        parameter String fileName="NoName" "File where matrix is stored"
          annotation (Dialog(
            group="Table data definition",
            enable=tableOnFile,
            loadSelector(filter="Text files (*.txt);;MATLAB MAT-files (*.mat)",
                caption="Open file in which table is present")));
        parameter Boolean verboseRead=true
        "= true, if info message that file is loading is to be printed"
          annotation (Dialog(group="Table data definition",enable=tableOnFile));
        parameter Modelica.Blocks.Types.Smoothness smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments
        "Smoothness of table interpolation"
          annotation (Dialog(group="Table data interpretation"));
    protected
        Modelica.Blocks.Types.ExternalCombiTable2D tableID=
            Modelica.Blocks.Types.ExternalCombiTable2D(
              if tableOnFile then tableName else "NoName",
              if tableOnFile and fileName <> "NoName" and not Modelica.Utilities.Strings.isEmpty(fileName) then fileName else "NoName",
              table,
              smoothness) "External table object";
        parameter Real tableOnFileRead(fixed=false)
        "= 1, if table was successfully read from file";

        function readTableData
        "Read table data from ASCII text or MATLAB MAT-file"
          extends Modelica.Icons.Function;
          input Modelica.Blocks.Types.ExternalCombiTable2D tableID;
          input Boolean forceRead = false
          "= true: Force reading of table data; = false: Only read, if not yet read.";
          input Boolean verboseRead
          "= true: Print info message; = false: No info message";
          output Real readSuccess "Table read success";
          external"C" readSuccess = ModelicaStandardTables_CombiTable2D_read(tableID, forceRead, verboseRead)
            annotation (Library={"ModelicaStandardTables"});
        end readTableData;

        function getTableValue "Interpolate 2-dim. table defined by matrix"
          extends Modelica.Icons.Function;
          input Modelica.Blocks.Types.ExternalCombiTable2D tableID;
          input Real u1;
          input Real u2;
          input Real tableAvailable
          "Dummy input to ensure correct sorting of function calls";
          output Real y;
          external"C" y = ModelicaStandardTables_CombiTable2D_getValue(tableID, u1, u2)
            annotation (Library={"ModelicaStandardTables"});
          annotation (derivative(noDerivative=tableAvailable) = getDerTableValue);
        end getTableValue;

        function getTableValueNoDer
        "Interpolate 2-dim. table defined by matrix (but do not provide a derivative function)"
          extends Modelica.Icons.Function;
          input Modelica.Blocks.Types.ExternalCombiTable2D tableID;
          input Real u1;
          input Real u2;
          input Real tableAvailable
          "Dummy input to ensure correct sorting of function calls";
          output Real y;
          external"C" y = ModelicaStandardTables_CombiTable2D_getValue(tableID, u1, u2)
            annotation (Library={"ModelicaStandardTables"});
        end getTableValueNoDer;

        function getDerTableValue
        "Derivative of interpolated 2-dim. table defined by matrix"
          extends Modelica.Icons.Function;
          input Modelica.Blocks.Types.ExternalCombiTable2D tableID;
          input Real u1;
          input Real u2;
          input Real tableAvailable
          "Dummy input to ensure correct sorting of function calls";
          input Real der_u1;
          input Real der_u2;
          output Real der_y;
          external"C" der_y = ModelicaStandardTables_CombiTable2D_getDerValue(tableID, u1, u2, der_u1, der_u2)
            annotation (Library={"ModelicaStandardTables"});
        end getDerTableValue;

      initial algorithm
        if tableOnFile then
          tableOnFileRead := readTableData(tableID, false, verboseRead);
        else
          tableOnFileRead := 1.;
        end if;
      equation
        if tableOnFile then
          assert(tableName <> "NoName",
            "tableOnFile = true and no table name given");
        else
          assert(size(table, 1) > 0 and size(table, 2) > 0,
            "tableOnFile = false and parameter table is an empty matrix");
        end if;
        if smoothness == Modelica.Blocks.Types.Smoothness.ConstantSegments then
          y = getTableValueNoDer(tableID, u1, u2, tableOnFileRead);
        else
          y = getTableValue(tableID, u1, u2, tableOnFileRead);
        end if;
        annotation (
          Documentation(info="<html>
<p>
<b>Linear interpolation</b> in <b>two</b> dimensions of a <b>table</b>.
The grid points and function values are stored in a matrix \"table[i,j]\",
where:
</p>
<ul>
<li> the first column \"table[2:,1]\" contains the u[1] grid points,</li>
<li> the first row \"table[1,2:]\" contains the u[2] grid points,</li>
<li> the other rows and columns contain the data to be interpolated.</li>
</ul>
<p>
Example:
</p>
<pre>
           |       |       |       |
           |  1.0  |  2.0  |  3.0  |  // u2
       ----*-------*-------*-------*
       1.0 |  1.0  |  3.0  |  5.0  |
       ----*-------*-------*-------*
       2.0 |  2.0  |  4.0  |  6.0  |
       ----*-------*-------*-------*
     // u1
   is defined as
      table = [0.0,   1.0,   2.0,   3.0;
               1.0,   1.0,   3.0,   5.0;
               2.0,   2.0,   4.0,   6.0]
   If, e.g., the input u is [1.0;1.0], the output y is 1.0,
       e.g., the input u is [2.0;1.5], the output y is 3.0.
</pre>
<ul>
<li> The interpolation is <b>efficient</b>, because a search for a new
     interpolation starts at the interval used in the last call.</li>
<li> If the table has only <b>one element</b>, the table value is returned,
     independent of the value of the input signal.</li>
<li> If the input signal <b>u1</b> or <b>u2</b> is <b>outside</b> of the defined
     <b>interval</b>, the corresponding value is also determined by linear
     interpolation through the last or first two points of the table.</li>
<li> The grid values (first column and first row) have to be strictly
     increasing.</li>
</ul>
<p>
The table matrix can be defined in the following ways:
</p>
<ol>
<li> Explicitly supplied as <b>parameter matrix</b> \"table\",
     and the other parameters have the following values:
<pre>
   tableName is \"NoName\" or has only blanks,
   fileName  is \"NoName\" or has only blanks.
</pre></li>
<li> <b>Read</b> from a <b>file</b> \"fileName\" where the matrix is stored as
      \"tableName\". Both ASCII and MAT-file format is possible.
      (The ASCII format is described below).
      The MAT-file format comes in four different versions: v4, v6, v7 and v7.3.
      The library supports at least v4, v6 and v7 whereas v7.3 is optional.
      It is most convenient to generate the MAT-file from FreeMat or MATLAB&reg;
      by command
<pre>
   save tables.mat tab1 tab2 tab3
</pre>
      or Scilab by command
<pre>
   savematfile tables.mat tab1 tab2 tab3
</pre>
      when the three tables tab1, tab2, tab3 should be used from the model.<br>
      Note, a fileName can be defined as URI by using the helper function
      <a href=\"modelica://Modelica.Utilities.Files.loadResource\">loadResource</a>.</li>
<li>  Statically stored in function \"usertab\" in file \"usertab.c\".
      The matrix is identified by \"tableName\". Parameter
      fileName = \"NoName\" or has only blanks. Row-wise storage is always to be
      preferred as otherwise the table is reallocated and transposed.
      See the <a href=\"modelica://Modelica.Blocks.Tables\">Tables</a> package
      documentation for more details.</li>
</ol>
<p>
When the constant \"NO_FILE_SYSTEM\" is defined, all file I/O related parts of the
source code are removed by the C-preprocessor, such that no access to files takes place.
</p>
<p>
If tables are read from an ASCII-file, the file needs to have the
following structure (\"-----\" is not part of the file content):
</p>
<pre>
-----------------------------------------------------
#1
double table2D_1(3,4)   # comment line
0.0  1.0  2.0  3.0  # u[2] grid points
1.0  1.0  3.0  5.0
2.0  2.0  4.0  6.0

double table2D_2(4,4)   # comment line
0.0  1.0  2.0  3.0  # u[2] grid points
1.0  1.0  3.0  5.0
2.0  2.0  4.0  6.0
3.0  3.0  5.0  7.0
-----------------------------------------------------
</pre>
<p>
Note, that the first two characters in the file need to be
\"#1\" (a line comment defining the version number of the file format).
Afterwards, the corresponding matrix has to be declared
with type (= \"double\" or \"float\"), name and actual dimensions.
Finally, in successive rows of the file, the elements of the matrix
have to be given. The elements have to be provided as a sequence of
numbers in row-wise order (therefore a matrix row can span several
lines in the file and need not start at the beginning of a line).
Numbers have to be given according to C syntax (such as 2.3, -2, +2.e4).
Number separators are spaces, tab (\t), comma (,), or semicolon (;).
Several matrices may be defined one after another. Line comments start
with the hash symbol (#) and can appear everywhere.
Other characters, like trailing non comments, are not allowed in the file.
The matrix elements are interpreted in exactly the same way
as if the matrix is given as a parameter. For example, the first
column \"table2D_1[2:,1]\" contains the u[1] grid points,
and the first row \"table2D_1[1,2:]\" contains the u[2] grid points.
</p>

<p>
MATLAB is a registered trademark of The MathWorks, Inc.
</p>
</html>"),Icon(
          coordinateSystem(preserveAspectRatio=true,
            extent={{-100.0,-100.0},{100.0,100.0}},
            initialScale=0.1),
            graphics={
          Line(points={{-60.0,40.0},{-60.0,-40.0},{60.0,-40.0},{60.0,40.0},{30.0,40.0},{30.0,-40.0},{-30.0,-40.0},{-30.0,40.0},{-60.0,40.0},{-60.0,20.0},{60.0,20.0},{60.0,0.0},{-60.0,0.0},{-60.0,-20.0},{60.0,-20.0},{60.0,-40.0},{-60.0,-40.0},{-60.0,40.0},{60.0,40.0},{60.0,-40.0}}),
          Line(points={{0.0,40.0},{0.0,-40.0}}),
          Line(points={{-60.0,40.0},{-30.0,20.0}}),
          Line(points={{-30.0,40.0},{-60.0,20.0}}),
          Rectangle(origin={2.3077,-0.0},
            fillColor={255,215,136},
            fillPattern=FillPattern.Solid,
            extent={{-62.3077,0.0},{-32.3077,20.0}}),
          Rectangle(origin={2.3077,-0.0},
            fillColor={255,215,136},
            fillPattern=FillPattern.Solid,
            extent={{-62.3077,-20.0},{-32.3077,0.0}}),
          Rectangle(origin={2.3077,-0.0},
            fillColor={255,215,136},
            fillPattern=FillPattern.Solid,
            extent={{-62.3077,-40.0},{-32.3077,-20.0}}),
          Rectangle(fillColor={255,215,136},
            fillPattern=FillPattern.Solid,
            extent={{-30.0,20.0},{0.0,40.0}}),
          Rectangle(fillColor={255,215,136},
            fillPattern=FillPattern.Solid,
            extent={{0.0,20.0},{30.0,40.0}}),
          Rectangle(origin={-2.3077,-0.0},
            fillColor={255,215,136},
            fillPattern=FillPattern.Solid,
            extent={{32.3077,20.0},{62.3077,40.0}})}),
          Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                  100,100}}), graphics={
              Rectangle(
                extent={{-60,60},{60,-60}},
                fillColor={235,235,235},
                fillPattern=FillPattern.Solid,
                lineColor={0,0,255}),
              Line(points={{60,0},{100,0}}, color={0,0,255}),
              Text(
                extent={{-100,100},{100,64}},
                textString="2 dimensional linear table interpolation",
                lineColor={0,0,255}),
              Line(points={{-54,40},{-54,-40},{54,-40},{54,40},{28,40},{28,-40},{-28,
                    -40},{-28,40},{-54,40},{-54,20},{54,20},{54,0},{-54,0},{-54,-20},
                    {54,-20},{54,-40},{-54,-40},{-54,40},{54,40},{54,-40}}, color={
                    0,0,0}),
              Line(points={{0,40},{0,-40}}, color={0,0,0}),
              Rectangle(
                extent={{-54,20},{-28,0}},
                lineColor={0,0,0},
                fillColor={255,255,0},
                fillPattern=FillPattern.Solid),
              Rectangle(
                extent={{-54,0},{-28,-20}},
                lineColor={0,0,0},
                fillColor={255,255,0},
                fillPattern=FillPattern.Solid),
              Rectangle(
                extent={{-54,-20},{-28,-40}},
                lineColor={0,0,0},
                fillColor={255,255,0},
                fillPattern=FillPattern.Solid),
              Rectangle(
                extent={{-28,40},{0,20}},
                lineColor={0,0,0},
                fillColor={255,255,0},
                fillPattern=FillPattern.Solid),
              Rectangle(
                extent={{0,40},{28,20}},
                lineColor={0,0,0},
                fillColor={255,255,0},
                fillPattern=FillPattern.Solid),
              Rectangle(
                extent={{28,40},{54,20}},
                lineColor={0,0,0},
                fillColor={255,255,0},
                fillPattern=FillPattern.Solid),
              Line(points={{-54,40},{-28,20}}, color={0,0,0}),
              Line(points={{-28,40},{-54,20}}, color={0,0,0}),
              Text(
                extent={{-54,-40},{-30,-56}},
                textString="u1",
                lineColor={0,0,255}),
              Text(
                extent={{28,58},{52,44}},
                textString="u2",
                lineColor={0,0,255}),
              Text(
                extent={{-2,12},{32,-22}},
                textString="y",
                lineColor={0,0,255})}));
      end CombiTable2D;
      annotation (Documentation(info="<html>
<p>This package contains blocks for one- and two-dimensional interpolation in tables. </p>
<h4>Special interest topic: Statically stored tables for real-time simulation targets</h4>
<p>Especially for use on real-time platform targets (e.g., HIL-simulators) with <b>no file system</b>, it is possible to statically
store tables using a function &quot;usertab&quot; in a file conventionally named &quot;usertab.c&quot;. This can be more efficient than providing the tables as Modelica parameter arrays.</p>
<p>This is achieved by providing the tables in a specific structure as C-code and compiling that C-code together with the rest of the simulation model into a binary
that can be executed on the target platform. The &quot;Resources/Data/Tables/&quot; subdirectory of the MSL installation directory contains the files
<a href=\"modelica://Modelica/Resources/Data/Tables/usertab.c\">&quot;usertab.c&quot;</a> and <a href=\"modelica://Modelica/Resources/Data/Tables/usertab.h\">&quot;usertab.h&quot;</a>
that can be used as a template for own developments. While &quot;usertab.c&quot; would be typically used unmodified, the
&quot;usertab.h&quot; needs to adapted for the own needs.</p>
<p>In order to work it is necessary that the compiler pulls in the &quot;usertab.c&quot; file. Different Modelica tools might provide different mechanisms to do so.
Please consult the respective documentation/support for your Modelica tool.</p>
<p>A possible (though a bit &quot;hackish&quot;) Modelica standard conformant approach is to pull in the required files by utilizing a &quot;dummy&quot;-function that uses the Modelica external function
interface to pull in the required &quot;usertab.c&quot;. An example how this can be done is given below.</p>
<pre>
model Test25_usertab \"Test utilizing the usertab.c interface\"
  extends Modelica.Icons.Example;
public
  Modelica.Blocks.Sources.RealExpression realExpression(y=getUsertab(t_new.y))
    annotation (Placement(transformation(extent={{-40,-34},{-10,-14}})));
  Modelica.Blocks.Tables.CombiTable1D t_new(tableOnFile=true, tableName=\"TestTable_1D_a\")
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Modelica.Blocks.Sources.Clock clock
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
protected
  encapsulated function getUsertab
    input Real dummy_u[:];
    output Real dummy_y;
    external \"C\" dummy_y=  mydummyfunc(dummy_u);
    annotation(IncludeDirectory=\"modelica://Modelica/Resources/Data/Tables\",
           Include = \"#include \"usertab.c\"
 double mydummyfunc(const double* dummy_in) {
        return 0;
}
\");
  end getUsertab;
equation
  connect(clock.y,t_new. u[1]) annotation (Line(
      points={{-59,10},{-42,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (experiment(StartTime=0, StopTime=5), uses(Modelica(version=\"3.2.1\")));
end Test25_usertab;
</pre>
</html>"),     Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
                {100,100}}), graphics={
            Rectangle(
              extent={{-76,-26},{80,-76}},
              lineColor={95,95,95},
              fillColor={235,235,235},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{-76,24},{80,-26}},
              lineColor={95,95,95},
              fillColor={235,235,235},
              fillPattern=FillPattern.Solid),
            Rectangle(
              extent={{-76,74},{80,24}},
              lineColor={95,95,95},
              fillColor={235,235,235},
              fillPattern=FillPattern.Solid),
            Line(
              points={{-28,74},{-28,-76}},
              color={95,95,95}),
            Line(
              points={{24,74},{24,-76}},
              color={95,95,95})}));
    end Tables;

    package Types
    "Library of constants and types with choices, especially to build menus"
      extends Modelica.Icons.TypesPackage;

      type Smoothness = enumeration(
        LinearSegments "Table points are linearly interpolated",
        ContinuousDerivative
          "Table points are interpolated such that the first derivative is continuous",

        ConstantSegments
          "Table points are not interpolated, but the value from the previous abscissa point is returned")
      "Enumeration defining the smoothness of table interpolation";

      type Init = enumeration(
        NoInit
          "No initialization (start values are used as guess values with fixed=false)",

        SteadyState
          "Steady state initialization (derivatives of states are zero)",
        InitialState "Initialization with initial states",
        InitialOutput
          "Initialization with initial outputs (and steady state of the states if possible)")
      "Enumeration defining initialization of a block"   annotation (Evaluate=true,
        Documentation(info="<html>
  <p>The following initialization alternatives are available:</p>
  <dl>
    <dt><code><strong>NoInit</strong></code></dt>
      <dd>No initialization (start values are used as guess values with <code>fixed=false</code>)</dd>
    <dt><code><strong>SteadyState</strong></code></dt>
      <dd>Steady state initialization (derivatives of states are zero)</dd>
    <dt><code><strong>InitialState</strong></code></dt>
      <dd>Initialization with initial states</dd>
    <dt><code><strong>InitialOutput</strong></code></dt>
      <dd>Initialization with initial outputs (and steady state of the states if possible)</dd>
  </dl>
</html>"));

      type AnalogFilter = enumeration(
        CriticalDamping "Filter with critical damping",
        Bessel "Bessel filter",
        Butterworth "Butterworth filter",
        ChebyshevI "Chebyshev I filter")
      "Enumeration defining the method of filtering"   annotation (Evaluate=true);

      type FilterType = enumeration(
        LowPass "Low pass filter",
        HighPass "High pass filter",
        BandPass "Band pass filter",
        BandStop "Band stop / notch filter")
      "Enumeration of analog filter types (low, high, band pass or band stop filter)"
        annotation (Evaluate=true);

      class ExternalCombiTable2D
      "External object of 2-dim. table defined by matrix"
        extends ExternalObject;

        function constructor "Initialize 2-dim. table defined by matrix"
          extends Modelica.Icons.Function;
          input String tableName "Table name";
          input String fileName "File name";
          input Real table[:, :];
          input Modelica.Blocks.Types.Smoothness smoothness;
          output ExternalCombiTable2D externalCombiTable2D;
        external"C" externalCombiTable2D = ModelicaStandardTables_CombiTable2D_init(
                tableName,
                fileName,
                table,
                size(table, 1),
                size(table, 2),
                smoothness) annotation (Library={"ModelicaStandardTables"});
        end constructor;

        function destructor "Terminate 2-dim. table defined by matrix"
          extends Modelica.Icons.Function;
          input ExternalCombiTable2D externalCombiTable2D;
        external"C" ModelicaStandardTables_CombiTable2D_close(externalCombiTable2D)
            annotation (Library={"ModelicaStandardTables"});
        end destructor;

      end ExternalCombiTable2D;
      annotation (Documentation(info="<HTML>
<p>
In this package <b>types</b>, <b>constants</b> and <b>external objects</b> are defined that are used
in library Modelica.Blocks. The types have additional annotation choices
definitions that define the menus to be built up in the graphical
user interface when the type is used as parameter in a declaration.
</p>
</HTML>"));
    end Types;

    package Icons "Icons for Blocks"
        extends Modelica.Icons.IconsPackage;

        partial block Block "Basic graphical layout of input/output block"

          annotation (
            Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                  100,100}}), graphics={Rectangle(
                extent={{-100,-100},{100,100}},
                lineColor={0,0,127},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid), Text(
                extent={{-150,150},{150,110}},
                textString="%name",
                lineColor={0,0,255})}),
          Documentation(info="<html>
<p>
Block that has only the basic icon for an input/output
block (no declarations, no equations). Most blocks
of package Modelica.Blocks inherit directly or indirectly
from this block.
</p>
</html>"));

        end Block;
    end Icons;
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100.0,-100.0},{100.0,100.0}}, initialScale=0.1), graphics={
        Rectangle(
          origin={0.0,35.1488},
          fillColor={255,255,255},
          extent={{-30.0,-20.1488},{30.0,20.1488}}),
        Rectangle(
          origin={0.0,-34.8512},
          fillColor={255,255,255},
          extent={{-30.0,-20.1488},{30.0,20.1488}}),
        Line(
          origin={-51.25,0.0},
          points={{21.25,-35.0},{-13.75,-35.0},{-13.75,35.0},{6.25,35.0}}),
        Polygon(
          origin={-40.0,35.0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{10.0,0.0},{-5.0,5.0},{-5.0,-5.0}}),
        Line(
          origin={51.25,0.0},
          points={{-21.25,35.0},{13.75,35.0},{13.75,-35.0},{-6.25,-35.0}}),
        Polygon(
          origin={40.0,-35.0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-10.0,0.0},{5.0,5.0},{5.0,-5.0}})}), Documentation(info="<html>
<p>
This library contains input/output blocks to build up block diagrams.
</p>

<dl>
<dt><b>Main Author:</b>
<dd><a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a><br>
    Deutsches Zentrum f&uuml;r Luft und Raumfahrt e. V. (DLR)<br>
    Oberpfaffenhofen<br>
    Postfach 1116<br>
    D-82230 Wessling<br>
    email: <A HREF=\"mailto:Martin.Otter@dlr.de\">Martin.Otter@dlr.de</A><br>
</dl>
<p>
Copyright &copy; 1998-2013, Modelica Association and DLR.
</p>
<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"https://www.modelica.org/licenses/ModelicaLicense2\"> https://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>
</html>",   revisions="<html>
<ul>
<li><i>June 23, 2004</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Introduced new block connectors and adapted all blocks to the new connectors.
       Included subpackages Continuous, Discrete, Logical, Nonlinear from
       package ModelicaAdditions.Blocks.
       Included subpackage ModelicaAdditions.Table in Modelica.Blocks.Sources
       and in the new package Modelica.Blocks.Tables.
       Added new blocks to Blocks.Sources and Blocks.Logical.
       </li>
<li><i>October 21, 2002</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>
       and <a href=\"http://www.robotic.dlr.de/Christian.Schweiger/\">Christian Schweiger</a>:<br>
       New subpackage Examples, additional components.
       </li>
<li><i>June 20, 2000</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a> and
       Michael Tiller:<br>
       Introduced a replaceable signal type into
       Blocks.Interfaces.RealInput/RealOutput:
<pre>
   replaceable type SignalType = Real
</pre>
       in order that the type of the signal of an input/output block
       can be changed to a physical type, for example:
<pre>
   Sine sin1(outPort(redeclare type SignalType=Modelica.SIunits.Torque))
</pre>
      </li>
<li><i>Sept. 18, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Renamed to Blocks. New subpackages Math, Nonlinear.
       Additional components in subpackages Interfaces, Continuous
       and Sources. </li>
<li><i>June 30, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Realized a first version, based on an existing Dymola library
       of Dieter Moormann and Hilding Elmqvist.</li>
</ul>
</html>"));
  end Blocks;

  package Fluid
  "Library of 1-dim. thermo-fluid flow models using the Modelica.Media media description"
    extends Modelica.Icons.Package;
  import SI = Modelica.SIunits;
  import Cv = Modelica.SIunits.Conversions;

    model System
    "System properties and default values (ambient, flow direction, initialization)"

      package Medium = Modelica.Media.Interfaces.PartialMedium
      "Medium model for default start values"
          annotation (choicesAllMatching = true);
      parameter Modelica.SIunits.AbsolutePressure p_ambient=101325
      "Default ambient pressure"
        annotation(Dialog(group="Environment"));
      parameter Modelica.SIunits.Temperature T_ambient=293.15
      "Default ambient temperature"
        annotation(Dialog(group="Environment"));
      parameter Modelica.SIunits.Acceleration g=Modelica.Constants.g_n
      "Constant gravity acceleration"
        annotation(Dialog(group="Environment"));

      // Assumptions
      parameter Boolean allowFlowReversal = true
      "= false to restrict to design flow direction (port_a -> port_b)"
        annotation(Dialog(tab="Assumptions"), Evaluate=true);
      parameter Modelica.Fluid.Types.Dynamics energyDynamics=
        Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
      "Default formulation of energy balances"
        annotation(Evaluate=true, Dialog(tab = "Assumptions", group="Dynamics"));
      parameter Modelica.Fluid.Types.Dynamics massDynamics=
        energyDynamics "Default formulation of mass balances"
        annotation(Evaluate=true, Dialog(tab = "Assumptions", group="Dynamics"));
      final parameter Modelica.Fluid.Types.Dynamics substanceDynamics=
        massDynamics "Default formulation of substance balances"
        annotation(Evaluate=true, Dialog(tab = "Assumptions", group="Dynamics"));
      final parameter Modelica.Fluid.Types.Dynamics traceDynamics=
        massDynamics "Default formulation of trace substance balances"
        annotation(Evaluate=true, Dialog(tab = "Assumptions", group="Dynamics"));
      parameter Modelica.Fluid.Types.Dynamics momentumDynamics=
        Modelica.Fluid.Types.Dynamics.SteadyState
      "Default formulation of momentum balances, if options available"
        annotation(Evaluate=true, Dialog(tab = "Assumptions", group="Dynamics"));

      // Initialization
      parameter Modelica.SIunits.MassFlowRate m_flow_start = 0
      "Default start value for mass flow rates"
        annotation(Dialog(tab = "Initialization"));
      parameter Modelica.SIunits.AbsolutePressure p_start = p_ambient
      "Default start value for pressures"
        annotation(Dialog(tab = "Initialization"));
      parameter Modelica.SIunits.Temperature T_start = T_ambient
      "Default start value for temperatures"
        annotation(Dialog(tab = "Initialization"));
      // Advanced
      parameter Boolean use_eps_Re = false
      "= true to determine turbulent region automatically using Reynolds number"
        annotation(Evaluate=true, Dialog(tab = "Advanced"));
      parameter Modelica.SIunits.MassFlowRate m_flow_nominal = if use_eps_Re then 1 else 1e2*m_flow_small
      "Default nominal mass flow rate"
        annotation(Dialog(tab="Advanced", enable = use_eps_Re));
      parameter Real eps_m_flow(min=0) = 1e-4
      "Regularization of zero flow for |m_flow| < eps_m_flow*m_flow_nominal"
        annotation(Dialog(tab = "Advanced", enable = use_eps_Re));
      parameter Modelica.SIunits.AbsolutePressure dp_small(min=0) = 1
      "Default small pressure drop for regularization of laminar and zero flow"
        annotation(Dialog(tab="Advanced", group="Classic", enable = not use_eps_Re));
      parameter Modelica.SIunits.MassFlowRate m_flow_small(min=0) = 1e-2
      "Default small mass flow rate for regularization of laminar and zero flow"
        annotation(Dialog(tab = "Advanced", group="Classic", enable = not use_eps_Re));
    initial equation
      //assert(use_eps_Re, "*** Using classic system.m_flow_small and system.dp_small."
      //       + " They do not distinguish between laminar flow and regularization of zero flow."
      //       + " Absolute small values are error prone for models with local nominal values."
      //       + " Moreover dp_small can generally be obtained automatically."
      //       + " Please update the model to new system.use_eps_Re = true  (see system, Advanced tab). ***",
      //       level=AssertionLevel.warning);
      annotation (
        defaultComponentName="system",
        defaultComponentPrefixes="inner",
        missingInnerMessage="
Your model is using an outer \"system\" component but
an inner \"system\" component is not defined.
For simulation drag Modelica.Fluid.System into your model
to specify system properties.
",      Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
                100}}), graphics={
            Rectangle(
              extent={{-100,100},{100,-100}},
              lineColor={0,0,255},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Text(
              extent={{-150,150},{150,110}},
              lineColor={0,0,255},
              textString="%name"),
            Line(points={{-86,-30},{82,-30}}, color={0,0,0}),
            Line(points={{-82,-68},{-52,-30}}, color={0,0,0}),
            Line(points={{-48,-68},{-18,-30}}, color={0,0,0}),
            Line(points={{-14,-68},{16,-30}}, color={0,0,0}),
            Line(points={{22,-68},{52,-30}}, color={0,0,0}),
            Line(points={{74,84},{74,14}}, color={0,0,0}),
            Polygon(
              points={{60,14},{88,14},{74,-18},{60,14}},
              lineColor={0,0,0},
              fillColor={0,0,0},
              fillPattern=FillPattern.Solid),
            Text(
              extent={{16,20},{60,-18}},
              lineColor={0,0,0},
              textString="g"),
            Text(
              extent={{-90,82},{74,50}},
              lineColor={0,0,0},
              textString="defaults"),
            Line(
              points={{-82,14},{-42,-20},{2,30}},
              color={0,0,0},
              thickness=0.5),
            Ellipse(
              extent={{-10,40},{12,18}},
              pattern=LinePattern.None,
              lineColor={0,0,0},
              fillColor={255,0,0},
              fillPattern=FillPattern.Solid)}),
        Documentation(info="<html>
<p>
 A system component is needed in each fluid model to provide system-wide settings, such as ambient conditions and overall modeling assumptions.
 The system settings are propagated to the fluid models using the inner/outer mechanism.
</p>
<p>
 A model should never directly use system parameters.
 Instead a local parameter should be declared, which uses the global setting as default.
 The only exceptions are:</p>
 <ul>
  <li>the gravity system.g,</li>
  <li>the global system.eps_m_flow, which is used to define a local m_flow_small for the local m_flow_nominal:
      <pre>m_flow_small = system.eps_m_flow*m_flow_nominal</pre>
  </li>
 </ul>
<p>
 The global system.m_flow_small and system.dp_small are classic parameters.
 They do not distinguish between laminar flow and regularization of zero flow.
 Absolute small values are error prone for models with local nominal values.
 Moreover dp_small can generally be obtained automatically.
 Consider using the new system.use_eps_Re = true (see Advanced tab).
</p>
</html>"));
    end System;

    package Vessels "Devices for storing fluid"
        extends Modelica.Icons.VariantsPackage;

      package BaseClasses
      "Base classes used in the Vessels package (only of interest to build new component models)"
        extends Modelica.Icons.BasesPackage;

        connector VesselFluidPorts_b
        "Fluid connector with outlined, large icon to be used for horizontally aligned vectors of FluidPorts (vector dimensions must be added after dragging)"
          extends Interfaces.FluidPort;
          annotation (defaultComponentName="ports_b",
                      Diagram(coordinateSystem(
                preserveAspectRatio=false,
                extent={{-50,-200},{50,200}},
                initialScale=0.2), graphics={
                Text(extent={{-75,130},{75,100}}, textString="%name"),
                Rectangle(
                  extent={{-25,100},{25,-100}},
                  lineColor={0,0,0}),
                Ellipse(
                  extent={{-22,100},{-10,-100}},
                  lineColor={0,0,0},
                  fillColor={0,127,255},
                  fillPattern=FillPattern.Solid),
                Ellipse(
                  extent={{-20,-69},{-12,69}},
                  lineColor={0,127,255},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Ellipse(
                  extent={{-6,100},{6,-100}},
                  lineColor={0,0,0},
                  fillColor={0,127,255},
                  fillPattern=FillPattern.Solid),
                Ellipse(
                  extent={{10,100},{22,-100}},
                  lineColor={0,0,0},
                  fillColor={0,127,255},
                  fillPattern=FillPattern.Solid),
                Ellipse(
                  extent={{-4,-69},{4,69}},
                  lineColor={0,127,255},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Ellipse(
                  extent={{12,-69},{20,69}},
                  lineColor={0,127,255},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid)}),
               Icon(coordinateSystem(
                preserveAspectRatio=false,
                extent={{-50,-200},{50,200}},
                initialScale=0.2), graphics={
                Rectangle(
                  extent={{-50,200},{50,-200}},
                  lineColor={0,127,255},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Ellipse(
                  extent={{-44,200},{-20,-200}},
                  lineColor={0,0,0},
                  fillColor={0,127,255},
                  fillPattern=FillPattern.Solid),
                Ellipse(
                  extent={{-12,200},{12,-200}},
                  lineColor={0,0,0},
                  fillColor={0,127,255},
                  fillPattern=FillPattern.Solid),
                Ellipse(
                  extent={{20,200},{44,-200}},
                  lineColor={0,0,0},
                  fillColor={0,127,255},
                  fillPattern=FillPattern.Solid),
                Ellipse(
                  extent={{-39,-118.5},{-25,113}},
                  lineColor={0,127,255},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Ellipse(
                  extent={{-7,-118.5},{7,113}},
                  lineColor={0,127,255},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid),
                Ellipse(
                  extent={{25,-117.5},{39,114}},
                  lineColor={0,127,255},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid)}));
        end VesselFluidPorts_b;
      end BaseClasses;
      annotation (Documentation(info="<html>

</html>"));
    end Vessels;

    package Interfaces
    "Interfaces for steady state and unsteady, mixed-phase, multi-substance, incompressible and compressible flow"
      extends Modelica.Icons.InterfacesPackage;

      connector FluidPort
      "Interface for quasi one-dimensional fluid flow in a piping network (incompressible or compressible, one or more phases, one or more substances)"

        replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
        "Medium model"   annotation (choicesAllMatching=true);

        flow Medium.MassFlowRate m_flow
        "Mass flow rate from the connection point into the component";
        Medium.AbsolutePressure p
        "Thermodynamic pressure in the connection point";
        stream Medium.SpecificEnthalpy h_outflow
        "Specific thermodynamic enthalpy close to the connection point if m_flow < 0";
        stream Medium.MassFraction Xi_outflow[Medium.nXi]
        "Independent mixture mass fractions m_i/m close to the connection point if m_flow < 0";
        stream Medium.ExtraProperty C_outflow[Medium.nC]
        "Properties c_i/m close to the connection point if m_flow < 0";
      end FluidPort;

      connector FluidPort_a "Generic fluid connector at design inlet"
        extends FluidPort;
        annotation (defaultComponentName="port_a",
                    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                  -100},{100,100}}), graphics={Ellipse(
                extent={{-40,40},{40,-40}},
                lineColor={0,0,0},
                fillColor={0,127,255},
                fillPattern=FillPattern.Solid), Text(extent={{-150,110},{150,50}},
                  textString="%name")}),
             Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
                  100,100}}), graphics={Ellipse(
                extent={{-100,100},{100,-100}},
                lineColor={0,127,255},
                fillColor={0,127,255},
                fillPattern=FillPattern.Solid), Ellipse(
                extent={{-100,100},{100,-100}},
                lineColor={0,0,0},
                fillColor={0,127,255},
                fillPattern=FillPattern.Solid)}));
      end FluidPort_a;

      connector FluidPort_b "Generic fluid connector at design outlet"
        extends FluidPort;
        annotation (defaultComponentName="port_b",
                    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                  -100},{100,100}}), graphics={
              Ellipse(
                extent={{-40,40},{40,-40}},
                lineColor={0,0,0},
                fillColor={0,127,255},
                fillPattern=FillPattern.Solid),
              Ellipse(
                extent={{-30,30},{30,-30}},
                lineColor={0,127,255},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Text(extent={{-150,110},{150,50}}, textString="%name")}),
             Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
                  100,100}}), graphics={
              Ellipse(
                extent={{-100,100},{100,-100}},
                lineColor={0,127,255},
                fillColor={0,127,255},
                fillPattern=FillPattern.Solid),
              Ellipse(
                extent={{-100,100},{100,-100}},
                lineColor={0,0,0},
                fillColor={0,127,255},
                fillPattern=FillPattern.Solid),
              Ellipse(
                extent={{-80,80},{80,-80}},
                lineColor={0,127,255},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid)}));
      end FluidPort_b;

      partial model PartialTwoPort "Partial component with two ports"
        import Modelica.Constants;
        outer Modelica.Fluid.System system "System wide properties";

        replaceable package Medium =
            Modelica.Media.Interfaces.PartialMedium "Medium in the component"
            annotation (choicesAllMatching = true);

        parameter Boolean allowFlowReversal = system.allowFlowReversal
        "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
          annotation(Dialog(tab="Assumptions"), Evaluate=true);

        Modelica.Fluid.Interfaces.FluidPort_a port_a(
                                      redeclare package Medium = Medium,
                           m_flow(min=if allowFlowReversal then -Constants.inf else 0))
        "Fluid connector a (positive design flow direction is from port_a to port_b)"
          annotation (Placement(transformation(extent={{-110,-10},{-90,10}},
                  rotation=0)));
        Modelica.Fluid.Interfaces.FluidPort_b port_b(
                                      redeclare package Medium = Medium,
                           m_flow(max=if allowFlowReversal then +Constants.inf else 0))
        "Fluid connector b (positive design flow direction is from port_a to port_b)"
          annotation (Placement(transformation(extent={{110,-10},{90,10}}, rotation=
                   0), iconTransformation(extent={{110,-10},{90,10}})));
        // Model structure, e.g., used for visualization
    protected
        parameter Boolean port_a_exposesState = false
        "= true if port_a exposes the state of a fluid volume";
        parameter Boolean port_b_exposesState = false
        "= true if port_b.p exposes the state of a fluid volume";
        parameter Boolean showDesignFlowDirection = true
        "= false to hide the arrow in the model icon";

        annotation (
          Documentation(info="<html>
<p>
This partial model defines an interface for components with two ports.
The treatment of the design flow direction and of flow reversal are predefined based on the parameter <code><b>allowFlowReversal</b></code>.
The component may transport fluid and may have internal storage for a given fluid <code><b>Medium</b></code>.
</p>
<p>
An extending model providing direct access to internal storage of mass or energy through port_a or port_b
should redefine the protected parameters <code><b>port_a_exposesState</b></code> and <code><b>port_b_exposesState</b></code> appropriately.
This will be visualized at the port icons, in order to improve the understanding of fluid model diagrams.
</p>
</html>"),Icon(coordinateSystem(
                preserveAspectRatio=true,
                extent={{-100,-100},{100,100}}), graphics={
              Polygon(
                points={{20,-70},{60,-85},{20,-100},{20,-70}},
                lineColor={0,128,255},
                smooth=Smooth.None,
                fillColor={0,128,255},
                fillPattern=FillPattern.Solid,
                visible=showDesignFlowDirection),
              Polygon(
                points={{20,-75},{50,-85},{20,-95},{20,-75}},
                lineColor={255,255,255},
                smooth=Smooth.None,
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid,
                visible=allowFlowReversal),
              Line(
                points={{55,-85},{-60,-85}},
                color={0,128,255},
                smooth=Smooth.None,
                visible=showDesignFlowDirection),
              Text(
                extent={{-149,-114},{151,-154}},
                lineColor={0,0,255},
                textString="%name"),
              Ellipse(
                extent={{-110,26},{-90,-24}},
                lineColor={0,0,0},
                fillColor={0,0,0},
                fillPattern=FillPattern.Solid,
                visible=port_a_exposesState),
              Ellipse(
                extent={{90,25},{110,-25}},
                lineColor={0,0,0},
                fillColor={0,0,0},
                fillPattern=FillPattern.Solid,
                visible=port_b_exposesState)}));
      end PartialTwoPort;

    partial model PartialTwoPortTransport
      "Partial element transporting fluid between two ports without storage of mass or energy"

      extends PartialTwoPort(
        final port_a_exposesState=false,
        final port_b_exposesState=false);

      // Advanced
      // Note: value of dp_start shall be refined by derived model, basing on local dp_nominal
      parameter Medium.AbsolutePressure dp_start = 0.01*system.p_start
        "Guess value of dp = port_a.p - port_b.p"
        annotation(Dialog(tab = "Advanced", enable=from_dp));
      parameter Medium.MassFlowRate m_flow_start = system.m_flow_start
        "Guess value of m_flow = port_a.m_flow"
        annotation(Dialog(tab = "Advanced", enable=not from_dp));
      // Note: value of m_flow_small shall be refined by derived model, basing on local m_flow_nominal
      parameter Medium.MassFlowRate m_flow_small = if system.use_eps_Re then system.eps_m_flow*system.m_flow_nominal else system.m_flow_small
        "Small mass flow rate for regularization of zero flow"
        annotation(Dialog(tab = "Advanced"));

      // Diagnostics
      parameter Boolean show_T = true
        "= true, if temperatures at port_a and port_b are computed"
        annotation(Dialog(tab="Advanced",group="Diagnostics"));
      parameter Boolean show_V_flow = true
        "= true, if volume flow rate at inflowing port is computed"
        annotation(Dialog(tab="Advanced",group="Diagnostics"));

      // Variables
      Medium.MassFlowRate m_flow(
         min=if allowFlowReversal then -Modelica.Constants.inf else 0,
         start = m_flow_start) "Mass flow rate in design flow direction";
      Modelica.SIunits.Pressure dp(start=dp_start)
        "Pressure difference between port_a and port_b (= port_a.p - port_b.p)";

      Modelica.SIunits.VolumeFlowRate V_flow=
          m_flow/Modelica.Fluid.Utilities.regStep(m_flow,
                      Medium.density(state_a),
                      Medium.density(state_b),
                      m_flow_small) if show_V_flow
        "Volume flow rate at inflowing port (positive when flow from port_a to port_b)";

      Medium.Temperature port_a_T=
          Modelica.Fluid.Utilities.regStep(port_a.m_flow,
                      Medium.temperature(state_a),
                      Medium.temperature(Medium.setState_phX(port_a.p, port_a.h_outflow, port_a.Xi_outflow)),
                      m_flow_small) if show_T
        "Temperature close to port_a, if show_T = true";
      Medium.Temperature port_b_T=
          Modelica.Fluid.Utilities.regStep(port_b.m_flow,
                      Medium.temperature(state_b),
                      Medium.temperature(Medium.setState_phX(port_b.p, port_b.h_outflow, port_b.Xi_outflow)),
                      m_flow_small) if show_T
        "Temperature close to port_b, if show_T = true";
    protected
      Medium.ThermodynamicState state_a
        "state for medium inflowing through port_a";
      Medium.ThermodynamicState state_b
        "state for medium inflowing through port_b";
    equation
      // medium states
      state_a = Medium.setState_phX(port_a.p, inStream(port_a.h_outflow), inStream(port_a.Xi_outflow));
      state_b = Medium.setState_phX(port_b.p, inStream(port_b.h_outflow), inStream(port_b.Xi_outflow));

      // Pressure drop in design flow direction
      dp = port_a.p - port_b.p;

      // Design direction of mass flow rate
      m_flow = port_a.m_flow;
      assert(m_flow > -m_flow_small or allowFlowReversal, "Reverting flow occurs even though allowFlowReversal is false");

      // Mass balance (no storage)
      port_a.m_flow + port_b.m_flow = 0;

      // Transport of substances
      port_a.Xi_outflow = inStream(port_b.Xi_outflow);
      port_b.Xi_outflow = inStream(port_a.Xi_outflow);

      port_a.C_outflow = inStream(port_b.C_outflow);
      port_b.C_outflow = inStream(port_a.C_outflow);

      annotation (
        Documentation(info="<html>
<p>
This component transports fluid between its two ports, without storing mass or energy.
Energy may be exchanged with the environment though, e.g., in the form of work.
<code>PartialTwoPortTransport</code> is intended as base class for devices like orifices, valves and simple fluid machines.</p>
<p>
Three equations need to be added by an extending class using this component:
</p>
<ul>
<li>the momentum balance specifying the relationship between the pressure drop <code>dp</code> and the mass flow rate <code>m_flow</code>,</li>
<li><code>port_b.h_outflow</code> for flow in design direction, and</li>
<li><code>port_a.h_outflow</code> for flow in reverse direction.</li>
</ul>
<p>
Moreover appropriate values shall be assigned to the following parameters:
</p>
<ul>
<li><code>dp_start</code> for a guess of the pressure drop</li>
<li><code>m_flow_small</code> for regularization of zero flow.</li>
</ul>
</html>"));
    end PartialTwoPortTransport;
      annotation (Documentation(info="<html>

</html>",     revisions="<html>
<ul>
<li><i>June 9th, 2008</i>
       by Michael Sielemann: Introduced stream keyword after decision at 57th Design Meeting (Lund).</li>
<li><i>May 30, 2007</i>
       by Christoph Richter: moved everything back to its original position in Modelica.Fluid.</li>
<li><i>Apr. 20, 2007</i>
       by Christoph Richter: moved parts of the original package from Modelica.Fluid
       to the development branch of Modelica 2.2.2.</li>
<li><i>Nov. 2, 2005</i>
       by Francesco Casella: restructured after 45th Design Meeting.</li>
<li><i>Nov. 20-21, 2002</i>
       by Hilding Elmqvist, Mike Tiller, Allan Watson, John Batteh, Chuck Newman,
       Jonas Eborn: Improved at the 32nd Modelica Design Meeting.
<li><i>Nov. 11, 2002</i>
       by Hilding Elmqvist, Martin Otter: improved version.</li>
<li><i>Nov. 6, 2002</i>
       by Hilding Elmqvist: first version.</li>
<li><i>Aug. 11, 2002</i>
       by Martin Otter: Improved according to discussion with Hilding
       Elmqvist and Hubertus Tummescheit.<br>
       The PortVicinity model is manually
       expanded in the base models.<br>
       The Volume used for components is renamed
       PartialComponentVolume.<br>
       A new volume model \"Fluid.Components.PortVolume\"
       introduced that has the medium properties of the port to which it is
       connected.<br>
       Fluid.Interfaces.PartialTwoPortTransport is a component
       for elementary two port transport elements, whereas PartialTwoPort
       is a component for a container component.</li>
</ul>
</html>"));
    end Interfaces;

    package Types "Common types for fluid models"
      extends Modelica.Icons.TypesPackage;

      type Dynamics = enumeration(
        DynamicFreeInitial
          "DynamicFreeInitial -- Dynamic balance, Initial guess value",
        FixedInitial "FixedInitial -- Dynamic balance, Initial value fixed",
        SteadyStateInitial
          "SteadyStateInitial -- Dynamic balance, Steady state initial with guess value",

        SteadyState "SteadyState -- Steady state balance, Initial guess value")
      "Enumeration to define definition of balance equations"
      annotation (Documentation(info="<html>
<p>
Enumeration to define the formulation of balance equations
(to be selected via choices menu):
</p>

<table border=1 cellspacing=0 cellpadding=2>
<tr><th><b>Dynamics.</b></th><th><b>Meaning</b></th></tr>
<tr><td>DynamicFreeInitial</td><td>Dynamic balance, Initial guess value</td></tr>

<tr><td>FixedInitial</td><td>Dynamic balance, Initial value fixed</td></tr>

<tr><td>SteadyStateInitial</td><td>Dynamic balance, Steady state initial with guess value</td></tr>

<tr><td>SteadyState</td><td>Steady state balance, Initial guess value</td></tr>
</table>

<p>
The enumeration \"Dynamics\" is used for the mass, energy and momentum balance equations
respectively. The exact meaning for the three balance equations is stated in the following
tables:
</p>

<table border=1 cellspacing=0 cellpadding=2>
<tr><td colspan=\"3\"><b>Mass balance</b> </td>
<tr><td><b>Dynamics.</b></td>
    <td><b>Balance equation</b></td>
    <td><b>Initial condition</b></td></tr>

<tr><td> DynamicFreeInitial</td>
    <td> no restrictions </td>
    <td> no initial conditions </td></tr>

<tr><td> FixedInitial</td>
    <td> no restrictions </td>
    <td> <b>if</b> Medium.singleState <b>then</b> <br>
         &nbsp;&nbsp;no initial condition<br>
         <b>else</b> p=p_start </td></tr>

<tr><td> SteadyStateInitial</td>
    <td> no restrictions </td>
    <td> <b>if</b> Medium.singleState <b>then</b> <br>
         &nbsp;&nbsp;no initial condition<br>
         <b>else</b> <b>der</b>(p)=0 </td></tr>

<tr><td> SteadyState</td>
    <td> <b>der</b>(m)=0  </td>
    <td> no initial conditions </td></tr>
</table>

&nbsp;<br>

<table border=1 cellspacing=0 cellpadding=2>
<tr><td colspan=\"3\"><b>Energy balance</b> </td>
<tr><td><b>Dynamics.</b></td>
    <td><b>Balance equation</b></td>
    <td><b>Initial condition</b></td></tr>

<tr><td> DynamicFreeInitial</td>
    <td> no restrictions </td>
    <td> no initial conditions </td></tr>

<tr><td> FixedInitial</td>
    <td> no restrictions </td>
    <td> T=T_start or h=h_start </td></tr>

<tr><td> SteadyStateInitial</td>
    <td> no restrictions </td>
    <td> <b>der</b>(T)=0 or <b>der</b>(h)=0 </td></tr>

<tr><td> SteadyState</td>
    <td> <b>der</b>(U)=0  </td>
    <td> no initial conditions </td></tr>
</table>

&nbsp;<br>

<table border=1 cellspacing=0 cellpadding=2>
<tr><td colspan=\"3\"><b>Momentum balance</b> </td>
<tr><td><b>Dynamics.</b></td>
    <td><b>Balance equation</b></td>
    <td><b>Initial condition</b></td></tr>

<tr><td> DynamicFreeInitial</td>
    <td> no restrictions </td>
    <td> no initial conditions </td></tr>

<tr><td> FixedInitial</td>
    <td> no restrictions </td>
    <td> m_flow = m_flow_start </td></tr>

<tr><td> SteadyStateInitial</td>
    <td> no restrictions </td>
    <td> <b>der</b>(m_flow)=0 </td></tr>

<tr><td> SteadyState</td>
    <td> <b>der</b>(m_flow)=0 </td>
    <td> no initial conditions </td></tr>
</table>

<p>
In the tables above, the equations are given for one-substance fluids. For multiple-substance
fluids and for trace substances, equivalent equations hold.
</p>

<p>
Medium.singleState is a medium property and defines whether the medium is only
described by one state (+ the mass fractions in case of a multi-substance fluid). In such
a case one initial condition less must be provided. For example, incompressible
media have Medium.singleState = <b>true</b>.
</p>

</html>"));
      annotation (preferredView="info",
                  Documentation(info="<html>

</html>"));
    end Types;

    package Utilities
    "Utility models to construct fluid components (should not be used directly)"
      extends Modelica.Icons.UtilitiesPackage;

      function regRoot2
      "Anti-symmetric approximation of square root with discontinuous factor so that the first derivative is finite and continuous"

        extends Modelica.Icons.Function;
        input Real x "abscissa value";
        input Real x_small(min=0)=0.01
        "approximation of function for |x| <= x_small";
        input Real k1(min=0)=1 "y = if x>=0 then sqrt(k1*x) else -sqrt(k2*|x|)";
        input Real k2(min=0)=1 "y = if x>=0 then sqrt(k1*x) else -sqrt(k2*|x|)";
        input Boolean use_yd0 = false "= true, if yd0 shall be used";
        input Real yd0(min=0)=1 "Desired derivative at x=0: dy/dx = yd0";
        output Real y "ordinate value";
    protected
        encapsulated function regRoot2_utility
        "Interpolating with two 3-order polynomials with a prescribed derivative at x=0"
          import Modelica;
          extends Modelica.Icons.Function;
          import Modelica.Fluid.Utilities.evaluatePoly3_derivativeAtZero;
           input Real x;
           input Real x1 "approximation of function abs(x) < x1";
           input Real k1
          "y = if x>=0 then sqrt(k1*x) else -sqrt(k2*|x|); k1 >= k2";
           input Real k2 "y = if x>=0 then sqrt(k1*x) else -sqrt(k2*|x|))";
           input Boolean use_yd0 "= true, if yd0 shall be used";
           input Real yd0(min=0) "Desired derivative at x=0: dy/dx = yd0";
           output Real y;
      protected
           Real x2;
           Real xsqrt1;
           Real xsqrt2;
           Real y1;
           Real y2;
           Real y1d;
           Real y2d;
           Real w;
           Real y0d;
           Real w1;
           Real w2;
           Real sqrt_k1 = if k1 > 0 then sqrt(k1) else 0;
           Real sqrt_k2 = if k2 > 0 then sqrt(k2) else 0;
        algorithm
           if k2 > 0 then
              // Since k1 >= k2 required, k2 > 0 means that k1 > 0
              x2 :=-x1*(k2/k1);
           elseif k1 > 0 then
              x2 := -x1;
           else
              y := 0;
              return;
           end if;

           if x <= x2 then
              y := -sqrt_k2*sqrt(abs(x));
           else
              y1 :=sqrt_k1*sqrt(x1);
              y2 :=-sqrt_k2*sqrt(abs(x2));
              y1d :=sqrt_k1/sqrt(x1)/2;
              y2d :=sqrt_k2/sqrt(abs(x2))/2;

              if use_yd0 then
                 y0d :=yd0;
              else
                 /* Determine derivative, such that first and second derivative
              of left and right polynomial are identical at x=0:
           _
           Basic equations:
              y_right = a1*(x/x1) + a2*(x/x1)^2 + a3*(x/x1)^3
              y_left  = b1*(x/x2) + b2*(x/x2)^2 + b3*(x/x2)^3
              yd_right*x1 = a1 + 2*a2*(x/x1) + 3*a3*(x/x1)^2
              yd_left *x2 = b1 + 2*b2*(x/x2) + 3*b3*(x/x2)^2
              ydd_right*x1^2 = 2*a2 + 6*a3*(x/x1)
              ydd_left *x2^2 = 2*b2 + 6*b3*(x/x2)
           _
           Conditions (6 equations for 6 unknowns):
                     y1 = a1 + a2 + a3
                     y2 = b1 + b2 + b3
                 y1d*x1 = a1 + 2*a2 + 3*a3
                 y2d*x2 = b1 + 2*b2 + 3*b3
                    y0d = a1/x1 = b1/x2
                   y0dd = 2*a2/x1^2 = 2*b2/x2^2
           _
           Derived equations:
              b1 = a1*x2/x1
              b2 = a2*(x2/x1)^2
              b3 = y2 - b1 - b2
                 = y2 - a1*(x2/x1) - a2*(x2/x1)^2
              a3 = y1 - a1 - a2
           _
           Remaining equations
              y1d*x1 = a1 + 2*a2 + 3*(y1 - a1 - a2)
                     = 3*y1 - 2*a1 - a2
              y2d*x2 = a1*(x2/x1) + 2*a2*(x2/x1)^2 +
                       3*(y2 - a1*(x2/x1) - a2*(x2/x1)^2)
                     = 3*y2 - 2*a1*(x2/x1) - a2*(x2/x1)^2
              y0d    = a1/x1
           _
           Solving these equations results in y0d below
           (note, the denominator "(1-w)" is always non-zero, because w is negative)
           */
                 w :=x2/x1;
                 y0d := ( (3*y2 - x2*y2d)/w - (3*y1 - x1*y1d)*w) /(2*x1*(1 - w));
              end if;

              /* Modify derivative y0d, such that the polynomial is
           monotonically increasing. A sufficient condition is
             0 <= y0d <= sqrt(8.75*k_i/|x_i|)
        */
              w1 :=sqrt_k1*sqrt(8.75/x1);
              w2 :=sqrt_k2*sqrt(8.75/abs(x2));
              y0d :=smooth(2, min(y0d, 0.9*min(w1, w2)));

              /* Perform interpolation in scaled polynomial:
           y_new = y/y1
           x_new = x/x1
        */
              y := y1*(if x >= 0 then evaluatePoly3_derivativeAtZero(x/x1,1,1,y1d*x1/y1,y0d*x1/y1) else
                                      evaluatePoly3_derivativeAtZero(x/x1,x2/x1,y2/y1,y2d*x1/y1,y0d*x1/y1));
           end if;
           annotation(smoothOrder=2);
        end regRoot2_utility;
      algorithm
        y := smooth(2, if x >= x_small then sqrt(k1*x) else
                       if x <= -x_small then -sqrt(k2*abs(x)) else
                       if k1 >= k2 then regRoot2_utility(x,x_small,k1,k2,use_yd0,yd0) else
                                       -regRoot2_utility(-x,x_small,k2,k1,use_yd0,yd0));
        annotation(smoothOrder=2, Documentation(info="<html>
<p>
Approximates the function
</p>
<pre>
   y = <b>if</b> x &ge; 0 <b>then</b> <b>sqrt</b>(k1*x) <b>else</b> -<b>sqrt</b>(k2*<b>abs</b>(x)), with k1, k2 &ge; 0
</pre>
<p>
in such a way that within the region -x_small &le; x &le; x_small,
the function is described by two polynomials of third order
(one in the region -x_small .. 0 and one within the region 0 .. x_small)
such that
</p>
<ul>
<li> The derivative at x=0 is finite. </li>
<li> The overall function is continuous with a
     continuous first derivative everywhere.</li>
<li> If parameter use_yd0 = <b>false</b>, the two polynomials
     are constructed such that the second derivatives at x=0
     are identical. If use_yd0 = <b>true</b>, the derivative
     at x=0 is explicitly provided via the additional argument
     yd0. If necessary, the derivative yd0 is automatically
     reduced in order that the polynomials are strict monotonically
     increasing <i>[Fritsch and Carlson, 1980]</i>.</li>
</ul>
<p>
Typical screenshots for two different configurations
are shown below. The first one with k1=k2=1:
</p>
<p>
<img src=\"modelica://Modelica/Resources/Images/Fluid/Components/regRoot2_a.png\"
     alt=\"regRoot2_a.png\">
</p>
<p>
and the second one with k1=1 and k2=3:
</p>
<p>
<img src=\"modelica://Modelica/Resources/Images/Fluid/Components/regRoot2_b.png\"
      alt=\"regRoot2_b.png\">
</p>

<p>
The (smooth) derivative of the function with
k1=1, k2=3 is shown in the next figure:
<p>
<img src=\"modelica://Modelica/Resources/Images/Fluid/Components/regRoot2_c.png\"
     alt=\"regRoot2_c.png\">
</p>

<p>
<b>Literature</b>
</p>

<dl>
<dt> Fritsch F.N. and Carlson R.E. (1980):</dt>
<dd> <b>Monotone piecewise cubic interpolation</b>.
     SIAM J. Numerc. Anal., Vol. 17, No. 2, April 1980, pp. 238-246</dd>
</dl>
</html>",     revisions="<html>
<ul>
<li><i>Sept., 2019</i>
    by <a href=\"mailto:Martin.Otter@DLR.de\">Martin Otter</a>:<br>
    Improved so that k1=0 and/or k2=0 is also possible.</li>
<li><i>Nov., 2005</i>
    by <a href=\"mailto:Martin.Otter@DLR.de\">Martin Otter</a>:<br>
    Designed and implemented.</li>
</ul>
</html>"));
      end regRoot2;

      function regSquare2
      "Anti-symmetric approximation of square with discontinuous factor so that the first derivative is non-zero and is continuous"
        extends Modelica.Icons.Function;
        input Real x "abscissa value";
        input Real x_small(min=0)=0.01
        "approximation of function for |x| <= x_small";
        input Real k1(min=0)=1 "y = (if x>=0 then k1 else k2)*x*|x|";
        input Real k2(min=0)=1 "y = (if x>=0 then k1 else k2)*x*|x|";
        input Boolean use_yd0 = false "= true, if yd0 shall be used";
        input Real yd0(min=0)=1 "Desired derivative at x=0: dy/dx = yd0";
        output Real y "ordinate value";
    protected
        encapsulated function regSquare2_utility
        "Interpolating with two 3-order polynomials with a prescribed derivative at x=0"
          import Modelica;
          extends Modelica.Icons.Function;
          import Modelica.Fluid.Utilities.evaluatePoly3_derivativeAtZero;
           input Real x;
           input Real x1 "approximation of function abs(x) < x1";
           input Real k1 "y = (if x>=0 then k1 else -k2)*x*|x|; k1 >= k2";
           input Real k2 "y = (if x>=0 then k1 else -k2)*x*|x|";
           input Boolean use_yd0 = false "= true, if yd0 shall be used";
           input Real yd0(min=0)=1 "Desired derivative at x=0: dy/dx = yd0";
           output Real y;
      protected
           Real x2;
           Real y1;
           Real y2;
           Real y1d;
           Real y2d;
           Real w;
           Real w1;
           Real w2;
           Real y0d;
           Real ww;
        algorithm
           // x2 :=-x1*(k2/k1)^2;
           x2 := -x1;
           if x <= x2 then
              y := -k2*x^2;
           else
               y1 := k1*x1^2;
               y2 :=-k2*x2^2;
              y1d := k1*2*x1;
              y2d :=-k2*2*x2;
              if use_yd0 then
                 y0d :=yd0;
              else
                 /* Determine derivative, such that first and second derivative
              of left and right polynomial are identical at x=0:
              see derivation in function regRoot2
           */
                 w :=x2/x1;
                 y0d := ( (3*y2 - x2*y2d)/w - (3*y1 - x1*y1d)*w) /(2*x1*(1 - w));
              end if;

              /* Modify derivative y0d, such that the polynomial is
           monotonically increasing. A sufficient condition is
             0 <= y0d <= sqrt(5)*k_i*|x_i|
        */
              w1 :=sqrt(5)*k1*x1;
              w2 :=sqrt(5)*k2*abs(x2);
              // y0d :=min(y0d, 0.9*min(w1, w2));
              ww :=0.9*(if w1 < w2 then w1 else w2);
              if ww < y0d then
                 y0d :=ww;
              end if;
              y := if x >= 0 then evaluatePoly3_derivativeAtZero(x,x1,y1,y1d,y0d) else
                                  evaluatePoly3_derivativeAtZero(x,x2,y2,y2d,y0d);
           end if;
           annotation(smoothOrder=2);
        end regSquare2_utility;
      algorithm
        y := smooth(2,if x >= x_small then k1*x^2 else
                      if x <= -x_small then -k2*x^2 else
                      if k1 >= k2 then regSquare2_utility(x,x_small,k1,k2,use_yd0,yd0) else
                                      -regSquare2_utility(-x,x_small,k2,k1,use_yd0,yd0));
        annotation(smoothOrder=2, Documentation(info="<html>
<p>
Approximates the function
</p>
<pre>
   y = <b>if</b> x &ge; 0 <b>then</b> k1*x*x <b>else</b> -k2*x*x, with k1, k2 > 0
</pre>
<p>
in such a way that within the region -x_small &le; x &le; x_small,
the function is described by two polynomials of third order
(one in the region -x_small .. 0 and one within the region 0 .. x_small)
such that
</p>

<ul>
<li> The derivative at x=0 is non-zero (in order that the
     inverse of the function does not have an infinite derivative). </li>
<li> The overall function is continuous with a
     continuous first derivative everywhere.</li>
<li> If parameter use_yd0 = <b>false</b>, the two polynomials
     are constructed such that the second derivatives at x=0
     are identical. If use_yd0 = <b>true</b>, the derivative
     at x=0 is explicitly provided via the additional argument
     yd0. If necessary, the derivative yd0 is automatically
     reduced in order that the polynomials are strict monotonically
     increasing <i>[Fritsch and Carlson, 1980]</i>.</li>
</ul>

<p>
A typical screenshot for k1=1, k2=3 is shown in the next figure:
</p>
<p>
<img src=\"modelica://Modelica/Resources/Images/Fluid/Components/regSquare2_b.png\"
     alt=\"regSquare2_b.png\">
</p>

<p>
The (smooth, non-zero) derivative of the function with
k1=1, k2=3 is shown in the next figure:
</p>

<p>
<img src=\"modelica://Modelica/Resources/Images/Fluid/Components/regSquare2_c.png\"
     alt=\"regSquare2_b.png\">
</p>

<p>
<b>Literature</b>
</p>

<dl>
<dt> Fritsch F.N. and Carlson R.E. (1980):</dt>
<dd> <b>Monotone piecewise cubic interpolation</b>.
     SIAM J. Numerc. Anal., Vol. 17, No. 2, April 1980, pp. 238-246</dd>
</dl>
</html>",     revisions="<html>
<ul>
<li><i>Nov., 2005</i>
    by <a href=\"mailto:Martin.Otter@DLR.de\">Martin Otter</a>:<br>
    Designed and implemented.</li>
</ul>
</html>"));
      end regSquare2;

      function regStep
      "Approximation of a general step, such that the characteristic is continuous and differentiable"
        extends Modelica.Icons.Function;
        input Real x "Abscissa value";
        input Real y1 "Ordinate value for x > 0";
        input Real y2 "Ordinate value for x < 0";
        input Real x_small(min=0) = 1e-5
        "Approximation of step for -x_small <= x <= x_small; x_small >= 0 required";
        output Real y
        "Ordinate value to approximate y = if x > 0 then y1 else y2";
      algorithm
        y := smooth(1, if x >  x_small then y1 else
                       if x < -x_small then y2 else
                       if x_small > 0 then (x/x_small)*((x/x_small)^2 - 3)*(y2-y1)/4 + (y1+y2)/2 else (y1+y2)/2);
        annotation(Documentation(revisions="<html>
<ul>
<li><i>April 29, 2008</i>
    by <a href=\"mailto:Martin.Otter@DLR.de\">Martin Otter</a>:<br>
    Designed and implemented.</li>
<li><i>August 12, 2008</i>
    by <a href=\"mailto:Michael.Sielemann@dlr.de\">Michael Sielemann</a>:<br>
    Minor modification to cover the limit case <code>x_small -> 0</code> without division by zero.</li>
</ul>
</html>",       info="<html>
<p>
This function is used to approximate the equation
</p>
<pre>
    y = <b>if</b> x &gt; 0 <b>then</b> y1 <b>else</b> y2;
</pre>

<p>
by a smooth characteristic, so that the expression is continuous and differentiable:
</p>

<pre>
   y = <b>smooth</b>(1, <b>if</b> x &gt;  x_small <b>then</b> y1 <b>else</b>
                 <b>if</b> x &lt; -x_small <b>then</b> y2 <b>else</b> f(y1, y2));
</pre>

<p>
In the region -x_small &lt; x &lt; x_small a 2nd order polynomial is used
for a smooth transition from y1 to y2.
</p>
</html>"));
      end regStep;

      function evaluatePoly3_derivativeAtZero
      "Evaluate polynomial of order 3 that passes the origin with a predefined derivative"
        extends Modelica.Icons.Function;
        input Real x "Value for which polynomial shall be evaluated";
        input Real x1 "Abscissa value";
        input Real y1 "y1=f(x1)";
        input Real y1d "First derivative at y1";
        input Real y0d "First derivative at f(x=0)";
        output Real y;
    protected
        Real a1;
        Real a2;
        Real a3;
        Real xx;
      algorithm
        a1 := x1*y0d;
        a2 := 3*y1 - x1*y1d - 2*a1;
        a3 := y1 - a2 - a1;
        xx := x/x1;
        y  := xx*(a1 + xx*(a2 + xx*a3));
        annotation(smoothOrder=3, Documentation(info="<html>

</html>"));
      end evaluatePoly3_derivativeAtZero;

      function cubicHermite "Evaluate a cubic Hermite spline"
        extends Modelica.Icons.Function;

        input Real x "Abscissa value";
        input Real x1 "Lower abscissa value";
        input Real x2 "Upper abscissa value";
        input Real y1 "Lower ordinate value";
        input Real y2 "Upper ordinate value";
        input Real y1d "Lower gradient";
        input Real y2d "Upper gradient";
        output Real y "Interpolated ordinate value";
    protected
        Real h "Distance between x1 and x2";
        Real t "abscissa scaled with h, i.e., t=[0..1] within x=[x1..x2]";
        Real h00 "Basis function 00 of cubic Hermite spline";
        Real h10 "Basis function 10 of cubic Hermite spline";
        Real h01 "Basis function 01 of cubic Hermite spline";
        Real h11 "Basis function 11 of cubic Hermite spline";
        Real aux3 "t cube";
        Real aux2 "t square";
      algorithm
        h := x2 - x1;
        if abs(h)>0 then
          // Regular case
          t := (x - x1)/h;

          aux3 :=t^3;
          aux2 :=t^2;

          h00 := 2*aux3 - 3*aux2 + 1;
          h10 := aux3 - 2*aux2 + t;
          h01 := -2*aux3 + 3*aux2;
          h11 := aux3 - aux2;
          y := y1*h00 + h*y1d*h10 + y2*h01 + h*y2d*h11;
        else
          // Degenerate case, x1 and x2 are identical, return step function
          y := (y1 + y2)/2;
        end if;
        annotation(smoothOrder=3, Documentation(revisions="<html>
<ul>
<li><i>May 2008</i>
    by <a href=\"mailto:Michael.Sielemann@dlr.de\">Michael Sielemann</a>:<br>
    Designed and implemented.</li>
</ul>
</html>"));
      end cubicHermite;
      annotation (Documentation(info="<html>

</html>"));
    end Utilities;
  annotation (Icon(graphics={
          Polygon(points={{-70,26},{68,-44},{68,26},{2,-10},{-70,-42},{-70,26}},
              lineColor={0,0,0}),
          Line(points={{2,42},{2,-10}}, color={0,0,0}),
          Rectangle(
            extent={{-18,50},{22,42}},
            lineColor={0,0,0},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid)}), preferredView="info",
    Documentation(info="<html>
<p>
Library <b>Modelica.Fluid</b> is a <b>free</b> Modelica package providing components for
<b>1-dimensional thermo-fluid flow</b> in networks of vessels, pipes, fluid machines, valves and fittings.
A unique feature is that the component equations and the media models
as well as pressure loss and heat transfer correlations are decoupled from each other.
All components are implemented such that they can be used for
media from the Modelica.Media library. This means especially that an
incompressible or compressible medium, a single or a multiple
substance medium with one or more phases might be used.
</p>

<p>
In the next figure, several features of the library are demonstrated with
a simple heating system with a closed flow cycle. By just changing one configuration parameter in the system object the equations are changed between steady-state and dynamic simulation with fixed or steady-state initial conditions.
</p>

<p>
<img src=\"modelica://Modelica/Resources/Images/Fluid/UsersGuide/HeatingSystem.png\" border=\"1\"
     alt=\"HeatingSystem.png\">
</p>

<p>
With respect to previous versions, the design
of the connectors has been changed in a non-backward compatible way,
using the recently developed concept
of stream connectors that results in much more reliable simulations
(see also <a href=\"modelica://Modelica/Resources/Documentation/Fluid/Stream-Connectors-Overview-Rationale.pdf\">Stream-Connectors-Overview-Rationale.pdf</a>).
This extension was included in Modelica 3.1.
As of Jan. 2009, the stream concept is supported in Dymola 7.1.
It is recommended to use Dymola 7.2 (available since Feb. 2009), or a later Dymola version,
since this version supports a new annotation to connect very
conveniently to vectors of connectors.
Other tool vendors will support the stream concept as well.
</p>

<p>
The following parts are useful, when newly starting with this library:
</p>
<ul>
<li> <a href=\"modelica://Modelica.Fluid.UsersGuide\">Modelica.Fluid.UsersGuide</a>.</li>
<li> <a href=\"modelica://Modelica.Fluid.UsersGuide.ReleaseNotes\">Modelica.Fluid.UsersGuide.ReleaseNotes</a>
     summarizes the changes of the library releases.</li>
<li> <a href=\"modelica://Modelica.Fluid.Examples\">Modelica.Fluid.Examples</a>
     contains examples that demonstrate the usage of this library.</li>
</ul>
<p>
<b>Licensed by the Modelica Association under the Modelica License 2</b><br>
Copyright &copy; 2002-2013, ABB, DLR, Dassault Syst&egrave;mes AB, Modelon, TU Braunschweig, TU Hamburg-Harburg, Politecnico di Milano.
</p>
<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"https://www.modelica.org/licenses/ModelicaLicense2\"> https://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>
</html>"));
  end Fluid;

  package Media "Library of media property models"
  extends Modelica.Icons.Package;
  import SI = Modelica.SIunits;
  import Cv = Modelica.SIunits.Conversions;

  package Interfaces "Interfaces for media models"
    extends Modelica.Icons.InterfacesPackage;

    partial package PartialMedium
    "Partial medium properties (base package of all media packages)"
      extends Modelica.Media.Interfaces.Types;
      extends Modelica.Icons.MaterialPropertiesPackage;

      // Constants to be set in Medium
      constant Modelica.Media.Interfaces.Choices.IndependentVariables
        ThermoStates "Enumeration type for independent variables";
      constant String mediumName="unusablePartialMedium" "Name of the medium";
      constant String substanceNames[:]={mediumName}
      "Names of the mixture substances. Set substanceNames={mediumName} if only one substance.";
      constant String extraPropertiesNames[:]=fill("", 0)
      "Names of the additional (extra) transported properties. Set extraPropertiesNames=fill(\"\",0) if unused";
      constant Boolean singleState
      "= true, if u and d are not a function of pressure";
      constant Boolean reducedX=true
      "= true if medium contains the equation sum(X) = 1.0; set reducedX=true if only one substance (see docu for details)";
      constant Boolean fixedX=false
      "= true if medium contains the equation X = reference_X";
      constant AbsolutePressure reference_p=101325
      "Reference pressure of Medium: default 1 atmosphere";
      constant Temperature reference_T=298.15
      "Reference temperature of Medium: default 25 deg Celsius";
      constant MassFraction reference_X[nX]=fill(1/nX, nX)
      "Default mass fractions of medium";
      constant AbsolutePressure p_default=101325
      "Default value for pressure of medium (for initialization)";
      constant Temperature T_default=Modelica.SIunits.Conversions.from_degC(20)
      "Default value for temperature of medium (for initialization)";
      constant SpecificEnthalpy h_default=specificEnthalpy_pTX(
              p_default,
              T_default,
              X_default)
      "Default value for specific enthalpy of medium (for initialization)";
      constant MassFraction X_default[nX]=reference_X
      "Default value for mass fractions of medium (for initialization)";

      final constant Integer nS=size(substanceNames, 1) "Number of substances"
        annotation (Evaluate=true);
      constant Integer nX=nS "Number of mass fractions" annotation (Evaluate=true);
      constant Integer nXi=if fixedX then 0 else if reducedX then nS - 1 else nS
      "Number of structurally independent mass fractions (see docu for details)"
        annotation (Evaluate=true);

      final constant Integer nC=size(extraPropertiesNames, 1)
      "Number of extra (outside of standard mass-balance) transported properties"
        annotation (Evaluate=true);
      constant Real C_nominal[nC](min=fill(Modelica.Constants.eps, nC)) = 1.0e-6*
        ones(nC) "Default for the nominal values for the extra properties";
      replaceable record FluidConstants =
          Modelica.Media.Interfaces.Types.Basic.FluidConstants
      "Critical, triple, molecular and other standard data of fluid";

      replaceable record ThermodynamicState
      "Minimal variable set that is available as input argument to every medium function"
        extends Modelica.Icons.Record;
      end ThermodynamicState;

      replaceable partial model BaseProperties
      "Base properties (p, d, T, h, u, R, MM and, if applicable, X and Xi) of a medium"
        InputAbsolutePressure p "Absolute pressure of medium";
        InputMassFraction[nXi] Xi(start=reference_X[1:nXi])
        "Structurally independent mass fractions";
        InputSpecificEnthalpy h "Specific enthalpy of medium";
        Density d "Density of medium";
        Temperature T "Temperature of medium";
        MassFraction[nX] X(start=reference_X)
        "Mass fractions (= (component mass)/total mass  m_i/m)";
        SpecificInternalEnergy u "Specific internal energy of medium";
        SpecificHeatCapacity R "Gas constant (of mixture if applicable)";
        MolarMass MM "Molar mass (of mixture or single fluid)";
        ThermodynamicState state
        "Thermodynamic state record for optional functions";
        parameter Boolean preferredMediumStates=false
        "= true if StateSelect.prefer shall be used for the independent property variables of the medium"
          annotation (Evaluate=true, Dialog(tab="Advanced"));
        parameter Boolean standardOrderComponents=true
        "If true, and reducedX = true, the last element of X will be computed from the other ones";
        SI.Conversions.NonSIunits.Temperature_degC T_degC=
            Modelica.SIunits.Conversions.to_degC(T)
        "Temperature of medium in [degC]";
        SI.Conversions.NonSIunits.Pressure_bar p_bar=
            Modelica.SIunits.Conversions.to_bar(p)
        "Absolute pressure of medium in [bar]";

        // Local connector definition, used for equation balancing check
        connector InputAbsolutePressure = input SI.AbsolutePressure
        "Pressure as input signal connector";
        connector InputSpecificEnthalpy = input SI.SpecificEnthalpy
        "Specific enthalpy as input signal connector";
        connector InputMassFraction = input SI.MassFraction
        "Mass fraction as input signal connector";

      equation
        if standardOrderComponents then
          Xi = X[1:nXi];

          if fixedX then
            X = reference_X;
          end if;
          if reducedX and not fixedX then
            X[nX] = 1 - sum(Xi);
          end if;
          for i in 1:nX loop
            assert(X[i] >= -1.e-5 and X[i] <= 1 + 1.e-5, "Mass fraction X[" +
              String(i) + "] = " + String(X[i]) + "of substance " +
              substanceNames[i] + "\nof medium " + mediumName +
              " is not in the range 0..1");
          end for;

        end if;

        assert(p >= 0.0, "Pressure (= " + String(p) + " Pa) of medium \"" +
          mediumName + "\" is negative\n(Temperature = " + String(T) + " K)");
        annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                  -100},{100,100}}), graphics={Rectangle(
                extent={{-100,100},{100,-100}},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid,
                lineColor={0,0,255}), Text(
                extent={{-152,164},{152,102}},
                textString="%name",
                lineColor={0,0,255})}), Documentation(info="<html>
<p>
Model <b>BaseProperties</b> is a model within package <b>PartialMedium</b>
and contains the <b>declarations</b> of the minimum number of
variables that every medium model is supposed to support.
A specific medium inherits from model <b>BaseProperties</b> and provides
the equations for the basic properties.</p>
<p>
The BaseProperties model contains the following <b>7+nXi variables</b>
(nXi is the number of independent mass fractions defined in package
PartialMedium):
</p>
<table border=1 cellspacing=0 cellpadding=2>
  <tr><td valign=\"top\"><b>Variable</b></td>
      <td valign=\"top\"><b>Unit</b></td>
      <td valign=\"top\"><b>Description</b></td></tr>
  <tr><td valign=\"top\">T</td>
      <td valign=\"top\">K</td>
      <td valign=\"top\">temperature</td></tr>
  <tr><td valign=\"top\">p</td>
      <td valign=\"top\">Pa</td>
      <td valign=\"top\">absolute pressure</td></tr>
  <tr><td valign=\"top\">d</td>
      <td valign=\"top\">kg/m3</td>
      <td valign=\"top\">density</td></tr>
  <tr><td valign=\"top\">h</td>
      <td valign=\"top\">J/kg</td>
      <td valign=\"top\">specific enthalpy</td></tr>
  <tr><td valign=\"top\">u</td>
      <td valign=\"top\">J/kg</td>
      <td valign=\"top\">specific internal energy</td></tr>
  <tr><td valign=\"top\">Xi[nXi]</td>
      <td valign=\"top\">kg/kg</td>
      <td valign=\"top\">independent mass fractions m_i/m</td></tr>
  <tr><td valign=\"top\">R</td>
      <td valign=\"top\">J/kg.K</td>
      <td valign=\"top\">gas constant</td></tr>
  <tr><td valign=\"top\">M</td>
      <td valign=\"top\">kg/mol</td>
      <td valign=\"top\">molar mass</td></tr>
</table>
<p>
In order to implement an actual medium model, one can extend from this
base model and add <b>5 equations</b> that provide relations among
these variables. Equations will also have to be added in order to
set all the variables within the ThermodynamicState record state.</p>
<p>
If standardOrderComponents=true, the full composition vector X[nX]
is determined by the equations contained in this base class, depending
on the independent mass fraction vector Xi[nXi].</p>
<p>Additional <b>2 + nXi</b> equations will have to be provided
when using the BaseProperties model, in order to fully specify the
thermodynamic conditions. The input connector qualifier applied to
p, h, and nXi indirectly declares the number of missing equations,
permitting advanced equation balance checking by Modelica tools.
Please note that this doesn't mean that the additional equations
should be connection equations, nor that exactly those variables
should be supplied, in order to complete the model.
For further information, see the Modelica.Media User's guide, and
Section 4.7 (Balanced Models) of the Modelica 3.0 specification.</p>
</html>"));
      end BaseProperties;

      replaceable partial function setState_pTX
      "Return thermodynamic state as function of p, T and composition X or Xi"
        extends Modelica.Icons.Function;
        input AbsolutePressure p "Pressure";
        input Temperature T "Temperature";
        input MassFraction X[:]=reference_X "Mass fractions";
        output ThermodynamicState state "Thermodynamic state record";
      end setState_pTX;

      replaceable partial function setState_phX
      "Return thermodynamic state as function of p, h and composition X or Xi"
        extends Modelica.Icons.Function;
        input AbsolutePressure p "Pressure";
        input SpecificEnthalpy h "Specific enthalpy";
        input MassFraction X[:]=reference_X "Mass fractions";
        output ThermodynamicState state "Thermodynamic state record";
      end setState_phX;

      replaceable partial function setState_psX
      "Return thermodynamic state as function of p, s and composition X or Xi"
        extends Modelica.Icons.Function;
        input AbsolutePressure p "Pressure";
        input SpecificEntropy s "Specific entropy";
        input MassFraction X[:]=reference_X "Mass fractions";
        output ThermodynamicState state "Thermodynamic state record";
      end setState_psX;

      replaceable partial function setState_dTX
      "Return thermodynamic state as function of d, T and composition X or Xi"
        extends Modelica.Icons.Function;
        input Density d "Density";
        input Temperature T "Temperature";
        input MassFraction X[:]=reference_X "Mass fractions";
        output ThermodynamicState state "Thermodynamic state record";
      end setState_dTX;

      replaceable partial function setSmoothState
      "Return thermodynamic state so that it smoothly approximates: if x > 0 then state_a else state_b"
        extends Modelica.Icons.Function;
        input Real x "m_flow or dp";
        input ThermodynamicState state_a "Thermodynamic state if x > 0";
        input ThermodynamicState state_b "Thermodynamic state if x < 0";
        input Real x_small(min=0)
        "Smooth transition in the region -x_small < x < x_small";
        output ThermodynamicState state
        "Smooth thermodynamic state for all x (continuous and differentiable)";
        annotation (Documentation(info="<html>
<p>
This function is used to approximate the equation
</p>
<pre>
    state = <b>if</b> x &gt; 0 <b>then</b> state_a <b>else</b> state_b;
</pre>

<p>
by a smooth characteristic, so that the expression is continuous and differentiable:
</p>

<pre>
   state := <b>smooth</b>(1, <b>if</b> x &gt;  x_small <b>then</b> state_a <b>else</b>
                      <b>if</b> x &lt; -x_small <b>then</b> state_b <b>else</b> f(state_a, state_b));
</pre>

<p>
This is performed by applying function <b>Media.Common.smoothStep</b>(..)
on every element of the thermodynamic state record.
</p>

<p>
If <b>mass fractions</b> X[:] are approximated with this function then this can be performed
for all <b>nX</b> mass fractions, instead of applying it for nX-1 mass fractions and computing
the last one by the mass fraction constraint sum(X)=1. The reason is that the approximating function has the
property that sum(state.X) = 1, provided sum(state_a.X) = sum(state_b.X) = 1.
This can be shown by evaluating the approximating function in the abs(x) &lt; x_small
region (otherwise state.X is either state_a.X or state_b.X):
</p>

<pre>
    X[1]  = smoothStep(x, X_a[1] , X_b[1] , x_small);
    X[2]  = smoothStep(x, X_a[2] , X_b[2] , x_small);
       ...
    X[nX] = smoothStep(x, X_a[nX], X_b[nX], x_small);
</pre>

<p>
or
</p>

<pre>
    X[1]  = c*(X_a[1]  - X_b[1])  + (X_a[1]  + X_b[1])/2
    X[2]  = c*(X_a[2]  - X_b[2])  + (X_a[2]  + X_b[2])/2;
       ...
    X[nX] = c*(X_a[nX] - X_b[nX]) + (X_a[nX] + X_b[nX])/2;
    c     = (x/x_small)*((x/x_small)^2 - 3)/4
</pre>

<p>
Summing all mass fractions together results in
</p>

<pre>
    sum(X) = c*(sum(X_a) - sum(X_b)) + (sum(X_a) + sum(X_b))/2
           = c*(1 - 1) + (1 + 1)/2
           = 1
</pre>

</html>"));
      end setSmoothState;

      replaceable partial function dynamicViscosity "Return dynamic viscosity"
        extends Modelica.Icons.Function;
        input ThermodynamicState state "Thermodynamic state record";
        output DynamicViscosity eta "Dynamic viscosity";
      end dynamicViscosity;

      replaceable partial function thermalConductivity
      "Return thermal conductivity"
        extends Modelica.Icons.Function;
        input ThermodynamicState state "Thermodynamic state record";
        output ThermalConductivity lambda "Thermal conductivity";
      end thermalConductivity;

      replaceable function prandtlNumber "Return the Prandtl number"
        extends Modelica.Icons.Function;
        input ThermodynamicState state "Thermodynamic state record";
        output PrandtlNumber Pr "Prandtl number";
      algorithm
        Pr := dynamicViscosity(state)*specificHeatCapacityCp(state)/
          thermalConductivity(state);
      end prandtlNumber;

      replaceable partial function pressure "Return pressure"
        extends Modelica.Icons.Function;
        input ThermodynamicState state "Thermodynamic state record";
        output AbsolutePressure p "Pressure";
      end pressure;

      replaceable partial function temperature "Return temperature"
        extends Modelica.Icons.Function;
        input ThermodynamicState state "Thermodynamic state record";
        output Temperature T "Temperature";
      end temperature;

      replaceable partial function density "Return density"
        extends Modelica.Icons.Function;
        input ThermodynamicState state "Thermodynamic state record";
        output Density d "Density";
      end density;

      replaceable partial function specificEnthalpy "Return specific enthalpy"
        extends Modelica.Icons.Function;
        input ThermodynamicState state "Thermodynamic state record";
        output SpecificEnthalpy h "Specific enthalpy";
      end specificEnthalpy;

      replaceable partial function specificInternalEnergy
      "Return specific internal energy"
        extends Modelica.Icons.Function;
        input ThermodynamicState state "Thermodynamic state record";
        output SpecificEnergy u "Specific internal energy";
      end specificInternalEnergy;

      replaceable partial function specificEntropy "Return specific entropy"
        extends Modelica.Icons.Function;
        input ThermodynamicState state "Thermodynamic state record";
        output SpecificEntropy s "Specific entropy";
      end specificEntropy;

      replaceable partial function specificGibbsEnergy
      "Return specific Gibbs energy"
        extends Modelica.Icons.Function;
        input ThermodynamicState state "Thermodynamic state record";
        output SpecificEnergy g "Specific Gibbs energy";
      end specificGibbsEnergy;

      replaceable partial function specificHelmholtzEnergy
      "Return specific Helmholtz energy"
        extends Modelica.Icons.Function;
        input ThermodynamicState state "Thermodynamic state record";
        output SpecificEnergy f "Specific Helmholtz energy";
      end specificHelmholtzEnergy;

      replaceable partial function specificHeatCapacityCp
      "Return specific heat capacity at constant pressure"
        extends Modelica.Icons.Function;
        input ThermodynamicState state "Thermodynamic state record";
        output SpecificHeatCapacity cp
        "Specific heat capacity at constant pressure";
      end specificHeatCapacityCp;

      function heatCapacity_cp = specificHeatCapacityCp
      "Alias for deprecated name";

      replaceable partial function specificHeatCapacityCv
      "Return specific heat capacity at constant volume"
        extends Modelica.Icons.Function;
        input ThermodynamicState state "Thermodynamic state record";
        output SpecificHeatCapacity cv
        "Specific heat capacity at constant volume";
      end specificHeatCapacityCv;

      function heatCapacity_cv = specificHeatCapacityCv
      "Alias for deprecated name";

      replaceable partial function isentropicExponent
      "Return isentropic exponent"
        extends Modelica.Icons.Function;
        input ThermodynamicState state "Thermodynamic state record";
        output IsentropicExponent gamma "Isentropic exponent";
      end isentropicExponent;

      replaceable partial function isentropicEnthalpy
      "Return isentropic enthalpy"
        extends Modelica.Icons.Function;
        input AbsolutePressure p_downstream "Downstream pressure";
        input ThermodynamicState refState "Reference state for entropy";
        output SpecificEnthalpy h_is "Isentropic enthalpy";
        annotation (Documentation(info="<html>
<p>
This function computes an isentropic state transformation:
</p>
<ol>
<li> A medium is in a particular state, refState.</li>
<li> The enthalpy at another state (h_is) shall be computed
     under the assumption that the state transformation from refState to h_is
     is performed with a change of specific entropy ds = 0 and the pressure of state h_is
     is p_downstream and the composition X upstream and downstream is assumed to be the same.</li>
</ol>

</html>"));
      end isentropicEnthalpy;

      replaceable partial function velocityOfSound "Return velocity of sound"
        extends Modelica.Icons.Function;
        input ThermodynamicState state "Thermodynamic state record";
        output VelocityOfSound a "Velocity of sound";
      end velocityOfSound;

      replaceable partial function isobaricExpansionCoefficient
      "Return overall the isobaric expansion coefficient beta"
        extends Modelica.Icons.Function;
        input ThermodynamicState state "Thermodynamic state record";
        output IsobaricExpansionCoefficient beta
        "Isobaric expansion coefficient";
        annotation (Documentation(info="<html>
<pre>
beta is defined as  1/v * der(v,T), with v = 1/d, at constant pressure p.
</pre>
</html>"));
      end isobaricExpansionCoefficient;

      function beta = isobaricExpansionCoefficient
      "Alias for isobaricExpansionCoefficient for user convenience";

      replaceable partial function isothermalCompressibility
      "Return overall the isothermal compressibility factor"
        extends Modelica.Icons.Function;
        input ThermodynamicState state "Thermodynamic state record";
        output SI.IsothermalCompressibility kappa "Isothermal compressibility";
        annotation (Documentation(info="<html>
<pre>

kappa is defined as - 1/v * der(v,p), with v = 1/d at constant temperature T.

</pre>
</html>"));
      end isothermalCompressibility;

      function kappa = isothermalCompressibility
      "Alias of isothermalCompressibility for user convenience";

      // explicit derivative functions for finite element models
      replaceable partial function density_derp_h
      "Return density derivative w.r.t. pressure at const specific enthalpy"
        extends Modelica.Icons.Function;
        input ThermodynamicState state "Thermodynamic state record";
        output DerDensityByPressure ddph "Density derivative w.r.t. pressure";
      end density_derp_h;

      replaceable partial function density_derh_p
      "Return density derivative w.r.t. specific enthalpy at constant pressure"
        extends Modelica.Icons.Function;
        input ThermodynamicState state "Thermodynamic state record";
        output DerDensityByEnthalpy ddhp
        "Density derivative w.r.t. specific enthalpy";
      end density_derh_p;

      replaceable partial function density_derp_T
      "Return density derivative w.r.t. pressure at const temperature"
        extends Modelica.Icons.Function;
        input ThermodynamicState state "Thermodynamic state record";
        output DerDensityByPressure ddpT "Density derivative w.r.t. pressure";
      end density_derp_T;

      replaceable partial function density_derT_p
      "Return density derivative w.r.t. temperature at constant pressure"
        extends Modelica.Icons.Function;
        input ThermodynamicState state "Thermodynamic state record";
        output DerDensityByTemperature ddTp
        "Density derivative w.r.t. temperature";
      end density_derT_p;

      replaceable partial function density_derX
      "Return density derivative w.r.t. mass fraction"
        extends Modelica.Icons.Function;
        input ThermodynamicState state "Thermodynamic state record";
        output Density[nX] dddX "Derivative of density w.r.t. mass fraction";
      end density_derX;

      replaceable partial function molarMass
      "Return the molar mass of the medium"
        extends Modelica.Icons.Function;
        input ThermodynamicState state "Thermodynamic state record";
        output MolarMass MM "Mixture molar mass";
      end molarMass;

      replaceable function specificEnthalpy_pTX
      "Return specific enthalpy from p, T, and X or Xi"
        extends Modelica.Icons.Function;
        input AbsolutePressure p "Pressure";
        input Temperature T "Temperature";
        input MassFraction X[:]=reference_X "Mass fractions";
        output SpecificEnthalpy h "Specific enthalpy";
      algorithm
        h := specificEnthalpy(setState_pTX(
                p,
                T,
                X));
        annotation (inverse(T=temperature_phX(
                      p,
                      h,
                      X)));
      end specificEnthalpy_pTX;

      replaceable function specificEntropy_pTX
      "Return specific enthalpy from p, T, and X or Xi"
        extends Modelica.Icons.Function;
        input AbsolutePressure p "Pressure";
        input Temperature T "Temperature";
        input MassFraction X[:]=reference_X "Mass fractions";
        output SpecificEntropy s "Specific entropy";
      algorithm
        s := specificEntropy(setState_pTX(
                p,
                T,
                X));

        annotation (inverse(T=temperature_psX(
                      p,
                      s,
                      X)));
      end specificEntropy_pTX;

      replaceable function density_pTX "Return density from p, T, and X or Xi"
        extends Modelica.Icons.Function;
        input AbsolutePressure p "Pressure";
        input Temperature T "Temperature";
        input MassFraction X[:] "Mass fractions";
        output Density d "Density";
      algorithm
        d := density(setState_pTX(
                p,
                T,
                X));
      end density_pTX;

      replaceable function temperature_phX
      "Return temperature from p, h, and X or Xi"
        extends Modelica.Icons.Function;
        input AbsolutePressure p "Pressure";
        input SpecificEnthalpy h "Specific enthalpy";
        input MassFraction X[:]=reference_X "Mass fractions";
        output Temperature T "Temperature";
      algorithm
        T := temperature(setState_phX(
                p,
                h,
                X));
      end temperature_phX;

      replaceable function density_phX "Return density from p, h, and X or Xi"
        extends Modelica.Icons.Function;
        input AbsolutePressure p "Pressure";
        input SpecificEnthalpy h "Specific enthalpy";
        input MassFraction X[:]=reference_X "Mass fractions";
        output Density d "Density";
      algorithm
        d := density(setState_phX(
                p,
                h,
                X));
      end density_phX;

      replaceable function temperature_psX
      "Return temperature from p,s, and X or Xi"
        extends Modelica.Icons.Function;
        input AbsolutePressure p "Pressure";
        input SpecificEntropy s "Specific entropy";
        input MassFraction X[:]=reference_X "Mass fractions";
        output Temperature T "Temperature";
      algorithm
        T := temperature(setState_psX(
                p,
                s,
                X));
        annotation (inverse(s=specificEntropy_pTX(
                      p,
                      T,
                      X)));
      end temperature_psX;

      replaceable function density_psX "Return density from p, s, and X or Xi"
        extends Modelica.Icons.Function;
        input AbsolutePressure p "Pressure";
        input SpecificEntropy s "Specific entropy";
        input MassFraction X[:]=reference_X "Mass fractions";
        output Density d "Density";
      algorithm
        d := density(setState_psX(
                p,
                s,
                X));
      end density_psX;

      replaceable function specificEnthalpy_psX
      "Return specific enthalpy from p, s, and X or Xi"
        extends Modelica.Icons.Function;
        input AbsolutePressure p "Pressure";
        input SpecificEntropy s "Specific entropy";
        input MassFraction X[:]=reference_X "Mass fractions";
        output SpecificEnthalpy h "Specific enthalpy";
      algorithm
        h := specificEnthalpy(setState_psX(
                p,
                s,
                X));
      end specificEnthalpy_psX;

      type MassFlowRate = SI.MassFlowRate (
          quantity="MassFlowRate." + mediumName,
          min=-1.0e5,
          max=1.e5) "Type for mass flow rate with medium specific attributes";

      // Only for backwards compatibility to version 3.2 (
      // (do not use these definitions in new models, but use Modelica.Media.Interfaces.Choices instead)
      package Choices = Modelica.Media.Interfaces.Choices annotation (obsolete=
            "Use Modelica.Media.Interfaces.Choices");

      annotation (Documentation(info="<html>
<p>
<b>PartialMedium</b> is a package and contains all <b>declarations</b> for
a medium. This means that constants, models, and functions
are defined that every medium is supposed to support
(some of them are optional). A medium package
inherits from <b>PartialMedium</b> and provides the
equations for the medium. The details of this package
are described in
<a href=\"modelica://Modelica.Media.UsersGuide\">Modelica.Media.UsersGuide</a>.
</p>
</html>",   revisions="<html>

</html>"));
    end PartialMedium;

    partial package PartialPureSubstance
    "Base class for pure substances of one chemical substance"
      extends PartialMedium(final reducedX=true, final fixedX=true);

      replaceable function setState_pT
      "Return thermodynamic state from p and T"
        extends Modelica.Icons.Function;
        input AbsolutePressure p "Pressure";
        input Temperature T "Temperature";
        output ThermodynamicState state "Thermodynamic state record";
      algorithm
        state := setState_pTX(
                p,
                T,
                fill(0, 0));
      end setState_pT;

      replaceable function setState_ph
      "Return thermodynamic state from p and h"
        extends Modelica.Icons.Function;
        input AbsolutePressure p "Pressure";
        input SpecificEnthalpy h "Specific enthalpy";
        output ThermodynamicState state "Thermodynamic state record";
      algorithm
        state := setState_phX(
                p,
                h,
                fill(0, 0));
      end setState_ph;

      replaceable function setState_ps
      "Return thermodynamic state from p and s"
        extends Modelica.Icons.Function;
        input AbsolutePressure p "Pressure";
        input SpecificEntropy s "Specific entropy";
        output ThermodynamicState state "Thermodynamic state record";
      algorithm
        state := setState_psX(
                p,
                s,
                fill(0, 0));
      end setState_ps;

      replaceable function setState_dT
      "Return thermodynamic state from d and T"
        extends Modelica.Icons.Function;
        input Density d "Density";
        input Temperature T "Temperature";
        output ThermodynamicState state "Thermodynamic state record";
      algorithm
        state := setState_dTX(
                d,
                T,
                fill(0, 0));
      end setState_dT;

      replaceable function density_ph "Return density from p and h"
        extends Modelica.Icons.Function;
        input AbsolutePressure p "Pressure";
        input SpecificEnthalpy h "Specific enthalpy";
        output Density d "Density";
      algorithm
        d := density_phX(
                p,
                h,
                fill(0, 0));
      end density_ph;

      replaceable function temperature_ph "Return temperature from p and h"
        extends Modelica.Icons.Function;
        input AbsolutePressure p "Pressure";
        input SpecificEnthalpy h "Specific enthalpy";
        output Temperature T "Temperature";
      algorithm
        T := temperature_phX(
                p,
                h,
                fill(0, 0));
      end temperature_ph;

      replaceable function pressure_dT "Return pressure from d and T"
        extends Modelica.Icons.Function;
        input Density d "Density";
        input Temperature T "Temperature";
        output AbsolutePressure p "Pressure";
      algorithm
        p := pressure(setState_dTX(
                d,
                T,
                fill(0, 0)));
      end pressure_dT;

      replaceable function specificEnthalpy_dT
      "Return specific enthalpy from d and T"
        extends Modelica.Icons.Function;
        input Density d "Density";
        input Temperature T "Temperature";
        output SpecificEnthalpy h "Specific enthalpy";
      algorithm
        h := specificEnthalpy(setState_dTX(
                d,
                T,
                fill(0, 0)));
      end specificEnthalpy_dT;

      replaceable function specificEnthalpy_ps
      "Return specific enthalpy from p and s"
        extends Modelica.Icons.Function;
        input AbsolutePressure p "Pressure";
        input SpecificEntropy s "Specific entropy";
        output SpecificEnthalpy h "Specific enthalpy";
      algorithm
        h := specificEnthalpy_psX(
                p,
                s,
                fill(0, 0));
      end specificEnthalpy_ps;

      replaceable function temperature_ps "Return temperature from p and s"
        extends Modelica.Icons.Function;
        input AbsolutePressure p "Pressure";
        input SpecificEntropy s "Specific entropy";
        output Temperature T "Temperature";
      algorithm
        T := temperature_psX(
                p,
                s,
                fill(0, 0));
      end temperature_ps;

      replaceable function density_ps "Return density from p and s"
        extends Modelica.Icons.Function;
        input AbsolutePressure p "Pressure";
        input SpecificEntropy s "Specific entropy";
        output Density d "Density";
      algorithm
        d := density_psX(
                p,
                s,
                fill(0, 0));
      end density_ps;

      replaceable function specificEnthalpy_pT
      "Return specific enthalpy from p and T"
        extends Modelica.Icons.Function;
        input AbsolutePressure p "Pressure";
        input Temperature T "Temperature";
        output SpecificEnthalpy h "Specific enthalpy";
      algorithm
        h := specificEnthalpy_pTX(
                p,
                T,
                fill(0, 0));
      end specificEnthalpy_pT;

      replaceable function density_pT "Return density from p and T"
        extends Modelica.Icons.Function;
        input AbsolutePressure p "Pressure";
        input Temperature T "Temperature";
        output Density d "Density";
      algorithm
        d := density(setState_pTX(
                p,
                T,
                fill(0, 0)));
      end density_pT;

      redeclare replaceable partial model extends BaseProperties(final
          standardOrderComponents=true)
      end BaseProperties;
    end PartialPureSubstance;

    partial package PartialSimpleMedium
    "Medium model with linear dependency of u, h from temperature. All other quantities, especially density, are constant."

      extends Interfaces.PartialPureSubstance(final ThermoStates=Modelica.Media.Interfaces.Choices.IndependentVariables.pT,
          final singleState=true);

      constant SpecificHeatCapacity cp_const
      "Constant specific heat capacity at constant pressure";
      constant SpecificHeatCapacity cv_const
      "Constant specific heat capacity at constant volume";
      constant Density d_const "Constant density";
      constant DynamicViscosity eta_const "Constant dynamic viscosity";
      constant ThermalConductivity lambda_const "Constant thermal conductivity";
      constant VelocityOfSound a_const "Constant velocity of sound";
      constant Temperature T_min "Minimum temperature valid for medium model";
      constant Temperature T_max "Maximum temperature valid for medium model";
      constant Temperature T0=reference_T "Zero enthalpy temperature";
      constant MolarMass MM_const "Molar mass";

      constant FluidConstants[nS] fluidConstants "Fluid constants";

      redeclare record extends ThermodynamicState "Thermodynamic state"
        AbsolutePressure p "Absolute pressure of medium";
        Temperature T "Temperature of medium";
      end ThermodynamicState;

      redeclare replaceable model extends BaseProperties(T(stateSelect=if
              preferredMediumStates then StateSelect.prefer else StateSelect.default),
          p(stateSelect=if preferredMediumStates then StateSelect.prefer else
              StateSelect.default)) "Base properties"
      equation
        assert(T >= T_min and T <= T_max, "
Temperature T (= "   + String(T) + " K) is not
in the allowed range ("   + String(T_min) + " K <= T <= " + String(T_max) + " K)
required from medium model \""   + mediumName + "\".
");

        // h = cp_const*(T-T0);
        h = specificEnthalpy_pTX(
                p,
                T,
                X);
        u = cv_const*(T - T0);
        d = d_const;
        R = 0;
        MM = MM_const;
        state.T = T;
        state.p = p;
        annotation (Documentation(info="<HTML>
<p>
This is the most simple incompressible medium model, where
specific enthalpy h and specific internal energy u are only
a function of temperature T and all other provided medium
quantities are assumed to be constant.
Note that the (small) influence of the pressure term p/d is neglected.
</p>
</HTML>"));
      end BaseProperties;

      redeclare function setState_pTX
      "Return thermodynamic state from p, T, and X or Xi"
        extends Modelica.Icons.Function;
        input AbsolutePressure p "Pressure";
        input Temperature T "Temperature";
        input MassFraction X[:]=reference_X "Mass fractions";
        output ThermodynamicState state "Thermodynamic state record";
      algorithm
        state := ThermodynamicState(p=p, T=T);
      end setState_pTX;

      redeclare function setState_phX
      "Return thermodynamic state from p, h, and X or Xi"
        extends Modelica.Icons.Function;
        input AbsolutePressure p "Pressure";
        input SpecificEnthalpy h "Specific enthalpy";
        input MassFraction X[:]=reference_X "Mass fractions";
        output ThermodynamicState state "Thermodynamic state record";
      algorithm
        state := ThermodynamicState(p=p, T=T0 + h/cp_const);
      end setState_phX;

      redeclare replaceable function setState_psX
      "Return thermodynamic state from p, s, and X or Xi"
        extends Modelica.Icons.Function;
        input AbsolutePressure p "Pressure";
        input SpecificEntropy s "Specific entropy";
        input MassFraction X[:]=reference_X "Mass fractions";
        output ThermodynamicState state "Thermodynamic state record";
      algorithm
        state := ThermodynamicState(p=p, T=Modelica.Math.exp(s/cp_const +
          Modelica.Math.log(reference_T)))
        "Here the incompressible limit is used, with cp as heat capacity";
      end setState_psX;

      redeclare function setState_dTX
      "Return thermodynamic state from d, T, and X or Xi"
        extends Modelica.Icons.Function;
        input Density d "Density";
        input Temperature T "Temperature";
        input MassFraction X[:]=reference_X "Mass fractions";
        output ThermodynamicState state "Thermodynamic state record";
      algorithm
        assert(false,
          "Pressure can not be computed from temperature and density for an incompressible fluid!");
      end setState_dTX;

      redeclare function extends setSmoothState
      "Return thermodynamic state so that it smoothly approximates: if x > 0 then state_a else state_b"
      algorithm
        state := ThermodynamicState(p=Media.Common.smoothStep(
                x,
                state_a.p,
                state_b.p,
                x_small), T=Media.Common.smoothStep(
                x,
                state_a.T,
                state_b.T,
                x_small));
      end setSmoothState;

      redeclare function extends dynamicViscosity "Return dynamic viscosity"

      algorithm
        eta := eta_const;
      end dynamicViscosity;

      redeclare function extends thermalConductivity
      "Return thermal conductivity"

      algorithm
        lambda := lambda_const;
      end thermalConductivity;

      redeclare function extends pressure "Return pressure"

      algorithm
        p := state.p;
      end pressure;

      redeclare function extends temperature "Return temperature"

      algorithm
        T := state.T;
      end temperature;

      redeclare function extends density "Return density"

      algorithm
        d := d_const;
      end density;

      redeclare function extends specificEnthalpy "Return specific enthalpy"

      algorithm
        h := cp_const*(state.T - T0);
      end specificEnthalpy;

      redeclare function extends specificHeatCapacityCp
      "Return specific heat capacity at constant pressure"

      algorithm
        cp := cp_const;
      end specificHeatCapacityCp;

      redeclare function extends specificHeatCapacityCv
      "Return specific heat capacity at constant volume"

      algorithm
        cv := cv_const;
      end specificHeatCapacityCv;

      redeclare function extends isentropicExponent
      "Return isentropic exponent"

      algorithm
        gamma := cp_const/cv_const;
      end isentropicExponent;

      redeclare function extends velocityOfSound "Return velocity of sound"

      algorithm
        a := a_const;
      end velocityOfSound;

      redeclare function specificEnthalpy_pTX
      "Return specific enthalpy from p, T, and X or Xi"
        extends Modelica.Icons.Function;
        input AbsolutePressure p "Pressure";
        input Temperature T "Temperature";
        input MassFraction X[nX] "Mass fractions";
        output SpecificEnthalpy h "Specific enthalpy";
      algorithm
        h := cp_const*(T - T0);
        annotation (Documentation(info="<html>
<p>
This function computes the specific enthalpy of the fluid, but neglects the (small) influence of the pressure term p/d.
</p>
</html>"));
      end specificEnthalpy_pTX;

      redeclare function temperature_phX
      "Return temperature from p, h, and X or Xi"
        extends Modelica.Icons.Function;
        input AbsolutePressure p "Pressure";
        input SpecificEnthalpy h "Specific enthalpy";
        input MassFraction X[nX] "Mass fractions";
        output Temperature T "Temperature";
      algorithm
        T := T0 + h/cp_const;
      end temperature_phX;

      redeclare function density_phX "Return density from p, h, and X or Xi"
        extends Modelica.Icons.Function;
        input AbsolutePressure p "Pressure";
        input SpecificEnthalpy h "Specific enthalpy";
        input MassFraction X[nX] "Mass fractions";
        output Density d "Density";
      algorithm
        d := density(setState_phX(
                p,
                h,
                X));
      end density_phX;

      redeclare function extends specificInternalEnergy
      "Return specific internal energy"
        extends Modelica.Icons.Function;
      algorithm
        //  u := cv_const*(state.T - T0) - reference_p/d_const;
        u := cv_const*(state.T - T0);
        annotation (Documentation(info="<html>
<p>
This function computes the specific internal energy of the fluid, but neglects the (small) influence of the pressure term p/d.
</p>
</html>"));
      end specificInternalEnergy;

      redeclare function extends specificEntropy "Return specific entropy"
        extends Modelica.Icons.Function;
      algorithm
        s := cv_const*Modelica.Math.log(state.T/T0);
      end specificEntropy;

      redeclare function extends specificGibbsEnergy
      "Return specific Gibbs energy"
        extends Modelica.Icons.Function;
      algorithm
        g := specificEnthalpy(state) - state.T*specificEntropy(state);
      end specificGibbsEnergy;

      redeclare function extends specificHelmholtzEnergy
      "Return specific Helmholtz energy"
        extends Modelica.Icons.Function;
      algorithm
        f := specificInternalEnergy(state) - state.T*specificEntropy(state);
      end specificHelmholtzEnergy;

      redeclare function extends isentropicEnthalpy
      "Return isentropic enthalpy"
      algorithm
        h_is := cp_const*(temperature(refState) - T0);
      end isentropicEnthalpy;

      redeclare function extends isobaricExpansionCoefficient
      "Returns overall the isobaric expansion coefficient beta"
      algorithm
        beta := 0.0;
      end isobaricExpansionCoefficient;

      redeclare function extends isothermalCompressibility
      "Returns overall the isothermal compressibility factor"
      algorithm
        kappa := 0;
      end isothermalCompressibility;

      redeclare function extends density_derp_T
      "Returns the partial derivative of density with respect to pressure at constant temperature"
      algorithm
        ddpT := 0;
      end density_derp_T;

      redeclare function extends density_derT_p
      "Returns the partial derivative of density with respect to temperature at constant pressure"
      algorithm
        ddTp := 0;
      end density_derT_p;

      redeclare function extends density_derX
      "Returns the partial derivative of density with respect to mass fractions at constant pressure and temperature"
      algorithm
        dddX := fill(0, nX);
      end density_derX;

      redeclare function extends molarMass
      "Return the molar mass of the medium"
      algorithm
        MM := MM_const;
      end molarMass;
    end PartialSimpleMedium;

    package Choices "Types, constants to define menu choices"
      extends Modelica.Icons.Package;

      type IndependentVariables = enumeration(
        T "Temperature",
        pT "Pressure, Temperature",
        ph "Pressure, Specific Enthalpy",
        phX "Pressure, Specific Enthalpy, Mass Fraction",
        pTX "Pressure, Temperature, Mass Fractions",
        dTX "Density, Temperature, Mass Fractions")
      "Enumeration defining the independent variables of a medium";
      annotation (Documentation(info="<html>
<p>
Enumerations and data types for all types of fluids
</p>

<p>
Note: Reference enthalpy might have to be extended with enthalpy of formation.
</p>
</html>"));
    end Choices;

    package Types "Types to be used in fluid models"
      extends Modelica.Icons.Package;

      type AbsolutePressure = SI.AbsolutePressure (
          min=0,
          max=1.e8,
          nominal=1.e5,
          start=1.e5)
      "Type for absolute pressure with medium specific attributes";

      type Density = SI.Density (
          min=0,
          max=1.e5,
          nominal=1,
          start=1) "Type for density with medium specific attributes";

      type DynamicViscosity = SI.DynamicViscosity (
          min=0,
          max=1.e8,
          nominal=1.e-3,
          start=1.e-3)
      "Type for dynamic viscosity with medium specific attributes";

      type EnthalpyFlowRate = SI.EnthalpyFlowRate (
          nominal=1000.0,
          min=-1.0e8,
          max=1.e8)
      "Type for enthalpy flow rate with medium specific attributes";

      type MassFraction = Real (
          quantity="MassFraction",
          final unit="kg/kg",
          min=0,
          max=1,
          nominal=0.1) "Type for mass fraction with medium specific attributes";

      type MolarMass = SI.MolarMass (
          min=0.001,
          max=0.25,
          nominal=0.032) "Type for molar mass with medium specific attributes";

      type IsentropicExponent = SI.RatioOfSpecificHeatCapacities (
          min=1,
          max=500000,
          nominal=1.2,
          start=1.2)
      "Type for isentropic exponent with medium specific attributes";

      type SpecificEnergy = SI.SpecificEnergy (
          min=-1.0e8,
          max=1.e8,
          nominal=1.e6)
      "Type for specific energy with medium specific attributes";

      type SpecificInternalEnergy = SpecificEnergy
      "Type for specific internal energy with medium specific attributes";

      type SpecificEnthalpy = SI.SpecificEnthalpy (
          min=-1.0e10,
          max=1.e10,
          nominal=1.e6)
      "Type for specific enthalpy with medium specific attributes";

      type SpecificEntropy = SI.SpecificEntropy (
          min=-1.e7,
          max=1.e7,
          nominal=1.e3)
      "Type for specific entropy with medium specific attributes";

      type SpecificHeatCapacity = SI.SpecificHeatCapacity (
          min=0,
          max=1.e7,
          nominal=1.e3,
          start=1.e3)
      "Type for specific heat capacity with medium specific attributes";

      type Temperature = SI.Temperature (
          min=1,
          max=1.e4,
          nominal=300,
          start=300) "Type for temperature with medium specific attributes";

      type ThermalConductivity = SI.ThermalConductivity (
          min=0,
          max=500,
          nominal=1,
          start=1)
      "Type for thermal conductivity with medium specific attributes";

      type PrandtlNumber = SI.PrandtlNumber (
          min=1e-3,
          max=1e5,
          nominal=1.0)
      "Type for Prandtl number with medium specific attributes";

      type VelocityOfSound = SI.Velocity (
          min=0,
          max=1.e5,
          nominal=1000,
          start=1000)
      "Type for velocity of sound with medium specific attributes";

      type ExtraProperty = Real (min=0.0, start=1.0)
      "Type for unspecified, mass-specific property transported by flow";

      type ExtraPropertyFlowRate = Real (unit="kg/s")
      "Type for flow rate of unspecified, mass-specific property";

      type IsobaricExpansionCoefficient = Real (
          min=0,
          max=1.0e8,
          unit="1/K")
      "Type for isobaric expansion coefficient with medium specific attributes";

      type DerDensityByPressure = SI.DerDensityByPressure
      "Type for partial derivative of density with respect to pressure with medium specific attributes";

      type DerDensityByEnthalpy = SI.DerDensityByEnthalpy
      "Type for partial derivative of density with respect to enthalpy with medium specific attributes";

      type DerDensityByTemperature = SI.DerDensityByTemperature
      "Type for partial derivative of density with respect to temperature with medium specific attributes";

      package Basic
      "The most basic version of a record used in several degrees of detail"
        extends Icons.Package;

        record FluidConstants
        "Critical, triple, molecular and other standard data of fluid"
          extends Modelica.Icons.Record;
          String iupacName
          "Complete IUPAC name (or common name, if non-existent)";
          String casRegistryNumber
          "Chemical abstracts sequencing number (if it exists)";
          String chemicalFormula
          "Chemical formula, (brutto, nomenclature according to Hill";
          String structureFormula "Chemical structure formula";
          MolarMass molarMass "Molar mass";
        end FluidConstants;
      end Basic;
    end Types;
    annotation (Documentation(info="<HTML>
<p>
This package provides basic interfaces definitions of media models for different
kind of media.
</p>
</HTML>"));
  end Interfaces;

  package Common
    "Data structures and fundamental functions for fluid properties"
    extends Modelica.Icons.Package;

    function smoothStep
    "Approximation of a general step, such that the characteristic is continuous and differentiable"
      extends Modelica.Icons.Function;
      input Real x "Abscissa value";
      input Real y1 "Ordinate value for x > 0";
      input Real y2 "Ordinate value for x < 0";
      input Real x_small(min=0) = 1e-5
      "Approximation of step for -x_small <= x <= x_small; x_small > 0 required";
      output Real y
      "Ordinate value to approximate y = if x > 0 then y1 else y2";
    algorithm
      y := smooth(1, if x > x_small then y1 else if x < -x_small then y2 else if
        abs(x_small) > 0 then (x/x_small)*((x/x_small)^2 - 3)*(y2 - y1)/4 + (y1
         + y2)/2 else (y1 + y2)/2);

      annotation (
        Inline=true,
        smoothOrder=1,
        Documentation(revisions="<html>
<ul>
<li><i>April 29, 2008</i>
    by <a href=\"mailto:Martin.Otter@DLR.de\">Martin Otter</a>:<br>
    Designed and implemented.</li>
<li><i>August 12, 2008</i>
    by <a href=\"mailto:Michael.Sielemann@dlr.de\">Michael Sielemann</a>:<br>
    Minor modification to cover the limit case <code>x_small -> 0</code> without division by zero.</li>
</ul>
</html>",   info="<html>
<p>
This function is used to approximate the equation
</p>
<pre>
    y = <b>if</b> x &gt; 0 <b>then</b> y1 <b>else</b> y2;
</pre>

<p>
by a smooth characteristic, so that the expression is continuous and differentiable:
</p>

<pre>
   y = <b>smooth</b>(1, <b>if</b> x &gt;  x_small <b>then</b> y1 <b>else</b>
                 <b>if</b> x &lt; -x_small <b>then</b> y2 <b>else</b> f(y1, y2));
</pre>

<p>
In the region -x_small &lt; x &lt; x_small a 2nd order polynomial is used
for a smooth transition from y1 to y2.
</p>

<p>
If <b>mass fractions</b> X[:] are approximated with this function then this can be performed
for all <b>nX</b> mass fractions, instead of applying it for nX-1 mass fractions and computing
the last one by the mass fraction constraint sum(X)=1. The reason is that the approximating function has the
property that sum(X) = 1, provided sum(X_a) = sum(X_b) = 1
(and y1=X_a[i], y2=X_b[i]).
This can be shown by evaluating the approximating function in the abs(x) &lt; x_small
region (otherwise X is either X_a or X_b):
</p>

<pre>
    X[1]  = smoothStep(x, X_a[1] , X_b[1] , x_small);
    X[2]  = smoothStep(x, X_a[2] , X_b[2] , x_small);
       ...
    X[nX] = smoothStep(x, X_a[nX], X_b[nX], x_small);
</pre>

<p>
or
</p>

<pre>
    X[1]  = c*(X_a[1]  - X_b[1])  + (X_a[1]  + X_b[1])/2
    X[2]  = c*(X_a[2]  - X_b[2])  + (X_a[2]  + X_b[2])/2;
       ...
    X[nX] = c*(X_a[nX] - X_b[nX]) + (X_a[nX] + X_b[nX])/2;
    c     = (x/x_small)*((x/x_small)^2 - 3)/4
</pre>

<p>
Summing all mass fractions together results in
</p>

<pre>
    sum(X) = c*(sum(X_a) - sum(X_b)) + (sum(X_a) + sum(X_b))/2
           = c*(1 - 1) + (1 + 1)/2
           = 1
</pre>
</html>"));
    end smoothStep;
    annotation (Documentation(info="<HTML><h4>Package description</h4>
      <p>Package Modelica.Media.Common provides records and functions shared by many of the property sub-packages.
      High accuracy fluid property models share a lot of common structure, even if the actual models are different.
      Common data structures and computations shared by these property models are collected in this library.
   </p>

</html>",   revisions="<html>
      <ul>
      <li>First implemented: <i>July, 2000</i>
      by <a href=\"http://www.control.lth.se/~hubertus/\">Hubertus Tummescheit</a>
      for the ThermoFluid Library with help from Jonas Eborn and Falko Jens Wagner
      </li>
      <li>Code reorganization, enhanced documentation, additional functions: <i>December, 2002</i>
      by <a href=\"http://www.control.lth.se/~hubertus/\">Hubertus Tummescheit</a> and move to Modelica
                            properties library.</li>
      <li>Inclusion into Modelica.Media: September 2003 </li>
      </ul>

      <address>Author: Hubertus Tummescheit, <br>
      Lund University<br>
      Department of Automatic Control<br>
      Box 118, 22100 Lund, Sweden<br>
      email: hubertus@control.lth.se
      </address>
</html>"));
  end Common;

    package Water "Medium models for water"
    extends Modelica.Icons.VariantsPackage;
    import Modelica.Media.Water.ConstantPropertyLiquidWater.simpleWaterConstants;

    package ConstantPropertyLiquidWater
      "Water: Simple liquid water medium (incompressible, constant data)"

      //   redeclare record extends FluidConstants
      //   end FluidConstants;

      constant Modelica.Media.Interfaces.Types.Basic.FluidConstants[1]
        simpleWaterConstants(
        each chemicalFormula="H2O",
        each structureFormula="H2O",
        each casRegistryNumber="7732-18-5",
        each iupacName="oxidane",
        each molarMass=0.018015268);

      extends Interfaces.PartialSimpleMedium(
        mediumName="SimpleLiquidWater",
        cp_const=4184,
        cv_const=4184,
        d_const=995.586,
        eta_const=1.e-3,
        lambda_const=0.598,
        a_const=1484,
        T_min=Cv.from_degC(-1),
        T_max=Cv.from_degC(130),
        T0=273.15,
        MM_const=0.018015268,
        fluidConstants=simpleWaterConstants);

      annotation (Documentation(info="<html>

</html>"));
    end ConstantPropertyLiquidWater;
    annotation (Documentation(info="<html>
<p>This package contains different medium models for water:</p>
<ul>
<li><b>ConstantPropertyLiquidWater</b><br>
    Simple liquid water medium (incompressible, constant data).</li>
<li><b>IdealSteam</b><br>
    Steam water medium as ideal gas from Media.IdealGases.SingleGases.H2O</li>
<li><b>WaterIF97 derived models</b><br>
    High precision water model according to the IAPWS/IF97 standard
    (liquid, steam, two phase region). Models with different independent
    variables are provided as well as models valid only
    for particular regions. The <b>WaterIF97_ph</b> model is valid
    in all regions and is the recommended one to use.</li>
</ul>
<h4>Overview of WaterIF97 derived water models</h4>
<p>
The WaterIF97 models calculate medium properties
for water in the <b>liquid</b>, <b>gas</b> and <b>two phase</b> regions
according to the IAPWS/IF97 standard, i.e., the accepted industrial standard
and best compromise between accuracy and computation time.
It has been part of the ThermoFluid Modelica library and been extended,
reorganized and documented to become part of the Modelica Standard library.</p>
<p>An important feature that distinguishes this implementation of the IF97 steam property standard
is that this implementation has been explicitly designed to work well in dynamic simulations. Computational
performance has been of high importance. This means that there often exist several ways to get the same result
from different functions if one of the functions is called often but can be optimized for that purpose.
</p>
<p>Three variable pairs can be the independent variables of the model:
</p>
<ol>
<li>Pressure <b>p</b> and specific enthalpy <b>h</b> are
    the most natural choice for general applications.
    This is the recommended choice for most general purpose
    applications, in particular for power plants.</li>
<li>Pressure <b>p</b> and temperature <b>T</b> are the most natural
    choice for applications where water is always in the same phase,
    both for liquid water and steam.</li>
<li>Density <b>d</b> and temperature <b>T</b> are explicit
    variables of the Helmholtz function in the near-critical
    region and can be the best choice for applications with
    super-critical or near-critical states.</li>
</ol>
<p>
The following quantities are always computed in Medium.BaseProperties:
</p>
<table border=1 cellspacing=0 cellpadding=2>
  <tr><td valign=\"top\"><b>Variable</b></td>
      <td valign=\"top\"><b>Unit</b></td>
      <td valign=\"top\"><b>Description</b></td></tr>
  <tr><td valign=\"top\">T</td>
      <td valign=\"top\">K</td>
      <td valign=\"top\">temperature</td></tr>
  <tr><td valign=\"top\">u</td>
      <td valign=\"top\">J/kg</td>
      <td valign=\"top\">specific internal energy</td></tr>
  <tr><td valign=\"top\">d</td>
      <td valign=\"top\">kg/m^3</td>
      <td valign=\"top\">density</td></tr>
  <tr><td valign=\"top\">p</td>
      <td valign=\"top\">Pa</td>
      <td valign=\"top\">pressure</td></tr>
  <tr><td valign=\"top\">h</td>
      <td valign=\"top\">J/kg</td>
      <td valign=\"top\">specific enthalpy</td></tr>
</table>
<p>
In some cases additional medium properties are needed.
A component that needs these optional properties has to call
one of the following functions:
</p>
<table border=1 cellspacing=0 cellpadding=2>
  <tr><td valign=\"top\"><b>Function call</b></td>
      <td valign=\"top\"><b>Unit</b></td>
      <td valign=\"top\"><b>Description</b></td></tr>
  <tr><td valign=\"top\">Medium.dynamicViscosity(medium.state)</td>
      <td valign=\"top\">Pa.s</td>
      <td valign=\"top\">dynamic viscosity</td></tr>
  <tr><td valign=\"top\">Medium.thermalConductivity(medium.state)</td>
      <td valign=\"top\">W/(m.K)</td>
      <td valign=\"top\">thermal conductivity</td></tr>
  <tr><td valign=\"top\">Medium.prandtlNumber(medium.state)</td>
      <td valign=\"top\">1</td>
      <td valign=\"top\">Prandtl number</td></tr>
  <tr><td valign=\"top\">Medium.specificEntropy(medium.state)</td>
      <td valign=\"top\">J/(kg.K)</td>
      <td valign=\"top\">specific entropy</td></tr>
  <tr><td valign=\"top\">Medium.heatCapacity_cp(medium.state)</td>
      <td valign=\"top\">J/(kg.K)</td>
      <td valign=\"top\">specific heat capacity at constant pressure</td></tr>
  <tr><td valign=\"top\">Medium.heatCapacity_cv(medium.state)</td>
      <td valign=\"top\">J/(kg.K)</td>
      <td valign=\"top\">specific heat capacity at constant density</td></tr>
  <tr><td valign=\"top\">Medium.isentropicExponent(medium.state)</td>
      <td valign=\"top\">1</td>
      <td valign=\"top\">isentropic exponent</td></tr>
  <tr><td valign=\"top\">Medium.isentropicEnthalpy(pressure, medium.state)</td>
      <td valign=\"top\">J/kg</td>
      <td valign=\"top\">isentropic enthalpy</td></tr>
  <tr><td valign=\"top\">Medium.velocityOfSound(medium.state)</td>
      <td valign=\"top\">m/s</td>
      <td valign=\"top\">velocity of sound</td></tr>
  <tr><td valign=\"top\">Medium.isobaricExpansionCoefficient(medium.state)</td>
      <td valign=\"top\">1/K</td>
      <td valign=\"top\">isobaric expansion coefficient</td></tr>
  <tr><td valign=\"top\">Medium.isothermalCompressibility(medium.state)</td>
      <td valign=\"top\">1/Pa</td>
      <td valign=\"top\">isothermal compressibility</td></tr>
  <tr><td valign=\"top\">Medium.density_derp_h(medium.state)</td>
      <td valign=\"top\">kg/(m3.Pa)</td>
      <td valign=\"top\">derivative of density by pressure at constant enthalpy</td></tr>
  <tr><td valign=\"top\">Medium.density_derh_p(medium.state)</td>
      <td valign=\"top\">kg2/(m3.J)</td>
      <td valign=\"top\">derivative of density by enthalpy at constant pressure</td></tr>
  <tr><td valign=\"top\">Medium.density_derp_T(medium.state)</td>
      <td valign=\"top\">kg/(m3.Pa)</td>
      <td valign=\"top\">derivative of density by pressure at constant temperature</td></tr>
  <tr><td valign=\"top\">Medium.density_derT_p(medium.state)</td>
      <td valign=\"top\">kg/(m3.K)</td>
      <td valign=\"top\">derivative of density by temperature at constant pressure</td></tr>
  <tr><td valign=\"top\">Medium.density_derX(medium.state)</td>
      <td valign=\"top\">kg/m3</td>
      <td valign=\"top\">derivative of density by mass fraction</td></tr>
  <tr><td valign=\"top\">Medium.molarMass(medium.state)</td>
      <td valign=\"top\">kg/mol</td>
      <td valign=\"top\">molar mass</td></tr>
</table>
<p>More details are given in
<a href=\"modelica://Modelica.Media.UsersGuide.MediumUsage.OptionalProperties\">
Modelica.Media.UsersGuide.MediumUsage.OptionalProperties</a>.

Many additional optional functions are defined to compute properties of
saturated media, either liquid (bubble point) or vapour (dew point).
The argument to such functions is a SaturationProperties record, which can be
set starting from either the saturation pressure or the saturation temperature.
With reference to a model defining a pressure p, a temperature T, and a
SaturationProperties record sat, the following functions are provided:
</p>
<table border=1 cellspacing=0 cellpadding=2>
  <tr><td valign=\"top\"><b>Function call</b></td>
      <td valign=\"top\"><b>Unit</b></td>
      <td valign=\"top\"><b>Description</b></td></tr>
  <tr><td valign=\"top\">Medium.saturationPressure(T)</td>
      <td valign=\"top\">Pa</td>
      <td valign=\"top\">Saturation pressure at temperature T</td></tr>
  <tr><td valign=\"top\">Medium.saturationTemperature(p)</td>
      <td valign=\"top\">K</td>
      <td valign=\"top\">Saturation temperature at pressure p</td></tr>
  <tr><td valign=\"top\">Medium.saturationTemperature_derp(p)</td>
      <td valign=\"top\">K/Pa</td>
      <td valign=\"top\">Derivative of saturation temperature with respect to pressure</td></tr>
  <tr><td valign=\"top\">Medium.bubbleEnthalpy(sat)</td>
      <td valign=\"top\">J/kg</td>
      <td valign=\"top\">Specific enthalpy at bubble point</td></tr>
  <tr><td valign=\"top\">Medium.dewEnthalpy(sat)</td>
      <td valign=\"top\">J/kg</td>
      <td valign=\"top\">Specific enthalpy at dew point</td></tr>
  <tr><td valign=\"top\">Medium.bubbleEntropy(sat)</td>
      <td valign=\"top\">J/(kg.K)</td>
      <td valign=\"top\">Specific entropy at bubble point</td></tr>
  <tr><td valign=\"top\">Medium.dewEntropy(sat)</td>
      <td valign=\"top\">J/(kg.K)</td>
      <td valign=\"top\">Specific entropy at dew point</td></tr>
  <tr><td valign=\"top\">Medium.bubbleDensity(sat)</td>
      <td valign=\"top\">kg/m3</td>
      <td valign=\"top\">Density at bubble point</td></tr>
  <tr><td valign=\"top\">Medium.dewDensity(sat)</td>
      <td valign=\"top\">kg/m3</td>
      <td valign=\"top\">Density at dew point</td></tr>
  <tr><td valign=\"top\">Medium.dBubbleDensity_dPressure(sat)</td>
      <td valign=\"top\">kg/(m3.Pa)</td>
      <td valign=\"top\">Derivative of density at bubble point with respect to pressure</td></tr>
  <tr><td valign=\"top\">Medium.dDewDensity_dPressure(sat)</td>
      <td valign=\"top\">kg/(m3.Pa)</td>
      <td valign=\"top\">Derivative of density at dew point with respect to pressure</td></tr>
  <tr><td valign=\"top\">Medium.dBubbleEnthalpy_dPressure(sat)</td>
      <td valign=\"top\">J/(kg.Pa)</td>
      <td valign=\"top\">Derivative of specific enthalpy at bubble point with respect to pressure</td></tr>
  <tr><td valign=\"top\">Medium.dDewEnthalpy_dPressure(sat)</td>
      <td valign=\"top\">J/(kg.Pa)</td>
      <td valign=\"top\">Derivative of specific enthalpy at dew point with respect to pressure</td></tr>
  <tr><td valign=\"top\">Medium.surfaceTension(sat)</td>
      <td valign=\"top\">N/m</td>
      <td valign=\"top\">Surface tension between liquid and vapour phase</td></tr>
</table>
<p>Details on usage and some examples are given in:
<a href=\"modelica://Modelica.Media.UsersGuide.MediumUsage.TwoPhase\">
Modelica.Media.UsersGuide.MediumUsage.TwoPhase</a>.
</p>
<p>Many further properties can be computed. Using the well-known Bridgman's Tables,
all first partial derivatives of the standard thermodynamic variables can be computed easily.
</p>
<p>
The documentation of the IAPWS/IF97 steam properties can be freely
distributed with computer implementations and are included here
(in directory Modelica/Resources/Documentation/Media/Water/IF97documentation):
</p>
<ul>
<li><a href=\"modelica://Modelica/Resources/Documentation/Media/Water/IF97documentation/IF97.pdf\">IF97.pdf</a> The standards document for the main part of the IF97.</li>
<li><a href=\"modelica://Modelica/Resources/Documentation/Media/Water/IF97documentation/Back3.pdf\">Back3.pdf</a> The backwards equations for region 3.</li>
<li><a href=\"modelica://Modelica/Resources/Documentation/Media/Water/IF97documentation/crits.pdf\">crits.pdf</a> The critical point data.</li>
<li><a href=\"modelica://Modelica/Resources/Documentation/Media/Water/IF97documentation/meltsub.pdf\">meltsub.pdf</a> The melting- and sublimation line formulation (not implemented)</li>
<li><a href=\"modelica://Modelica/Resources/Documentation/Media/Water/IF97documentation/surf.pdf\">surf.pdf</a> The surface tension standard definition</li>
<li><a href=\"modelica://Modelica/Resources/Documentation/Media/Water/IF97documentation/thcond.pdf\">thcond.pdf</a> The thermal conductivity standard definition</li>
<li><a href=\"modelica://Modelica/Resources/Documentation/Media/Water/IF97documentation/visc.pdf\">visc.pdf</a> The viscosity standard definition</li>
</ul>
</html>"));
    end Water;
  annotation (preferredView="info",Documentation(info="<HTML>
<p>
This library contains <a href=\"modelica://Modelica.Media.Interfaces\">interface</a>
definitions for media and the following <b>property</b> models for
single and multiple substance fluids with one and multiple phases:
</p>
<ul>
<li> <a href=\"modelica://Modelica.Media.IdealGases\">Ideal gases:</a><br>
     1241 high precision gas models based on the
     NASA Glenn coefficients, plus ideal gas mixture models based
     on the same data.</li>
<li> <a href=\"modelica://Modelica.Media.Water\">Water models:</a><br>
     ConstantPropertyLiquidWater, WaterIF97 (high precision
     water model according to the IAPWS/IF97 standard)</li>
<li> <a href=\"modelica://Modelica.Media.Air\">Air models:</a><br>
     SimpleAir, DryAirNasa, ReferenceAir, MoistAir, ReferenceMoistAir.</li>
<li> <a href=\"modelica://Modelica.Media.Incompressible\">
     Incompressible media:</a><br>
     TableBased incompressible fluid models (properties are defined by tables rho(T),
     HeatCapacity_cp(T), etc.)</li>
<li> <a href=\"modelica://Modelica.Media.CompressibleLiquids\">
     Compressible liquids:</a><br>
     Simple liquid models with linear compressibility</li>
<li> <a href=\"modelica://Modelica.Media.R134a\">Refrigerant Tetrafluoroethane (R134a)</a>.</li>
</ul>
<p>
The following parts are useful, when newly starting with this library:
<ul>
<li> <a href=\"modelica://Modelica.Media.UsersGuide\">Modelica.Media.UsersGuide</a>.</li>
<li> <a href=\"modelica://Modelica.Media.UsersGuide.MediumUsage\">Modelica.Media.UsersGuide.MediumUsage</a>
     describes how to use a medium model in a component model.</li>
<li> <a href=\"modelica://Modelica.Media.UsersGuide.MediumDefinition\">
     Modelica.Media.UsersGuide.MediumDefinition</a>
     describes how a new fluid medium model has to be implemented.</li>
<li> <a href=\"modelica://Modelica.Media.UsersGuide.ReleaseNotes\">Modelica.Media.UsersGuide.ReleaseNotes</a>
     summarizes the changes of the library releases.</li>
<li> <a href=\"modelica://Modelica.Media.Examples\">Modelica.Media.Examples</a>
     contains examples that demonstrate the usage of this library.</li>
</ul>
<p>
Copyright &copy; 1998-2013, Modelica Association.
</p>
<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"https://www.modelica.org/licenses/ModelicaLicense2\"> https://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>
</HTML>",   revisions="<html>
<ul>
<li><i>May 16, 2013</i> by Stefan Wischhusen (XRG Simulation):<br/>
    Added new media models Air.ReferenceMoistAir, Air.ReferenceAir, R134a.</li>
<li><i>May 25, 2011</i> by Francesco Casella:<br/>Added min/max attributes to Water, TableBased, MixtureGasNasa, SimpleAir and MoistAir local types.</li>
<li><i>May 25, 2011</i> by Stefan Wischhusen:<br/>Added individual settings for polynomial fittings of properties.</li>
</ul>
</html>"),
      Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
          graphics={
          Line(
            points = {{-76,-80},{-62,-30},{-32,40},{4,66},{48,66},{73,45},{62,-8},{48,-50},{38,-80}},
            color={64,64,64},
            smooth=Smooth.Bezier),
          Line(
            points={{-40,20},{68,20}},
            color={175,175,175},
            smooth=Smooth.None),
          Line(
            points={{-40,20},{-44,88},{-44,88}},
            color={175,175,175},
            smooth=Smooth.None),
          Line(
            points={{68,20},{86,-58}},
            color={175,175,175},
            smooth=Smooth.None),
          Line(
            points={{-60,-28},{56,-28}},
            color={175,175,175},
            smooth=Smooth.None),
          Line(
            points={{-60,-28},{-74,84},{-74,84}},
            color={175,175,175},
            smooth=Smooth.None),
          Line(
            points={{56,-28},{70,-80}},
            color={175,175,175},
            smooth=Smooth.None),
          Line(
            points={{-76,-80},{38,-80}},
            color={175,175,175},
            smooth=Smooth.None),
          Line(
            points={{-76,-80},{-94,-16},{-94,-16}},
            color={175,175,175},
            smooth=Smooth.None)}));
  end Media;

  package Thermal
  "Library of thermal system components to model heat transfer and simple thermo-fluid pipe flow"
    extends Modelica.Icons.Package;

    package HeatTransfer
    "Library of 1-dimensional heat transfer with lumped elements"
      extends Modelica.Icons.Package;

      package Components "Lumped thermal components"
      extends Modelica.Icons.Package;

        model HeatCapacitor "Lumped thermal element storing heat"
          parameter Modelica.SIunits.HeatCapacity C
          "Heat capacity of element (= cp*m)";
          Modelica.SIunits.Temperature T(start=293.15, displayUnit="degC")
          "Temperature of element";
          Modelica.SIunits.TemperatureSlope der_T(start=0)
          "Time derivative of temperature (= der(T))";
          Interfaces.HeatPort_a port annotation (Placement(transformation(
                origin={0,-100},
                extent={{-10,-10},{10,10}},
                rotation=90)));
        equation
          T = port.T;
          der_T = der(T);
          C*der(T) = port.Q_flow;
          annotation (
            Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                    100,100}}), graphics={
                Text(
                  extent={{-150,110},{150,70}},
                  textString="%name",
                  lineColor={0,0,255}),
                Polygon(
                  points={{0,67},{-20,63},{-40,57},{-52,43},{-58,35},{-68,25},{-72,
                      13},{-76,-1},{-78,-15},{-76,-31},{-76,-43},{-76,-53},{-70,-65},
                      {-64,-73},{-48,-77},{-30,-83},{-18,-83},{-2,-85},{8,-89},{22,
                      -89},{32,-87},{42,-81},{54,-75},{56,-73},{66,-61},{68,-53},{
                      70,-51},{72,-35},{76,-21},{78,-13},{78,3},{74,15},{66,25},{54,
                      33},{44,41},{36,57},{26,65},{0,67}},
                  lineColor={160,160,164},
                  fillColor={192,192,192},
                  fillPattern=FillPattern.Solid),
                Polygon(
                  points={{-58,35},{-68,25},{-72,13},{-76,-1},{-78,-15},{-76,-31},{
                      -76,-43},{-76,-53},{-70,-65},{-64,-73},{-48,-77},{-30,-83},{-18,
                      -83},{-2,-85},{8,-89},{22,-89},{32,-87},{42,-81},{54,-75},{42,
                      -77},{40,-77},{30,-79},{20,-81},{18,-81},{10,-81},{2,-77},{-12,
                      -73},{-22,-73},{-30,-71},{-40,-65},{-50,-55},{-56,-43},{-58,-35},
                      {-58,-25},{-60,-13},{-60,-5},{-60,7},{-58,17},{-56,19},{-52,
                      27},{-48,35},{-44,45},{-40,57},{-58,35}},
                  lineColor={0,0,0},
                  fillColor={160,160,164},
                  fillPattern=FillPattern.Solid),
                Text(
                  extent={{-69,7},{71,-24}},
                  lineColor={0,0,0},
                  textString="%C")}),
            Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
                    {100,100}}), graphics={
                Polygon(
                  points={{0,67},{-20,63},{-40,57},{-52,43},{-58,35},{-68,25},{-72,
                      13},{-76,-1},{-78,-15},{-76,-31},{-76,-43},{-76,-53},{-70,-65},
                      {-64,-73},{-48,-77},{-30,-83},{-18,-83},{-2,-85},{8,-89},{22,
                      -89},{32,-87},{42,-81},{54,-75},{56,-73},{66,-61},{68,-53},{
                      70,-51},{72,-35},{76,-21},{78,-13},{78,3},{74,15},{66,25},{54,
                      33},{44,41},{36,57},{26,65},{0,67}},
                  lineColor={160,160,164},
                  fillColor={192,192,192},
                  fillPattern=FillPattern.Solid),
                Polygon(
                  points={{-58,35},{-68,25},{-72,13},{-76,-1},{-78,-15},{-76,-31},{
                      -76,-43},{-76,-53},{-70,-65},{-64,-73},{-48,-77},{-30,-83},{-18,
                      -83},{-2,-85},{8,-89},{22,-89},{32,-87},{42,-81},{54,-75},{42,
                      -77},{40,-77},{30,-79},{20,-81},{18,-81},{10,-81},{2,-77},{-12,
                      -73},{-22,-73},{-30,-71},{-40,-65},{-50,-55},{-56,-43},{-58,-35},
                      {-58,-25},{-60,-13},{-60,-5},{-60,7},{-58,17},{-56,19},{-52,
                      27},{-48,35},{-44,45},{-40,57},{-58,35}},
                  lineColor={0,0,0},
                  fillColor={160,160,164},
                  fillPattern=FillPattern.Solid),
                Ellipse(
                  extent={{-6,-1},{6,-12}},
                  lineColor={255,0,0},
                  fillColor={191,0,0},
                  fillPattern=FillPattern.Solid),
                Text(
                  extent={{11,13},{50,-25}},
                  lineColor={0,0,0},
                  textString="T"),
                Line(points={{0,-12},{0,-96}}, color={255,0,0})}),
            Documentation(info="<HTML>
<p>
This is a generic model for the heat capacity of a material.
No specific geometry is assumed beyond a total volume with
uniform temperature for the entire volume.
Furthermore, it is assumed that the heat capacity
is constant (independent of temperature).
</p>
<p>
The temperature T [Kelvin] of this component is a <b>state</b>.
A default of T = 25 degree Celsius (= SIunits.Conversions.from_degC(25))
is used as start value for initialization.
This usually means that at start of integration the temperature of this
component is 25 degrees Celsius. You may, of course, define a different
temperature as start value for initialization. Alternatively, it is possible
to set parameter <b>steadyStateStart</b> to <b>true</b>. In this case
the additional equation '<b>der</b>(T) = 0' is used during
initialization, i.e., the temperature T is computed in such a way that
the component starts in <b>steady state</b>. This is useful in cases,
where one would like to start simulation in a suitable operating
point without being forced to integrate for a long time to arrive
at this point.
</p>
<p>
Note, that parameter <b>steadyStateStart</b> is not available in
the parameter menu of the simulation window, because its value
is utilized during translation to generate quite different
equations depending on its setting. Therefore, the value of this
parameter can only be changed before translating the model.
</p>
<p>
This component may be used for complicated geometries where
the heat capacity C is determined my measurements. If the component
consists mainly of one type of material, the <b>mass m</b> of the
component may be measured or calculated and multiplied with the
<b>specific heat capacity cp</b> of the component material to
compute C:
</p>
<pre>
   C = cp*m.
   Typical values for cp at 20 degC in J/(kg.K):
      aluminium   896
      concrete    840
      copper      383
      iron        452
      silver      235
      steel       420 ... 500 (V2A)
      wood       2500
</pre>
</html>"));
        end HeatCapacitor;

        model ThermalConductor
        "Lumped thermal element transporting heat without storing it"
          extends Interfaces.Element1D;
          parameter Modelica.SIunits.ThermalConductance G
          "Constant thermal conductance of material";

        equation
          Q_flow = G*dT;
          annotation (
            Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                    100,100}}), graphics={
                Rectangle(
                  extent={{-90,70},{90,-70}},
                  lineColor={0,0,0},
                  pattern=LinePattern.None,
                  fillColor={192,192,192},
                  fillPattern=FillPattern.Backward),
                Line(
                  points={{-90,70},{-90,-70}},
                  color={0,0,0},
                  thickness=0.5),
                Line(
                  points={{90,70},{90,-70}},
                  color={0,0,0},
                  thickness=0.5),
                Text(
                  extent={{-150,115},{150,75}},
                  textString="%name",
                  lineColor={0,0,255}),
                Text(
                  extent={{-150,-75},{150,-105}},
                  lineColor={0,0,0},
                  textString="G=%G")}),
            Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
                    {100,100}}), graphics={
                Line(
                  points={{-80,0},{80,0}},
                  color={255,0,0},
                  thickness=0.5,
                  arrow={Arrow.None,Arrow.Filled}),
                Text(
                  extent={{-100,-20},{100,-40}},
                  lineColor={255,0,0},
                  textString="Q_flow"),
                Text(
                  extent={{-100,40},{100,20}},
                  lineColor={0,0,0},
                  textString="dT = port_a.T - port_b.T")}),
            Documentation(info="<HTML>
<p>
This is a model for transport of heat without storing it; see also:
<a href=\"modelica://Modelica.Thermal.HeatTransfer.Components.ThermalResistor\">ThermalResistor</a>.
It may be used for complicated geometries where
the thermal conductance G (= inverse of thermal resistance)
is determined by measurements and is assumed to be constant
over the range of operations. If the component consists mainly of
one type of material and a regular geometry, it may be calculated,
e.g., with one of the following equations:
</p>
<ul>
<li><p>
    Conductance for a <b>box</b> geometry under the assumption
    that heat flows along the box length:</p>
    <pre>
    G = k*A/L
    k: Thermal conductivity (material constant)
    A: Area of box
    L: Length of box
    </pre>
    </li>
<li><p>
    Conductance for a <b>cylindrical</b> geometry under the assumption
    that heat flows from the inside to the outside radius
    of the cylinder:</p>
    <pre>
    G = 2*pi*k*L/log(r_out/r_in)
    pi   : Modelica.Constants.pi
    k    : Thermal conductivity (material constant)
    L    : Length of cylinder
    log  : Modelica.Math.log;
    r_out: Outer radius of cylinder
    r_in : Inner radius of cylinder
    </pre>
    </li>
</ul>
<pre>
    Typical values for k at 20 degC in W/(m.K):
      aluminium   220
      concrete      1
      copper      384
      iron         74
      silver      407
      steel        45 .. 15 (V2A)
      wood         0.1 ... 0.2
</pre>
</html>"));
        end ThermalConductor;
        annotation (Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100,-100},{100,100}}), graphics = {
          Rectangle(
            origin=  {12,40},
            fillColor=  {192,192,192},
            fillPattern=  FillPattern.Backward,
            extent=  {{-100,-100},{-70,18}}),
          Line(
            origin=  {12,40},
            points=  {{-44,16},{-44,-100}},
            color=  {0,127,255}),
          Line(
            origin=  {12,40},
            points=  {{-4,16},{-4,-100}},
            color=  {0,127,255}),
          Line(
            origin=  {12,40},
            points=  {{30,18},{30,-100}},
            color=  {0,127,255}),
          Line(
            origin=  {12,40},
            points=  {{66,18},{66,-100}},
            color=  {0,127,255}),
          Line(
            origin=  {12,40},
            points=  {{66,-100},{76,-80}},
            color=  {0,127,255}),
          Line(
            origin=  {12,40},
            points=  {{66,-100},{56,-80}},
            color=  {0,127,255}),
          Line(
            origin=  {12,40},
            points=  {{30,-100},{40,-80}},
            color=  {0,127,255}),
          Line(
            origin=  {12,40},
            points=  {{30,-100},{20,-80}},
            color=  {0,127,255}),
          Line(
            origin=  {12,40},
            points=  {{-4,-100},{6,-80}},
            color=  {0,127,255}),
          Line(
            origin=  {12,40},
            points=  {{-4,-100},{-14,-80}},
            color=  {0,127,255}),
          Line(
            origin=  {12,40},
            points=  {{-44,-100},{-34,-80}},
            color=  {0,127,255}),
          Line(
            origin=  {12,40},
            points=  {{-44,-100},{-54,-80}},
            color=  {0,127,255}),
          Line(
            origin=  {12,40},
            points=  {{-70,-60},{66,-60}},
            color=  {191,0,0}),
          Line(
            origin=  {12,40},
            points=  {{46,-70},{66,-60}},
            color=  {191,0,0}),
          Line(
            origin=  {12,40},
            points=  {{46,-50},{66,-60}},
            color=  {191,0,0}),
          Line(
            origin=  {12,40},
            points=  {{46,-30},{66,-20}},
            color=  {191,0,0}),
          Line(
            origin=  {12,40},
            points=  {{46,-10},{66,-20}},
            color=  {191,0,0}),
          Line(
            origin=  {12,40},
            points=  {{-70,-20},{66,-20}},
            color=  {191,0,0})}), Documentation(
              info="<html>

</html>"));
      end Components;

      package Sources "Thermal sources"
      extends Modelica.Icons.SourcesPackage;

        model FixedTemperature "Fixed temperature boundary condition in Kelvin"

          parameter Modelica.SIunits.Temperature T "Fixed temperature at port";
          Interfaces.HeatPort_b port annotation (Placement(transformation(extent={{90,
                    -10},{110,10}}, rotation=0)));
        equation
          port.T = T;
          annotation (
            Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                    100,100}}), graphics={
                Text(
                  extent={{-150,150},{150,110}},
                  textString="%name",
                  lineColor={0,0,255}),
                Text(
                  extent={{-150,-110},{150,-140}},
                  lineColor={0,0,0},
                  textString="T=%T"),
                Rectangle(
                  extent={{-100,100},{100,-100}},
                  lineColor={0,0,0},
                  pattern=LinePattern.None,
                  fillColor={159,159,223},
                  fillPattern=FillPattern.Backward),
                Text(
                  extent={{0,0},{-100,-100}},
                  lineColor={0,0,0},
                  textString="K"),
                Line(
                  points={{-52,0},{56,0}},
                  color={191,0,0},
                  thickness=0.5),
                Polygon(
                  points={{50,-20},{50,20},{90,0},{50,-20}},
                  lineColor={191,0,0},
                  fillColor={191,0,0},
                  fillPattern=FillPattern.Solid)}),
            Documentation(info="<HTML>
<p>
This model defines a fixed temperature T at its port in Kelvin,
i.e., it defines a fixed temperature as a boundary condition.
</p>
</html>"),         Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                    100,100}}), graphics={
                Rectangle(
                  extent={{-100,100},{100,-101}},
                  lineColor={0,0,0},
                  pattern=LinePattern.None,
                  fillColor={159,159,223},
                  fillPattern=FillPattern.Backward),
                Line(
                  points={{-52,0},{56,0}},
                  color={191,0,0},
                  thickness=0.5),
                Text(
                  extent={{0,0},{-100,-100}},
                  lineColor={0,0,0},
                  textString="K"),
                Polygon(
                  points={{52,-20},{52,20},{90,0},{52,-20}},
                  lineColor={191,0,0},
                  fillColor={191,0,0},
                  fillPattern=FillPattern.Solid)}));
        end FixedTemperature;

        model PrescribedTemperature
        "Variable temperature boundary condition in Kelvin"

          Interfaces.HeatPort_b port annotation (Placement(transformation(extent={{90,
                    -10},{110,10}}, rotation=0)));
          Modelica.Blocks.Interfaces.RealInput T(unit="K") annotation (Placement(transformation(
                  extent={{-140,-20},{-100,20}}, rotation=0)));
        equation
          port.T = T;
          annotation (
            Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                    100,100}}), graphics={
                Rectangle(
                  extent={{-100,100},{100,-100}},
                  lineColor={0,0,0},
                  pattern=LinePattern.None,
                  fillColor={159,159,223},
                  fillPattern=FillPattern.Backward),
                Line(
                  points={{-102,0},{64,0}},
                  color={191,0,0},
                  thickness=0.5),
                Text(
                  extent={{0,0},{-100,-100}},
                  lineColor={0,0,0},
                  textString="K"),
                Text(
                  extent={{-150,150},{150,110}},
                  textString="%name",
                  lineColor={0,0,255}),
                Polygon(
                  points={{50,-20},{50,20},{90,0},{50,-20}},
                  lineColor={191,0,0},
                  fillColor={191,0,0},
                  fillPattern=FillPattern.Solid)}),
            Documentation(info="<HTML>
<p>
This model represents a variable temperature boundary condition.
The temperature in [K] is given as input signal <b>T</b>
to the model. The effect is that an instance of this model acts as
an infinite reservoir able to absorb or generate as much energy
as required to keep the temperature at the specified value.
</p>
</html>"),         Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                    100,100}}), graphics={
                Rectangle(
                  extent={{-100,100},{100,-100}},
                  lineColor={0,0,0},
                  pattern=LinePattern.None,
                  fillColor={159,159,223},
                  fillPattern=FillPattern.Backward),
                Text(
                  extent={{0,0},{-100,-100}},
                  lineColor={0,0,0},
                  textString="K"),
                Line(
                  points={{-102,0},{64,0}},
                  color={191,0,0},
                  thickness=0.5),
                Polygon(
                  points={{52,-20},{52,20},{90,0},{52,-20}},
                  lineColor={191,0,0},
                  fillColor={191,0,0},
                  fillPattern=FillPattern.Solid)}));
        end PrescribedTemperature;
        annotation (   Documentation(info="<html>

</html>"));
      end Sources;

      package Interfaces "Connectors and partial models"
        extends Modelica.Icons.InterfacesPackage;

        partial connector HeatPort "Thermal port for 1-dim. heat transfer"
          Modelica.SIunits.Temperature T "Port temperature";
          flow Modelica.SIunits.HeatFlowRate Q_flow
          "Heat flow rate (positive if flowing from outside into the component)";
          annotation (Documentation(info="<html>

</html>"));
        end HeatPort;

        connector HeatPort_a
        "Thermal port for 1-dim. heat transfer (filled rectangular icon)"

          extends HeatPort;

          annotation(defaultComponentName = "port_a",
            Documentation(info="<HTML>
<p>This connector is used for 1-dimensional heat flow between components.
The variables in the connector are:</p>
<pre>
   T       Temperature in [Kelvin].
   Q_flow  Heat flow rate in [Watt].
</pre>
<p>According to the Modelica sign convention, a <b>positive</b> heat flow
rate <b>Q_flow</b> is considered to flow <b>into</b> a component. This
convention has to be used whenever this connector is used in a model
class.</p>
<p>Note, that the two connector classes <b>HeatPort_a</b> and
<b>HeatPort_b</b> are identical with the only exception of the different
<b>icon layout</b>.</p></html>"),         Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                    100,100}}), graphics={Rectangle(
                  extent={{-100,100},{100,-100}},
                  lineColor={191,0,0},
                  fillColor={191,0,0},
                  fillPattern=FillPattern.Solid)}),
            Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
                    {100,100}}), graphics={Rectangle(
                  extent={{-50,50},{50,-50}},
                  lineColor={191,0,0},
                  fillColor={191,0,0},
                  fillPattern=FillPattern.Solid), Text(
                  extent={{-120,120},{100,60}},
                  lineColor={191,0,0},
                  textString="%name")}));
        end HeatPort_a;

        connector HeatPort_b
        "Thermal port for 1-dim. heat transfer (unfilled rectangular icon)"

          extends HeatPort;

          annotation(defaultComponentName = "port_b",
            Documentation(info="<HTML>
<p>This connector is used for 1-dimensional heat flow between components.
The variables in the connector are:</p>
<pre>
   T       Temperature in [Kelvin].
   Q_flow  Heat flow rate in [Watt].
</pre>
<p>According to the Modelica sign convention, a <b>positive</b> heat flow
rate <b>Q_flow</b> is considered to flow <b>into</b> a component. This
convention has to be used whenever this connector is used in a model
class.</p>
<p>Note, that the two connector classes <b>HeatPort_a</b> and
<b>HeatPort_b</b> are identical with the only exception of the different
<b>icon layout</b>.</p></html>"),         Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
                    {100,100}}), graphics={Rectangle(
                  extent={{-50,50},{50,-50}},
                  lineColor={191,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid), Text(
                  extent={{-100,120},{120,60}},
                  lineColor={191,0,0},
                  textString="%name")}),
            Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                    100,100}}), graphics={Rectangle(
                  extent={{-100,100},{100,-100}},
                  lineColor={191,0,0},
                  fillColor={255,255,255},
                  fillPattern=FillPattern.Solid)}));
        end HeatPort_b;

        partial model Element1D
        "Partial heat transfer element with two HeatPort connectors that does not store energy"

          Modelica.SIunits.HeatFlowRate Q_flow
          "Heat flow rate from port_a -> port_b";
          Modelica.SIunits.TemperatureDifference dT "port_a.T - port_b.T";
      public
          HeatPort_a port_a annotation (Placement(transformation(extent={{-110,-10},
                    {-90,10}}, rotation=0)));
          HeatPort_b port_b annotation (Placement(transformation(extent={{90,-10},{
                    110,10}}, rotation=0)));
        equation
          dT = port_a.T - port_b.T;
          port_a.Q_flow = Q_flow;
          port_b.Q_flow = -Q_flow;
          annotation (Documentation(info="<HTML>
<p>
This partial model contains the basic connectors and variables to
allow heat transfer models to be created that <b>do not store energy</b>,
This model defines and includes equations for the temperature
drop across the element, <b>dT</b>, and the heat flow rate
through the element from port_a to port_b, <b>Q_flow</b>.
</p>
<p>
By extending this model, it is possible to write simple
constitutive equations for many types of heat transfer components.
</p>
</html>"));
        end Element1D;
        annotation (                               Documentation(info="<html>

</html>"));
      end Interfaces;
      annotation (
         Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100,-100},{100,100}}), graphics = {
          Polygon(
            origin=  {13.758,27.517},
            lineColor=  {128,128,128},
            fillColor=  {192,192,192},
            fillPattern=  FillPattern.Solid,
            points=  {{-54,-6},{-61,-7},{-75,-15},{-79,-24},{-80,-34},{-78,-42},{-73,-49},{-64,-51},{-57,-51},{-47,-50},{-41,-43},{-38,-35},{-40,-27},{-40,-20},{-42,-13},{-47,-7},{-54,-5},{-54,-6}}),
        Polygon(
            origin=  {13.758,27.517},
            fillColor=  {160,160,164},
            fillPattern=  FillPattern.Solid,
            points=  {{-75,-15},{-79,-25},{-80,-34},{-78,-42},{-72,-49},{-64,-51},{-57,-51},{-47,-50},{-57,-47},{-65,-45},{-71,-40},{-74,-33},{-76,-23},{-75,-15},{-75,-15}}),
          Polygon(
            origin=  {13.758,27.517},
            lineColor=  {160,160,164},
            fillColor=  {192,192,192},
            fillPattern=  FillPattern.Solid,
            points=  {{39,-6},{32,-7},{18,-15},{14,-24},{13,-34},{15,-42},{20,-49},{29,-51},{36,-51},{46,-50},{52,-43},{55,-35},{53,-27},{53,-20},{51,-13},{46,-7},{39,-5},{39,-6}}),
          Polygon(
            origin=  {13.758,27.517},
            fillColor=  {160,160,164},
            fillPattern=  FillPattern.Solid,
            points=  {{18,-15},{14,-25},{13,-34},{15,-42},{21,-49},{29,-51},{36,-51},{46,-50},{36,-47},{28,-45},{22,-40},{19,-33},{17,-23},{18,-15},{18,-15}}),
          Polygon(
            origin=  {13.758,27.517},
            lineColor=  {191,0,0},
            fillColor=  {191,0,0},
            fillPattern=  FillPattern.Solid,
            points=  {{-9,-23},{-9,-10},{18,-17},{-9,-23}}),
          Line(
            origin=  {13.758,27.517},
            points=  {{-41,-17},{-9,-17}},
            color=  {191,0,0},
            thickness=  0.5),
          Line(
            origin=  {13.758,27.517},
            points=  {{-17,-40},{15,-40}},
            color=  {191,0,0},
            thickness=  0.5),
          Polygon(
            origin=  {13.758,27.517},
            lineColor=  {191,0,0},
            fillColor=  {191,0,0},
            fillPattern=  FillPattern.Solid,
            points=  {{-17,-46},{-17,-34},{-40,-40},{-17,-46}})}),
                                Documentation(info="<HTML>
<p>
This package contains components to model <b>1-dimensional heat transfer</b>
with lumped elements. This allows especially to model heat transfer in
machines provided the parameters of the lumped elements, such as
the heat capacity of a part, can be determined by measurements
(due to the complex geometries and many materials used in machines,
calculating the lumped element parameters from some basic analytic
formulas is usually not possible).
</p>
<p>
Example models how to use this library are given in subpackage <b>Examples</b>.<br>
For a first simple example, see <b>Examples.TwoMasses</b> where two masses
with different initial temperatures are getting in contact to each
other and arriving after some time at a common temperature.<br>
<b>Examples.ControlledTemperature</b> shows how to hold a temperature
within desired limits by switching on and off an electric resistor.<br>
A more realistic example is provided in <b>Examples.Motor</b> where the
heating of an electrical motor is modelled, see the following screen shot
of this example:
</p>

<p>
<img src=\"modelica://Modelica/Resources/Images/Thermal/HeatTransfer/driveWithHeatTransfer.png\" ALT=\"driveWithHeatTransfer\">
</p>

<p>
The <b>filled</b> and <b>non-filled red squares</b> at the left and
right side of a component represent <b>thermal ports</b> (connector HeatPort).
Drawing a line between such squares means that they are thermally connected.
The variables of a HeatPort connector are the temperature <b>T</b> at the port
and the heat flow rate <b>Q_flow</b> flowing into the component (if Q_flow is positive,
the heat flows into the element, otherwise it flows out of the element):
</p>
<pre>   Modelica.SIunits.Temperature  T  \"absolute temperature at port in Kelvin\";
   Modelica.SIunits.HeatFlowRate Q_flow  \"flow rate at the port in Watt\";
</pre>
<p>
Note, that all temperatures of this package, including initial conditions,
are given in Kelvin. For convenience, in subpackages <b>HeatTransfer.Celsius</b>,
 <b>HeatTransfer.Fahrenheit</b> and <b>HeatTransfer.Rankine</b> components are provided such that source and
sensor information is available in degree Celsius, degree Fahrenheit, or degree Rankine,
respectively. Additionally, in package <b>SIunits.Conversions</b> conversion
functions between the units Kelvin and Celsius, Fahrenheit, Rankine are
provided. These functions may be used in the following way:
</p>
<pre>  <b>import</b> SI=Modelica.SIunits;
  <b>import</b> Modelica.SIunits.Conversions.*;
     ...
  <b>parameter</b> SI.Temperature T = from_degC(25);  // convert 25 degree Celsius to Kelvin
</pre>

<p>
There are several other components available, such as AxialConduction (discretized PDE in
axial direction), which have been temporarily removed from this library. The reason is that
these components reference material properties, such as thermal conductivity, and currently
the Modelica design group is discussing a general scheme to describe material properties.
</p>
<p>
For technical details in the design of this library, see the following reference:<br>
<b>Michael Tiller (2001)</b>: <a href=\"http://www.amazon.de\">
Introduction to Physical Modeling with Modelica</a>.
Kluwer Academic Publishers Boston.
</p>
<p>
<b>Acknowledgements:</b><br>
Several helpful remarks from the following persons are acknowledged:
John Batteh, Ford Motors, Dearborn, U.S.A;
<a href=\"http://www.haumer.at/\">Anton Haumer</a>, Technical Consulting &amp; Electrical Engineering, Austria;
Ludwig Marvan, VA TECH ELIN EBG Elektronik GmbH, Wien, Austria;
Hans Olsson, Dassault Syst&egrave;mes AB, Sweden;
Hubertus Tummescheit, Lund Institute of Technology, Lund, Sweden.
</p>
<dl>
  <dt><b>Main Authors:</b></dt>
  <dd>
  <p>
  <a href=\"http://www.haumer.at/\">Anton Haumer</a><br>
  Technical Consulting &amp; Electrical Engineering<br>
  A-3423 St.Andrae-Woerdern, Austria<br>
  email: <a href=\"mailto:a.haumer@haumer.at\">a.haumer@haumer.at</a>
</p>
  </dd>
</dl>
<p><b>Copyright &copy; 2001-2013, Modelica Association, Michael Tiller and DLR.</b></p>

<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"https://www.modelica.org/licenses/ModelicaLicense2\"> https://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>
</html>",     revisions="<html>
<ul>
<li><i>July 15, 2002</i>
       by Michael Tiller, <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>
       and Nikolaus Sch&uuml;rmann:<br>
       Implemented.
</li>
<li><i>June 13, 2005</i>
       by <a href=\"http://www.haumer.at/\">Anton Haumer</a><br>
       Refined placing of connectors (cosmetic).<br>
       Refined all Examples; removed Examples.FrequencyInverter, introducing Examples.Motor<br>
       Introduced temperature dependent correction (1 + alpha*(T - T_ref)) in Fixed/PrescribedHeatFlow<br>
</li>
  <li> v1.1.1 2007/11/13 Anton Haumer<br>
       components moved to sub-packages</li>
  <li> v1.2.0 2009/08/26 Anton Haumer<br>
       added component ThermalCollector</li>

</ul>
</html>"));
    end HeatTransfer;
    annotation (
     Icon(coordinateSystem(extent={{-100.0,-100.0},{100.0,100.0}}), graphics={
      Line(
      origin={-47.5,11.6667},
      points={{-2.5,-91.6667},{17.5,-71.6667},{-22.5,-51.6667},{17.5,-31.6667},{-22.5,-11.667},{17.5,8.3333},{-2.5,28.3333},{-2.5,48.3333}},
        smooth=Smooth.Bezier),
      Polygon(
      origin={-50.0,68.333},
      pattern=LinePattern.None,
      fillPattern=FillPattern.Solid,
        points={{0.0,21.667},{-10.0,-8.333},{10.0,-8.333}}),
      Line(
      origin={2.5,11.6667},
      points={{-2.5,-91.6667},{17.5,-71.6667},{-22.5,-51.6667},{17.5,-31.6667},{-22.5,-11.667},{17.5,8.3333},{-2.5,28.3333},{-2.5,48.3333}},
        smooth=Smooth.Bezier),
      Polygon(
      origin={0.0,68.333},
      pattern=LinePattern.None,
      fillPattern=FillPattern.Solid,
        points={{0.0,21.667},{-10.0,-8.333},{10.0,-8.333}}),
      Line(
      origin={52.5,11.6667},
      points={{-2.5,-91.6667},{17.5,-71.6667},{-22.5,-51.6667},{17.5,-31.6667},{-22.5,-11.667},{17.5,8.3333},{-2.5,28.3333},{-2.5,48.3333}},
        smooth=Smooth.Bezier),
      Polygon(
      origin={50.0,68.333},
      pattern=LinePattern.None,
      fillPattern=FillPattern.Solid,
        points={{0.0,21.667},{-10.0,-8.333},{10.0,-8.333}})}),
      Documentation(info="<html>
<p>
This package contains libraries to model heat transfer
and fluid heat flow.
</p>
</html>"));
  end Thermal;

  package Math
  "Library of mathematical functions (e.g., sin, cos) and of functions operating on vectors and matrices"
  import SI = Modelica.SIunits;
  extends Modelica.Icons.Package;

  package Icons "Icons for Math"
    extends Modelica.Icons.IconsPackage;

    partial function AxisLeft
    "Basic icon for mathematical function with y-axis on left side"

      annotation (
        Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
                100}}), graphics={
            Rectangle(
              extent={{-100,100},{100,-100}},
              lineColor={0,0,0},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Line(points={{-80,-80},{-80,68}}, color={192,192,192}),
            Polygon(
              points={{-80,90},{-88,68},{-72,68},{-80,90}},
              lineColor={192,192,192},
              fillColor={192,192,192},
              fillPattern=FillPattern.Solid),
            Text(
              extent={{-150,150},{150,110}},
              textString="%name",
              lineColor={0,0,255})}),
        Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
                100,100}}), graphics={Line(points={{-80,80},{-88,80}}, color={95,
              95,95}),Line(points={{-80,-80},{-88,-80}}, color={95,95,95}),Line(
              points={{-80,-90},{-80,84}}, color={95,95,95}),Text(
                  extent={{-75,104},{-55,84}},
                  lineColor={95,95,95},
                  textString="y"),Polygon(
                  points={{-80,98},{-86,82},{-74,82},{-80,98}},
                  lineColor={95,95,95},
                  fillColor={95,95,95},
                  fillPattern=FillPattern.Solid)}),
        Documentation(info="<html>
<p>
Icon for a mathematical function, consisting of an y-axis on the left side.
It is expected, that an x-axis is added and a plot of the function.
</p>
</html>"));
    end AxisLeft;

    partial function AxisCenter
    "Basic icon for mathematical function with y-axis in the center"

      annotation (
        Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
                100}}), graphics={
            Rectangle(
              extent={{-100,100},{100,-100}},
              lineColor={0,0,0},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid),
            Line(points={{0,-80},{0,68}}, color={192,192,192}),
            Polygon(
              points={{0,90},{-8,68},{8,68},{0,90}},
              lineColor={192,192,192},
              fillColor={192,192,192},
              fillPattern=FillPattern.Solid),
            Text(
              extent={{-150,150},{150,110}},
              textString="%name",
              lineColor={0,0,255})}),
        Diagram(graphics={Line(points={{0,80},{-8,80}}, color={95,95,95}),Line(
              points={{0,-80},{-8,-80}}, color={95,95,95}),Line(points={{0,-90},{
              0,84}}, color={95,95,95}),Text(
                  extent={{5,104},{25,84}},
                  lineColor={95,95,95},
                  textString="y"),Polygon(
                  points={{0,98},{-6,82},{6,82},{0,98}},
                  lineColor={95,95,95},
                  fillColor={95,95,95},
                  fillPattern=FillPattern.Solid)}),
        Documentation(info="<html>
<p>
Icon for a mathematical function, consisting of an y-axis in the middle.
It is expected, that an x-axis is added and a plot of the function.
</p>
</html>"));
    end AxisCenter;
  end Icons;

  package Vectors "Library of functions operating on vectors"
    extends Modelica.Icons.Package;

    function interpolate "Interpolate in a vector"
      extends Modelica.Icons.Function;
      input Real x[:]
      "Abscissa table vector (strict monotonically increasing values required)";
      input Real y[size(x, 1)] "Ordinate table vector";
      input Real xi "Desired abscissa value";
      input Integer iLast=1 "Index used in last search";
      output Real yi "Ordinate value corresponding to xi";
      output Integer iNew=1 "xi is in the interval x[iNew] <= xi < x[iNew+1]";
  protected
      Integer i;
      Integer nx=size(x, 1);
      Real x1;
      Real x2;
      Real y1;
      Real y2;
    algorithm
      assert(nx > 0, "The table vectors must have at least 1 entry.");
      if nx == 1 then
        yi := y[1];
      else
        // Search interval
        i := min(max(iLast, 1), nx - 1);
        if xi >= x[i] then
          // search forward
          while i < nx and xi >= x[i] loop
            i := i + 1;
          end while;
          i := i - 1;
        else
          // search backward
          while i > 1 and xi < x[i] loop
            i := i - 1;
          end while;
        end if;

        // Get interpolation data
        x1 := x[i];
        x2 := x[i + 1];
        y1 := y[i];
        y2 := y[i + 1];

        assert(x2 > x1, "Abscissa table vector values must be increasing");
        // Interpolate
        yi := y1 + (y2 - y1)*(xi - x1)/(x2 - x1);
        iNew := i;
      end if;

      annotation (Documentation(info="<html>
<h4>Syntax</h4>
<blockquote><pre>
// Real    x[:], y[:], xi, yi;
// Integer iLast, iNew;
        yi = Vectors.<b>interpolate</b>(x,y,xi);
(yi, iNew) = Vectors.<b>interpolate</b>(x,y,xi,iLast=1);
</pre></blockquote>
<h4>Description</h4>
<p>
The function call \"<code>Vectors.interpolate(x,y,xi)</code>\" interpolates in vectors
(x,y) and returns the value yi that corresponds to xi. Vector x[:] must consist
of strictly monotonically increasing values. If xi &lt; x[1] or &gt; x[end], then
extrapolation takes places through the first or last two x[:] values, respectively.
The search for the interval x[iNew] &le; xi &lt; x[iNew+1] starts at the optional
input argument \"iLast\". The index \"iNew\" is returned as output argument.
The usage of \"iLast\" and \"iNew\" is useful to increase the efficiency of the call,
if many interpolations take place.
</p>

<h4>Example</h4>

<blockquote><pre>
  Real x[:] = { 0,  2,  4,  6,  8, 10};
  Real y[:] = {10, 20, 30, 40, 50, 60};
<b>algorithm</b>
  (yi, iNew) := Vectors.interpolate(x,y,5);  // yi = 35, iNew=3
</pre></blockquote>

</html>"));
    end interpolate;
    annotation (preferredView="info", Documentation(info="<HTML>
<h4>Library content</h4>
<p>
This library provides functions operating on vectors:
</p>

<ul>
<li> <a href=\"modelica://Modelica.Math.Vectors.toString\">toString</a>(v)
     - returns the string representation of vector v.</li>

<li> <a href=\"modelica://Modelica.Math.Vectors.isEqual\">isEqual</a>(v1, v2)
     - returns true if vectors v1 and v2 have the same size and the same elements.</li>

<li> <a href=\"modelica://Modelica.Math.Vectors.norm\">norm</a>(v,p)
     - returns the p-norm of vector v.</li>

<li> <a href=\"modelica://Modelica.Math.Vectors.length\">length</a>(v)
     - returns the length of vector v (= norm(v,2), but inlined and therefore usable in
       symbolic manipulations)</li>

<li> <a href=\"modelica://Modelica.Math.Vectors.normalize\">normalize</a>(v)
     - returns vector in direction of v with lenght = 1 and prevents
       zero-division for zero vector.</li>

<li> <a href=\"modelica://Modelica.Math.Vectors.reverse\">reverse</a>(v)
     - reverses the vector elements of v. </li>

<li> <a href=\"modelica://Modelica.Math.Vectors.sort\">sort</a>(v)
     - sorts the elements of vector v in ascending or descending order.</li>

<li> <a href=\"modelica://Modelica.Math.Vectors.find\">find</a>(e, v)
     - returns the index of the first occurrence of scalar e in vector v.</li>

<li> <a href=\"modelica://Modelica.Math.Vectors.interpolate\">interpolate</a>(x, y, xi)
     - returns the interpolated value in (x,y) that corresponds to xi.</li>

<li> <a href=\"modelica://Modelica.Math.Vectors.relNodePositions\">relNodePositions</a>(nNodes)
     - returns a vector of relative node positions (0..1).</li>
</ul>

<h4>See also</h4>
<a href=\"modelica://Modelica.Math.Matrices\">Matrices</a>
</HTML>"));
  end Vectors;

  function sin "Sine"
    extends Modelica.Math.Icons.AxisLeft;
    input Modelica.SIunits.Angle u;
    output Real y;

  external "builtin" y=  sin(u);
    annotation (
      Icon(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics={
          Line(points={{-90,0},{68,0}}, color={192,192,192}),
          Polygon(
            points={{90,0},{68,8},{68,-8},{90,0}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),
          Line(points={{-80,0},{-68.7,34.2},{-61.5,53.1},{-55.1,66.4},{-49.4,74.6},
                {-43.8,79.1},{-38.2,79.8},{-32.6,76.6},{-26.9,69.7},{-21.3,59.4},
                {-14.9,44.1},{-6.83,21.2},{10.1,-30.8},{17.3,-50.2},{23.7,-64.2},
                {29.3,-73.1},{35,-78.4},{40.6,-80},{46.2,-77.6},{51.9,-71.5},{
                57.5,-61.9},{63.9,-47.2},{72,-24.8},{80,0}}, color={0,0,0}),
          Text(
            extent={{12,84},{84,36}},
            lineColor={192,192,192},
            textString="sin")}),
      Diagram(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics={Line(points={{-100,0},{84,0}}, color={95,95,95}),
            Polygon(
              points={{100,0},{84,6},{84,-6},{100,0}},
              lineColor={95,95,95},
              fillColor={95,95,95},
              fillPattern=FillPattern.Solid),Line(
              points={{-80,0},{-68.7,34.2},{-61.5,53.1},{-55.1,66.4},{-49.4,74.6},
              {-43.8,79.1},{-38.2,79.8},{-32.6,76.6},{-26.9,69.7},{-21.3,59.4},{-14.9,
              44.1},{-6.83,21.2},{10.1,-30.8},{17.3,-50.2},{23.7,-64.2},{29.3,-73.1},
              {35,-78.4},{40.6,-80},{46.2,-77.6},{51.9,-71.5},{57.5,-61.9},{63.9,
              -47.2},{72,-24.8},{80,0}},
              color={0,0,255},
              thickness=0.5),Text(
              extent={{-105,72},{-85,88}},
              textString="1",
              lineColor={0,0,255}),Text(
              extent={{70,25},{90,5}},
              textString="2*pi",
              lineColor={0,0,255}),Text(
              extent={{-103,-72},{-83,-88}},
              textString="-1",
              lineColor={0,0,255}),Text(
              extent={{82,-6},{102,-26}},
              lineColor={95,95,95},
              textString="u"),Line(
              points={{-80,80},{-28,80}},
              color={175,175,175},
              smooth=Smooth.None),Line(
              points={{-80,-80},{50,-80}},
              color={175,175,175},
              smooth=Smooth.None)}),
      Documentation(info="<html>
<p>
This function returns y = sin(u), with -&infin; &lt; u &lt; &infin;:
</p>

<p>
<img src=\"modelica://Modelica/Resources/Images/Math/sin.png\">
</p>
</html>"));
  end sin;

  function cos "Cosine"
    extends Modelica.Math.Icons.AxisLeft;
    input SI.Angle u;
    output Real y;

  external "builtin" y=  cos(u);
    annotation (
      Icon(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics={
          Line(points={{-90,0},{68,0}}, color={192,192,192}),
          Polygon(
            points={{90,0},{68,8},{68,-8},{90,0}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),
          Line(points={{-80,80},{-74.4,78.1},{-68.7,72.3},{-63.1,63},{-56.7,48.7},
                {-48.6,26.6},{-29.3,-32.5},{-22.1,-51.7},{-15.7,-65.3},{-10.1,-73.8},
                {-4.42,-78.8},{1.21,-79.9},{6.83,-77.1},{12.5,-70.6},{18.1,-60.6},
                {24.5,-45.7},{32.6,-23},{50.3,31.3},{57.5,50.7},{63.9,64.6},{69.5,
                73.4},{75.2,78.6},{80,80}}, color={0,0,0}),
          Text(
            extent={{-36,82},{36,34}},
            lineColor={192,192,192},
            textString="cos")}),
      Diagram(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics={Text(
              extent={{-103,72},{-83,88}},
              textString="1",
              lineColor={0,0,255}),Text(
              extent={{-103,-72},{-83,-88}},
              textString="-1",
              lineColor={0,0,255}),Text(
              extent={{70,25},{90,5}},
              textString="2*pi",
              lineColor={0,0,255}),Line(points={{-100,0},{84,0}}, color={95,95,95}),
            Polygon(
              points={{98,0},{82,6},{82,-6},{98,0}},
              lineColor={95,95,95},
              fillColor={95,95,95},
              fillPattern=FillPattern.Solid),Line(
              points={{-80,80},{-74.4,78.1},{-68.7,72.3},{-63.1,63},{-56.7,48.7},
              {-48.6,26.6},{-29.3,-32.5},{-22.1,-51.7},{-15.7,-65.3},{-10.1,-73.8},
              {-4.42,-78.8},{1.21,-79.9},{6.83,-77.1},{12.5,-70.6},{18.1,-60.6},{
              24.5,-45.7},{32.6,-23},{50.3,31.3},{57.5,50.7},{63.9,64.6},{69.5,
              73.4},{75.2,78.6},{80,80}},
              color={0,0,255},
              thickness=0.5),Text(
              extent={{78,-6},{98,-26}},
              lineColor={95,95,95},
              textString="u"),Line(
              points={{-80,-80},{18,-80}},
              color={175,175,175},
              smooth=Smooth.None)}),
      Documentation(info="<html>
<p>
This function returns y = cos(u), with -&infin; &lt; u &lt; &infin;:
</p>

<p>
<img src=\"modelica://Modelica/Resources/Images/Math/cos.png\">
</p>
</html>"));
  end cos;

  function tan "Tangent (u shall not be -pi/2, pi/2, 3*pi/2, ...)"
    extends Modelica.Math.Icons.AxisCenter;
    input SI.Angle u;
    output Real y;

  external "builtin" y=  tan(u);
    annotation (
      Icon(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics={
          Line(points={{-90,0},{68,0}}, color={192,192,192}),
          Polygon(
            points={{90,0},{68,8},{68,-8},{90,0}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),
          Line(points={{-80,-80},{-78.4,-68.4},{-76.8,-59.7},{-74.4,-50},{-71.2,-40.9},
                {-67.1,-33},{-60.7,-24.8},{-51.1,-17.2},{-35.8,-9.98},{-4.42,-1.07},
                {33.4,9.12},{49.4,16.2},{59.1,23.2},{65.5,30.6},{70.4,39.1},{73.6,
                47.4},{76,56.1},{77.6,63.8},{80,80}}, color={0,0,0}),
          Text(
            extent={{-90,72},{-18,24}},
            lineColor={192,192,192},
            textString="tan")}),
      Diagram(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics={Text(
              extent={{-37,-72},{-17,-88}},
              textString="-5.8",
              lineColor={0,0,255}),Text(
              extent={{-33,86},{-13,70}},
              textString=" 5.8",
              lineColor={0,0,255}),Text(
              extent={{68,-13},{88,-33}},
              textString="1.4",
              lineColor={0,0,255}),Line(points={{-100,0},{84,0}}, color={95,95,95}),
            Polygon(
              points={{98,0},{82,6},{82,-6},{98,0}},
              lineColor={95,95,95},
              fillColor={95,95,95},
              fillPattern=FillPattern.Solid),Line(
              points={{-80,-80},{-78.4,-68.4},{-76.8,-59.7},{-74.4,-50},{-71.2,-40.9},
              {-67.1,-33},{-60.7,-24.8},{-51.1,-17.2},{-35.8,-9.98},{-4.42,-1.07},
              {33.4,9.12},{49.4,16.2},{59.1,23.2},{65.5,30.6},{70.4,39.1},{73.6,
              47.4},{76,56.1},{77.6,63.8},{80,80}},
              color={0,0,255},
              thickness=0.5),Text(
              extent={{82,22},{102,2}},
              lineColor={95,95,95},
              textString="u"),Line(
              points={{0,80},{86,80}},
              color={175,175,175},
              smooth=Smooth.None),Line(
              points={{80,88},{80,-16}},
              color={175,175,175},
              smooth=Smooth.None)}),
      Documentation(info="<html>
<p>
This function returns y = tan(u), with -&infin; &lt; u &lt; &infin;
(if u is a multiple of (2n-1)*pi/2, y = tan(u) is +/- infinity).
</p>

<p>
<img src=\"modelica://Modelica/Resources/Images/Math/tan.png\">
</p>
</html>"));
  end tan;

  function asin "Inverse sine (-1 <= u <= 1)"
    extends Modelica.Math.Icons.AxisCenter;
    input Real u;
    output SI.Angle y;

  external "builtin" y=  asin(u);
    annotation (
      Icon(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics={
          Line(points={{-90,0},{68,0}}, color={192,192,192}),
          Polygon(
            points={{90,0},{68,8},{68,-8},{90,0}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),
          Line(points={{-80,-80},{-79.2,-72.8},{-77.6,-67.5},{-73.6,-59.4},{-66.3,
                -49.8},{-53.5,-37.3},{-30.2,-19.7},{37.4,24.8},{57.5,40.8},{68.7,
                52.7},{75.2,62.2},{77.6,67.5},{80,80}}, color={0,0,0}),
          Text(
            extent={{-88,78},{-16,30}},
            lineColor={192,192,192},
            textString="asin")}),
      Diagram(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics={Text(
              extent={{-40,-72},{-15,-88}},
              textString="-pi/2",
              lineColor={0,0,255}),Text(
              extent={{-38,88},{-13,72}},
              textString=" pi/2",
              lineColor={0,0,255}),Text(
              extent={{68,-9},{88,-29}},
              textString="+1",
              lineColor={0,0,255}),Text(
              extent={{-90,21},{-70,1}},
              textString="-1",
              lineColor={0,0,255}),Line(points={{-100,0},{84,0}}, color={95,95,95}),
            Polygon(
              points={{98,0},{82,6},{82,-6},{98,0}},
              lineColor={95,95,95},
              fillColor={95,95,95},
              fillPattern=FillPattern.Solid),Line(
              points={{-80,-80},{-79.2,-72.8},{-77.6,-67.5},{-73.6,-59.4},{-66.3,
              -49.8},{-53.5,-37.3},{-30.2,-19.7},{37.4,24.8},{57.5,40.8},{68.7,
              52.7},{75.2,62.2},{77.6,67.5},{80,80}},
              color={0,0,255},
              thickness=0.5),Text(
              extent={{82,24},{102,4}},
              lineColor={95,95,95},
              textString="u"),Line(
              points={{0,80},{86,80}},
              color={175,175,175},
              smooth=Smooth.None),Line(
              points={{80,86},{80,-10}},
              color={175,175,175},
              smooth=Smooth.None)}),
      Documentation(info="<html>
<p>
This function returns y = asin(u), with -1 &le; u &le; +1:
</p>

<p>
<img src=\"modelica://Modelica/Resources/Images/Math/asin.png\">
</p>
</html>"));
  end asin;

  function cosh "Hyperbolic cosine"
    extends Modelica.Math.Icons.AxisCenter;
    input Real u;
    output Real y;

  external "builtin" y=  cosh(u);
    annotation (
      Icon(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics={
          Line(points={{-90,-86.083},{68,-86.083}}, color={192,192,192}),
          Polygon(
            points={{90,-86.083},{68,-78.083},{68,-94.083},{90,-86.083}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),
          Line(points={{-80,80},{-77.6,61.1},{-74.4,39.3},{-71.2,20.7},{-67.1,
                1.29},{-63.1,-14.6},{-58.3,-29.8},{-52.7,-43.5},{-46.2,-55.1},{-39,
                -64.3},{-30.2,-71.7},{-18.9,-77.1},{-4.42,-79.9},{10.9,-79.1},{
                23.7,-75.2},{34.2,-68.7},{42.2,-60.6},{48.6,-51.2},{54.3,-40},{
                59.1,-27.5},{63.1,-14.6},{67.1,1.29},{71.2,20.7},{74.4,39.3},{
                77.6,61.1},{80,80}}, color={0,0,0}),
          Text(
            extent={{4,66},{66,20}},
            lineColor={192,192,192},
            textString="cosh")}),
      Diagram(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics={Line(points={{-100,-84.083},{84,-84.083}}, color=
             {95,95,95}),Polygon(
              points={{98,-84.083},{82,-78.083},{82,-90.083},{98,-84.083}},
              lineColor={95,95,95},
              fillColor={95,95,95},
              fillPattern=FillPattern.Solid),Line(
              points={{-80,80},{-77.6,61.1},{-74.4,39.3},{-71.2,20.7},{-67.1,1.29},
              {-63.1,-14.6},{-58.3,-29.8},{-52.7,-43.5},{-46.2,-55.1},{-39,-64.3},
              {-30.2,-71.7},{-18.9,-77.1},{-4.42,-79.9},{10.9,-79.1},{23.7,-75.2},
              {34.2,-68.7},{42.2,-60.6},{48.6,-51.2},{54.3,-40},{59.1,-27.5},{
              63.1,-14.6},{67.1,1.29},{71.2,20.7},{74.4,39.3},{77.6,61.1},{80,80}},
              color={0,0,255},
              thickness=0.5),Text(
              extent={{-31,72},{-11,88}},
              textString="27",
              lineColor={0,0,255}),Text(
              extent={{64,-83},{84,-103}},
              textString="4",
              lineColor={0,0,255}),Text(
              extent={{-94,-63},{-74,-83}},
              textString="-4",
              lineColor={0,0,255}),Text(
              extent={{80,-60},{100,-80}},
              lineColor={95,95,95},
              textString="u"),Line(
              points={{0,80},{88,80}},
              color={175,175,175},
              smooth=Smooth.None),Line(
              points={{80,84},{80,-90}},
              color={175,175,175},
              smooth=Smooth.None)}),
      Documentation(info="<html>
<p>
This function returns y = cosh(u), with -&infin; &lt; u &lt; &infin;:
</p>

<p>
<img src=\"modelica://Modelica/Resources/Images/Math/cosh.png\">
</p>
</html>"));
  end cosh;

  function tanh "Hyperbolic tangent"
    extends Modelica.Math.Icons.AxisCenter;
    input Real u;
    output Real y;

  external "builtin" y=  tanh(u);
    annotation (
      Icon(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics={
          Line(points={{-90,0},{68,0}}, color={192,192,192}),
          Polygon(
            points={{90,0},{68,8},{68,-8},{90,0}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),
          Line(points={{-80,-80},{-47.8,-78.7},{-35.8,-75.7},{-27.7,-70.6},{-22.1,
                -64.2},{-17.3,-55.9},{-12.5,-44.3},{-7.64,-29.2},{-1.21,-4.82},{
                6.83,26.3},{11.7,42},{16.5,54.2},{21.3,63.1},{26.9,69.9},{34.2,75},
                {45.4,78.4},{72,79.9},{80,80}}, color={0,0,0}),
          Text(
            extent={{-88,72},{-16,24}},
            lineColor={192,192,192},
            textString="tanh")}),
      Diagram(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics={Line(points={{-100,0},{84,0}}, color={95,95,
            95}),Polygon(
              points={{96,0},{80,6},{80,-6},{96,0}},
              lineColor={95,95,95},
              fillColor={95,95,95},
              fillPattern=FillPattern.Solid),Line(
              points={{-80,-80.5},{-47.8,-79.2},{-35.8,-76.2},{-27.7,-71.1},{-22.1,
              -64.7},{-17.3,-56.4},{-12.5,-44.8},{-7.64,-29.7},{-1.21,-5.32},{
              6.83,25.8},{11.7,41.5},{16.5,53.7},{21.3,62.6},{26.9,69.4},{34.2,
              74.5},{45.4,77.9},{72,79.4},{80,79.5}},
              color={0,0,255},
              thickness=0.5),Text(
              extent={{-29,72},{-9,88}},
              textString="1",
              lineColor={0,0,255}),Text(
              extent={{3,-72},{23,-88}},
              textString="-1",
              lineColor={0,0,255}),Text(
              extent={{82,-2},{102,-22}},
              lineColor={95,95,95},
              textString="u"),Line(
              points={{0,80},{88,80}},
              color={175,175,175},
              smooth=Smooth.None)}),
      Documentation(info="<html>
<p>
This function returns y = tanh(u), with -&infin; &lt; u &lt; &infin;:
</p>

<p>
<img src=\"modelica://Modelica/Resources/Images/Math/tanh.png\">
</p>
</html>"));
  end tanh;

  function asinh "Inverse of sinh (area hyperbolic sine)"
    extends Modelica.Math.Icons.AxisCenter;
    input Real u;
    output Real y;

  algorithm
    y := Modelica.Math.log(u + sqrt(u*u + 1));
    annotation (
      Icon(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics={
          Line(points={{-90,0},{68,0}}, color={192,192,192}),
          Polygon(
            points={{90,0},{68,8},{68,-8},{90,0}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),
          Line(points={{-80,-80},{-56.7,-68.4},{-39.8,-56.8},{-26.9,-44.7},{-17.3,
                -32.4},{-9.25,-19},{9.25,19},{17.3,32.4},{26.9,44.7},{39.8,56.8},
                {56.7,68.4},{80,80}}, color={0,0,0}),
          Text(
            extent={{-90,80},{-6,26}},
            lineColor={192,192,192},
            textString="asinh")}),
      Diagram(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics={Line(points={{-100,0},{84,0}}, color={95,95,95}),
            Polygon(
              points={{98,0},{82,6},{82,-6},{98,0}},
              lineColor={95,95,95},
              fillColor={95,95,95},
              fillPattern=FillPattern.Solid),Line(
              points={{-80,-80},{-56.7,-68.4},{-39.8,-56.8},{-26.9,-44.7},{-17.3,
              -32.4},{-9.25,-19},{9.25,19},{17.3,32.4},{26.9,44.7},{39.8,56.8},{
              56.7,68.4},{80,80}},
              color={0,0,255},
              thickness=0.5),Text(
              extent={{-31,72},{-11,88}},
              textString="2.31",
              lineColor={0,0,255}),Text(
              extent={{-35,-88},{-15,-72}},
              textString="-2.31",
              lineColor={0,0,255}),Text(
              extent={{72,-13},{92,-33}},
              textString="5",
              lineColor={0,0,255}),Text(
              extent={{-96,21},{-76,1}},
              textString="-5",
              lineColor={0,0,255}),Text(
              extent={{80,22},{100,2}},
              lineColor={95,95,95},
              textString="u"),Line(
              points={{0,80},{88,80}},
              color={175,175,175},
              smooth=Smooth.None),Line(
              points={{80,86},{80,-12}},
              color={175,175,175},
              smooth=Smooth.None)}),
      Documentation(info="<html>
<p>
The function returns the area hyperbolic sine of its
input argument u. This inverse of sinh(..) is unique
and there is no restriction on the input argument u of
asinh(u) (-&infin; &lt; u &lt; &infin;):
</p>

<p>
<img src=\"modelica://Modelica/Resources/Images/Math/asinh.png\">
</p>
</html>"));
  end asinh;

  function exp "Exponential, base e"
    extends Modelica.Math.Icons.AxisCenter;
    input Real u;
    output Real y;

  external "builtin" y=  exp(u);
    annotation (
      Icon(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics={
          Line(points={{-90,-80.3976},{68,-80.3976}}, color={192,192,192}),
          Polygon(
            points={{90,-80.3976},{68,-72.3976},{68,-88.3976},{90,-80.3976}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),
          Line(points={{-80,-80},{-31,-77.9},{-6.03,-74},{10.9,-68.4},{23.7,-61},
                {34.2,-51.6},{43,-40.3},{50.3,-27.8},{56.7,-13.5},{62.3,2.23},{
                67.1,18.6},{72,38.2},{76,57.6},{80,80}}, color={0,0,0}),
          Text(
            extent={{-86,50},{-14,2}},
            lineColor={192,192,192},
            textString="exp")}),
      Diagram(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics={Line(points={{-100,-80.3976},{84,-80.3976}},
            color={95,95,95}),Polygon(
              points={{98,-80.3976},{82,-74.3976},{82,-86.3976},{98,-80.3976}},
              lineColor={95,95,95},
              fillColor={95,95,95},
              fillPattern=FillPattern.Solid),Line(
              points={{-80,-80},{-31,-77.9},{-6.03,-74},{10.9,-68.4},{23.7,-61},{
              34.2,-51.6},{43,-40.3},{50.3,-27.8},{56.7,-13.5},{62.3,2.23},{67.1,
              18.6},{72,38.2},{76,57.6},{80,80}},
              color={0,0,255},
              thickness=0.5),Text(
              extent={{-31,72},{-11,88}},
              textString="20",
              lineColor={0,0,255}),Text(
              extent={{-92,-81},{-72,-101}},
              textString="-3",
              lineColor={0,0,255}),Text(
              extent={{66,-81},{86,-101}},
              textString="3",
              lineColor={0,0,255}),Text(
              extent={{2,-69},{22,-89}},
              textString="1",
              lineColor={0,0,255}),Text(
              extent={{78,-54},{98,-74}},
              lineColor={95,95,95},
              textString="u"),Line(
              points={{0,80},{88,80}},
              color={175,175,175},
              smooth=Smooth.None),Line(
              points={{80,84},{80,-84}},
              color={175,175,175},
              smooth=Smooth.None)}),
      Documentation(info="<html>
<p>
This function returns y = exp(u), with -&infin; &lt; u &lt; &infin;:
</p>

<p>
<img src=\"modelica://Modelica/Resources/Images/Math/exp.png\">
</p>
</html>"));
  end exp;

  function log "Natural (base e) logarithm (u shall be > 0)"
    extends Modelica.Math.Icons.AxisLeft;
    input Real u;
    output Real y;

  external "builtin" y=  log(u);
    annotation (
      Icon(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics={
          Line(points={{-90,0},{68,0}}, color={192,192,192}),
          Polygon(
            points={{90,0},{68,8},{68,-8},{90,0}},
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid),
          Line(points={{-80,-80},{-79.2,-50.6},{-78.4,-37},{-77.6,-28},{-76.8,-21.3},
                {-75.2,-11.4},{-72.8,-1.31},{-69.5,8.08},{-64.7,17.9},{-57.5,28},
                {-47,38.1},{-31.8,48.1},{-10.1,58},{22.1,68},{68.7,78.1},{80,80}},
              color={0,0,0}),
          Text(
            extent={{-6,-24},{66,-72}},
            lineColor={192,192,192},
            textString="log")}),
      Diagram(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}}), graphics={Line(points={{-100,0},{84,0}}, color={95,95,95}),
            Polygon(
              points={{100,0},{84,6},{84,-6},{100,0}},
              lineColor={95,95,95},
              fillColor={95,95,95},
              fillPattern=FillPattern.Solid),Line(
              points={{-78,-80},{-77.2,-50.6},{-76.4,-37},{-75.6,-28},{-74.8,-21.3},
              {-73.2,-11.4},{-70.8,-1.31},{-67.5,8.08},{-62.7,17.9},{-55.5,28},{-45,
              38.1},{-29.8,48.1},{-8.1,58},{24.1,68},{70.7,78.1},{82,80}},
              color={0,0,255},
              thickness=0.5),Text(
              extent={{-105,72},{-85,88}},
              textString="3",
              lineColor={0,0,255}),Text(
              extent={{60,-3},{80,-23}},
              textString="20",
              lineColor={0,0,255}),Text(
              extent={{-78,-7},{-58,-27}},
              textString="1",
              lineColor={0,0,255}),Text(
              extent={{84,26},{104,6}},
              lineColor={95,95,95},
              textString="u"),Text(
              extent={{-100,9},{-80,-11}},
              textString="0",
              lineColor={0,0,255}),Line(
              points={{-80,80},{84,80}},
              color={175,175,175},
              smooth=Smooth.None),Line(
              points={{82,82},{82,-6}},
              color={175,175,175},
              smooth=Smooth.None)}),
      Documentation(info="<html>
<p>
This function returns y = log(10) (the natural logarithm of u),
with u &gt; 0:
</p>

<p>
<img src=\"modelica://Modelica/Resources/Images/Math/log.png\">
</p>
</html>"));
  end log;
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}), graphics={Line(points={{-80,0},{-68.7,34.2},{-61.5,53.1},
              {-55.1,66.4},{-49.4,74.6},{-43.8,79.1},{-38.2,79.8},{-32.6,76.6},{
              -26.9,69.7},{-21.3,59.4},{-14.9,44.1},{-6.83,21.2},{10.1,-30.8},{17.3,
              -50.2},{23.7,-64.2},{29.3,-73.1},{35,-78.4},{40.6,-80},{46.2,-77.6},
              {51.9,-71.5},{57.5,-61.9},{63.9,-47.2},{72,-24.8},{80,0}}, color={
              0,0,0}, smooth=Smooth.Bezier)}), Documentation(info="<HTML>
<p>
This package contains <b>basic mathematical functions</b> (such as sin(..)),
as well as functions operating on
<a href=\"modelica://Modelica.Math.Vectors\">vectors</a>,
<a href=\"modelica://Modelica.Math.Matrices\">matrices</a>,
<a href=\"modelica://Modelica.Math.Nonlinear\">nonlinear functions</a>, and
<a href=\"modelica://Modelica.Math.BooleanVectors\">Boolean vectors</a>.
</p>

<dl>
<dt><b>Main Authors:</b>
<dd><a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a> and
    Marcus Baur<br>
    Deutsches Zentrum f&uuml;r Luft und Raumfahrt e.V. (DLR)<br>
    Institut f&uuml;r Robotik und Mechatronik<br>
    Postfach 1116<br>
    D-82230 Wessling<br>
    Germany<br>
    email: <A HREF=\"mailto:Martin.Otter@dlr.de\">Martin.Otter@dlr.de</A><br>
</dl>

<p>
Copyright &copy; 1998-2013, Modelica Association and DLR.
</p>
<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"https://www.modelica.org/licenses/ModelicaLicense2\"> https://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>
</html>",   revisions="<html>
<ul>
<li><i>October 21, 2002</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>
       and <a href=\"http://www.robotic.dlr.de/Christian.Schweiger/\">Christian Schweiger</a>:<br>
       Function tempInterpol2 added.</li>
<li><i>Oct. 24, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Icons for icon and diagram level introduced.</li>
<li><i>June 30, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Realized.</li>
</ul>

</html>"));
  end Math;

  package Utilities
  "Library of utility functions dedicated to scripting (operating on files, streams, strings, system)"
    extends Modelica.Icons.Package;

    package Streams "Read from files and write to files"
      extends Modelica.Icons.Package;

      function print "Print string to terminal or file"
        extends Modelica.Icons.Function;
        input String string="" "String to be printed";
        input String fileName=""
        "File where to print (empty string is the terminal)"
                     annotation(Dialog(saveSelector(filter="Text files (*.txt)",
                            caption="Text file to store the output of print(..)")));
      external "C" ModelicaInternal_print(string, fileName) annotation(Library="ModelicaExternalC");
        annotation (Documentation(info="<HTML>
<h4>Syntax</h4>
<blockquote><pre>
Streams.<b>print</b>(string);
Streams.<b>print</b>(string,fileName);
</pre></blockquote>
<h4>Description</h4>
<p>
Function <b>print</b>(..) opens automatically the given file, if
it is not yet open. If the file does not exist, it is created.
If the file does exist, the given string is appended to the file.
If this is not desired, call \"Files.remove(fileName)\" before calling print
(\"remove(..)\" is silent, if the file does not exist).
The Modelica environment may close the file whenever appropriate.
This can be enforced by calling <b>Streams.close</b>(fileName).
After every call of \"print(..)\" a \"new line\" is printed automatically.
</p>
<h4>Example</h4>
<blockquote><pre>
  Streams.print(\"x = \" + String(x));
  Streams.print(\"y = \" + String(y));
  Streams.print(\"x = \" + String(y), \"mytestfile.txt\");
</pre></blockquote>
<h4>See also</h4>
<p>
<a href=\"modelica://Modelica.Utilities.Streams\">Streams</a>,
<a href=\"modelica://Modelica.Utilities.Streams.error\">Streams.error</a>,
<a href=\"modelica://ModelicaReference.Operators.'String()'\">ModelicaReference.Operators.'String()'</a>
</p>
</HTML>"));
      end print;

      function error "Print error message and cancel all actions"
        extends Modelica.Icons.Function;
        input String string "String to be printed to error message window";
        external "C" ModelicaError(string) annotation(Library="ModelicaExternalC");
        annotation (Documentation(info="<html>
<h4>Syntax</h4>
<blockquote><pre>
Streams.<b>error</b>(string);
</pre></blockquote>
<h4>Description</h4>
<p>
Print the string \"string\" as error message and
cancel all actions. Line breaks are characterized
by \"\\n\" in the string.
</p>
<h4>Example</h4>
<blockquote><pre>
  Streams.error(\"x (= \" + String(x) + \")\\nhas to be in the range 0 .. 1\");
</pre></blockquote>
<h4>See also</h4>
<p>
<a href=\"modelica://Modelica.Utilities.Streams\">Streams</a>,
<a href=\"modelica://Modelica.Utilities.Streams.print\">Streams.print</a>,
<a href=\"modelica://ModelicaReference.Operators.'String()'\">ModelicaReference.Operators.'String()'</a>
</p>
</html>"));
      end error;
      annotation (
        Documentation(info="<HTML>
<h4>Library content</h4>
<p>
Package <b>Streams</b> contains functions to input and output strings
to a message window or on files. Note that a string is interpreted
and displayed as html text (e.g., with print(..) or error(..))
if it is enclosed with the Modelica html quotation, e.g.,
</p>
<center>
string = \"&lt;html&gt; first line &lt;br&gt; second line &lt;/html&gt;\".
</center>
<p>
It is a quality of implementation, whether (a) all tags of html are supported
or only a subset, (b) how html tags are interpreted if the output device
does not allow to display formatted text.
</p>
<p>
In the table below an example call to every function is given:
</p>
<table border=1 cellspacing=0 cellpadding=2>
  <tr><th><b><i>Function/type</i></b></th><th><b><i>Description</i></b></th></tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Utilities.Streams.print\">print</a>(string)<br>
          <a href=\"modelica://Modelica.Utilities.Streams.print\">print</a>(string,fileName)</td>
      <td valign=\"top\"> Print string \"string\" or vector of strings to message window or on
           file \"fileName\".</td>
  </tr>
  <tr><td valign=\"top\">stringVector =
         <a href=\"modelica://Modelica.Utilities.Streams.readFile\">readFile</a>(fileName)</td>
      <td valign=\"top\"> Read complete text file and return it as a vector of strings.</td>
  </tr>
  <tr><td valign=\"top\">(string, endOfFile) =
         <a href=\"modelica://Modelica.Utilities.Streams.readLine\">readLine</a>(fileName, lineNumber)</td>
      <td valign=\"top\">Returns from the file the content of line lineNumber.</td>
  </tr>
  <tr><td valign=\"top\">lines =
         <a href=\"modelica://Modelica.Utilities.Streams.countLines\">countLines</a>(fileName)</td>
      <td valign=\"top\">Returns the number of lines in a file.</td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Utilities.Streams.error\">error</a>(string)</td>
      <td valign=\"top\"> Print error message \"string\" to message window
           and cancel all actions</td>
  </tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Utilities.Streams.close\">close</a>(fileName)</td>
      <td valign=\"top\"> Close file if it is still open. Ignore call if
           file is already closed or does not exist. </td>
  </tr>
</table>
<p>
Use functions <b>scanXXX</b> from package
<a href=\"modelica://Modelica.Utilities.Strings\">Strings</a>
to parse a string.
</p>
<p>
If Real, Integer or Boolean values shall be printed
or used in an error message, they have to be first converted
to strings with the builtin operator
<a href=\"modelica://ModelicaReference.Operators.'String()'\">ModelicaReference.Operators.'String()'</a>(...).
Example:
</p>
<pre>
  <b>if</b> x &lt; 0 <b>or</b> x &gt; 1 <b>then</b>
     Streams.error(\"x (= \" + String(x) + \") has to be in the range 0 .. 1\");
  <b>end if</b>;
</pre>
</html>"));
    end Streams;

    package Strings "Operations on strings"
      extends Modelica.Icons.Package;

      function length "Returns length of string"
        extends Modelica.Icons.Function;
        input String string;
        output Integer result "Number of characters of string";
      external "C" result = ModelicaStrings_length(string) annotation(Library="ModelicaExternalC");
        annotation (Documentation(info="<html>
<h4>Syntax</h4>
<blockquote><pre>
Strings.<b>length</b>(string);
</pre></blockquote>
<h4>Description</h4>
<p>
Returns the number of characters of \"string\".
</p>
</html>"));
      end length;

      function compare "Compare two strings lexicographically"
        extends Modelica.Icons.Function;
        input String string1;
        input String string2;
        input Boolean caseSensitive=true
        "= false, if case of letters is ignored";
        output Modelica.Utilities.Types.Compare result "Result of comparison";
      external "C" result = ModelicaStrings_compare(string1, string2, caseSensitive) annotation(Library="ModelicaExternalC");
        annotation (Documentation(info="<html>
<h4>Syntax</h4>
<blockquote><pre>
result = Strings.<b>compare</b>(string1, string2);
result = Strings.<b>compare</b>(string1, string2, caseSensitive=true);
</pre></blockquote>
<h4>Description</h4>
<p>
Compares two strings. If the optional argument caseSensitive=false,
upper case letters are treated as if they would be lower case letters.
The result of the comparison is returned as:
</p>
<pre>
  result = Modelica.Utilities.Types.Compare.Less     // string1 &lt; string2
         = Modelica.Utilities.Types.Compare.Equal    // string1 = string2
         = Modelica.Utilities.Types.Compare.Greater  // string1 &gt; string2
</pre>
<p>
Comparison is with regards to lexicographical order,
e.g., \"a\" &lt; \"b\";
</p>
</html>"));
      end compare;

      function isEqual "Determine whether two strings are identical"
        extends Modelica.Icons.Function;
        input String string1;
        input String string2;
        input Boolean caseSensitive=true
        "= false, if lower and upper case are ignored for the comparison";
        output Boolean identical "True, if string1 is identical to string2";
      algorithm
        identical :=compare(string1, string2, caseSensitive) == Types.Compare.Equal;
        annotation (
      Documentation(info="<html>
<h4>Syntax</h4>
<blockquote><pre>
Strings.<b>isEqual</b>(string1, string2);
Strings.<b>isEqual</b>(string1, string2, caseSensitive=true);
</pre></blockquote>
<h4>Description</h4>
<p>
Compare whether two strings are identical,
optionally ignoring case.
</p>
</html>"));
      end isEqual;

      function isEmpty
      "Return true if a string is empty (has only white space characters)"
        extends Modelica.Icons.Function;
        input String string;
        output Boolean result "True, if string is empty";
    protected
        Integer nextIndex;
        Integer len;
      algorithm
        nextIndex := Strings.Advanced.skipWhiteSpace(string);
        len := Strings.length(string);
        if len < 1 or nextIndex > len then
          result := true;
        else
          result := false;
        end if;

        annotation (Documentation(info="<html>
<h4>Syntax</h4>
<blockquote><pre>
Strings.<b>isEmpty</b>(string);
</pre></blockquote>
<h4>Description</h4>
<p>
Returns true if the string has no characters or if the string consists
only of white space characters. Otherwise, false is returned.
</p>

<h4>Example</h4>
<blockquote><pre>
  isEmpty(\"\");       // returns true
  isEmpty(\"   \");    // returns true
  isEmpty(\"  abc\");  // returns false
  isEmpty(\"a\");      // returns false
</pre></blockquote>
</html>"));
      end isEmpty;

      package Advanced "Advanced scanning functions"
      extends Modelica.Icons.Package;

        function skipWhiteSpace "Scans white space"
          extends Modelica.Icons.Function;
          input String string;
          input Integer startIndex(min=1)=1;
          output Integer nextIndex;
          external "C" nextIndex = ModelicaStrings_skipWhiteSpace(string, startIndex) annotation(Library="ModelicaExternalC");
          annotation (Documentation(info="<html>
<h4>Syntax</h4>
<blockquote><pre>
nextIndex = <b>skipWhiteSpace</b>(string, startIndex);
</pre></blockquote>
<h4>Description</h4>
<p>
Starts scanning of \"string\" at position \"startIndex\" and
skips white space. The function returns nextIndex = index of character
of the first non white space character.
</p>
<h4>See also</h4>
<a href=\"modelica://Modelica.Utilities.Strings.Advanced\">Strings.Advanced</a>.
</html>"));
        end skipWhiteSpace;
        annotation (Documentation(info="<html>
<h4>Library content</h4>
<p>
Package <b>Strings.Advanced</b> contains basic scanning
functions. These functions should be <b>not called</b> directly, because
it is much simpler to utilize the higher level functions \"Strings.scanXXX\".
The functions of the \"Strings.Advanced\" library provide
the basic interface in order to implement the higher level
functions in package \"Strings\".
</p>
<p>
Library \"Advanced\" provides the following functions:
</p>
<pre>
  (nextIndex, realNumber)    = <a href=\"modelica://Modelica.Utilities.Strings.Advanced.scanReal\">scanReal</a>        (string, startIndex, unsigned=false);
  (nextIndex, integerNumber) = <a href=\"modelica://Modelica.Utilities.Strings.Advanced.scanInteger\">scanInteger</a>     (string, startIndex, unsigned=false);
  (nextIndex, string2)       = <a href=\"modelica://Modelica.Utilities.Strings.Advanced.scanString\">scanString</a>      (string, startIndex);
  (nextIndex, identifier)    = <a href=\"modelica://Modelica.Utilities.Strings.Advanced.scanIdentifier\">scanIdentifier</a>  (string, startIndex);
   nextIndex                 = <a href=\"modelica://Modelica.Utilities.Strings.Advanced.skipWhiteSpace\">skipWhiteSpace</a>  (string, startIndex);
   nextIndex                 = <a href=\"modelica://Modelica.Utilities.Strings.Advanced.skipLineComments\">skipLineComments</a>(string, startIndex);
</pre>
<p>
All functions perform the following actions:
</p>
<ol>
<li> Scanning starts at character position \"startIndex\" of
     \"string\" (startIndex has a default of 1).
<li> First, white space is skipped, such as blanks (\" \"), tabs (\"\\t\"), or newline (\"\\n\")</li>
<li> Afterwards, the required token is scanned.</li>
<li> If successful, on return nextIndex = index of character
     directly after the found token and the token value is returned
     as second output argument.<br>
     If not successful, on return nextIndex = startIndex.
     </li>
</ol>
<p>
The following additional rules apply for the scanning:
</p>
<ul>
<li> Function <a href=\"modelica://Modelica.Utilities.Strings.Advanced.scanReal\">scanReal</a>:<br>
     Scans a full number including one optional leading \"+\" or \"-\" (if unsigned=false)
     according to the Modelica grammar. For example, \"+1.23e-5\", \"0.123\" are
     Real numbers, but \".1\" is not.
     Note, an Integer number, such as \"123\" is also treated as a Real number.<br>&nbsp;</li>
<li> Function <a href=\"modelica://Modelica.Utilities.Strings.Advanced.scanInteger\">scanInteger</a>:<br>
     Scans an Integer number including one optional leading \"+\"
     or \"-\" (if unsigned=false) according to the Modelica (and C/C++) grammar.
     For example, \"+123\", \"20\" are Integer numbers.
     Note, a Real number, such as \"123.4\" is not an Integer and
     scanInteger returns nextIndex = startIndex.<br>&nbsp;</li>
<li> Function <a href=\"modelica://Modelica.Utilities.Strings.Advanced.scanString\">scanString</a>:<br>
     Scans a String according to the Modelica (and C/C++) grammar, e.g.,
     \"This is a \"string\"\" is a valid string token.<br>&nbsp;</li>
<li> Function <a href=\"modelica://Modelica.Utilities.Strings.Advanced.scanIdentifier\">scanIdentifier</a>:<br>
     Scans a Modelica identifier, i.e., the identifier starts either
     with a letter, followed by letters, digits or \"_\".
     For example, \"w_rel\", \"T12\".<br>&nbsp;</li>
<li> Function <a href=\"modelica://Modelica.Utilities.Strings.Advanced.skipLineComments\">skipLineComments</a><br>
     Skips white space and Modelica (C/C++) line comments iteratively.
     A line comment starts with \"//\" and ends either with an
     end-of-line (\"\\n\") or the end of the \"string\". </li>
</ul>
</html>"));
      end Advanced;
      annotation (
        Documentation(info="<HTML>
<h4>Library content</h4>
<p>
Package <b>Strings</b> contains functions to manipulate strings.
</p>
<p>
In the table below an example
call to every function is given using the <b>default</b> options.
</p>
<table border=1 cellspacing=0 cellpadding=2>
  <tr><th><b><i>Function</i></b></th><th><b><i>Description</i></b></th></tr>
  <tr><td valign=\"top\">len = <a href=\"modelica://Modelica.Utilities.Strings.length\">length</a>(string)</td>
      <td valign=\"top\">Returns length of string</td></tr>
  <tr><td valign=\"top\">string2 = <a href=\"modelica://Modelica.Utilities.Strings.substring\">substring</a>(string1,startIndex,endIndex)
       </td>
      <td valign=\"top\">Returns a substring defined by start and end index</td></tr>
  <tr><td valign=\"top\">result = <a href=\"modelica://Modelica.Utilities.Strings.repeat\">repeat</a>(n)<br>
 result = <a href=\"modelica://Modelica.Utilities.Strings.repeat\">repeat</a>(n,string)</td>
      <td valign=\"top\">Repeat a blank or a string n times.</td></tr>
  <tr><td valign=\"top\">result = <a href=\"modelica://Modelica.Utilities.Strings.compare\">compare</a>(string1, string2)</td>
      <td valign=\"top\">Compares two substrings with regards to alphabetical order</td></tr>
  <tr><td valign=\"top\">identical =
<a href=\"modelica://Modelica.Utilities.Strings.isEqual\">isEqual</a>(string1,string2)</td>
      <td valign=\"top\">Determine whether two strings are identical</td></tr>
  <tr><td valign=\"top\">result = <a href=\"modelica://Modelica.Utilities.Strings.count\">count</a>(string,searchString)</td>
      <td valign=\"top\">Count the number of occurrences of a string</td></tr>
  <tr>
<td valign=\"top\">index = <a href=\"modelica://Modelica.Utilities.Strings.find\">find</a>(string,searchString)</td>
      <td valign=\"top\">Find first occurrence of a string in another string</td></tr>
<tr>
<td valign=\"top\">index = <a href=\"modelica://Modelica.Utilities.Strings.findLast\">findLast</a>(string,searchString)</td>
      <td valign=\"top\">Find last occurrence of a string in another string</td></tr>
  <tr><td valign=\"top\">string2 = <a href=\"modelica://Modelica.Utilities.Strings.replace\">replace</a>(string,searchString,replaceString)</td>
      <td valign=\"top\">Replace one or all occurrences of a string</td></tr>
  <tr><td valign=\"top\">stringVector2 = <a href=\"modelica://Modelica.Utilities.Strings.sort\">sort</a>(stringVector1)</td>
      <td valign=\"top\">Sort vector of strings in alphabetic order</td></tr>
  <tr><td valign=\"top\">(token, index) = <a href=\"modelica://Modelica.Utilities.Strings.scanToken\">scanToken</a>(string,startIndex)</td>
      <td valign=\"top\">Scan for a token (Real/Integer/Boolean/String/Identifier/Delimiter/NoToken)</td></tr>
  <tr><td valign=\"top\">(number, index) = <a href=\"modelica://Modelica.Utilities.Strings.scanReal\">scanReal</a>(string,startIndex)</td>
      <td valign=\"top\">Scan for a Real constant</td></tr>
  <tr><td valign=\"top\">(number, index) = <a href=\"modelica://Modelica.Utilities.Strings.scanInteger\">scanInteger</a>(string,startIndex)</td>
      <td valign=\"top\">Scan for an Integer constant</td></tr>
  <tr><td valign=\"top\">(boolean, index) = <a href=\"modelica://Modelica.Utilities.Strings.scanBoolean\">scanBoolean</a>(string,startIndex)</td>
      <td valign=\"top\">Scan for a Boolean constant</td></tr>
  <tr><td valign=\"top\">(string2, index) = <a href=\"modelica://Modelica.Utilities.Strings.scanString\">scanString</a>(string,startIndex)</td>
      <td valign=\"top\">Scan for a String constant</td></tr>
  <tr><td valign=\"top\">(identifier, index) = <a href=\"modelica://Modelica.Utilities.Strings.scanIdentifier\">scanIdentifier</a>(string,startIndex)</td>
      <td valign=\"top\">Scan for an identifier</td></tr>
  <tr><td valign=\"top\">(delimiter, index) = <a href=\"modelica://Modelica.Utilities.Strings.scanDelimiter\">scanDelimiter</a>(string,startIndex)</td>
      <td valign=\"top\">Scan for delimiters</td></tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Utilities.Strings.scanNoToken\">scanNoToken</a>(string,startIndex)</td>
      <td valign=\"top\">Check that remaining part of string consists solely of <br>
          white space or line comments (\"// ...\\n\").</td></tr>
  <tr><td valign=\"top\"><a href=\"modelica://Modelica.Utilities.Strings.syntaxError\">syntaxError</a>(string,index,message)</td>
      <td valign=\"top\"> Print a \"syntax error message\" as well as a string and the <br>
           index at which scanning detected an error</td></tr>
</table>
<p>
The functions \"compare\", \"isEqual\", \"count\", \"find\", \"findLast\", \"replace\", \"sort\"
have the optional
input argument <b>caseSensitive</b> with default <b>true</b>.
If <b>false</b>, the operation is carried out without taking
into account whether a character is upper or lower case.
</p>
</HTML>"));
    end Strings;

    package Types "Type definitions used in package Modelica.Utilities"
      extends Modelica.Icons.TypesPackage;

      type Compare = enumeration(
        Less "String 1 is lexicographically less than string 2",
        Equal "String 1 is identical to string 2",
        Greater "String 1 is lexicographically greater than string 2")
      "Enumeration defining comparison of two strings";
      annotation (Documentation(info="<html>
<p>
This package contains type definitions used in Modelica.Utilities.
</p>

</html>"));
    end Types;
      annotation (
  Icon(coordinateSystem(extent={{-100.0,-100.0},{100.0,100.0}}), graphics={
      Polygon(
        origin={1.3835,-4.1418},
        rotation=45.0,
        fillColor={64,64,64},
        pattern=LinePattern.None,
        fillPattern=FillPattern.Solid,
        points={{-15.0,93.333},{-15.0,68.333},{0.0,58.333},{15.0,68.333},{15.0,93.333},{20.0,93.333},{25.0,83.333},{25.0,58.333},{10.0,43.333},{10.0,-41.667},{25.0,-56.667},{25.0,-76.667},{10.0,-91.667},{0.0,-91.667},{0.0,-81.667},{5.0,-81.667},{15.0,-71.667},{15.0,-61.667},{5.0,-51.667},{-5.0,-51.667},{-15.0,-61.667},{-15.0,-71.667},{-5.0,-81.667},{0.0,-81.667},{0.0,-91.667},{-10.0,-91.667},{-25.0,-76.667},{-25.0,-56.667},{-10.0,-41.667},{-10.0,43.333},{-25.0,58.333},{-25.0,83.333},{-20.0,93.333}}),
      Polygon(
        origin={10.1018,5.218},
        rotation=-45.0,
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid,
        points={{-15.0,87.273},{15.0,87.273},{20.0,82.273},{20.0,27.273},{10.0,17.273},{10.0,7.273},{20.0,2.273},{20.0,-2.727},{5.0,-2.727},{5.0,-77.727},{10.0,-87.727},{5.0,-112.727},{-5.0,-112.727},{-10.0,-87.727},{-5.0,-77.727},{-5.0,-2.727},{-20.0,-2.727},{-20.0,2.273},{-10.0,7.273},{-10.0,17.273},{-20.0,27.273},{-20.0,82.273}})}),
  Documentation(info="<html>
<p>
This package contains Modelica <b>functions</b> that are
especially suited for <b>scripting</b>. The functions might
be used to work with strings, read data from file, write data
to file or copy, move and remove files.
</p>
<p>
For an introduction, have especially a look at:
</p>
<ul>
<li> <a href=\"modelica://Modelica.Utilities.UsersGuide\">Modelica.Utilities.User's Guide</a>
     discusses the most important aspects of this library.</li>
<li> <a href=\"modelica://Modelica.Utilities.Examples\">Modelica.Utilities.Examples</a>
     contains examples that demonstrate the usage of this library.</li>
</ul>
<p>
The following main sublibraries are available:
</p>
<ul>
<li> <a href=\"modelica://Modelica.Utilities.Files\">Files</a>
     provides functions to operate on files and directories, e.g.,
     to copy, move, remove files.</li>
<li> <a href=\"modelica://Modelica.Utilities.Streams\">Streams</a>
     provides functions to read from files and write to files.</li>
<li> <a href=\"modelica://Modelica.Utilities.Strings\">Strings</a>
     provides functions to operate on strings. E.g.
     substring, find, replace, sort, scanToken.</li>
<li> <a href=\"modelica://Modelica.Utilities.System\">System</a>
     provides functions to interact with the environment.
     E.g., get or set the working directory or environment
     variables and to send a command to the default shell.</li>
</ul>

<p>
Copyright &copy; 1998-2013, Modelica Association, DLR, and Dassault Syst&egrave;mes AB.
</p>

<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"https://www.modelica.org/licenses/ModelicaLicense2\"> https://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>

</html>"));
  end Utilities;

  package Constants
  "Library of mathematical constants and constants of nature (e.g., pi, eps, R, sigma)"
    import SI = Modelica.SIunits;
    import NonSI = Modelica.SIunits.Conversions.NonSIunits;
    extends Modelica.Icons.Package;

    final constant Real pi=2*Modelica.Math.asin(1.0);

    final constant Real eps=ModelicaServices.Machine.eps
    "Biggest number such that 1.0 + eps = 1.0";

    final constant Real small=ModelicaServices.Machine.small
    "Smallest number such that small and -small are representable on the machine";

    final constant Real inf=ModelicaServices.Machine.inf
    "Biggest Real number such that inf and -inf are representable on the machine";

    final constant SI.Acceleration g_n=9.80665
    "Standard acceleration of gravity on earth";

    final constant NonSI.Temperature_degC T_zero=-273.15
    "Absolute zero temperature";
    annotation (
      Documentation(info="<html>
<p>
This package provides often needed constants from mathematics, machine
dependent constants and constants from nature. The latter constants
(name, value, description) are from the following source:
</p>

<dl>
<dt>Peter J. Mohr and Barry N. Taylor (1999):</dt>
<dd><b>CODATA Recommended Values of the Fundamental Physical Constants: 1998</b>.
    Journal of Physical and Chemical Reference Data, Vol. 28, No. 6, 1999 and
    Reviews of Modern Physics, Vol. 72, No. 2, 2000. See also <a href=
\"http://physics.nist.gov/cuu/Constants/\">http://physics.nist.gov/cuu/Constants/</a></dd>
</dl>

<p>CODATA is the Committee on Data for Science and Technology.</p>

<dl>
<dt><b>Main Author:</b></dt>
<dd><a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a><br>
    Deutsches Zentrum f&uuml;r Luft und Raumfahrt e. V. (DLR)<br>
    Oberpfaffenhofen<br>
    Postfach 11 16<br>
    D-82230 We&szlig;ling<br>
    email: <a href=\"mailto:Martin.Otter@dlr.de\">Martin.Otter@dlr.de</a></dd>
</dl>

<p>
Copyright &copy; 1998-2013, Modelica Association and DLR.
</p>
<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"https://www.modelica.org/licenses/ModelicaLicense2\"> https://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>
</html>",   revisions="<html>
<ul>
<li><i>Nov 8, 2004</i>
       by <a href=\"http://www.robotic.dlr.de/Christian.Schweiger/\">Christian Schweiger</a>:<br>
       Constants updated according to 2002 CODATA values.</li>
<li><i>Dec 9, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Constants updated according to 1998 CODATA values. Using names, values
       and description text from this source. Included magnetic and
       electric constant.</li>
<li><i>Sep 18, 1999</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Constants eps, inf, small introduced.</li>
<li><i>Nov 15, 1997</i>
       by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br>
       Realized.</li>
</ul>
</html>"),
      Icon(coordinateSystem(extent={{-100.0,-100.0},{100.0,100.0}}), graphics={
        Polygon(
          origin={-9.2597,25.6673},
          fillColor={102,102,102},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{48.017,11.336},{48.017,11.336},{10.766,11.336},{-25.684,10.95},{-34.944,-15.111},{-34.944,-15.111},{-32.298,-15.244},{-32.298,-15.244},{-22.112,0.168},{11.292,0.234},{48.267,-0.097},{48.267,-0.097}},
          smooth=Smooth.Bezier),
        Polygon(
          origin={-19.9923,-8.3993},
          fillColor={102,102,102},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{3.239,37.343},{3.305,37.343},{-0.399,2.683},{-16.936,-20.071},{-7.808,-28.604},{6.811,-22.519},{9.986,37.145},{9.986,37.145}},
          smooth=Smooth.Bezier),
        Polygon(
          origin={23.753,-11.5422},
          fillColor={102,102,102},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-10.873,41.478},{-10.873,41.478},{-14.048,-4.162},{-9.352,-24.8},{7.912,-24.469},{16.247,0.27},{16.247,0.27},{13.336,0.071},{13.336,0.071},{7.515,-9.983},{-3.134,-7.271},{-2.671,41.214},{-2.671,41.214}},
          smooth=Smooth.Bezier)}));
  end Constants;

  package Icons "Library of icons"
    extends Icons.Package;

    partial package ExamplesPackage
    "Icon for packages containing runnable examples"
      extends Modelica.Icons.Package;
      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics={
            Polygon(
              origin={8.0,14.0},
              lineColor={78,138,73},
              fillColor={78,138,73},
              pattern=LinePattern.None,
              fillPattern=FillPattern.Solid,
              points={{-58.0,46.0},{42.0,-14.0},{-58.0,-74.0},{-58.0,46.0}})}), Documentation(info="<html>
<p>This icon indicates a package that contains executable examples.</p>
</html>"));
    end ExamplesPackage;

    partial model Example "Icon for runnable examples"

      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
            Ellipse(lineColor = {75,138,73},
                    fillColor={255,255,255},
                    fillPattern = FillPattern.Solid,
                    extent = {{-100,-100},{100,100}}),
            Polygon(lineColor = {0,0,255},
                    fillColor = {75,138,73},
                    pattern = LinePattern.None,
                    fillPattern = FillPattern.Solid,
                    points = {{-36,60},{64,0},{-36,-60},{-36,60}})}), Documentation(info="<html>
<p>This icon indicates an example. The play button suggests that the example can be executed.</p>
</html>"));
    end Example;

    partial package Package "Icon for standard packages"

      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
            Rectangle(
              lineColor={200,200,200},
              fillColor={248,248,248},
              fillPattern=FillPattern.HorizontalCylinder,
              extent={{-100.0,-100.0},{100.0,100.0}},
              radius=25.0),
            Rectangle(
              lineColor={128,128,128},
              fillPattern=FillPattern.None,
              extent={{-100.0,-100.0},{100.0,100.0}},
              radius=25.0)}),   Documentation(info="<html>
<p>Standard package icon.</p>
</html>"));
    end Package;

    partial package BasesPackage "Icon for packages containing base classes"
      extends Modelica.Icons.Package;
      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics={
            Ellipse(
              extent={{-30.0,-30.0},{30.0,30.0}},
              lineColor={128,128,128},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid)}),
                                Documentation(info="<html>
<p>This icon shall be used for a package/library that contains base models and classes, respectively.</p>
</html>"));
    end BasesPackage;

    partial package VariantsPackage "Icon for package containing variants"
      extends Modelica.Icons.Package;
      annotation (Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},
                {100,100}}),       graphics={
            Ellipse(
              origin={10.0,10.0},
              fillColor={76,76,76},
              pattern=LinePattern.None,
              fillPattern=FillPattern.Solid,
              extent={{-80.0,-80.0},{-20.0,-20.0}}),
            Ellipse(
              origin={10.0,10.0},
              pattern=LinePattern.None,
              fillPattern=FillPattern.Solid,
              extent={{0.0,-80.0},{60.0,-20.0}}),
            Ellipse(
              origin={10.0,10.0},
              fillColor={128,128,128},
              pattern=LinePattern.None,
              fillPattern=FillPattern.Solid,
              extent={{0.0,0.0},{60.0,60.0}}),
            Ellipse(
              origin={10.0,10.0},
              lineColor={128,128,128},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid,
              extent={{-80.0,0.0},{-20.0,60.0}})}),
                                Documentation(info="<html>
<p>This icon shall be used for a package/library that contains several variants of one components.</p>
</html>"));
    end VariantsPackage;

    partial package InterfacesPackage "Icon for packages containing interfaces"
      extends Modelica.Icons.Package;
      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics={
            Polygon(origin={20.0,0.0},
              lineColor={64,64,64},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid,
              points={{-10.0,70.0},{10.0,70.0},{40.0,20.0},{80.0,20.0},{80.0,-20.0},{40.0,-20.0},{10.0,-70.0},{-10.0,-70.0}}),
            Polygon(fillColor={102,102,102},
              pattern=LinePattern.None,
              fillPattern=FillPattern.Solid,
              points={{-100.0,20.0},{-60.0,20.0},{-30.0,70.0},{-10.0,70.0},{-10.0,-70.0},{-30.0,-70.0},{-60.0,-20.0},{-100.0,-20.0}})}),
                                Documentation(info="<html>
<p>This icon indicates packages containing interfaces.</p>
</html>"));
    end InterfacesPackage;

    partial package SourcesPackage "Icon for packages containing sources"
      extends Modelica.Icons.Package;
      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics={
            Polygon(origin={23.3333,0.0},
              fillColor={128,128,128},
              pattern=LinePattern.None,
              fillPattern=FillPattern.Solid,
              points={{-23.333,30.0},{46.667,0.0},{-23.333,-30.0}}),
            Rectangle(
              fillColor = {128,128,128},
              pattern = LinePattern.None,
              fillPattern = FillPattern.Solid,
              extent = {{-70,-4.5},{0,4.5}})}),
                                Documentation(info="<html>
<p>This icon indicates a package which contains sources.</p>
</html>"));
    end SourcesPackage;

    partial package UtilitiesPackage "Icon for utility packages"
      extends Modelica.Icons.Package;
       annotation (Icon(coordinateSystem(extent={{-100.0,-100.0},{100.0,100.0}}), graphics={
      Polygon(
        origin={1.3835,-4.1418},
        rotation=45.0,
        fillColor={64,64,64},
        pattern=LinePattern.None,
        fillPattern=FillPattern.Solid,
        points={{-15.0,93.333},{-15.0,68.333},{0.0,58.333},{15.0,68.333},{15.0,93.333},{20.0,93.333},{25.0,83.333},{25.0,58.333},{10.0,43.333},{10.0,-41.667},{25.0,-56.667},{25.0,-76.667},{10.0,-91.667},{0.0,-91.667},{0.0,-81.667},{5.0,-81.667},{15.0,-71.667},{15.0,-61.667},{5.0,-51.667},{-5.0,-51.667},{-15.0,-61.667},{-15.0,-71.667},{-5.0,-81.667},{0.0,-81.667},{0.0,-91.667},{-10.0,-91.667},{-25.0,-76.667},{-25.0,-56.667},{-10.0,-41.667},{-10.0,43.333},{-25.0,58.333},{-25.0,83.333},{-20.0,93.333}}),
      Polygon(
        origin={10.1018,5.218},
        rotation=-45.0,
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid,
        points={{-15.0,87.273},{15.0,87.273},{20.0,82.273},{20.0,27.273},{10.0,17.273},{10.0,7.273},{20.0,2.273},{20.0,-2.727},{5.0,-2.727},{5.0,-77.727},{10.0,-87.727},{5.0,-112.727},{-5.0,-112.727},{-10.0,-87.727},{-5.0,-77.727},{-5.0,-2.727},{-20.0,-2.727},{-20.0,2.273},{-10.0,7.273},{-10.0,17.273},{-20.0,27.273},{-20.0,82.273}})}),
      Documentation(info="<html>
<p>This icon indicates a package containing utility classes.</p>
</html>"));
    end UtilitiesPackage;

    partial package TypesPackage
    "Icon for packages containing type definitions"
      extends Modelica.Icons.Package;
      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics={Polygon(
              origin={-12.167,-23},
              fillColor={128,128,128},
              pattern=LinePattern.None,
              fillPattern=FillPattern.Solid,
              points={{12.167,65},{14.167,93},{36.167,89},{24.167,20},{4.167,-30},
                  {14.167,-30},{24.167,-30},{24.167,-40},{-5.833,-50},{-15.833,
                  -30},{4.167,20},{12.167,65}},
              smooth=Smooth.Bezier,
              lineColor={0,0,0}), Polygon(
              origin={2.7403,1.6673},
              fillColor={128,128,128},
              pattern=LinePattern.None,
              fillPattern=FillPattern.Solid,
              points={{49.2597,22.3327},{31.2597,24.3327},{7.2597,18.3327},{-26.7403,
                10.3327},{-46.7403,14.3327},{-48.7403,6.3327},{-32.7403,0.3327},{-6.7403,
                4.3327},{33.2597,14.3327},{49.2597,14.3327},{49.2597,22.3327}},
              smooth=Smooth.Bezier)}));
    end TypesPackage;

    partial package IconsPackage "Icon for packages containing icons"
      extends Modelica.Icons.Package;
      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics={Polygon(
              origin={-8.167,-17},
              fillColor={128,128,128},
              pattern=LinePattern.None,
              fillPattern=FillPattern.Solid,
              points={{-15.833,20.0},{-15.833,30.0},{14.167,40.0},{24.167,20.0},{
                  4.167,-30.0},{14.167,-30.0},{24.167,-30.0},{24.167,-40.0},{-5.833,
                  -50.0},{-15.833,-30.0},{4.167,20.0},{-5.833,20.0}},
              smooth=Smooth.Bezier,
              lineColor={0,0,0}), Ellipse(
              origin={-0.5,56.5},
              fillColor={128,128,128},
              pattern=LinePattern.None,
              fillPattern=FillPattern.Solid,
              extent={{-12.5,-12.5},{12.5,12.5}},
              lineColor={0,0,0})}));
    end IconsPackage;

    partial package InternalPackage
    "Icon for an internal package (indicating that the package should not be directly utilized by user)"

    annotation (
      Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
              100}}), graphics={
          Rectangle(
            lineColor={215,215,215},
            fillColor={255,255,255},
            fillPattern=FillPattern.HorizontalCylinder,
            extent={{-100,-100},{100,100}},
            radius=25),
          Rectangle(
            lineColor={215,215,215},
            fillPattern=FillPattern.None,
            extent={{-100,-100},{100,100}},
            radius=25),
          Ellipse(
            extent={{-80,80},{80,-80}},
            lineColor={215,215,215},
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid),
          Ellipse(
            extent={{-55,55},{55,-55}},
            lineColor={255,255,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-60,14},{60,-14}},
            lineColor={215,215,215},
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid,
            origin={0,0},
            rotation=45)}),
      Documentation(info="<html>

<p>
This icon shall be used for a package that contains internal classes not to be
directly utilized by a user.
</p>
</html>"));
    end InternalPackage;

    partial package MaterialPropertiesPackage
    "Icon for package containing property classes"
      extends Modelica.Icons.Package;
      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics={
            Ellipse(
              lineColor={102,102,102},
              fillColor={204,204,204},
              pattern=LinePattern.None,
              fillPattern=FillPattern.Sphere,
              extent={{-60.0,-60.0},{60.0,60.0}})}),
                                Documentation(info="<html>
<p>This icon indicates a package that contains properties</p>
</html>"));
    end MaterialPropertiesPackage;

    partial function Function "Icon for functions"

      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
            Text(
              lineColor={0,0,255},
              extent={{-150,105},{150,145}},
              textString="%name"),
            Ellipse(
              lineColor = {108,88,49},
              fillColor = {255,215,136},
              fillPattern = FillPattern.Solid,
              extent = {{-100,-100},{100,100}}),
            Text(
              lineColor={108,88,49},
              extent={{-90.0,-90.0},{90.0,90.0}},
              textString="f")}),
    Documentation(info="<html>
<p>This icon indicates Modelica functions.</p>
</html>"));
    end Function;

    partial record Record "Icon for records"

      annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
            Text(
              lineColor={0,0,255},
              extent={{-150,60},{150,100}},
              textString="%name"),
            Rectangle(
              origin={0.0,-25.0},
              lineColor={64,64,64},
              fillColor={255,215,136},
              fillPattern=FillPattern.Solid,
              extent={{-100.0,-75.0},{100.0,75.0}},
              radius=25.0),
            Line(
              points={{-100.0,0.0},{100.0,0.0}},
              color={64,64,64}),
            Line(
              origin={0.0,-50.0},
              points={{-100.0,0.0},{100.0,0.0}},
              color={64,64,64}),
            Line(
              origin={0.0,-25.0},
              points={{0.0,75.0},{0.0,-75.0}},
              color={64,64,64})}),                        Documentation(info="<html>
<p>
This icon is indicates a record.
</p>
</html>"));
    end Record;

    partial package Library
    "This icon will be removed in future Modelica versions, use Package instead"
      // extends Modelica.Icons.ObsoleteModel;
      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
            Rectangle(
              lineColor={200,200,200},
              fillColor={248,248,248},
              fillPattern=FillPattern.HorizontalCylinder,
              extent={{-100.0,-100.0},{100.0,100.0}},
              radius=25.0),
            Rectangle(
              lineColor={128,128,128},
              fillPattern=FillPattern.None,
              extent={{-100.0,-100.0},{100.0,100.0}},
              radius=25.0)}),   Documentation(info="<html>
<p>This icon of a package will be removed in future versions of the library.</p>
<h5>Note</h5>
<p>This icon will be removed in future versions of the Modelica Standard Library. Instead the icon <a href=\"modelica://Modelica.Icons.Package\">Package</a> shall be used.</p>
</html>"));
    end Library;
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}), graphics={Polygon(
              origin={-8.167,-17},
              fillColor={128,128,128},
              pattern=LinePattern.None,
              fillPattern=FillPattern.Solid,
              points={{-15.833,20.0},{-15.833,30.0},{14.167,40.0},{24.167,20.0},{
                  4.167,-30.0},{14.167,-30.0},{24.167,-30.0},{24.167,-40.0},{-5.833,
                  -50.0},{-15.833,-30.0},{4.167,20.0},{-5.833,20.0}},
              smooth=Smooth.Bezier,
              lineColor={0,0,0}), Ellipse(
              origin={-0.5,56.5},
              fillColor={128,128,128},
              pattern=LinePattern.None,
              fillPattern=FillPattern.Solid,
              extent={{-12.5,-12.5},{12.5,12.5}},
              lineColor={0,0,0})}), Documentation(info="<html>
<p>This package contains definitions for the graphical layout of components which may be used in different libraries. The icons can be utilized by inheriting them in the desired class using &quot;extends&quot; or by directly copying the &quot;icon&quot; layer. </p>

<h4>Main Authors:</h4>

<dl>
<dt><a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a></dt>
    <dd>Deutsches Zentrum fuer Luft und Raumfahrt e.V. (DLR)</dd>
    <dd>Oberpfaffenhofen</dd>
    <dd>Postfach 1116</dd>
    <dd>D-82230 Wessling</dd>
    <dd>email: <a href=\"mailto:Martin.Otter@dlr.de\">Martin.Otter@dlr.de</a></dd>
<dt>Christian Kral</dt>
    <dd><a href=\"http://www.ait.ac.at/\">Austrian Institute of Technology, AIT</a></dd>
    <dd>Mobility Department</dd><dd>Giefinggasse 2</dd>
    <dd>1210 Vienna, Austria</dd>
    <dd>email: <a href=\"mailto:dr.christian.kral@gmail.com\">dr.christian.kral@gmail.com</a></dd>
<dt>Johan Andreasson</dt>
    <dd><a href=\"http://www.modelon.se/\">Modelon AB</a></dd>
    <dd>Ideon Science Park</dd>
    <dd>22370 Lund, Sweden</dd>
    <dd>email: <a href=\"mailto:johan.andreasson@modelon.se\">johan.andreasson@modelon.se</a></dd>
</dl>

<p>Copyright &copy; 1998-2013, Modelica Association, DLR, AIT, and Modelon AB. </p>
<p><i>This Modelica package is <b>free</b> software; it can be redistributed and/or modified under the terms of the <b>Modelica license</b>, see the license conditions and the accompanying <b>disclaimer</b> in <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a>.</i> </p>
</html>"));
  end Icons;

  package SIunits
  "Library of type and unit definitions based on SI units according to ISO 31-1992"
    extends Modelica.Icons.Package;

    package Icons "Icons for SIunits"
      extends Modelica.Icons.IconsPackage;

      partial function Conversion "Base icon for conversion functions"

        annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                  -100},{100,100}}), graphics={
              Rectangle(
                extent={{-100,100},{100,-100}},
                lineColor={191,0,0},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid),
              Line(points={{-90,0},{30,0}}, color={191,0,0}),
              Polygon(
                points={{90,0},{30,20},{30,-20},{90,0}},
                lineColor={191,0,0},
                fillColor={191,0,0},
                fillPattern=FillPattern.Solid),
              Text(
                extent={{-115,155},{115,105}},
                textString="%name",
                lineColor={0,0,255})}));
      end Conversion;
    end Icons;

    package Conversions
    "Conversion functions to/from non SI units and type definitions of non SI units"
      extends Modelica.Icons.Package;

      package NonSIunits "Type definitions of non SI units"
        extends Modelica.Icons.Package;

        type Temperature_degC = Real (final quantity="ThermodynamicTemperature",
              final unit="degC")
        "Absolute temperature in degree Celsius (for relative temperature use SIunits.TemperatureDifference)"
                                                                                                            annotation(absoluteValue=true);

        type Pressure_bar = Real (final quantity="Pressure", final unit="bar")
        "Absolute pressure in bar";
        annotation (Documentation(info="<HTML>
<p>
This package provides predefined types, such as <b>Angle_deg</b> (angle in
degree), <b>AngularVelocity_rpm</b> (angular velocity in revolutions per
minute) or <b>Temperature_degF</b> (temperature in degree Fahrenheit),
which are in common use but are not part of the international standard on
units according to ISO 31-1992 \"General principles concerning quantities,
units and symbols\" and ISO 1000-1992 \"SI units and recommendations for
the use of their multiples and of certain other units\".</p>
<p>If possible, the types in this package should not be used. Use instead
types of package Modelica.SIunits. For more information on units, see also
the book of Francois Cardarelli <b>Scientific Unit Conversion - A
Practical Guide to Metrication</b> (Springer 1997).</p>
<p>Some units, such as <b>Temperature_degC/Temp_C</b> are both defined in
Modelica.SIunits and in Modelica.Conversions.NonSIunits. The reason is that these
definitions have been placed erroneously in Modelica.SIunits although they
are not SIunits. For backward compatibility, these type definitions are
still kept in Modelica.SIunits.</p>
</html>"),   Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Text(
          origin={15.0,51.8518},
          extent={{-105.0,-86.8518},{75.0,-16.8518}},
          lineColor={0,0,0},
          textString="[km/h]")}));
      end NonSIunits;

      function to_degC "Convert from Kelvin to degCelsius"
        extends Modelica.SIunits.Icons.Conversion;
        input Temperature Kelvin "Kelvin value";
        output NonSIunits.Temperature_degC Celsius "Celsius value";
      algorithm
        Celsius := Kelvin + Modelica.Constants.T_zero;
        annotation (Inline=true,Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                  -100},{100,100}}), graphics={Text(
                extent={{-20,100},{-100,20}},
                lineColor={0,0,0},
                textString="K"), Text(
                extent={{100,-20},{20,-100}},
                lineColor={0,0,0},
                textString="degC")}));
      end to_degC;

      function from_degC "Convert from degCelsius to Kelvin"
        extends Modelica.SIunits.Icons.Conversion;
        input NonSIunits.Temperature_degC Celsius "Celsius value";
        output Temperature Kelvin "Kelvin value";
      algorithm
        Kelvin := Celsius - Modelica.Constants.T_zero;
        annotation (Inline=true,Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                  -100},{100,100}}), graphics={Text(
                extent={{-20,100},{-100,20}},
                lineColor={0,0,0},
                textString="degC"),  Text(
                extent={{100,-20},{20,-100}},
                lineColor={0,0,0},
                textString="K")}));
      end from_degC;

      function to_bar "Convert from Pascal to bar"
        extends Modelica.SIunits.Icons.Conversion;
        input Pressure Pa "Pascal value";
        output NonSIunits.Pressure_bar bar "bar value";
      algorithm
        bar := Pa/1e5;
        annotation (Inline=true,Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                  -100},{100,100}}), graphics={Text(
                extent={{-12,100},{-100,56}},
                lineColor={0,0,0},
                textString="Pa"),     Text(
                extent={{98,-52},{-4,-100}},
                lineColor={0,0,0},
                textString="bar")}));
      end to_bar;
      annotation (                              Documentation(info="<HTML>
<p>This package provides conversion functions from the non SI Units
defined in package Modelica.SIunits.Conversions.NonSIunits to the
corresponding SI Units defined in package Modelica.SIunits and vice
versa. It is recommended to use these functions in the following
way (note, that all functions have one Real input and one Real output
argument):</p>
<pre>
  <b>import</b> SI = Modelica.SIunits;
  <b>import</b> Modelica.SIunits.Conversions.*;
     ...
  <b>parameter</b> SI.Temperature     T   = from_degC(25);   // convert 25 degree Celsius to Kelvin
  <b>parameter</b> SI.Angle           phi = from_deg(180);   // convert 180 degree to radian
  <b>parameter</b> SI.AngularVelocity w   = from_rpm(3600);  // convert 3600 revolutions per minutes
                                                      // to radian per seconds
</pre>

</html>"));
    end Conversions;

    type Angle = Real (
        final quantity="Angle",
        final unit="rad",
        displayUnit="deg");

    type Length = Real (final quantity="Length", final unit="m");

    type Volume = Real (final quantity="Volume", final unit="m3");

    type Time = Real (final quantity="Time", final unit="s");

    type AngularVelocity = Real (
        final quantity="AngularVelocity",
        final unit="rad/s");

    type Velocity = Real (final quantity="Velocity", final unit="m/s");

    type Acceleration = Real (final quantity="Acceleration", final unit="m/s2");

    type Frequency = Real (final quantity="Frequency", final unit="Hz");

    type Mass = Real (
        quantity="Mass",
        final unit="kg",
        min=0);

    type Density = Real (
        final quantity="Density",
        final unit="kg/m3",
        displayUnit="g/cm3",
        min=0.0);

    type Pressure = Real (
        final quantity="Pressure",
        final unit="Pa",
        displayUnit="bar");

    type AbsolutePressure = Pressure (min=0.0, nominal = 1e5);

    type DynamicViscosity = Real (
        final quantity="DynamicViscosity",
        final unit="Pa.s",
        min=0);

    type Energy = Real (final quantity="Energy", final unit="J");

    type Power = Real (final quantity="Power", final unit="W");

    type EnthalpyFlowRate = Real (final quantity="EnthalpyFlowRate", final unit=
            "W");

    type MassFlowRate = Real (quantity="MassFlowRate", final unit="kg/s");

    type VolumeFlowRate = Real (final quantity="VolumeFlowRate", final unit=
            "m3/s");

    type ThermodynamicTemperature = Real (
        final quantity="ThermodynamicTemperature",
        final unit="K",
        min = 0.0,
        start = 288.15,
        nominal = 300,
        displayUnit="degC")
    "Absolute temperature (use type TemperatureDifference for relative temperatures)"
                                                                                                        annotation(absoluteValue=true);

    type Temperature = ThermodynamicTemperature;

    type TemperatureDifference = Real (
        final quantity="ThermodynamicTemperature",
        final unit="K") annotation(absoluteValue=false);

    type TemperatureSlope = Real (final quantity="TemperatureSlope",
        final unit="K/s");

    type Compressibility = Real (final quantity="Compressibility", final unit=
            "1/Pa");

    type IsothermalCompressibility = Compressibility;

    type HeatFlowRate = Real (final quantity="Power", final unit="W");

    type ThermalConductivity = Real (final quantity="ThermalConductivity", final unit=
               "W/(m.K)");

    type ThermalConductance = Real (final quantity="ThermalConductance", final unit=
               "W/K");

    type HeatCapacity = Real (final quantity="HeatCapacity", final unit="J/K");

    type SpecificHeatCapacity = Real (final quantity="SpecificHeatCapacity",
          final unit="J/(kg.K)");

    type RatioOfSpecificHeatCapacities = Real (final quantity=
            "RatioOfSpecificHeatCapacities", final unit="1");

    type SpecificEntropy = Real (final quantity="SpecificEntropy",
                                 final unit="J/(kg.K)");

    type SpecificEnergy = Real (final quantity="SpecificEnergy",
                                final unit="J/kg");

    type SpecificInternalEnergy = SpecificEnergy;

    type SpecificEnthalpy = SpecificEnergy;

    type DerDensityByEnthalpy = Real (final unit="kg.s2/m5");

    type DerDensityByPressure = Real (final unit="s2/m2");

    type DerDensityByTemperature = Real (final unit="kg/(m3.K)");

    type MolarMass = Real (final quantity="MolarMass", final unit="kg/mol",min=0);

    type MassFraction = Real (final quantity="MassFraction", final unit="1",
                              min=0, max=1);

    type PrandtlNumber = Real (final quantity="PrandtlNumber", final unit="1");
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics={
          Line(
            points={{-66,78},{-66,-40}},
            color={64,64,64},
            smooth=Smooth.None),
          Ellipse(
            extent={{12,36},{68,-38}},
            lineColor={64,64,64},
            fillColor={175,175,175},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-74,78},{-66,-40}},
            lineColor={64,64,64},
            fillColor={175,175,175},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-66,-4},{-66,6},{-16,56},{-16,46},{-66,-4}},
            lineColor={64,64,64},
            smooth=Smooth.None,
            fillColor={175,175,175},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-46,16},{-40,22},{-2,-40},{-10,-40},{-46,16}},
            lineColor={64,64,64},
            smooth=Smooth.None,
            fillColor={175,175,175},
            fillPattern=FillPattern.Solid),
          Ellipse(
            extent={{22,26},{58,-28}},
            lineColor={64,64,64},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{68,2},{68,-46},{64,-60},{58,-68},{48,-72},{18,-72},{18,-64},
                {46,-64},{54,-60},{58,-54},{60,-46},{60,-26},{64,-20},{68,-6},{68,
                2}},
            lineColor={64,64,64},
            smooth=Smooth.Bezier,
            fillColor={175,175,175},
            fillPattern=FillPattern.Solid)}), Documentation(info="<html>
<p>This package provides predefined types, such as <i>Mass</i>,
<i>Angle</i>, <i>Time</i>, based on the international standard
on units, e.g.,
</p>

<pre>   <b>type</b> Angle = Real(<b>final</b> quantity = \"Angle\",
                     <b>final</b> unit     = \"rad\",
                     displayUnit    = \"deg\");
</pre>

<p>
as well as conversion functions from non SI-units to SI-units
and vice versa in subpackage
<a href=\"modelica://Modelica.SIunits.Conversions\">Conversions</a>.
</p>

<p>
For an introduction how units are used in the Modelica standard library
with package SIunits, have a look at:
<a href=\"modelica://Modelica.SIunits.UsersGuide.HowToUseSIunits\">How to use SIunits</a>.
</p>

<p>
Copyright &copy; 1998-2013, Modelica Association and DLR.
</p>
<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"https://www.modelica.org/licenses/ModelicaLicense2\"> https://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>
</html>",   revisions="<html>
<ul>
<li><i>May 25, 2011</i> by Stefan Wischhusen:<br/>Added molar units for energy and enthalpy.</li>
<li><i>Jan. 27, 2010</i> by Christian Kral:<br/>Added complex units.</li>
<li><i>Dec. 14, 2005</i> by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br/>Add User&#39;;s Guide and removed &quot;min&quot; values for Resistance and Conductance.</li>
<li><i>October 21, 2002</i> by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a> and <a href=\"http://www.robotic.dlr.de/Christian.Schweiger/\">Christian Schweiger</a>:<br/>Added new package <b>Conversions</b>. Corrected typo <i>Wavelenght</i>.</li>
<li><i>June 6, 2000</i> by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br/>Introduced the following new types<br/>type Temperature = ThermodynamicTemperature;<br/>types DerDensityByEnthalpy, DerDensityByPressure, DerDensityByTemperature, DerEnthalpyByPressure, DerEnergyByDensity, DerEnergyByPressure<br/>Attribute &quot;final&quot; removed from min and max values in order that these values can still be changed to narrow the allowed range of values.<br/>Quantity=&quot;Stress&quot; removed from type &quot;Stress&quot;, in order that a type &quot;Stress&quot; can be connected to a type &quot;Pressure&quot;.</li>
<li><i>Oct. 27, 1999</i> by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br/>New types due to electrical library: Transconductance, InversePotential, Damping.</li>
<li><i>Sept. 18, 1999</i> by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br/>Renamed from SIunit to SIunits. Subpackages expanded, i.e., the SIunits package, does no longer contain subpackages.</li>
<li><i>Aug 12, 1999</i> by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br/>Type &quot;Pressure&quot; renamed to &quot;AbsolutePressure&quot; and introduced a new type &quot;Pressure&quot; which does not contain a minimum of zero in order to allow convenient handling of relative pressure. Redefined BulkModulus as an alias to AbsolutePressure instead of Stress, since needed in hydraulics.</li>
<li><i>June 29, 1999</i> by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a>:<br/>Bug-fix: Double definition of &quot;Compressibility&quot; removed and appropriate &quot;extends Heat&quot; clause introduced in package SolidStatePhysics to incorporate ThermodynamicTemperature.</li>
<li><i>April 8, 1998</i> by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a> and Astrid Jaschinski:<br/>Complete ISO 31 chapters realized.</li>
<li><i>Nov. 15, 1997</i> by <a href=\"http://www.robotic.dlr.de/Martin.Otter/\">Martin Otter</a> and <a href=\"http://www.control.lth.se/~hubertus/\">Hubertus Tummescheit</a>:<br/>Some chapters realized.</li>
</ul>
</html>"));
  end SIunits;
annotation (
preferredView="info",
version="3.2.1",
versionBuild=2,
versionDate="2013-08-14",
dateModified = "2013-08-14 08:44:41Z",
revisionId="$Id:: package.mo 6947 2013-08-23 07:41:37Z #$",
uses(Complex(version="3.2.1"), ModelicaServices(version="3.2.1")),
conversion(
 noneFromVersion="3.2",
 noneFromVersion="3.1",
 noneFromVersion="3.0.1",
 noneFromVersion="3.0",
 from(version="2.1", script="modelica://Modelica/Resources/Scripts/Dymola/ConvertModelica_from_2.2.2_to_3.0.mos"),
 from(version="2.2", script="modelica://Modelica/Resources/Scripts/Dymola/ConvertModelica_from_2.2.2_to_3.0.mos"),
 from(version="2.2.1", script="modelica://Modelica/Resources/Scripts/Dymola/ConvertModelica_from_2.2.2_to_3.0.mos"),
 from(version="2.2.2", script="modelica://Modelica/Resources/Scripts/Dymola/ConvertModelica_from_2.2.2_to_3.0.mos")),
Icon(coordinateSystem(extent={{-100.0,-100.0},{100.0,100.0}}), graphics={
  Polygon(
    origin={-6.9888,20.048},
    fillColor={0,0,0},
    pattern=LinePattern.None,
    fillPattern=FillPattern.Solid,
    points={{-93.0112,10.3188},{-93.0112,10.3188},{-73.011,24.6},{-63.011,31.221},{-51.219,36.777},{-39.842,38.629},{-31.376,36.248},{-25.819,29.369},{-24.232,22.49},{-23.703,17.463},{-15.501,25.135},{-6.24,32.015},{3.02,36.777},{15.191,39.423},{27.097,37.306},{32.653,29.633},{35.035,20.108},{43.501,28.046},{54.085,35.19},{65.991,39.952},{77.897,39.688},{87.422,33.338},{91.126,21.696},{90.068,9.525},{86.099,-1.058},{79.749,-10.054},{71.283,-21.431},{62.816,-33.337},{60.964,-32.808},{70.489,-16.14},{77.368,-2.381},{81.072,10.054},{79.749,19.05},{72.605,24.342},{61.758,23.019},{49.587,14.817},{39.003,4.763},{29.214,-6.085},{21.012,-16.669},{13.339,-26.458},{5.401,-36.777},{-1.213,-46.037},{-6.24,-53.446},{-8.092,-52.387},{-0.684,-40.746},{5.401,-30.692},{12.81,-17.198},{19.424,-3.969},{23.658,7.938},{22.335,18.785},{16.514,23.283},{8.047,23.019},{-1.478,19.05},{-11.267,11.113},{-19.734,2.381},{-29.259,-8.202},{-38.519,-19.579},{-48.044,-31.221},{-56.511,-43.392},{-64.449,-55.298},{-72.386,-66.939},{-77.678,-74.612},{-79.53,-74.083},{-71.857,-61.383},{-62.861,-46.037},{-52.278,-28.046},{-44.869,-15.346},{-38.784,-2.117},{-35.344,8.731},{-36.403,19.844},{-42.488,23.813},{-52.013,22.49},{-60.744,16.933},{-68.947,10.054},{-76.884,2.646},{-93.0112,-12.1707},{-93.0112,-12.1707}},
    smooth=Smooth.Bezier),
  Ellipse(
    origin={40.8208,-37.7602},
    fillColor={161,0,4},
    pattern=LinePattern.None,
    fillPattern=FillPattern.Solid,
    extent={{-17.8562,-17.8563},{17.8563,17.8562}})}),
Documentation(info="<HTML>
<p>
Package <b>Modelica&reg;</b> is a <b>standardized</b> and <b>free</b> package
that is developed together with the Modelica&reg; language from the
Modelica Association, see
<a href=\"https://www.Modelica.org\">https://www.Modelica.org</a>.
It is also called <b>Modelica Standard Library</b>.
It provides model components in many domains that are based on
standardized interface definitions. Some typical examples are shown
in the next figure:
</p>

<p>
<img src=\"modelica://Modelica/Resources/Images/UsersGuide/ModelicaLibraries.png\">
</p>

<p>
For an introduction, have especially a look at:
</p>
<ul>
<li> <a href=\"modelica://Modelica.UsersGuide.Overview\">Overview</a>
  provides an overview of the Modelica Standard Library
  inside the <a href=\"modelica://Modelica.UsersGuide\">User's Guide</a>.</li>
<li><a href=\"modelica://Modelica.UsersGuide.ReleaseNotes\">Release Notes</a>
 summarizes the changes of new versions of this package.</li>
<li> <a href=\"modelica://Modelica.UsersGuide.Contact\">Contact</a>
  lists the contributors of the Modelica Standard Library.</li>
<li> The <b>Examples</b> packages in the various libraries, demonstrate
  how to use the components of the corresponding sublibrary.</li>
</ul>

<p>
This version of the Modelica Standard Library consists of
</p>
<ul>
<li><b>1360</b> models and blocks, and</li>
<li><b>1280</b> functions</li>
</ul>
<p>
that are directly usable (= number of public, non-partial classes). It is fully compliant
to <a href=\"https://www.modelica.org/documents/ModelicaSpec32Revision2.pdf\">Modelica Specification Version 3.2 Revision 2</a>
and it has been tested with Modelica tools from different vendors.
</p>

<p>
<b>Licensed by the Modelica Association under the Modelica License 2</b><br>
Copyright &copy; 1998-2013, ABB, AIT, T.&nbsp;B&ouml;drich, DLR, Dassault Syst&egrave;mes AB, Fraunhofer, A.Haumer, ITI, Modelon,
TU Hamburg-Harburg, Politecnico di Milano, XRG Simulation.
</p>

<p>
<i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica License 2. For license conditions (including the disclaimer of warranty) see <a href=\"modelica://Modelica.UsersGuide.ModelicaLicense2\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"https://www.modelica.org/licenses/ModelicaLicense2\"> https://www.modelica.org/licenses/ModelicaLicense2</a>.</i>
</p>

<p>
<b>Modelica&reg;</b> is a registered trademark of the Modelica Association.
</p>
</html>"));
end Modelica;

package IDEAS "Integrated District Energy Assessment Simulation"
  extends Modelica.Icons.Library;
  import SI = Modelica.SIunits;

  package Thermal "Thermal systems, HVAC and thermal renewable energy"
    extends Modelica.Icons.Package;
  import SI = Modelica.SIunits;
  import Annex60;

    package Components
    "Thermal models for building HVAC systems and their control"
      extends Modelica.Icons.Package;

      package Production "Models for heat/cold production devices"
        extends Modelica.Icons.Package;

        model Boiler_a60
        "Modulating boiler with losses to environment, based on performance tables. Flow reversal is not allowed because the HeatSource is based on the inflow temperature from flowPort_a"
          extends
          IDEAS.Thermal.Components.Production.Interfaces.PartialDynamicHeaterWithLosses_a60
          (   final heaterType=IDEAS.Thermal.Components.Production.BaseClasses.HeaterType.Boiler,
              heatedFluid(allowFlowReversal=false, show_T=show_T));

          Real eta "Instanteanous efficiency";

          BaseClasses.HeatSource_CondensingGasBurner_a60   heatSource(
            redeclare package Medium=Medium,
            QNom=QNom,
            TBoilerSet=TSet,
            TEnvironment=heatPort.T,
            UALoss=UALoss,
            THxIn=Medium.temperature( Medium.setState_phX( flowPort_a.p, actualStream(flowPort_a.h_outflow))),
            m_flowHx=flowPort_a.m_flow,
            modulationMin=modulationMin,
            modulationStart=modulationStart)
            annotation (Placement(transformation(extent={{-68,20},{-48,40}})));
          parameter Real modulationMin=25 "Minimal modulation percentage";
          parameter Real modulationStart=35
          "Min estimated modulation level required for start of HP";

          Modelica.SIunits.Temperature T_in;
          Modelica.SIunits.Temperature T_out;
          parameter Boolean show_T= false
          "= true, if actual temperature at port is computed";
        equation
          // Electricity consumption for electronics and fan only.  Pump is covered by pumpHeater;
          // This data is taken from Viessmann VitoDens 300W, smallest model.  So only valid for
          // very small household condensing gas boilers.
          PEl = 7 + heatSource.modulation/100 * (33-7);
          PFuel = heatSource.PFuel;
          eta = heatSource.eta;

        T_in = Medium.temperature( Medium.setState_phX( flowPort_a.p, actualStream(flowPort_a.h_outflow)));
        T_out = heatedFluid.vol.T;
          // Notice: T_out can also be written as:
          // T_out = Medium.temperature( Medium.setState_phX( flowPort_b.p, actualStream(flowPort_b.h_outflow)));

          connect(heatSource.heatPort, heatedFluid.heatPort) annotation (Line(
              points={{-48,30},{-10,30},{-10,6.12323e-016}},
              color={191,0,0},
              smooth=Smooth.None));
          annotation (Diagram(graphics), Icon(graphics={
                Ellipse(
                  extent={{-58,60},{60,-60}},
                  lineColor={127,0,0},
                  fillPattern=FillPattern.Solid,
                  fillColor={255,255,255}),
                Ellipse(extent={{-46,46},{48,-46}}, lineColor={95,95,95}),
                Line(
                  points={{-30,34},{32,-34}},
                  color={95,95,95},
                  smooth=Smooth.None),
                Line(
                  points={{100,20},{44,20}},
                  color={0,0,127},
                  smooth=Smooth.None),
                Line(
                  points={{102,-40},{70,-40},{70,-80},{0,-80},{0,-46}},
                  color={0,0,127},
                  smooth=Smooth.None)}),
            Documentation(info="<html>
<p><h4><font color=\"#008000\">Description </font></h4></p>
<p>Dynamic boiler model, based on interpolation in performance tables. The boiler has thermal losses to the environment which are often not mentioned in the performance tables. Therefore, the additional environmental heat losses are added to the heat production in order to ensure the same performance as in the manufacturers data, while still obtaining a dynamic model with heat losses (also when boiler is off). The heatSource will compute the required power and the environmental heat losses, and try to reach the set point. </p>
<p>See<a href=\"modelica://IDEAS.Thermal.Components.Production.Interfaces.PartialDynamicHeaterWithLosses\"> IDEAS.Thermal.Components.Production.Interfaces.PartialDynamicHeaterWithLosses</a> for more details about the heat losses and dynamics. </p>
<p><h4>Assumptions and limitations </h4></p>
<p><ol>
<li>Dynamic model based on water content and lumped dry capacity</li>
<li>Limited power (based on QNom and interpolation tables in heatSource) </li>
<li>Heat losses to environment which are compensated &apos;artifically&apos; to meet the manufacturers data in steady state conditions</li>
<li>No enforced min on or min off time; Hysteresis on start/stop thanks to different parameters for minimum modulation to start and stop the heat pump</li>
</ol></p>
<p><h4>Model use</h4></p>
<p>This model is based on performance tables of a specific boiler, as specified by <a href=\"modelica://IDEAS.Thermal.Components.Production.BaseClasses.HeatSource_CondensingGasBurner\">IDEAS.Thermal.Components.Production.BaseClasses.HeatSource_CondensingGasBurner</a>. If a different gas boiler is to be simulated, create a different Burner model with adapted interpolation tables.</p>
<p><ol>
<li>Specify medium and initial temperature (of the water + dry mass)</li>
<li>Specify the nominal power</li>
<li>Specify the minimum required modulation level for the boiler to start (modulation_start) and the minimum modulation level when the boiler is operating (modulation_min). The difference between both will ensure some off-time in case of low heat demands</li>
<li>Connect TSet, the flowPorts and the heatPort to environment. </li>
</ol></p>
<p>See also<a href=\"modelica://IDEAS.Thermal.Components.Production.Interfaces.PartialDynamicHeaterWithLosses\"> IDEAS.Thermal.Components.Production.Interfaces.PartialDynamicHeaterWithLosses</a> for more details about the heat losses and dynamics. </p>
<p><h4>Validation </h4></p>
<p>The model has been verified in order to check if the &apos;artificial&apos; heat loss compensation still leads to correct steady state efficiencies according to the manufacturer data. This verification is integrated in the example model <a href=\"modelica://IDEAS.Thermal.Components.Examples.Boiler_validation\">IDEAS.Thermal.Components.Examples.Boiler_validation</a>.</p>
<p><h4>Example</h4></p>
<p>See validation.</p>
</html>",         revisions="<html>
<p><ul>
<li>2013 May, Roel De Coninck: documentation</li>
<li>2011 August, Roel De Coninck: first version</li>
</ul></p>
</html>"));
        end Boiler_a60;

        package BaseClasses
        "Partials, submodels and general stuff to be used in other HVAC models"
          extends Modelica.Icons.BasesPackage;

          type HeaterType = enumeration(
            HP_AW "Air/water Heat pump",
            HP_BW "Brine/water Heat pump",
            HP_BW_Collective "Brine/water HP with collective borefield",
            Boiler "Boiler")
          "Type of the heater: heat pump, gas boiler, fuel boiler, pellet boiler, ...";

          model HeatSource_CondensingGasBurner_a60
          "Burner for use in Boiler, based on interpolation data.  Takes into account losses of the boiler to the environment"

            //protected
            replaceable package Medium =
                Modelica.Media.Interfaces.PartialMedium
            "Medium in the component"
                annotation (choicesAllMatching = true);

            final parameter Real[6] modVector = {0, 20, 40, 60, 80, 100}
            "6 modulation steps, %";
            Real eta
            "Instantaneous efficiency of the boiler (higher heating value)";
            Real[6] etaVector
            "Thermal efficiency (higher heating value) for 6 modulation steps, base 1";
            Real[6] QVector "Thermal power for 6 modulation steps, in kW";
            Modelica.SIunits.Power QMax
            "Maximum thermal power at specified evap and condr temperatures, in W";
            Modelica.SIunits.Power QAsked(start=0);
            parameter Modelica.SIunits.ThermalConductance UALoss
            "UA of heat losses of HP to environment";
            parameter Modelica.SIunits.Power QNom
            "The power at nominal conditions (50/30)";

        public
            parameter Real etaNom = 0.922
            "Nominal efficiency (higher heating value)of the xxx boiler at 50/30degC.  See datafile";
            parameter Real modulationMin(max=29)=25
            "Minimal modulation percentage";
              // dont' set this to 0 or very low values, you might get negative P at very low modulations because of wrong extrapolation
            parameter Real modulationStart(min=min(30,modulationMin+5)) = 35
            "Min estimated modulation level required for start of HP";
            Real modulationInit
            "Initial modulation, decides on start/stop of the boiler";
            Real modulation(min=0, max=1) "Current modulation percentage";
            Modelica.SIunits.Power PFuel "Resulting fuel consumption";
            input Modelica.SIunits.Temperature THxIn "Condensor temperature";
            input Modelica.SIunits.Temperature TBoilerSet
            "Condensor setpoint temperature.  Not always possible to reach it";
            input Modelica.SIunits.MassFlowRate m_flowHx
            "Condensor mass flow rate";
            input Modelica.SIunits.Temperature TEnvironment
            "Temperature of environment for heat losses";

        protected
            Real kgps2lph = 3600 / Medium.density(sta_default) * 1000
            "Conversion from kg/s to l/h";
            Modelica.Blocks.Tables.CombiTable2D eta100(smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative, table=[0,
                  100,400,700,1000,1300; 20.0,0.9015,0.9441,0.9599,0.9691,0.9753; 30.0,0.8824,
                  0.9184,0.9324,0.941,0.9471; 40.0,0.8736,0.8909,0.902,0.9092,0.9143; 50.0,
                  0.8676,0.8731,0.8741,0.8746,0.8774; 60.0,0.8,0.867,0.8681,0.8686,0.8689;
                  70.0,0.8,0.8609,0.8619,0.8625,0.8628; 80.0,0.8,0.8547,0.8558,0.8563,0.8566])
              annotation (Placement(transformation(extent={{-58,66},{-38,86}})));
            Modelica.Blocks.Tables.CombiTable2D eta80(smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
                table=[0,100,400,700,1000,1300;20.0,0.9155,0.9587,0.9733,0.9813,0.9866;30.0,0.8937,0.9311,0.9449,0.953,0.9585;40.0,0.8753,0.9007,0.9121,0.9192,0.9242;50.0,0.8691,0.8734,0.8755,0.8804,0.884;60.0,0.8628,0.8671,0.8679,0.8683,0.8686;70.0,0.7415,0.8607,0.8616,0.862,0.8622;80.0,0.6952,0.8544,0.8552,0.8556,0.8559])
              annotation (Placement(transformation(extent={{-58,32},{-38,52}})));
            Modelica.Blocks.Tables.CombiTable2D eta60(smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
                table=[0,100,400,700,1000,1300;20.0,0.9349,0.9759,0.9879,0.9941,0.998;30.0,0.9096,0.9471,0.9595,0.9664,0.9709;40.0,0.8831,0.9136,0.9247,0.9313,0.9357;50.0,0.8701,0.8759,0.8838,0.8887,0.8921;60.0,0.8634,0.8666,0.8672,0.8675,0.8677;70.0,0.8498,0.8599,0.8605,0.8608,0.861;80.0,0.8488,0.8532,0.8538,0.8541,0.8543])
              annotation (Placement(transformation(extent={{-58,-6},{-38,14}})));
            Modelica.Blocks.Tables.CombiTable2D eta40(smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
                table=[0,100,400,700,1000,1300;20.0,0.9624,0.9947,0.9985,0.9989,0.999;30.0,0.9333,0.9661,0.9756,0.9803,0.9833;40.0,0.901,0.9306,0.94,0.9451,0.9485;50.0,0.8699,0.8871,0.8946,0.8989,0.9018;60.0,0.8626,0.8647,0.8651,0.8653,0.8655;70.0,0.8553,0.8573,0.8577,0.8579,0.8581;80.0,0.8479,0.8499,0.8503,0.8505,0.8506])
              annotation (Placement(transformation(extent={{-58,-44},{-38,-24}})));
            Modelica.Blocks.Tables.CombiTable2D eta20(smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
                table=[0,100,400,700,1000,1300;20.0,0.9969,0.9987,0.999,0.999,0.999;30.0,0.9671,0.9859,0.99,0.9921,0.9934;40.0,0.9293,0.9498,0.9549,0.9575,0.9592;50.0,0.8831,0.9003,0.9056,0.9083,0.9101;60.0,0.8562,0.857,0.8575,0.8576,0.8577;70.0,0.8398,0.8479,0.8481,0.8482,0.8483;80.0,0.8374,0.8384,0.8386,0.8387,0.8388])
              annotation (Placement(transformation(extent={{-58,-86},{-38,-66}})));

            Modelica.SIunits.HeatFlowRate QLossesToCompensate
            "Environment losses";

            parameter Medium.ThermodynamicState sta_default=Medium.setState_pTX(
                T=Medium.T_default, p=Medium.p_default, X=Medium.X_default);
            parameter Modelica.SIunits.Density rho_default=Medium.density(sta_default)
            "Density, used to compute fluid volume";

          //    Boolean QVecOk(start = true);
        public
            Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
            "heatPort connection to water in condensor"
              annotation (Placement(transformation(extent={{90,-10},{110,10}})));
            IDEAS.BaseClasses.Control.Hyst_NoEvent
                                         onOff(
              uLow = modulationMin,
              uHigh = modulationStart,
              y(
              start = 0),
              enableRelease=true) "on-off, based on modulationInit"
              annotation (Placement(transformation(extent={{28,40},{48,60}})));

          equation
            assert( m_flowHx*kgps2lph >= 0 and  m_flowHx*kgps2lph < 1300,  "The mass flow rate is outside the range of the boiler (m_flow = " + String(m_flowHx*kgps2lph) + " l/h) but should be between 0 and 1300");
            assert( THxIn - 273.15 >= 0 and THxIn - 273.15 < 70, "The input temperature is outside the range of the interpolation table. Please ensure that THxIn (" + String(THxIn - 273.15) + "degC) is higher than 0 and lower than 70 degC");

            onOff.release = if noEvent(m_flowHx > 0) then 1.0 else 0.0;
            QAsked = max(0, m_flowHx*Medium.specificHeatCapacityCp(sta_default)*(
              TBoilerSet - THxIn));
            eta100.u1 = THxIn - 273.15;
            eta100.u2 = m_flowHx*kgps2lph;
            eta80.u1 = THxIn - 273.15;
            eta80.u2 = m_flowHx*kgps2lph;
            eta60.u1 = THxIn - 273.15;
            eta60.u2 = m_flowHx*kgps2lph;
            eta40.u1 = THxIn - 273.15;
            eta40.u2 = m_flowHx*kgps2lph;
            eta20.u1 = THxIn - 273.15;
            eta20.u2 = m_flowHx*kgps2lph;

            // all these are in kW
            etaVector[1] = 0;
            etaVector[2] = eta20.y;
            etaVector[3] = eta40.y;
            etaVector[4] = eta60.y;
            etaVector[5] = eta80.y;
            etaVector[6] = eta100.y;
            QVector = etaVector/etaNom .* modVector/100*QNom;     // in W
            QMax = QVector[6];

            modulationInit = Modelica.Math.Vectors.interpolate(
              QVector,
              modVector,
              QAsked);
            eta = Modelica.Math.Vectors.interpolate(
              modVector,
              etaVector,
              modulation);

            modulation = onOff.y*min(modulationInit, 100);

            onOff.u = modulationInit;

            // compensation of heat losses (only when the hp is operating)
            QLossesToCompensate = if noEvent(modulation > 0) then UALoss*(heatPort.T -
              TEnvironment) else 0;

            heatPort.Q_flow = -Modelica.Math.Vectors.interpolate(
              modVector,
              QVector,
              modulation) - QLossesToCompensate;
            PFuel = if noEvent(modulation > 0) then -heatPort.Q_flow/eta else 0;

            annotation (Diagram(graphics),
                        Diagram(graphics),
              Documentation(info="<html>
<p><b>Description</b> </p>
<p>This&nbsp;model&nbsp;is&nbsp;based&nbsp;on&nbsp;data&nbsp;from&nbsp;a Remeha boiler. It is used in the <a href=\"modelica://IDEAS.Thermal.Components.Production.Boiler\">Boiler</a> model. </p>
<p>The&nbsp;nominal&nbsp;power&nbsp;of&nbsp;the&nbsp;original&nbsp;boiler&nbsp;is&nbsp;10.1&nbsp;kW&nbsp;at &nbsp;50/30 degC&nbsp;water&nbsp;temperatures.&nbsp;&nbsp;&nbsp;The&nbsp;efficiency&nbsp;in&nbsp;this&nbsp;point&nbsp;is&nbsp;92.2&percnt;&nbsp;on&nbsp;higher&nbsp;heating&nbsp;value.&nbsp;</p>
<p>First,&nbsp;the&nbsp;efficiency&nbsp;is&nbsp;interpolated&nbsp;for&nbsp;the&nbsp;&nbsp;return&nbsp;water&nbsp;temperature&nbsp;and&nbsp;flowrate&nbsp;at&nbsp;5&nbsp;different&nbsp;modulation&nbsp;levels.&nbsp;These&nbsp;modulation&nbsp;levels&nbsp;are&nbsp;the&nbsp;FUEL&nbsp;input&nbsp;power&nbsp;to&nbsp;the&nbsp;boiler.&nbsp;&nbsp;The&nbsp;results&nbsp;&nbsp;are&nbsp;rescaled&nbsp;to&nbsp;the&nbsp;nominal&nbsp;power&nbsp;of&nbsp;the&nbsp;modelled&nbsp;heatpump&nbsp;(with&nbsp;QNom/QNom_data)&nbsp;and&nbsp;&nbsp;stored&nbsp;in&nbsp;a&nbsp;vector,&nbsp;eta_vector.</p>
<p>Finally,&nbsp;the&nbsp;initial&nbsp;modulation&nbsp;is&nbsp;calculated&nbsp;based&nbsp;on&nbsp;the&nbsp;asked&nbsp;power&nbsp;and&nbsp;the&nbsp;max&nbsp;power&nbsp;at&nbsp;&nbsp;operating&nbsp;conditions:&nbsp;</p>
<p><ul>
<li>&nbsp;&nbsp;if&nbsp;modulation_init&nbsp;&LT;&nbsp;modulation_min,&nbsp;the&nbsp;boiler&nbsp;is&nbsp;OFF,&nbsp;modulation&nbsp;=&nbsp;0.&nbsp;&nbsp;</li>
<li>&nbsp;&nbsp;if&nbsp;modulation_init&nbsp;&GT;&nbsp;100&percnt;,&nbsp;the&nbsp;modulation&nbsp;is&nbsp;100&percnt;</li>
<li>&nbsp;&nbsp;if&nbsp;modulation_init&nbsp;between&nbsp;modulation_min&nbsp;and&nbsp;modulation_start:&nbsp;hysteresis&nbsp;for&nbsp;on/off&nbsp;cycling.</li>
</ul></p>
<p>If&nbsp;the&nbsp;boiler&nbsp;is&nbsp;on&nbsp;another&nbsp;modulation,&nbsp;interpolation&nbsp;is&nbsp;made&nbsp;to&nbsp;get&nbsp;eta&nbsp;at&nbsp;the&nbsp;real&nbsp;modulation.</p>
<p><h4>ATTENTION</h4></p>
<p>This&nbsp;model&nbsp;takes&nbsp;into&nbsp;account&nbsp;environmental&nbsp;heat&nbsp;losses&nbsp;of&nbsp;the&nbsp;boiler.&nbsp;&nbsp;In&nbsp;order&nbsp;to&nbsp;keep&nbsp;the&nbsp;same&nbsp;nominal&nbsp;eta&apos;s&nbsp;during&nbsp;operation,&nbsp;these&nbsp;heat&nbsp;losses&nbsp;are&nbsp;added&nbsp;to&nbsp;the&nbsp;computed&nbsp;power.&nbsp;&nbsp;Therefore,&nbsp;the&nbsp;heat&nbsp;losses&nbsp;are&nbsp;only&nbsp;really&nbsp;&apos;losses&apos;&nbsp;when&nbsp;the&nbsp;boiler&nbsp;is&nbsp;NOT&nbsp;operating.&nbsp;</p>
<p>The&nbsp;eta&nbsp;is&nbsp;calculated&nbsp;as&nbsp;the&nbsp;heat&nbsp;delivered&nbsp;to&nbsp;the&nbsp;heatedFluid&nbsp;divided&nbsp;by&nbsp;the&nbsp;fuel&nbsp;consumption&nbsp;PFuel.&nbsp;</p>
<p><h4>Assumptions and limitations </h4></p>
<p><ol>
<li>Based on interpolation in manufacturer data for Remeha condensing gas boiler</li>
</ol></p>
<p><h4>Model use</h4></p>
<p>This model is used in the <a href=\"modelica://IDEAS.Thermal.Components.Production.Boiler\">Boiler</a> model. If a different gas boiler is to be simulated, copy this Burner model and adapt the interpolation tables.</p>
<p><h4>Validation </h4></p>
<p>See the <a href=\"modelica://IDEAS.Thermal.Components.Production.Boiler\">Boiler</a> model. </p>
</html>",           revisions="<html>
<p><ul>
<li>2013 May, Roel De Coninck: documentation</li>
<li>2011 August, Roel De Coninck: first version</li>
</ul></p>
</html>"));
          end HeatSource_CondensingGasBurner_a60;
        end BaseClasses;

        package Interfaces
        "Contains partial classes for the IDEAS.Thermal.Components.Production package"
        extends Modelica.Icons.InterfacesPackage;

          model PartialDynamicHeaterWithLosses_a60
          "Partial heater model incl dynamics and environmental losses"
            import IDEAS;

            import IDEAS.Thermal.Components.Production.BaseClasses.HeaterType;
            replaceable package Medium =
                Modelica.Media.Interfaces.PartialMedium
            "Medium in the component"
                annotation (choicesAllMatching = true);

            parameter HeaterType heaterType
            "Type of the heater, is used mainly for post processing";
            parameter Modelica.SIunits.Temperature TInitial=293.15
            "Initial temperature of the water and dry mass";
            parameter Modelica.SIunits.Power QNom "Nominal power";

             Modelica.SIunits.Power PFuel "Fuel consumption";
            parameter Modelica.SIunits.Time tauHeatLoss=7200
            "Time constant of environmental heat losses";
            parameter Modelica.SIunits.Mass mWater=5
            "Mass of water in the condensor";
            parameter Modelica.SIunits.HeatCapacity cDry=4800
            "Capacity of dry material lumped to condensor";

            final parameter Modelica.SIunits.ThermalConductance UALoss=(cDry + mWater*
                Medium.specificHeatCapacityCp(sta_default))/tauHeatLoss;

            Modelica.Thermal.HeatTransfer.Components.HeatCapacitor mDry(C=cDry, T(start=TInitial))
            "Lumped dry mass subject to heat exchange/accumulation"
              annotation (Placement(transformation(extent={{-10,-10},{10,10}},
                  rotation=90,
                  origin={-40,-30})));
            Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalLosses(G=UALoss)
              annotation (Placement(transformation(extent={{-10,-10},{10,10}},
                  rotation=-90,
                  origin={-30,-70})));
            Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
            "heatPort for thermal losses to environment"
              annotation (Placement(transformation(extent={{-40,-110},{-20,-90}}),
                  iconTransformation(extent={{-40,-110},{-20,-90}})));
            Modelica.Blocks.Interfaces.RealInput TSet
            "Temperature setpoint, acts as on/off signal too"
              annotation (Placement(transformation(extent={{-126,-20},{-86,20}}),
                  iconTransformation(
                  extent={{-10,-10},{10,10}},
                  rotation=-90,
                  origin={-10,120})));
            Modelica.Blocks.Interfaces.RealOutput PEl "Electrical consumption" annotation (Placement(transformation(
                    extent={{-252,10},{-232,30}}), iconTransformation(
                  extent={{-10,-10},{10,10}},
                  rotation=-90,
                  origin={-74,-100})));

            parameter Medium.ThermodynamicState sta_default=Medium.setState_pTX(
                T=Medium.T_default, p=Medium.p_default, X=Medium.X_default);
            parameter Modelica.SIunits.Density rho_default=Medium.density(sta_default)
            "Density, used to compute fluid volume";

            IDEAS.Thermal.Components.BaseClasses.Pipe_HeatPort_a60_2 heatedFluid(
              redeclare package Medium = Medium,
              final V=mWater/Medium.density(sta_default),
              m_flow_nominal=m_flow_nominal,
              dp_nominal=dp_nominal,
              T_start=TInitial)                        annotation (Placement(transformation(
                  extent={{-10,10},{10,-10}},
                  rotation=90,
                  origin={0,0})));

            parameter SI.Pressure dp_nominal "Pressure";
            parameter SI.MassFlowRate m_flow_nominal "Nominal mass flow rate";
            Modelica.Fluid.Interfaces.FluidPort_b flowPort_b(redeclare package
              Medium =
                  Medium)
            "Fluid connector b (positive design flow direction is from port_a to port_b)"
              annotation (Placement(transformation(extent={{90,30},{110,50}})));
            Modelica.Fluid.Interfaces.FluidPort_a flowPort_a(redeclare package
              Medium =
                  Medium)
            "Fluid connector a (positive design flow direction is from port_a to port_b)"
              annotation (Placement(transformation(extent={{90,-50},{110,-30}})));
          equation

            connect(mDry.port, thermalLosses.port_a)
                                              annotation (Line(
                points={{-30,-30},{-30,-30},{-30,-60},{-30,-60}},
                color={191,0,0},
                smooth=Smooth.None));
            connect(thermalLosses.port_b, heatPort)
                                             annotation (Line(
                points={{-30,-80},{-30,-100}},
                color={191,0,0},
                smooth=Smooth.None));
            connect(heatedFluid.port_b, flowPort_b)       annotation (Line(
                points={{0,10},{0,40},{100,40}},
                color={0,127,255},
                smooth=Smooth.None));
            connect(heatedFluid.port_a, flowPort_a)       annotation (Line(
                points={{0,-10},{0,-40},{100,-40}},
                color={0,127,255},
                smooth=Smooth.None));
            connect(mDry.port, heatedFluid.heatPort)           annotation (Line(
                points={{-30,-30},{-30,0},{-10,0}},
                color={191,0,0},
                smooth=Smooth.None));
            annotation (Diagram(coordinateSystem(extent={{-100,-100},{100,120}},
                    preserveAspectRatio=false),
                                graphics), Icon(coordinateSystem(extent={{-100,-100},{100,
                      120}}, preserveAspectRatio=false),
                                                graphics),
              Documentation(info="<html>
<p><b>Description</b> </p>
<p>This is a partial model from which most heaters (boilers, heat pumps) will extend. This model is <u>dynamic</u> (there is a water content in the heater and a dry mass lumped to it) and it has <u>thermal losses to the environment</u>. To complete this model and turn it into a heater, a <u>heatSource</u> has to be added, specifying how much heat is injected in the heatedFluid pipe, at which efficiency, if there is a maximum power, etc. HeatSource models are grouped in <a href=\"modelica://IDEAS.Thermal.Components.Production.BaseClasses\">IDEAS.Thermal.Components.Production.BaseClasses.</a></p>
<p>The set temperature of the model is passed as a realInput.The model has a realOutput PEl for the electricity consumption.</p>
<p>See the extensions of this model for more details.</p>
<p><h4>Assumptions and limitations </h4></p>
<p><ol>
<li>the temperature of the dry mass is identical as the outlet temperature of the heater </li>
<li>no pressure drop</li>
</ol></p>
<p><h4>Model use</h4></p>
<p>Depending on the extended model, different parameters will have to be set. Common to all these extensions are the following:</p>
<p><ol>
<li>the environmental heat losses are specified by a <u>time constant</u>. Based on the water content, dry capacity and this time constant, the UA value of the heat transfer to the environment will be set</li>
<li>set the heaterType (useful in post-processing)</li>
<li>connect the set temperature to the TSet realInput connector</li>
<li>connect the flowPorts (flowPort_b is the outlet) </li>
<li>if heat losses to environment are to be considered, connect heatPort to the environment.  If this port is not connected, the dry capacity and water content will still make this a dynamic model, but without heat losses to environment,.  IN that case, the time constant is not used.</li>
</ol></p>
<p><h4>Validation </h4></p>
<p>This partial model is based on physical principles and is not validated. Extensions may be validated.</p>
<p><h4>Examples</h4></p>
<p>See the extensions, like the <a href=\"modelica://IDEAS.Thermal.Components.Production.IdealHeater\">IdealHeater</a>, the <a href=\"modelica://IDEAS.Thermal.Components.Production.Boiler\">Boiler</a> or <a href=\"modelica://IDEAS.Thermal.Components.Production.HP_AWMod_Losses\">air-water heat pump</a></p>
</html>"));
          end PartialDynamicHeaterWithLosses_a60;
        end Interfaces;
      end Production;

      package BaseClasses "Basic components for thermal fluid flow"
        extends Modelica.Icons.BasesPackage;

        model Pipe_HeatPort_a60_2
          extends Annex60.Fluid.Interfaces.TwoPortHeatMassExchanger(vol(V=V),show_T=true);
          Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
          "Heat port connected to outflowing medium"
            annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
          parameter SI.Volume V "Volume";

        equation
          connect(vol.heatPort, heatPort) annotation (Line(
              points={{-9,-10},{-26,-10},{-26,-56},{0,-56},{0,-100}},
              color={191,0,0},
              smooth=Smooth.None));
          annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                    -100},{100,100}}), graphics));
        end Pipe_HeatPort_a60_2;
      annotation (Documentation(info="<html>
</html>",     revisions="<HTML>
  <ul>
  <li> v1.00 2005/02/01 Anton Haumer<br>
       first stable official release</li>
  <li> v1.20 Beta 2005/02/18 Anton Haumer<br>
       introduced geodetic height in Components.Pipes<br>
       <i>new models: Components.Valve</i></li>
  <li> v1.30 Beta 2005/06/02 Anton Haumer<br>
       friction losses are fed to medium</li>
  </ul>
</HTML>
"),     Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
                  100}}), graphics));
      end BaseClasses;

      package Examples
      "Examples that demonstrate the use of the models from IDEAS.Thermal.Components"
        extends Modelica.Icons.ExamplesPackage;

        record boiler_validation
          extends Modelica.Icons.Record;

          // T Boundary
          parameter Real TSet = 273.15 + 60;
          parameter Real TFix = 273.15 + 20;
          parameter Real TIni = 273.15 + 20;

          // heater
          parameter Real QNom = 5000;
          parameter Real tau_heatLoss = 3600;
          parameter Real mWater = 10;
          parameter Real cDry = 10000;

          // Saw
          parameter Real ampl_saw = 0.9998;
          parameter Real period_saw = 20000;
          parameter Real  offset_saw = 0.0001;
          parameter Real startTime_saw = 1000;

          // pump
          parameter Real m_pump = 0;
          parameter Real mFlowNom = 120/3600;
          parameter Real mFlowStart = 0.0001;
          parameter Real dpFix = 0;
          parameter Real etaTot = 0.8;

          //pipe
          parameter Real m_pipe = 5;

          //sine
          parameter Real ampl_sine = 20;
          parameter Real freqHz_sine = 1/5000;
          parameter Real offset_sine = 273.15 + 30;
          parameter Real startTime_sine = 20000;

        end boiler_validation;

        package HydraulicTest_IDEAS_a60 "Modelica.Icons.ExamplesPackage"
          extends Modelica.Icons.ExamplesPackage;

          model Boiler_validation_a60 "Validation model for the boiler"
            import Buildings;

            extends Modelica.Icons.Example;
            package Medium = Annex60.Media.ConstantPropertyLiquidWater
            "Medium model";

            final parameter Medium.ThermodynamicState state_pTX = Medium.setState_pTX(p=Medium.p_default, T=313.15, X=Medium.X_default)
            "Medium state";

            BaseClasses.Pipe_HeatPort_a60_2 pipe(
              redeclare package Medium = Medium,
              m_flow_nominal=par.mFlowNom,
              m_flow(start=par.mFlowNom),
              dp_nominal=0,
              V=par.mWater/Medium.density(state_pTX),
              show_T=false,
              T_start=313.15)  annotation (Placement(transformation(extent={{-2,14},{18,-6}})));

            Production.Boiler_a60 heater(
              redeclare package Medium = Medium,
              TInitial=par.TIni,
              QNom=par.QNom,
              tauHeatLoss=par.tau_heatLoss,
              mWater=par.mWater,
              cDry=par.cDry,
              dp_nominal=par.dpFix,
              m_flow_nominal=par.mFlowNom)
                         annotation (Placement(transformation(extent={{-70,-16},{-50,4}})));

            Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TReturn
              annotation (Placement(transformation(extent={{50,30},{30,50}})));
            Buildings.Fluid.Movers.FlowMachine_m_flow pump(
              redeclare package Medium = Medium,
              addPowerToMedium=false,
              motorCooledByFluid=false,
              m_flow_nominal=par.mFlowNom,
              T_start=par.TIni,
              m_flow(start=par.mFlowStart),
              m_flow_start=par.mFlowStart,
              tau=50,
              motorEfficiency=
                  Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters(
                  r_V={1}, eta={1}),
              hydraulicEfficiency=
                  Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters(
                  r_V={1}, eta={1}),
              show_T=false,
              dynamicBalance=false,
              filteredSpeed=false)
              annotation (Placement(transformation(extent={{8,-28},{-12,-48}})));
            Buildings.Fluid.Storage.ExpansionVessel exp(redeclare package
              Medium =                                                             Medium,
                VTot=0.01)
              annotation (Placement(transformation(extent={{48,-32},{68,-12}})));
            boiler_validation par
              annotation (Placement(transformation(extent={{-38,48},{-18,68}})));
            Modelica.Blocks.Sources.SawTooth saw(
              amplitude=par.ampl_saw*par.mFlowNom,
              period=par.period_saw,
              startTime=par.startTime_saw,
              offset=par.offset_saw*par.mFlowNom)
              annotation (Placement(transformation(extent={{-30,-90},{-10,-70}})));
            Modelica.Blocks.Sources.Sine sine(
              amplitude=par.ampl_sine,
              freqHz=par.freqHz_sine,
              offset=par.offset_sine,
              startTime=par.startTime_sine)
              annotation (Placement(transformation(extent={{100,30},{80,50}})));
            Modelica.Blocks.Sources.RealExpression realExpression(y=par.TSet)
              annotation (Placement(transformation(extent={{-90,10},{-70,30}})));
            Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=par.TFix)
              annotation (Placement(transformation(extent={{-88,-48},{-74,-34}})));

            Modelica.SIunits.Temperature TBoiler_in;
            Modelica.SIunits.Temperature TBoiler_out;
          equation
            TBoiler_in = heater.T_in;
            TBoiler_out = heater.T_out;

            connect(TReturn.port, pipe.heatPort)                    annotation (Line(
                points={{30,40},{8,40},{8,14}},
                color={191,0,0},
                smooth=Smooth.None));

            connect(heater.flowPort_b, pipe.port_a) annotation (Line(
                points={{-50,-3.27273},{-50,4},{-2,4}},
                color={0,127,255},
                smooth=Smooth.None));
            connect(pipe.port_b, pump.port_a)  annotation (Line(
                points={{18,4},{24,4},{24,-38},{8,-38}},
                color={0,127,255},
                smooth=Smooth.None));
            connect(pump.port_b, heater.flowPort_a)  annotation (Line(
                points={{-12,-38},{-50,-38},{-50,-10.5455}},
                color={0,127,255},
                smooth=Smooth.None));
            connect(exp.port_a, pump.port_a) annotation (Line(
                points={{58,-32},{60,-32},{60,-38},{8,-38}},
                color={0,127,255},
                smooth=Smooth.None));
            connect(saw.y, pump.m_flow_in) annotation (Line(
                points={{-9,-80},{-1.8,-80},{-1.8,-50}},
                color={0,0,127},
                smooth=Smooth.None));
            connect(sine.y, TReturn.T) annotation (Line(
                points={{79,40},{52,40}},
                color={0,0,127},
                smooth=Smooth.None));
            connect(realExpression.y, heater.TSet) annotation (Line(
                points={{-69,20},{-61,20},{-61,4}},
                color={0,0,127},
                smooth=Smooth.None));
            connect(fixedTemperature.port, heater.heatPort) annotation (Line(
                points={{-74,-41},{-62,-41},{-62,-16},{-63,-16}},
                color={191,0,0},
                smooth=Smooth.None));
            annotation (
              Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
                      100}}), graphics),
              experiment(StopTime=400000),
              __Dymola_experimentSetupOutput,
              Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}})),
              Commands(file="Scripts/Tester_Boiler.mos" "TestModel"),
              Documentation(info="<html>
<p>Model used to validate the <a href=\"modelica://IDEAS.Thermal.Components.Production.Boiler\">IDEAS.Thermal.Components.Production.Boiler</a>. With a fixed set point, the boiler receives different mass flow rates. </p>
</html>"));
          end Boiler_validation_a60;
        end HydraulicTest_IDEAS_a60;
      annotation (Documentation(info="<html>
<p>Examples and testers for all main hydraulic thermal components.  Specific examples of higher level models are provided in the respective packages.</p>
</html>",     revisions="<html>
<p><ul>
<li>2013 May, Roel De Coninck, largely restructured version including renaming and documentation</li>
<li>2010, Roel De Coninck, first version</li>
</ul></p>
</html>"),
        Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
                  100}}), graphics));
      end Examples;
    end Components;
  end Thermal;

  package BaseClasses "Base classes for IDEAS"
    extends Modelica.Icons.BasesPackage;

    package Control "General stuff"
      extends Modelica.Icons.Package;

      block Hyst_NoEvent "Hysteresis without events, with Real in- and output"

        extends Modelica.Blocks.Interfaces.partialBooleanBlockIcon;
        parameter Real uLow;
        parameter Real uHigh;
        parameter Boolean enableRelease = false
        "if true, an additional RealInput will be available for releasing the controller";

        Modelica.Blocks.Interfaces.RealInput u
          annotation (Placement(transformation(extent={{-128,-20},{-88,20}})));
        Modelica.Blocks.Interfaces.RealOutput y(start=0)
          annotation (Placement(transformation(extent={{96,-10},{116,10}})));

        output Real error(start=0);

        Modelica.Blocks.Interfaces.RealInput release(start=0) = rel if enableRelease
        "if < 0.5, the controller is OFF"
          annotation (Placement(transformation(extent={{-128,60},{-88,100}})));
    protected
        Real rel
        "release, either 1 ,either from RealInput release if enableRelease is true";

      equation
        if not enableRelease then
          rel = 1;
        end if;

        if noEvent(u >= uHigh and rel > 0.5) then
          y =  1;
        elseif noEvent(u <= uLow) then
          y =  0;
        elseif noEvent(u > uLow) and noEvent(y > 0.5) and noEvent(rel > 0.5) then
          y =  1;
        else
          y =  0;
        end if;

        /* 
  We have experienced errors with the hysteresis without events in case the tolerance of the 
  integrator is too low: some unlogical behaviour.
  To check correct behaviour, it was possible to define the error as below. 
  The u-delay(u,1) is there because der(u) causes problems in case u is not continuous...
  */

        error = if noEvent(u < uHigh and u > uLow and u - delay(u,1) < 0 and y < 0.5) then 1.0
           else 0.0;
        annotation (
          Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
                  100}}),     graphics={
              Polygon(
                points={{-65,89},{-73,67},{-57,67},{-65,89}},
                lineColor={192,192,192},
                fillColor={192,192,192},
                fillPattern=FillPattern.Solid),
              Line(points={{-65,67},{-65,-81}}, color={192,192,192}),
              Line(points={{-90,-70},{82,-70}}, color={192,192,192}),
              Polygon(
                points={{90,-70},{68,-62},{68,-78},{90,-70}},
                lineColor={192,192,192},
                fillColor={192,192,192},
                fillPattern=FillPattern.Solid),
              Text(
                extent={{70,-80},{94,-100}},
                lineColor={160,160,164},
                textString="u"),
              Text(
                extent={{-65,93},{-12,75}},
                lineColor={160,160,164},
                textString="y"),
              Line(
                points={{-80,-70},{30,-70}},
                color={0,0,0},
                thickness=0.5),
              Line(
                points={{-50,10},{80,10}},
                color={0,0,0},
                thickness=0.5),
              Line(
                points={{-50,10},{-50,-70}},
                color={0,0,0},
                thickness=0.5),
              Line(
                points={{30,10},{30,-70}},
                color={0,0,0},
                thickness=0.5),
              Line(
                points={{-10,-65},{0,-70},{-10,-75}},
                color={0,0,0},
                thickness=0.5),
              Line(
                points={{-10,15},{-20,10},{-10,5}},
                color={0,0,0},
                thickness=0.5),
              Line(
                points={{-55,-20},{-50,-30},{-44,-20}},
                color={0,0,0},
                thickness=0.5),
              Line(
                points={{25,-30},{30,-19},{35,-30}},
                color={0,0,0},
                thickness=0.5),
              Text(
                extent={{-99,2},{-70,18}},
                lineColor={160,160,164},
                textString="true"),
              Text(
                extent={{-98,-87},{-66,-73}},
                lineColor={160,160,164},
                textString="false"),
              Text(
                extent={{19,-87},{44,-70}},
                lineColor={0,0,0},
                textString="uHigh"),
              Text(
                extent={{-63,-88},{-38,-71}},
                lineColor={0,0,0},
                textString="uLow"),
              Line(points={{-69,10},{-60,10}}, color={160,160,164})}),
          Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
                  100}}), graphics={
              Polygon(
                points={{-80,90},{-88,68},{-72,68},{-80,90}},
                lineColor={192,192,192},
                fillColor={192,192,192},
                fillPattern=FillPattern.Solid),
              Line(points={{-80,68},{-80,-29}}, color={192,192,192}),
              Polygon(
                points={{92,-29},{70,-21},{70,-37},{92,-29}},
                lineColor={192,192,192},
                fillColor={192,192,192},
                fillPattern=FillPattern.Solid),
              Line(points={{-79,-29},{84,-29}}, color={192,192,192}),
              Line(points={{-79,-29},{41,-29}}, color={0,0,0}),
              Line(points={{-15,-21},{1,-29},{-15,-36}}, color={0,0,0}),
              Line(points={{41,51},{41,-29}}, color={0,0,0}),
              Line(points={{33,3},{41,22},{50,3}}, color={0,0,0}),
              Line(points={{-49,51},{81,51}}, color={0,0,0}),
              Line(points={{-4,59},{-19,51},{-4,43}}, color={0,0,0}),
              Line(points={{-59,29},{-49,11},{-39,29}}, color={0,0,0}),
              Line(points={{-49,51},{-49,-29}}, color={0,0,0}),
              Text(
                extent={{-92,-49},{-9,-92}},
                lineColor={192,192,192},
                textString="%uLow"),
              Text(
                extent={{2,-49},{91,-92}},
                lineColor={192,192,192},
                textString="%uHigh"),
              Rectangle(extent={{-91,-49},{-8,-92}}, lineColor={192,192,192}),
              Line(points={{-49,-29},{-49,-49}}, color={192,192,192}),
              Rectangle(extent={{2,-49},{91,-92}}, lineColor={192,192,192}),
              Line(points={{41,-29},{41,-49}}, color={192,192,192})}),
          Documentation(info="<HTML>
<p>
This block transforms a <b>Real</b> input signal into a <b>Boolean</b>
output signal:
</p>
<ul>
<li> When the output was <b>false</b> and the input becomes
     <b>greater</b> than parameter <b>uHigh</b>, the output
     switches to <b>true</b>.</li>
<li> When the output was <b>true</b> and the input becomes
     <b>less</b> than parameter <b>uLow</b>, the output
     switches to <b>false</b>.</li>
</ul>
<p>
The start value of the output is defined via parameter
<b>pre_y_start</b> (= value of pre(y) at initial time).
The default value of this parameter is <b>false</b>.
</p>
</HTML>
"));
      end Hyst_NoEvent;
    end Control;
  end BaseClasses;
  annotation (uses(
    Annex60(version="0.1"),
    Modelica(version="3.2.1"),
    Buildings(version="1.6")),                             Icon(graphics),
  version="3",
  conversion(noneFromVersion="", noneFromVersion="1",
    noneFromVersion="2"),
    Documentation(info="<html>
<p>Licensed by KU Leuven and 3E under the Modelica License 2 </p>
<p>Copyright &copy; 2013-2023, KU Leuven and 3E. </p>
<p>&nbsp; </p>
<p><i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>;</i>  <i>it can be redistributed and/or modified under the terms of the Modelica License 2. </i></p>
<p><i>For license conditions (including the disclaimer of warranty) see <a href=\"UrlBlockedError.aspx\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"https://www.modelica.org/licenses/ModelicaLicense2\">https://www.modelica.org/licenses/ModelicaLicense2</a>.</i> </p>
</html>"));
end IDEAS;
model IDEAS_Thermal_Components_Examples_HydraulicTest_IDEAS_a60_Boiler_validation_a60
 extends IDEAS.Thermal.Components.Examples.HydraulicTest_IDEAS_a60.Boiler_validation_a60;
  annotation(experiment(StopTime=400000),uses(IDEAS(version="3")));
end IDEAS_Thermal_Components_Examples_HydraulicTest_IDEAS_a60_Boiler_validation_a60;
