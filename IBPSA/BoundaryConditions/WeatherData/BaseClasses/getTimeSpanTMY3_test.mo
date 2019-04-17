within IBPSA.BoundaryConditions.WeatherData.BaseClasses;
function getTimeSpanTMY3_test
  "Get the time span of the weather data from the file"

  input String filNam "Name of weather data file";
  input String tabNam "Name of table on weather file";
  output Modelica.SIunits.Time startTime;
  output Modelica.SIunits.Time endTime;
  //output Modelica.SIunits.Time[2] timeSpan "Start time, end time of weather data";

external "C" getTimeSpan(filNam, tabNam, startTime, endTime)
  annotation (
  Include="#include <getTimeSpan.c>",
  IncludeDirectory="modelica://IBPSA/Resources/C-Sources");

  annotation (Documentation(info="<html>
<p>
This function returns the start time (first time stamp) and end time
(last time stamp + average increment) of the TMY3 weather data file.
</p>
</html>", revisions="<html>
<ul>
<li>
November 15, 2017, by Ana Constantin:<br/>
First implementation, as part of solution to <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/842\">#842</a>.
</li>
</ul>
</html>"));
end getTimeSpanTMY3_test;
