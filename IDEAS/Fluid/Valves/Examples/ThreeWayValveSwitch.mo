within IDEAS.Fluid.Valves.Examples;
model ThreeWayValveSwitch "Test the new component ThreeWayValveSwitch"
  import IDEAS;
  extends Modelica.Icons.Example;
  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  Fluid.Movers.Pump pumpEmission(
    redeclare package Medium = Medium,
    m=0.1,
    m_flow_nominal=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{58,0},{78,20}})));
  Fluid.FixedResistances.Pipe_HeatPort pipe_HeatPort(m=5, redeclare package
      Medium =                                                                       Medium,
    m_flow_nominal=1)                                                                        annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={-48,-12})));
  Modelica.Blocks.Sources.Pulse pulse1(period=10)
    annotation (Placement(transformation(extent={{-52,32},{-32,52}})));
  Modelica.Blocks.Math.RealToBoolean realToBoolean(threshold=0.5)
    annotation (Placement(transformation(extent={{-12,34},{2,48}})));
  IDEAS.Fluid.Valves.ThreeWayValveSwitch threeWayValveSwitch(redeclare package
      Medium =                                                                          Medium,
      m_flow_nominal=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{6,0},{26,20}})));
  IDEAS.Fluid.Sources.Boundary_pT bou(nPorts=3,          redeclare package
      Medium =                                                                      Medium,
    T=293.15)
    annotation (Placement(transformation(extent={{-68,-70},{-48,-50}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature
    annotation (Placement(transformation(extent={{-86,-22},{-66,-2}})));
  Modelica.Blocks.Sources.Constant pulse2(k=273.15 + 40)
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  IDEAS.Fluid.MixingVolumes.MixingVolume vol(nPorts=2, m_flow_nominal=1,redeclare
      package Medium =                                                                             Medium,
    V=0.01,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={90,-26})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort T_mix(redeclare package Medium =
        Medium, m_flow_nominal=1)
    annotation (Placement(transformation(extent={{32,0},{52,20}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort T_leg0(redeclare package Medium =
        Medium, m_flow_nominal=1)
    annotation (Placement(transformation(extent={{-30,0},{-10,20}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort T_leg1(redeclare package Medium =
        Medium, m_flow_nominal=1)
    annotation (Placement(transformation(extent={{-20,-54},{0,-34}})));
  inner Modelica.Fluid.System system(
    p_ambient=300000,
    T_ambient=313.15)
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
equation
  connect(pulse1.y, realToBoolean.u) annotation (Line(
      points={{-31,42},{-22.2,42},{-22.2,41},{-13.4,41}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(threeWayValveSwitch.switch, realToBoolean.y) annotation (Line(
      points={{16,18},{16,41},{2.7,41}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(bou.ports[1], pipe_HeatPort.port_a) annotation (Line(
      points={{-48,-57.3333},{-46,-57.3333},{-46,-22},{-48,-22}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe_HeatPort.heatPort, prescribedTemperature.port) annotation (Line(
      points={{-58,-12},{-66,-12}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pulse2.y, prescribedTemperature.T) annotation (Line(
      points={{-79,30},{-74,30},{-74,6},{-96,6},{-96,-12},{-88,-12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pumpEmission.port_b, vol.ports[1]) annotation (Line(
      points={{78,10},{80,10},{80,-24}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(threeWayValveSwitch.port_b, T_mix.port_a) annotation (Line(
      points={{26,10},{32,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(T_mix.port_b, pumpEmission.port_a) annotation (Line(
      points={{52,10},{58,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe_HeatPort.port_b, T_leg0.port_a) annotation (Line(
      points={{-48,-2},{-48,10},{-30,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(T_leg0.port_b, threeWayValveSwitch.port_a1) annotation (Line(
      points={{-10,10},{6,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(bou.ports[2], T_leg1.port_a) annotation (Line(
      points={{-48,-60},{-32,-60},{-32,-44},{-20,-44}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(T_leg1.port_b, threeWayValveSwitch.port_a2) annotation (Line(
      points={{0,-44},{16,-44},{16,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol.ports[2], bou.ports[3]) annotation (Line(
      points={{80,-28},{80,-62.6667},{-48,-62.6667}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics),
    experiment(StopTime=100),
    __Dymola_experimentSetupOutput);
end ThreeWayValveSwitch;
