within IBPSA.Controls.OBC.CDL.Reals.Sources;
block Ramp
  "Generate ramp signal"
  parameter Real height=1
    "Height of ramps";
  parameter Real duration(
    final quantity="Time",
    final unit="s",
    min=Constants.small)
    "Duration of ramp (= 0.0 gives a Step)";
  parameter Real offset=0
    "Offset of output signal";
  parameter Real startTime(
    final quantity="Time",
    final unit="s")=0
    "Output = offset for time < startTime";
  IBPSA.Controls.OBC.CDL.Interfaces.RealOutput y
    "Ramp output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

equation
  y=offset+(
    if time < startTime then
      0
    else
      if time < (startTime+duration) then
        (time-startTime)*height/duration
      else
        height);
  annotation (
    defaultComponentName="ram",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
        Text(
          textColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name"),
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,68},{-80,-80}},
          color={192,192,192}),
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-90,-70},{82,-70}},
          color={192,192,192}),
        Polygon(
          points={{90,-70},{68,-62},{68,-78},{90,-70}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,-70},{-40,-70},{31,38}}),
        Text(
          extent={{-150,-150},{150,-110}},
          textColor={0,0,0},
          textString="duration=%duration"),
        Line(
          points={{31,38},{86,38}}),
        Text(
          extent={{226,60},{106,10}},
          textColor={0,0,0},
          textString=DynamicSelect("",String(y,
            leftJustified=false,
            significantDigits=3)))}),
    Documentation(
      info="<html>
<p>
The Real output y is a ramp signal:
</p>

<p align=\"center\">
<img src=\"modelica://IBPSA/Resources/Images/Controls/OBC/CDL/Reals/Sources/Ramp.png\"
     alt=\"Ramp.png\" />
</p>
</html>",
      revisions="<html>
<ul>
<li>
November 12, 2020, by Michael Wetter:<br/>
Reformulated to remove dependency to <code>Modelica.Units.SI</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2243\">Buildings, issue 2243</a>.
</li>
<li>
March 2, 2020, by Michael Wetter:<br/>
Changed icon to display dynamically the output value.
</li>
<li>
March 16, 2017, by Jianjun Hu:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end Ramp;
