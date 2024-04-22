within IBPSA.ThermalZones.ISO13790.Validation.BESTEST.Cases9xx;
model Case900 "Case 600, but with high thermal mass"
  extends IBPSA.ThermalZones.ISO13790.Validation.BESTEST.Cases6xx.Case600(
    zon5R1C(           redeclare replaceable
        IBPSA.ThermalZones.ISO13790.Validation.BESTEST.Data.Case900Mass buiMas),
    annComBESTEST(
      EHeaMax=7347600000,
      EHeaMin=4212000000,
      ECooMax=-11394000000,
      ECooMin=-7686000000,
      PHeaMax=3797,
      PHeaMin=2850,
      PCooMax=-3871,
      PCooMin=-2888));

 annotation(experiment(
      StopTime=31536000,
      Interval=3600,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
  __Dymola_Commands(file=
  "modelica://IBPSA/Resources/Scripts/Dymola/ThermalZones/ISO13790/Validation/BESTEST/Cases9xx/Case900.mos"
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
