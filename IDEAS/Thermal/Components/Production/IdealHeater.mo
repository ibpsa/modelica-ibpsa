within IDEAS.Thermal.Components.Production;
model IdealHeater "Ideal heater, no losses to environment, unlimited power"
  extends
    IDEAS.Thermal.Components.Production.Interfaces.PartialDynamicHeaterWithLosses(
    final heaterType=IDEAS.Thermal.Components.Production.BaseClasses.HeaterType.Boiler,

    final QNom=1,
    final cDry=0.1,
    final mWater=0);

  Real eta "Instanteanous efficiency";

  IDEAS.Thermal.Components.Production.BaseClasses.HeatSource_Ideal heatSource(
    medium=medium,
    TBoilerSet=TSet,
    TEnvironment=heatPort.T,
    UALoss=UALoss,
    THxIn=heatedFluid.T_a,
    m_flowHx=heatedFluid.flowPort_a.m_flow)
    annotation (Placement(transformation(extent={{-64,26},{-44,46}})));
equation
  // Electricity consumption for electronics and fan only.  Pump is covered by pumpHeater;
  // This data is taken from Viessmann VitoDens 300W, smallest model.  So only valid for
  // very small household condensing gas boilers.
  PEl = 0;
  PFuel = heatSource.PFuel;
  eta = 1;
  connect(heatSource.heatPort, heatedFluid.heatPort) annotation (Line(
      points={{-44,36},{-20,36},{-20,6.12323e-016}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (
    Diagram(graphics),
    Icon(graphics={
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
          smooth=Smooth.None)}),
    Documentation(info="<html>
<p><h4><font color=\"#008000\">Description </font></h4></p>
<p>Ideal&nbsp;heater,&nbsp;will&nbsp;always&nbsp;make&nbsp;sure&nbsp;to&nbsp;reach&nbsp;the&nbsp;setpoint (no power limitation). This heater has thermal losses to the environment but an energy conversion efficiency of one. The IdealHeatSource will compute the required power and the environmental heat losses, and deliver exactly this heat flux to the heatedFluid so it will reach the set point. </p>
<p>The dynamics have been largely removed from this model by setting a final mWater=0.1 and final cDry=0.1. This ensures that the setpoint is reached at all operating conditions, also when these operating conditions change very rapidly.</p>
<p>See<a href=\"modelica://IDEAS.Thermal.Components.Production.Interfaces.PartialDynamicHeaterWithLosses\"> IDEAS.Thermal.Components.Production.Interfaces.PartialDynamicHeaterWithLosses</a> for more details about the heat losses and dynamics. </p>
<p><h4>Assumptions and limitations </h4></p>
<p><ol>
<li>&apos;pseudo&apos; dynamic model because water content and lumped dry capacity are extremely small</li>
<li>Ideal heater, so unlimited power and will always reach setpoint</li>
<li>Heat losses to environment</li>
</ol></p>
<p><h4>Model use</h4></p>
<p><ol>
<li>Specify medium and initial temperature (of the water + dry mass)</li>
<li>Connect TSet, the flowPorts and the heatPort to environment. </li>
</ol></p>
<p>See also<a href=\"modelica://IDEAS.Thermal.Components.Production.Interfaces.PartialDynamicHeaterWithLosses\"> IDEAS.Thermal.Components.Production.Interfaces.PartialDynamicHeaterWithLosses</a> for more details about the heat losses and dynamics. </p>
<p><h4>Validation </h4></p>
<p>No validation.</p>
<p><h4>Example</h4></p>
<p>An example of this model can be found in <a href=\"modelica://IDEAS.Thermal.Components.Examples.IdealHeater\">IDEAS.Thermal.Components.Examples.IdealHeater</a>.</p>
</html>", revisions="<html>
<p><ul>
<li>2013 May, Roel De Coninck: removing dynamics to improve setpoint reaching. Removing unused parameters</li>
<li>2012 September, Roel De Coninck, first version</li>
</ul></p>
</html>"));
end IdealHeater;
