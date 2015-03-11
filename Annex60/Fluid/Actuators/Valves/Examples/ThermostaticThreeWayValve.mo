within Annex60.Fluid.Actuators.Valves.Examples;
model ThermostaticThreeWayValve
  "Thermostatic three way valve with variable sources temperature and pressure."
  extends Modelica.Icons.Example;
  Annex60.Fluid.Actuators.Valves.ThermostaticThreeWayLinear thermoVal(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=6000,
    l={0.001,0.001},
    dynamicBalance=true,
    dynamicValve=true,
    tau=0.5) annotation (Placement(transformation(extent={{8,8},{28,28}})));
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

  Annex60.Fluid.Sensors.TemperatureTwoPort senTem_out(
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
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Annex60.Fluid.Sources.Boundary_pT sou2(
    redeclare package Medium = Medium,
    use_T_in=true,
    nPorts=1,
    p=Medium.p_default,
    use_p_in=true,
    T=333.15)
    annotation (Placement(transformation(extent={{-30,-30},{-10,-10}})));
  Modelica.Blocks.Sources.Constant TSou2(k=303.15)
    annotation (Placement(transformation(extent={{-60,-36},{-40,-16}})));
  Modelica.Blocks.Sources.Constant TSet(k=293.15)
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  Modelica.Blocks.Sources.Ramp     pSou(
    startTime=10,
    duration=20,
    height=-150000,
    offset=0)
    annotation (Placement(transformation(extent={{-94,10},{-74,30}})));
  Annex60.Fluid.Sources.Boundary_pT sink(
    redeclare package Medium = Medium,
    nPorts=1,
    p=Medium.p_default,
    use_p_in=false,
    use_T_in=false,
    T=Medium.T_default + 3)
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  Modelica.Blocks.Math.Add add(k2=2)
    annotation (Placement(transformation(extent={{-56,4},{-44,16}})));
  Modelica.Blocks.Sources.Constant pSou0(k=Medium.p_default)
    annotation (Placement(transformation(extent={{-94,-20},{-74,0}})));
equation

  connect(sou1.ports[1], thermoVal.port_1) annotation (Line(
      points={{-10,18},{8,18}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TSou2.y, sou2.T_in) annotation (Line(
      points={{-39,-26},{-38,-26},{-38,-16},{-32,-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou2.ports[1], thermoVal.port_3) annotation (Line(
      points={{-10,-20},{18,-20},{18,8}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TSou1.y, sou1.T_in) annotation (Line(
      points={{-39,40},{-38,40},{-38,14},{-32,14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(thermoVal.port_2, senTem_out.port_a) annotation (Line(
      points={{28,18},{64,18}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sink.ports[1], senTem_out.port_b) annotation (Line(
      points={{80,-30},{90,-30},{90,18},{76,18}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pSou.y, add.u1) annotation (Line(
      points={{-73,20},{-70,20},{-70,13.6},{-57.2,13.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, sou1.p_in) annotation (Line(
      points={{-43.4,10},{-32,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pSou0.y, add.u2) annotation (Line(
      points={{-73,-10},{-70,-10},{-70,6.4},{-57.2,6.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, sou2.p_in) annotation (Line(
      points={{-43.4,10},{-38,10},{-38,-12},{-32,-12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSet.y, thermoVal.TSet) annotation (Line(
      points={{1,60},{18,60},{18,30}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics),
    Documentation(revisions="<html>
<ul>
<li>
Januari 2014 by Damien Picard:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>Test for the thermostatic three way valve. Variable temperature and variable pressure sources are connected to the legs of the 
thermostatic three way valve. This tries to reach the set point temperature except if there is a flow reversal for which the valve 
opening is fixed to 0.5.</p>
</html>"),
    experiment(StopTime=30),
    __Dymola_experimentSetupOutput,
    __Dymola_Commands(file="Resources/Scripts/Dymola/Fluid/Actuators/Valves/Examples/ThermostaticThreeWayValve.mos"
        "Simulate and plot"));
end ThermostaticThreeWayValve;
