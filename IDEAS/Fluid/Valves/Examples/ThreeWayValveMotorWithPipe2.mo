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
  Modelica.Blocks.Sources.Sine     ctrl(
    freqHz=0.001,
    amplitude=1,
    offset=0)
        annotation (Placement(transformation(extent={{-32,58},{-12,78}})));
  Sources.Boundary_pT hot(
    redeclare package Medium = Medium,
    p=100000,
    T=333.15,
    nPorts=2) annotation (Placement(transformation(extent={{78,-10},{58,10}})));
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
    dynamicBalance=false)
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
    freqHz=0.001)
    annotation (Placement(transformation(extent={{-134,24},{-114,44}})));
equation
  connect(pumpFlow1.port_a, temperature.port_b) annotation (Line(
      points={{-62,0},{-44,0}},
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
  connect(temperature.port_a, hot.ports[1]) annotation (Line(
      points={{-24,0},{18,0},{18,2},{58,2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(ctrl.y, pumpFlow1.m_flowSet) annotation (Line(
      points={{-11,68},{0,68},{0,22},{-72,22},{-72,10.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pipe_HeatPort1.port_b, temperature.port_a) annotation (Line(
      points={{-98,-32},{-96,-32},{-96,-52},{-16,-52},{-16,0},{-24,0}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,
            -180},{100,100}}), graphics), Icon(coordinateSystem(extent={{-140,
            -180},{100,100}})));
end ThreeWayValveMotorWithPipe2;
