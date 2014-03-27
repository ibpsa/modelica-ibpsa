within IDEAS.Thermal.Components.Production;
model HP_BrineWater "Brine-Water HP WITHOUT borehole"
  import IDEAS;

  extends
    IDEAS.Thermal.Components.Production.Interfaces.PartialDynamicHeaterWithLosses(
      final heaterType=IDEAS.Thermal.Components.Production.BaseClasses.HeaterType.HP_BW);
  parameter Modelica.SIunits.Power QNom "Nominal power at 2/35";

  replaceable package MediumBrine =
      Modelica.Media.Interfaces.PartialMedium
    "Medium (brine) at the primary side of the heat pump";

  parameter Modelica.SIunits.Power QDesign=0
    "Overrules QNom if different from 0. Design heat load, typically at -8 or -10 degC in Belgium.  ";
  parameter Real fraLosDesNom=0.68
    "Ratio of power at design conditions over power at 2/35degC";
  parameter Real betaFactor=0.8 "Relative sizing compared to design heat load";
  final parameter SI.Power QNomFinal=if QDesign == 0 then QNom else QDesign/
      fraLosDesNom*betaFactor "Used nominal power in the heatSource model";

  Real COP "Instanteanous COP";

  IDEAS.Thermal.Components.Production.BaseClasses.HeatSource_HP_BW heatSource(
    QNom=QNomFinal,
    TCondensor_set=TSet,
    TEnvironment=heatPort.T,
    UALoss=UALoss,
    TCondensor_in=Tin.T,
    m_flowCondensor=port_a.m_flow,
    redeclare package MediumPrimary = Medium,
    redeclare package MediumSecondary = MediumBrine)
    annotation (Placement(transformation(extent={{2,-64},{16,-50}})));
  outer IDEAS.SimInfoManager sim
    annotation (Placement(transformation(extent={{-86,92},{-66,112}})));
  IDEAS.Thermal.Components.Interfaces.FlowPort_a flowPortBrine_a(redeclare
      package Medium =
        MediumBrine) "Inlet flowport for the brine"
    annotation (Placement(transformation(extent={{16,-110},{36,-90}})));
  IDEAS.Thermal.Components.Interfaces.FlowPort_b flowPortBrine_b(redeclare
      package Medium =
        MediumBrine) "Outlet flowport for brine"
    annotation (Placement(transformation(extent={{66,-110},{86,-90}})));
  IDEAS.Fluid.Sensors.Temperature Tin(redeclare package Medium = Medium)
    "Incoming water temperature: for evaluation of condensation efficiency"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=0,
        origin={40,-56})));
