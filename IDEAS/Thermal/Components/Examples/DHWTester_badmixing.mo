within IDEAS.Thermal.Components.Examples;
model DHWTester_badmixing "Test the DHW component"

  parameter Thermal.Data.Interfaces.Medium medium=Data.Media.Water();

  Thermal.Components.Storage.StorageTank storageTank(
    TInitial={273.15 + 60 for i in 1:storageTank.nbrNodes},
    volumeTank=0.3,
    heightTank=1.6,
    UA=0.4,
    medium=medium)
    annotation (Placement(transformation(extent={{30,-64},{-8,4}})));

  IDEAS.Thermal.HeatingSystems.DHW_MixingVolume
           dHW(medium = medium,
    TDHWSet=273.15 + 35,
    VDayAvg=0.001)
    annotation (Placement(transformation(extent={{48,-30},{68,-10}})));
  IDEAS.Thermal.Components.HeatProduction.HP_AWMod
                      hP_AWMod(TSet = HPControl.THPSet, QNom=20000, medium=medium)
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
    dTHPTankSet=2)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.Pulse pulse(period=3600)
    annotation (Placement(transformation(extent={{-80,34},{-60,54}})));
equation
  pump.m_flowSet = HPControl.onOff;

  connect(dHW.flowPortCold, storageTank.flowPort_b) annotation (Line(
      points={{58,-30},{58,-64},{11,-64}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(dHW.flowPortHot, storageTank.flowPort_a) annotation (Line(
      points={{58,-10},{58,4},{11,4}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(storageTank.flowPort_b, pump.flowPort_a) annotation (Line(
      points={{11,-64},{-36,-64}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(pump.flowPort_b, hP_AWMod.flowPort_a) annotation (Line(
      points={{-56,-64},{-78,-64},{-78,4},{-72,4}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(hP_AWMod.flowPort_b, storageTank.flowPort_a) annotation (Line(
      points={{-52,4},{11,4}},
      color={255,0,0},
      smooth=Smooth.None));
   annotation (Diagram(graphics));
end DHWTester_badmixing;
