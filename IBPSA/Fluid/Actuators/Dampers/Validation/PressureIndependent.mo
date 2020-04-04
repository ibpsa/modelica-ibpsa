within IBPSA.Fluid.Actuators.Dampers.Validation;
model PressureIndependent
  "Dampers with constant pressure difference and varying control signal."
  extends Modelica.Icons.Example;
  package Medium = IBPSA.Media.Air "Medium model for air";

  IBPSA.Fluid.Actuators.Dampers.Exponential res(
    redeclare package Medium = Medium,
    use_inputFilter=false,
    dpDamper_nominal=10,
    m_flow_nominal=1,
    k1=0.45) "A damper with quadratic relationship between m_flow and dp"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));

    Modelica.Blocks.Sources.Ramp yRam(
    duration=0.3,
    offset=0,
    startTime=0.5,
    height=1) annotation (Placement(transformation(extent={{-20,60},{0,80}})));

  IBPSA.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    use_p_in=true,
    p(displayUnit="Pa") = 101335,
    T=293.15,
    nPorts=3) "Pressure boundary condition"
     annotation (Placement(
        transformation(extent={{-50,-10},{-30,10}})));

  IBPSA.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    nPorts=3) "Pressure boundary condition"
      annotation (Placement(
        transformation(extent={{94,-10},{74,10}})));

  IBPSA.Fluid.Actuators.Dampers.PressureIndependent preInd(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dpDamper_nominal=10,
    use_inputFilter=false)
    "A damper with a mass flow proportional to the input signal"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Exponential                               res1(
    redeclare package Medium = Medium,
    use_inputFilter=false,
    dpDamper_nominal=10,
    m_flow_nominal=1,
    k1=0.45) "A damper with quadratic relationship between m_flow and dp"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  Controls.Continuous.LimPID conPID(k=10, Ti=0.01)
    annotation (Placement(transformation(extent={{-70,-70},{-50,-50}})));
  Sensors.MassFlowRate senMasFlo(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{30,-70},{50,-90}})));
    Modelica.Blocks.Sources.Ramp yRam1(
    duration=0.3,
    offset=Medium.p_default - 100,
    startTime=0,
    height=200)
              annotation (Placement(transformation(extent={{-90,60},{-70,80}})));
    Modelica.Blocks.Sources.Ramp yRam2(
    duration=0.2,
    offset=0,
    startTime=0.8,
    height=-200)
              annotation (Placement(transformation(extent={{-90,16},{-70,36}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{-52,30},{-32,50}})));
equation
  connect(res.port_a, sou.ports[1]) annotation (Line(points={{0,-40},{-20,-40},
          {-20,2.66667},{-30,2.66667}},
                               color={0,127,255}));
  connect(res.port_b, sin.ports[1]) annotation (Line(points={{20,-40},{60,-40},{
          60,2.66667},{74,2.66667}},
                      color={0,127,255}));
  connect(sou.ports[2], preInd.port_a) annotation (Line(points={{-30,
          -2.22045e-16},{-20,-2.22045e-16},{-20,0},{0,0}},
                              color={0,127,255}));
  connect(preInd.port_b, sin.ports[2]) annotation (Line(points={{20,0},{48,0},{
          48,-2.22045e-16},{74,-2.22045e-16}},
                           color={0,127,255}));
  connect(yRam.y, preInd.y) annotation (Line(points={{1,70},{36,70},{36,20},{10,
          20},{10,12}}, color={0,0,127}));
  connect(preInd.y_actual, res.y) annotation (Line(points={{15,7},{40,7},{40,
          -20},{10,-20},{10,-28}},
                              color={0,0,127}));
  connect(res1.port_b, senMasFlo.port_a)
    annotation (Line(points={{20,-80},{30,-80}}, color={0,127,255}));
  connect(senMasFlo.port_b, sin.ports[3]) annotation (Line(points={{50,-80},{68,
          -80},{68,-2.66667},{74,-2.66667}}, color={0,127,255}));
  connect(sou.ports[3], res1.port_a) annotation (Line(points={{-30,-2.66667},{
          -20,-2.66667},{-20,-80},{0,-80}},
                                        color={0,127,255}));
  connect(senMasFlo.m_flow, conPID.u_m) annotation (Line(points={{40,-91},{40,-100},
          {-60,-100},{-60,-72}}, color={0,0,127}));
  connect(conPID.y, res1.y)
    annotation (Line(points={{-49,-60},{10,-60},{10,-68}}, color={0,0,127}));
  connect(yRam.y, conPID.u_s) annotation (Line(points={{1,70},{36,70},{36,40},{
          94,40},{94,-110},{-80,-110},{-80,-60},{-72,-60}},
                                    color={0,0,127}));
  connect(yRam1.y, add.u1) annotation (Line(points={{-69,70},{-62,70},{-62,46},
          {-54,46}}, color={0,0,127}));
  connect(yRam2.y, add.u2) annotation (Line(points={{-69,26},{-62,26},{-62,34},
          {-54,34}}, color={0,0,127}));
  connect(add.y, sou.p_in) annotation (Line(points={{-31,40},{-26,40},{-26,20},
          {-62,20},{-62,8},{-52,8}}, color={0,0,127}));
    annotation (experiment(Tolerance=1e-6, StopTime=1.0),
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
Added Linear damper models <code>lin</code>, <code>preIndFrom_dp</code>, and <code>preInd</code>.
</li>
<li>
July 20, 2007 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-100,-120},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-120},{100,100}})));
end PressureIndependent;
