within Annex60.Fluid.Examples.PerformanceExamples;
model Example1v2 "Example 1 model with mixing volume"
  extends Annex60.Fluid.Examples.PerformanceExamples.BaseClasses.Example1;

  Delays.DelayFirstOrder[nRes.k] vol(
    redeclare each package Medium = Medium,
    each m_flow_nominal=m_flow_nominal,
    each allowFlowReversal=allowFlowReversal.k,
    each nPorts=2,
    each tau=tau) "Mixing volumes for enthalpy circuit"
    annotation (Placement(transformation(extent={{80,-8},{60,12}})));
  parameter Modelica.SIunits.Time tau=10 "Time constant at nominal flow";
equation
  for i in 1:nRes.k loop
    connect(vol[i].ports[1], res[i].port_b) annotation (Line(
      points={{72,-8},{72,-10},{100,-10},{100,30},{90,30},{90,30}},
      color={0,127,255},
      smooth=Smooth.None));
    connect(vol[i].ports[2], val.port_3) annotation (Line(
      points={{68,-8},{68,-10},{20,-10},{20,20}},
      color={0,127,255},
      smooth=Smooth.None));

  end for;
  annotation (experiment(
      StopTime=10000,
      __Dymola_NumberOfIntervals=10,
      __Dymola_Algorithm="Radau"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-20},{100,
            100}}), graphics),
    Documentation(info="<html>
<p>
This example is an extension of Example1v1 and demonstrates the use of 
mixing volumes for decoupling the algebraic loop that solves for the enthalpy of the system.
</p>
<h3>Example1v1:</h3>
<p>
Sizes of nonlinear systems of equations: {6, 21, <b>46</b>}
</p>
<p>
Sizes after manipulation of the nonlinear systems: {1, 19, <b>22</b>} 
</p>
<h3>Example1v2 using mixing volumes: </h3>
<p>
Sizes of nonlinear systems of equations: {6, 21, <b>4</b>}
</p>
<p>
Sizes after manipulation of the nonlinear systems: {1, 19, <b>1</b>} 
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
    __Dymola_experimentSetupOutput(events=false),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/Examples/PerformanceExamples/Example1v2.mos"
        "Simulate and plot"));
end Example1v2;
