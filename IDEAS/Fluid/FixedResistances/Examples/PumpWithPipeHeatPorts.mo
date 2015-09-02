within IDEAS.Fluid.FixedResistances.Examples;
model PumpWithPipeHeatPorts "Example of Pipe_heatPort usage"
  import IDEAS;
  extends Modelica.Icons.Example;

  IDEAS.Fluid.Movers.Pump pump(redeclare package Medium = Medium, m_flow_nominal=
       1,
    useInput=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
          annotation (Placement(transformation(extent={{-52,-12},{-32,8}})));
  IDEAS.Fluid.Sources.Boundary_pT bou(nPorts=1, redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-100,-12},{-80,8}})));
//   replaceable package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater
//     annotation (__Dymola_choicesAllMatching=true);
   package Medium =
      Modelica.Media.Water.ConstantPropertyLiquidWater
    annotation (__Dymola_choicesAllMatching=true);

  inner Modelica.Fluid.System system(
    p_ambient=300000,
    T_ambient=313.15)
    annotation (Placement(transformation(extent={{-90,-80},{-70,-60}})));
  Modelica.Blocks.Sources.Sine sine(freqHz=0.001)
    annotation (Placement(transformation(extent={{-80,26},{-60,46}})));
  IDEAS.Fluid.FixedResistances.Pipe_HeatPort pipe_HeatPort(redeclare package
      Medium = Medium, m_flow_nominal=1)
    annotation (Placement(transformation(extent={{-14,-12},{6,8}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature
    annotation (Placement(transformation(extent={{-38,68},{-18,88}})));
  Modelica.Blocks.Sources.Sine sine1(
    freqHz=0.001,
    amplitude=10,
    offset=293.15,
    startTime=0)
    annotation (Placement(transformation(extent={{-80,68},{-60,88}})));
  Modelica.Fluid.Sensors.TemperatureTwoPort temperature(redeclare package
      Medium = Medium)
    annotation (Placement(transformation(extent={{20,-12},{40,8}})));
  IDEAS.Fluid.FixedResistances.Pipe_HeatPort pipe_HeatPort1(
                                                           redeclare package
      Medium = Medium, m_flow_nominal=1)
    annotation (Placement(transformation(extent={{64,-12},{84,8}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature1
    annotation (Placement(transformation(extent={{50,66},{70,86}})));
  Modelica.Fluid.Sensors.TemperatureTwoPort temperature1(
                                                        redeclare package
      Medium = Medium)
    annotation (Placement(transformation(extent={{42,-72},{22,-52}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T=60, y_start=273.15 + 30,
    initType=Modelica.Blocks.Types.Init.InitialState)
    annotation (Placement(transformation(extent={{18,66},{38,86}})));
  Modelica.Blocks.Sources.Step step(
    height=-10,
    startTime=5*3600,
    offset=273.15 + 30)
    annotation (Placement(transformation(extent={{38,34},{18,54}})));
equation
  connect(bou.ports[1], pump.port_a) annotation (Line(
      points={{-80,-2},{-52,-2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sine.y, pump.m_flowSet) annotation (Line(
      points={{-59,36},{-42,36},{-42,8.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pump.port_b, pipe_HeatPort.port_a) annotation (Line(
      points={{-32,-2},{-14,-2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(prescribedTemperature.port, pipe_HeatPort.heatPort) annotation (Line(
      points={{-18,78},{-4,78},{-4,8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sine1.y, prescribedTemperature.T) annotation (Line(
      points={{-59,78},{-40,78}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pipe_HeatPort.port_b, temperature.port_a) annotation (Line(
      points={{6,-2},{20,-2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(temperature.port_b, pipe_HeatPort1.port_a) annotation (Line(
      points={{40,-2},{64,-2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(prescribedTemperature1.port, pipe_HeatPort1.heatPort) annotation (
      Line(
      points={{70,76},{74,76},{74,8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pipe_HeatPort1.port_b, temperature1.port_a) annotation (Line(
      points={{84,-2},{94,-2},{94,-62},{42,-62}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(temperature1.port_b, pump.port_a) annotation (Line(
      points={{22,-62},{-52,-62},{-52,-2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(prescribedTemperature1.T, firstOrder.y) annotation (Line(
      points={{48,76},{39,76}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(step.y, firstOrder.u) annotation (Line(
      points={{17,44},{12,44},{12,76},{16,76}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    experiment(StopTime=10000),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end PumpWithPipeHeatPorts;
