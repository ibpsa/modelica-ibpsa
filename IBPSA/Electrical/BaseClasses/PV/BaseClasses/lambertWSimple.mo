within IBPSA.Electrical.BaseClasses.PV.BaseClasses;
function lambertWSimple
  "Simple approximation for Lambert W function for x >= 2, should only be used for large input values as error decreases for increasing input values"
  extends Modelica.Icons.Function;
   input Real x(min=2);
   output Real W;

algorithm
  W:= log(x)*(1-log(log(x))/(log(x)+1));
  annotation (Documentation(info="<html>
<p>
The Lambert W function solves mathematical equations in which the unknown is both inside and outside of an exponential function or a logarithm.
</p>
<p>
This function is a simple approximation for Lambert W function following Baetzelis, 2016:
</p>
</html>", revisions="<html>
<ul>
<li>
Nov 17, 2022, by Laura Maier:<br/>
First implementation.
</li>
</ul>
</html>"));
end lambertWSimple;
