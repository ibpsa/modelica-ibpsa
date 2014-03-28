within IDEAS.Fluid.Valves.Examples;
model ThreeWayValveSwitch "Test the new component ThreeWayValveSwitch"
  import IDEAS;
  extends Modelica.Icons.Example;

  Fluid.Movers.Pump pumpEmission(
    medium=IDEAS.Thermal.Data.Media.Water(),
    m=0.1,
    TInitial=283.15,
    m_flowNom=2) annotation (Placement(transformation(extent={{54,0},{74,20}})));
  Modelica.Blocks.Sources.Pulse pulse(
    period=10,
    offset=0,
    amplitude=1000)
    annotation (Placement(transformation(extent={{-96,18},{-76,38}})));
  Fluid.FixedResistances.Pipe pipe(
    medium=IDEAS.Thermal.Data.Media.Water(),
    m=0.1,
    TInitial=291.15)
    annotation (Placement(transformation(extent={{38,8},{48,12}})));
  Fluid.FixedResistances.Pipe pipeSplit(
    medium=IDEAS.Thermal.Data.Media.Water(),
    m=0.1,
    TInitial=291.15)
    annotation (Placement(transformation(extent={{40,-34},{50,-30}})));
  Fluid.FixedResistances.Pipe pipeBOTTOM(
    medium=IDEAS.Thermal.Data.Media.Water(),
    m=0.1,
    TInitial=291.15)
    annotation (Placement(transformation(extent={{22,-18},{32,-14}})));
  Fluid.FixedResistances.Pipe pipe3(
    medium=IDEAS.Thermal.Data.Media.Water(),
    m=0.1,
    TInitial=291.15)
    annotation (Placement(transformation(extent={{-18,-34},{-8,-30}})));
  Fluid.FixedResistances.Pipe pipeTOP(
    medium=IDEAS.Thermal.Data.Media.Water(),
    m=0.1,
    TInitial=291.15)
    annotation (Placement(transformation(extent={{-16,8},{-6,12}})));
  Fluid.FixedResistances.Pipe_HeatPort pipe_HeatPort(m=5, medium=
        IDEAS.Thermal.Data.Media.Water()) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-46,-12})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Fluid.FixedResistances.Pipe pipe5(
    medium=IDEAS.Thermal.Data.Media.Water(),
    m=100,
    TInitial=291.15)
    annotation (Placement(transformation(extent={{58,-36},{78,-28}})));
  IDEAS.BaseClasses.AbsolutePressure absolutePressure1(p=100000)
    annotation (Placement(transformation(extent={{18,-62},{38,-42}})));
  Modelica.Blocks.Sources.Pulse pulse1(period=10)
    annotation (Placement(transformation(extent={{-52,32},{-32,52}})));
  Modelica.Blocks.Math.RealToBoolean realToBoolean(threshold=0.5)
    annotation (Placement(transformation(extent={{-12,34},{2,48}})));
  IDEAS.Fluid.Valves.ThreeWayValveSwitch threeWayValveSwitch
    annotation (Placement(transformation(extent={{10,0},{30,20}})));
equation
  connect(pipe.flowPort_b, pumpEmission.flowPort_a) annotation (Line(
      points={{48,10},{54,10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pulse.y, prescribedHeatFlow.Q_flow) annotation (Line(
      points={{-75,28},{-70,28},{-70,4},{-92,4},{-92,-10},{-80,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedHeatFlow.port, pipe_HeatPort.heatPort) annotation (Line(
      points={{-60,-10},{-58,-10},{-58,-12},{-56,-12}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pipe5.flowPort_b, pumpEmission.flowPort_b) annotation (Line(
      points={{78,-32},{86,-28},{84,10},{74,10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pipe3.flowPort_a, pipe_HeatPort.flowPort_b) annotation (Line(
      points={{-18,-32},{-48,-32},{-48,-22},{-46,-22}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pipe_HeatPort.flowPort_a, pipeTOP.flowPort_a) annotation (Line(
      points={{-46,-2},{-46,10},{-16,10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pulse1.y, realToBoolean.u) annotation (Line(
      points={{-31,42},{-22.2,42},{-22.2,41},{-13.4,41}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(threeWayValveSwitch.flowPort_option1, pipeBOTTOM.flowPort_a)
    annotation (Line(
      points={{20,0},{20,-16},{22,-16}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(threeWayValveSwitch.flowPort_fixed, pipe.flowPort_a) annotation (Line(
      points={{30,10},{38,10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(threeWayValveSwitch.flowPort_option0, pipeTOP.flowPort_b) annotation (
     Line(
      points={{10,10},{-6,10}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(threeWayValveSwitch.switch, realToBoolean.y) annotation (Line(
      points={{20,18},{18,18},{18,41},{2.7,41}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(absolutePressure1.flowPort, pipe3.flowPort_b) annotation (Line(
      points={{18,-52},{-8,-52},{-8,-32}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pipe3.flowPort_b, pipeSplit.flowPort_a) annotation (Line(
      points={{-8,-32},{40,-32}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pipeBOTTOM.flowPort_b, pipeSplit.flowPort_a) annotation (Line(
      points={{32,-16},{40,-16},{40,-32}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pipeSplit.flowPort_b, pipe5.flowPort_a) annotation (Line(
      points={{50,-32},{58,-32}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (
    Diagram(graphics),
    experiment(StopTime=101),
    __Dymola_experimentSetupOutput);
end ThreeWayValveSwitch;
