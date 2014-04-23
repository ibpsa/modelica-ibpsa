within IDEAS.Fluid.Valves.Examples;
model ThreeWayValveMotorWithPipe2
  import IDEAS;
  extends Modelica.Icons.Example;
  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater
    annotation (__Dymola_choicesAllMatching=true);

protected
  IDEAS.Fluid.Movers.Pump pumpFlow1(
    useInput=true,
    dpFix=0,
    m_flow_nominal=1,
    redeclare package Medium = Medium,
    m=1,
    dynamicBalance=true)
             annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-72,0})));
public
  Modelica.Blocks.Sources.Constant flow_pump(k=1)
        annotation (Placement(transformation(extent={{-98,60},{-78,80}})));
  Modelica.Blocks.Sources.Sine     ctrl(freqHz=0.1,
    amplitude=0.5,
    offset=0.5,
    phase=4.7123889803847)
        annotation (Placement(transformation(extent={{-32,58},{-12,78}})));
  IDEAS.Fluid.Valves.ThreeWayValveMotor threeWayValveMotor(m_flow_nominal=1,
      redeclare package Medium = Medium,
    m=0.1)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}})));
  inner Modelica.Fluid.System system(
    p_ambient=300000,
    T_ambient=313.15)
    annotation (Placement(transformation(extent={{100,-140},{120,-120}})));
  Modelica.Fluid.Sensors.TemperatureTwoPort temperature(redeclare package
      Medium = Medium, m_flow_nominal=1)
    annotation (Placement(transformation(extent={{-24,-10},{-44,10}})));
  IDEAS.Fluid.FixedResistances.Pipe_HeatPort pipe_HeatPort1(
                                                           redeclare package
      Medium = Medium, m_flow_nominal=1,
    linearizeFlowResistance=true,
    dynamicBalance=true)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-98,-22})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature
    annotation (Placement(transformation(extent={{-134,-32},{-114,-12}})));
  Modelica.Blocks.Sources.Sine sine1(
    amplitude=10,
    offset=293.15,
    startTime=0,
    freqHz=0.1)
    annotation (Placement(transformation(extent={{-136,24},{-116,44}})));
  IDEAS.Fluid.Valves.ThreeWayValveMotor threeWayValveMotor1(
                                                           m_flow_nominal=1,
      redeclare package Medium = Medium,
    m=0.1)
    annotation (Placement(transformation(extent={{46,-10},{26,10}})));
  IDEAS.Fluid.FixedResistances.Pipe_HeatPort pipe_HeatPort2(
                                                           redeclare package
      Medium = Medium, m_flow_nominal=1,
    linearizeFlowResistance=true,
    dynamicBalance=true)
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=90,
        origin={86,-34})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature1
    annotation (Placement(transformation(extent={{130,-42},{110,-22}})));
public
  Modelica.Blocks.Sources.Constant flow_pump1(k=273.15 + 60)
        annotation (Placement(transformation(extent={{106,-88},{126,-68}})));
  Sources.Boundary_pT hot(
    redeclare package Medium = Medium,
    p=100000,
    T=333.15,
    nPorts=1) annotation (Placement(transformation(extent={{124,-10},{104,10}})));
  IDEAS.Fluid.FixedResistances.Pipe_HeatPort pipe_HeatPort3(
                                                           redeclare package
      Medium = Medium, m_flow_nominal=1,
    linearizeFlowResistance=true,
    dynamicBalance=true)
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=90,
        origin={32,-102})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature2
    annotation (Placement(transformation(extent={{76,-110},{56,-90}})));
public
  Modelica.Blocks.Sources.Constant flow_pump2(k=273.15 + 20)
        annotation (Placement(transformation(extent={{52,-156},{72,-136}})));
equation
  connect(flow_pump.y, pumpFlow1.m_flowSet)
                                         annotation (Line(
      points={{-77,70},{-72,70},{-72,10.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ctrl.y, threeWayValveMotor.ctrl) annotation (Line(
      points={{-11,68},{1,68},{1,9.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pumpFlow1.port_a, temperature.port_b) annotation (Line(
      points={{-62,0},{-44,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(temperature.port_a, threeWayValveMotor.port_b) annotation (Line(
      points={{-24,0},{-10,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe_HeatPort1.port_a, pumpFlow1.port_b) annotation (Line(
      points={{-98,-12},{-98,0},{-82,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe_HeatPort1.heatPort, prescribedTemperature.port) annotation (Line(
      points={{-108,-22},{-114,-22}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sine1.y, prescribedTemperature.T) annotation (Line(
      points={{-115,34},{-108,34},{-108,32},{-112,32},{-112,0},{-134,0},{-136,
          -22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pipe_HeatPort1.port_b, threeWayValveMotor.port_a2) annotation (Line(
      points={{-98,-32},{-98,-58},{0,-58},{0,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(threeWayValveMotor.port_a1, threeWayValveMotor1.port_b) annotation (
      Line(
      points={{10,0},{26,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(ctrl.y, threeWayValveMotor1.ctrl) annotation (Line(
      points={{-11,68},{37,68},{37,9.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(threeWayValveMotor1.port_a1, pipe_HeatPort2.port_b) annotation (Line(
      points={{46,0},{86,0},{86,-24}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe_HeatPort1.port_b, pipe_HeatPort2.port_a) annotation (Line(
      points={{-98,-32},{-98,-80},{86,-80},{86,-44}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(prescribedTemperature1.port, pipe_HeatPort2.heatPort) annotation (
      Line(
      points={{110,-32},{104,-32},{104,-34},{96,-34}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(flow_pump1.y, prescribedTemperature1.T) annotation (Line(
      points={{127,-78},{138,-78},{138,-32},{132,-32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hot.ports[1], threeWayValveMotor1.port_a1) annotation (Line(
      points={{104,0},{46,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe_HeatPort1.port_b, pipe_HeatPort3.port_a) annotation (Line(
      points={{-98,-32},{-98,-144},{32,-144},{32,-112}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe_HeatPort3.port_b, threeWayValveMotor1.port_a2) annotation (Line(
      points={{32,-92},{36,-92},{36,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe_HeatPort3.heatPort, prescribedTemperature2.port) annotation (
      Line(
      points={{42,-102},{50,-102},{50,-100},{56,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedTemperature2.T, flow_pump2.y) annotation (Line(
      points={{78,-100},{78,-146},{73,-146}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,
            -180},{160,100}}), graphics), Icon(coordinateSystem(extent={{-140,
            -180},{160,100}})),
    experiment(StopTime=100),
    __Dymola_experimentSetupOutput);
end ThreeWayValveMotorWithPipe2;
