within IBPSA.BoundaryConditions.WeatherData.BaseClasses;
model testGetTimeSpan "Test model to get time span of a weather file"
  extends Modelica.Icons.Example;

  parameter String filNam = Modelica.Utilities.Files.loadResource(
  "modelica://IBPSA/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    "Name of weather data file";
  parameter String tabNam = "tab1" "Name of table on weather file";

  parameter Modelica.SIunits.Time startTime(fixed=false);
  parameter Modelica.SIunits.Time endTime(fixed=false);
  //parameter Modelica.SIunits.Time[2] timeSpan "Start time, end time of weather data";

initial equation
  (startTime,endTime) = IBPSA.BoundaryConditions.WeatherData.BaseClasses.getTimeSpanTMY3_test(
  filNam, tabNam);

//   assert(abs(timeSpan[2]-365*24*3600.) < 1E-5  and abs(timeSpan[1]) < 1E-5,
//       "Error in weather file, start time " + String(timeSpan[1]) +
//       " and end time " + String(timeSpan[2]) + ", but expected 0 and 31536000.");

  annotation (
    Documentation(info="<html>
<p>
This example tests getting the header of the TMY3 weather data file.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 16, 2019, by Michael Wetter:<br/>
Removed call to get the absolute path of the file, corrected the <code>.mos</code>
file name and updated the documentation
</li>
<li>
April 15, 2019, by Ana Constantin:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://IBPSA/Resources/Scripts/Dymola/BoundaryConditions/WeatherData/BaseClasses/Examples/GetTimeSpanTMY3.mos"
        "Simulate and plot"));
end testGetTimeSpan;
