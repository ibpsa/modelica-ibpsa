within IBPSA.Fluid.Examples.Performance.PressureDrop;
model Series "Series configurations"
  extends IBPSA.Fluid.Examples.Performance.PressureDrop.BaseClasses.Template;
  Solarwind.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    nPorts=4) "Pressure boundary condition"
      annotation (Placement(transformation(
          extent={{80,-10},{60,10}})));
equation
  for i in 1:nRes-1 loop
    connect(res[i].port_b, res[i+1].port_a) annotation (Line(points={{10,60},{10,
            60},{10,66},{-10,66},{-10,60}},                  color={0,127,255}));
    connect(res1[i].port_b, res1[i + 1].port_a) annotation (Line(points={{10,20},{
          10,26},{-10,26},{-10,20}}, color={0,127,255}));
    connect(res2[i].port_b, res2[i + 1].port_a) annotation (Line(points={{10,-20},
          {10,-14},{-10,-14},{-10,-20}}, color={0,127,255}));
    connect(res3[i].port_b, res3[i + 1].port_a) annotation (Line(points={{10,-60},
            {10,-54},{-10,-54},{-10,-60}},
                                         color={0,127,255}));
  end for;
    connect(res[nRes].port_b, sin.ports[1]) annotation (Line(points={{10,60},{24,
          60},{24,3},{60,3}},                 color={0,127,255}));
    connect(res1[nRes].port_b, sin.ports[2]) annotation (Line(points={{10,20},{24,
          20},{24,1},{60,1}},                 color={0,127,255}));
    connect(res2[nRes].port_b, sin.ports[3]) annotation (Line(points={{10,-20},{
          24,-20},{24,-1},{60,-1}},           color={0,127,255}));
    connect(res3[nRes].port_b, sin.ports[4]) annotation (Line(points={{10,-60},{
          24,-60},{24,-3},{60,-3}},           color={0,127,255}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
Series configurations of 
<a href=\"modelica://IBPSA.Fluid.FixedResistances.PressureDrop\">
IBPSA.Fluid.FixedResistances.PressureDrop</a> 
components with 
<code>from_dp = true</code> or 
<code>from_dp = false</code> and prescribed 
mass flow rate or prescribed pressure difference.
</p>
<p>
See translation statistics for how these configurations
affect the number and size of algebraic loops.
</p>
</html>", revisions="<html>
<ul>
<li>
May 16, 2017, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(StartTime=-1, StopTime=1, Tolerance=1e-06),
    __Dymola_Commands(file="Resources/Scripts/Dymola/Fluid/Examples/Performance/PressureDrop/Series.mos"
        "Simulate and plot"));
end Series;
