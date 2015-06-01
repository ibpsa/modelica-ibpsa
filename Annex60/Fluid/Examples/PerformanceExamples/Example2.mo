within Annex60.Fluid.Examples.PerformanceExamples;
model Example2
  extends Modelica.Icons.Example;

  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate";
  parameter Modelica.SIunits.Pressure dp_nominal=1
    "Pressure drop at nominal mass flow rate";
  Movers.FlowControlled_dp pump_dp(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    filteredSpeed=false,
    allowFlowReversal=false) "Pump model with unidirectional flow"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Sources.Boundary_pT               bou(
    redeclare package Medium = Medium,
    nPorts=1) "Boundary for pressure boundary condition"
    annotation (Placement(transformation(extent={{-100,10},{-80,-10}})));
  Modelica.Blocks.Sources.Pulse pulse(period=1) "Pulse input"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));

  FixedResistances.FixedResistanceDpM[nRes.k] res(
    redeclare each package Medium = Medium,
    each m_flow_nominal=m_flow_nominal,
    each from_dp=from_dp.k,
    each allowFlowReversal=false,
    dp_nominal={dp_nominal*(1 + mod(i, 3)) for i in 1:nRes.k})
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Modelica.Blocks.Sources.BooleanConstant from_dp(k=true)
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Modelica.Blocks.Sources.IntegerConstant nRes(k=6)
    "Number of parallel branches"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
equation
  connect(pump_dp.port_a, bou.ports[1]) annotation (Line(
      points={{-60,0},{-80,0}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(pump_dp.dp_in, pulse.y) annotation (Line(
      points={{-50.2,12},{-50.2,30},{-79,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(res[1].port_a, pump_dp.port_b) annotation (Line(
      points={{-20,0},{-40,0}},
      color={0,127,255},
      smooth=Smooth.None));
  for i in 1:nRes.k-1 loop
    connect(res[i].port_b, res[i+1].port_a) annotation (Line(
      points={{0,0},{-20,0}},
      color={0,127,255},
      smooth=Smooth.None));
  end for;

  connect(res[nRes.k].port_b, pump_dp.port_a) annotation (Line(
      points={{0,0},{10,0},{10,-18},{-60,-18},{-60,0}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -40},{40,60}}),    graphics),
    experiment(StopTime=1000),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=
            false)),
    Documentation(info="<html>
<p>
This example demonstrates that the use of parameter <code>from_dp</code>
can be important for reducing the size of algebraic loops in hydraulic
circuits with many pressure drop components connected in series and
a pump setting the pressure head.
</p>
<p>
When <code>from_dp=true</code> then we get: <br />

Sizes of nonlinear systems of equations: {7}<br />
Sizes after manipulation of the nonlinear systems: {<b>5</b>}<br />
else<br />
Sizes of nonlinear systems of equations: {7}<br />
Sizes after manipulation of the nonlinear systems: {<b>1</b>}<br />
</p>
<p>
This can have a large impact on computational speed.
</p>
</html>", revisions="<html>
<ul>
<li>
May 20, 2015, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
end Example2;
