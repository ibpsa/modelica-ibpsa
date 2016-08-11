within Annex60.Utilities.Time.Examples;
model CalendarTime
  extends Modelica.Icons.Example;
  // fixme: comment of calendarTime2016 should probably be changed
  // as time=0 should be a fixed time, such as zero unix time
  Annex60.Utilities.Time.CalendarTime calendarTime2016(
    timRef=Annex60.Utilities.Time.BaseClasses.TimeReference.NY2016)
    "Computes date and time assuming time=0 corresponds to new year 2016"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Annex60.Utilities.Time.ModelTime modTim "Model time"
    annotation (Placement(transformation(extent={{-62,-10},{-42,10}})));
   // fixme: comment of calendarTime2016 should probably be changed
  // as time=0 should be a fixed time, such as zero unix time
  Annex60.Utilities.Time.CalendarTime calendarTimeCustom(
    timRef=Annex60.Utilities.Time.BaseClasses.TimeReference.Custom,
    yearRef=2014,
    monthRef=5,
    dayRef=4,
    hourRef=12,
    minuteRef=30,
    secondRef=15)
    "Computes date and time assuming time=0 corresponds to 4th of may 2014, 12:30 and 15 seconds"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));

equation
  connect(modTim.y, calendarTime2016.tim) annotation (Line(points={{-41,0},{-30,
          0},{-30,30},{-22,30}},   color={0,0,127}));
  connect(calendarTimeCustom.tim, modTim.y) annotation (Line(points={{-22,-30},{
          -30,-30},{-30,0},{-41,0}},  color={0,0,127}));

  // fixme: the experiment StopTime annotation is missing, which is needed for the
  // model to be run by the OpenModelica regression tests
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
</html>"));
end CalendarTime;
