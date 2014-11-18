within Annex60.Fluid.Actuators.Valves.Examples;
model Thermostatic3WayValve "Example of a thermostatic three way valve"
  extends Modelica.Icons.Example;
  Annex60.Fluid.Actuators.Valves.ThermostaticThreeWayLinear
    thermostatic3WayValve(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dynamicValve=false,
    dpValve_nominal=6000,
    l={0.05,0.05},
    tau=1)              annotation (Placement(transformation(extent={{8,8},{28,28}})));
  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=2
    "Nominal mass flow rate";
  Annex60.Fluid.Sources.Boundary_pT sou1(
    redeclare package Medium = Medium,
    nPorts=1,
    use_T_in=true,
    use_p_in=true,
    p=100000,
    T=333.15) annotation (Placement(transformation(extent={{-30,28},{-10,8}})));

  Annex60.Fluid.Sensors.TemperatureTwoPort T_out(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    tau=0.01) annotation (Placement(transformation(extent={{64,12},{76,24}})));
  inner Modelica.Fluid.System system(p_ambient=300000, T_ambient=313.15)
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Modelica.Blocks.Sources.Ramp TSou1(
    duration=10,
    height=-30,
    offset=313.15,
    startTime=0)
    annotation (Placement(transformation(extent={{-64,30},{-44,50}})));
  Annex60.Fluid.Sources.Boundary_pT sou2(
    redeclare package Medium = Medium,
    use_T_in=true,
    nPorts=1,
    p=Medium.p_default,
    use_p_in=true,
    T=333.15)
    annotation (Placement(transformation(extent={{-30,-30},{-10,-10}})));
  Modelica.Blocks.Sources.Constant TSou2(k=303.15)
    annotation (Placement(transformation(extent={{-64,-36},{-44,-16}})));
  Modelica.Blocks.Sources.Constant TSet(k=293.15)
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  Modelica.Blocks.Sources.Ramp     pSou(
    height=-1.2,
    duration=20,
    offset=1.2,
    startTime=10)
    annotation (Placement(transformation(extent={{-94,4},{-74,24}})));
  Annex60.Fluid.Sources.Boundary_pT sink(
    redeclare package Medium = Medium,
    nPorts=1,
    p=Medium.p_default,
    use_p_in=false,
    use_T_in=false,
    T=Medium.T_default)
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  Modelica.Blocks.Math.Product product
    annotation (Placement(transformation(extent={{-56,4},{-44,16}})));
  Modelica.Blocks.Sources.Constant pSou_defaut(k=Medium.p_default)
    annotation (Placement(transformation(extent={{-94,-28},{-74,-8}})));
equation

  connect(sou1.ports[1], thermostatic3WayValve.port_1) annotation (Line(
      points={{-10,18},{8,18}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TSou2.y, sou2.T_in) annotation (Line(
      points={{-43,-26},{-38,-26},{-38,-16},{-32,-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou2.ports[1], thermostatic3WayValve.port_3) annotation (Line(
      points={{-10,-20},{18,-20},{18,8}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TSet.y, thermostatic3WayValve.y) annotation (Line(
      points={{1,60},{18,60},{18,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSou1.y, sou1.T_in) annotation (Line(
      points={{-43,40},{-38,40},{-38,14},{-32,14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(thermostatic3WayValve.port_2, T_out.port_a) annotation (Line(
      points={{28,18},{64,18}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sink.ports[1], T_out.port_b) annotation (Line(
      points={{80,-30},{90,-30},{90,18},{76,18}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pSou.y, product.u1) annotation (Line(
      points={{-73,14},{-70,14},{-70,13.6},{-57.2,13.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(product.y, sou1.p_in) annotation (Line(
      points={{-43.4,10},{-32,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pSou_defaut.y, product.u2) annotation (Line(
      points={{-73,-18},{-70,-18},{-70,6.4},{-57.2,6.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(product.y, sou2.p_in) annotation (Line(
      points={{-43.4,10},{-38,10},{-38,-12},{-32,-12}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),
                    graphics),
    Documentation(revisions="<html>
<ul>
<li>
March 2014 by Filip Jorissen:<br/>
First implementation.
</li>
<li>
May 2014 by Filip Jorissen:<br/>
Changed implementation for more flexible 3wayvalve
</li>
</ul>
</html>"),
    experiment(StopTime=30),
    __Dymola_experimentSetupOutput);
end Thermostatic3WayValve;
