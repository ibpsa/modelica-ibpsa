within IDEAS.Thermal.Components.Production;
model HP_AWMod_Losses_MinOff
  "Modulating AW HP with losses to environment and minimum off-time"

  extends
    IDEAS.Thermal.Components.Production.Interfaces.PartialDynamicHeaterWithLosses(
      final heaterType=IDEAS.Thermal.Components.Production.BaseClasses.HeaterType.HP_AW);

  Real COP "Instanteanous COP";

public
  IDEAS.Thermal.Components.Production.BaseClasses.HP_CondensationPower_Losses_MinOff
                                                                               heatSource(
    medium=medium,
    QDesign=QNom,
    TEvaporator=sim.Te,
    TCondensor_in=heatedFluid.T_a,
    TCondensor_set=TSet,
    m_flowCondensor=heatedFluid.flowPort_a.m_flow,
    TEnvironment=heatPort.T,
    UALoss=UALoss)
    annotation (Placement(transformation(extent={{-48,-46},{-28,-26}})));
  outer IDEAS.SimInfoManager         sim
    annotation (Placement(transformation(extent={{-82,66},{-62,86}})));

equation
  PFuel = 0;
  PEl = heatSource.PEl;
  COP = if noEvent(PEl > 0) then heatedFluid.heatPort.Q_flow / PEl else 0;

  connect(heatSource.heatPort, heatedFluid.heatPort)
                                                 annotation (Line(
      points={{-28,-36},{-20,-36},{-20,6.12323e-016}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Icon(graphics={
        Line(
          points={{-100,30},{-100,10}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-100,-30},{-100,-50}},
          color={85,85,255},
          smooth=Smooth.None),
        Line(
          points={{80,30},{80,10}},
          color={128,0,255},
          smooth=Smooth.None),
        Line(
          points={{100,20},{84,20}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{100,-40},{84,-40}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{80,-30},{80,-50}},
          color={128,0,255},
          smooth=Smooth.None),
        Ellipse(extent={{-80,50},{-20,-10}},  lineColor={100,100,100}),
        Line(
          points={{-100,20},{-68,20},{-40,32},{-60,8},{-32,20},{-20,20}},
          color={0,0,127},
          smooth=Smooth.None),
        Ellipse(extent={{0,-10},{60,-70}},    lineColor={100,100,100}),
        Line(
          points={{0,-40},{12,-40},{40,-28},{20,-52},{48,-40},{80,-40}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-104,30},{-104,10}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-104,-30},{-104,-50}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{84,-30},{84,-50}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{84,30},{84,10}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-20,20},{-10,20},{-30,-40},{-100,-40}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{0,-40},{-10,-40},{10,20},{80,20}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-20,-72},{-20,-88},{0,-72},{0,-88},{-20,-72}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{-50,-10},{-50,-80},{-20,-80}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{0,-80},{30,-80},{30,-70}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{-50,50},{-50,100},{-30,100}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{30,-10},{30,80},{10,80}},
          color={95,95,95},
          smooth=Smooth.None),
        Polygon(
          points={{-20,120},{0,120},{8,118},{10,110},{10,70},{8,62},{0,60},{-20,
              60},{-28,62},{-30,70},{-30,110},{-28,118},{-20,120}},
          lineColor={95,95,95},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{14,100},{10,110}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-124,-60},{-184,120}},
          lineColor={95,95,95},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-214,100},{-184,20}},
          lineColor={95,95,95},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-174,-20},{-132,-42}},
          color={95,95,95},
          smooth=Smooth.None),
        Ellipse(
          extent={{-150,-34},{-138,-46}},
          lineColor={95,95,95},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255}),
        Line(
          points={{-104,-40},{-144,-40}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-174,0},{-132,-22}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{-174,20},{-132,-2}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{-174,40},{-132,18}},
          color={95,95,95},
          smooth=Smooth.None),
        Ellipse(
          extent={{-150,26},{-138,14}},
          lineColor={95,95,95},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255}),
        Line(
          points={{-104,20},{-144,20}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-176,62},{-134,40}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{-176,80},{-134,58}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{-176,102},{-134,80}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{-214,60},{-208,60},{-204,64},{-204,90},{-202,94},{-194,94},
              {-192,90},{-192,82}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{-214,60},{-208,60},{-204,56},{-204,30},{-202,26},{-194,26},
              {-192,30},{-192,38}},
          color={95,95,95},
          smooth=Smooth.None)}));
end HP_AWMod_Losses_MinOff;
