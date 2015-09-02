within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Interfaces;
partial model partial_multipleBoreHoles
  "Calculates the average fluid temperature T_fts of the borefield for a given (time dependent) load Q_flow"
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium in the component" annotation (choicesAllMatching=true);
  // Medium in borefield
  extends IDEAS.Fluid.Interfaces.PartialTwoPortInterface(
    m_flow_nominal=bfData.m_flow_nominal,
    redeclare package Medium = Medium,
    final allowFlowReversal=false);

  extends IDEAS.Fluid.Interfaces.LumpedVolumeDeclarations(T_start = bfData.gen.T_start,
    redeclare package Medium = Medium);
  extends IDEAS.Fluid.Interfaces.TwoPortFlowResistanceParameters(final
      computeFlowResistance=true, dp_nominal=0);

  // General parameters of borefield
  replaceable parameter Data.Records.BorefieldData bfData constrainedby
    Data.Records.BorefieldData
    "Record containing all the parameters of the borefield model" annotation (
     choicesAllMatching=true, Placement(transformation(extent={{-90,-88},{-70,
            -68}})));

  //General parameters of aggregation
  parameter Integer lenSim=3600*24*100
    "Simulation length ([s]). By default = 100 days";

  parameter Boolean dynFil=true
    "Set to false to remove the dynamics of the filling material."
    annotation (Dialog(tab="Dynamics"));

  // Load of borefield
  Modelica.SIunits.HeatFlowRate QAve_flow
    "Average heat flux over a time period";

  Modelica.SIunits.Temperature TWall "Average borehole wall temperature";

  Modelica.Blocks.Sources.RealExpression TWall_val(y=TWall)
    "Average borehole wall temperature"
    annotation (Placement(transformation(extent={{-42,30},{-20,50}})));

  // Parameters for the aggregation technic
protected
  parameter Integer nbHEX = bfData.gen.nVer * bfData.gen.nbSer;
  parameter Integer indexFirstLayerHEX[:] = {1 + (i-1)*bfData.gen.nVer for i in 1:bfData.gen.nbSer};
  final parameter Integer p_max=5
    "Number of aggregation cells within one aggregation level";
  final parameter Integer q_max=
      BaseClasses.Aggregation.BaseClasses.nbOfLevelAgg(          n_max=integer(
      lenSim/bfData.gen.tStep), p_max=p_max) "Number of aggregation levels";
  final parameter Real[q_max,p_max] kappaMat(fixed=false)
    "Transient thermal resistance of each aggregation cells";
  final parameter Integer[q_max] rArr(fixed=false)
    "Width of aggregation cell for each level";
  final parameter Integer[q_max,p_max] nuMat(fixed=false)
    "Number of aggregated pulses at end of each aggregation cell";

  // Parameters for the calculation of the steady state resistance of the borefield
  final parameter Modelica.SIunits.Temperature TSteSta(fixed=false)
    "Quasi steady state temperature of the borefield for a constant heat flux";
  final parameter Real R_ss(fixed=false) "Steady state resistance";

  //Load
  Modelica.SIunits.Power[q_max,p_max] QMat
    "Aggregation of load vector. Updated every discrete time step.";

  //Utilities
  Modelica.SIunits.Energy UOld "Internal energy at the previous period";
  Modelica.SIunits.Energy U
    "Current internal energy, defined as U=0 for t=tStart";
  Modelica.SIunits.Time startTime "Start time of the simulation";

public
  Modelica.Blocks.Interfaces.RealOutput Q_flow(unit="W")
    "Thermal power extracted or injected in the borefield"
    annotation (Placement(transformation(extent={{100,42},{120,62}})));
  BaseClasses.MassFlowRateMultiplier massFlowRateMultiplier(redeclare package
      Medium = Medium, k=1/bfData.gen.nbBh)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  BaseClasses.MassFlowRateMultiplier massFlowRateMultiplier1(redeclare package
      Medium = Medium, k=bfData.gen.nbBh)
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

