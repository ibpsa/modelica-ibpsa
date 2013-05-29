within IDEAS.Thermal.Components.Examples;
model NakedTabsTester "Testing discretisation of the naked tabs"

extends Modelica.Icons.Example;

  IDEAS.Thermal.Components.Emission.BaseClasses.NakedTabs
                                    nakedTabs2(n1=2, n2=2)
    annotation (Placement(transformation(extent={{22,184},{42,204}})));
  IDEAS.Thermal.Components.Emission.BaseClasses.NakedTabs
                                    nakedTabs50(n1=50, n2=50)
    annotation (Placement(transformation(extent={{22,130},{42,150}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature
    annotation (Placement(transformation(extent={{-62,156},{-42,176}})));
  Modelica.Blocks.Sources.Step step(
    height=10,
    offset=293.15,
    startTime=1000)
    annotation (Placement(transformation(extent={{-82,194},{-62,214}})));
   Modelica.Thermal.HeatTransfer.Components.Convection convection
     annotation (Placement(transformation(extent={{22,244},{2,224}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature prescribedTemperature1(T=293.15)
              annotation (Placement(transformation(extent={{-40,224},{-20,244}})));
   Modelica.Thermal.HeatTransfer.Components.Convection convection1
     annotation (Placement(transformation(extent={{74,184},{54,164}})));
  IDEAS.Thermal.Components.Emission.BaseClasses.NakedTabsMassiveCore
                                               nakedTabs2Core(n1=2, n2=2)
    annotation (Placement(transformation(extent={{28,54},{48,74}})));
  IDEAS.Thermal.Components.Emission.BaseClasses.NakedTabsMassiveCore
                                               nakedTabs50Core(n1=50, n2=50)
    annotation (Placement(transformation(extent={{28,0},{48,20}})));
   Modelica.Thermal.HeatTransfer.Components.Convection convection2
     annotation (Placement(transformation(extent={{26,108},{6,88}})));
   Modelica.Thermal.HeatTransfer.Components.Convection convection3
     annotation (Placement(transformation(extent={{80,54},{60,34}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature prescribedTemperature2(T=293.15)
              annotation (Placement(transformation(extent={{-50,90},{-30,110}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(G=1000)
    annotation (Placement(transformation(extent={{-34,156},{-14,176}})));
equation
  convection.Gc = nakedTabs2.FHChars.A_Floor * 11;
  convection1.Gc = nakedTabs2.FHChars.A_Floor * 11;
  convection2.Gc = nakedTabs2.FHChars.A_Floor * 11;
  convection3.Gc = nakedTabs2.FHChars.A_Floor * 11;
  connect(step.y, prescribedTemperature.T) annotation (Line(
      points={{-61,204},{-56,204},{-56,184},{-74,184},{-74,166},{-64,166}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(nakedTabs2.port_a, convection.solid) annotation (Line(
      points={{32,204},{32,236},{22,236},{22,234}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedTemperature1.port, convection.fluid) annotation (Line(
      points={{-20,234},{2,234}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(nakedTabs50.port_a, convection1.solid) annotation (Line(
      points={{32,150},{34,150},{34,154},{82,154},{82,174},{74,174}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convection1.fluid, prescribedTemperature1.port) annotation (Line(
      points={{54,174},{52,174},{52,252},{-4,252},{-4,234},{-20,234}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(nakedTabs2Core.port_a, convection2.solid)
                                               annotation (Line(
      points={{38,74},{38,98},{26,98}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(nakedTabs50Core.port_a, convection3.solid)
                                                 annotation (Line(
      points={{38,20},{40,20},{40,24},{88,24},{88,44},{80,44}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedTemperature2.port, convection2.fluid) annotation (Line(
      points={{-30,100},{-12,100},{-12,98},{6,98}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedTemperature2.port, convection3.fluid) annotation (Line(
      points={{-30,100},{-24,100},{-24,44},{60,44}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedTemperature.port, thermalConductor.port_a) annotation (Line(
      points={{-42,166},{-34,166}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalConductor.port_b, nakedTabs2.portCore) annotation (Line(
      points={{-14,166},{-8,166},{-8,194},{22,194}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalConductor.port_b, nakedTabs50.portCore) annotation (Line(
      points={{-14,166},{-8,166},{-8,140},{22,140}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalConductor.port_b, nakedTabs2Core.portCore) annotation (Line(
      points={{-14,166},{-8,166},{-8,64},{28,64}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalConductor.port_b, nakedTabs50Core.portCore) annotation (Line(
      points={{-14,166},{-8,166},{-8,10},{28,10}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-100,-100},{100,100}})));
end NakedTabsTester;
