within IDEAS.Thermal.Components.Examples;
model MixingVolume "Test the mixing volume component"

extends Modelica.Icons.Example;

  parameter Thermal.Data.Interfaces.Medium medium=Data.Media.Water();

  Thermal.Components.BaseClasses.Ambient ambient(
    medium=medium,
    constantAmbientPressure=200000,
    constantAmbientTemperature=283.15)
    annotation (Placement(transformation(extent={{-46,10},{-66,30}})));
  Thermal.Components.BaseClasses.Pump pump(
    medium=medium,
    m=4,
    m_flowNom=0.2)
    annotation (Placement(transformation(extent={{30,10},{50,30}})));
  Thermal.Components.BaseClasses.Ambient ambient1(
    medium=medium,
    constantAmbientPressure=600000,
    constantAmbientTemperature=313.15)
    annotation (Placement(transformation(extent={{76,10},{96,30}})));
  Thermal.Components.BaseClasses.MixingVolume mixingVolume(
    medium=medium,
    nbrPorts=3,
    m=10) annotation (Placement(transformation(extent={{-14,42},{6,62}})));
  Thermal.Components.BaseClasses.Ambient ambient2(
    medium=medium,
    constantAmbientPressure=1000000,
    constantAmbientTemperature=313.15)
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Thermal.Components.BaseClasses.Pump pump1(
    medium=medium,
    m=4,
    useInput=true,
    m_flowNom=0.5)
    annotation (Placement(transformation(extent={{-24,-18},{-4,2}})));
  Modelica.Blocks.Sources.Step step(height=0.4, startTime=1000)
    annotation (Placement(transformation(extent={{-92,-14},{-72,6}})));
equation
  connect(ambient1.flowPort,pump. flowPort_b) annotation (Line(
      points={{76,20},{50,20}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(ambient.flowPort, mixingVolume.flowPorts[1]) annotation (Line(
      points={{-46,20},{-10,20},{-10,42},{-4,42},{-4,41.3333}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(mixingVolume.flowPorts[2], pump.flowPort_a) annotation (Line(
      points={{-4,42},{2,42},{2,20},{30,20}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(ambient2.flowPort, pump1.flowPort_a) annotation (Line(
      points={{-20,-40},{-36,-40},{-36,-8},{-24,-8}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(pump1.flowPort_b, mixingVolume.flowPorts[3]) annotation (Line(
      points={{-4,-8},{-4,42.6667}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(step.y, pump1.m_flowSet) annotation (Line(
      points={{-71,-4},{-42,-4},{-42,2},{-14,2}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics), experiment(StopTime=3600));
end MixingVolume;
