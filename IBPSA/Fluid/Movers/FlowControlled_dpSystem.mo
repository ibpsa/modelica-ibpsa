within IBPSA.Fluid.Movers;
model FlowControlled_dpSystem
  "Fan or pump with ideally controlled head dp relative to upstream or downstream pressure measurement as input signal"
  extends FlowControlled_dp(preSou(final control_dp=false));
  parameter Boolean setDownStreamPressure = true
    "= false, to set head dp relative to a point upstream of the fan or pump"
    annotation(Evaluate=true);

  Modelica.Blocks.Interfaces.RealInput p=
    if setDownStreamPressure
    then port_a.p + gain.u
    else port_b.p - gain.u
    "Pressure measurement at the point in the system relative to which the head dp should be controlled"
    annotation (Placement(transformation(extent={{-52,96},{-92,136}}),
        iconTransformation(
        extent={{20,-20},{-20,20}},
        rotation=90,
        origin={-80,120})));

  annotation (Documentation(info="<html>
<p>
This model is an idealised implementation of a pump 
with an integrated static pressure reset controller. 
The mover is controlled such that the pressure difference 
between the inlet of the mover and a point downstream 
in the system is equal to the prescribed pressure difference. 
A measurement of the pressure at the remote point in the 
system needs to be provided as an input to the model.
</p>
<h4>Main equations</h4>
<p>
See the
<a href=\"modelica://IBPSA.Fluid.Movers.UsersGuide\">
User's Guide</a> for general information
with respect to fans and pumps.
</p>
<h4>Typical use and important parameters</h4>
<p>
Parameter <code>setDownStreamPressure</code> can be 
set to <code>false</code> to set the pressure head
between the mover outlet and a point upstream in the system. 
</p>
<h4>Implementation</h4>
<p>
This model prescribes the value of the <code>RealInput</code>
<code>p</code>. Moreover the equations in <code>preSou</code>
are not locally balanced.
</p>
</html>", revisions="<html>
<ul>
<li>
May 4 2017, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
end FlowControlled_dpSystem;
