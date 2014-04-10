within IDEAS.Fluid.FixedResistances.Examples;
model HydraulicCircuit
  "Illustrates use of pumps, Pipes with heat port and AbsolutePressure"

  extends Modelica.Icons.Example;

  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater
    annotation (__Dymola_choicesAllMatching=true);
   parameter SI.MassFlowRate m_flow_nominal = 0.5 "Nominal mass flow rate";

  Fluid.Movers.Pump pump1(
    useInput=true,
    m_flow_nominal=0.5,
    m=0,
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
         annotation (Placement(transformation(extent={{-36,28},{-16,48}})));
  IDEAS.Fluid.FixedResistances.Pipe_HeatPort pipe1(
    m=5,
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal)
          annotation (Placement(transformation(extent={{10,28},{30,48}})));
  Modelica.Blocks.Sources.Sine pulse(
    startTime=200,
    freqHz=1/3600,
    amplitude=1)
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Fluid.Movers.Pump volumeFlow1(
    m_flow_nominal=0.5,
    useInput=true,
    m=0,
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
         annotation (Placement(transformation(extent={{-36,-16},{-16,4}})));
  IDEAS.Fluid.FixedResistances.Pipe_HeatPort pipe2(
    m = 5,
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal)
          annotation (Placement(transformation(extent={{10,4},{30,-16}})));
  Modelica.Blocks.Sources.Pulse pulse1(
    period=1800,
    startTime=3600,
    amplitude=1)
    annotation (Placement(transformation(extent={{-60,6},{-40,26}})));
  IDEAS.Fluid.FixedResistances.Pipe pipe3(
    m=5,
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{52,10},{70,18}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(G=
        20) annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=
        333.15)
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor1(G=
       20) annotation (Placement(transformation(extent={{-8,76},{12,96}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature1(T=
        313.15)
    annotation (Placement(transformation(extent={{-36,76},{-16,96}})));
  Sources.Boundary_pT             bou(nPorts=1, redeclare package Medium =
        Medium,
    p=200000) "Absolute pressure"
    annotation (Placement(transformation(extent={{88,28},{68,48}})));

  inner Modelica.Fluid.System system(p_ambient=101325)
                                   annotation (Placement(transformation(extent={{80,-100},
            {100,-80}},        rotation=0)));
equation
  connect(pump1.port_b, pipe1.port_a) annotation (Line(
      points={{-16,38},{10,38}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(volumeFlow1.port_b, pipe2.port_a) annotation (Line(
      points={{-16,-6},{10,-6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(pipe1.port_b, pipe3.port_a) annotation (Line(
      points={{30,38},{40,38},{40,14},{52,14}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(pipe2.port_b, pipe3.port_a) annotation (Line(
      points={{30,-6},{40,-6},{40,14},{52,14}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(pipe3.port_b, volumeFlow1.port_a) annotation (Line(
      points={{70,14},{74,14},{74,-62},{-76,-62},{-76,-6},{-36,-6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(pipe3.port_b, pump1.port_a) annotation (Line(
      points={{70,14},{74,14},{74,-62},{-76,-62},{-76,38},{-36,38}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(thermalConductor.port_b, pipe2.heatPort) annotation (Line(
      points={{10,-40},{20,-40},{20,-16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fixedTemperature.port, thermalConductor.port_a) annotation (Line(
      points={{-40,-40},{-10,-40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fixedTemperature1.port, thermalConductor1.port_a) annotation (Line(
      points={{-16,86},{-8,86}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalConductor1.port_b, pipe1.heatPort) annotation (Line(
      points={{12,86},{20,86},{20,48}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pulse.y, pump1.m_flowSet) annotation (Line(
      points={{-39,60},{-26,60},{-26,48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pulse1.y, volumeFlow1.m_flowSet) annotation (Line(
      points={{-39,16},{-26,16},{-26,4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(bou.ports[1], pipe1.port_b) annotation (Line(
      points={{68,38},{30,38}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),
            graphics),
    experiment(StopTime=10000),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>This model shows a hydraulic circuit composed of two loops that come together.  As shown, the flowrates in pumps and pipes can be bidirectional.</p>
</html>", revisions="<html>
<ul>
<li>March 2014 by Filip Jorissen:<br/> 
Annex60 compatibility
</li>
</ul>
</html>"));
end HydraulicCircuit;
