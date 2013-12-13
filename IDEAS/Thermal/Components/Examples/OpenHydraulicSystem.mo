within IDEAS.Thermal.Components.Examples;
model OpenHydraulicSystem "Illustrate the use of the ambient model"

  extends Modelica.Icons.Example;

  parameter Thermal.Data.Interfaces.Medium medium=Data.Media.Water();
  Thermal.Components.BaseClasses.Ambient ambient(
    medium=medium,
    constantAmbientPressure=200000,
    constantAmbientTemperature=283.15)
    annotation (Placement(transformation(extent={{-56,0},{-76,20}})));
  BaseClasses.Pipe_Insulated heatedPipe(
    medium=medium,
    m=5,
    UA=10) annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Thermal.Components.BaseClasses.Pump pump(
    medium=medium,
    m=4,
    m_flowNom=0.1)
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Thermal.Components.BaseClasses.Ambient ambient1(
    medium=medium,
    constantAmbientPressure=600000,
    constantAmbientTemperature=313.15)
    annotation (Placement(transformation(extent={{66,0},{86,20}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=
        298.15)
    annotation (Placement(transformation(extent={{-52,-46},{-32,-26}})));
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
  connect(fixedTemperature.port, heatedPipe.heatPort) annotation (Line(
      points={{-32,-36},{-10,-36},{-10,0}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics),
    Documentation(info="<html>
<p>Simple tester for the IDEAS.Thermal.Components.BaseClasses.Ambient model</p>
</html>"),
    experiment(StopTime=3600),
    __Dymola_experimentSetupOutput);
end OpenHydraulicSystem;
