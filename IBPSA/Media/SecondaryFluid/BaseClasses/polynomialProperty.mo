within IBPSA.Media.SecondaryFluid.BaseClasses;
function polynomialProperty
  "Evaluates thermophysical property from 2-variable polynomial"
  extends Modelica.Icons.Function;

  input Real x "First independent variable";
  input Real y "Second independent variable";
  input Real xm "Reference value of x";
  input Real ym "Reference value of y";
  input Integer nx "Order of polynomial in x";
  input Integer ny[nx] "Order of polynomial in y";
  input Real coeff[sum(ny)] "Polynomial coefficients";

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
      f := f + coeff[n]*dx^i*dy^j;
    end for;
  end for;

end polynomialProperty;
