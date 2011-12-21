within IDEAS.Thermal.Components.VerticalGroundHeatExchanger.Examples;
model Example_Borehole "Most basic example/tester for a borehole "

  VerticalHeatExchangerModels.BoreHole boreHole
    annotation (Placement(transformation(extent={{2,-6},{-18,14}})));
  Thermal.Components.BaseClasses.HeatedPipe heatedPipe(
    medium=Data.Media.Water(),
    m=1,
    TInitial=277.15)
    annotation (Placement(transformation(extent={{-32,40},{-12,20}})));
  Thermal.Components.BaseClasses.Pump pump(
    medium=Data.Media.Water(),
    m=0,
    useInput=true,
    m_flowNom=0.5)
    annotation (Placement(transformation(extent={{-2,20},{18,40}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=
        277.15)
    annotation (Placement(transformation(extent={{-54,56},{-34,76}})));
  inner Commons.SimInfoManager sim(redeclare Commons.Meteo.Files.min60 detail,
      redeclare Commons.Meteo.Locations.Uccle city)
    annotation (Placement(transformation(extent={{-92,70},{-72,90}})));
  Thermal.Components.BaseClasses.AbsolutePressure absolutePressure(p=300000)
    annotation (Placement(transformation(extent={{62,46},{82,66}})));
  Modelica.Blocks.Sources.Step step(startTime=20000)
    annotation (Placement(transformation(extent={{-18,72},{2,92}})));
equation
  connect(heatedPipe.flowPort_b, pump.flowPort_a) annotation (Line(
      points={{-12,30},{-2,30}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(fixedTemperature.port, heatedPipe.heatPort) annotation (Line(
      points={{-34,66},{-22,66},{-22,40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(absolutePressure.flowPort, pump.flowPort_b) annotation (Line(
      points={{62,56},{18,56},{18,30}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(pump.flowPort_b, boreHole.flowPort_a) annotation (Line(
      points={{18,30},{20,30},{20,3.8},{1.8,3.8}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(heatedPipe.flowPort_a, boreHole.flowPort_b) annotation (Line(
      points={{-32,30},{-46,30},{-46,4},{-17.8,4}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(step.y, pump.m_flowSet) annotation (Line(
      points={{3,82},{8,82},{8,40}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Commands(file=
          "../../smartbuildings/TME/Scripts/Tester_Borehole.mos" "RunTest"));
end Example_Borehole;
