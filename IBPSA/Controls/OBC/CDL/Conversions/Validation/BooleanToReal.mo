within IBPSA.Controls.OBC.CDL.Conversions.Validation;
model BooleanToReal
  "Validation model for the BooleanToReal block"
  IBPSA.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Block that converts Boolean to Real signal"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  IBPSA.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    period=1)
    "Generate cyclic on-and-off output"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

equation
  connect(booPul.y,booToRea.u)
    annotation (Line(points={{2,0},{28,0},{28,0}},color={255,0,255}));
  annotation (
    experiment(
      StopTime=4.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://IBPSA/Resources/Scripts/Dymola/Controls/OBC/CDL/Conversions/Validation/BooleanToReal.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://IBPSA.Controls.OBC.CDL.Conversions.BooleanToReal\">
IBPSA.Controls.OBC.CDL.Conversions.BooleanToReal</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
April 10, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(
      graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}));
end BooleanToReal;
