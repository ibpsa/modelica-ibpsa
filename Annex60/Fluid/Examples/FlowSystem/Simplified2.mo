within Annex60.Fluid.Examples.FlowSystem;
model Simplified2 "Using from_dp"
  extends Simplified1(
    valSouth1(from_dp=true),
    valSouth2(from_dp=true),
    valNorth1(from_dp=true),
    valNorth2(from_dp=true));
  annotation (Documentation(info="<html>
<p>
The model is further simplified: using <code>from_dp</code> to find more efficient tearing method.
</p>
</html>", revisions="<html>
<ul>
<li>
October 7, 2016, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"), __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/Examples/FlowSystem/Simplified2.mos"
        "Simulate and plot"));
end Simplified2;
