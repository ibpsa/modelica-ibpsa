within IDEAS.Fluid.Valves.Examples;
model Thermostatic3WayValveExample "Example of a thermostatic three way valve"
  extends Modelica.Icons.Example;
  Thermostatic3WayValve thermostatic3WayValve(redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{2,10},{22,30}})));
  MixingVolumes.MixingVolume vol(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    V=1,
    nPorts=2) annotation (Placement(transformation(extent={{64,20},{84,40}})));
  replaceable package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater
    annotation (__Dymola_choicesAllMatching=true);

  parameter SI.MassFlowRate m_flow_nominal=1 "Nominal mass flow rate";
  Movers.Pump pump(redeclare package Medium = Medium, m_flow_nominal=
        m_flow_nominal)
    annotation (Placement(transformation(extent={{34,10},{54,30}})));
  Sources.Boundary_pT bou(
    redeclare package Medium = Medium,
    p=100000,
    T=333.15,
    nPorts=2) annotation (Placement(transformation(extent={{-64,8},{-44,28}})));
  Modelica.Blocks.Sources.Constant const(k=273.15 + 50)
    annotation (Placement(transformation(extent={{-32,48},{-12,68}})));
equation
  connect(pump.port_b, vol.ports[1]) annotation (Line(
      points={{54,20},{72,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(const.y, thermostatic3WayValve.TMixedSet) annotation (Line(
      points={{-11,58},{2,58},{2,30},{12,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(bou.ports[1], thermostatic3WayValve.port_a1) annotation (Line(
      points={{-44,20},{-22,20},{-22,20},{2,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(thermostatic3WayValve.port_b, pump.port_a) annotation (Line(
      points={{22,20},{34,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(thermostatic3WayValve.port_a2, bou.ports[2]) annotation (Line(
      points={{12,10},{12,-2},{-44,-2},{-44,16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol.ports[2], thermostatic3WayValve.port_a2) annotation (Line(
      points={{76,20},{76,-2},{12,-2},{12,10}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                         graphics), Documentation(revisions="<html>
<ul>
<li>
March 2014 by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
end Thermostatic3WayValveExample;
