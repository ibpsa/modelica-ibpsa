within IBPSA.Controls.OBC.CDL.Logical;
block Latch
  "Maintains a true signal until cleared"
  IBPSA.Controls.OBC.CDL.Interfaces.BooleanInput u
    "Latch input"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  IBPSA.Controls.OBC.CDL.Interfaces.BooleanInput clr
    "Clear input"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  IBPSA.Controls.OBC.CDL.Interfaces.BooleanOutput y
    "Output with latched signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
equation
  when initial() then
    y=not clr and u;
  elsewhen {clr, u} then
    y=not clr and u;
  end when;
  annotation (
    defaultComponentName="lat",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Ellipse(
          extent={{-73,9},{-87,-5}},
          lineColor=DynamicSelect({235,235,235},
            if u then
              {0,255,0}
            else
              {235,235,235}),
          fillColor=DynamicSelect({235,235,235},
            if u then
              {0,255,0}
            else
              {235,235,235}),
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{81,7},{95,-7}},
          lineColor=DynamicSelect({235,235,235},
            if y then
              {0,255,0}
            else
              {235,235,235}),
          fillColor=DynamicSelect({235,235,235},
            if y then
              {0,255,0}
            else
              {235,235,235}),
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-73,-53},{-87,-67}},
          lineColor=DynamicSelect({235,235,235},
            if clr then
              {0,255,0}
            else
              {235,235,235}),
          fillColor=DynamicSelect({235,235,235},
            if clr then
              {0,255,0}
            else
              {235,235,235}),
          fillPattern=FillPattern.Solid),
        Line(
          points={{-68,-62},{4,-62},{4,-22},{74,-22}},
          color={255,0,255}),
        Line(
          points={{-68,24},{-48,24},{-48,56},{-16,56},{-16,24},{24,24},{24,56},{54,56},{54,24},{74,24}},
          color={255,0,255}),
        Text(
          extent={{-14,-8},{14,-18}},
          textColor={0,0,0},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          textString="Clear"),
        Text(
          extent={{-16,72},{24,58}},
          textColor={0,0,0},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          textString="Latch input"),
        Text(
          extent={{-150,150},{150,110}},
          textColor={0,0,255},
          textString="%name")}),
    Documentation(
      info="<html>
<p>
Block that generates a <code>true</code> output when the latch input <code>u</code>
rises from <code>false</code> to <code>true</code>, provided that the clear input
<code>clr</code> is <code>false</code> or also became at the same time <code>false</code>.
The output remains <code>true</code> until the clear input <code>clr</code> rises
from <code>false</code> to <code>true</code>.
</p>
<p>
If the clear input <code>clr</code> is <code>true</code>, the output <code>y</code>
switches to <code>false</code> (if it was <code>true</code>) and it remains <code>false</code>,
regardless of the value of the latch input <code>u</code>.
</p>
<p>
At initial time, if <code>clr = false</code>, then the output will be
<code>y = u</code>. Otherwise it will be <code>y=false</code>
(because the clear input <code>clr</code> is <code>true</code>).
</p>

<p align=\"center\">
<img src=\"modelica://IBPSA/Resources/Images/Controls/OBC/CDL/Logical/Latch.png\"
     alt=\"Latch.png\" />
</p>

</html>",
      revisions="<html>
<ul>
<li>
April 15, 2024, by Antoine Gautier:<br/>
Simplified the implementation.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3796\">Buildings, issue 3796</a>.
</li>
<li>
October 13, 2020, by Jianjun Hu:<br/>
Removed the parameter <code>pre_y_start</code>, and made the initial output to be
equal to latch input when the clear input is <code>false</code>.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2177\">Buildings, issue 2177</a>.
</li>
<li>
March 9, 2020, by Michael Wetter:<br/>
Simplified implementation, and made model work with OpenModelica.
</li>
<li>
April 4, 2019, by Jianjun Hu:<br/>
Corrected implementation that causes wrong output at initial stage.
This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1402\">Buildings, issue 1402</a>.
</li>
<li>
December 1, 2017, by Michael Wetter:<br/>
Revised documentation.
</li>
<li>
March 30, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Latch;
