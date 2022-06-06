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
    nPorts=1) "Source with constant pressure"
              annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  IBPSA.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    use_p_in=true,
    T=293.15,
    nPorts=1) "Sink with varying pressure"
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  Modelica.Blocks.Sources.Constant one(k=1) "Constant one"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Modelica.Blocks.Sources.Ramp ram(
    height=-sou.p*0.5,
    duration=3600,
    offset=sou.p*1.25) "Ramp signal"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
equation
  connect(one.y, fan.y)
    annotation (Line(points={{-19,30},{0,30},{0,12}}, color={0,0,127}));

  connect(ram.y, sin.p_in)
    annotation (Line(points={{61,30},{82,30},{82,8}}, color={0,0,127}));
  connect(fan.port_b, sin.ports[1])
    annotation (Line(points={{10,0},{60,0}}, color={0,127,255}));
  connect(sou.ports[1], fan.port_a)
    annotation (Line(points={{-60,0},{-10,0}}, color={0,127,255}));
annotation(__Dymola_Commands(file="modelica://IBPSA/Resources/Scripts/Dymola/Fluid/Movers/Validation/NegativePressureOrFlow.mos"
        "Simulate and plot"),
   experiment(
      StopTime=3600,
      Tolerance=1e-06));
end NegativePressureOrFlow;
