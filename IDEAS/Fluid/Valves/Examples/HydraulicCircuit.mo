within IDEAS.Fluid.Valves.Examples;
model HydraulicCircuit
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
        annotation (Placement(transformation(extent={{-98,24},{-78,44}})));
  Modelica.Blocks.Sources.Sine     ctrl(freqHz=0.1,
    amplitude=0.5,
    offset=0.5,
    phase=4.7123889803847)
        annotation (Placement(transformation(extent={{-36,28},{-16,48}})));
  IDEAS.Fluid.Valves.ThreeWayValveMotor threeWayValveMotor(m_flow_nominal=1,
      redeclare package Medium = Medium,
    m=0.1)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}})));
  inner Modelica.Fluid.System system(
    p_ambient=300000,
    T_ambient=313.15)
    annotation (Placement(transformation(extent={{160,40},{180,60}})));
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
    annotation (Placement(transformation(extent={{-152,24},{-132,44}})));
  IDEAS.Fluid.Valves.ThreeWayValveMotor threeWayValveMotor1(
                                                           m_flow_nominal=1,
      redeclare package Medium = Medium,
    m=0.1)
    annotation (Placement(transformation(extent={{46,-10},{26,10}})));
  IDEAS.Fluid.FixedResistances.Pipe_HeatPort boiler(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    linearizeFlowResistance=true,
    dynamicBalance=true) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={86,-34})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature1
    annotation (Placement(transformation(extent={{130,-42},{110,-22}})));
public
  Modelica.Blocks.Sources.Constant flow_pump1(k=273.15 + 60)
        annotation (Placement(transformation(extent={{168,-42},{148,-22}})));
  Sources.Boundary_pT bou(
    redeclare package Medium = Medium,
    nPorts=1,
    p=100000,
    T=333.15) annotation (Placement(transformation(extent={{124,-10},{104,10}})));
  IDEAS.Fluid.FixedResistances.Pipe_HeatPort chiller(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    linearizeFlowResistance=true,
    dynamicBalance=true) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={36,-102})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature2
    annotation (Placement(transformation(extent={{130,-112},{110,-92}})));
public
  Modelica.Blocks.Sources.Constant flow_pump2(k=273.15 + 20)
        annotation (Placement(transformation(extent={{170,-112},{150,-92}})));
protected
  IDEAS.Fluid.Movers.Pump pumpFlow2(
    useInput=true,
    dpFix=0,
    m_flow_nominal=1,
    redeclare package Medium = Medium,
    m=1,
    dynamicBalance=true)
             annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-74,-180})));
public
  Modelica.Blocks.Sources.Constant flow_pump3(
                                             k=1)
        annotation (Placement(transformation(extent={{-102,-156},{-82,-136}})));
  Modelica.Blocks.Sources.Sine     ctrl1(
                                        freqHz=0.1,
    amplitude=0.5,
    offset=0.5,
    phase=4.7123889803847)
        annotation (Placement(transformation(extent={{-48,-154},{-28,-134}})));
  IDEAS.Fluid.Valves.ThreeWayValveMotor threeWayValveMotor2(
                                                           m_flow_nominal=1,
      redeclare package Medium = Medium,
    m=0.1)
    annotation (Placement(transformation(extent={{8,-190},{-12,-170}})));
  Modelica.Fluid.Sensors.TemperatureTwoPort temperature1(
                                                        redeclare package
      Medium = Medium, m_flow_nominal=1)
    annotation (Placement(transformation(extent={{-26,-190},{-46,-170}})));
  IDEAS.Fluid.FixedResistances.Pipe_HeatPort pipe_HeatPort4(
                                                           redeclare package
      Medium = Medium, m_flow_nominal=1,
    linearizeFlowResistance=true,
    dynamicBalance=true)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-100,-202})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature3
    annotation (Placement(transformation(extent={{-136,-212},{-116,-192}})));
  Modelica.Blocks.Sources.Sine sine2(
    amplitude=10,
    offset=293.15,
    startTime=0,
    freqHz=0.1)
    annotation (Placement(transformation(extent={{-138,-156},{-118,-136}})));
  IDEAS.Fluid.Valves.ThreeWayValveMotor threeWayValveMotor3(
                                                           m_flow_nominal=1,
      redeclare package Medium = Medium,
    m=0.1)
    annotation (Placement(transformation(extent={{44,-190},{24,-170}})));
