within IDEAS.Thermal.Components.Examples;
model NakedTabsTester "Testing discretisation of the naked tabs"

  extends Modelica.Icons.Example;

  IDEAS.Thermal.Components.Emission.NakedTabs nakedTabs2(n1=2, n2=2)
    annotation (Placement(transformation(extent={{28,4},{48,24}})));
  IDEAS.Thermal.Components.Emission.NakedTabs nakedTabs50(n1=50, n2=50)
    annotation (Placement(transformation(extent={{28,-42},{48,-22}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature
    annotation (Placement(transformation(extent={{-56,-24},{-36,-4}})));
  Modelica.Blocks.Sources.Step step(
    height=10,
    offset=293.15,
    startTime=1000)
    annotation (Placement(transformation(extent={{-88,-24},{-68,-4}})));
  Modelica.Thermal.HeatTransfer.Components.Convection convection
    annotation (Placement(transformation(extent={{28,46},{8,26}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature prescribedTemperature1
    (T=293.15)
    annotation (Placement(transformation(extent={{-34,26},{-14,46}})));
  Modelica.Thermal.HeatTransfer.Components.Convection convection1
    annotation (Placement(transformation(extent={{80,4},{60,-16}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(G=
        1000) annotation (Placement(transformation(extent={{-28,-24},{-8,-4}})));
equation
  convection.Gc = nakedTabs2.FHChars.A_Floor*11;
  convection1.Gc = nakedTabs2.FHChars.A_Floor*11;

  connect(step.y, prescribedTemperature.T) annotation (Line(
      points={{-67,-14},{-58,-14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(nakedTabs2.port_a, convection.solid) annotation (Line(
      points={{38,24},{38,36},{28,36}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedTemperature1.port, convection.fluid) annotation (Line(
      points={{-14,36},{8,36}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(nakedTabs50.port_a, convection1.solid) annotation (Line(
      points={{38,-22},{38,-20},{88,-20},{88,-6},{80,-6}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convection1.fluid, prescribedTemperature1.port) annotation (Line(
      points={{60,-6},{58,-6},{58,52},{2,52},{2,36},{-14,36}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedTemperature.port, thermalConductor.port_a) annotation (Line(
      points={{-36,-14},{-28,-14}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalConductor.port_b, nakedTabs2.portCore) annotation (Line(
      points={{-8,-14},{-2,-14},{-2,14},{28,14}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalConductor.port_b, nakedTabs50.portCore) annotation (Line(
      points={{-8,-14},{-2,-14},{-2,-32},{28,-32}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}})),
    Documentation(info="<html>
<p>Tester model for NakedTabs.</p>
<p>Remark: this tester may not be used to assess the difference between NakedTabs and NakedTabsMassiveCore.  It is not realistic to apply a step to the core temperature of an embedded system, and therefore these models have to be run in combination with an embedded pipe model. </p>
</html>"));
end NakedTabsTester;
