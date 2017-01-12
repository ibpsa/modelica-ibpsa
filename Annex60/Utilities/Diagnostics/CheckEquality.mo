within Annex60.Utilities.Diagnostics;
block CheckEquality "Check equality between inputs up to a threshold"
  extends Modelica.Blocks.Icons.Block;
  parameter Real threShold(min=0)=1e-2 "Threshold for equality comparison";
  Modelica.Blocks.Interfaces.RealInput u1 "Value to check"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput u2 "Value to check"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealOutput y "Error"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  y = noEvent(if abs(u1-u2)< threShold then 0 else abs(u1-u2));
annotation (
defaultComponentName="cheEqu",
Documentation(info="<html>
<p>
Model that returns 0 if the difference
<i>|u1-u2| &lt; threShold</i>
or <i>|u1-u2|</i> else.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 12, 2017, by Thiery S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
               Text(
          extent={{-84,108},{90,-28}},
          lineColor={255,0,0},
          textString="u1 = u2"),
                             Text(
          extent={{-62,-38},{54,-68}},
          lineColor={0,0,255},
          textString="%threShold")}));
end CheckEquality;
