within IBPSA.Controls.OBC.CDL.Logical.Sources.Validation;
model SampleTriggerPositiveStartTime
  "Validation model for the SampleTrigger block with a positive start time"
  IBPSA.Controls.OBC.CDL.Logical.Sources.SampleTrigger samTri(
    period=0.5)
    "Block that generates sample trigger signal"
    annotation (Placement(transformation(extent={{-30,20},{-10,40}})));
  IBPSA.Controls.OBC.CDL.Reals.Sources.Ramp ramp(
    duration=5,
    offset=0,
    height=20,
    startTime=1)
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  IBPSA.Controls.OBC.CDL.Discrete.TriggeredSampler triggeredSampler
    "Triggered sampler"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  IBPSA.Controls.OBC.CDL.Logical.Sources.SampleTrigger samTri1(
    period=0.5,
    shift=0.3)
    "Block that generates sample trigger signal"
    annotation (Placement(transformation(extent={{-30,-80},{-10,-60}})));
  IBPSA.Controls.OBC.CDL.Discrete.TriggeredSampler triggeredSampler1(
    y_start=-2)
    "Triggered sampler"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));

equation
  connect(ramp.y,triggeredSampler.u)
    annotation (Line(points={{-58,70},{18,70}},color={0,0,127}));
  connect(samTri.y,triggeredSampler.trigger)
    annotation (Line(points={{-8,30},{30,30},{30,58}},  color={255,0,255}));
  connect(samTri1.y,triggeredSampler1.trigger)
    annotation (Line(points={{-8,-70},{30,-70},{30,-42}},  color={255,0,255}));
  connect(triggeredSampler1.u,ramp.y)
    annotation (Line(points={{18,-30},{-50,-30},{-50,70},{-58,70}},color={0,0,127}));
  annotation (
    experiment(
      StartTime=1.0,
      StopTime=6.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://IBPSA/Resources/Scripts/Dymola/Controls/OBC/CDL/Logical/Sources/Validation/SampleTriggerPositiveStartTime.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://IBPSA.Controls.OBC.CDL.Logical.Sources.SampleTrigger\">
IBPSA.Controls.OBC.CDL.Logical.Sources.SampleTrigger</a>
with positive start time.
The instances <code>samTri</code> and <code>samTri1</code> use a different value for the parameter <code>shift</code>.
</p>
</html>",
      revisions="<html>
<ul> 
<li>
December 02, 2020, by Milica Grahovac:<br/>
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
end SampleTriggerPositiveStartTime;
