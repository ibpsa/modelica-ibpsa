within IBPSA.Utilities.Math.Functions;
function exponentialIntegralE1 "Exponential integral, E1"
  extends Modelica.Icons.Function;

  input Real x "Independent variable";
  output Real E1 "Exponential integral E1(x)";

protected
  Real a1[6] = {-0.57721566, 0.99999193, -0.24991055, 0.05519968, -0.00976004, 0.00107857};
  Real a2[5] = {0.2677737343, 8.6347608925, 18.0590169730, 8.5733287401, 1.0};
  Real b2[5] = {3.9584969228, 21.0996530827, 25.6329561486, 9.5733223454, 1.0};

algorithm

  if x < 1 then
    E1 := IBPSA.Utilities.Math.Functions.polynomial(x, a1) - log(x);
  else
    E1 := IBPSA.Utilities.Math.Functions.polynomial(x, a2)/(IBPSA.Utilities.Math.Functions.polynomial(x, b2)*x*exp(x));
  end if;

end exponentialIntegralE1;