equation
  connect(flow_pump.y, pumpFlow1.m_flowSet)
                                         annotation (Line(
      points={{-77,34},{-72,34},{-72,10.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ctrl.y, threeWayValveMotor.ctrl) annotation (Line(
      points={{-15,38},{1,38},{1,9.6}},
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
      points={{-15,38},{37,38},{37,9.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(threeWayValveMotor1.port_a1, boiler.port_b) annotation (Line(
      points={{46,0},{86,0},{86,-24}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe_HeatPort1.port_b, boiler.port_a) annotation (Line(
      points={{-98,-32},{-98,-80},{86,-80},{86,-44}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(prescribedTemperature1.port, boiler.heatPort) annotation (Line(
      points={{110,-32},{104,-32},{104,-34},{96,-34}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(flow_pump1.y, prescribedTemperature1.T) annotation (Line(
      points={{147,-32},{132,-32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(bou.ports[1], threeWayValveMotor1.port_a1) annotation (Line(
      points={{104,0},{46,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe_HeatPort1.port_b, chiller.port_a) annotation (Line(
      points={{-98,-32},{-98,-120},{36,-120},{36,-112}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(chiller.port_b, threeWayValveMotor1.port_a2) annotation (Line(
      points={{36,-92},{36,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(chiller.heatPort, prescribedTemperature2.port) annotation (Line(
      points={{46,-102},{110,-102}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(flow_pump3.y, pumpFlow2.m_flowSet) annotation (Line(
      points={{-81,-146},{-74,-146},{-74,-169.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ctrl1.y, threeWayValveMotor2.ctrl) annotation (Line(
      points={{-27,-144},{-1,-144},{-1,-170.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pumpFlow2.port_a, temperature1.port_b) annotation (Line(
      points={{-64,-180},{-46,-180}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(temperature1.port_a, threeWayValveMotor2.port_b) annotation (Line(
      points={{-26,-180},{-12,-180}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe_HeatPort4.port_a,pumpFlow2. port_b) annotation (Line(
      points={{-100,-192},{-100,-180},{-84,-180}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe_HeatPort4.heatPort, prescribedTemperature3.port) annotation (
      Line(
      points={{-110,-202},{-116,-202}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pipe_HeatPort4.port_b, threeWayValveMotor2.port_a2) annotation (Line(
      points={{-100,-212},{-100,-218},{-2,-218},{-2,-206},{-2,-206},{-2,-190}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(threeWayValveMotor2.port_a1, threeWayValveMotor3.port_b) annotation (
      Line(
      points={{8,-180},{24,-180}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(ctrl1.y, threeWayValveMotor3.ctrl) annotation (Line(
      points={{-27,-144},{35,-144},{35,-170.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(threeWayValveMotor3.port_a1, boiler.port_b) annotation (Line(
      points={{44,-180},{56,-180},{56,-178},{68,-178},{68,-24},{86,-24}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(threeWayValveMotor3.port_a2, chiller.port_b) annotation (Line(
      points={{34,-190},{34,-202},{62,-202},{62,-92},{36,-92}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe_HeatPort1.port_b, pipe_HeatPort4.port_b) annotation (Line(
      points={{-98,-32},{-100,-32},{-100,-40},{-150,-40},{-150,-212},{-100,-212}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(sine1.y, prescribedTemperature.T) annotation (Line(
      points={{-131,34},{-124,34},{-124,2},{-144,2},{-144,-22},{-136,-22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sine2.y, prescribedTemperature3.T) annotation (Line(
      points={{-117,-146},{-110,-146},{-110,-180},{-138,-180},{-138,-202}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedTemperature2.T, flow_pump2.y) annotation (Line(
      points={{132,-102},{149,-102}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,
            -220},{180,60}}),  graphics), Icon(coordinateSystem(extent={{-160,
            -220},{180,60}})),
    experiment(StopTime=100),
    __Dymola_experimentSetupOutput);
end HydraulicCircuit;
