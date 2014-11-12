within IDEAS.Fluid.HeatExchangers.Examples;
model EmbeddedPipe "Testing the floorheating according to Koschenz, par. 4.5.1"

  extends Modelica.Icons.Example;

  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;

  Movers.Pump pump(
    m=4,
    useInput=true,
    redeclare package Medium = Medium,
    m_flow(start=12*24/3600),
    m_flow_nominal=12*24/3600,
    T_start=303.15)
    annotation (Placement(transformation(extent={{-36,-14},{-16,6}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature prescribedTemperature(
      T=293.15) annotation (Placement(transformation(extent={{8,64},{28,84}})));
  FixedResistances.Pipe_HeatPort                     heatedPipe(
    m=5,
    redeclare package Medium = Medium,
    m_flow_nominal=12*24/3600,
    dynamicBalance=false,
    T_start=303.15)
    annotation (Placement(transformation(extent={{0,6},{20,-16}})));
  Modelica.Thermal.HeatTransfer.Components.Convection convection annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={78,46})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TSet
    annotation (Placement(transformation(extent={{-28,-50},{-8,-30}})));
  Modelica.Blocks.Sources.Pulse pulse(
    period=7200,
    offset=0,
    startTime=0)
    annotation (Placement(transformation(extent={{-88,30},{-68,50}})));
  BaseClasses.NakedTabs nakedTabs(radSlaCha=radSlaCha_ValidationEmpa)
    annotation (Placement(transformation(extent={{102,2},{122,22}})));
  RadiantSlab.EmbeddedPipe embeddedPipe(
    redeclare package Medium = Medium,
    m_flow_nominal=12*24/3600,
    m_flowMin=0.1,
    A_floor=1)
    annotation (Placement(transformation(extent={{64,-16},{84,4}})));
  BaseClasses.RadSlaCha_ValidationEmpa radSlaCha_ValidationEmpa
    annotation (Placement(transformation(extent={{-90,-96},{-70,-76}})));
  Modelica.Blocks.Sources.RealExpression convTabs(y=11)
    "\"convection coefficient for the tabs\""
    annotation (Placement(transformation(extent={{28,36},{48,56}})));
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
  Sensors.TemperatureTwoPort TSen_emb_ret(redeclare package Medium = Medium,
      m_flow_nominal=12*24/3600) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={100,-32})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(
                                                   T=60, y_start=1)
    annotation (Placement(transformation(extent={{-54,30},{-34,50}})));
equation

  connect(convection.fluid, prescribedTemperature.port) annotation (Line(
      points={{78,56},{50,56},{50,74},{28,74}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TSet.port, heatedPipe.heatPort) annotation (Line(
      points={{-8,-40},{2,-40},{2,-38},{10,-38},{10,-16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pump.port_b, heatedPipe.port_a) annotation (Line(
      points={{-16,-4},{-8,-4},{-8,-5},{0,-5}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(convection.solid, nakedTabs.port_a) annotation (Line(
      points={{78,36},{78,22},{112,22}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(nakedTabs.port_b, convection.solid) annotation (Line(
      points={{112,2.2},{112,-6},{130,-6},{130,36},{78,36}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(embeddedPipe.heatPortEmb, nakedTabs.portCore) annotation (Line(
      points={{74,4},{74,12},{102,12}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convTabs.y, convection.Gc) annotation (Line(
      points={{49,46},{68,46}},
      color={0,0,127},
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
  connect(TSen_emb_sup.port_b, embeddedPipe.port_a) annotation (Line(
      points={{56,-6},{64,-6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(embeddedPipe.port_b, TSen_emb_ret.port_a) annotation (Line(
      points={{84,-6},{100,-6},{100,-22}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TSen_emb_ret.port_b, bou.ports[2]) annotation (Line(
      points={{100,-42},{100,-62}},
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
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{140,100}}),
                      graphics),
    experiment(StopTime=10000),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent={{-100,-100},{140,100}})));
end EmbeddedPipe;
