within Annex60.Fluid.Actuators.Valves.Examples;
model TwoWayValvePressureIndependent2
  "Two way valves with pressure independent opening characteristic"
  extends Modelica.Icons.Example;
  package Medium = Annex60.Media.Water;
    Modelica.Blocks.Sources.Ramp y(
    duration=1,
    height=0,
    offset=0.8) "Control signal"
                 annotation (Placement(transformation(extent={{-60,70},{-40,90}})));

  Sources.MassFlowSource_T souValInd(
    redeclare package Medium = Medium,
    T=293.15,
    nPorts=1,
    use_m_flow_in=true) "Boundary condition for flow source"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Annex60.Fluid.Sources.Boundary_pT sin(             redeclare package Medium
      = Medium,
    p(displayUnit="Pa") = 3E5,
    T=293.15,
    nPorts=3) "Boundary condition for flow sink"    annotation (Placement(
        transformation(extent={{72,-10},{52,10}})));

  TwoWayPressureIndependent valInd(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    CvData=Annex60.Fluid.Types.CvTypes.OpPoint,
    filteredOpening=false,
    l=0.05,
    dpFixed_nominal=0,
    dpValve_nominal=10000,
    l2=0.1,
    from_dp=false) "Pressure independent valve"
             annotation (Placement(transformation(extent={{-10,30},{10,50}})));
    Modelica.Blocks.Sources.Ramp dp(
    duration=1,
    startTime=1,
    height=-1,
    offset=2) "Pressure ramp"
                 annotation (Placement(transformation(extent={{-100,-2},{-80,18}})));
  TwoWayPressureIndependent valIndDpFix(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    CvData=Annex60.Fluid.Types.CvTypes.OpPoint,
    filteredOpening=false,
    l=0.05,
    dpFixed_nominal=5000,
    dpValve_nominal=10000,
    l2=0.1,
    from_dp=false) "Pressure independent valve using dp_Fixed_nominal"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  TwoWayPressureIndependent valIndFromMflow(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    CvData=Annex60.Fluid.Types.CvTypes.OpPoint,
    filteredOpening=false,
    l=0.05,
    from_dp=false,
    dpFixed_nominal=0,
    dpValve_nominal=10000,
    l2=0.1) "Pressure independent valve using from_dp = false"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Sources.MassFlowSource_T souValIndDpFix(
    redeclare package Medium = Medium,
    T=293.15,
    nPorts=1,
    use_m_flow_in=true) "Boundary condition for flow source"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Sources.MassFlowSource_T souValIndFromMflow(
    redeclare package Medium = Medium,
    T=293.15,
    nPorts=1,
    use_m_flow_in=true) "Boundary condition for flow source"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
equation
  connect(valInd.y, y.y) annotation (Line(
      points={{0,52},{0,66},{-20,66},{-20,80},{-39,80}},
      color={0,0,127}));
  connect(souValInd.ports[1], valInd.port_a)
    annotation (Line(points={{-40,40},{-40,40},{-10,40}}, color={0,127,255}));
  connect(valInd.port_b, sin.ports[1]) annotation (Line(
      points={{10,40},{32,40},{32,2.66667},{52,2.66667}},
      color={0,127,255}));
  connect(valIndDpFix.port_b, sin.ports[2]) annotation (Line(
      points={{10,0},{32,0},{32,-2.22045e-16},{52,-2.22045e-16}},
      color={0,127,255}));
  connect(valIndFromMflow.port_b, sin.ports[3]) annotation (Line(
      points={{10,-40},{32,-40},{32,-2.66667},{52,-2.66667}},
      color={0,127,255}));
  connect(y.y, valIndDpFix.y) annotation (Line(
      points={{-39,80},{-20,80},{-20,20},{0,20},{0,12}},
      color={0,0,127}));
  connect(y.y, valIndFromMflow.y) annotation (Line(
      points={{-39,80},{-20,80},{-20,-20},{0,-20},{0,-28}},
      color={0,0,127}));
  connect(dp.y, souValInd.m_flow_in)
    annotation (Line(points={{-79,8},{-70,8},{-70,48},{-60,48}},
                                                        color={0,0,127}));
  connect(dp.y, souValIndDpFix.m_flow_in)
    annotation (Line(points={{-79,8},{-60,8}}, color={0,0,127}));
  connect(souValIndFromMflow.ports[1], valIndFromMflow.port_a) annotation (Line(
        points={{-40,-40},{-10,-40}},           color={0,127,255}));
  connect(souValIndDpFix.ports[1], valIndDpFix.port_a)
    annotation (Line(points={{-40,0},{-40,0},{-10,0}}, color={0,127,255}));
  connect(souValIndFromMflow.m_flow_in, dp.y)
    annotation (Line(points={{-60,-32},{-60,-32},{-62,-32},{-70,-32},{-70,8},{
          -79,8}},                                       color={0,0,127}));
    annotation (experiment(StopTime=2),
__Dymola_Commands(file=
          "modelica://Annex60/Resources/Scripts/Dymola/Fluid/Actuators/Valves/Examples/TwoWayValvePressureIndependent2.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>Test model for pressure independent valves using a prescribed mass flow rate. Note that the leakage at full mass flow rate (<code>l2</code>) has been set to a large value for better visualization of the valve characteristics. To use common values, use the default values. </p>
<p>The parameter <code>filterOpening</code> is set to <code>false</code>, as this model is used to plot the flow at different opening signals without taking into account the travel time of the actuator. </p>
</html>", revisions="<html>
<ul>
<li>
January 8, 2016 by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics={Text(
          extent={{14,84},{36,64}},
          lineColor={238,46,47},
          horizontalAlignment=TextAlignment.Left,
          textString="fixme:
I don't understand this test.
You have a ramp dp.y, which says \"Pressure ramp\", 
but then you use it to set the mass flow rate
of the mass flow sources?
What do you want to test with this unit test?")}));
end TwoWayValvePressureIndependent2;
