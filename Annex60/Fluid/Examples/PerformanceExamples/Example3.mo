within Annex60.Fluid.Examples.PerformanceExamples;
model Example3
  extends Modelica.Icons.Example;

  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate";
  parameter Modelica.SIunits.Pressure dp_nominal=1
    "Pressure drop at nominal mass flow rate";
  Movers.FlowControlled_m_flow pump(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    filteredSpeed=false,
    allowFlowReversal=false) "Pump model with unidirectional flow"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Sources.Boundary_pT               bou(
    redeclare package Medium = Medium,
    nPorts=1) "Boundary for pressure boundary condition"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-80,-10})));
  Modelica.Blocks.Sources.Pulse pulse(period=1) "Pulse input"
    annotation (Placement(transformation(extent={{-100,14},{-80,34}})));

  FixedResistances.FixedResistanceDpM[nRes.k] res(
    redeclare each package Medium = Medium,
    each m_flow_nominal=m_flow_nominal,
    each from_dp=from_dp.k,
    each allowFlowReversal=false,
    dp_nominal={dp_nominal*(1 + mod(i, 3)) + (if mergeDp.k then 0 else
        dp_nominal) for i in 1:nRes.k})
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Modelica.Blocks.Sources.BooleanConstant mergeDp(k=true)
    annotation (Placement(transformation(extent={{-60,-42},{-40,-22}})));
  Modelica.Blocks.Sources.BooleanConstant from_dp(k=true)
    annotation (Placement(transformation(extent={{-20,-42},{0,-22}})));
  FixedResistances.FixedResistanceDpM[nRes.k] res1(
    redeclare package Medium = Medium,
    each m_flow_nominal=m_flow_nominal,
    each from_dp=from_dp.k,
    each allowFlowReversal=false,
    each dp_nominal=if mergeDp.k then 0 else dp_nominal)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Blocks.Sources.IntegerConstant nRes(k=6)
    "Number of parallel branches"
    annotation (Placement(transformation(extent={{20,-42},{40,-22}})));
equation
  connect(pump.port_a, bou.ports[1]) annotation (Line(
      points={{-60,0},{-80,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pulse.y, pump.m_flow_in) annotation (Line(
      points={{-79,24},{-50.2,24},{-50.2,12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(res.port_b, res1.port_a) annotation (Line(
      points={{0,0},{20,0}},
      color={0,127,255},
      smooth=Smooth.None));
  for i in 1:nRes.k loop
    connect(res[i].port_a, pump.port_b) annotation (Line(
      points={{-20,0},{-40,0}},
      color={0,127,255},
      smooth=Smooth.None));
    connect(res1[i].port_b, pump.port_a) annotation (Line(
      points={{40,0},{50,0},{50,20},{-60,20},{-60,0}},
      color={0,127,255},
      smooth=Smooth.None));
  end for;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -60},{60,40}}),    graphics),
    experiment(StopTime=1000),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=
            false)),
    Documentation(revisions="<html>
<ul>
<li>
April 17, 2015, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This example demonstrates the importance of merging 
pressure drop components that are connected in series, 
into one pressure drop component. 
Parameter <code>mergeDp.k</code> can be used to merge two components 
that are connected in series. 
Parameter <code>from_dp</code> also has an influence of the computational speed. 
</p>
<p>
See paper for results and a discussion.
</p>
</html>"),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/Examples/PerformanceExamples/Example3.mos"
        "Simulate and plot"));
end Example3;
