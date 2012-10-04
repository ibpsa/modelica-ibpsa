within IDEAS.Thermal.Components.Production;
model Boiler
  "Modulating boiler with losses to environment, based on performance tables"
  extends
    Thermal.Components.Production.Auxiliaries.PartialDynamicHeaterWithLosses(
      final heaterType=IDEAS.Thermal.Components.Production.Auxiliaries.HeaterType.Boiler);

  Real eta "Instanteanous efficiency";

  Thermal.Components.Production.Auxiliaries.Burner heatSource(
    medium=medium,
    QDesign=QNom,
    TBoilerSet=TSet,
    TEnvironment=heatPort.T,
    UALoss=UALoss,
    THxIn=heatedFluid.T_a,
    m_flowHx=heatedFluid.flowPort_a.m_flow)
    annotation (Placement(transformation(extent={{-48,-46},{-28,-26}})));
equation
  // Electricity consumption for electronics and fan only.  Pump is covered by pumpHeater;
  // This data is taken from Viessmann VitoDens 300W, smallest model.  So only valid for
  // very small household condensing gas boilers.
  PEl = 7 + heatSource.modulation/100 * (33-7);
  PFuel = heatSource.PFuel;
  eta = heatSource.eta;
  connect(heatSource.heatPort, heatedFluid.heatPort) annotation (Line(
      points={{-28,-36},{-20,-36},{-20,6.12323e-016}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={255,255,255},
          fillPattern=FillPattern.HorizontalCylinder,
          lineColor={127,0,0}),
        Rectangle(
          extent={{-100,0},{100,-100}},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255},
          pattern=LinePattern.None),
        Ellipse(
          extent={{-58,60},{60,-60}},
          lineColor={127,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255}),
        Ellipse(extent={{-46,46},{48,-46}}, lineColor={127,0,0}),
        Line(
          points={{-30,34},{32,-34}},
          color={127,0,0},
          smooth=Smooth.None),
        Line(
          points={{0,60},{0,100}},
          color={127,0,0},
          smooth=Smooth.None),
        Line(
          points={{100,20},{42,20}},
          color={0,128,255},
          smooth=Smooth.None),
        Line(
          points={{102,-20},{70,-20},{70,-80},{0,-80},{0,-60}},
          color={0,128,255},
          smooth=Smooth.None)}));
end Boiler;
