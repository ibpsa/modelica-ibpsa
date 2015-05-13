within Annex60.Fluid.Examples.PerformanceExamples;
model Example1v2 "Example 1 model with mixing volume"
  extends Annex60.Fluid.Examples.PerformanceExamples.BaseClasses.Example1;

  Delays.DelayFirstOrder[nRes.k] vol(
    redeclare each package Medium = Medium,
    each m_flow_nominal=m_flow_nominal,
    each allowFlowReversal=allowFlowReversal.k,
    each nPorts=2,
    each tau=tau) "Mixing volumes for enthalpy circuit"
    annotation (Placement(transformation(extent={{80,-16},{60,4}})));
  parameter Modelica.SIunits.Time tau=10 "Time constant at nominal flow";
equation
  for i in 1:nRes.k loop
    connect(vol[i].ports[1], res[i].port_b) annotation (Line(
      points={{72,-16},{72,-20},{90,-20},{90,30}},
      color={0,127,255},
      smooth=Smooth.None));
    connect(vol[i].ports[2], val.port_3) annotation (Line(
      points={{68,-16},{68,-20},{20,-20},{20,20}},
      color={0,127,255},
      smooth=Smooth.None));

  end for;
  annotation (experiment(
      StopTime=10000,
      __Dymola_NumberOfIntervals=10,
      __Dymola_Algorithm="Radau"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-40},{100,
            100}}), graphics),
    Documentation(info="<html>
<p>
This model demonstrates the impact of the <code>allowFlowReversal</code> parameter on the sizes
of nonlinear systems of equations. The user can change the parameter value in the <code>allowFlowReversal</code>
block to rerun the simulation. The results are also demonstrated below for <code>nRes.k = 10</code>, 
the number of parallel branches containing one pressure drop element and one mixing volume each.
</p>
<p>
This model was created for demonstrating the influence of a new implementation of <code>ConservationEquation</code>.
The old implementation used <code>actualStream()</code> whereas the new implementation uses the <code>semiLinear()</code>
function. This change allows Dymola to exploit knowledge about the min/max value of <code>m_flow</code>.
When Dymola knows in which way the medium will flow, nonlinear systems can be simplified or completely removed. 
This is illustrated by the results below. 
See <a href='https://github.com/iea-annex60/modelica-annex60/issues/216'>issue 216 </a> for a discussion. <br/>
Note that Dymola can only reliable solve the last case. For the other
two cases the Newton solver of the nonlinear system does not converge.
</p>
<p>
These results were generated using Dymola 2015FD01 64 bit on Ubuntu 14.04.
</p>
<h3>
AllowFlowReversal = true
</h3>
<p>
Sizes of nonlinear systems of equations: {7, 21, <b>56</b>}<br/>
Sizes after manipulation of the nonlinear systems: {2, 10, <b>12</b>}
</p>
<h3>
AllowFlowReversal = false
</h3>
<p>
<b>Old implementation</b>
</p>
<p>
Sizes of nonlinear systems of equations: {7, 21, <b>56</b>}<br/>
Sizes after manipulation of the nonlinear systems: {2, 10, <b>12</b>}
</p>
<p>
<b>New implementation</b>
</p>
<p>
Sizes of nonlinear systems of equations: {7, 21, <b>4</b>}<br/>
Sizes after manipulation of the nonlinear systems: {2, 10, <b>1</b>}
</p>
</html>", revisions="<html>
<ul>
<li>
April 17, 2015, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=
            false)),
    __Dymola_experimentSetupOutput(events=false));
end Example1v2;
