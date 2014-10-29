within IDEAS.Fluid.Valves.Examples;
model Thermostatic3WayValveExample2 "Example of a thermostatic three way valve"
  extends Modelica.Icons.Example;
  Thermostatic3WayValve thermostatic3WayValve(redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal,
    dynamicValve=false)
    annotation (Placement(transformation(extent={{-10,32},{10,52}})));
  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;

  parameter SI.MassFlowRate m_flow_nominal=2 "Nominal mass flow rate";
  Movers.Pump pump(redeclare package Medium = Medium, m_flow_nominal=
        m_flow_nominal,
    useInput=true)
    annotation (Placement(transformation(extent={{20,32},{40,52}})));
  Sources.Boundary_pT hotSou(
    redeclare package Medium = Medium,
    p=100000,
    T=333.15, nPorts=1,
    use_T_in=true)      annotation (Placement(transformation(extent={{-74,32},{-54,
            52}})));

  Sensors.TemperatureTwoPort T_in(redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{46,36},{58,48}})));
  inner Modelica.Fluid.System system(
    p_ambient=300000,
    T_ambient=313.15)
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    height=30,
    duration=10,
    offset=283.15)
    annotation (Placement(transformation(extent={{-110,36},{-90,56}})));
  Sources.Boundary_pT hotSou1(
    redeclare package Medium = Medium,
    p=100000,
    T=333.15,
    use_T_in=true,
    nPorts=2)           annotation (Placement(transformation(extent={{-78,-6},{-58,
            14}})));
  Modelica.Blocks.Sources.Constant
                               ramp3(k=303.15)
    annotation (Placement(transformation(extent={{-112,-2},{-92,18}})));
  Modelica.Blocks.Sources.Constant
                               ramp4(k=1)
    annotation (Placement(transformation(extent={{62,60},{42,80}})));
  Modelica.Blocks.Sources.Constant
                               ramp5(k=293.15)
    annotation (Placement(transformation(extent={{-26,58},{-6,78}})));
equation

  connect(thermostatic3WayValve.port_b, pump.port_a) annotation (Line(
      points={{10,42},{20,42}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hotSou.ports[1], thermostatic3WayValve.port_a1) annotation (Line(
      points={{-54,42},{-10,42}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pump.port_b, T_in.port_a) annotation (Line(
      points={{40,42},{46,42}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(ramp3.y, hotSou1.T_in) annotation (Line(
      points={{-91,8},{-80,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp4.y, pump.m_flowSet) annotation (Line(
      points={{41,70},{30,70},{30,52.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hotSou1.ports[1], thermostatic3WayValve.port_a2) annotation (Line(
      points={{-58,6},{0,6},{0,32}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(T_in.port_b, hotSou1.ports[2]) annotation (Line(
      points={{58,42},{68,42},{68,2},{-58,2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(ramp5.y, thermostatic3WayValve.TMixedSet) annotation (Line(
      points={{-5,68},{0,68},{0,52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp1.y, hotSou.T_in) annotation (Line(
      points={{-89,46},{-76,46}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                         graphics), Documentation(revisions="<html>
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
    experiment(StopTime=10000),
    __Dymola_experimentSetupOutput);
end Thermostatic3WayValveExample2;
