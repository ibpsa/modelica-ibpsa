within IBPSA.ThermalZones.ISO13790.Validation.BESTEST;
model Case900FF
  extends Modelica.Icons.Example;
  Zone5R1C.Zone          zone(
    Uwin=2.984,
    Awal={21.6,16.2,9.6,16.2},
    Uwal=0.51,
    Uroo=0.32,
    Vroo=129.6,
    f_ms=2.7,
    redeclare ISO13790.Data.BESTEST900 buiMas,
    gFactor=0.789)
    annotation (Placement(transformation(extent={{-14,-14},{14,14}})));
  IBPSA.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=Modelica.Utilities.Files.loadResource("modelica://IBPSA/Resources/weatherdata/DRYCOLD.mos"))
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.Constant intGains(k=200)
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
equation
  connect(weaDat.weaBus, zone.weaBus) annotation (Line(
      points={{-60,70},{-38,70},{-38,11},{-9.4,11}},
      color={255,204,51},
      thickness=0.5));
  connect(intGains.y, zone.intGains) annotation (Line(points={{-39,-30},{-30,
          -30},{-30,-12},{-16,-12}}, color={0,0,127}));
end Case900FF;
