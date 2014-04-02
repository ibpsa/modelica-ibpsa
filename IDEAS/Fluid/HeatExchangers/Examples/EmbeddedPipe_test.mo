within IDEAS.Fluid.HeatExchangers.Examples;
model EmbeddedPipe_test
  "Testing the floorheating according to Koschenz, par. 4.5.1"

  extends Modelica.Icons.Example;

  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;

  Movers.Pump pump(
    m=4,
    useInput=true,
    redeclare package Medium = Medium,
    m_flow(start=12*24/3600),
    T_start=303.15,
    m_flow_nominal=12*24/3600)
    annotation (Placement(transformation(extent={{-36,-14},{-16,6}})));
  FixedResistances.Pipe_HeatPort                     heatedPipe(
    m=5,
    redeclare package Medium = Medium,
    m_flow_nominal=12*24/3600,
    T_start=303.15,
    dynamicBalance=true)
    annotation (Placement(transformation(extent={{0,6},{20,-16}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TSet
    annotation (Placement(transformation(extent={{-28,-50},{-8,-30}})));
  Modelica.Blocks.Sources.Pulse pulse(
    offset=0,
    startTime=0,
    period=7200)
    annotation (Placement(transformation(extent={{-58,30},{-38,50}})));
  BaseClasses.RadSlaCha_ValidationEmpa radSlaCha_ValidationEmpa
    annotation (Placement(transformation(extent={{-90,-96},{-70,-76}})));
  inner Modelica.Fluid.System system(
    p_ambient=300000,
    T_ambient=313.15)
    annotation (Placement(transformation(extent={{120,-100},{140,-80}})));
  Sources.Boundary_ph bou(nPorts=2, redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{120,-70},{100,-50}})));
  Modelica.Blocks.Sources.Step step(
    height=-10,
    startTime=5*3600,
    offset=273.15 + 30)
    annotation (Placement(transformation(extent={{-66,-14},{-86,6}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T=60, y_start=273.15 + 30)
    annotation (Placement(transformation(extent={{-86,-50},{-66,-30}})));
  Sensors.TemperatureTwoPort TSen_emb_sup(redeclare package Medium = Medium,
      m_flow_nominal=12*24/3600)
    annotation (Placement(transformation(extent={{36,-16},{56,4}})));
  FixedResistances.Pipe_HeatPort                     heatedPipe1(
    m=5,
    redeclare package Medium = Medium,
    m_flow_nominal=12*24/3600,
    T_start=303.15,
    dynamicBalance=true)
    annotation (Placement(transformation(extent={{72,6},{92,-16}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TSet1
    annotation (Placement(transformation(extent={{-28,-76},{-8,-56}})));
  Modelica.Blocks.Sources.Step step1(
    startTime=5*3600,
    offset=273.15 + 30,
    height=10)
    annotation (Placement(transformation(extent={{-8,-100},{-28,-80}})));
equation

  connect(TSet.port, heatedPipe.heatPort) annotation (Line(
      points={{-8,-40},{2,-40},{2,-38},{10,-38},{10,-16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pulse.y, pump.m_flowSet) annotation (Line(
      points={{-37,40},{-26,40},{-26,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pump.port_b, heatedPipe.port_a) annotation (Line(
      points={{-16,-4},{-8,-4},{-8,-5},{0,-5}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(bou.ports[1], pump.port_a) annotation (Line(
      points={{100,-58},{100,-76},{-52,-76},{-52,-4},{-36,-4}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(step.y, firstOrder.u) annotation (Line(
      points={{-87,-4},{-96,-4},{-96,-40},{-88,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(firstOrder.y, TSet.T) annotation (Line(
      points={{-65,-40},{-30,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heatedPipe.port_b, TSen_emb_sup.port_a) annotation (Line(
      points={{20,-5},{26,-5},{26,-6},{36,-6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TSen_emb_sup.port_b, heatedPipe1.port_a) annotation (Line(
      points={{56,-6},{64,-6},{64,-5},{72,-5}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heatedPipe1.port_b, bou.ports[2]) annotation (Line(
      points={{92,-5},{100,-6},{100,-62}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TSet1.T, step1.y) annotation (Line(
      points={{-30,-66},{-42,-66},{-42,-90},{-29,-90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSet1.port, heatedPipe1.heatPort) annotation (Line(
      points={{-8,-66},{42,-66},{42,-62},{82,-62},{82,-16}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{140,100}}),
                      graphics),
    experiment(StopTime=10000),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent={{-100,-100},{140,100}})));
end EmbeddedPipe_test;
