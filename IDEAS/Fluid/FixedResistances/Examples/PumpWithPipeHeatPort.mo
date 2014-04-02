within IDEAS.Fluid.FixedResistances.Examples;
model PumpWithPipeHeatPort "Example of how a pump can be used"
  import IDEAS;
  extends Modelica.Icons.Example;

  IDEAS.Fluid.Movers.Pump pump(redeclare package Medium = Medium, m_flow_nominal=
       1,
    useInput=true)
          annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  IDEAS.Fluid.Sources.Boundary_pT bou(nPorts=1, redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-58,-10},{-38,10}})));
//   replaceable package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater
//     annotation (__Dymola_choicesAllMatching=true);
   replaceable package Medium = IDEAS.Media.Water
    annotation (__Dymola_choicesAllMatching=true);

  inner Modelica.Fluid.System system(
    p_ambient=300000,
    T_ambient=313.15)
    annotation (Placement(transformation(extent={{-90,-80},{-70,-60}})));
  Modelica.Blocks.Sources.Sine sine(freqHz=0.001)
    annotation (Placement(transformation(extent={{-38,28},{-18,48}})));
  IDEAS.Fluid.FixedResistances.Pipe_HeatPort pipe_HeatPort(redeclare package
      Medium = Medium, m_flow_nominal=1)
    annotation (Placement(transformation(extent={{28,-10},{48,10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature
    annotation (Placement(transformation(extent={{4,70},{24,90}})));
  Modelica.Blocks.Sources.Sine sine1(
    freqHz=0.001,
    amplitude=10,
    offset=293.15,
    startTime=0)
    annotation (Placement(transformation(extent={{-38,70},{-18,90}})));
  Modelica.Fluid.Sensors.TemperatureTwoPort temperature(redeclare package
      Medium = Medium)
    annotation (Placement(transformation(extent={{62,-10},{82,10}})));
  IDEAS.Fluid.FixedResistances.Pipe_HeatPort pipe_HeatPort1(
                                                           redeclare package
      Medium = Medium, m_flow_nominal=1)
    annotation (Placement(transformation(extent={{106,-10},{126,10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature1
    annotation (Placement(transformation(extent={{92,68},{112,88}})));
  Modelica.Blocks.Sources.Sine sine2(
    freqHz=0.001,
    startTime=0,
    amplitude=20,
    offset=303.15)
    annotation (Placement(transformation(extent={{60,68},{80,88}})));
  Modelica.Fluid.Sensors.TemperatureTwoPort temperature1(
                                                        redeclare package
      Medium = Medium)
    annotation (Placement(transformation(extent={{84,-70},{64,-50}})));
equation
  connect(bou.ports[1], pump.port_a) annotation (Line(
      points={{-38,0},{-10,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sine.y, pump.m_flowSet) annotation (Line(
      points={{-17,38},{0,38},{0,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pump.port_b, pipe_HeatPort.port_a) annotation (Line(
      points={{10,0},{28,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(prescribedTemperature.port, pipe_HeatPort.heatPort) annotation (Line(
      points={{24,80},{38,80},{38,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sine1.y, prescribedTemperature.T) annotation (Line(
      points={{-17,80},{2,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pipe_HeatPort.port_b, temperature.port_a) annotation (Line(
      points={{48,0},{62,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(temperature.port_b, pipe_HeatPort1.port_a) annotation (Line(
      points={{82,0},{106,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(prescribedTemperature1.T, sine2.y) annotation (Line(
      points={{90,78},{81,78}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedTemperature1.port, pipe_HeatPort1.heatPort) annotation (
      Line(
      points={{112,78},{116,78},{116,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pipe_HeatPort1.port_b, temperature1.port_a) annotation (Line(
      points={{126,0},{148,0},{148,-60},{84,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(temperature1.port_b, pump.port_a) annotation (Line(
      points={{64,-60},{-10,-60},{-10,0}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{160,100}}), graphics),
    experiment(StopTime=10000),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent={{-100,-100},{160,100}})));
end PumpWithPipeHeatPort;
