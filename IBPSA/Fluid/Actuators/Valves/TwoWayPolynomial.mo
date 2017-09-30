within IBPSA.Fluid.Actuators.Valves;
model TwoWayPolynomial "Two way valve with polynomial characteristic"
  extends IBPSA.Fluid.Actuators.BaseClasses.PartialTwoWayValveKv(
    phi=l + sum(c.*{y_actual^i for i in 0:size(c,1)-1})*(1 - l));

  parameter Real[:] c "Polynomial coefficients, starting with fixed offset";
annotation (
defaultComponentName="val",
Documentation(info="<html>
<p>
Two way valve with polynomial opening characteristic.
The polynomial coefficients are defined using parameter <code>c</code>.
The elements of c are coefficients for increasing powers of y,
starting with the power 0, which corresponds to a fixed offset.
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
