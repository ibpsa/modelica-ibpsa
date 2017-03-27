within IBPSA.Fluid.Actuators.Dampers.Examples;
model Damper
  "Dampers with constant pressure difference and varying control signal."
  extends Modelica.Icons.Example;
  package Medium = IBPSA.Media.Air;

  IBPSA.Fluid.Actuators.Dampers.Exponential res(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    filteredOpening=false)
    "A damper with quadratic relationship between m_flow and dp"
    annotation (Placement(transformation(extent={{0,12},{20,32}})));
    Modelica.Blocks.Sources.Ramp yRam(
    duration=0.3,
    offset=0,
    startTime=0.2,
    height=1)    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Annex60.Fluid.Sources.Boundary_pT sou(             redeclare package Medium =
        Medium,
    nPorts=2,
    p(displayUnit="Pa") = 101335,
    T=293.15)                                       annotation (Placement(
        transformation(extent={{-68,26},{-48,46}})));
  Annex60.Fluid.Sources.Boundary_pT sin(             redeclare package Medium =
        Medium,
    nPorts=4,
        transformation(extent={{-68,10},{-48,30}})));
  Annex60.Fluid.Sources.Boundary_pT sin(             redeclare package Medium =
        Medium,
    nPorts=2,
    p(displayUnit="Pa") = 101325,
    T=293.15)                                       annotation (Placement(
        transformation(extent={{74,26},{54,46}})));

  Linear lin(
    filteredOpening=false,
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dpFixed_nominal=0,
    dp_nominal=10)
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Linear lin_fixed(
    filteredOpening=false,
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dpFixed_nominal=5,
    dp_nominal=10)
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Linear lin_m_flow(
    filteredOpening=false,
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dpFixed_nominal=0,
    dp_nominal=10,
    from_dp=false)
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
equation
  connect(yRam.y, res.y) annotation (Line(
      points={{1,70},{10,70},{10,52}},
      color={0,0,127}));
  connect(sou.ports[1], res.port_a) annotation (Line(
      points={{-48,39},{-24,40},{0,40}},
      color={0,127,255}));
  connect(sin.ports[1], res.port_b) annotation (Line(
      points={{54,39},{38,40},{20,40}},
      color={0,127,255}));
  connect(yRam.y, lin.y) annotation (Line(points={{1,70},{30,70},{30,12},{10,12}},
        color={0,0,127}));
  connect(sou.ports[2], lin.port_a) annotation (Line(points={{-48,37},{-20,37},
          {-20,0},{0,0}}, color={0,127,255}));
  connect(lin.port_b, sin.ports[2]) annotation (Line(points={{20,0},{40,0},{40,
          37},{54,37}}, color={0,127,255}));
  connect(yRam.y, lin_fixed.y) annotation (Line(points={{1,70},{16,70},{30,70},
          {30,-28},{10,-28}}, color={0,0,127}));
  connect(yRam.y, lin_m_flow.y) annotation (Line(points={{1,70},{30,70},{30,-68},
          {10,-68}}, color={0,0,127}));
  connect(lin_fixed.port_a, sou.ports[3]) annotation (Line(points={{0,-40},{-22,
          -40},{-22,35},{-48,35}}, color={0,127,255}));
  connect(lin_m_flow.port_a, sou.ports[4]) annotation (Line(points={{0,-80},{
          -24,-80},{-24,33},{-48,33}}, color={0,127,255}));
  connect(lin_fixed.port_b, sin.ports[3]) annotation (Line(points={{20,-40},{42,
          -40},{42,35},{54,35}}, color={0,127,255}));
  connect(lin_m_flow.port_b, sin.ports[4]) annotation (Line(points={{20,-80},{
          44,-80},{44,33},{54,33}}, color={0,127,255}));
    annotation (experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://IBPSA/Resources/Scripts/Dymola/Fluid/Actuators/Dampers/Examples/Damper.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
Test model for the air damper with and without linearization of the pressure-flow relationship.
The air dampers are connected to models for constant inlet and outlet
pressures. The control signal of the damper is a ramp.
The pressure versus mass flow rate relation of the two models
intersect when <code>m_flow = m_flow_nominal = 1</code> kg/s.
</p>
</html>", revisions="<html>
<ul>
<li>
October 12, 2016 by David Blum:<br/>
Added damper <code>resLinear</code> with <code>linearized=true</code>.
</li>
<li>
July 20, 2007 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Damper;
