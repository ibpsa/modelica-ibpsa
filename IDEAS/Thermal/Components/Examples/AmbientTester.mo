within IDEAS.Thermal.Components.Examples;
model AmbientTester

extends Modelica.Icons.Example;

parameter Thermal.Data.Interfaces.Medium medium=Data.Media.Water();
  Thermal.Components.BaseClasses.Ambient ambient(
    medium=medium,
    constantAmbientPressure=200000,
    constantAmbientTemperature=283.15)
    annotation (Placement(transformation(extent={{-56,0},{-76,20}})));
  IDEAS.Thermal.Components.BaseClasses.Pipe_HeatPort
                                            heatedPipe(medium=medium, m=5)
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Thermal.Components.BaseClasses.Pump pump(
    medium=medium,
    m=4,
    m_flowNom=1)
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Thermal.Components.BaseClasses.Ambient ambient1(
    medium=medium,
    constantAmbientPressure=600000,
    constantAmbientTemperature=313.15)
    annotation (Placement(transformation(extent={{66,0},{86,20}})));
equation
  connect(ambient.flowPort, heatedPipe.flowPort_a) annotation (Line(
      points={{-56,10},{-20,10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(heatedPipe.flowPort_b, pump.flowPort_a) annotation (Line(
      points={{0,10},{20,10}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(ambient1.flowPort, pump.flowPort_b) annotation (Line(
      points={{66,10},{40,10}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Documentation(info="<html>
<p>Simple tester for the IDEAS.Thermal.Components.BaseClasses.Ambient model</p>
</html>"));
end AmbientTester;
