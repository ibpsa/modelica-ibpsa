within IDEAS.Fluid.Movers.Examples;
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
  connect(temperature.port_b, pump.port_a) annotation (Line(
      points={{82,0},{90,0},{90,-70},{-10,-70},{-10,0}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    experiment(StopTime=10000),
    __Dymola_experimentSetupOutput);
end PumpWithPipeHeatPort;
