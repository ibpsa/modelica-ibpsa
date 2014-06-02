within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.VerticalSingleBorehole.Examples;
model TestSpitlerConstant "validation spitler: Constant heat input rate test"
  extends Modelica.Icons.Example;

  //Beier, Richard A., Marvin D. Smith, and Jeffrey D. Spitler.
  //"Reference data sets for vertical borehole ground heat exchanger models and thermal response test analysis."
  //Geothermics 40.1 (2011): 79-85.

  Fluid.FixedResistances.Pipe_HeatPort heatedPipe(
    m=0.1,
    medium=medium,
    TInitial=295.15)
    annotation (Placement(transformation(extent={{-32,40},{-12,20}})));
  IDEAS.Fluid.Movers.Pump pump(
    m_flowNom=0.197,
    useInput=false,
    m=0,
    TInitial=295.15,
    medium=medium)
    annotation (Placement(transformation(extent={{-2,20},{18,40}})));
  inner SimInfoManager sim(redeclare IDEAS.Climate.Meteo.Files.min60 detail,
      redeclare IDEAS.Climate.Meteo.Locations.Uccle city)
    annotation (Placement(transformation(extent={{-92,70},{-72,90}})));
  IDEAS.Thermal.Components.BaseClasses.AbsolutePressure absolutePressure(p=
        300000) annotation (Placement(transformation(extent={{62,46},{82,66}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
    annotation (Placement(transformation(extent={{-60,36},{-40,56}})));
  Modelica.Blocks.Sources.Step step(height=1056, startTime=0)
    annotation (Placement(transformation(extent={{-88,24},{-68,44}})));
  SingleBorehole singleBorehole(
    brine=medium,
    boreholeRadius=0.063,
    pipeConductivity=0.39,
    groundConductivity=2.82,
    fillingConductivity=0.73,
    configurationPipe=2,
    geoFlux=0.00001,
    boreholeDepth=18.32,
    groundDensity=2000,
    groundHeatCapacity=3431,
    referenceMassFlowRate=0.197,
    tInitial=295.15,
    pipeInnerRadius=0.013665,
    pipeOuterRadius=0.0167)
    annotation (Placement(transformation(extent={{26,-18},{46,2}})));
  parameter IDEAS.Thermal.Data.Interfaces.Medium medium=
      IDEAS.Thermal.Data.Media.Water() "Medium in the component";
equation
  connect(heatedPipe.flowPort_b, pump.flowPort_a) annotation (Line(
      points={{-12,30},{-2,30}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(absolutePressure.flowPort, pump.flowPort_b) annotation (Line(
      points={{62,56},{40,56},{40,30},{18,30}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(prescribedHeatFlow.port, heatedPipe.heatPort) annotation (Line(
      points={{-40,46},{-32,46},{-32,40},{-22,40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(step.y, prescribedHeatFlow.Q_flow) annotation (Line(
      points={{-67,34},{-64,34},{-64,46},{-60,46}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pump.flowPort_b, singleBorehole.boreholeInlet) annotation (Line(
      points={{18,30},{22,30},{22,-2.7},{26.7,-2.7}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(singleBorehole.boreholeOutlet, heatedPipe.flowPort_a) annotation (
      Line(
      points={{45.3,-2.7},{54,-4},{54,-28},{-32,-28},{-32,30}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (
    Diagram(graphics),
    Commands(file="../../smartbuildings/TME/Scripts/Tester_Borehole.mos" "RunTest"),
    experiment(StopTime=187200, Interval=60),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>Dieter Patteeuw. March April 2012.</p>
<p><b>Description</b> </p>
<p>Validate the borehole model against the experiment of Spitler (Beier, Richard A., Marvin D. Smith, and Jeffrey D. Spitler. &QUOT;Reference data sets for vertical borehole ground heat exchanger models and thermal response test analysis.&QUOT; Geothermics 40.1 (2011): 79-85. )</p>
<p>This test is the constant heat input rate test. All parameters were taken from the paper, except the thermal capacity of the sand. The thermal capacity of the sand was calculated the measurements of the temperature of the sand at certain positions.</p>
<p><h4>Assumptions and limitations </h4></p>
<p>1. See paper.</p>
<p><br/><b>Model use</b> </p>
<p>1.&nbsp;Test for the borehole model and validation against the paper. Simulation time is 187200 seconds. Timestep used is 60 seconds.</p>
<p><h4>Validation </h4></p>
<p>-</p>
<p><b>Example</b> </p>
<p>-</p>
</html>"));
end TestSpitlerConstant;
