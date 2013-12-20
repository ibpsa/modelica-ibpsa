within IDEAS.Thermal.Components.Examples;
model StorageTank_DHW_HP
  "Example of a DHW system composed of HP and storage tank"

  extends Modelica.Icons.Example;

  parameter Thermal.Data.Interfaces.Medium medium=Data.Media.Water();
  parameter Integer nbrNodes=10 "Number of nodes in the storage tank";

  Storage.StorageTank_OneIntHX storageTank(
    nbrNodes=nbrNodes,
    TInitial={273.15 + 60 for i in 1:nbrNodes},
    volumeTank=0.3,
    heightTank=1.6,
    UIns=0.4,
    medium=medium)
    annotation (Placement(transformation(extent={{-30,-64},{42,10}})));

  Domestic_Hot_Water.DHW_RealInput dHW(medium=medium, TDHWSet=273.15 + 45)
    annotation (Placement(transformation(extent={{62,6},{82,26}})));
  Production.HP_AirWater hP_AWMod(QNom=10000, medium=medium)
    annotation (Placement(transformation(extent={{-88,-2},{-68,18}})));
  Thermal.Components.BaseClasses.Pump pump(
    medium=medium,
    m=1,
    m_flowNom=0.5,
    useInput=true)
    annotation (Placement(transformation(extent={{-38,-62},{-58,-42}})));
  inner IDEAS.SimInfoManager sim(redeclare IDEAS.Climate.Meteo.Locations.Uccle
      city, redeclare IDEAS.Climate.Meteo.Files.min60 detail)
    annotation (Placement(transformation(extent={{-94,-94},{-74,-74}})));
  Control.Ctrl_Heating_TES HPControl(
    dTSafetyTop=3,
    dTHPTankSet=2,
    DHW=true,
    TSupNom=313.15,
    TDHWSet=323.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-82,60})));
  Modelica.Blocks.Sources.Pulse pulse(period=3600, width=10)
    annotation (Placement(transformation(extent={{30,26},{50,46}})));
  Modelica.Blocks.Sources.SawTooth sawTooth(
    period=1000,
    startTime=30000,
    amplitude=0.15)
    annotation (Placement(transformation(extent={{30,58},{50,78}})));
  BaseClasses.AbsolutePressure absolutePressure(p=300000)
    annotation (Placement(transformation(extent={{-20,-94},{0,-74}})));
equation
  dHW.mDHW60C = pulse.y*sawTooth.y;

  connect(dHW.flowPortCold, storageTank.flowPort_b) annotation (Line(
      points={{82,11.7143},{82,-58.3077},{42,-58.3077}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(dHW.flowPortHot, storageTank.flowPort_a) annotation (Line(
      points={{62,11.7143},{62,12},{42,12},{42,4.30769}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(pump.flowPort_b, hP_AWMod.flowPort_a) annotation (Line(
      points={{-58,-52},{-64,-52},{-64,3.63636},{-68,3.63636}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(storageTank.flowPortHXLower, pump.flowPort_a) annotation (Line(
      points={{-30,-52.6154},{-34,-52.6154},{-34,-52},{-38,-52}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(hP_AWMod.flowPort_b, storageTank.flowPortHXUpper) annotation (Line(
      points={{-68,8.90909},{-50,8.90909},{-50,8},{-36,8},{-36,-41.2308},{-30,-41.2308}},
      color={0,0,255},
      smooth=Smooth.None));

  connect(absolutePressure.flowPort, pump.flowPort_a) annotation (Line(
      points={{-20,-84},{-30,-84},{-30,-52},{-34,-52.6154},{-34,-52},{-38,-52}},
      color={0,0,255},
      smooth=Smooth.None));

  connect(HPControl.THPSet, hP_AWMod.TSet) annotation (Line(
      points={{-78.1111,48.6667},{-78.1111,32},{-79,32},{-79,18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(storageTank.T[10], HPControl.TTankBot) annotation (Line(
      points={{42,-18.4615},{70,-18.4615},{70,-18},{92,-18},{92,96},{-83.1111,
          96},{-83.1111,69.3333}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(storageTank.T[1], HPControl.TTankTop) annotation (Line(
      points={{42,-18.4615},{72,-18.4615},{72,-22},{88,-22},{88,92},{-78.1111,
          92},{-78.1111,69.3333}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HPControl.onOff, pump.m_flowSet) annotation (Line(
      points={{-83.1111,48.6667},{-83.1111,40},{-48,40},{-48,-42}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics),
    experiment(StopTime=86400),
    __Dymola_experimentSetupOutput);
end StorageTank_DHW_HP;
