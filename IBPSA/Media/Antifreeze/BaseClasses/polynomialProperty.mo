within IBPSA.Media.Antifreeze.BaseClasses;
function polynomialProperty
  "Evaluates thermophysical property from 2-variable polynomial"
  extends Modelica.Icons.Function;

  input Real x "First independent variable";
  input Real y "Second independent variable";
  input Real xm "Reference value of x";
  input Real ym "Reference value of y";
  input Integer nx "Order of polynomial in x";
  input Integer ny[nx] "Order of polynomial in y";
  input Real a[sum(ny)] "Polynomial coefficients";

  output Real f "Value of thermophysical property";

protected
  Real dx;
  Real dy;
  Integer n;

algorithm

  dx := x - xm;
  dy := y - ym;

  f := 0;
  n := 0;
  for i in 0:nx-1 loop
    for j in 0:ny[i+1]-1 loop
      n := n + 1;
      f := f + a[n]*dx^i*dy^j;
    end for;
  end for;
annotation (
Documentation(info="<html>
<p>
Evaluates a thermophysical property of a mixture, based on correlations proposed
by Melinder (2010).
</p>
<p>
The polynomial has the form
</p>
<p align=\"center\" style=\"font-style:italic;\">
f = a<sub>1</sub> (x-xm)<sup>0</sup>(y-ym)<sup>0</sup>
+ a<sub>2</sub> (x-xm)<sup>0</sup>(y-ym)<sup>1</sup>
+ ... +
a<sub>ny[1]</sub> (x-xm)<sup>0</sup>(y-ym)<sup>ny[1]-1</sup>
+ ... +
a<sub>ny[1])+1</sub> (x-xm)<sup>1</sup>(y-ym)<sup>0</sup>
+ ... +
a<sub>ny[1]+ny[2]</sub> (x-xm)<sup>1</sup>(y-ym)<sup>ny[2]-1</sup>
+ ...
</p>
<h4>References</h4>
<p>
Melinder, &#197;ke. 2010. Properties of Secondary Working Fluids (Secondary
Refrigerants or Coolants, Heat Transfer Fluids) for Indirect Systems. Paris:
IIR/IIF.
</p>
</html>", revisions="<html>
<ul>
<li>
March 16, 2018 by Massimo Cimmino:<br/>
First implementation.
This function is used models in
<a href=\"modelica://IBPSA.Media.Antifreeze\">
IBPSA.Media.Antifreeze</a>.
</li>
</ul>
</html>"));
end polynomialProperty;
