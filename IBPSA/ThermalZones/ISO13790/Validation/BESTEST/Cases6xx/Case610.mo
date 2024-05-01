within IBPSA.ThermalZones.ISO13790.Validation.BESTEST.Cases6xx;
model Case610 "Case 600 with south shading"
  extends IBPSA.ThermalZones.ISO13790.Validation.BESTEST.Cases6xx.Case600(zon5R1C(
        shaRedFac=0.84));
 annotation(experiment(
      StopTime=31536000,
      Interval=3600,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
  __Dymola_Commands(file=
  "modelica://IBPSA/Resources/Scripts/Dymola/ThermalZones/ISO13790/Validation/BESTEST/Cases6xx/Case610.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model is used for the basic test case 610 of the BESTEST validation suite. 
Case 600 is a light-weight building with room temperature control set to <i>20</i>&deg;C 
for heating and <i>27</i>&deg;C for cooling. The room has no shade and a window that faces south. 
</p>
</html>", revisions="<html><ul>
<li>
Mar 16, 2022, by Alessandro Maccarini:<br/>
First implementation.
</li>
</ul></html>"));
end Case610;
