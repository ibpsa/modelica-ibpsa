within IBPSA.ThermalZones.ISO13790.Examples;
model FreeFloatingHVAC_v2
  extends Modelica.Icons.Example;

  IBPSA.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=Modelica.Utilities.Files.loadResource("modelica://IBPSA/Resources/weatherdata/DRYCOLD.mos"))
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  Zone5R1C.ZoneHVAC zoneHVAC_v2_2(
    nVe=0.5,
    Awin={0,0,12,0},
    Uwin=2,
    Awal={0,0,12,0},
    Aroo=48,
    Uwal=1,
    Uroo=1,
    Af=48,
    Vroo=130,
    f_ms=2.5,
    gFactor=0.5,
    redeclare package Medium = IBPSA.Media.Air,
    redeclare Data.Medium buiMas)
    annotation (Placement(transformation(extent={{26,-12},{54,16}})));
  Modelica.Blocks.Sources.Constant intGains(k=10)
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Modelica.Blocks.Sources.Constant latGains(k=0)
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
equation
  connect(zoneHVAC_v2_2.weaBus, weaDat.weaBus) annotation (Line(
      points={{30.6,13},{-50.7,13},{-50.7,70},{-60,70}},
      color={255,204,51},
      thickness=0.5));
  connect(intGains.y,zoneHVAC_v2_2. intGains) annotation (Line(points={{-59,-70},
          {-50,-70},{-50,-10},{24,-10}}, color={0,0,127}));
  connect(latGains.y,zoneHVAC_v2_2. latGains) annotation (Line(points={{-59,-10},
          {-54,-10},{-54,-6},{24,-6}}, color={0,0,127}));
  annotation (experiment(
      StopTime=31536000,
      Interval=3600,
      __Dymola_Algorithm="Dassl"));
end FreeFloatingHVAC_v2;
