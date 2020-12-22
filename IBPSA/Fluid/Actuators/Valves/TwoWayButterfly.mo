within IBPSA.Fluid.Actuators.Valves;
model TwoWayButterfly
  "Two way valve with the flow characteristic of a typical butterfly valve"
  extends IBPSA.Fluid.Actuators.Valves.TwoWayPolynomial(
    final CvData = IBPSA.Fluid.Types.CvTypes.Kv,
    final Kv = Kvs,
    final c={0,1.101898284705380E-01, 2.217227395456580,  -7.483401207660790, 1.277617623360130E+01, -6.618045307070130});


  parameter Real Kvs "Kv value at fully open valve"
    annotation(choices(
     choice =   822 "DN 150",
     choice =  1492 "DN 200",
     choice =  2422 "DN 250",
     choice =  3611 "DN 300",
     choice =  5060 "DN 350",
     choice =  6790 "DN 400",
     choice =  8823 "DN 450",
     choice = 11159 "DN 500",
     choice = 16759 "DN 600",
     choice = 20068 "DN 650",
     choice = 23744 "DN 700",
     choice = 27767 "DN 750",
     choice = 32178 "DN 800",
     choice = 42212 "DN 900",
     choice = 53911 "DN 1000",
     choice = 60420 "DN 1050",
     choice = 82845 "DN 1200"));

annotation (
defaultComponentName="valBut",
Documentation(info="<html>
<p>
Two way valve with the flow characteristic of a typical butterfly valve as listed below.
</p>
<p>
<img src=\"modelica://IBPSA/Resources/Images/Fluid/Actuators/Valves/Examples/TwoWayButterfly.png\" alt=\"Butterfly valve characteristic\"/>
</p>
<h4>Implementation</h4>
<p>
The model assigns a <code>Kv</code> based on the table at
<a href=\"http://www.mydatabook.org/fluid-mechanics/flow-coefficient-opening-and-closure-curves-of-butterfly-valves/\">mydatabook.org</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 22, 2020 by Michael Wetter:<br/>
Add parameter <code>Kvs</code>.
</li>
<li>
December 20, 2020 by Filip Jorissen:<br/>
Revised implementation with default <code>Kv</code> computation.
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
