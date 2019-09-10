within IBPSA.Fluid.FixedResistances.Examples;
model CheckValve_from_dp "Example model for check valve"
  extends Modelica.Icons.Example;

  package Medium = IDEAS.Media.Water "Medium model";

  Modelica.Blocks.Sources.Ramp P(
    duration=1.001,
    height=4e5,
    offset=3e5,
    startTime=0)        "Ramp pressure signal"
    annotation (Placement(transformation(extent={{-92,-2},{-72,18}})));

  IDEAS.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    T=273.15 + 20,
    use_p_in=true,
    nPorts=1)
    "Pressure boundary condition"
    annotation (Placement(transformation(
          extent={{-50,-10},{-30,10}})));

  IDEAS.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    T=273.15 + 10,
    p(displayUnit="bar") = 500000,
    nPorts=1)
    "Pressure boundary condition"
    annotation (Placement(transformation(
          extent={{50,-10},{30,10}})));

  IBPSA.Fluid.FixedResistances.CheckValve checkValve(
    redeclare package Medium = IDEAS.Media.Water,
    m_flow_nominal=5,
    dpValve_nominal=1e5)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(P.y, sou.p_in)
    annotation (Line(points={{-71,8},{-52,8}}, color={0,0,127}));

  connect(sou.ports[1], checkValve.port_a)
    annotation (Line(points={{-30,0},{-10,0}}, color={0,127,255}));
  connect(checkValve.port_b, sin.ports[1])
    annotation (Line(points={{10,0},{30,0}}, color={0,127,255}));
  annotation (experiment(StopTime=1));
end CheckValve_from_dp;
