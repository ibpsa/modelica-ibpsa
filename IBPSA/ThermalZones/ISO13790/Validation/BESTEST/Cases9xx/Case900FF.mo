within IBPSA.ThermalZones.ISO13790.Validation.BESTEST.Cases9xx;
model Case900FF
  "Case 600FF, but with high thermal mass"
  extends IBPSA.ThermalZones.ISO13790.Validation.BESTEST.Cases6xx.Case600FF(
    zon5R1C(
      redeclare replaceable IBPSA.ThermalZones.ISO13790.Validation.BESTEST.Data.Case900Mass buiMas),
    annComBESTESTFF(TavgMin=297.65));

 annotation(experiment(Tolerance=1e-6, StopTime=3.1536e+007),
  __Dymola_Commands(file=
  "modelica://IBPSA/Resources/Scripts/Dymola/ThermalZones/ISO13790/Validation/BESTEST/Cases9xx/Case900FF.mos"
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
