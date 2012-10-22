within IDEAS.Thermal.Components.Storage.Examples;
model Validation_Vitocell100V390l_Charging_b
  "charging the tank from 10°C to 55°C with 65°C supply temperature: 77 minutes"

  /*
  This model is used in an automatic optimization to determine the buoyancy model parameters across different number of nodes.
  See the IDEAS manual for more on the validation of the storage tank model
  */

 parameter SI.ThermalConductance powBuo=3 annotation(Evaluate=false);

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
    TInitial=338.15) annotation (Placement(transformation(extent={{-4,-6},{16,14}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature QFix(T=338.15)
    annotation (Placement(transformation(extent={{-28,-26},{-8,-6}})));
  Storage.StorageTank_OneIntHX           tank(
    medium=Data.Media.Water(),
    mediumHX=Data.Media.Water(),
    AHX=4.1,
    mHX=27,
    volumeTank=0.39,
    heightTank=1.4,
    TInitial={283.15 for i in 1:tank.nbrNodes},
    UIns=0.4,
    UACon=0.56,
    nbrNodes=10,
    nodeHXUpper=4,
    nodeHXLower=10,
    redeclare IDEAS.Thermal.Components.Storage.Buoyancy_power buoyancy(powBuo=1000))
                                                         annotation (
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
      points={{16,4},{50,4},{50,-15.9},{59.9,-15.9}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(tank.flowPortHXLower, volumeFlow1.flowPort_a) annotation (Line(
      points={{59.9,-23.9},{50,-23.9},{50,-86},{-96,-86},{-96,-6},{-88,-6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(absolutePressure1.flowPort, volumeFlow1.flowPort_a) annotation (Line(
      points={{-80,-63},{-86,-63},{-86,-58},{-88,-58},{-88,-6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(absolutePressure2.flowPort, tank.flowPort_b) annotation (Line(
      points={{80,-61},{74,-61},{74,-60},{69.9,-60},{69.9,-27.9}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics),
    experiment(StopTime=4620, Interval=5),
    __Dymola_experimentSetupOutput);
end Validation_Vitocell100V390l_Charging_b;
