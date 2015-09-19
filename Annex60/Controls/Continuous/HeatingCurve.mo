within Annex60.Controls.Continuous;
model HeatingCurve
  "Heating curve with one input and output variable, optional upper and lower output bound and optional night setback"
  extends Modelica.Blocks.Interfaces.SISO;

  //not using Modelica.SIunits.Temperature since this block may be used for other purposes too
  parameter Real[:] uVals "Input values";
  parameter Real[:] yVals "Corresponding output values";
  parameter Boolean useNightSetBack = false
    "Set to true for using a different day and night heating curve"
    annotation(Dialog(group="Night set back"), Evaluate=true);
  parameter Real[:] yValsNight = fill(0, size(yVals,1))
    "Corresponding output values during night set back"
    annotation(Dialog(group="Night set back", enable=useNightSetBack));
  parameter Boolean useBounds = false
    "Enable to be able to set upper and lower bound of output signal"
    annotation(Dialog(group="Bounds"), Evaluate=true);
  parameter Real yLower=1 "Lower bound for y"
    annotation(Dialog(group="Bounds", enable=useBounds));
  parameter Real yUpper=400 "Upper bound for y"
    annotation(Dialog(group="Bounds", enable=useBounds));
  parameter Modelica.Blocks.Types.Smoothness smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments
    "Smoothness of table interpolation";
  Modelica.Blocks.Tables.CombiTable1Ds combiTable(
    final tableOnFile=false,
    final table=transpose(if useNightSetBack then {uVals,yVals,
        yValsNight} else {uVals,yVals}),
    final columns=if useNightSetBack then {2,3} else {2},
    final smoothness=smoothness) "Combitable for interpolation of signals"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Interfaces.BooleanInput day if useNightSetBack
    "Set to false to enable night set back"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
protected
  Modelica.Blocks.Math.Max maxBlock if useBounds "Maximum bound"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Math.Min minBlock if useBounds "Minimum bound"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Blocks.Sources.Constant minVal(k=yUpper) if useBounds
    "Maximum output bound value"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Modelica.Blocks.Sources.Constant maxVal(k=yLower) if useBounds
    "Minimum output bound value"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Modelica.Blocks.Logical.Switch setBackSwitch if  useNightSetBack
    "Switch for switching between day and night curve"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Modelica.Blocks.Routing.RealPassThrough ToutUnfiltered
    "Pass through for easier handling of conditional components"
    annotation (Placement(transformation(extent={{-10,-4},{10,16}})));

equation
  connect(combiTable.u, u) annotation (Line(
      points={{-82,0},{-120,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(minVal.y, minBlock.u2) annotation (Line(
      points={{1,-30},{10,-30},{10,-6},{18,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(maxVal.y, maxBlock.u2) annotation (Line(
      points={{41,-30},{58,-30},{58,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  if not useNightSetBack then
    connect(combiTable.y[1], ToutUnfiltered.u) annotation (Line(
        points={{-59,0},{-34,0},{-34,6},{-12,6}},
        color={0,0,127},
        smooth=Smooth.None));
  end if;
  connect(minBlock.y, maxBlock.u1) annotation (Line(
      points={{41,0},{50,0},{50,6},{58,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(maxBlock.y, y) annotation (Line(
      points={{81,0},{110,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(setBackSwitch.u1, combiTable.y[1]) annotation (Line(
      points={{-42,48},{-56,48},{-56,0},{-59,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(setBackSwitch.u3, combiTable.y[2]) annotation (Line(
      points={{-42,32},{-50,32},{-50,0},{-59,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(setBackSwitch.y, ToutUnfiltered.u) annotation (Line(points={{-19,40},{
          -16,40},{-16,6},{-12,6}},   color={0,0,127}));
  connect(ToutUnfiltered.y, minBlock.u1)
    annotation (Line(points={{11,6},{11,6},{18,6}}, color={0,0,127}));

  if not useBounds then
    connect(ToutUnfiltered.y, y) annotation (Line(points={{11,6},{12,6},{12,24},
            {110,24},{110,0}}, color={0,0,127}));
  end if;
  connect(setBackSwitch.u2, day)
    annotation (Line(points={{-42,40},{-120,40}}, color={255,0,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),           Icon(graphics={
                                   Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-68,38},{12,10},{38,-12},{66,-70}},
          color={175,175,175},
          smooth=Smooth.None,
          pattern=LinePattern.Dash),
        Line(
          points={{-64,48},{12,26},{40,10},{66,-44}},
          color={175,175,175},
          smooth=Smooth.None),
        Ellipse(
          extent={{24,20},{28,16}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,58},{-80,-90}}, color={192,192,192}),
        Line(points={{-90,-80},{82,-80}}, color={192,192,192}),
        Polygon(
          points={{90,-80},{68,-72},{68,-88},{90,-80}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-80,80},{-88,58},{-72,58},{-80,80}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{26,-80},{26,0}},    color={192,192,192}),
        Polygon(
          points={{11,0},{-4,3},{-4,-3},{11,0}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid,
          origin={26,4},
          rotation=90),
        Polygon(
          points={{11,0},{-4,3},{-4,-3},{11,0}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid,
          origin={-67,18},
          rotation=180),
        Line(points={{0,-37},{-3.41535e-15,60}},
                                          color={192,192,192},
          origin={-16,18},
          rotation=90)}),
    Documentation(info="<html>
<p>
Heating curve implementation based on piecewise set of 
input-output points <code>uVals</code> and <code>yVals</code>. 
A second curve can be supplied for switching between two operation modes,
for instance when modelling a night set back. 
An upper and lower bound for the output can optionally be provided.
</p>
<h4>Main equations</h4>
<p>
Main equations are:
</p>
<pre>
y = f(u)
</pre>
<p>
with <code>f()</code> a piecewise function defined 
by <code>uVals</code> and <code>yVals</code>.
</p>
<p>
This can be extended to: 
</p>
<pre>
y = min(yUpper,max(yLower,f(u)))
</pre>
<p>
and/or 
</p>
<pre>
y = if day then f(u) else f2(u)
</pre>
<p>
with <code>f2()</code> a second piecewise function defined by
<code>uVals</code> and <code>yValsNight</code>. 
</p>
<h4>Assumption and limitations</h4>
<p>
It is assumed that both piecewise curves have the same <code>uVals</code> 
and hence <code>yVals</code> and <code>yValsNight</code> have the same length.
</p>
<h4>Typical use and important parameters</h4>
<p>
Typically the outside temperature is connected to the input <code>u</code>
of this model and the output <code>y</code> is used as a temperature set point
for a heating device.
</p>
<p>
Most parameters have been explained above. 
Parameter <code>useBounds</code> can be used to enable the output bound limitation. 
Parameter <code>useNightSetBack</code> can be used to enable the option for using night set back. 
The <code>day</code> input boolean will then be enabled.
Parameter <code>smoothNess</code> can be used to change the interpolation type that is
used for interpolating the values of <code>yVals</code>. 
</p>
</html>", revisions="<html>
<ul>
<li>
September 19, 2015 by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
end HeatingCurve;
