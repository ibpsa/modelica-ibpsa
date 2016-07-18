within Annex60.Controls.Continuous;
block LimPID
  "P, PI, PD, and PID controller with limited output, anti-windup compensation and setpoint weighting"
  extends Modelica.Blocks.Continuous.LimPID(
    addP(k1=revAct*wp, k2=-revAct),
    addD(k1=revAct*wd, k2=-revAct),
    addI(k1=revAct, k2=-revAct),
    yMin=0,
    yMax=1,
    strict=true);

  parameter Boolean reverseAction = false
    "Set to true for throttling the water flow rate through a cooling coil controller";
  parameter Boolean withResetIntegrator = false
    "Enables option to trigger a reset for the integrator part";
  Modelica.Blocks.Interfaces.BooleanInput resetI if withResetIntegrator
    "Resets optionally the integrator output to its start value when trigger input becomes true. (See also Source Code of LimPID.)"
    annotation (Placement(transformation(extent={{-140,-86},{-100,-46}})));
  Modelica.Blocks.Routing.BooleanPassThrough resetIPassThrough
    annotation (Placement(transformation(extent={{-52,-62},{-44,-54}})));
  Modelica.Blocks.Sources.BooleanConstant resetIFalse(k=false) if not withResetIntegrator
    "Necessary to compensate if withResetIntegrator = false"
    annotation (Placement(transformation(extent={{-68,-80},{-60,-72}})));

protected
  parameter Real revAct = if reverseAction then -1 else 1;

equation
  when resetIPassThrough.y == true then
      reinit(I.y,I.y_start);
  end when;

  connect(resetI, resetIPassThrough.u) annotation (Line(points={{-120,-66},{-56,
          -66},{-56,-58},{-52.8,-58}}, color={255,0,255}));
  connect(resetIFalse.y, resetIPassThrough.u) annotation (Line(points={{-59.6,-76},
          {-52.8,-76},{-52.8,-58}}, color={255,0,255}));
   annotation (
defaultComponentName="conPID",
Documentation(info="<html>
<p>
This model is identical to
<a href=\"modelica://Modelica.Blocks.Continuous.LimPID\">
Modelica.Blocks.Continuous.LimPID</a> except
that it can be configured to have a reverse action.
</p>
<p>
If the parameter <code>reverseAction=false</code> (the default),
then <code>u_m &lt; u_s</code> increases the controller output,
otherwise the controller output is decreased.
Thus,
</p>
<ul>
<li>
for a heating coil with a two-way valve, set <code>reverseAction = false</code>,
</li>
<li>
for a cooling coils with a two-way valve, set <code>reverseAction = true</code>.
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
March 15, 2016, by Michael Wetter:<br/>
Changed the default value to <code>strict=true</code>
in order to avoid events when the controller saturates.
This is for
<a href=\"https://github.com/iea-annex60/modelica-annex60/issues/433\">issue 433</a>.
</li>
<li>
February 24, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(graphics={
        Rectangle(
          extent={{-6,-20},{66,-66}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          visible=(controllerType == Modelica.Blocks.Types.SimpleController.P),
          extent={{-32,-22},{68,-62}},
          lineColor={0,0,0},
          textString="P",
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175}),
        Text(
          visible=(controllerType == Modelica.Blocks.Types.SimpleController.PI),
          extent={{-28,-22},{72,-62}},
          lineColor={0,0,0},
          textString="PI",
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175}),
        Text(
          visible=(controllerType == Modelica.Blocks.Types.SimpleController.PD),
          extent={{-16,-22},{88,-62}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175},
          textString="P D"),
        Text(
          visible=(controllerType == Modelica.Blocks.Types.SimpleController.PID),
          extent={{-14,-22},{86,-62}},
          lineColor={0,0,0},
          textString="PID",
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175})}));
end LimPID;
