within IDEAS.Thermal.Components.Production;
model IdealHeater "Ideal heater, no losses to environment, unlimited power"
  extends
    IDEAS.Thermal.Components.Production.Interfaces.PartialDynamicHeaterWithLosses(
      final heaterType=IDEAS.Thermal.Components.Production.BaseClasses.HeaterType.Boiler);

  Real eta "Instanteanous efficiency";

  IDEAS.Thermal.Components.Production.BaseClasses.IdealHeatSource
                                                   heatSource(
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
  PEl = 0;
  PFuel = heatSource.PFuel;
  eta = 1;
  connect(heatSource.heatPort, heatedFluid.heatPort) annotation (Line(
      points={{-28,-36},{-20,-36},{-20,6.12323e-016}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Icon(graphics={
        Ellipse(
          extent={{-60,60},{58,-60}},
          lineColor={127,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255}),
        Ellipse(extent={{-48,46},{46,-46}}, lineColor={95,95,95}),
        Line(
          points={{-32,34},{30,-34}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{98,20},{42,20}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{100,-40},{68,-40},{68,-80},{-2,-80},{-2,-46}},
          color={0,0,127},
          smooth=Smooth.None)}));
end IdealHeater;
