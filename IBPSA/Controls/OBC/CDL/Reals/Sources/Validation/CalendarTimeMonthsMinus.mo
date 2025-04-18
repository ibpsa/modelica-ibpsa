within IBPSA.Controls.OBC.CDL.Reals.Sources.Validation;
model CalendarTimeMonthsMinus
  "Validation model for the calendar time model with start time slightly below the full hour"
  extends IBPSA.Controls.OBC.CDL.Reals.Sources.Validation.CalendarTimeMonths;
  annotation (
    experiment(
      StartTime=172799,
      Tolerance=1e-6,
      StopTime=345599),
    __Dymola_Commands(
      file="modelica://IBPSA/Resources/Scripts/Dymola/Controls/OBC/CDL/Reals/Sources/Validation/CalendarTimeMonthsMinus.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
This model validates the use of the
<a href=\"modelica://IBPSA.Controls.OBC.CDL.Reals.Sources.CalendarTime\">
IBPSA.Controls.OBC.CDL.Reals.Sources.CalendarTime</a>.
It is identical to
<a href=\"modelica://IBPSA.Controls.OBC.CDL.Reals.Sources.Validation.CalendarTimeMonths\">
IBPSA.Controls.OBC.CDL.Reals.Sources.Validation.CalendarTimeMonths</a>
except that the start and end time are different.
</p>
</html>",
      revisions="<html>
<ul>
<li>
July 18, 2017, by Jianjun Hu:<br/>
First implementation in CDL.
</li>
</ul>
</html>"));
end CalendarTimeMonthsMinus;
