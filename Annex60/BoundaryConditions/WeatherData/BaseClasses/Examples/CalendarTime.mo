within Annex60.BoundaryConditions.WeatherData.BaseClasses.Examples;
model CalendarTime
  import Annex60;
  Annex60.BoundaryConditions.WeatherData.BaseClasses.CalendarTime calendarTime(
      timRef=Annex60.BoundaryConditions.WeatherData.BaseClasses.TimeReference.NY2013)
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Annex60.Utilities.Time.ModelTime modTim
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
equation
  connect(modTim.y, calendarTime.tim)
    annotation (Line(points={{-39,30},{-20.6,30}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end CalendarTime;
