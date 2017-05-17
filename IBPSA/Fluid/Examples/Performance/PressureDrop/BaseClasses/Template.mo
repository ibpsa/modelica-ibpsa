within IBPSA.Fluid.Examples.Performance.PressureDrop.BaseClasses;
partial model Template "Template model"
  extends Modelica.Icons.Example;
  package Medium = IBPSA.Media.Water;
  parameter Integer nRes(min=2) = 10 "Number of resistances";
  parameter Modelica.SIunits.PressureDifference dp_nominal=1
    "Pressure drop at nominal mass flow rate";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate";
  IBPSA.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    nPorts=2,
    use_p_in=true)
              "Pressure boundary condition"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  IBPSA.Fluid.Sources.MassFlowSource_T sou2(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1) "Prescribed mass flow source"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Modelica.Blocks.Sources.Pulse pulse_p(
    amplitude=1,
    period=1,
    offset=Medium.p_default) "Pulse input for pressure"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Modelica.Blocks.Sources.Pulse pulse_m_flow(
    period=1,
    offset=0,
    amplitude=m_flow_nominal) "Pulse input for mass flow rate"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  IBPSA.Fluid.Sources.MassFlowSource_T sou1(
    redeclare package Medium = Medium,
    nPorts=1,
    use_m_flow_in=true) "Prescribed mass flow source"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  FixedResistances.PressureDrop[nRes] res(
    redeclare each package Medium = Medium,
    each m_flow_nominal=m_flow_nominal,
    each allowFlowReversal=false,
    dp_nominal={dp_nominal*(1 + mod(i, 3)) for i in 1:nRes},
    each from_dp=false)
                   "Pressure drop component with from_dp = false"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  FixedResistances.PressureDrop[nRes] res1(
    redeclare each package Medium = Medium,
    each m_flow_nominal=m_flow_nominal,
    each allowFlowReversal=false,
    dp_nominal={dp_nominal*(1 + mod(i, 3)) for i in 1:nRes},
    each from_dp=true) "Pressure drop component with from_dp = true"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  FixedResistances.PressureDrop[nRes] res2(
    redeclare each package Medium = Medium,
    each m_flow_nominal=m_flow_nominal,
    each allowFlowReversal=false,
    dp_nominal={dp_nominal*(1 + mod(i, 3)) for i in 1:nRes},
    each from_dp=false)
                   "Pressure drop component with from_dp = false"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  FixedResistances.PressureDrop[nRes] res3(
    redeclare each package Medium = Medium,
    each m_flow_nominal=m_flow_nominal,
    each allowFlowReversal=false,
    dp_nominal={dp_nominal*(1 + mod(i, 3)) for i in 1:nRes},
    each from_dp=true) "Pressure drop component with from_dp = true"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
equation
    connect(res[1].port_a,sou. ports[1]) annotation (Line(points={{-10,60},{-20,
          60},{-20,42},{-40,42}},             color={0,127,255}));
    connect(res1[1].port_a,sou. ports[2]) annotation (Line(points={{-10,20},{
          -20,20},{-20,38},{-40,38}},         color={0,127,255}));
    connect(res2[1].port_a,sou1. ports[1]) annotation (Line(points={{-10,-20},{-20,
          -20},{-40,-20}},                    color={0,127,255}));
    connect(res3[1].port_a,sou2. ports[1]) annotation (Line(points={{-10,-60},{-20,
          -60},{-40,-60}},                    color={0,127,255}));
  connect(pulse_p.y,sou. p_in) annotation (Line(points={{-79,50},{-70,50},{-70,48},
          {-62,48}}, color={0,0,127}));
  connect(sou2.m_flow_in,pulse_m_flow. y) annotation (Line(points={{-60,-52},{-72,
          -52},{-72,-30},{-79,-30}}, color={0,0,127}));
  connect(sou1.m_flow_in,pulse_m_flow. y) annotation (Line(points={{-60,-12},{-72,
          -12},{-72,-30},{-79,-30}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
May 16, 2017, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Template model for examples.
</p>
</html>"));
end Template;
