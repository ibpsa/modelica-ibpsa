within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.Examples;
model MassFlowRateMultiplier "Example use of MassFlowRateMultiplier"
  extends Modelica.Icons.Example;
  package Medium = IBPSA.Media.Water;

  IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.MassFlowRateMultiplier
    massFlowRateMultiplier(k=5, redeclare package Medium = Medium)
                                "Mass flow rate multiplier"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Ramp ram_m_flow(
    height=10,
    duration=10,
    offset=0) "Mass flow rate ramp"
    annotation (Placement(transformation(extent={{-100,-2},{-80,18}})));
  Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1) "Mass flow source"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Sources.Boundary_pT sin(          redeclare package Medium = Medium, nPorts=1)
    "Mass flow sink"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={50,0})));
equation
  connect(ram_m_flow.y, sou.m_flow_in)
    annotation (Line(points={{-79,8},{-62,8}}, color={0,0,127}));
  connect(sou.ports[1], massFlowRateMultiplier.port_a)
    annotation (Line(points={{-40,0},{-25,0},{-10,0}}, color={0,127,255}));
  connect(massFlowRateMultiplier.port_b, sin.ports[1])
    annotation (Line(points={{10,0},{25,0},{40,0}}, color={0,127,255}));
  annotation (
    __Dymola_Commands(file=
          "modelica://IBPSA/Resources/Scripts/Dymola/Fluid/HeatExchangers/GroundHeatExchangers/BaseClasses/Examples/MassFlowRateMultiplier.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StartTime=0.0, StopTime=10.0),
    Documentation(info="<html>
<p>
This example demonstrates the evaluation of 
<a href=\"modelica://IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.MassFlowRateMultiplier\">
IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.MassFlowRateMultiplier</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 19, 2018, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end MassFlowRateMultiplier;
