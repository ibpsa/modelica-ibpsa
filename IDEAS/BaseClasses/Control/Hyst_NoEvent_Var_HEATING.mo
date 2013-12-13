within IDEAS.BaseClasses.Control;
block Hyst_NoEvent_Var_HEATING
  "Hysteresis FOR HEATING without events, with Real in- and output, and inputs for uLow and uHigh"

  //  extends Modelica.Blocks.Interfaces.partialBooleanBlockIcon;

  Modelica.Blocks.Interfaces.RealInput u annotation (Placement(transformation(
          extent={{-88,-30},{-68,-10}}), iconTransformation(extent={{-88,-30},{
            -68,-10}})));
  Modelica.Blocks.Interfaces.RealOutput y annotation (Placement(transformation(
          extent={{92,-10},{112,10}}), iconTransformation(extent={{92,-10},{112,
            10}})));

  Modelica.Blocks.Interfaces.RealInput uLow annotation (Placement(
        transformation(extent={{-88,50},{-68,70}}), iconTransformation(extent={
            {-88,50},{-68,70}})));
  Modelica.Blocks.Interfaces.RealInput uHigh annotation (Placement(
        transformation(extent={{-88,10},{-68,30}}), iconTransformation(extent={
            {-88,10},{-68,30}})));

initial equation
  y = 0;

equation
  if noEvent(u < uLow) then
    y = 1;
  elseif noEvent(u < uHigh and y > 0.5) then
    y = 1;
  else
    y = 0;
  end if;

  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-80,-80},{100,
            80}}), graphics={Polygon(
          points={{-65,89},{-73,67},{-57,67},{-65,89}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),Line(points={{-65,67},{-65,-81}},
          color={192,192,192}),Line(points={{-90,-70},{82,-70}}, color={192,192,
          192}),Polygon(
          points={{90,-70},{68,-62},{68,-78},{90,-70}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),Text(
          extent={{70,-80},{94,-100}},
          lineColor={160,160,164},
          textString="u"),Text(
          extent={{-65,93},{-12,75}},
          lineColor={160,160,164},
          textString="y"),Line(
          points={{-80,-70},{30,-70}},
          color={0,0,0},
          thickness=0.5),Line(
          points={{-50,10},{80,10}},
          color={0,0,0},
          thickness=0.5),Line(
          points={{-50,10},{-50,-70}},
          color={0,0,0},
          thickness=0.5),Line(
          points={{30,10},{30,-70}},
          color={0,0,0},
          thickness=0.5),Line(
          points={{-10,-65},{0,-70},{-10,-75}},
          color={0,0,0},
          thickness=0.5),Line(
          points={{-10,15},{-20,10},{-10,5}},
          color={0,0,0},
          thickness=0.5),Line(
          points={{-55,-20},{-50,-30},{-44,-20}},
          color={0,0,0},
          thickness=0.5),Line(
          points={{25,-30},{30,-19},{35,-30}},
          color={0,0,0},
          thickness=0.5),Text(
          extent={{-99,2},{-70,18}},
          lineColor={160,160,164},
          textString="true"),Text(
          extent={{-98,-87},{-66,-73}},
          lineColor={160,160,164},
          textString="false"),Text(
          extent={{19,-87},{44,-70}},
          lineColor={0,0,0},
          textString="uHigh"),Text(
          extent={{-63,-88},{-38,-71}},
          lineColor={0,0,0},
          textString="uLow"),Line(points={{-69,10},{-60,10}}, color={160,160,
          164})}),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-80,-80},{100,80}}),
        graphics={
        Rectangle(
          extent={{100,80},{-80,-80}},
          lineColor={100,100,100},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255}),
        Line(
          points={{20,80},{100,0},{20,-80}},
          color={100,100,100},
          smooth=Smooth.None),
        Text(
          extent={{-60,40},{60,-40}},
          lineColor={100,100,100},
          textString="hea")}),
    Documentation(info="<HTML>
<p>
This block transforms a <b>Real</b> input signal into a <b>Boolean</b>
output signal:
</p>
<ul>
<li> When the output was <b>false</b> and the input becomes
     <b>greater</b> than parameter <b>uHigh</b>, the output
     switches to <b>true</b>.</li>
<li> When the output was <b>true</b> and the input becomes
     <b>less</b> than parameter <b>uLow</b>, the output
     switches to <b>false</b>.</li>
</ul>
<p>
The start value of the output is defined via parameter
<b>pre_y_start</b> (= value of pre(y) at initial time).
The default value of this parameter is <b>false</b>.
</p>
</HTML>
"));
end Hyst_NoEvent_Var_HEATING;
