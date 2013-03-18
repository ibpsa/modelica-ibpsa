within IDEAS.Thermal.Components.GroundHeatExchanger.ModelDieterPatteeuw;
model BoreholeSpitler "validation spitler main file"
// experiment based on Reference data sets for vertical borehole ground heat exchanger models and thermal response test analysis
// by  Richard A. Beier, Marvin D. Smith, Jeffrey D. Spitler

  IDEAS.Thermal.Components.BaseClasses.Pipe_HeatPort heatedPipe(
    medium=TME.FHF.Media.Water(),
    m=0.1,
    TInitial=295.15)
    annotation (Placement(transformation(extent={{-32,40},{-12,20}})));
  IDEAS.Thermal.Components.BaseClasses.Pump pump(
    medium=TME.FHF.Media.Water(),
    m_flowNom=0.197,
    useInput=false,
    m=0,
    TInitial=295.15)
    annotation (Placement(transformation(extent={{-2,20},{18,40}})));
  IDEAS.Thermal.Components.BaseClasses.AbsolutePressure absolutePressure(p=300000)
    annotation (Placement(transformation(extent={{62,46},{82,66}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow
    prescribedHeatFlow
    annotation (Placement(transformation(extent={{-60,36},{-40,56}})));
  Modelica.Blocks.Sources.Step step(height=1056, startTime=0)
    annotation (Placement(transformation(extent={{-88,24},{-68,44}})));
  SingleBorehole singleBorehole(
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
    pipeInnerRadius=0.013665,
    pipeOuterRadius=0.0167,
    brine=IDEAS.Thermal.Data.Media.Water(),
    tInitial=295.15)
    annotation (Placement(transformation(extent={{26,-18},{46,2}})));
  inner IDEAS.SimInfoManager sim(
    redeclare IDEAS.Climate.Meteo.Files.min60 detail,
    redeclare IDEAS.Climate.Meteo.Locations.Uccle city,
    occBeh=false)
    annotation (Placement(transformation(extent={{-86,68},{-66,88}})));
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
  connect(singleBorehole.boreholeOutlet, heatedPipe.flowPort_a)
    annotation (Line(
      points={{45.3,-2.7},{54,-4},{54,-28},{-32,-28},{-32,30}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Commands(file=
          "../../smartbuildings/TME/Scripts/Tester_Borehole.mos" "RunTest"),
    experiment(StopTime=187200, Interval=60));
end BoreholeSpitler;
