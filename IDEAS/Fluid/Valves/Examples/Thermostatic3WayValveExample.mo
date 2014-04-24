within IDEAS.Fluid.Valves.Examples;
model Thermostatic3WayValveExample "Example of a thermostatic three way valve"
  extends Modelica.Icons.Example;
  Thermostatic3WayValve thermostatic3WayValve(redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-10,32},{10,52}})));
  MixingVolumes.MixingVolume vol(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    V=1,
    nPorts=2) annotation (Placement(transformation(extent={{62,42},{82,62}})));
  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;

  parameter SI.MassFlowRate m_flow_nominal=1 "Nominal mass flow rate";
  Movers.Pump pump(redeclare package Medium = Medium, m_flow_nominal=
        m_flow_nominal)
    annotation (Placement(transformation(extent={{18,32},{38,52}})));
  Sources.Boundary_pT hotSou(
    redeclare package Medium = Medium,
    nPorts=2,
    p=100000,
    T=333.15) annotation (Placement(transformation(extent={{-74,30},{-54,50}})));
  Modelica.Blocks.Sources.Constant const(k=273.15 + 50)
    annotation (Placement(transformation(extent={{-44,70},{-24,90}})));
  Sensors.TemperatureTwoPort T_out(redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{62,10},{46,26}})));
  Sensors.TemperatureTwoPort T_in(redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{44,36},{56,48}})));
  Thermostatic3WayValve thermostatic3WayValve1(
                                              redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-10,-74},{10,-54}})));
  MixingVolumes.MixingVolume vol1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    V=1,
    nPorts=2) annotation (Placement(transformation(extent={{62,-64},{82,-44}})));
  Movers.Pump pump1(
                   redeclare package Medium = Medium, m_flow_nominal=
        m_flow_nominal)
    annotation (Placement(transformation(extent={{18,-74},{38,-54}})));
  Sources.Boundary_pT coldSou(
    redeclare package Medium = Medium,
    nPorts=2,
    p=100000,
    T=274.15)
    annotation (Placement(transformation(extent={{-70,-76},{-50,-56}})));
  Modelica.Blocks.Sources.Constant const1(k=273.15 + 10)
    annotation (Placement(transformation(extent={{-44,-36},{-24,-16}})));
  Sensors.TemperatureTwoPort T_out1(redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{62,-96},{46,-80}})));
  Sensors.TemperatureTwoPort T_in1(redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{44,-70},{56,-58}})));
  inner Modelica.Fluid.System system(
    p_ambient=300000,
    T_ambient=313.15)
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
equation
  connect(const.y, thermostatic3WayValve.TMixedSet) annotation (Line(
      points={{-23,80},{-10,80},{-10,52},{0,52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(thermostatic3WayValve.port_b, pump.port_a) annotation (Line(
      points={{10,42},{18,42}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hotSou.ports[1], thermostatic3WayValve.port_a1) annotation (Line(
      points={{-54,42},{-10,42}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(thermostatic3WayValve.port_a2, hotSou.ports[2]) annotation (Line(
      points={{0,32},{0,18},{-48,18},{-48,38},{-54,38}},
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
  connect(const1.y, thermostatic3WayValve1.TMixedSet) annotation (Line(
      points={{-23,-26},{-10,-26},{-10,-54},{0,-54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(thermostatic3WayValve1.port_b, pump1.port_a) annotation (Line(
      points={{10,-64},{18,-64}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(coldSou.ports[1], thermostatic3WayValve1.port_a1) annotation (Line(
      points={{-50,-64},{-10,-64}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(thermostatic3WayValve1.port_a2, coldSou.ports[2]) annotation (Line(
      points={{0,-74},{0,-88},{-40,-88},{-40,-68},{-50,-68}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol1.ports[1], T_out1.port_a) annotation (Line(
      points={{70,-64},{70,-88},{62,-88}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(T_out1.port_b, thermostatic3WayValve1.port_a2) annotation (Line(
      points={{46,-88},{0,-88},{0,-74}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pump1.port_b, T_in1.port_a) annotation (Line(
      points={{38,-64},{44,-64}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(T_in1.port_b, vol1.ports[2]) annotation (Line(
      points={{56,-64},{74,-64}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                         graphics={Text(
          extent={{-94,102},{-56,82}},
          lineColor={100,100,100},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="Correct use of valve"), Text(
          extent={{-92,12},{6,-26}},
          lineColor={100,100,100},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="Incorrect use of valve (cold and hot legs are interverted)")}),
                                    Documentation(revisions="<html>
<ul>
<li>
March 2014 by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(StopTime=10000),
    __Dymola_experimentSetupOutput);
end Thermostatic3WayValveExample;
