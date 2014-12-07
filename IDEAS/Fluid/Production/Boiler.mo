within IDEAS.Fluid.Production;
model Boiler
  "Modulating boiler with losses to environment, based on performance tables"
  extends IDEAS.Fluid.Production.Interfaces.PartialDynamicHeaterWithLosses(
      final heaterType=BaseClasses.HeaterType.Boiler);

  Real eta "Instanteanous efficiency";

  IDEAS.Fluid.Production.BaseClasses.HeatSource_CondensingGasBurner heatSource(
    QNom=QNom,
    TBoilerSet=TSet,
    TEnvironment=heatPort.T,
    UALoss=UALoss,
    modulationMin=modulationMin,
    modulationStart=modulationStart,
    THxIn=Tin.T,
    hIn=inStream(port_a.h_outflow),
    m_flowHx=port_a.m_flow,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  parameter Real modulationMin=25 "Minimal modulation percentage";
  parameter Real modulationStart=35
    "Min estimated modulation level required for start of HP";
equation
  // Electricity consumption for electronics and fan only.  Pump is covered by pumpHeater;
  // This data is taken from Viessmann VitoDens 300W, smallest model.  So only valid for
  // very small household condensing gas boilers.
  PEl = 7 + heatSource.modulation/100*(33 - 7);
  PFuel = heatSource.PFuel;
  eta = heatSource.eta;
  connect(heatSource.heatPort, pipe_HeatPort.heatPort) annotation (Line(
      points={{-60,30},{28,30},{28,-6}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            120}}),
            graphics),
    Icon(graphics={
        Ellipse(
          extent={{-60,60},{58,-60}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={95,95,95}),
        Ellipse(extent={{-48,46},{46,-46}}, lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-32,34},{30,-34}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{100,60},{44,60}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{44,60},{34,48}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{44,-60},{34,-48}},
          color={0,0,127},
          smooth=Smooth.None,
          pattern=LinePattern.Dash),
        Line(
          points={{100,-60},{44,-60}},
          color={0,0,127},
          smooth=Smooth.None,
          pattern=LinePattern.Dash)}),
    Documentation(info="<html>
<p><h4><font color=\"#008000\">Description </font></h4></p>
<p>Dynamic boiler model, based on interpolation in performance tables. The boiler has thermal losses to the environment which are often not mentioned in the performance tables. Therefore, the additional environmental heat losses are added to the heat production in order to ensure the same performance as in the manufacturers data, while still obtaining a dynamic model with heat losses (also when boiler is off). The heatSource will compute the required power and the environmental heat losses, and try to reach the set point. </p>
<p>See<a href=\"modelica://IDEAS.Thermal.Components.Production.Interfaces.PartialDynamicHeaterWithLosses\"> IDEAS.Thermal.Components.Production.Interfaces.PartialDynamicHeaterWithLosses</a> for more details about the heat losses and dynamics. </p>
<p><h4>Assumptions and limitations </h4></p>
<p><ol>
<li>Dynamic model based on water content and lumped dry capacity</li>
<li>Limited power (based on QNom and interpolation tables in heatSource) </li>
<li>Heat losses to environment which are compensated &apos;artifically&apos; to meet the manufacturers data in steady state conditions</li>
<li>No enforced min on or min off time; Hysteresis on start/stop thanks to different parameters for minimum modulation to start and stop the heat pump</li>
</ol></p>
<p><h4>Model use</h4></p>
<p>This model is based on performance tables of a specific boiler, as specified by <a href=\"modelica://IDEAS.Thermal.Components.Production.BaseClasses.HeatSource_CondensingGasBurner\">IDEAS.Thermal.Components.Production.BaseClasses.HeatSource_CondensingGasBurner</a>. If a different gas boiler is to be simulated, create a different Burner model with adapted interpolation tables.</p>
<p><ol>
<li>Specify medium and initial temperature (of the water + dry mass)</li>
<li>Specify the nominal power</li>
<li>Specify the minimum required modulation level for the boiler to start (modulation_start) and the minimum modulation level when the boiler is operating (modulation_min). The difference between both will ensure some off-time in case of low heat demands</li>
<li>Connect TSet, the flowPorts and the heatPort to environment. </li>
</ol></p>
<p>See also<a href=\"modelica://IDEAS.Thermal.Components.Production.Interfaces.PartialDynamicHeaterWithLosses\"> IDEAS.Thermal.Components.Production.Interfaces.PartialDynamicHeaterWithLosses</a> for more details about the heat losses and dynamics. </p>
<p><h4>Validation </h4></p>
<p>The model has been verified in order to check if the &apos;artificial&apos; heat loss compensation still leads to correct steady state efficiencies according to the manufacturer data. This verification is integrated in the example model <a href=\"modelica://IDEAS.Thermal.Components.Examples.Boiler_validation\">IDEAS.Thermal.Components.Examples.Boiler_validation</a>.</p>
<p><h4>Example</h4></p>
<p>See validation.</p>
</html>", revisions="<html>
<p><ul>
<li>2014 March, Filip Jorissen, Annex60 compatibility</li>
<li>2013 May, Roel De Coninck: documentation</li>
<li>2011 August, Roel De Coninck: first version</li>
</ul></p>
</html>"));
end Boiler;
