within IDEAS.Thermal.Components.Examples;
model DHWTester "Test the DHW component"

  parameter Thermal.Data.Interfaces.Medium medium=Data.Media.Water();

  Thermal.Components.Storage.StorageTank storageTank(
    TInitial={273.15 + 60 for i in 1:storageTank.nbrNodes},
    volumeTank=0.3,
    heightTank=1.6,
    UA=0.4,
    medium=medium)
    annotation (Placement(transformation(extent={{42,-64},{-30,10}})));

  Thermal.Components.BaseClasses.DomesticHotWater dHW(
    medium=medium,
    VDayAvg=0.2,
    TDHWSet=273.15 + 45,
    profileType=3)
    annotation (Placement(transformation(extent={{46,-30},{66,-10}})));
  IDEAS.Thermal.Components.HeatProduction.HP_AWMod
                      hP_AWMod(TSet = HPControl.THPSet, QNom=10000, medium=medium)
    annotation (Placement(transformation(extent={{-72,-6},{-52,14}})));
  Thermal.Components.BaseClasses.Pump pump(
    medium=medium,
    m=1,
    m_flowNom=0.5,
    useInput=true)
    annotation (Placement(transformation(extent={{-36,-74},{-56,-54}})));
  inner Commons.SimInfoManager sim(redeclare Commons.Meteo.Files.min15
      detail, redeclare Commons.Meteo.Locations.Uccle city)
              annotation (Placement(transformation(extent={{8,62},{28,82}})));
  Thermal.Control.HPControl_HeatingCurve HPControl(
    TTankTop=storageTank.nodes[1].T,
    TTankBot=storageTank.nodes[4].T,
    dTSafetyTop=3,
    dTHPTankSet=2,
    DHW=true,
    TDHWSet=318.15)
    annotation (Placement(transformation(extent={{-48,34},{-28,54}})));
  Modelica.Blocks.Sources.Pulse pulse(period=3600)
    annotation (Placement(transformation(extent={{-72,-34},{-52,-14}})));
equation
  //pump.m_flowSet = HPControl.onOff;
  pump.m_flowSet = HPControl.onOff;
  connect(dHW.flowPortCold, storageTank.flowPort_b) annotation (Line(
      points={{56,-30},{58,-30},{58,-64},{6,-64}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(dHW.flowPortHot, storageTank.flowPort_a) annotation (Line(
      points={{56,-10},{56,12},{6,12},{6,10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(storageTank.flowPort_b, pump.flowPort_a) annotation (Line(
      points={{6,-64},{-36,-64}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(pump.flowPort_b, hP_AWMod.flowPort_a) annotation (Line(
      points={{-56,-64},{-78,-64},{-78,4},{-72,4}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(hP_AWMod.flowPort_b, storageTank.flowPort_a) annotation (Line(
      points={{-52,4},{-24,4},{-24,10},{6,10}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end DHWTester;
