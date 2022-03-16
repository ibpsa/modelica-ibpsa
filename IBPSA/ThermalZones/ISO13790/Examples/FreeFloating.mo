within IBPSA.ThermalZones.ISO13790.Examples;
model FreeFloating
  extends Modelica.Icons.Example;

  IBPSA.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=Modelica.Utilities.Files.loadResource("modelica://IBPSA/Resources/weatherdata/DRYCOLD.mos"))
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));


  Zone5R1C.Zone zone(redeclare ISO13790.Data.Heavy buiMas)
    annotation (Placement(transformation(extent={{26,-12},{54,16}})));
  Modelica.Blocks.Sources.Constant intGains(k=10)
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
equation
  connect(zone.weaBus, weaDat.weaBus) annotation (Line(
      points={{30.6,13},{-50.7,13},{-50.7,70},{-60,70}},
      color={255,204,51},
      thickness=0.5));
  connect(intGains.y, zone.intGains) annotation (Line(points={{-59,-70},{-50,
          -70},{-50,-10},{24,-10}}, color={0,0,127}));
  annotation (experiment(
      StopTime=31536000,
      Interval=3600,
      __Dymola_Algorithm="Dassl"));
end FreeFloating;
