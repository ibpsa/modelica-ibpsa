within Annex60.Utilities.Time.Examples;
model CalendarTime "Example for the calendar time model"
  extends Modelica.Icons.Example;
  Annex60.Utilities.Time.CalendarTime calendarTime2016(
    timRef=Annex60.Utilities.Time.BaseClasses.TimeReference.NY2016)
    "Computes date and time assuming time=0 corresponds to new year 2016"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Annex60.Utilities.Time.ModelTime modTim "Model time"
    annotation (Placement(transformation(extent={{-62,-10},{-42,10}})));

equation
  connect(modTim.y, calendarTime2016.tim) annotation (Line(points={{-41,0},{-30,
          0},{-22,0}},             color={0,0,127}));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    __Dymola_Commands(file="Resources/Scripts/Dymola/Utilities/Time/Examples/CalendarTime.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
    <ul>
<li>
August 3, 2016, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model demonstrates the use of the
<a href=\"modelica://Annex60.Utilities.Time.CalendarTime\">
Annex60.Utilities.Time.CalendarTime</a>
block.
</p>
</html>"),
    experiment(StopTime=1e+08));
end CalendarTime;
