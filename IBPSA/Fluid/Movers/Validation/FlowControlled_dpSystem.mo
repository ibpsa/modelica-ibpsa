within IBPSA.Fluid.Movers.Validation;
model FlowControlled_dpSystem
  "Comparison of FlowControlled_dp and FlowControlled_dpSystem"
  extends Modelica.Icons.Example;
  package Medium = IBPSA.Media.Air;
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal= 1
    "Nominal mass flow rate";
  parameter Modelica.SIunits.PressureDifference dp_nominal = 500
    "Nominal pressure difference";
  Modelica.Blocks.Sources.Ramp y(
    offset=1,
    duration=0.5,
    startTime=0.25,
    height=-1) "Input signal"
    annotation (Placement(transformation(extent={{-70,130},{-50,150}})));
  Sources.Boundary_pT             sou(
    redeclare package Medium = Medium,
    nPorts=3) "Source"
              annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  FixedResistances.PressureDrop dpDow1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal/2) "Downstream pressure drop"
    annotation (Placement(transformation(extent={{78,110},{98,130}})));
  IBPSA.Fluid.Movers.FlowControlled_dp floCon_dp(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=false,
    m_flow_nominal=1,
    use_inputFilter=false) "Regular dp controlled pump"
    annotation (Placement(transformation(extent={{40,110},{60,130}})));
  IBPSA.Fluid.Movers.FlowControlled_dpSystem floCon_dpSys(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=false,
    m_flow_nominal=1,
    use_inputFilter=false)
    "Dp controlled pump that sets downstream pressure point"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  IBPSA.Fluid.FixedResistances.PressureDrop dpDow2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal/2) "Downstream pressure drop"
    annotation (Placement(transformation(extent={{80,30},{100,50}})));
  Modelica.Blocks.Math.Gain gain "Gain for input signal"
    annotation (Placement(transformation(extent={{-26,130},{-6,150}})));
  IBPSA.Fluid.FixedResistances.PressureDrop dpUps1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal/2) "Upstream pressuredrop"
    annotation (Placement(transformation(extent={{0,110},{20,130}})));
  IBPSA.Fluid.FixedResistances.PressureDrop dpUps2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal/2) "Upstream pressuredrop"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Sensors.Pressure senPre(redeclare package Medium = Medium)
    "Pressure sensor for remote set point"
    annotation (Placement(transformation(extent={{124,64},{104,84}})));
  Sensors.RelativePressure senRelPreUps(redeclare package Medium = Medium)
    "Relative pressure sensor"
    annotation (Placement(transformation(extent={{80,0},{60,20}})));

  Sources.Boundary_pT sin(redeclare package Medium = Medium, nPorts=3) "Sink"
    annotation (Placement(transformation(extent={{160,30},{140,50}})));
  IBPSA.Fluid.Movers.FlowControlled_dpSystem floCon_dpSysUps(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=false,
    m_flow_nominal=1,
    use_inputFilter=false,
    setDownStreamPressure=false)
    "Dp controlled pump that sets upstream pressure point"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
  IBPSA.Fluid.FixedResistances.PressureDrop dpDow3(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal/2) "Downstream pressure drop"
    annotation (Placement(transformation(extent={{80,-50},{100,-30}})));
  IBPSA.Fluid.FixedResistances.PressureDrop dpUps3(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal/2) "Upstream pressuredrop"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Sensors.RelativePressure senRelPreDow(redeclare package Medium = Medium)
    "Downstream relative pressure sensor"
    annotation (Placement(transformation(extent={{40,-80},{20,-60}})));
  Sensors.Pressure senPre1(
                          redeclare package Medium = Medium)
    "Pressure sensor for remote set point"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
