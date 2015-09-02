within IDEAS.Fluid.HeatExchangers.Examples;
model EmbeddedPipeDp "Testing pressure drop of embeddedpipe"

  extends Modelica.Icons.Example;

  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;

  Movers.Pump pump(
    m=4,
    useInput=true,
    redeclare package Medium = Medium,
    m_flow(start=12*24/3600),
    T_start=303.15,
    m_flow_nominal=0.1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{-36,-14},{-16,6}})));
  Modelica.Blocks.Sources.Pulse pulse(
    period=7200,
    offset=0,
    startTime=0)
    annotation (Placement(transformation(extent={{-88,30},{-68,50}})));
  RadiantSlab.EmbeddedPipe embeddedPipe(
    redeclare package Medium = Medium,
    m_flow_nominal=12*24/3600,
    m_flowMin=0.1,
    A_floor=10,
    computeFlowResistance=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{64,-16},{84,4}})));
  BaseClasses.RadSlaCha_ValidationEmpa radSlaCha_ValidationEmpa
    annotation (Placement(transformation(extent={{-90,-96},{-70,-76}})));
  inner Modelica.Fluid.System system(
    p_ambient=300000,
    T_ambient=313.15)
    annotation (Placement(transformation(extent={{120,-100},{140,-80}})));
  Sources.Boundary_ph bou(nPorts=2, redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{120,-70},{100,-50}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(
                                                   T=60, y_start=1,
    initType=Modelica.Blocks.Types.Init.InitialState)
    annotation (Placement(transformation(extent={{-54,30},{-34,50}})));
equation

  connect(bou.ports[1], pump.port_a) annotation (Line(
      points={{100,-58},{100,-76},{-52,-76},{-52,-4},{-36,-4}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pulse.y, firstOrder1.u) annotation (Line(
      points={{-67,40},{-56,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(firstOrder1.y, pump.m_flowSet) annotation (Line(
      points={{-33,40},{-26,40},{-26,6.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pump.port_b, embeddedPipe.port_a) annotation (Line(
      points={{-16,-4},{24,-4},{24,-6},{64,-6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(bou.ports[2], embeddedPipe.port_b) annotation (Line(
      points={{100,-62},{100,-6},{84,-6}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{140,100}}),
                      graphics),
    experiment(StopTime=10000),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent={{-100,-100},{140,100}})));
end EmbeddedPipeDp;
