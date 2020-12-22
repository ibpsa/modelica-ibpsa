within IBPSA.Fluid.Actuators.Valves;
model TwoWayButterfly
  "Two way valve with the flow characteristic of a typical butterfly valve"
  extends IBPSA.Fluid.Actuators.Valves.TwoWayPolynomial(
    CvData = IBPSA.Fluid.Types.CvTypes.Kv,
    Kv = 0.0472*(d*1000)^2 -2.0104*(d*1000),
    final c={0,1.101898284705380E-01, 2.217227395456580,  - 7.483401207660790, 1.277617623360130E+01, -6.618045307070130});

  parameter Modelica.SIunits.Length d
    "Nominal diameter";

annotation (
defaultComponentName="valBut",
Documentation(info="<html>
<p>
Two way valve with the flow characteristic of a typical butterfly valve as listed below. 
</p>
<p>
<img src=\"modelica://IBPSA/Resources/Images/Fluid/Actuators/Valves/Examples/TwoWayButterfly.png\" alt=\"Butterfly valve characteristic\"/>
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
</html>"),
    Icon(graphics={Ellipse(
          extent={{-16,18},{16,-14}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}));
end TwoWayButterfly;
