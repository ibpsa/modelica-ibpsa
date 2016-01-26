within Annex60.Fluid.Actuators.Valves.Examples;
model TwoWayValvePressureIndependentFixedResistance
  "Two way valves with pressure independent opening characteristic and fixed resistance"
  extends Modelica.Icons.Example;
  package Medium = Annex60.Media.Water;

  parameter Modelica.SIunits.Pressure dpFixed_nominal=5000
    "Pressure drop of pipe and other resistances that are in series";

    Modelica.Blocks.Sources.Ramp y(
    duration=1,
    height=1,
    offset=0) "Control signal"
                 annotation (Placement(transformation(extent={{-80,70},{-60,90}})));

  Annex60.Fluid.Sources.Boundary_pT sou(             redeclare package Medium
      = Medium,
    use_p_in=true,
    T=293.15,
    nPorts=4) "Boundary condition for flow source"  annotation (Placement(
        transformation(extent={{-70,-10},{-50,10}})));
  Annex60.Fluid.Sources.Boundary_pT sin(             redeclare package Medium
      = Medium,
    p(displayUnit="Pa") = 3E5,
    T=293.15,
    nPorts=4) "Boundary condition for flow sink"    annotation (Placement(
        transformation(extent={{90,-10},{70,10}})));

  TwoWayPressureIndependent valInd_from_dp(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    CvData=Annex60.Fluid.Types.CvTypes.OpPoint,
    filteredOpening=false,
    l=0.05,
    from_dp=true,
    dpFixed_nominal=0,
    dpValve_nominal=10000,
    l2=0.01) "Pressure independent valve"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
    Modelica.Blocks.Sources.Ramp dp(
    duration=1,
    startTime=1,
    height=10000 + 2*dpFixed_nominal,
    offset=303000) "Pressure ramp"
                 annotation (Placement(transformation(extent={{-100,-2},{-80,18}})));
  TwoWayPressureIndependent valIndDpFix_from_dp(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    CvData=Annex60.Fluid.Types.CvTypes.OpPoint,
    filteredOpening=false,
    l=0.05,
    from_dp=true,
    dpValve_nominal=10000,
    l2=0.01,
    dpFixed_nominal=dpFixed_nominal)
    "Pressure independent valve using dp_Fixed_nominal"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  FixedResistances.FixedResistanceDpM res(
    m_flow_nominal=1,
    dp_nominal=dpFixed_nominal,
    redeclare package Medium = Medium) "Fixed flow resistance"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));

  TwoWayPressureIndependent valInd_from_m_flow(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    CvData=Annex60.Fluid.Types.CvTypes.OpPoint,
    filteredOpening=false,
    l=0.05,
    dpFixed_nominal=0,
    dpValve_nominal=10000,
    l2=0.01,
    from_dp=false) "Pressure independent valve"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  TwoWayPressureIndependent valIndDpFix_from_m_flow(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    CvData=Annex60.Fluid.Types.CvTypes.OpPoint,
    filteredOpening=false,
    l=0.05,
    dpValve_nominal=10000,
    l2=0.01,
    dpFixed_nominal=dpFixed_nominal,
    from_dp=false) "Pressure independent valve using dp_Fixed_nominal"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  FixedResistances.FixedResistanceDpM res1(
    m_flow_nominal=1,
    dp_nominal=dpFixed_nominal,
    redeclare package Medium = Medium) "Fixed flow resistance"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
equation
  connect(valInd_from_dp.y, y.y) annotation (Line(points={{30,52},{30,80},{-16,
          80},{-59,80}}, color={0,0,127}));
  connect(dp.y, sou.p_in) annotation (Line(
      points={{-79,8},{-76,8},{-72,8}},
      color={0,0,127}));
  connect(y.y, valIndDpFix_from_dp.y) annotation (Line(points={{-59,80},{-40,80},
          {-40,20},{10,20},{10,12}}, color={0,0,127}));
  connect(valInd_from_dp.port_a, res.port_b)
    annotation (Line(points={{20,40},{10,40},{0,40}}, color={0,127,255}));
  connect(valInd_from_m_flow.y, y.y) annotation (Line(points={{30,-28},{30,-20},
          {-40,-20},{-40,-12},{-40,80},{-59,80}}, color={0,0,127}));
  connect(y.y, valIndDpFix_from_m_flow.y) annotation (Line(points={{-59,80},{
          -40,80},{-40,-60},{10,-60},{10,-68}}, color={0,0,127}));
  connect(valInd_from_m_flow.port_a, res1.port_b)
    annotation (Line(points={{20,-40},{10,-40},{0,-40}}, color={0,127,255}));
  connect(sou.ports[1], res.port_a) annotation (Line(points={{-50,3},{-42,3},{
          -30,3},{-30,40},{-20,40}}, color={0,127,255}));
  connect(sou.ports[2], valIndDpFix_from_dp.port_a) annotation (Line(points={{
          -50,1},{-30,1},{-30,0},{-30,0},{0,0}}, color={0,127,255}));
  connect(sou.ports[3], res1.port_a) annotation (Line(points={{-50,-1},{-30,-1},
          {-30,-40},{-20,-40}}, color={0,127,255}));
  connect(sou.ports[4], valIndDpFix_from_m_flow.port_a) annotation (Line(points=
         {{-50,-3},{-40,-3},{-30,-3},{-30,-80},{0,-80}}, color={0,127,255}));
  connect(valInd_from_dp.port_b, sin.ports[1]) annotation (Line(points={{40,40},
          {60,40},{60,3},{70,3}}, color={0,127,255}));
  connect(valIndDpFix_from_dp.port_b, sin.ports[2])
    annotation (Line(points={{20,0},{70,0},{70,1}}, color={0,127,255}));
  connect(valInd_from_m_flow.port_b, sin.ports[3]) annotation (Line(points={{40,
          -40},{52,-40},{60,-40},{60,-1},{70,-1}}, color={0,127,255}));
  connect(valIndDpFix_from_m_flow.port_b, sin.ports[4]) annotation (Line(points=
         {{20,-80},{50,-80},{60,-80},{60,-3},{70,-3}}, color={0,127,255}));
    annotation (experiment(StopTime=2),
__Dymola_Commands(file=
          "modelica://Annex60/Resources/Scripts/Dymola/Fluid/Actuators/Valves/Examples/TwoWayValvePressureIndependentFixedResistance.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>Test model for pressure independent valves with and without fixed resistance,
and configured to compute flow rate from pressure drop and vice versa.
Note that the leakage at full mass flow rate (<code>l2</code>) has been set to a large value for better visualization of the valve characteristics. To use common values, use the default values. </p>
<p>The parameter <code>filterOpening</code> is set to <code>false</code>, as this model is used to plot the flow at different opening signals without taking into account the travel time of the actuator. </p>
</html>", revisions="<html>
<ul>
<li>
January 7, 2016 by Filip Jorissen:<br/>
Updated example according to new implementation of 
<code>PressureIndependentValve</code>.
</li>
<li>
January 29, 2015 by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})));
end TwoWayValvePressureIndependentFixedResistance;
