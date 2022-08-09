within IBPSA.ThermalZones.ISO13790.Validation.BESTEST;
model Case900FF "Test with heavy-weight construction and free floating temperature"
  extends Modelica.Icons.Example;
  BoundaryConditions.WeatherData.ReaderTMY3       weaDat(filNam=
        Modelica.Utilities.Files.loadResource(
        "modelica://IBPSA/Resources/weatherdata/DRYCOLD.mos")) "weather data"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Zone5R1C.Zone zon5R1C(
    airRat=0.5,
    AWin={0,0,12,0},
    UWin=2.984,
    AWal={21.6,16.2,9.6,16.2},
    ARoo=48,
    UWal=0.51,
    URoo=0.32,
    AFlo=48,
    VRoo=129.6,
    facMas=2.7,
    redeclare IBPSA.ThermalZones.ISO13790.Data.BESTEST900 buiMas,
    winFra=0.01,
    gFac=0.789) "Thermal zone"
    annotation (Placement(transformation(extent={{-14,-14},{14,14}})));
  Modelica.Blocks.Sources.Constant intGains(k=200) "Internal heat gains"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
equation
  connect(weaDat.weaBus,zon5R1C. weaBus) annotation (Line(
      points={{-60,70},{-38,70},{-38,11},{-9.4,11}},
      color={255,204,51},
      thickness=0.5));

  connect(zon5R1C.intGai, intGains.y) annotation (Line(points={{-16,-12},{-30,
          -12},{-30,-30},{-39,-30}}, color={0,0,127}));
 annotation(experiment(Tolerance=1e-6, StopTime=3.1536e+007),
  __Dymola_Commands(file=
  "modelica://IBPSA/Resources/Scripts/Dymola/ThermalZones/ISO13790/Validation/BESTEST/Case900FF.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model is used for the test case 900FF of the BESTEST validation suite.
Case 900FF is a heavy-weight building.
The room temperature is free floating.
</p>
</html>", revisions="<html><ul>
<li>
Mar 16, 2022, by Alessandro Maccarini:<br/>
First implementation.
</li>
</ul></html>"));
end Case900FF;
