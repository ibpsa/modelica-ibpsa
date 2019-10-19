within IBPSA.Fluid.FixedResistances.Examples;
model CheckValve "Example model for check valve"
  extends Modelica.Icons.Example;
  package Medium = IBPSA.Media.Water "Medium model";
  Modelica.Blocks.Sources.Ramp P(
    duration=1,
    height=4e5,
    offset=3e5,
    startTime=0)        "Ramp pressure signal"
    annotation (Placement(transformation(extent={{-92,-2},{-72,18}})));
  IBPSA.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    T=273.15 + 20,
    use_p_in=true,
    nPorts=2)
    "Pressure boundary condition"
    annotation (Placement(transformation(
          extent={{-50,-10},{-30,10}})));
  IBPSA.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    T=273.15 + 10,
    p(displayUnit="bar") = 500000,
    nPorts=2)
    "Pressure boundary condition"
    annotation (Placement(transformation(
          extent={{50,-10},{30,10}})));
  IBPSA.Fluid.FixedResistances.CheckValve checkValve(
    redeclare package Medium = IBPSA.Media.Water,
    m_flow_nominal=5,
    dpValve_nominal=1e5)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  IBPSA.Fluid.FixedResistances.CheckValve checkValveDpFix(
    redeclare package Medium = Media.Water,
    m_flow_nominal=5,
    dpValve_nominal=1e5,
    dpFixed_nominal=10e5) "Check valve with series resistance"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
equation
  connect(P.y, sou.p_in)
    annotation (Line(points={{-71,8},{-52,8}}, color={0,0,127}));
  connect(sou.ports[1], checkValve.port_a)
    annotation (Line(points={{-30,2},{-20,2},{-20,0},{-10,0}},
                                               color={0,127,255}));
  connect(checkValve.port_b, sin.ports[1])
    annotation (Line(points={{10,0},{20,0},{20,2},{30,2}},
                                             color={0,127,255}));
  connect(sou.ports[2], checkValveDpFix.port_a)
    annotation (Line(points={{-30,-2},{-30,30},{-10,30}}, color={0,127,255}));
  connect(checkValveDpFix.port_b, sin.ports[2])
    annotation (Line(points={{10,30},{30,30},{30,-2}}, color={0,127,255}));
  annotation (experiment(Tolerance=1e-06, __Dymola_Algorithm="Lsodar",stopTime=1),
      __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/FixedResistances/Examples/CheckValve.mos"
        "Simulate and plot"));
end CheckValve;
