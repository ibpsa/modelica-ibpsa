within IDEAS.Fluid.Valves.Examples;
model Thermostatic3WayValveExample
  "Example of a thermostatic three way valve"
  extends Modelica.Icons.Example;
  Thermostatic3WayValve thermostatic3WayValve(redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{-10,32},{10,52}})));
  MixingVolumes.MixingVolume vol(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    V=1,
    nPorts=2) annotation (Placement(transformation(extent={{62,42},{82,62}})));
  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;

  parameter SI.MassFlowRate m_flow_nominal=2 "Nominal mass flow rate";
  Movers.Pump pump(redeclare package Medium = Medium, m_flow_nominal=
        m_flow_nominal,
    useInput=true)
    annotation (Placement(transformation(extent={{18,32},{38,52}})));
  Sources.Boundary_pT hotSou(
    redeclare package Medium = Medium,
    p=100000,
    T=333.15, nPorts=2,
    use_T_in=true)      annotation (Placement(transformation(extent={{-74,30},{-54,50}})));

  Sensors.TemperatureTwoPort T_out(redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{62,10},{46,26}})));
  Sensors.TemperatureTwoPort T_in(redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{44,36},{56,48}})));
  inner Modelica.Fluid.System system(
    p_ambient=300000,
    T_ambient=313.15)
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Modelica.Blocks.Sources.Trapezoid
                               ramp(
    offset=1,
    startTime=1000,
    amplitude=-1,
    rising=1000,
    width=1000,
    falling=1000,
    period=5000)
    annotation (Placement(transformation(extent={{62,72},{42,92}})));
  Modelica.Blocks.Sources.Sine sine(
    amplitude=25,
    offset=273.15 + 30,
    freqHz=0.002)
    annotation (Placement(transformation(extent={{-104,50},{-84,70}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    height=-20,
    offset=273.15 + 40,
    duration=1000,
    startTime=5000)
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
equation

  connect(thermostatic3WayValve.port_b, pump.port_a) annotation (Line(
      points={{10,42},{18,42}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hotSou.ports[1], thermostatic3WayValve.port_a1) annotation (Line(
      points={{-54,42},{-10,42}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol.ports[1], T_out.port_a) annotation (Line(
      points={{70,42},{70,18},{62,18}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(T_out.port_b, thermostatic3WayValve.port_a2) annotation (Line(
      points={{46,18},{0,18},{0,32}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pump.port_b, T_in.port_a) annotation (Line(
      points={{38,42},{44,42}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(T_in.port_b, vol.ports[2]) annotation (Line(
      points={{56,42},{74,42}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(ramp.y, pump.m_flowSet) annotation (Line(
      points={{41,82},{28,82},{28,52.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T_out.port_b, hotSou.ports[2]) annotation (Line(
      points={{46,18},{-54,18},{-54,38}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sine.y, hotSou.T_in) annotation (Line(
      points={{-83,60},{-80,60},{-80,44},{-76,44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp1.y, thermostatic3WayValve.TMixedSet) annotation (Line(
      points={{-19,70},{0,70},{0,52}},
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
end Thermostatic3WayValveExample;
