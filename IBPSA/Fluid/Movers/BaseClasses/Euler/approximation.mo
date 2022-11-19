within IBPSA.Fluid.Movers.BaseClasses.Euler;
function approximation
  "Correlation of static efficiency ratio vs log of Euler number ratio"
  extends Modelica.Icons.Function;
  input Real x "log10(Eu/Eu_peak)";
  output Real y "eta/eta_peak";

protected
  Real a = if x <-0.5 then 0.056873227 else if x>0.5 then -0.0085494313567 else 0.378246;
  Real b = if x<-0.5 then 0.493231336746 else if x>0.5 then 0.12957001502 else -0.759885;
  Real c = if x<-0.5 then 1.433531254001 else if x>0.5 then -0.65997315029 else -0.0606145;
  Real d = if x<-0.5 then 1.407887300933 else if x>0.5 then 1.1399300301 else 1.01427;
 algorithm
  y:=max(0,a*x^3+b*x^2+c*x+d)/1.01545;

  annotation(Documentation(info="<html>
<p>
This function implements an approximation to the following correlation:
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://IBPSA/Resources/Images/Fluid/Movers/BaseClasses/Euler/eulerCorrelation.svg\"/>
</p>
<p>
where <i>y=&eta; &frasl; &eta;<sub>p</sub></i> (note that <i>&eta;</i>
refers to the hydraulic efficiency instead of total efficiency),
<i>x=log10(Eu &frasl; Eu<sub>p</sub>)</i>,
with the subscript <i>p</i> denoting the condition where
the mover is operating at peak efficiency, and
</p>
<p align=\"center\">
<i>Z<sub>1</sub>=(x-a) &frasl; b</i>
</p>
<p align=\"center\">
<i>Z<sub>2</sub>=(e<sup>c&sdot;x</sup>&sdot;d&sdot;x-a) &frasl; b</i>
</p>
<p align=\"center\">
<i>Z<sub>3</sub>=-a &frasl; b</i>
</p>
<p align=\"center\">
<i>a=-2.732094</i>
</p>
<p align=\"center\">
<i>b=2.273014</i>
</p>
<p align=\"center\">
<i>c=0.196344</i>
</p>
<p align=\"center\">
<i>d=5.267518.</i>
</p>
<p>See <a href=\"modelica://IBPSA.Fluid.Movers.BaseClasses.Euler.correlation\">IBPSA.Fluid.Movers.BaseClasses.Euler.correlation</a> and <a href=\"https://github.com/ibpsa/modelica-ibpsa/pull/1646#issuecomment-1320920539\">IBPSA issue 1645</a> for more information.
</html>",
revisions="<html>
<ul>
<li>
November 19, 2022, by Filip Jorissen:<br/>
First implementation. This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1645\">#1645</a>.
</li>
</ul>
</html>"));
end approximation;