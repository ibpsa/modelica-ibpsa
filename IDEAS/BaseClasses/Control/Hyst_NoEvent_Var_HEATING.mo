within IDEAS.BaseClasses.Control;
block Hyst_NoEvent_Var_HEATING
  "Hysteresis FOR HEATING without events, with Real in- and output, and inputs for uLow and uHigh"

// IMPORTANT: MAKE SURE THE INITIAL CONDITIONS ALLOW THE HYST TO BE OFF AT INITIALIZATION
//  extends Modelica.Blocks.Interfaces.partialBooleanBlockIcon;

  Modelica.Blocks.Interfaces.RealInput u
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}}),
        iconTransformation(extent={{-110,-70},{-90,-50}})));
  Modelica.Blocks.Interfaces.RealOutput y
    annotation (Placement(transformation(extent={{96,50},{116,70}}),
        iconTransformation(extent={{96,50},{116,70}})));

  Modelica.Blocks.Interfaces.RealInput uLow
    annotation (Placement(transformation(extent={{-110,50},{-90,70}}),
        iconTransformation(extent={{-110,50},{-90,70}})));
  Modelica.Blocks.Interfaces.RealInput uHigh
    annotation (Placement(transformation(extent={{-110,10},{-90,30}}),
        iconTransformation(extent={{-110,10},{-90,30}})));

initial equation
  y=0;

equation
  if noEvent(u<uLow) then
    y = 1;
  elseif noEvent(u<uHigh and y > 0.5) then
    y = 1;
  else
    y = 0;
  end if;

  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}),     graphics={
        Polygon(
          points={{-65,89},{-73,67},{-57,67},{-65,89}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-65,67},{-65,-81}}, color={192,192,192}),
        Line(points={{-90,-70},{82,-70}}, color={192,192,192}),
        Polygon(
          points={{90,-70},{68,-62},{68,-78},{90,-70}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{70,-80},{94,-100}},
          lineColor={160,160,164},
          textString="u"),
        Text(
          extent={{-65,93},{-12,75}},
          lineColor={160,160,164},
          textString="y"),
        Line(
          points={{-80,-70},{30,-70}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-50,10},{80,10}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-50,10},{-50,-70}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{30,10},{30,-70}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-10,-65},{0,-70},{-10,-75}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-10,15},{-20,10},{-10,5}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{-55,-20},{-50,-30},{-44,-20}},
          color={0,0,0},
          thickness=0.5),
        Line(
          points={{25,-30},{30,-19},{35,-30}},
          color={0,0,0},
          thickness=0.5),
        Text(
          extent={{-99,2},{-70,18}},
          lineColor={160,160,164},
          textString="true"),
        Text(
          extent={{-98,-87},{-66,-73}},
          lineColor={160,160,164},
          textString="false"),
        Text(
          extent={{19,-87},{44,-70}},
          lineColor={0,0,0},
          textString="uHigh"),
        Text(
          extent={{-63,-88},{-38,-71}},
          lineColor={0,0,0},
          textString="uLow"),
        Line(points={{-69,10},{-60,10}}, color={160,160,164})}),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Rectangle(
          extent={{-74,58},{74,-56}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{48,38},{54,-38}},
          lineColor={70,70,70},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{22,38},{28,-38}},
          lineColor={70,70,70},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-4,38},{2,-38}},
          lineColor={70,70,70},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-30,38},{-24,-38}},
          lineColor={70,70,70},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-54,36},{-46,28}},
          lineColor={255,255,255},
          fillColor={128,255,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-34,-4},{-22,-4},{-16,-10},{-22,-16},{-34,-16},{-34,-4}},
          lineColor={0,0,127},
          smooth=Smooth.None,
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-8,12},{4,12},{10,6},{4,0},{-8,0},{-8,12}},
          lineColor={0,0,127},
          smooth=Smooth.None,
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{18,0},{30,0},{36,-6},{30,-12},{18,-12},{18,0}},
          lineColor={0,0,127},
          smooth=Smooth.None,
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{46,16},{58,16},{64,10},{58,4},{46,4},{46,16}},
          lineColor={0,0,127},
          smooth=Smooth.None,
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid)}),
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
