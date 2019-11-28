within IBPSA.Fluid.Actuators.Valves.Examples;
model ThreeWayTable "Three way valve with different table-specified opening characteristics for each path"
  extends Modelica.Icons.Example;

  package Medium = IBPSA.Media.Water "Medium in the component";

  IBPSA.Fluid.Actuators.Valves.ThreeWayTable val(
    redeclare package Medium = Medium,
    m_flow_nominal=2,
    use_inputFilter=false,
    dpValve_nominal=6000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    flowCharacteristics1=Data.Linear(),
    flowCharacteristics3(y={0,0.5,1}, phi={0.001,0.3,1}))
    "Valve model, linear opening characteristics"
    annotation (Placement(transformation(extent={{0,-8},{20,12}})));
  Modelica.Blocks.Sources.Ramp y(
    height=1,
    duration=1,
    offset=0) "Control signal"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  IBPSA.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    nPorts=1,
    use_p_in=true,
    T=313.15) "Boundary condition for flow source"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  IBPSA.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    nPorts=1,
    use_p_in=true,
    T=313.15) "Boundary condition for flow sink"
    annotation (Placement(transformation(extent={{70,-10},{50,10}})));
  Modelica.Blocks.Sources.Constant PSin(k=3E5)
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Modelica.Blocks.Sources.Constant PSou(k=306000)
    annotation (Placement(transformation(extent={{-88,-2},{-68,18}})));
  IBPSA.Fluid.Sources.Boundary_pT ret(
    redeclare package Medium = Medium,
    nPorts=1,
    use_p_in=true,
    T=303.15) "Boundary condition for flow sink" annotation (Placement(
        transformation(extent={{10,-10},{-10,10}}, origin={64,-70})));

equation
  connect(y.y, val.y)
    annotation (Line(points={{-19,40},{10,40},{10,14}}, color={0,0,127}));
  connect(PSin.y, sin.p_in)
    annotation (Line(points={{81,70},{86,70},{86,8},{72,8}}, color={0,0,127}));
  connect(sou.ports[1], val.port_1) annotation (Line(points={{-30,0},{-16,0},{-16,
          2},{-5.55112e-16,2}}, color={0,127,255}));
  connect(val.port_2, sin.ports[1])
    annotation (Line(points={{20,2},{36,2},{36,0},{50,0}}, color={0,127,255}));
  connect(PSou.y, ret.p_in) annotation (Line(
      points={{-67,8},{-60,8},{-60,-88},{90,-88},{90,-62},{76,-62}},
      color={0,0,127}));
  connect(ret.ports[1], val.port_3) annotation (Line(points={{54,-70},{40,-70},
          {40,-20},{10,-20},{10,-8}}, color={0,127,255}));
  connect(PSou.y, sou.p_in) annotation (Line(
      points={{-67,8},{-52,8}},
      color={0,0,127}));
  annotation (
    experiment(Tolerance=1e-6, StopTime=1.0),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/Actuators/Valves/Examples/ThreeWayTable.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>Test model for table-specified three way valves.</p>
</html>", revisions="<html>
<ul>
<li>November 15, 2019, by Alexander K&uuml;mpel:<br>First implementation. </li>
</ul>
</html>"));
end ThreeWayTable;