initial algorithm
  // Initialisation of the internal energy (zeros) and the load vector. Load vector have the same length as the number of aggregated pulse and cover lenSim
  U := 0;
  UOld := 0;

  // Initialization of the aggregation matrix and check that the short-term response for the given bfData record has already been calculated
  (kappaMat,rArr,nuMat,TSteSta) :=
    IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.Scripts.saveAggregationMatrix(
    p_max=p_max,
    q_max=q_max,
    lenSim=lenSim,
    gen=bfData.gen,
    soi=bfData.soi,
    fil=bfData.fil);

  R_ss := TSteSta/(bfData.gen.q_ste*bfData.gen.hBor*bfData.gen.nbBh)
    "Steady state resistance";

equation
  Q_flow = port_a.m_flow*(actualStream(port_a.h_outflow) - actualStream(port_b.h_outflow));

  assert(time < lenSim, "The chosen value for lenSim is too small. It cannot cover the whole simulation time!");

  der(U) = Q_flow
    "Integration of load to calculate below the average load/(discrete time step)";

algorithm
  // Set the start time for the sampling
  when initial() then
    startTime := time;
  end when;

  when initial() or sample(startTime, bfData.gen.tStep) then
    QAve_flow := (U - UOld)/bfData.gen.tStep;
    UOld := U;

    // Update of aggregated load matrix.
    QMat := BaseClasses.Aggregation.aggregateLoad(
        q_max=q_max,
        p_max=p_max,
        rArr=rArr,
        nuMat=nuMat,
        QNew=QAve_flow,
        QAggOld=QMat);

    // Wall temperature of the borefield
    TWall :=BaseClasses.deltaTWall(
      q_max=q_max,
      p_max=p_max,
      QMat=QMat,
      kappaMat=kappaMat,
      R_ss=R_ss) + T_start;
  end when;

equation

  connect(massFlowRateMultiplier1.port_b, port_b)
    annotation (Line(points={{80,0},{86,0},{100,0}}, color={0,127,255}));
  connect(port_a, massFlowRateMultiplier.port_a)
    annotation (Line(points={{-100,0},{-96,0},{-80,0}}, color={0,127,255}));
  annotation (
    experiment(StopTime=70000, __Dymola_NumberOfIntervals=50),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{-100,60},{100,-66}},
          lineColor={0,0,0},
          fillColor={234,210,210},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-88,-6},{-32,-62}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-82,-12},{-38,-56}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-88,54},{-32,-2}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-82,48},{-38,4}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-26,54},{30,-2}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-20,48},{24,4}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-28,-6},{28,-62}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-22,-12},{22,-56}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{36,56},{92,0}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{42,50},{86,6}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{38,-4},{94,-60}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{44,-10},{88,-54}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward)}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),Documentation(info="<html>
  <p>The proposed model is a so-called hybrid step-response
model (HSRM). This type of model uses the
borefield’s temperature response to a step load input.
An arbitrary load can always be approximated by a superposition
of step loads. The borefield’s response to
the load is then calculated by superposition of the step responses
using the linearity property of the heat diffusion
equation. The most famous example of HSRM
for borefields is probably the <i>g-function</i> of Eskilson
(1987). The major challenge of this approach is to obtain a
HSRM which is valid for both minute-based and year-based
simulations. To tackle this problem, a HSRM
has been implemented. A long-term response model
is implemented in order to take into account
the interactions between the boreholes and the
temperature evolution of the surrounding ground. A
short-term response model is implemented to
describe the transient heat flux in the borehole heat exchanger to the surrounding
ground. The step-response of each model is then calculated and merged into one
in order to achieve both short- and long-term
accuracy. Finally an aggregation method is implemented to speed up the calculation.
However, the aggregation method calculates the temperature for discrete time step. In order to avoid
abrut temperature changes, the aggregation method is used to calculate the average borehole wall
temperature instead of the average fluid temperature. The calculated borehole wall temperature is then
connected to the dynamic model of the borehole heat exchanger.</p>
<p>More detailed documentation can be found in 
<a href=\"modelica://IDEAS/Resources/Images/Fluid/HeatExchangers/Borefield/UsersGuide/2014-10thModelicaConference-Picard.pdf\">Picard (2014)</a>.
and in 
<a href=\"modelica://IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.UsersGuide\">IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.UsersGuide</a>.
</p>
<p>
A verification of this model can be found in 
<a href=\"modelica://IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Validation.TrtValidation\">TrtValidation</a>
.
</p>
</html>", revisions="<html>
<ul>
<li>
July 2014, by Damien Picard:<br>
First implementation.
</li>
</ul>
</html>"));
end partial_multipleBoreHoles;
