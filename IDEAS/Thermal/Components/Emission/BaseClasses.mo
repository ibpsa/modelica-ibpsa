within IDEAS.Thermal.Components.Emission;
package BaseClasses

  extends Modelica.Icons.BasesPackage;

  record FH_Standard1 "Basic floor heating design 1"
    extends IDEAS.Thermal.Components.BaseClasses.FH_Characteristics;
  end FH_Standard1;

  record FH_Standard2 "Larger pipes and bigger interdistance"
    extends IDEAS.Thermal.Components.BaseClasses.FH_Characteristics(
      T=0.2,
      d_a=0.025,
      s_r=0.0025);
  end FH_Standard2;

  record FH_ValidationEmpa "According to Koschenz, 2000, par 4.5.1"
    extends IDEAS.Thermal.Components.BaseClasses.FH_Characteristics(
      T=0.25,
      d_a=0.02,
      s_r=0.0025,
      n1=10,
      n2=10,
      lambda_r=0.55);
  end FH_ValidationEmpa;

  record FH_ValidationEmpa4_6 "According to Koschenz, 2000, par 4.6"
    extends IDEAS.Thermal.Components.BaseClasses.FH_Characteristics(
      S_1=0.1,
      S_2=0.2,
      T=0.20,
      d_a=0.025,
      s_r=0.0025,
      n1=10,
      n2=10,
      lambda_r=0.45);
                // A_Floor should be 120m * 0.2m = 24 m²
  end FH_ValidationEmpa4_6;

  model NakedTabs "HeatPort only very simple tabs system"

    replaceable parameter
      IDEAS.Thermal.Components.BaseClasses.FH_Characteristics            FHChars     annotation (choicesAllMatching = true);

    parameter Integer n1 = FHChars.n1;
    parameter Integer n2 = FHChars.n2;
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
      annotation (Placement(transformation(extent={{-10,90},{10,110}})));
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_b
      annotation (Placement(transformation(extent={{-10,-108},{10,-88}})));
    Modelica.Thermal.HeatTransfer.Components.ThermalConductor[n1+1] U1(each G = FHChars.lambda_b / (FHChars.S_1 / (n1+1)) * FHChars.A_Floor)
                                                                 annotation (
        Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={0,32})));
    Modelica.Thermal.HeatTransfer.Components.ThermalConductor[n2+1] U2(each G = FHChars.lambda_b / (FHChars.S_2 / (n2+1)) * FHChars.A_Floor)
                                                                 annotation (
        Placement(transformation(
          extent={{10,-10},{-10,10}},
          rotation=90,
          origin={0,-22})));
    Modelica.Thermal.HeatTransfer.Components.HeatCapacitor[n1] C1(each C = FHChars.A_Floor * FHChars.S_1/n1 * FHChars.rho_b * FHChars.c_b,
      each T(fixed=false))
      annotation (Placement(transformation(extent={{32,54},{52,74}})));

    Modelica.Thermal.HeatTransfer.Components.HeatCapacitor[n2] C2(each C = FHChars.A_Floor * FHChars.S_2/n2 * FHChars.rho_b * FHChars.c_b)
      annotation (Placement(transformation(extent={{30,-62},{50,-42}})));
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a portCore
      annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  equation
    for i in 1:n1 loop
      connect(U1[i].port_b, U1[i+1].port_a);
      connect(U1[i].port_b, C1[i].port);
    end for;
    for i in 1:n2 loop
      connect(U2[i].port_b, U2[i+1].port_a);
      connect(U2[i].port_b, C2[i].port);
    end for;
    connect(U1[n1+1].port_b, port_a);
    connect(U2[n2+1].port_b, port_b);
    connect(portCore, U1[1].port_a) annotation (Line(
        points={{-100,0},{-6.12323e-016,0},{-6.12323e-016,22}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(portCore, U2[1].port_a) annotation (Line(
        points={{-100,0},{6.12323e-016,0},{6.12323e-016,-12}},
        color={191,0,0},
        smooth=Smooth.None));
    annotation (Diagram(graphics));
  end NakedTabs;

  model NakedTabsMassiveCore
    "HeatPort only very simple tabs system, with lumped capacity to the core layer"

    replaceable parameter
      IDEAS.Thermal.Components.BaseClasses.FH_Characteristics            FHChars     annotation (choicesAllMatching = true);

    parameter Integer n1 = FHChars.n1;
    parameter Integer n2 = FHChars.n2;
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
      annotation (Placement(transformation(extent={{-10,90},{10,110}})));
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_b
      annotation (Placement(transformation(extent={{-10,-108},{10,-88}})));
    Modelica.Thermal.HeatTransfer.Components.ThermalConductor[n1+1] U1(each G = FHChars.lambda_b / (FHChars.S_1 / (n1+1)) * FHChars.A_Floor)
                                                                 annotation (
        Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={0,32})));
    Modelica.Thermal.HeatTransfer.Components.ThermalConductor[n2+1] U2(each G = FHChars.lambda_b / (FHChars.S_2 / (n2+1)) * FHChars.A_Floor)
                                                                 annotation (
        Placement(transformation(
          extent={{10,-10},{-10,10}},
          rotation=90,
          origin={0,-22})));
    Modelica.Thermal.HeatTransfer.Components.HeatCapacitor[n1] C1(each C = FHChars.A_Floor * FHChars.S_1/(n1+1) * FHChars.rho_b * FHChars.c_b)
      annotation (Placement(transformation(extent={{32,54},{52,74}})));

    Modelica.Thermal.HeatTransfer.Components.HeatCapacitor[n2] C2(each C = FHChars.A_Floor * FHChars.S_2/(n2+1) * FHChars.rho_b * FHChars.c_b)
      annotation (Placement(transformation(extent={{30,-62},{50,-42}})));
    Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a portCore
      annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
    Modelica.Thermal.HeatTransfer.Components.HeatCapacitor C0(C = FHChars.A_Floor * FHChars.S_1/(n1+1) * FHChars.rho_b * FHChars.c_b + FHChars.A_Floor * FHChars.S_2/(n2+1) * FHChars.rho_b * FHChars.c_b)
      "Capacitor to the core"
      annotation (Placement(transformation(extent={{34,6},{54,26}})));
  equation
    for i in 1:n1 loop
      connect(U1[i].port_b, U1[i+1].port_a);
      connect(U1[i].port_b, C1[i].port);
    end for;
    for i in 1:n2 loop
      connect(U2[i].port_b, U2[i+1].port_a);
      connect(U2[i].port_b, C2[i].port);
    end for;
    connect(U1[n1+1].port_b, port_a);
    connect(U2[n2+1].port_b, port_b);
    connect(portCore, U1[1].port_a) annotation (Line(
        points={{-100,0},{-6.12323e-016,0},{-6.12323e-016,22}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(portCore, U2[1].port_a) annotation (Line(
        points={{-100,0},{6.12323e-016,0},{6.12323e-016,-12}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(C0.port, U1[1].port_a) annotation (Line(
        points={{44,6},{44,0},{-6.12323e-016,0},{-6.12323e-016,22}},
        color={191,0,0},
        smooth=Smooth.None));
    annotation (Diagram(graphics));
  end NakedTabsMassiveCore;

  model Tabs "Very simple tabs system"

    extends IDEAS.Thermal.Components.Emission.Interfaces.Partial_Tabs;

    replaceable Thermal.Components.Emission.EmbeddedPipeDynTOut embeddedPipe(
      medium=medium,
      FHChars=FHChars,
      m_flowMin=m_flowMin) constrainedby
      IDEAS.Thermal.Components.Emission.Interfaces.Partial_EmbeddedPipe(
      medium=medium,
      FHChars=FHChars,
      m_flowMin=m_flowMin)
      annotation (choices(
        choice(redeclare
            IDEAS.Thermal.Components.Emission.EmbeddedPipe_prEN15377            embeddedPipe),
        choice(redeclare IDEAS.Thermal.Components.Emission.EmbeddedPipeDynTOut       embeddedPipe),
        choice(redeclare
            IDEAS.Thermal.Components.Emission.EmbeddedPipeDynSwitch       embeddedPipe)),
        Placement(transformation(extent={{-56,-8},{-36,12}})));

    IDEAS.Thermal.Components.Emission.BaseClasses.NakedTabs
              nakedTabs(FHChars=FHChars, n1=FHChars.n1, n2=FHChars.n2) annotation (Placement(transformation(extent={{-12,-8},{8,12}})));
      // It's a bit stupid to explicitly pass n1 and n2 again, but it's the only way to avoid warnings/errors in dymola 2012.
  equation
    connect(flowPort_a, embeddedPipe.flowPort_a) annotation (Line(
        points={{-100,40},{-70,40},{-70,2},{-56,2}},
        color={255,0,0},
        smooth=Smooth.None));
    connect(flowPort_b, embeddedPipe.flowPort_b) annotation (Line(
        points={{-100,-40},{-26,-40},{-26,2},{-36,2}},
        color={255,0,0},
        smooth=Smooth.None));
    connect(nakedTabs.port_a, port_a) annotation (Line(
        points={{-2,12},{-2,100},{0,100}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(nakedTabs.port_b, port_b) annotation (Line(
        points={{-2,-7.8},{-2,-98},{0,-98}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(embeddedPipe.heatPortFH, nakedTabs.portCore) annotation (Line(
        points={{-54.6,12},{-33.3,12},{-33.3,2},{-12,2}},
        color={191,0,0},
        smooth=Smooth.None));
    annotation (Diagram(graphics), Icon(graphics));
  end Tabs;

  model TabsMassiveCore "Very simple tabs system, with NakedTabsMassiveCore"

    extends IDEAS.Thermal.Components.Emission.Interfaces.Partial_Tabs;

    replaceable Thermal.Components.Emission.EmbeddedPipeDynTOut embeddedPipe(
      medium=medium,
      FHChars=FHChars,
      m_flowMin=m_flowMin) constrainedby
      IDEAS.Thermal.Components.Emission.Interfaces.Partial_EmbeddedPipe(
      medium=medium,
      FHChars=FHChars,
      m_flowMin=m_flowMin)
      annotation (choices(
        choice(redeclare
            IDEAS.Thermal.Components.Emission.EmbeddedPipe_prEN15377            embeddedPipe),
        choice(redeclare IDEAS.Thermal.Components.Emission.EmbeddedPipeDynTOut       embeddedPipe),
        choice(redeclare
            IDEAS.Thermal.Components.Emission.EmbeddedPipeDynSwitch       embeddedPipe)),
        Placement(transformation(extent={{-56,-8},{-36,12}})));

    IDEAS.Thermal.Components.Emission.BaseClasses.NakedTabsMassiveCore
              nakedTabs(FHChars=FHChars, n1=FHChars.n1, n2=FHChars.n2) annotation (Placement(transformation(extent={{-12,-8},{8,12}})));
      // It's a bit stupid to explicitly pass n1 and n2 again, but it's the only way to avoid warnings/errors in dymola 2012.
  equation
    connect(flowPort_a, embeddedPipe.flowPort_a) annotation (Line(
        points={{-100,40},{-70,40},{-70,2},{-56,2}},
        color={255,0,0},
        smooth=Smooth.None));
    connect(flowPort_b, embeddedPipe.flowPort_b) annotation (Line(
        points={{-100,-40},{-26,-40},{-26,2},{-36,2}},
        color={255,0,0},
        smooth=Smooth.None));
    connect(nakedTabs.port_a, port_a) annotation (Line(
        points={{-2,12},{-2,100},{0,100}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(nakedTabs.port_b, port_b) annotation (Line(
        points={{-2,-7.8},{-2,-98},{0,-98}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(embeddedPipe.heatPortFH, nakedTabs.portCore) annotation (Line(
        points={{-54.6,12},{-33.3,12},{-33.3,2},{-12,2}},
        color={191,0,0},
        smooth=Smooth.None));
    annotation (Diagram(graphics));
  end TabsMassiveCore;

  model TabsDiscretized "Discretized tabs system"

    extends IDEAS.Thermal.Components.Emission.Interfaces.Partial_Tabs;

    replaceable parameter
      IDEAS.Thermal.Components.BaseClasses.FH_Characteristics            FHCharsDiscretized(A_Floor=
          A_Floor/n) constrainedby
      IDEAS.Thermal.Components.BaseClasses.FH_Characteristics(
        A_Floor=A_Floor/n);

    parameter Integer n(min=2)=2 "number of discrete elements";

    IDEAS.Thermal.Components.Emission.BaseClasses.Tabs[
                                     n] tabs(
      each medium=medium,
      each A_Floor=A_Floor/n,
      each m_flowMin=m_flowMin,
      each FHChars=FHCharsDiscretized)
      annotation (Placement(transformation(extent={{-54,-8},{-34,12}})));

    Modelica.Thermal.HeatTransfer.Components.ThermalCollector thermalCollector(m=n)
      annotation (Placement(transformation(extent={{-54,52},{-34,32}})));
    Modelica.Thermal.HeatTransfer.Components.ThermalCollector thermalCollector1(m=n)
      annotation (Placement(transformation(extent={{-54,-46},{-34,-26}})));
  equation
    connect(flowPort_a, tabs[1].flowPort_a) annotation (Line(
        points={{-100,40},{-76,40},{-76,6},{-54,6}},
        color={255,0,0},
        smooth=Smooth.None));
    connect(tabs[n].flowPort_b, flowPort_b) annotation (Line(
        points={{-54,-2},{-76,-2},{-76,-40},{-100,-40}},
        color={255,0,0},
        smooth=Smooth.None));
    connect(thermalCollector.port_b, port_a) annotation (Line(
        points={{-44,52},{-44,74},{0,74},{0,100}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(tabs.port_a, thermalCollector.port_a) annotation (Line(
        points={{-44,12},{-44,32}},
        color={191,0,0},
        smooth=Smooth.None));

    for i in 1:n-1 loop
      connect(tabs[i].flowPort_b,tabs[i+1].flowPort_a);
    end for;

    connect(tabs.port_b, thermalCollector1.port_a) annotation (Line(
        points={{-44,-7.8},{-44,-26}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(thermalCollector1.port_b, port_b) annotation (Line(
        points={{-44,-46},{-44,-80},{0,-80},{0,-98}},
        color={191,0,0},
        smooth=Smooth.None));
    annotation (Diagram(graphics));
  end TabsDiscretized;

  model TabsDiscretized_2
    "Discretized tabs system, with discretized floor surface temperature too"

    extends IDEAS.Thermal.Components.Emission.Interfaces.Partial_Tabs;

    replaceable parameter
      IDEAS.Thermal.Components.BaseClasses.FH_Characteristics            FHCharsDiscretized(A_Floor=
          A_Floor/n) constrainedby
      IDEAS.Thermal.Components.BaseClasses.FH_Characteristics(
        A_Floor=A_Floor/n);

    parameter Integer n(min=2)=2 "number of discrete elements";

    IDEAS.Thermal.Components.Emission.BaseClasses.Tabs[
                                     n] tabs(
      each medium=medium,
      each A_Floor=A_Floor/n,
      each m_flowMin=m_flowMin,
      each FHChars=FHCharsDiscretized)
      annotation (Placement(transformation(extent={{-54,-8},{-34,12}})));

  equation
    connect(flowPort_a, tabs[1].flowPort_a) annotation (Line(
        points={{-100,40},{-76,40},{-76,6},{-54,6}},
        color={255,0,0},
        smooth=Smooth.None));
    connect(tabs[n].flowPort_b, flowPort_b) annotation (Line(
        points={{-54,-2},{-76,-2},{-76,-40},{-100,-40}},
        color={255,0,0},
        smooth=Smooth.None));

    for i in 1:n-1 loop
      connect(tabs[i].flowPort_b,tabs[i+1].flowPort_a);
    end for;
    for i in 1:n loop
      connect(tabs[i].port_b, port_b);
    end for;

    annotation (Diagram(graphics));
  end TabsDiscretized_2;
end BaseClasses;
