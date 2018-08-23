within IDEAS.LIDEAS.Validation;
model ZoneWithInputsValidationLinear "Model to validate the linearization method by simulating both the original model (with all flags set to linear) and the obtained state space model."
  extends ZoneWithInputsValidationNonLinear(
    firFlo(
          linearise=true),
    groFlo(
         linearise=true),
  sim(linIntCon=true,
      linExtCon=true,
      linIntRad=true,
      linExtRad=true),
    slabOnGround(linearise=true),
    commonWall(layMul(monLay(each monLayDyn(addRes_b=true)))));
  annotation (experiment(StopTime=100000), __Dymola_Commands(file="Resources/Scripts/Dymola/LIDEAS/Validation/ZoneWithInputsValidationLinear.mos"
        "Linearize, simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>May 15, 2018 by Damien Picard: <br/>First implementation</li>
</ul>
</html>", info="<html>
<p>This example verified that the obtained state-space model gives the same results as the original modelica model with <i>all linearise flags</i> set to true. The remaining error is probably due to numerical error.</p>
</html>"));
end ZoneWithInputsValidationLinear;
