within IDEAS.Thermal.Components.Examples;
model NakedTabsTester "Testing discretisation of the naked tabs"

extends Modelica.Icons.Example;

  IDEAS.Thermal.Components.Emission.NakedTabs
                                    nakedTabs2(n1=2, n2=2)
    annotation (Placement(transformation(extent={{24,50},{44,70}})));
  IDEAS.Thermal.Components.Emission.NakedTabs
                                    nakedTabs50(n1=50, n2=50)
    annotation (Placement(transformation(extent={{24,4},{44,24}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature
    annotation (Placement(transformation(extent={{-60,22},{-40,42}})));
  Modelica.Blocks.Sources.Step step(
    height=10,
    offset=293.15,
    startTime=1000)
    annotation (Placement(transformation(extent={{-92,22},{-72,42}})));
   Modelica.Thermal.HeatTransfer.Components.Convection convection
     annotation (Placement(transformation(extent={{24,92},{4,72}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature prescribedTemperature1(T=293.15)
              annotation (Placement(transformation(extent={{-38,72},{-18,92}})));
   Modelica.Thermal.HeatTransfer.Components.Convection convection1
     annotation (Placement(transformation(extent={{76,50},{56,30}})));
  IDEAS.Thermal.Components.Emission.BaseClasses.NakedTabsMassiveCore
                                               nakedTabs2Core(n1=2, n2=2)
    annotation (Placement(transformation(extent={{28,-52},{48,-32}})));
  IDEAS.Thermal.Components.Emission.BaseClasses.NakedTabsMassiveCore
                                               nakedTabs50Core(n1=50, n2=50)
    annotation (Placement(transformation(extent={{26,-96},{46,-76}})));
   Modelica.Thermal.HeatTransfer.Components.Convection convection2
     annotation (Placement(transformation(extent={{28,-8},{8,-28}})));
   Modelica.Thermal.HeatTransfer.Components.Convection convection3
     annotation (Placement(transformation(extent={{82,-50},{62,-70}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature prescribedTemperature2(T=293.15)
              annotation (Placement(transformation(extent={{-48,-28},{-28,-8}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(G=1000)
    annotation (Placement(transformation(extent={{-32,22},{-12,42}})));
equation
  convection.Gc = nakedTabs2.FHChars.A_Floor * 11;
  convection1.Gc = nakedTabs2.FHChars.A_Floor * 11;
  convection2.Gc = nakedTabs2.FHChars.A_Floor * 11;
  convection3.Gc = nakedTabs2.FHChars.A_Floor * 11;
  connect(step.y, prescribedTemperature.T) annotation (Line(
      points={{-71,32},{-62,32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(nakedTabs2.port_a, convection.solid) annotation (Line(
      points={{34,70},{34,82},{24,82}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedTemperature1.port, convection.fluid) annotation (Line(
      points={{-18,82},{4,82}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(nakedTabs50.port_a, convection1.solid) annotation (Line(
      points={{34,24},{34,26},{84,26},{84,40},{76,40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convection1.fluid, prescribedTemperature1.port) annotation (Line(
      points={{56,40},{54,40},{54,98},{-2,98},{-2,82},{-18,82}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(nakedTabs2Core.port_a, convection2.solid)
                                               annotation (Line(
      points={{38,-32},{38,-18},{28,-18}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(nakedTabs50Core.port_a, convection3.solid)
                                                 annotation (Line(
      points={{36,-76},{36,-74},{90,-74},{90,-60},{82,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedTemperature2.port, convection2.fluid) annotation (Line(
      points={{-28,-18},{8,-18}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedTemperature2.port, convection3.fluid) annotation (Line(
      points={{-28,-18},{-22,-18},{-22,-60},{62,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedTemperature.port, thermalConductor.port_a) annotation (Line(
      points={{-40,32},{-32,32}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalConductor.port_b, nakedTabs2.portCore) annotation (Line(
      points={{-12,32},{-6,32},{-6,60},{24,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalConductor.port_b, nakedTabs50.portCore) annotation (Line(
      points={{-12,32},{-6,32},{-6,14},{24,14}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalConductor.port_b, nakedTabs2Core.portCore) annotation (Line(
      points={{-12,32},{-6,32},{-6,-42},{28,-42}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalConductor.port_b, nakedTabs50Core.portCore) annotation (Line(
      points={{-12,32},{-6,32},{-6,-86},{26,-86}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>Tester model for NakedTabs.</p>
<p>Remark: this tester may not be used to assess the difference between NakedTabs and NakedTabsMassiveCore.  It is not realistic to apply a step to the core temperature of an embedded system, and therefore these models have to be run in combination with an embedded pipe model. </p>
</html>"));
end NakedTabsTester;
