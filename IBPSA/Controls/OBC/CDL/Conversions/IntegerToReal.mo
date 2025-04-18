within IBPSA.Controls.OBC.CDL.Conversions;
block IntegerToReal
  "Convert Integer to Real signals"
  IBPSA.Controls.OBC.CDL.Interfaces.IntegerInput u
    "Integer signal to be converted to a Real signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  IBPSA.Controls.OBC.CDL.Interfaces.RealOutput y
    "Converted input signal as a Real"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

equation
  y=u;
  annotation (
    defaultComponentName="intToRea",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100.0,-100.0},{100.0,100.0}}),
      graphics={
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255}),
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          textColor={255,127,0},
          extent={{-120.0,-40.0},{-20.0,40.0}},
          textString="I"),
        Text(
          textColor={0,0,127},
          fillPattern=FillPattern.Solid,
          extent={{0.0,-40.0},{100.0,40.0}},
          textString="R"),
        Polygon(
          lineColor={0,0,127},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid,
          points={{10.0,0.0},{-10.0,20.0},{-10.0,10.0},{-40.0,10.0},{-40.0,-10.0},{-10.0,-10.0},{-10.0,-20.0},{10.0,0.0}})}),
    Documentation(
      info="<html>
<p>
Block that outputs the <code>Real</code>
equivalent of the <code>Integer</code> input.
</p>
<pre>
  y = u;
</pre>
<p>
where <code>u</code> is of <code>Integer</code> and
<code>y</code> of <code>Real</code> type.
</p>
</html>",
      revisions="<html>
<ul>
<li>
January 3, 2017, by Michael Wetter:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end IntegerToReal;
