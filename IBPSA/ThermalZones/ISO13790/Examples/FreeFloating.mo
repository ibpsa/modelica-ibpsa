within IBPSA.ThermalZones.ISO13790.Examples;
model FreeFloating "Illustrates the use of the 5R1C thermal zone in free-floating conditions"
  extends Modelica.Icons.Example;

  IBPSA.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource("modelica://IBPSA/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));


  Zone5R1C.Zone zon5R1C(
    nVe=0.5,
    Awin={0,0,3,0},
    Uwin=1.8,
    Awal={12,12,9,12},
    Aroo=16,
    Uwal=1.3,
    Uroo=1.3,
    Af=16,
    Vroo=16*3,
    f_ms=2.5,
    redeclare IBPSA.ThermalZones.ISO13790.Data.Light buiMas,
    gFactor=0.5)
    annotation (Placement(transformation(extent={{26,-12},{54,16}})));
  Modelica.Blocks.Sources.Constant intGains(k=10) "internal heat gains in Watt"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
equation
  connect(zon5R1C.weaBus, weaDat.weaBus) annotation (Line(
      points={{30.6,13},{-50.7,13},{-50.7,70},{-60,70}},
      color={255,204,51},
      thickness=0.5));
  connect(zon5R1C.intGai, intGains.y) annotation (Line(points={{24,-10},{-40,-10},
          {-40,-70},{-59,-70}}, color={0,0,127}));
  annotation (experiment(Tolerance=1e-6, StopTime=3.1536e+007, Interval=3600),
  __Dymola_Commands(file=
  "modelica://IBPSA/Resources/Scripts/Dymola/ThermalZones/ReducedOrder/Examples/SimpleRoomOneElement.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This model illustrates the use of <a href=\"modelica://IBPSA.ThermalZones.ISO13790.Zone5R1C.Zone\">
IBPSA.ThermalZones.ISO13790.Zone5R1C.Zone</a> in a free-floating case 
(i.e. no heating or cooling)
</p>
</html>",
revisions="<html>
<ul>
<li>
Mar 16, 2022, by Alessandro Maccarini:<br/>
First implementation.
</li>
</ul>
</html>",
        info="<html>
<p>
Mass data for heavy building
</p>
</html>"));
end FreeFloating;
