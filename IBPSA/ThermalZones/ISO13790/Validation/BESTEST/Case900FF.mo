within IBPSA.ThermalZones.ISO13790.Validation.BESTEST;
model Case900FF "Test with heavy-weight construction and free floating temperature"
  extends IBPSA.ThermalZones.ISO13790.Validation.BESTEST.Case600FF(
    zon5R1C(
      redeclare IBPSA.ThermalZones.ISO13790.Data.BESTEST900 buiMas,
      facMas=3));

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
