within IDEAS.Fluid.Production;
model HP_AirWater "Modulating air-to-water HP with losses to environment"

  extends IDEAS.Fluid.Production.Interfaces.PartialDynamicHeaterWithLosses(
      final heaterType=BaseClasses.HeaterType.HP_AW);

  parameter Modelica.SIunits.Power QDesign=0
    "Overrules QNom if different from 0. Design heat load, typically at -8 or -10 degC in Belgium.  ";
  parameter Real fraLosDesNom=0.68
    "Ratio of power at design conditions over power at 2/35degC";
  parameter Real betaFactor=0.8 "Relative sizing compared to design heat load";
  final parameter SI.Power QNomFinal=if QDesign == 0 then QNom else QDesign/
      fraLosDesNom*betaFactor "Used nominal power in the heatSource model";

  Real COP "Instanteanous COP";

  IDEAS.Fluid.Production.BaseClasses.HeatSource_HP_AW heatSource(
    QNom=QNomFinal,
    TEvaporator=sim.Te,
    TCondensor_set=TSet,
    TEnvironment=heatPort.T,
    UALoss=UALoss,
    modulation_min=modulation_min,
    modulation_start=modulation_start,
    TCondensor_in=Tin.T,
    m_flowCondensor=port_a.m_flow,
    hIn=inStream(port_a.h_outflow),
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  outer IDEAS.SimInfoManager sim
    annotation (Placement(transformation(extent={{-82,66},{-62,86}})));

  parameter Real modulation_min=20 "Minimal modulation percentage";
  parameter Real modulation_start=35
    "Min estimated modulation level required for start of HP";
  Modelica.Blocks.Interfaces.BooleanInput u
    "Temperature setpoint, acts as on/off signal too" annotation (Placement(
        transformation(extent={{-126,10},{-86,50}}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-10,120})));
