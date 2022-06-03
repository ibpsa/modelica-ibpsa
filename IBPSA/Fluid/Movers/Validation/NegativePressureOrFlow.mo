within IBPSA.Fluid.Movers.Validation;
model NegativePressureOrFlow
  "A validation model that tests the fan behaviour when the pressure rise or flow is negative"
  extends Modelica.Icons.Example;

  package Medium = IBPSA.Media.Air;

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=0.1
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.PressureDifference dp_nominal=sou.p*0.1
    "Nominal pressure difference";

  IBPSA.Fluid.Movers.SpeedControlled_y fan(
    redeclare package Medium = Medium,
    per(pressure(V_flow={0,m_flow_nominal,2*m_flow_nominal}/1.2,
                 dp={0.5*dp_nominal,0.25*dp_nominal,0})),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Fan"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  IBPSA.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    use_p_in=false,
    p(displayUnit="Pa") = 101325,
    T=293.15,
    nPorts=1) "Source"
              annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  IBPSA.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    use_p_in=true,
    T=293.15,
    nPorts=1) "Sink"
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  Modelica.Blocks.Sources.Constant one(k=1) "Constant one"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Modelica.Blocks.Sources.TimeTable pSin(table=[0,1*sou.p; 0.1,1*sou.p;
    0.3,1.1*sou.p; 0.7,0.9*sou.p; 0.9,1*sou.p; 1,1*sou.p]) "Pressure at the sink"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=-sou.p*0.5,
    duration=3600,
    offset=sou.p*1.25)
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  FixedResistances.PressureDrop dp1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal/2) "Pressure drop"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
equation
  connect(one.y, fan.y)
    annotation (Line(points={{-19,30},{0,30},{0,12}}, color={0,0,127}));

  connect(ramp.y, sin.p_in)
    annotation (Line(points={{61,30},{82,30},{82,8}}, color={0,0,127}));
  connect(fan.port_b, sin.ports[1])
    annotation (Line(points={{10,0},{60,0}}, color={0,127,255}));
  connect(sou.ports[1], dp1.port_a)
    annotation (Line(points={{-60,0},{-40,0}}, color={0,127,255}));
  connect(dp1.port_b, fan.port_a)
    annotation (Line(points={{-20,0},{-10,0}}, color={0,127,255}));
annotation(experiment(
      StopTime=3600,
      Tolerance=1e-06));
end NegativePressureOrFlow;
