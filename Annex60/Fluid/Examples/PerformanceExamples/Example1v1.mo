within Annex60.Fluid.Examples.PerformanceExamples;
model Example1v1 "Example 1 model without mixing volume"
  extends Annex60.Fluid.Examples.PerformanceExamples.BaseClasses.Example1(
      allowFlowReversal(k=false), from_dp(k=true));

equation
  for i in 1:nRes.k loop
    connect(res[i].port_b, val.port_3) annotation (Line(
      points={{90,30},{100,30},{100,-10},{20,-10},{20,20}},
      color={0,127,255},
      smooth=Smooth.None));
  end for;
  annotation (experiment(
      StopTime=10000,
      __Dymola_NumberOfIntervals=10,
      __Dymola_Algorithm="Radau"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-20},{100,
            100}}), graphics={Ellipse(
          extent={{66,0},{74,-8}},
          lineColor={0,0,255},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,255})}),
    Documentation(info="<html>
<p>
This model demonstrates the impact of the <code>allowFlowReversal</code> 
and <code>from_dp</code> parameters on the sizes of nonlinear algebraic loops. 
The user can change the parameter value in the respective 
<code>BooleanConstant</code> blocks and rerun the simulation to compare the performance. 
The results are also demonstrated below for <code>nRes.k = 20</code>, 
the number of parallel branches, which contain one pressure drop element each. 
</p>
<p>
These results were generated using Dymola 2015FD01 64 bit on Ubuntu 14.04. 
</p>
<h3>Default case:</h3>
<p>
<code>AllowFlowReversal = true</code> and <code>from_dp = false</code> 
</p>
<p>
Sizes of nonlinear systems of equations: {6, 21, <b>46</b>}
</p>
<p>
Sizes after manipulation of the nonlinear systems: {1, 19, <b>22</b>} 
</p>
<h3>Change 1: </h3>
<p>
<code>AllowFlowReversal = false</code> and <code>from_dp = false</code> 
</p>
<p>
Sizes of nonlinear systems of equations: {6, 21}
</p>
<p>
Sizes after manipulation of the nonlinear systems: {1, 19} 
</p>
<h3>Change 2: </h3>
<p>
<code>AllowFlowReversal = false</code> and <code>from_dp = true</code> 
</p>
<p>
Sizes of nonlinear systems of equations: {6, 21}
</p>
<p>
Sizes after manipulation of the nonlinear systems: {1, <b>1</b>} 
</p>
<p>
These changes also have a significant impact on the computational speed. 
</p>
<p>
See fixme paper for a discussion.
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
end Example1v1;
