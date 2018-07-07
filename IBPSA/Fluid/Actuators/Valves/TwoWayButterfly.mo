within IBPSA.Fluid.Actuators.Valves;
model TwoWayButterfly
  "Two way valve with the flow characteristic of a typical butterfly valve"
  extends IBPSA.Fluid.Actuators.Valves.TwoWayPolynomial(
    final c={0,0.3084,-4.0264, 23.841, -54.349, 57.201, -21.975});
annotation (
defaultComponentName="valBut",
Documentation(info="<html>
<p>
Two way valve with the flow characteristic of a typical butterfly valve.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 8, 2018 by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
end TwoWayButterfly;
