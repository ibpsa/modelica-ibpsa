within IBPSA.ThermalZones.ISO13790.Validation.BESTEST;
model Case900
  extends IBPSA.ThermalZones.ISO13790.Validation.BESTEST.Case600(
    zon5R1C(
      redeclare IBPSA.ThermalZones.ISO13790.Data.BESTEST900 buiMas,
      facMas=3));

 annotation(experiment(Tolerance=1e-6, StopTime=3.1536e+007),
  __Dymola_Commands(file=
  "modelica://IBPSA/Resources/Scripts/Dymola/ThermalZones/ISO13790/Validation/BESTEST/Case900.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model is used for the basic test case 900 of the BESTEST validation suite. 
Case 900 is a heavy-weight building with room temperature control set to <i>20</i>&deg;C 
for heating and <i>27</i>&deg;C for cooling. The room has no shade and a window that faces south. 
</p>
</html>", revisions="<html><ul>
<li>
Mar 16, 2022, by Alessandro Maccarini:<br/>
First implementation.
</li>
</ul></html>"));
end Case900;
