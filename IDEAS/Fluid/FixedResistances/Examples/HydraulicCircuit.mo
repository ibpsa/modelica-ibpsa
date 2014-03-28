within IDEAS.Fluid.FixedResistances.Examples;
model HydraulicCircuit
  "Illustrates use of pumps, Pipes with heat port and AbsolutePressure"

  extends Modelica.Icons.Example;

  Fluid.Movers.Pump pump1(
    medium=Thermal.Data.Media.Water(),
    useInput=true,
    m_flowNom=0.5,
    m=0) annotation (Placement(transformation(extent={{-36,28},{-16,48}})));
  IDEAS.Fluid.FixedResistances.Pipe_HeatPort pipe1(medium=Thermal.Data.Media.Water(),
                                                                              m=
       5) annotation (Placement(transformation(extent={{10,28},{30,48}})));
  Modelica.Blocks.Sources.Sine pulse(
    startTime=200,
    freqHz=1/3600,
    amplitude=1)
    annotation (Placement(transformation(extent={{-68,60},{-48,80}})));
  Thermal.Components.BaseClasses.AbsolutePressure absolutePressure(medium=
        Thermal.Data.Media.Water(),
                            p=200000)
    annotation (Placement(transformation(extent={{58,62},{78,82}})));
  Fluid.Movers.Pump volumeFlow1(
    medium=Thermal.Data.Media.Water(),
    m_flowNom=0.5,
    useInput=true,
    m=0) annotation (Placement(transformation(extent={{-36,-16},{-16,4}})));
  IDEAS.Fluid.FixedResistances.Pipe_HeatPort pipe2(medium=Thermal.Data.Media.Water(),
                                                                              m=
       5) annotation (Placement(transformation(extent={{10,-16},{30,4}})));
  Modelica.Blocks.Sources.Pulse pulse1(
    period=1800,
    startTime=3600,
    amplitude=1)
    annotation (Placement(transformation(extent={{-64,2},{-44,22}})));
  IDEAS.Fluid.FixedResistances.Pipe pipe3(medium=Thermal.Data.Media.Water(),
                                                                     m=5)
    annotation (Placement(transformation(extent={{50,4},{70,24}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(G=
        20) annotation (Placement(transformation(extent={{-6,-52},{14,-32}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=
        333.15)
    annotation (Placement(transformation(extent={{-56,-52},{-36,-32}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor1(G=
       20) annotation (Placement(transformation(extent={{16,76},{36,96}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature1(T=
        313.15)
    annotation (Placement(transformation(extent={{-34,76},{-14,96}})));
equation
  connect(pump1.flowPort_b, pipe1.flowPort_a) annotation (Line(
      points={{-16,38},{10,38}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(absolutePressure.flowPort, pipe1.flowPort_b) annotation (Line(
      points={{58,72},{48,72},{48,68},{30,68},{30,38}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(volumeFlow1.flowPort_b, pipe2.flowPort_a) annotation (Line(
      points={{-16,-6},{10,-6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(pipe1.flowPort_b, pipe3.flowPort_a) annotation (Line(
      points={{30,38},{38,38},{38,14},{50,14}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(pipe2.flowPort_b, pipe3.flowPort_a) annotation (Line(
      points={{30,-6},{34,-6},{34,-4},{40,-4},{40,14},{50,14}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(pipe3.flowPort_b, volumeFlow1.flowPort_a) annotation (Line(
      points={{70,14},{74,14},{74,-62},{-76,-62},{-76,-6},{-36,-6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(pipe3.flowPort_b, pump1.flowPort_a) annotation (Line(
      points={{70,14},{74,14},{74,-62},{-76,-62},{-76,38},{-36,38}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(thermalConductor.port_b, pipe2.heatPort) annotation (Line(
      points={{14,-42},{18,-42},{18,4},{20,4}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fixedTemperature.port, thermalConductor.port_a) annotation (Line(
      points={{-36,-42},{-6,-42}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fixedTemperature1.port, thermalConductor1.port_a) annotation (Line(
      points={{-14,86},{16,86}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalConductor1.port_b, pipe1.heatPort) annotation (Line(
      points={{36,86},{44,86},{44,48},{20,48}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pulse.y, pump1.m_flowSet) annotation (Line(
      points={{-47,70},{-26,70},{-26,48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pulse1.y, volumeFlow1.m_flowSet) annotation (Line(
      points={{-43,12},{-38,12},{-38,14},{-26,14},{-26,4}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(graphics),
    experiment(StopTime=10000),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>This model shows a hydraulic circuit composed of two loops that come together.  As shown, the flowrates in pumps and pipes can be bidirectional.</p>
</html>"));
end HydraulicCircuit;
