within IBPSA.Fluid.Actuators.Valves;
model TwoWayPolynomial "Two way valve with polynomial characteristic"
  extends IBPSA.Fluid.Actuators.BaseClasses.PartialTwoWayValveKv(
    phi=l + pol_y*(1 - l));

  parameter Real[:] c
    "Polynomial coefficients, starting with fixed offset";

protected
  constant Integer points = 100
    "Number of points for initial algorithm test";
  parameter Real phi_test(fixed=false)
    "Variable for testing validity of polynomial";
  parameter Real phi_test_prev(fixed=false)
    "Variable for testing validity of polynomial";
  Real pol_y = sum(c.*{y_actual^i for i in 0:size(c,1)-1})
    "Polynomial of valve control signal";

  // initial algorithm that tests the validity of the provided valve coefficients
initial algorithm
  phi_test:=0;
  phi_test_prev:=0;
  for i in 0:points loop
    phi_test:=sum(c .* {(i/points)^i for i in 0:size(c, 1) - 1});
    assert(phi_test-phi_test_prev>0, "The provided valve polynomial coefficients 
    do not lead to a strictly increasing characteristic. This is not allowed.");
  end for;
  assert(c[1]>=0, "The provided valve polynomial coefficients do not lead to 
  a valve opening that is larger than or equal to zero for a control signal of zero. ");
  assert(sum(c)<=1.1, "The provided valve polynomial coefficients do not lead to 
  a valve opening that is smaller than or equal to one for a control signal of one. ");

annotation (
defaultComponentName="val",
Documentation(info="<html>
<p>
Two way valve with polynomial opening characteristic.
The polynomial coefficients are defined using parameter <code>c</code>.
The elements of c are coefficients for increasing powers of y,
starting with the power 0, which corresponds to a fixed offset.
This valve model can be used to implement valves with a custom
opening characteristic, such as a combination
of a linear and a equal percentage characteristic.
</p>
<p>
This model is based on the partial valve model
<a href=\"modelica://IBPSA.Fluid.Actuators.BaseClasses.PartialTwoWayValve\">
IBPSA.Fluid.Actuators.BaseClasses.PartialTwoWayValve</a>.
Check this model for more information, such
as the regularization near the origin.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 30, 2017 by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
end TwoWayPolynomial;