equation
  PFuel = 0;
  PEl = heatSource.PEl;
  COP = if noEvent(PEl > 0) then pipe_HeatPort.heatPort.Q_flow/PEl else 0;

  connect(heatSource.heatPort, pipe_HeatPort.heatPort) annotation (Line(
      points={{-60,30},{28,30},{28,-6}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),
            graphics),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),
         graphics={
        Polygon(
          points={{-52,100},{-32,100},{-32,80},{28,80},{28,-80},{-2,-80},{-2,
              -72},{-12,-80},{-22,-72},{-22,-80},{-52,-80},{-52,100}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Line(
          points={{78,70},{78,50}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{96,60},{80,60}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{96,-60},{80,-60}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{78,-50},{78,-70}},
          color={0,0,127},
          smooth=Smooth.None),
        Ellipse(extent={{-82,50},{-22,-10}}, lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-102,20},{-70,20},{-42,32},{-62,8},{-34,20},{-22,20}},
          color={0,127,255},
          smooth=Smooth.None),
        Ellipse(extent={{-2,-10},{58,-70}}, lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-2,-40},{10,-40},{38,-28},{18,-52},{40,-44},{40,-60}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{80,-50},{80,-70}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{80,70},{80,50}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-22,20},{-12,20},{-32,-40},{-102,-40}},
          color={0,127,255},
          smooth=Smooth.None),
        Line(
          points={{-2,-40},{-12,-40},{20,60},{78,60}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-22,-72},{-22,-88},{-2,-72},{-2,-88},{-22,-72}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-52,-10},{-52,-80},{-22,-80}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-2,-80},{28,-80},{28,-70}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-52,50},{-52,100},{-32,100}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{28,-10},{28,80},{8,80}},
          color={0,0,0},
          smooth=Smooth.None),
        Polygon(
          points={{-22,120},{-2,120},{6,118},{8,110},{8,70},{6,62},{-2,60},{-22,
              60},{-30,62},{-32,70},{-32,110},{-30,118},{-22,120}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{12,100},{8,110}},
          lineColor={95,95,95},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-60},{-160,120}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-190,100},{-160,20}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-150,-20},{-108,-42}},
          color={0,0,0},
          smooth=Smooth.None),
        Ellipse(
          extent={{-126,-34},{-114,-46}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255}),
        Line(
          points={{-80,-40},{-120,-40}},
          color={0,127,255},
          smooth=Smooth.None),
        Line(
          points={{-150,0},{-108,-22}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-150,20},{-108,-2}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-150,40},{-108,18}},
          color={0,0,0},
          smooth=Smooth.None),
        Ellipse(
          extent={{-126,26},{-114,14}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255}),
        Line(
          points={{-80,20},{-120,20}},
          color={0,127,255},
          smooth=Smooth.None),
        Line(
          points={{-152,62},{-110,40}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-152,80},{-110,58}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-152,102},{-110,80}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-190,60},{-184,60},{-180,64},{-180,90},{-178,94},{-170,94},{-168,
              90},{-168,82}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-190,60},{-184,60},{-180,56},{-180,30},{-178,26},{-170,26},{-168,
              30},{-168,38}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{40,-60},{78,-60}},
          color={0,0,127},
          smooth=Smooth.None)}),
    Documentation(info="<html>
<p><h4><font color=\"#008000\">Description </font></h4></p>
<p>Dynamic heat pump model, based on interpolation in performance tables for a Daikin Altherma heat pump. These tables are encoded in the <a href=\"modelica://IDEAS.Thermal.Components.Production.BaseClasses.HeatSource_HP_AW\">heatSource</a> model. If a different heat pump is to be simulated, create a different heatSource model with adapted interpolation tables.</p>
<p>The nominal power of the heat pump can be adapted, this will NOT influence the efficiency as a function of ambient air temperature, condenser temperature and modulation level. </p>
<p>The heat pump has thermal losses to the environment which are often not mentioned in the performance tables. Therefore, the additional environmental heat losses are added to the heat production in order to ensure the same performance as in the manufacturers data, while still obtaining a dynamic model with heat losses (also when heat pump is off). The heatSource will compute the required power and the environmental heat losses, and try to reach the set point. </p>
<p>See<a href=\"modelica://IDEAS.Thermal.Components.Production.Interfaces.PartialDynamicHeaterWithLosses\"> IDEAS.Thermal.Components.Production.Interfaces.PartialDynamicHeaterWithLosses</a> for more details about the heat losses and dynamics. </p>
<p><h4>Assumptions and limitations </h4></p>
<p><ol>
<li>Dynamic model based on water content and lumped dry capacity</li>
<li>Inverter controlled heat pump with limited power (based on QNom and interpolation tables in heatSource) </li>
<li>Heat losses to environment which are compensated &apos;artifically&apos; to meet the manufacturers data in steady state conditions</li>
<li>No defrosting taken into account</li>
<li>No enforced min on or min off time; Hysteresis on start/stop thanks to different parameters for minimum modulation to start and stop the heat pump</li>
</ol></p>
<p><h4>Model use</h4></p>
<p>This model is based on performance tables of a specific heat pump, as specified by the <a href=\"modelica://IDEAS.Thermal.Components.Production.BaseClasses.HeatSource_HP_AW\">heatSource</a> model. If a different heat pump is to be simulated, create a different heatSource model with adapted interpolation tables.</p>
<p><ol>
<li>Specify medium and initial temperature (of the water + dry mass)</li>
<li>Specify the nominal power QNom. There are two options: (1) specify QNom and put QDesign = 0 or (2) specify QDesign &GT; 0 and QNom wil be calculated from QDesign as follows:</li>
<p>QNom = QDesign * betaFactor / fraLosDesNom</p>
<li>Connect TSet, the flowPorts and the heatPort to environment. </li>
<li>Specify the minimum required modulation level for the boiler to start (modulation_start) and the minimum modulation level when the boiler is operating (modulation_min). The difference between both will ensure some off-time in case of low heat demands</li>
</ol></p>
<p>See also<a href=\"modelica://IDEAS.Thermal.Components.Production.Interfaces.PartialDynamicHeaterWithLosses\"> IDEAS.Thermal.Components.Production.Interfaces.PartialDynamicHeaterWithLosses</a> for more details about the heat losses and dynamics. </p>
<p><h4>Validation </h4></p>
<p>The model has been verified in order to check if the &apos;artificial&apos; heat loss compensation still leads to correct steady state efficiencies according to the manufacturer data. This verification is integrated in the example model <a href=\"modelica://IDEAS.Thermal.Components.Examples.Boiler_validation\">IDEAS.Thermal.Components.Examples.Boiler_validation</a>.</p>
<p><h4>Example</h4></p>
<p>A specific heat pump example is given in <a href=\"modelica://IDEAS.Thermal.Components.Examples.HeatPump_AirWater\">IDEAS.Thermal.Components.Examples.HeatPump_AirWater</a>.</p>
</html>", revisions="<html>
<p><ul>
<li>2014 March, Filip Jorissen, Annex60 compatibility</li>
<li>2013 May, Roel De Coninck: propagation of heatSource parameters and better definition of QNom used.  Documentation and example added</li>
<li>2011 Roel De Coninck: first version</li>
</ul></p>
</html>"));
end HP_AirWater;
