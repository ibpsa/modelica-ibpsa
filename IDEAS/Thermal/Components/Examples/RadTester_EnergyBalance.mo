within IDEAS.Thermal.Components.Examples;
model RadTester_EnergyBalance "Test for energy balance of the radiator model"
  import Commons;

  Real QBoiler( start = 0);
  Real QRadiator( start = 0);

  Thermal.Components.BaseClasses.AbsolutePressure absolutePressure(medium=
        Data.Media.Water(), p=200000)
    annotation (Placement(transformation(extent={{50,-52},{70,-32}})));
  Thermal.Components.BaseClasses.Pump volumeFlow1(
    medium=Data.Media.Water(),
    m=4,
    m_flowNom=0.05,
    TInitial=293.15,
    useInput=true)
    annotation (Placement(transformation(extent={{-36,-16},{-16,4}})));
  Thermal.Components.BaseClasses.HeatedPipe boiler(
    medium=Data.Media.Water(),
    m=5,
    TInitial=293.15) annotation (Placement(transformation(extent={{12,-16},{32,4}})));
  IDEAS.Thermal.Components.HeatEmission.Radiator_Old
                      radiator(
    medium=Data.Media.Water(),
                          QNom=3000,
    TInNom=318.15,
    TOutNom=308.15,
    powerFactor=3.37) "Hydraulic radiator model"
               annotation (Placement(transformation(extent={{52,-16},{72,4}})));
  inner Commons.SimInfoManager sim(redeclare Commons.Meteo.Files.min15
      detail, redeclare Commons.Meteo.Locations.Uccle city)
    annotation (Placement(transformation(extent={{-84,68},{-64,88}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature
    prescribedTemperature(T=293.15)
    annotation (Placement(transformation(extent={{32,24},{52,44}})));
  Modelica.Blocks.Sources.Pulse step(
    startTime=10000,
    offset=0,
    amplitude=3000,
    period=10000,
    nperiod=3)
    annotation (Placement(transformation(extent={{-62,-50},{-42,-30}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow
                                                      boilerHeatFlow
    annotation (Placement(transformation(extent={{-12,-50},{8,-30}})));
  Modelica.Blocks.Sources.Pulse step1(
    startTime=10000,
    offset=0,
    period=10000,
    amplitude=1,
    nperiod=5)
    annotation (Placement(transformation(extent={{-56,30},{-36,50}})));
equation
der(QBoiler) = boilerHeatFlow.Q_flow;
der(QRadiator) = -radiator.heatPortConv.Q_flow - radiator.heatPortRad.Q_flow;

  connect(volumeFlow1.flowPort_b, boiler.flowPort_a)        annotation (Line(
      points={{-16,-6},{12,-6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(boiler.flowPort_b, radiator.flowPort_a)             annotation (Line(
      points={{32,-6},{52,-6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(radiator.flowPort_b, volumeFlow1.flowPort_a)      annotation (Line(
      points={{72,-6},{82,-6},{82,-62},{-76,-62},{-76,-6},{-36,-6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(absolutePressure.flowPort, radiator.flowPort_a)      annotation (Line(
      points={{50,-42},{50,-30},{48,-30},{48,-6},{52,-6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(prescribedTemperature.port, radiator.heatPortConv) annotation (Line(
      points={{52,34},{59,34},{59,4}},
      color={191,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(prescribedTemperature.port, radiator.heatPortRad) annotation (Line(
      points={{52,34},{67,34},{67,4}},
      color={191,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(boilerHeatFlow.port, boiler.heatPort) annotation (Line(
      points={{8,-40},{14,-40},{14,-38},{22,-38},{22,-16}},
      color={191,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(step.y, boilerHeatFlow.Q_flow) annotation (Line(
      points={{-41,-40},{-12,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(step1.y, volumeFlow1.m_flowSet) annotation (Line(
      points={{-35,40},{-26,40},{-26,4}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end RadTester_EnergyBalance;
