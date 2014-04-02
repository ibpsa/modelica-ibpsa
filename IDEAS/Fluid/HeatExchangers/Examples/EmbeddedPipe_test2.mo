within IDEAS.Fluid.HeatExchangers.Examples;
model EmbeddedPipe_test2
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
  Modelica.Blocks.Sources.Pulse pulse(
    period=7200,
    offset=0,
    startTime=0)
    annotation (Placement(transformation(extent={{-58,30},{-38,50}})));
  RadiantSlab.EmbeddedPipe embeddedPipe(
    redeclare package Medium = Medium,
    m_flow_nominal=12*24/3600,
    m_flowMin=0.1)
    annotation (Placement(transformation(extent={{64,-16},{84,4}})));
  BaseClasses.RadSlaCha_ValidationEmpa radSlaCha_ValidationEmpa
    annotation (Placement(transformation(extent={{-90,-96},{-70,-76}})));
  inner Modelica.Fluid.System system(
    p_ambient=300000,
    T_ambient=313.15)
    annotation (Placement(transformation(extent={{120,-100},{140,-80}})));
  Sources.Boundary_ph bou(nPorts=2, redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{120,-70},{100,-50}})));
  Sensors.TemperatureTwoPort TSen_emb_sup(redeclare package Medium = Medium,
      m_flow_nominal=12*24/3600)
    annotation (Placement(transformation(extent={{36,-16},{56,4}})));
  Sensors.TemperatureTwoPort TSen_emb_ret(redeclare package Medium = Medium,
      m_flow_nominal=12*24/3600) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={100,-32})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TSet1
    annotation (Placement(transformation(extent={{44,60},{64,80}})));
  Modelica.Blocks.Sources.Step step1(
    height=0,
    offset=273.15 + 10,
    startTime=0)
    annotation (Placement(transformation(extent={{-8,60},{12,80}})));
equation

  connect(pulse.y, pump.m_flowSet) annotation (Line(
      points={{-37,40},{-26,40},{-26,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(bou.ports[1], pump.port_a) annotation (Line(
      points={{100,-58},{100,-76},{-52,-76},{-52,-4},{-36,-4}},
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
  connect(TSet1.port, embeddedPipe.heatPortEmb) annotation (Line(
      points={{64,70},{70,70},{70,68},{74,68},{74,4}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(step1.y, TSet1.T) annotation (Line(
      points={{13,70},{42,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pump.port_b, TSen_emb_sup.port_a) annotation (Line(
      points={{-16,-4},{12,-4},{12,-6},{36,-6}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{140,100}}),
                      graphics),
    experiment(StopTime=10000),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent={{-100,-100},{140,100}})));
end EmbeddedPipe_test2;
