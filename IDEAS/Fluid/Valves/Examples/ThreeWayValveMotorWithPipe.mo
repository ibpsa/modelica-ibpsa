within IDEAS.Fluid.Valves.Examples;
model ThreeWayValveMotorWithPipe
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
    offset=0.5)
        annotation (Placement(transformation(extent={{-32,58},{-12,78}})));
  Sources.Boundary_pT hot(
    redeclare package Medium = Medium,
    nPorts=1,
    p=100000,
    T=333.15) annotation (Placement(transformation(extent={{78,-10},{58,10}})));
  IDEAS.Fluid.Valves.ThreeWayValveMotor threeWayValveMotor(m_flow_nominal=1,
      redeclare package Medium = Medium,
    m=0.1)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}})));
  inner Modelica.Fluid.System system(
    p_ambient=300000,
    T_ambient=313.15)
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
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
    annotation (Placement(transformation(extent={{-132,-32},{-112,-12}})));
  Modelica.Blocks.Sources.Sine sine1(
    amplitude=10,
    offset=293.15,
    startTime=0,
    freqHz=0.1)
    annotation (Placement(transformation(extent={{-134,24},{-114,44}})));
  Sources.Boundary_pT bou(
    redeclare package Medium = Medium,
    nPorts=1,
    p=100000,
    T=333.15) annotation (Placement(transformation(extent={{80,-40},{60,-20}})));
equation
  connect(flow_pump.y, pumpFlow1.m_flowSet)
                                         annotation (Line(
      points={{-77,70},{-72,70},{-72,10.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(threeWayValveMotor.port_a1, hot.ports[1]) annotation (Line(
      points={{10,0},{58,0}},
      color={0,127,255},
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
      points={{-108,-22},{-112,-22}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sine1.y, prescribedTemperature.T) annotation (Line(
      points={{-113,34},{-108,34},{-108,32},{-112,32},{-112,0},{-134,0},{-134,
          -22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pipe_HeatPort1.port_b, threeWayValveMotor.port_a2) annotation (Line(
      points={{-98,-32},{-98,-58},{0,-58},{0,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(bou.ports[1], threeWayValveMotor.port_a2) annotation (Line(
      points={{60,-30},{0,-30},{0,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,
            -100},{100,100}}), graphics), Icon(coordinateSystem(extent={{-140,-100},
            {100,100}})));
end ThreeWayValveMotorWithPipe;
