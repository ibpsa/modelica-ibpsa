within IBPSA.BoundaryConditions.WeatherData.BaseClasses;
block LimitMin
  "Ensures that the output is never below zero"
  extends Modelica.Blocks.Interfaces.SISO;
  constant Real minVal = 0 "Minimum value";
equation
  y = max(minVal, u);

annotation (
defaultComponentName="limMin",
Documentation(info="<html>
<p>
Block that outputs <i>y=max(0, u)</i>.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 14, 2020, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(
      graphics={
        Text(
          extent={{-100,30},{98,-16}},
          lineColor={0,0,0},
          textString="min(0, u)")}));
end LimitMin;
