within IBPSA.Fluid.HeatPumps.SafetyControls.BaseClasses;
block RunPerHouBoundary "Checks if a maximal run per hour value is in boundary"
  extends Modelica.Blocks.Interfaces.BooleanSISO;
  parameter Integer maxRunPer_h "Number of maximal on/off cycles per hour";
  parameter Modelica.Units.SI.Time delayTime(displayUnit="h") = 3600
    "Delay time of output with respect to input signal";
 Modelica.Blocks.Logical.LessThreshold
                              runCouLesMax(threshold=maxRunPer_h)
    "Checks if the count of total runs is lower than the maximal value"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Modelica.Blocks.MathInteger.TriggeredAdd triggeredAdd
    annotation (Placement(transformation(extent={{-60,10},{-40,-10}})));
  Modelica.Blocks.Sources.IntegerConstant intConPluOne(final k=1)
    "Value for counting"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  Modelica.Blocks.Math.IntegerToReal intToReal
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Modelica.Blocks.Math.Add sub(k2=-1)
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Nonlinear.FixedDelay fixedDelay(final delayTime(displayUnit=
          "h") = delayTime)
               annotation (Placement(transformation(extent={{10,-30},{30,-10}})));
equation
  connect(intConPluOne.y, triggeredAdd.u)
    annotation (Line(points={{-79,-20},{-74,-20},{-74,0},{-64,0}},
                                                   color={255,127,0}));
  connect(intToReal.u, triggeredAdd.y)
    annotation (Line(points={{-22,0},{-38,0}},     color={255,127,0}));
  connect(intToReal.y, sub.u1) annotation (Line(points={{1,0},{30,0},{30,6},{
          38,6}},             color={0,0,127}));
  connect(intToReal.y, fixedDelay.u)
    annotation (Line(points={{1,0},{6,0},{6,-20},{8,-20}},   color={0,0,127}));
  connect(fixedDelay.y, sub.u2) annotation (Line(points={{31,-20},{31,-6},{38,
          -6}},        color={0,0,127}));
  connect(runCouLesMax.y, y)
    annotation (Line(points={{91,0},{110,0}},           color={255,0,255}));
  connect(u, triggeredAdd.trigger) annotation (Line(points={{-120,0},{-80,0},
          {-80,20},{-56,20},{-56,12}},     color={255,0,255}));
  connect(sub.y, runCouLesMax.u) annotation (Line(points={{61,0},{68,0}},
                     color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Ellipse(extent={{-80,80},{80,-80}}, lineColor={160,160,164}),
        Line(points={{0,80},{0,60}}, color={160,160,164}),
        Line(points={{80,0},{60,0}}, color={160,160,164}),
        Line(points={{0,-80},{0,-60}}, color={160,160,164}),
        Line(points={{-80,0},{-60,0}}, color={160,160,164}),
        Line(points={{37,70},{26,50}}, color={160,160,164}),
        Line(points={{70,38},{49,26}}, color={160,160,164}),
        Line(points={{71,-37},{52,-27}}, color={160,160,164}),
        Line(points={{39,-70},{29,-51}}, color={160,160,164}),
        Line(points={{-39,-70},{-29,-52}}, color={160,160,164}),
        Line(points={{-71,-37},{-50,-26}}, color={160,160,164}),
        Line(points={{-71,37},{-54,28}}, color={160,160,164}),
        Line(points={{-38,70},{-28,51}}, color={160,160,164}),
        Line(
          points={{0,0},{-50,50}},
          thickness=0.5),
        Line(
          points={{0,0},{40,0}},
          thickness=0.5)}),                                      Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html><p>
  Everytime the boolean input signal has a rising edge, a counter is
  triggered and adds 1 to the total sum. This represents an on-turning
  of a certain device. With a delay this number is being substracted
  again, as this block counts the number of rising edges in a given
  amount of time(e.g. 1 hour). If this value is higher than a given
  maximal value, the output turns to false.
</p>
<ul>
  <li>
    <i>November 26, 2018&#160;</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">#577</a>)
  </li>
</ul>
</html>"));
end RunPerHouBoundary;
