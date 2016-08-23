within Annex60.Utilities.Math;
block IntegratorWithReset "Output the integral of the input signal"
  extends Modelica.Blocks.Continuous.Integrator;
  parameter Boolean use_reset = false
    "Enables option to trigger a reset for the integrator part" annotation(Evaluate=true, Dialog(group="Integrator Reset"), choices(checkBox=true));
  parameter Real y_reset = y_start
    "Value to which the output is reset if boolean trigger has a rising edge"
    annotation(Dialog(group="Integrator Reset"));
  Modelica.Blocks.Interfaces.BooleanInput reset if use_reset
    "Resets the integrator output to its start value when trigger input becomes true"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
        // fixme: check if these instances are needed.
  Modelica.Blocks.Routing.BooleanPassThrough resetPassThrough
    annotation (Placement(transformation(extent={{-82,-52},{-66,-36}})));
  Modelica.Blocks.Sources.BooleanConstant resetFalse(k=false) if  not use_reset
    "Necessary to compensate if use_reset = false"
    annotation (Placement(transformation(extent={{-100,-90},{-88,-78}})));

equation
  if use_reset then
    when edge(resetPassThrough.y) then
      reinit(y, y_reset);
    end when;
  end if;

  connect(resetFalse.y, resetPassThrough.u) annotation (Line(points={{-87.4,-84},
          {-87.4,-44},{-83.6,-44}}, color={255,0,255}));
  connect(reset, resetPassThrough.u) annotation (Line(points={{-120,-80},{-96,-80},
          {-96,-44},{-83.6,-44}}, color={255,0,255}));
  annotation (
defaultComponentName="intWitRes",
    Documentation(info="<html>
<p>
This model is similar to
<a href=\"modelica://Modelica.Blocks.Continuous.Integrator\">
Modelica.Blocks.Continuous.Integrator</a>
except that it has an optional parameter <code>use_reset</code>.
If <code>use_reset = true</code>, then the input connector <code>reset</code>
is enabled. If its signal has a rising edge, then the output of the
integrator is reset to the parameter value <code>y_reset</code>.
</p>
<p>
See <a href=\"modelica://Annex60.Utilities.Math.Examples.IntegratorWithReset\">
Annex60.Utilities.Math.Examples.IntegratorWithReset</a> for an example.
</p>
</html>", revisions="<html>
<ul>
<li>
August 9, 2016, by Michael Wetter:<br/>
Revised model.
</li>
<li>
July 18, 2016, by Philipp Mehrfeld:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100.0,-100.0},{100.0,100.0}},
          initialScale=0.1),
        graphics={
          Line(
            visible=true,
            points={{-80.0,78.0},{-80.0,-90.0}},
            color={192,192,192}),
          Polygon(
            visible=true,
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid,
            points={{-80.0,90.0},{-88.0,68.0},{-72.0,68.0},{-80.0,90.0}}),
          Line(
            visible=true,
            points={{-90.0,-80.0},{82.0,-80.0}},
            color={192,192,192}),
          Polygon(
            visible=true,
            lineColor={192,192,192},
            fillColor={192,192,192},
            fillPattern=FillPattern.Solid,
            points={{90.0,-80.0},{68.0,-72.0},{68.0,-88.0},{90.0,-80.0}}),
          Text(
            visible=true,
            lineColor={192,192,192},
            extent={{0.0,-70.0},{60.0,-10.0}},
            textString="I"),
          Text(
            visible=true,
            extent={{-150.0,-150.0},{150.0,-110.0}},
            textString="k=%k"),
          Line(
            visible=true,
            points={{-80.0,-80.0},{80.0,80.0}},
            color={0,0,127})}),
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Rectangle(extent={{-60,60},{60,-60}}, lineColor={0,0,255}),
        Line(points={{-100,0},{-60,0}}, color={0,0,255}),
        Line(points={{60,0},{100,0}}, color={0,0,255}),
        Text(
          extent={{-36,60},{32,2}},
          lineColor={0,0,0},
          textString="k"),
        Text(
          extent={{-32,0},{36,-58}},
          lineColor={0,0,0},
          textString="s"),
        Line(points={{-46,0},{46,0}}, color={0,0,0})}));
end IntegratorWithReset;
