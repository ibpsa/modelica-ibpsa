within IDEAS.LIDEAS.Validation;
model Case900ValidationLinearInputs
  extends Case900ValidationNonLinearInputs(sim(linIntCon=true,
      linExtCon=true,
      linIntRad=true,
      linExtRad=true));
        annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=100000),
    __Dymola_Commands(file="Resources/Scripts/Dymola/LIDEAS/Validation/Case900ValidationLinearInputs.mos"
        "Linearise, simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>May 15, 2018 by Damien Picard: <br>First implementation</li>
</ul>
</html>"));
end Case900ValidationLinearInputs;