equation
  PFuel = 0;
  PEl = heatSource.PEl;
  COP = if noEvent(heatSource.PEl > 0) then pipe_HeatPort.heatPort.Q_flow/PEl
     else 0;

  connect(Tin.port, port_a) annotation (Line(
      points={{40,-46},{40,-36},{100,-36},{100,-38}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(flowPortBrine_a, heatSource.prim_in) annotation (Line(
      points={{26,-100},{20,-100},{20,-86},{6.2,-86},{6.2,-64}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(flowPortBrine_b, heatSource.prim_out) annotation (Line(
      points={{76,-100},{76,-78},{10.4,-78},{10.4,-64}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(pipe_HeatPort.heatPort, heatSource.heatPort) annotation (Line(
      points={{28,-6},{22,-6},{22,-57},{16,-57}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            120}}),     graphics),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            120}}), graphics={
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
        Ellipse(extent={{-80,50},{-20,-10}}, lineColor={100,100,100}),
        Line(
          points={{-100,20},{-68,20},{-40,32},{-60,8},{-32,20},{-20,20}},
          color={0,0,127},
          smooth=Smooth.None),
        Ellipse(extent={{0,-10},{60,-70}}, lineColor={100,100,100}),
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
          extent={{-224,-80},{-114,-220}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Line(
          points={{-224,-80},{-114,-80}},
          color={95,95,95},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points={{-104,-40},{-144,-40}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-104,20},{-144,20}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-144,-40},{-144,-178},{-164,-198},{-184,-178},{-184,10},{-184,
              10}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-154,-40},{-154,-180},{-174,-198},{-194,-180},{-194,20},{-144,
              20}},
          color={0,0,127},
          smooth=Smooth.None)}),
    Documentation(info="<html>
<p><b>Description</b> </p>
<p>Dynamic ground source heat pump model, based on interpolation in performance tables for a Viessmann Vitocall 300-G heat pump. These tables are encoded in the <a href=\"modelica://IDEAS.Thermal.Components.Production.BaseClasses.HeatSource_HP_BW\">heatSource</a> model. If a different heat pump is to be simulated, create a different heatSource model with adapted interpolation tables.</p>
<p>The ground heat exchanger or aquifer is NOT INCLUDED in this model, but flowPort connectors are foreseen to connect the ground model to the heatSource. Without a ground model (or dummy model) this model cannot work.</p>
<p>The nominal power of the heat pump can be adapted, this will NOT influence the efficiency as a function of ambient air temperature and condenser temperaturel. </p>
<p>The heat pump has thermal losses to the environment which are often not mentioned in the performance tables. Therefore, the additional environmental heat losses are added to the heat production in order to ensure the same performance as in the manufacturers data, while still obtaining a dynamic model with heat losses (also when heat pump is off). The heatSource will compute the required power and the environmental heat losses, and try to reach the set point. </p>
<p>See<a href=\"modelica://IDEAS.Thermal.Components.Production.Interfaces.PartialDynamicHeaterWithLosses\"> IDEAS.Thermal.Components.Production.Interfaces.PartialDynamicHeaterWithLosses</a> for more details about the heat losses and dynamics. </p>
<p><h4>Assumptions and limitations </h4></p>
<p><ol>
<li>Dynamic model based on water content and lumped dry capacity</li>
<li>On/off controlled heat pump with limited power (based on QNom and interpolation tables in heatSource) </li>
<li>Heat losses to environment which are compensated &apos;artifically&apos; to meet the manufacturers data in steady state conditions</li>
</ol></p>
<p><h4>Model use</h4></p>
<p>This&nbsp;model&nbsp;is&nbsp;based&nbsp;on&nbsp;catalogue&nbsp;data&nbsp;from&nbsp;Viessmann&nbsp;for&nbsp;the&nbsp;vitocal&nbsp;300-G,&nbsp;type&nbsp;BW/BWC&nbsp;108&nbsp;(8kW&nbsp;nominal&nbsp;power) as specified by the <a href=\"modelica://IDEAS.Thermal.Components.Production.BaseClasses.HeatSource_HP_BW\">heatSource</a> model. If a different heat pumpr is to be simulated, create a different heatSource model with adapted interpolation tables.</p>
<p><ol>
<li>Specify medium and initial temperature (of the water + dry mass)</li>
<li>Specify the nominal power QNom. There are two options: (1) specify QNom and put QDesign = 0 or (2) specify QDesign &GT; 0 and QNom wil be calculated from QDesign as follows:</li>
<p>QNom = QDesign * betaFactor / fraLosDesNom</p>
<li>Connect TSet, the flowPorts and the heatPort to environment. </li>
</ol></p>
<p><br/>See also<a href=\"modelica://IDEAS.Thermal.Components.Production.Interfaces.PartialDynamicHeaterWithLosses\"> IDEAS.Thermal.Components.Production.Interfaces.PartialDynamicHeaterWithLosses</a> for more details about the heat losses and dynamics. </p>
<p><h4>Validation </h4></p>
<p>The model has been verified in order to check if the &apos;artificial&apos; heat loss compensation still leads to correct steady state efficiencies according to the manufacturer data. This verification is integrated in the example model <a href=\"modelica://IDEAS.Thermal.Components.Examples.Boiler_validation\">IDEAS.Thermal.Components.Examples.Boiler_validation</a>.</p>
<p><h4>Example</h4></p>
<p>No specific example foreseen. </p>
</html>", revisions="<html>
<p><ul>
<li>2013 May, Roel De Coninck: propagation of heatSource parameters and better definition of QNom used.  Documentation and example added</li>
<li>2011 Roel De Coninck: first version</li>
</ul></p>
</html>"));
end HP_BrineWater;
