within Annex60.Controls.Continuous;
block IntegratorWithReset "Output the integral of the input signal"
  extends Modelica.Blocks.Continuous.Integrator;
  parameter Boolean withResetIntegrator = false
    "Enables option to trigger a reset for the integrator part";
  parameter Real yReset = y_start
    "Value to which the output is reset if boolean trigger has a rising edge";
  Modelica.Blocks.Interfaces.BooleanInput resetI if withResetIntegrator
    "Resets optionally the integrator output to its start value when trigger input becomes true. See also source code for when algorithm."
    annotation (Placement(transformation(extent={{-140,-86},{-100,-46}})));

  Modelica.Blocks.Routing.BooleanPassThrough resetIPassThrough
    annotation (Placement(transformation(extent={{-82,-52},{-66,-36}})));
  Modelica.Blocks.Sources.BooleanConstant resetIFalse(k=false) if not withResetIntegrator
    "Necessary to compensate if withResetIntegrator = false"
    annotation (Placement(transformation(extent={{-100,-90},{-88,-78}})));

equation
  when edge(resetIPassThrough.y) then
      reinit(y,yReset);
  end when;

  connect(resetIFalse.y,resetIPassThrough. u) annotation (Line(points={{-87.4,-84},
          {-87.4,-44},{-83.6,-44}}, color={255,0,255}));
  connect(resetI, resetIPassThrough.u) annotation (Line(points={{-120,-66},{-96,
          -66},{-96,-44},{-83.6,-44}}, color={255,0,255}));
  annotation (
    Documentation(info="<html>
<p>It is possible to reset the output of<span style=\"font-family: MS Shell Dlg 2;\"> integrator</span><code>y</code> to the chosen value <code>yReset</code> when <code>resetI</code> has a rising edge.</p>
</html>", revisions="<html>
<ul>
<li>July 18, 2016, by Philipp Mehrfeld:<br>First implementation. </li>
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
