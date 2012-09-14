within IDEAS.Thermal.Components.Examples;
model StorageTank_InternalHX
  "Thermal storage tank tester with internal heat exchanger"

  Thermal.Components.BaseClasses.AbsolutePressure absolutePressure(medium=
        Data.Media.Water(), p=200000)
    annotation (Placement(transformation(extent={{56,-40},{76,-20}})));
  Thermal.Components.BaseClasses.Pump volumeFlow1(
    medium=Data.Media.Water(),
    m=4,
    useInput=true,
    TInitial=313.15,
    m_flowNom=0.1)
    annotation (Placement(transformation(extent={{-88,-16},{-68,4}})));
  Thermal.Components.BaseClasses.HeatedPipe boiler(
    medium=Data.Media.Water(),
    m=5,
    TInitial=313.15) annotation (Placement(transformation(extent={{-54,-16},{-34,
            4}})));
  Emission.Radiator   radiator(
    medium=Data.Media.Water()) "Hydraulic radiator model"
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
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow
                                                      prescribedHeatFlow
    annotation (Placement(transformation(extent={{-68,-52},{-48,-32}})));
  Storage.StorageTank_OneIntHX           tank(
    medium=Data.Media.Water(),
    volumeTank=1,
    nbrNodes=5,
    heightTank=2,
    mediumHX=Data.Media.Water(),
    nodeHXUpper=3,
    AHX=4.1,
    mHX=27,
    nodeHXLower=5)                                        annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-10,-32})));
  Thermal.Components.BaseClasses.Pump volumeFlow2(
    medium=Data.Media.Water(),
    m=4,
    m_flowNom=0.05,
    TInitial=313.15,
    useInput=true)
    annotation (Placement(transformation(extent={{60,-84},{40,-64}})));
  Modelica.Blocks.Logical.OnOffController onOff(bandwidth=5)
    annotation (Placement(transformation(extent={{-86,32},{-66,52}})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal
    annotation (Placement(transformation(extent={{-48,32},{-28,52}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=283.15)
    annotation (Placement(transformation(extent={{-4,-64},{16,-44}})));
  Modelica.Blocks.Sources.Pulse pulse1(
    amplitude=1,
    period=3600,
    startTime=2000)
    annotation (Placement(transformation(extent={{28,-54},{48,-34}})));
  Thermal.Components.BaseClasses.AbsolutePressure absolutePressure1(
                                                                   medium=
        Data.Media.Water(), p=200000)
    annotation (Placement(transformation(extent={{-80,-70},{-66,-56}})));
equation
onOff.reference = 60+273.15;
onOff.u = tank.nodes[1].T;
prescribedHeatFlow.Q_flow=6000 * booleanToReal.y;

  connect(volumeFlow1.flowPort_b, boiler.flowPort_a)        annotation (Line(
      points={{-68,-6},{-54,-6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(absolutePressure.flowPort, radiator.flowPort_a)      annotation (Line(
      points={{56,-30},{48,-30},{48,-6},{52,-6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(step.y, prescribedTemperature.T) annotation (Line(
      points={{17,34},{30,34}},
      color={0,0,127},
      thickness=0.5,
      smooth=Smooth.None));
  connect(prescribedTemperature.port, radiator.heatPortRad) annotation (Line(
      points={{52,34},{68,34},{68,4}},
      color={191,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(prescribedHeatFlow.port, boiler.heatPort) annotation (Line(
      points={{-48,-42},{-44,-42},{-44,-16}},
      color={191,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(radiator.flowPort_b, volumeFlow2.flowPort_a) annotation (Line(
      points={{72,-6},{82,-6},{82,-74},{60,-74}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(onOff.y, booleanToReal.u) annotation (Line(
      points={{-65,42},{-50,42}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(booleanToReal.y, volumeFlow1.m_flowSet) annotation (Line(
      points={{-27,42},{-20,42},{-20,16},{-78,16},{-78,4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(volumeFlow2.flowPort_b, tank.flowPort_b) annotation (Line(
      points={{40,-74},{-10,-74},{-10,-42}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(fixedTemperature.port,tank.heatExchEnv)  annotation (Line(
      points={{16,-54},{20,-54},{20,-32},{-3.8,-32}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pulse1.y, volumeFlow2.m_flowSet) annotation (Line(
      points={{49,-44},{54,-44},{54,-60},{50,-60},{50,-64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radiator.heatPortCon, prescribedTemperature.port) annotation (Line(
      points={{64,4},{64,34},{52,34},{52,34}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(boiler.flowPort_b, tank.flowPortHXUpper) annotation (Line(
      points={{-34,-6},{-32,-6},{-32,-8},{-30,-8},{-30,-30},{-20,-30}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(tank.flowPortHXLower, volumeFlow1.flowPort_a) annotation (Line(
      points={{-20,-38},{-30,-38},{-30,-72},{-96,-72},{-96,-6},{-88,-6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(tank.flowPort_a, radiator.flowPort_a) annotation (Line(
      points={{-10,-22},{-10,-6},{52,-6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(absolutePressure1.flowPort, volumeFlow1.flowPort_a) annotation (Line(
      points={{-80,-63},{-86,-63},{-86,-58},{-88,-58},{-88,-6}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end StorageTank_InternalHX;
