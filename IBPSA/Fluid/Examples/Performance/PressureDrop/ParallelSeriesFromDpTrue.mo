within IBPSA.Fluid.Examples.Performance.PressureDrop;
model ParallelSeriesFromDpTrue
  "Parallel-series configurations with from_dp=true for right pressure drop component"
  extends IBPSA.Fluid.Examples.Performance.PressureDrop.BaseClasses.Template;
  Solarwind.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium, nPorts=4)
              "Pressure boundary condition"
      annotation (Placement(transformation(
          extent={{100,-10},{80,10}})));
  FixedResistances.PressureDrop res4(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal,
    from_dp=true) "Series pressure drop component"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  FixedResistances.PressureDrop res5(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal,
    from_dp=true) "Series pressure drop component"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  FixedResistances.PressureDrop res6(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal,
    from_dp=true) "Series pressure drop component"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  FixedResistances.PressureDrop res7(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal,
    from_dp=true) "Series pressure drop component"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
equation
  for i in 1:nRes-1 loop
    connect(res[i].port_a, res[i+1].port_a) annotation (Line(points={{-10,60},{-10,
            60},{-10,66},{-10,60}},                          color={0,127,255}));
    connect(res1[i].port_a, res1[i + 1].port_a) annotation (Line(points={{-10,20},
            {-10,26},{-10,20}},      color={0,127,255}));
    connect(res2[i].port_a, res2[i + 1].port_a) annotation (Line(points={{-10,-20},
            {-10,-14},{-10,-20}},        color={0,127,255}));
    connect(res3[i].port_a, res3[i + 1].port_a) annotation (Line(points={{-10,-60},
            {-10,-54},{-10,-54},{-10,-60}},
                                         color={0,127,255}));
    connect(res[i].port_b, res[i+1].port_b) annotation (Line(points={{10,60},{10,
            66},{10,60}},                                    color={0,127,255}));
    connect(res1[i].port_b, res1[i + 1].port_b) annotation (Line(points={{10,20},
            {10,26},{10,20}},        color={0,127,255}));
    connect(res2[i].port_b, res2[i + 1].port_b) annotation (Line(points={{10,-20},
            {10,-14},{10,-20}},          color={0,127,255}));
    connect(res3[i].port_b, res3[i + 1].port_b) annotation (Line(points={{10,-60},
            {10,-54},{10,-54},{10,-60}}, color={0,127,255}));
  end for;
  connect(res1[1].port_b, res5.port_a)
    annotation (Line(points={{10,20},{25,20},{40,20}}, color={0,127,255}));
  connect(res2[1].port_b, res6.port_a)
    annotation (Line(points={{10,-20},{40,-20}}, color={0,127,255}));
  connect(res3[1].port_b, res7.port_a) annotation (Line(points={{10,-60},{26,-60},
          {40,-60}}, color={0,127,255}));
  connect(res[1].port_b, res4.port_a)
    annotation (Line(points={{10,60},{25,60},{40,60}}, color={0,127,255}));
  connect(res4.port_b, sin.ports[1])
    annotation (Line(points={{60,60},{80,60},{80,3}}, color={0,127,255}));
  connect(res5.port_b, sin.ports[2]) annotation (Line(points={{60,20},{66,20},
          {80,20},{80,1}}, color={0,127,255}));
  connect(res6.port_b, sin.ports[3]) annotation (Line(points={{60,-20},{68,-20},
          {80,-20},{80,-1}}, color={0,127,255}));
  connect(res7.port_b, sin.ports[4])
    annotation (Line(points={{60,-60},{80,-60},{80,-3}}, color={0,127,255}));
     annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-12,76},{14,86}},
          lineColor={28,108,200},
          textString="array"), Text(
          extent={{38,76},{64,86}},
          lineColor={28,108,200},
          textString="one")}),
    Documentation(info="<html>
<p>
Parallel-series configurations of 
<a href=\"modelica://IBPSA.Fluid.FixedResistances.PressureDrop\">
IBPSA.Fluid.FixedResistances.PressureDrop</a> 
components with 
<code>from_dp = true</code> or 
<code>from_dp = false</code> and prescribed 
mass flow rate or prescribed pressure difference.
The left 
<a href=\"modelica://IBPSA.Fluid.FixedResistances.PressureDrop\">
IBPSA.Fluid.FixedResistances.PressureDrop</a> 
is a vector of components that are in parallel
to each other and in series with the right
<a href=\"modelica://IBPSA.Fluid.FixedResistances.PressureDrop\">
IBPSA.Fluid.FixedResistances.PressureDrop</a>. 
The right
<a href=\"modelica://IBPSA.Fluid.FixedResistances.PressureDrop\">
IBPSA.Fluid.FixedResistances.PressureDrop</a> 
have <code>from_dp=true</code>.
See 
<a href=\"IBPSA.Fluid.Examples.Performance.PressureDrop.ParallelSeriesFromDpFalse\">
IBPSA.Fluid.Examples.Performance.PressureDrop.ParallelSeriesFromDpFalse</a>
for <code>from_dp=false</code>.
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
    __Dymola_Commands(file="Resources/Scripts/Dymola/Fluid/Examples/Performance/PressureDrop/ParallelSeriesFromDpTrue.mos"
        "Simulate and plot"));
end ParallelSeriesFromDpTrue;
