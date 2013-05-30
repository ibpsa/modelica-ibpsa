within IDEAS.Thermal.Components.Examples;
model DHWTester "Test the DHW component"

extends Modelica.Icons.Example;

  parameter Thermal.Data.Interfaces.Medium medium=Data.Media.Water();

  Thermal.Components.Storage.StorageTank storageTank(
    TInitial={273.15 + 60 for i in 1:storageTank.nbrNodes},
    volumeTank=0.3,
    heightTank=1.6,
    U=0.4,
    medium=medium)
    annotation (Placement(transformation(extent={{42,-64},{-30,10}})));

  DHW.DHW_RealInput                               dHW(
    medium=medium,
    TDHWSet=273.15 + 45)
    annotation (Placement(transformation(extent={{62,-46},{82,-26}})));
  Production.HP_AirWater
                      hP_AWMod(TSet = HPControl.THPSet, QNom=10000, medium=medium)
    annotation (Placement(transformation(extent={{-90,-2},{-70,18}})));
  Thermal.Components.BaseClasses.Pump pump(
    medium=medium,
    m=1,
    m_flowNom=0.5,
    useInput=true)
    annotation (Placement(transformation(extent={{-24,-74},{-44,-54}})));
  inner IDEAS.SimInfoManager         sim(redeclare
      IDEAS.Climate.Meteo.Files.min15
      detail, redeclare IDEAS.Climate.Meteo.Locations.Uccle city)
              annotation (Placement(transformation(extent={{8,62},{28,82}})));
  Thermal.Control.HPControl_HeatingCurve HPControl(
    TTankTop=storageTank.nodes[1].T,
    TTankBot=storageTank.nodes[4].T,
    dTSafetyTop=3,
    dTHPTankSet=2,
    DHW=true,
    TDHWSet=318.15)
    annotation (Placement(transformation(extent={{-48,34},{-28,54}})));
  Modelica.Blocks.Sources.Pulse pulse(period=3600, width=10)
    annotation (Placement(transformation(extent={{-60,-26},{-40,-6}})));
  Modelica.Blocks.Sources.SawTooth sawTooth(
    period=1000,
    startTime=30000,
    amplitude=0.15)
    annotation (Placement(transformation(extent={{30,32},{50,52}})));
equation
  dHW.mDHW60C = pulse.y * sawTooth.y;
  pump.m_flowSet = HPControl.onOff;
  connect(dHW.flowPortCold, storageTank.flowPort_b) annotation (Line(
      points={{82,-40.2857},{58,-40.2857},{58,-58.3077},{-30,-58.3077}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(dHW.flowPortHot, storageTank.flowPort_a) annotation (Line(
      points={{62,-40.2857},{62,12},{-30,12},{-30,4.30769}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(storageTank.flowPort_b, pump.flowPort_a) annotation (Line(
      points={{-30,-58.3077},{-27,-58.3077},{-27,-64},{-24,-64}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(pump.flowPort_b, hP_AWMod.flowPort_a) annotation (Line(
      points={{-44,-64},{-64,-64},{-64,3.63636},{-70,3.63636}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(hP_AWMod.flowPort_b, storageTank.flowPort_a) annotation (Line(
      points={{-70,8.90909},{-69,8.90909},{-69,3.21678},{-68,3.21678},{-68,
          4.30769},{-30,4.30769}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end DHWTester;
