within IDEAS.Thermal.Components.Storage.Examples;
model Validation_Vitocell100V390l_Charging_a
  "charging the tank from 10°C to 45°C with 55°C supply temperature: 60 minutes"

  /*
  This model is used in an automatic optimization to determine the lamBuo factor across different number of nodes.
  See the IDEAS manual for more on the validation of the storage tank model
  */

  parameter Real kBuo=9.37e-7 annotation(Evaluate=false);
  parameter Real expBuo= 4.75 annotation(Evaluate=false);

  Thermal.Components.BaseClasses.Pump volumeFlow1(
    medium=Data.Media.Water(),
    m=4,
    useInput=false,
    TInitial=328.15,
    m_flowNom=0.5)
    annotation (Placement(transformation(extent={{-88,-16},{-68,4}})));
  IDEAS.Thermal.Components.BaseClasses.Pipe_HeatPort
                                            boiler(
    medium=Data.Media.Water(),
    m=5,
    TInitial=328.15) annotation (Placement(transformation(extent={{-4,-6},{16,14}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature QFix(T=328.15)
    annotation (Placement(transformation(extent={{-28,-26},{-8,-6}})));
  Storage.StorageTank_OneIntHX           tank(
    medium=Data.Media.Water(),
    mediumHX=Data.Media.Water(),
    AHX=4.1,
    mHX=27,
    volumeTank=0.39,
    heightTank=1.4,
    TInitial={283.15 for i in 1:tank.nbrNodes},
    kBuo=kBuo,
    expBuo=expBuo,
    UIns=0.4,
    UACon=0.56,
    nbrNodes=10,
    nodeHXUpper=4,
    nodeHXLower=10)                                       annotation (
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
equation

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
      points={{16,4},{50,4},{50,-16},{60,-16}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(tank.flowPortHXLower, volumeFlow1.flowPort_a) annotation (Line(
      points={{60,-24},{50,-24},{50,-86},{-96,-86},{-96,-6},{-88,-6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(absolutePressure1.flowPort, volumeFlow1.flowPort_a) annotation (Line(
      points={{-80,-63},{-86,-63},{-86,-58},{-88,-58},{-88,-6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(absolutePressure2.flowPort, tank.flowPort_b) annotation (Line(
      points={{80,-61},{74,-61},{74,-60},{70,-60},{70,-28}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics),
    experiment(StopTime=3600, Interval=5),
    __Dymola_experimentSetupOutput);
end Validation_Vitocell100V390l_Charging_a;
