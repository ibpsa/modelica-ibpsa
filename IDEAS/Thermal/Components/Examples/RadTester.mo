within IDEAS.Thermal.Components.Examples;
model RadTester "Simple radiator tester"

  Thermal.Components.BaseClasses.AbsolutePressure absolutePressure(medium=
        Data.Media.Water(), p=200000)
    annotation (Placement(transformation(extent={{50,-52},{70,-32}})));
  Thermal.Components.BaseClasses.Pump volumeFlow1(
    medium=Data.Media.Water(),
    m=4,
    TInitial=313.15,
    m_flowNom=0.05)
    annotation (Placement(transformation(extent={{-58,-16},{-38,4}})));
  Thermal.Components.BaseClasses.HeatedPipe boiler(
    medium=Data.Media.Water(),
    m=5,
    TInitial=313.15) annotation (Placement(transformation(extent={{-26,-16},{-6,
            4}})));
  IDEAS.Thermal.Components.Emission.Radiator
                      radiator(
    medium=Data.Media.Water(),
                          QNom=3000) "Hydraulic radiator model"
               annotation (Placement(transformation(extent={{52,-16},{72,4}})));
  inner IDEAS.Climate.SimInfoManager sim(redeclare
      IDEAS.Climate.Meteo.Files.min15
      detail, redeclare IDEAS.Climate.Meteo.Locations.Uccle city)
    annotation (Placement(transformation(extent={{-84,68},{-64,88}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature
    annotation (Placement(transformation(extent={{32,24},{52,44}})));
  Modelica.Blocks.Sources.Step step(
    height=2,
    offset=291,
    startTime=10000)
    annotation (Placement(transformation(extent={{-4,24},{16,44}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow(Q_flow=3000)
    annotation (Placement(transformation(extent={{-50,-52},{-30,-32}})));
equation

  connect(volumeFlow1.flowPort_b, boiler.flowPort_a)        annotation (Line(
      points={{-38,-6},{-26,-6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(boiler.flowPort_b, radiator.flowPort_a)             annotation (Line(
      points={{-6,-6},{52,-6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(radiator.flowPort_b, volumeFlow1.flowPort_a)      annotation (Line(
      points={{72,-6},{82,-6},{82,-62},{-76,-62},{-76,-6},{-58,-6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(absolutePressure.flowPort, radiator.flowPort_a)      annotation (Line(
      points={{50,-42},{50,-30},{48,-30},{48,-6},{52,-6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(step.y, prescribedTemperature.T) annotation (Line(
      points={{17,34},{30,34}},
      color={0,0,127},
      thickness=0.5,
      smooth=Smooth.None));
  connect(prescribedTemperature.port, radiator.heatPortConv) annotation (Line(
      points={{52,34},{64,34},{64,4}},
      color={191,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(prescribedTemperature.port, radiator.heatPortRad) annotation (Line(
      points={{52,34},{68,34},{68,4}},
      color={191,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(fixedHeatFlow.port, boiler.heatPort) annotation (Line(
      points={{-30,-42},{-16,-42},{-16,-16}},
      color={191,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end RadTester;
