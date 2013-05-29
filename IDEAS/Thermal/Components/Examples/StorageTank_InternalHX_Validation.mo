within IDEAS.Thermal.Components.Examples;
model StorageTank_InternalHX_Validation
  "Thermal storage tank tester with internal heat exchanger"

extends Modelica.Icons.Example;

  parameter SI.ThermalConductivity lamBuo=1000 annotation(Evaluate=false);

  Thermal.Components.BaseClasses.Pump volumeFlow1(
    medium=Data.Media.Water(),
    m=4,
    useInput=false,
    TInitial=328.15,
    m_flowNom=0.75)
    annotation (Placement(transformation(extent={{-88,-16},{-68,4}})));
  IDEAS.Thermal.Components.BaseClasses.Pipe_HeatPort
                                            boiler(
    medium=Data.Media.Water(),
    m=5,
    TInitial=313.15) annotation (Placement(transformation(extent={{-4,-6},{16,14}})));
  inner IDEAS.Climate.SimInfoManager sim(redeclare
      IDEAS.Climate.Meteo.Files.min15
      detail, redeclare IDEAS.Climate.Meteo.Locations.Uccle city)
    annotation (Placement(transformation(extent={{-84,68},{-64,88}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow
                                                         QFix
    annotation (Placement(transformation(extent={{-28,-26},{-8,-6}})));
  Storage.StorageTank_OneIntHX           tank(
    medium=Data.Media.Water(),
    mediumHX=Data.Media.Water(),
    AHX=4.1,
    mHX=27,
    volumeTank=0.39,
    heightTank=1.4,
    TInitial={283.15 for i in 1:tank.nbrNodes},
    nbrNodes=5,
    nodeHXLower=5,
    lamBuo=lamBuo,
    nodeHXUpper=2,
    U=0.96)                                               annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,-18})));
  Thermal.Components.BaseClasses.AbsolutePressure absolutePressure1(
                                                                   medium=
        Data.Media.Water(), p=200000)
    annotation (Placement(transformation(extent={{-80,-70},{-66,-56}})));
  Thermal.Components.BaseClasses.AbsolutePressure absolutePressure2(
                                                                   medium=
        Data.Media.Water(), p=200000)
    annotation (Placement(transformation(extent={{80,-68},{94,-54}})));
  Modelica.Blocks.Logical.OnOffController onOff(bandwidth=5)
    annotation (Placement(transformation(extent={{-76,42},{-56,62}})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal
    annotation (Placement(transformation(extent={{-38,42},{-18,62}})));
equation
onOff.reference = 60+273.15;
onOff.u = boiler.T;
QFix.Q_flow = 16000 * booleanToReal.y;

  connect(volumeFlow1.flowPort_b, boiler.flowPort_a)        annotation (Line(
      points={{-68,-6},{-38,-6},{-38,4},{-4,4}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(QFix.port, boiler.heatPort)               annotation (Line(
      points={{-8,-16},{6,-16},{6,-6}},
      color={191,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(boiler.flowPort_b, tank.flowPortHXUpper) annotation (Line(
      points={{16,4},{50,4},{50,-21.8462},{60,-21.8462}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(tank.flowPortHXLower, volumeFlow1.flowPort_a) annotation (Line(
      points={{60,-24.9231},{50,-24.9231},{50,-86},{-96,-86},{-96,-6},{-88,-6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(absolutePressure1.flowPort, volumeFlow1.flowPort_a) annotation (Line(
      points={{-80,-63},{-86,-63},{-86,-58},{-88,-58},{-88,-6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(absolutePressure2.flowPort, tank.flowPort_b) annotation (Line(
      points={{80,-61},{74,-61},{74,-60},{80,-60},{80,-26.4615}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(onOff.y,booleanToReal. u) annotation (Line(
      points={{-55,52},{-40,52}},
      color={255,0,255},
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end StorageTank_InternalHX_Validation;
