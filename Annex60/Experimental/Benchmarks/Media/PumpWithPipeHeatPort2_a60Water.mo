within Annex60.Experimental.Benchmarks.Media;
model PumpWithPipeHeatPort2_a60Water "Example of how a pump can be used"
import Annex60;
extends Modelica.Icons.Example;

Annex60.Fluid.Sources.Boundary_pT bou(          redeclare package Medium =
      Medium, nPorts=1)
  annotation (Placement(transformation(extent={{-58,-10},{-38,10}})));
  //   replaceable package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater
  //     annotation (__Dymola_choicesAllMatching=true);
 package Medium =
    Annex60.Media.Water
  annotation (__Dymola_choicesAllMatching=true);

inner Modelica.Fluid.System system(
  p_ambient=300000,
  T_ambient=313.15)
  annotation (Placement(transformation(extent={{-90,-80},{-70,-60}})));
Modelica.Fluid.Pipes.DynamicPipe             pipe_HeatPort(redeclare package
      Medium=Medium,
  use_HeatTransfer=true,
  length=1,
  diameter=0.2,
    T_start=303.15)
  annotation (Placement(transformation(extent={{28,-10},{48,10}})));
Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
  prescribedTemperature
  annotation (Placement(transformation(extent={{4,70},{24,90}})));
Modelica.Fluid.Sensors.TemperatureTwoPort temperature(redeclare package Medium
      =      Medium)
  annotation (Placement(transformation(extent={{62,-10},{82,10}})));
Modelica.Blocks.Sources.Constant
                              pulse(k=100)
  annotation (Placement(transformation(extent={{-30,16},{-10,36}})));
Modelica.Fluid.Machines.PrescribedPump
                        pumps(
  checkValve=true,
  N_nominal=1200,
  redeclare function flowCharacteristic =
      Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics.quadraticFlow (
        V_flow_nominal={0,0.25,0.5}, head_nominal={100,60,0}),
  use_N_in=true,
  nParallel=1,
  energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
  V(displayUnit="l") = 0.05,
  massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
  redeclare package Medium = Medium)
  annotation (Placement(transformation(extent={{-12,-10},{8,10}},    rotation=
         0)));
Modelica.Blocks.Sources.Constant
                              pulse1(k=290)
  annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
equation
connect(pipe_HeatPort.port_b, temperature.port_a) annotation (Line(
    points={{48,0},{62,0}},
    color={0,127,255},
    smooth=Smooth.None));
connect(prescribedTemperature.port, pipe_HeatPort.heatPorts[1]) annotation (
    Line(
    points={{24,80},{36.55,80},{36.55,4.4}},
    color={191,0,0},
    smooth=Smooth.None));
connect(bou.ports[1], pumps.port_a) annotation (Line(
    points={{-38,0},{-12,0}},
    color={0,127,255},
    smooth=Smooth.None));
connect(pumps.port_b, pipe_HeatPort.port_a) annotation (Line(
    points={{8,0},{28,0}},
    color={0,127,255},
    smooth=Smooth.None));
connect(pulse.y, pumps.N_in) annotation (Line(
    points={{-9,26},{-2,26},{-2,10}},
    color={0,0,127},
    smooth=Smooth.None));
  connect(temperature.port_b, pumps.port_a) annotation (Line(
      points={{82,0},{100,0},{100,-60},{-24,-60},{-24,0},{-12,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pulse1.y, prescribedTemperature.T) annotation (Line(
      points={{-19,80},{2,80}},
      color={0,0,127},
      smooth=Smooth.None));
annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {160,100}}),     graphics),
  experiment(StopTime=10000),
  __Dymola_experimentSetupOutput,
  Icon(coordinateSystem(extent={{-100,-100},{160,100}})));
end PumpWithPipeHeatPort2_a60Water;
