within IDEAS.Controls.Control_fixme;
block Hyst_NoEvent3 "Hysteresis without events, with Real in- and output"

  extends Modelica.Blocks.Interfaces.partialBooleanBlockIcon;
  parameter Real uLow;
  parameter Real uHigh;

  Modelica.Blocks.Interfaces.RealInput u
    annotation (Placement(transformation(extent={{-128,-20},{-88,20}})));
  Modelica.Blocks.Interfaces.RealOutput y(start=0)
    annotation (Placement(transformation(extent={{96,-10},{116,10}})));

  output Real error;
equation
  y = Hysteresis_NoEvent(
    u,
    y,
    uLow,
    uHigh);
  error = if noEvent(u < uHigh and u > (uLow + 1.01*(uHigh - uLow)) and der(u)
     < 0 and y < 0.5) then 1.0 else 0.0;
  assert(error < 0.5,
    "The Hyst_NoEvent did not operate correctly.  Try reducing the tolerance of the solver");
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Polygon(
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
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),Line(points={{-80,68},{-80,-29}},
          color={192,192,192}),Polygon(
          points={{92,-29},{70,-21},{70,-37},{92,-29}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),Line(points={{-79,-29},{84,-29}},
          color={192,192,192}),Line(points={{-79,-29},{41,-29}}, color={0,0,0}),
          Line(points={{-15,-21},{1,-29},{-15,-36}}, color={0,0,0}),Line(points=
           {{41,51},{41,-29}}, color={0,0,0}),Line(points={{33,3},{41,22},{50,3}},
          color={0,0,0}),Line(points={{-49,51},{81,51}}, color={0,0,0}),Line(
          points={{-4,59},{-19,51},{-4,43}}, color={0,0,0}),Line(points={{-59,
          29},{-49,11},{-39,29}}, color={0,0,0}),Line(points={{-49,51},{-49,-29}},
          color={0,0,0}),Text(
          extent={{-92,-49},{-9,-92}},
          lineColor={192,192,192},
          textString="%uLow"),Text(
          extent={{2,-49},{91,-92}},
          lineColor={192,192,192},
          textString="%uHigh"),Rectangle(extent={{-91,-49},{-8,-92}}, lineColor=
           {192,192,192}),Line(points={{-49,-29},{-49,-49}}, color={192,192,192}),
          Rectangle(extent={{2,-49},{91,-92}}, lineColor={192,192,192}),Line(
          points={{41,-29},{41,-49}}, color={192,192,192})}),
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
end Hyst_NoEvent3;
