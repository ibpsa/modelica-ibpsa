within IBPSA.Controls.OBC.CDL.Reals.Validation;
model PIDInitialDerivativeOutput
  "Test model for LimPID controller with initial output of the derivative term specified"
  IBPSA.Controls.OBC.CDL.Reals.Sources.Constant ySet(
    k=0.75)
    "Set point"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  IBPSA.Controls.OBC.CDL.Reals.Sources.Constant yMea(
    k=0.75)
    "Measured value"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  IBPSA.Controls.OBC.CDL.Reals.PID limPID(
    controllerType=IBPSA.Controls.OBC.CDL.Types.SimpleController.PID,
    k=3,
    yd_start=0.2)
    "PID controller"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  IBPSA.Controls.OBC.CDL.Reals.PID limPD(
    controllerType=IBPSA.Controls.OBC.CDL.Types.SimpleController.PD,
    k=3,
    yd_start=0.2)
    "PD controller"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));

equation
  connect(ySet.y,limPID.u_s)
    annotation (Line(points={{-18,40},{0,40},{0,30},{18,30}},color={0,0,127}));
  connect(ySet.y,limPD.u_s)
    annotation (Line(points={{-18,40},{0,40},{0,-30},{18,-30}},color={0,0,127}));
  connect(yMea.y,limPID.u_m)
    annotation (Line(points={{-18,10},{30,10},{30,18}},color={0,0,127}));
  connect(yMea.y,limPD.u_m)
    annotation (Line(points={{-18,10},{-4,10},{-4,-50},{30,-50},{30,-42}},color={0,0,127}));
  annotation (
    experiment(
      StopTime=0.2,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://IBPSA/Resources/Scripts/Dymola/Controls/OBC/CDL/Reals/Validation/PIDInitialDerivativeOutput.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://IBPSA.Controls.OBC.CDL.Reals.PID\">
IBPSA.Controls.OBC.CDL.Reals.PID</a>.
</p>
<p>
This model validates setting the initial output of the controller to a specified value.
Note that the control error must be zero for the initial output to be at the specified value.
See the description of
<a href=\"modelica://IBPSA.Controls.OBC.CDL.Reals.PID\">
IBPSA.Controls.OBC.CDL.Reals.PID</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
April 8, 2020, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(
      coordinateSystem(
        extent={{-100,-100},{100,100}}),
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
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(
      coordinateSystem(
        extent={{-100,-100},{100,100}})));
end PIDInitialDerivativeOutput;
