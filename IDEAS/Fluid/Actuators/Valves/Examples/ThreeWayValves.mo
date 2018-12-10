within IDEAS.Fluid.Actuators.Valves.Examples;
model ThreeWayValves "Three way valves with different opening characteristics"
  extends Modelica.Icons.Example;

  package Medium = IDEAS.Media.Water "Medium in the component";

  IDEAS.Fluid.Actuators.Valves.ThreeWayLinear valLin(
    redeclare package Medium = Medium,
    l={0.05,0.05},
    m_flow_nominal=2,
    use_inputFilter=false,
    dpValve_nominal=6000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Valve model, linear opening characteristics"
    annotation (Placement(transformation(extent={{0,-8},{20,12}})));
  Modelica.Blocks.Sources.Ramp y(
    height=1,
    duration=1,
    offset=0) "Control signal"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  IDEAS.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    nPorts=3,
    use_p_in=true,
    T=313.15) "Boundary condition for flow source"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  IDEAS.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    nPorts=3,
    use_p_in=true,
    T=313.15) "Boundary condition for flow sink"
    annotation (Placement(transformation(extent={{70,-10},{50,10}})));
  Modelica.Blocks.Sources.Constant PSin(k=3E5)
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Modelica.Blocks.Sources.Constant PSou(k=306000)
    annotation (Placement(transformation(extent={{-88,-2},{-68,18}})));
  Actuators.Valves.ThreeWayEqualPercentageLinear valEquPerLin(
    l={0.05,0.05},
    redeclare package Medium = Medium,
    R=10,
    m_flow_nominal=2,
    use_inputFilter=false,
    dpValve_nominal=6000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  IDEAS.Fluid.Sources.Boundary_pT ret(
    redeclare package Medium = Medium,
    nPorts=3,
    use_p_in=true,
    T=303.15) "Boundary condition for flow sink" annotation (Placement(
        transformation(extent={{10,-10},{-10,10}}, origin={64,-70})));

  ThreeWayEqualPercentageMixedLinear valMix(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    use_inputFilter=false,
    redeclare package Medium = Medium,
    dpValve_nominal=6000,
    m_flow_nominal=2,
    l={0.05,0.05}) "Valve with mixed equal-percentage / linear characteristic"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
equation
  connect(y.y, valLin.y) annotation (Line(
      points={{-59,90},{-12,90},{-12,32},{10,32},{10,14}},
      color={0,0,127}));
  connect(PSin.y, sin.p_in)
    annotation (Line(points={{81,70},{86,70},{86,8},{72,8}}, color={0,0,127}));
  connect(y.y, valEquPerLin.y) annotation (Line(points={{-59,90},{-12,90},{-12,
          -28},{10,-28},{10,-38}},
                              color={0,0,127}));
  connect(sou.ports[1], valLin.port_1) annotation (Line(
      points={{-30,2.66667},{-16,2.66667},{-16,2},{-5.55112e-16,2}},
      color={0,127,255}));
  connect(sou.ports[2], valEquPerLin.port_1) annotation (Line(
      points={{-30,-2.22045e-16},{-24,-2.22045e-16},{-24,-50},{-5.55112e-16,-50}},
      color={0,127,255}));
  connect(valLin.port_2, sin.ports[1]) annotation (Line(
      points={{20,2},{36,2},{36,2.66667},{50,2.66667}},
      color={0,127,255}));
  connect(valEquPerLin.port_2, sin.ports[2]) annotation (Line(
      points={{20,-50},{37,-50},{37,-2.22045e-16},{50,-2.22045e-16}},
      color={0,127,255}));
  connect(PSou.y, ret.p_in) annotation (Line(
      points={{-67,8},{-60,8},{-60,-88},{90,-88},{90,-62},{76,-62}},
      color={0,0,127}));
  connect(ret.ports[1], valLin.port_3) annotation (Line(
      points={{54,-67.3333},{40,-67.3333},{40,-20},{10,-20},{10,-8}},
      color={0,127,255}));
  connect(ret.ports[2], valEquPerLin.port_3) annotation (Line(
      points={{54,-70},{10,-70},{10,-60}},
      color={0,127,255}));
  connect(PSou.y, sou.p_in) annotation (Line(
      points={{-67,8},{-52,8}},
      color={0,0,127}));
  connect(y.y, valMix.y)
    annotation (Line(points={{-59,90},{10,90},{10,82}}, color={0,0,127}));
  connect(valMix.port_1, sou.ports[3]) annotation (Line(points={{0,70},{-24,70},
          {-24,-2.66667},{-30,-2.66667}}, color={0,127,255}));
  connect(valMix.port_2, sin.ports[3]) annotation (Line(points={{20,70},{50,70},
          {50,-2.66667}}, color={0,127,255}));
  connect(valMix.port_3, ret.ports[3]) annotation (Line(points={{10,60},{10,46},
          {42,46},{42,-72.6667},{54,-72.6667}}, color={0,127,255}));
  annotation (
    experiment(Tolerance=1e-6, StopTime=1.0),
    __Dymola_Commands(file="modelica://IDEAS/Resources/Scripts/Dymola/Fluid/Actuators/Valves/Examples/ThreeWayValves.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Test model for three way valves. Note that the
leakage flow rate has been set to a large value
and the rangeability to a small value
for better visualization of the valve characteristics.
To use common values, use the default values.
</p>
</html>", revisions="<html>
<ul>
<li>
February 28, 2013, by Michael Wetter:<br/>
Added default value for <code>dpValve_nominal</code>.
</li>
<li>
June 16, 2008 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ThreeWayValves;
