within IDEAS.Thermal.Components.Emission;
model TabsMassiveCore "Very simple tabs system, with NakedTabsMassiveCore"

  extends Thermal.Components.Emission.Auxiliaries.Partial_Tabs;

  replaceable Thermal.Components.Emission.EmbeddedPipeDynTOut embeddedPipe(
    medium=medium,
    FHChars=FHChars,
    m_flowMin=m_flowMin) constrainedby
    Thermal.Components.Emission.Auxiliaries.Partial_EmbeddedPipe(
    medium=medium,
    FHChars=FHChars,
    m_flowMin=m_flowMin)
    annotation (choices(
      choice(redeclare IDEAS.Thermal.Components.Emission.EmbeddedPipe_prEN15377
                                                                              embeddedPipe),
      choice(redeclare IDEAS.Thermal.Components.Emission.EmbeddedPipeDynTOut       embeddedPipe),
      choice(redeclare IDEAS.Thermal.Components.Emission.EmbeddedPipeDynSwitch
                                                                        embeddedPipe)),
      Placement(transformation(extent={{-56,-8},{-36,12}})));

  NakedTabsMassiveCore
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
