within Annex60.Utilities.Math;
block IntegratorWithReset "Output the integral of the input signal"
  extends Modelica.Blocks.Continuous.Integrator;
  parameter Boolean use_reset = false
    "Enables option to trigger a reset for the integrator part" annotation(Evaluate=true, Dialog(group="Integrator Reset"), choices(checkBox=true));
  parameter Annex60.BoundaryConditions.Types.DataSource yResetSou=Annex60.BoundaryConditions.Types.DataSource.Parameter "Either reset to parameter yReset or to variable input connector." annotation(Dialog(group="Integrator Reset", enable = if use_reset then true else false), Evaluate=true, choices(choice=Annex60.BoundaryConditions.Types.DataSource.Parameter "Use parameter", choice=Annex60.BoundaryConditions.Types.DataSource.Input "Use input connector"));
  parameter Real yReset = y_start
    "Value to which the output is reset if boolean trigger has a rising edge" annotation(Evaluate=true, Dialog(group="Integrator Reset", enable = if use_reset and yResetSou==Annex60.BoundaryConditions.Types.DataSource.Parameter then true else false));
  Modelica.Blocks.Interfaces.BooleanInput reset if  use_reset
    "Resets optionally the integrator output to its start value when trigger input becomes true. See also source code for when algorithm."
    annotation (Placement(transformation(extent={{-140,50},{-100,90}})));

  Modelica.Blocks.Interfaces.RealInput yReset_in if use_reset and yResetSou==Annex60.BoundaryConditions.Types.DataSource.Input "Here desired variable can be connected to which the integrator's output is reset to."
    annotation (Placement(transformation(extent={{-140,-90},{-100,-50}})));
protected
  Modelica.Blocks.Interfaces.BooleanInput reset_internal;
  Real yReset_nonParam;
  Modelica.Blocks.Interfaces.RealInput yReset_internal annotation(Evaluate=true);
equation
  yReset_nonParam=if yResetSou == Annex60.BoundaryConditions.Types.DataSource.Parameter then yReset else y_start;

  if use_reset then
    connect(reset_internal, reset);
  else
    reset_internal = false;
  end if;

  if use_reset and yResetSou == Annex60.BoundaryConditions.Types.DataSource.Parameter then
    yReset_internal = yReset_nonParam;
  elseif use_reset and yResetSou == Annex60.BoundaryConditions.Types.DataSource.Input then
    connect(yReset_in, yReset_internal);
  else
    yReset_internal = y;
  end if;

  if use_reset then
    when edge(reset_internal) then
      reinit(y,yReset_internal);
    end when;
  end if;

  annotation (
defaultComponentName="intWitRes",
    Documentation(info="<html>
<p>When <code>use_reset = true</code> then it is possible to reset the output of<span style=\"font-family: MS Shell Dlg 2;\"> integrator</span><code>y</code> to the chosen parameter <code>yReset (yResetSou = use Parameter)</code> or to the connected input <code>yReset_in (yResetSou = use Input)</code> when <code>reset</code> has a rising edge.</p>
</html>", revisions="<html>
<ul>
<li>September 22, 2016, by Philipp Mehrfeld:<br>First implementation. </li>
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