equation
  assert(abs(senRelPreUps.p_rel - floCon_dpSys.dp_in) < 1e-6,
    "Remote pressure set point is not tracked correctly");
  assert(abs(senRelPreDow.p_rel - floCon_dpSysUps.dp_in) < 1e-6,
    "Remote pressure set point is not tracked correctly");
  connect(floCon_dp.port_b, dpDow1.port_a)
    annotation (Line(points={{60,120},{78,120}}, color={0,127,255}));
  connect(y.y,gain. u) annotation (Line(
      points={{-49,140},{-28,140}},
      color={0,0,127}));
  connect(floCon_dpSys.port_b, dpDow2.port_a)
    annotation (Line(points={{60,40},{70,40},{80,40}}, color={0,127,255}));
  connect(dpUps1.port_b, floCon_dp.port_a)
    annotation (Line(points={{20,120},{40,120}}, color={0,127,255}));
  connect(dpUps2.port_b, floCon_dpSys.port_a)
    annotation (Line(points={{20,40},{30,40},{40,40}}, color={0,127,255}));
  connect(dpUps1.port_a, sou.ports[1]) annotation (Line(points={{0,120},{-60,
          120},{-60,42.6667}}, color={0,127,255}));
  connect(dpUps2.port_a, sou.ports[2])
    annotation (Line(points={{0,40},{-32,40},{-60,40}}, color={0,127,255}));
  connect(gain.y,floCon_dp. dp_in) annotation (Line(
      points={{-5,140},{49.8,140},{49.8,132}},
      color={0,0,127}));
  connect(gain.y, floCon_dpSys.dp_in) annotation (Line(points={{-5,140},{30,140},
          {30,70},{49.8,70},{49.8,52}}, color={0,0,127}));
  connect(senPre.port, dpDow2.port_b)
    annotation (Line(points={{114,64},{114,40},{100,40}}, color={0,127,255}));
  connect(senPre.p, floCon_dpSys.p)
    annotation (Line(points={{103,74},{42,74},{42,52}}, color={0,0,127}));
  connect(senRelPreUps.port_b, floCon_dpSys.port_a)
    annotation (Line(points={{60,10},{40,10},{40,40}}, color={0,127,255}));
  connect(senRelPreUps.port_a, dpDow2.port_b)
    annotation (Line(points={{80,10},{100,10},{100,40}}, color={0,127,255}));
  connect(floCon_dpSysUps.port_b, dpDow3.port_a)
    annotation (Line(points={{60,-40},{80,-40}}, color={0,127,255}));
  connect(dpUps3.port_b, floCon_dpSysUps.port_a)
    annotation (Line(points={{20,-40},{40,-40}}, color={0,127,255}));
  connect(floCon_dpSysUps.dp_in, floCon_dpSys.dp_in) annotation (Line(points={{
          49.8,-28},{50,-28},{50,-12},{30,-12},{30,70},{49.8,70},{49.8,52}},
        color={0,0,127}));
  connect(dpDow3.port_b, sin.ports[1]) annotation (Line(points={{100,-40},{140,
          -40},{140,42.6667}}, color={0,127,255}));
  connect(dpDow2.port_b, sin.ports[2])
    annotation (Line(points={{100,40},{140,40}}, color={0,127,255}));
  connect(dpDow1.port_b, sin.ports[3]) annotation (Line(points={{98,120},{140,
          120},{140,37.3333}}, color={0,127,255}));
  connect(dpUps3.port_a, sou.ports[3]) annotation (Line(points={{0,-40},{-20,
          -40},{-60,-40},{-60,37.3333}}, color={0,127,255}));
  connect(dpUps3.port_a, senPre1.port)
    annotation (Line(points={{0,-40},{0,-30}}, color={0,127,255}));
  connect(senPre1.p, floCon_dpSysUps.p)
    annotation (Line(points={{11,-20},{42,-20},{42,-28}}, color={0,0,127}));
  connect(senRelPreDow.port_a, floCon_dpSysUps.port_b)
    annotation (Line(points={{40,-70},{60,-70},{60,-40}}, color={0,127,255}));
  connect(senRelPreDow.port_b, dpUps3.port_a)
    annotation (Line(points={{20,-70},{0,-70},{0,-40}}, color={0,127,255}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{160,
            160}})),
experiment(StopTime=1, Tolerance=1e-06),
__Dymola_Commands(file="modelica://IBPSA/Resources/Scripts/Dymola/Fluid/Movers/Validation/FlowControlled_dp.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example demonstrates and tests the use of a flow machine whose mass flow rate is reduced to zero.
</p>
<p>
The fans have been configured as steady-state models.
This ensures that the actual speed is equal to the input signal.
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
