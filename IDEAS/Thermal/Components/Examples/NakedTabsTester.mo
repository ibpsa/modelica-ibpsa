within IDEAS.Thermal.Components.Examples;
model NakedTabsTester "Testing discretisation of the naked tabs"

  IDEAS.Thermal.Components.HeatEmission.NakedTabs
                                    nakedTabs2(n1=2, n2=2)
    annotation (Placement(transformation(extent={{10,26},{30,46}})));
  IDEAS.Thermal.Components.HeatEmission.NakedTabs
                                    nakedTabs50(n1=50, n2=50)
    annotation (Placement(transformation(extent={{10,-28},{30,-8}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature
    annotation (Placement(transformation(extent={{-74,-2},{-54,18}})));
  Modelica.Blocks.Sources.Step step(
    height=10,
    offset=293.15,
    startTime=1000)
    annotation (Placement(transformation(extent={{-94,36},{-74,56}})));
   Modelica.Thermal.HeatTransfer.Components.Convection convection
     annotation (Placement(transformation(extent={{10,86},{-10,66}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature prescribedTemperature1(T=293.15)
              annotation (Placement(transformation(extent={{-52,66},{-32,86}})));
   Modelica.Thermal.HeatTransfer.Components.Convection convection1
     annotation (Placement(transformation(extent={{62,26},{42,6}})));
  IDEAS.Thermal.Components.HeatEmission.NakedTabsMassiveCore
                                               nakedTabs2Core(n1=2, n2=2)
    annotation (Placement(transformation(extent={{16,-104},{36,-84}})));
  IDEAS.Thermal.Components.HeatEmission.NakedTabsMassiveCore
                                               nakedTabs50Core(n1=50, n2=50)
    annotation (Placement(transformation(extent={{16,-158},{36,-138}})));
   Modelica.Thermal.HeatTransfer.Components.Convection convection2
     annotation (Placement(transformation(extent={{14,-50},{-6,-70}})));
   Modelica.Thermal.HeatTransfer.Components.Convection convection3
     annotation (Placement(transformation(extent={{68,-104},{48,-124}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature prescribedTemperature2(T=293.15)
              annotation (Placement(transformation(extent={{-62,-68},{-42,-48}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(G=1000)
    annotation (Placement(transformation(extent={{-46,-2},{-26,18}})));
equation
  convection.Gc = nakedTabs2.FHChars.A_Floor * 11;
  convection1.Gc = nakedTabs2.FHChars.A_Floor * 11;
  convection2.Gc = nakedTabs2.FHChars.A_Floor * 11;
  convection3.Gc = nakedTabs2.FHChars.A_Floor * 11;
  connect(step.y, prescribedTemperature.T) annotation (Line(
      points={{-73,46},{-68,46},{-68,26},{-86,26},{-86,8},{-76,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(nakedTabs2.port_a, convection.solid) annotation (Line(
      points={{20,46},{20,78},{10,78},{10,76}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedTemperature1.port, convection.fluid) annotation (Line(
      points={{-32,76},{-10,76}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(nakedTabs50.port_a, convection1.solid) annotation (Line(
      points={{20,-8},{22,-8},{22,-4},{70,-4},{70,16},{62,16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convection1.fluid, prescribedTemperature1.port) annotation (Line(
      points={{42,16},{40,16},{40,94},{-16,94},{-16,76},{-32,76}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(nakedTabs2Core.port_a, convection2.solid)
                                               annotation (Line(
      points={{26,-84},{26,-60},{14,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(nakedTabs50Core.port_a, convection3.solid)
                                                 annotation (Line(
      points={{26,-138},{28,-138},{28,-134},{76,-134},{76,-114},{68,-114}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedTemperature2.port, convection2.fluid) annotation (Line(
      points={{-42,-58},{-24,-58},{-24,-60},{-6,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedTemperature2.port, convection3.fluid) annotation (Line(
      points={{-42,-58},{-36,-58},{-36,-114},{48,-114}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedTemperature.port, thermalConductor.port_a) annotation (Line(
      points={{-54,8},{-46,8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalConductor.port_b, nakedTabs2.portCore) annotation (Line(
      points={{-26,8},{-20,8},{-20,36},{10,36}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalConductor.port_b, nakedTabs50.portCore) annotation (Line(
      points={{-26,8},{-20,8},{-20,-18},{10,-18}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalConductor.port_b, nakedTabs2Core.portCore) annotation (Line(
      points={{-26,8},{-20,8},{-20,-94},{16,-94}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalConductor.port_b, nakedTabs50Core.portCore) annotation (Line(
      points={{-26,8},{-20,8},{-20,-148},{16,-148}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -200},{100,200}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-100,-200},{100,200}})));
end NakedTabsTester;
