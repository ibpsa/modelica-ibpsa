within IBPSA.Controls.OBC.CDL.Routing.Validation;
model IntegerScalarReplicator
  "Validation model for the IntegerScalarReplicator block"
  IBPSA.Controls.OBC.CDL.Routing.IntegerScalarReplicator intRep(
    nout=3)
    "Block that outputs the array replicating input value"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  IBPSA.Controls.OBC.CDL.Reals.Sources.Ramp ram(
    height=5,
    duration=1,
    offset=-2)
    "Block that outputs ramp signal"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  IBPSA.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Convert Real input to Integer output"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation
  connect(ram.y,reaToInt.u)
    annotation (Line(points={{-39,0},{-12,0}},color={0,0,127}));
  connect(reaToInt.y,intRep.u)
    annotation (Line(points={{11,0},{38,0}},color={255,127,0}));
  annotation (
    experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://IBPSA/Resources/Scripts/Dymola/Controls/OBC/CDL/Routing/Validation/IntegerScalarReplicator.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://IBPSA.Controls.OBC.CDL.Routing.IntegerScalarReplicator\">
IBPSA.Controls.OBC.CDL.Routing.IntegerScalarReplicator</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
July 27, 2021, by Baptiste Ravache:<br/>
Renamed to IntegerScalarReplicator.
</li>
<li>
July 24, 2017, by Jianjun Hu:<br/>
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
end IntegerScalarReplicator;
