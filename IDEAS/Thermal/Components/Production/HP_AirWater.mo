within IDEAS.Thermal.Components.Production;
model HP_AirWater "Modulating air-to-water HP with losses to environment"

  extends
    IDEAS.Thermal.Components.Production.Interfaces.PartialDynamicHeaterWithLosses(
      final heaterType=IDEAS.Thermal.Components.Production.BaseClasses.HeaterType.HP_AW);

  Real COP "Instanteanous COP";
  parameter Real betaFactor = 0.8
    "Relative sizing compared to design heat load";

  IDEAS.Thermal.Components.Production.BaseClasses.HeatSource_HP_AW      heatSource(
    medium=medium,
    QDesign=QNom,
    TEvaporator=sim.Te,
    TCondensor_in=heatedFluid.T_a,
    TCondensor_set=TSet,
    m_flowCondensor=heatedFluid.flowPort_a.m_flow,
    TEnvironment=heatPort.T,
    UALoss=UALoss)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  outer IDEAS.SimInfoManager         sim
    annotation (Placement(transformation(extent={{-82,66},{-62,86}})));

equation
  PFuel = 0;
  PEl = heatSource.PEl;
  COP = if noEvent(PEl > 0) then heatedFluid.heatPort.Q_flow / PEl else 0;

  connect(heatSource.heatPort, heatedFluid.heatPort)
                                                 annotation (Line(
      points={{-40,0},{-20,0},{-20,6.12323e-016}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Icon(graphics={
        Line(
          points={{-102,30},{-102,10}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-102,-30},{-102,-50}},
          color={85,85,255},
          smooth=Smooth.None),
        Line(
          points={{78,30},{78,10}},
          color={128,0,255},
          smooth=Smooth.None),
        Line(
          points={{98,20},{82,20}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{98,-40},{82,-40}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{78,-30},{78,-50}},
          color={128,0,255},
          smooth=Smooth.None),
        Ellipse(extent={{-82,50},{-22,-10}},  lineColor={100,100,100}),
        Line(
          points={{-102,20},{-70,20},{-42,32},{-62,8},{-34,20},{-22,20}},
          color={0,0,127},
          smooth=Smooth.None),
        Ellipse(extent={{-2,-10},{58,-70}},   lineColor={100,100,100}),
        Line(
          points={{-2,-40},{10,-40},{38,-28},{18,-52},{46,-40},{78,-40}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-106,30},{-106,10}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-106,-30},{-106,-50}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{82,-30},{82,-50}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{82,30},{82,10}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-22,20},{-12,20},{-32,-40},{-102,-40}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-2,-40},{-12,-40},{8,20},{78,20}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-22,-72},{-22,-88},{-2,-72},{-2,-88},{-22,-72}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{-52,-10},{-52,-80},{-22,-80}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{-2,-80},{28,-80},{28,-70}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{-52,50},{-52,100},{-32,100}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{28,-10},{28,80},{8,80}},
          color={95,95,95},
          smooth=Smooth.None),
        Polygon(
          points={{-22,120},{-2,120},{6,118},{8,110},{8,70},{6,62},{-2,60},{-22,
              60},{-30,62},{-32,70},{-32,110},{-30,118},{-22,120}},
          lineColor={95,95,95},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{12,100},{8,110}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-126,-60},{-186,120}},
          lineColor={95,95,95},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-216,100},{-186,20}},
          lineColor={95,95,95},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-176,-20},{-134,-42}},
          color={95,95,95},
          smooth=Smooth.None),
        Ellipse(
          extent={{-152,-34},{-140,-46}},
          lineColor={95,95,95},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255}),
        Line(
          points={{-106,-40},{-146,-40}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-176,0},{-134,-22}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{-176,20},{-134,-2}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{-176,40},{-134,18}},
          color={95,95,95},
          smooth=Smooth.None),
        Ellipse(
          extent={{-152,26},{-140,14}},
          lineColor={95,95,95},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255}),
        Line(
          points={{-106,20},{-146,20}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-178,62},{-136,40}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{-178,80},{-136,58}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{-178,102},{-136,80}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{-216,60},{-210,60},{-206,64},{-206,90},{-204,94},{-196,94},
              {-194,90},{-194,82}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{-216,60},{-210,60},{-206,56},{-206,30},{-204,26},{-196,26},
              {-194,30},{-194,38}},
          color={95,95,95},
          smooth=Smooth.None)}),
    Documentation(info="<html>
<p><b>Description</b> </p>
<p>Dynamic heat pump model, based on interpolation in performance tables. The heat pump has thermal losses to the environment which are often not mentioned in the performance tables. Therefore, the additional environmental heat losses are added to the heat production in order to ensure the same performance as in the manufacturers data, while still obtaining a dynamic model with heat losses (also when heat pump is off). The heatSource will compute the required power and the environmental heat losses, and try to reach the set point. </p>
<p>See<a href=\"modelica://IDEAS.Thermal.Components.Production.Interfaces.PartialDynamicHeaterWithLosses\"> IDEAS.Thermal.Components.Production.Interfaces.PartialDynamicHeaterWithLosses</a> for more details about the heat losses and dynamics. </p>
<p><h4>Assumptions and limitations </h4></p>
<p><ol>
<li>Dynamic model based on water content and lumped dry capacity</li>
<li>Limited power (based on QNom and interpolation tables in heatSource) </li>
<li>Heat losses to environment which are compensated &apos;artifically&apos; to meet the manufacturers data in steady state conditions</li>
</ol></p>
<p><h4>Model use</h4></p>
<p>This model is based on performance tables of a specific boiler, as specified by <a href=\"modelica://IDEAS.Thermal.Components.Production.BaseClasses.Burner\">IDEAS.Thermal.Components.Production.BaseClasses.Burne</a>r. If a different gas boiler is to be simulated, create a different Burner model with adapted interpolation tables.</p>
<p><ol>
<li>Specify medium and initial temperature (of the water + dry mass)</li>
<li>Specify the nominal power</li>
<li>Connect TSet, the flowPorts and the heatPort to environment. </li>
</ol></p>
<p>See also<a href=\"modelica://IDEAS.Thermal.Components.Production.Interfaces.PartialDynamicHeaterWithLosses\"> IDEAS.Thermal.Components.Production.Interfaces.PartialDynamicHeaterWithLosses</a> for more details about the heat losses and dynamics. </p>
<p><h4>Validation </h4></p>
<p>The model has been verified in order to check if the &apos;arrtificial&apos; heat loss compensation still leads to correct steady state efficiencies according to the manufacturer data. This verification is integrated in the example model <a href=\"modelica://IDEAS.Thermal.Components.Examples.Boiler_validation\">IDEAS.Thermal.Components.Examples.heat pump_validation</a>.</p>
<p><h4>Example</h4></p>
<p>See validation.</p>
</html>"));
end HP_AirWater;
