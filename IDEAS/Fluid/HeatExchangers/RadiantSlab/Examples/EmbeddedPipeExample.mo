within IDEAS.Fluid.HeatExchangers.RadiantSlab.Examples;
model EmbeddedPipeExample
  extends Modelica.Icons.Example;
  replaceable package Medium = IDEAS.Media.Water.Simple;

  IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe embeddedPipe(
    redeclare package Medium = Medium,
    redeclare
      IDEAS.Fluid.HeatExchangers.RadiantSlab.BaseClasses.FH_ValidationEmpa4_6
      RadSlaCha,
    m_flow_nominal=1,
    A_floor=100,
    nParCir=10,
    computeFlowResistance=true)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Sources.MassFlowSource_T boundary(
    nPorts=1,
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    T=273.15 + 30)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=273.15 +
        10)
    annotation (Placement(transformation(extent={{-34,24},{-14,44}})));

  Sources.Boundary_pT bou(nPorts=1, redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  Modelica.Blocks.Sources.Trapezoid trapezoid(
    amplitude=1,
    rising=1000,
    width=1000,
    falling=1000,
    period=5000)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Sensors.TemperatureTwoPort senTem(redeclare package Medium = Medium,
      m_flow_nominal=1)
    annotation (Placement(transformation(extent={{26,-10},{46,10}})));
equation
  connect(boundary.ports[1], embeddedPipe.port_a) annotation (Line(
      points={{-40,0},{-10,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fixedTemperature.port, embeddedPipe.heatPortEmb) annotation (Line(
      points={{-14,34},{0,34},{0,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(trapezoid.y, boundary.m_flow_in) annotation (Line(
      points={{-79,0},{-70,0},{-70,8},{-60,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(embeddedPipe.port_b, senTem.port_a) annotation (Line(
      points={{10,0},{26,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTem.port_b, bou.ports[1]) annotation (Line(
      points={{46,0},{60,0}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    experiment(StopTime=10000),
    __Dymola_experimentSetupOutput);
end EmbeddedPipeExample;
