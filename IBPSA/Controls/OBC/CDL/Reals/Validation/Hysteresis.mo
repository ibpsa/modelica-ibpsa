within IBPSA.Controls.OBC.CDL.Reals.Validation;
model Hysteresis
  "Validation model for the Hysteresis block"
  IBPSA.Controls.OBC.CDL.Reals.Hysteresis hysteresis(
    final uLow=0,
    final uHigh=1)
    "Transform Real to Boolean signal with Hysteresis"
    annotation (Placement(transformation(extent={{50,30},{70,50}})));
  IBPSA.Controls.OBC.CDL.Reals.Hysteresis hysteresis1(
    final uLow=0,
    final uHigh=1,
    final pre_y_start=true)
    "Transform Real to Boolean signal with Hysteresis"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  IBPSA.Controls.OBC.CDL.Reals.Hysteresis hysteresis2(
    final uLow=0+0.01,
    final uHigh=1-0.01)
    "Transform Real to Boolean signal with Hysteresis"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));

protected
  IBPSA.Controls.OBC.CDL.Reals.Sources.Ramp ramp1(
    final duration=1,
    final offset=0,
    final height=6.2831852)
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-74,30},{-54,50}})));
  IBPSA.Controls.OBC.CDL.Reals.Sin sin1
    "Block that outputs the sine of the input"
    annotation (Placement(transformation(extent={{-30,30},{-10,50}})));
  IBPSA.Controls.OBC.CDL.Reals.MultiplyByParameter gain1(
    final k=2.5)
    "Block that outputs the product of a gain value with the input signal"
    annotation (Placement(transformation(extent={{10,30},{30,50}})));
  IBPSA.Controls.OBC.CDL.Reals.Sources.Sin sin(
    final amplitude=1,
    final freqHz=10)
    "Sine signal"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  IBPSA.Controls.OBC.CDL.Reals.Sources.Sin sin2(
    final amplitude=1,
    final freqHz=5)
    "Sine signal"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));

equation
  connect(ramp1.y,sin1.u)
    annotation (Line(points={{-52,40},{-32,40}},color={0,0,127}));
  connect(sin1.y,gain1.u)
    annotation (Line(points={{-8,40},{8,40}},color={0,0,127}));
  connect(gain1.y,hysteresis.u)
    annotation (Line(points={{32,40},{48,40}},color={0,0,127}));
  connect(hysteresis2.u,sin2.y)
    annotation (Line(points={{18,-40},{-18,-40}},color={0,0,127}));
  connect(sin.y,hysteresis1.u)
    annotation (Line(points={{-18,0},{18,0}},color={0,0,127}));
  annotation (
    experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://IBPSA/Resources/Scripts/Dymola/Controls/OBC/CDL/Reals/Validation/Hysteresis.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://IBPSA.Controls.OBC.CDL.Reals.Hysteresis\">
IBPSA.Controls.OBC.CDL.Reals.Hysteresis</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
March 14, 2023, by Jianjun Hu:<br/>
Changed the greater block input to avoid near zero crossing.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3294\">
issue 3294</a>.
</li> 
<li>
April 1, 2017, by Jianjun Hu:<br/>
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
end Hysteresis;
