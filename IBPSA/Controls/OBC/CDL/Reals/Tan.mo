within IBPSA.Controls.OBC.CDL.Reals;
block Tan "Output the tangent of the input"
  IBPSA.Controls.OBC.CDL.Interfaces.RealInput u(
    final unit="rad",
    displayUnit="deg")
    "Input for the tangent function"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  IBPSA.Controls.OBC.CDL.Interfaces.RealOutput y
    "Tangent of the input"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

equation
  y=Modelica.Math.tan(u);
  annotation (
    defaultComponentName="tan",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          textColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name"),
        Text(
          extent={{-90,72},{-18,24}},
          textColor={192,192,192},
          textString="tan"),
        Line(
          points={{0,-80},{0,68}},
          color={192,192,192}),
        Polygon(
          points={{0,90},{-8,68},{8,68},{0,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{90,0},{68,8},{68,-8},{90,0}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-90,0},{68,0}},
          color={192,192,192}),
        Line(
          points={{-80,-80},{-78.4,-68.4},{-76.8,-59.7},{-74.4,-50},{-71.2,-40.9},{-67.1,-33},{-60.7,-24.8},{-51.1,-17.2},{-35.8,-9.98},{-4.42,-1.07},{33.4,9.12},{49.4,16.2},{59.1,23.2},{65.5,30.6},{70.4,39.1},{73.6,47.4},{76,56.1},{77.6,63.8},{80,80}},
          smooth=Smooth.Bezier),
        Text(
          extent={{226,60},{106,10}},
          textColor={0,0,0},
          textString=DynamicSelect("",String(y,
            leftJustified=false,
            significantDigits=3)))}),
    Documentation(
      info="<html>
<p>
Block that outputs <code>y = tan(u)</code>,
where
<code>u</code> is an input.
</p>

<p align=\"center\">
<img src=\"modelica://IBPSA/Resources/Images/Controls/OBC/CDL/Reals/Tan.png\"
     alt=\"tan.png\" />
</p>

</html>",
      revisions="<html>
<ul>
<li>
November 8, 2024, by Michael Wetter:<br/>
Added <code>final</code> keyword to unit declaration as block is only valid for this unit.<br/>
Also added <code>displayUnit</code> keyword.
</li>
<li>
March 7, 2023, by Jianjun Hu:<br/>
Added unit <code>rad</code> to the input.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3277\">Buildings, issue 3277</a>.
</li>
<li>
March 2, 2020, by Michael Wetter:<br/>
Changed icon to display dynamically the output value.
</li>
<li>
January 3, 2017, by Michael Wetter:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end Tan;
