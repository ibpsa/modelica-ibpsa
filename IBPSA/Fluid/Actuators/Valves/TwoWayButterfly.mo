within IBPSA.Fluid.Actuators.Valves;
model TwoWayButterfly
  "Two way valve with the flow characteristic of a typical butterfly valve"
  extends IBPSA.Fluid.Actuators.Valves.TwoWayPolynomial(
    final CvData = IBPSA.Fluid.Types.CvTypes.Kv,
    Kv = 0.0472*(DN*1000)^2 -2.0104*(DN*1000),
    final c={0,1.101898284705380E-01, 2.217227395456580,  - 7.483401207660790, 1.277617623360130E+01, -6.618045307070130});

  parameter Modelica.SIunits.Length DN(displayUnit="mm") "Nominal diameter";

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
December 20, 2020 by Filip Jorissen:<br/>
Revised implementation with default Kv computation.
</li>
<li>
July 8, 2018 by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
end TwoWayButterfly;
