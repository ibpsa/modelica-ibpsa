within IBPSA.Fluid.Actuators.Dampers.Examples;
model Damper
  "Dampers with constant pressure difference and varying control signal."
  extends Modelica.Icons.Example;
  package Medium = IBPSA.Media.Air;

  IBPSA.Fluid.Actuators.Dampers.Exponential res(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    use_inputFilter=false)
    "A damper with quadratic relationship between m_flow and dp"
    annotation (Placement(transformation(extent={{0,52},{20,72}})));

    Modelica.Blocks.Sources.Ramp yRam(
    duration=0.3,
    offset=0,
    startTime=0.2,
    height=1) annotation (Placement(transformation(extent={{-20,80},{0,100}})));

  IBPSA.Fluid.Sources.Boundary_pT sou(redeclare package Medium =
        Medium,
    nPorts=4,
    p(displayUnit="Pa") = 101335,
    T=293.15) annotation (Placement(
        transformation(extent={{-62,10},{-42,30}})));

  IBPSA.Fluid.Sources.Boundary_pT sin(redeclare package Medium =
        Medium,
    nPorts=4) annotation (Placement(
        transformation(extent={{92,10},{72,30}})));

  Linear linDpFix(
    use_inputFilter=false,
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dpFixed_nominal=5,
    dp_nominal=10)
    "A damper with a mass flow proportional to the input signal and using dpFixed_nominal"
    annotation (Placement(transformation(extent={{0,-24},{20,-4}})));
  Linear linFromMflow(
    use_inputFilter=false,
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dpFixed_nominal=0,
    dp_nominal=10,
    from_dp=false)
    "A damper with a mass flow proportional to the input signal and using from_dp = false"
    annotation (Placement(transformation(extent={{0,-64},{20,-44}})));
  Linear lin(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal=10,
    use_inputFilter=false)
                   "A damper with a mass flow proportional to the input signal"
    annotation (Placement(transformation(extent={{0,16},{20,36}})));

equation
  connect(yRam.y, res.y) annotation (Line(
      points={{1,90},{10,90},{10,74}},
      color={0,0,127}));
  connect(sou.ports[1], res.port_a) annotation (Line(
      points={{-42,23},{-42,24},{-38,24},{-38,24},{-20,24},{-20,62},{0,62}},
      color={0,127,255}));
  connect(sin.ports[1], res.port_b) annotation (Line(
      points={{72,23},{56,23},{56,24},{40,24},{40,62},{20,62}},
      color={0,127,255}));
  connect(linDpFix.port_b, sin.ports[2]) annotation (Line(points={{20,-14},{40,-14},
          {40,21},{72,21}}, color={0,127,255}));
  connect(linFromMflow.port_b, sin.ports[3]) annotation (Line(points={{20,-54},{
          42,-54},{42,19},{72,19}}, color={0,127,255}));
  connect(linDpFix.port_a, sou.ports[2]) annotation (Line(points={{0,-14},{-20,-14},
          {-20,21},{-42,21}}, color={0,127,255}));
  connect(linFromMflow.port_a, sou.ports[3]) annotation (Line(points={{0,-54},{0,
          -54},{-22,-54},{-22,20},{-42,20},{-42,19}}, color={0,127,255}));
  connect(lin.port_a, sou.ports[4]) annotation (Line(points={{0,26},{-18,26},{-18,
          17},{-42,17}}, color={0,127,255}));
  connect(lin.port_b, sin.ports[4]) annotation (Line(points={{20,26},{38,26},{38,
          17},{72,17}}, color={0,127,255}));
  connect(yRam.y, lin.y) annotation (Line(points={{1,90},{30,90},{30,42},{10,42},
          {10,38}}, color={0,0,127}));
  connect(linDpFix.y, lin.y) annotation (Line(points={{10,-2},{10,6},{30,6},{30,
          42},{10,42},{10,38}}, color={0,0,127}));
  connect(linFromMflow.y, lin.y) annotation (Line(points={{10,-42},{10,-34},{30,
          -34},{30,42},{10,42},{10,38}}, color={0,0,127}));
    annotation (experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://IBPSA/Resources/Scripts/Dymola/Fluid/Actuators/Dampers/Examples/Damper.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
Test model for exponential and linear air dampers.
The air dampers are connected to models for constant inlet and outlet
pressures. The control signal of the dampers is a ramp.
</p>
</html>", revisions="<html>
<ul>
<li>
March 21, 2017 by David Blum:<br/>
Added Linear damper models <code>lin</code>, <code>linDpFix</code>, and <code>linFromMflow</code>.
</li>
<li>
July 20, 2007 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Damper;
