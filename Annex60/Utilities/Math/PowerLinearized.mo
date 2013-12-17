within Annex60.Utilities.Math;
block PowerLinearized
  "Power function that is linearized below a user-defined threshold"
  extends Modelica.Blocks.Interfaces.SISO;
  parameter Real n "Exponent";
  parameter Real x0 "Abscissa value below which linearization occurs";

equation
  y = Annex60.Utilities.Math.Functions.powerLinearized(x=u, n=n, x0=x0);

  annotation (Icon(graphics={Text(
          extent={{-90,36},{90,-36}},
          lineColor={160,160,164},
          textString="powerLinearized()")}), Documentation(info="<html>
<p>Block for function powerLinearized, which approximates <i>y=xn</i> where <i>0 &LT; n</i> so that </p>
<p><ul>
<li>the function is defined and monotone increasing for all <i>x</i>. </li>
<li><i>dy/dx</i> is bounded and continuous everywhere (for <i>n &LT; 1</i>). </li>
</ul></p>
<p>For <i>x &LT; x0</i>, this function replaces <i>y=xn</i> by a linear function that is continuously differentiable everywhere. </p>
<p>A typical use of this function is to replace <i>T = T4(1/4)</i> in a radiation balance to ensure that the function is defined everywhere. This can help solving the initialization problem when a solver may be far from a solution and hence <i>T4 &LT; 0</i>. </p>
<p>See the package <code>Examples</code> for the graph. </p>
</html>", revisions="<html>
<ul>
<li>
November 29, 2013, by Marcus Fuchs:<br/>
Implementation based on Funtions.powerLinearized.
</li>
</ul>
</html>"));
end PowerLinearized;
