within IBPSA.BoundaryConditions.WeatherData.BaseClasses.Examples;
model GetTimeSpanTMY3 "Test model to get time span of a weather file"
  extends Modelica.Icons.Example;

  parameter String filNam = Modelica.Utilities.Files.loadResource(
  "modelica://IBPSA/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    "Name of weather data file";
  parameter String tabNam = "tab1" "Name of table on weather file";

  final parameter String absFilNam = IBPSA.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath(filNam)
    "Absolute path of the file";

  parameter Modelica.SIunits.Time[2] timeSpan(fixed=false) "Start time, end time of weather data";

initial equation
  timeSpan = IBPSA.BoundaryConditions.WeatherData.BaseClasses.getTimeSpanTMY3(
  absFilNam, tabNam);
  Modelica.Utilities.Streams.print("Start time of weather file = " +
  String(timeSpan[1]) + "End time of weather file = " + String(timeSpan[2]) +
  "(end time stamp + calculated average increment)");
  assert(timeSpan[2] > timeSpan[1],
      "Error in weather file, end time " + String(timeSpan[2]) +
      ", smaller than start time " + String(timeSpan[1]));

  annotation (
    Documentation(info="<html>
<p>
This example tests getting the header of the TMY3 weather data file.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 15, 2019, by Ana Constantin:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://IBPSA/Resources/Scripts/Dymola/BoundaryConditions/WeatherData/BaseClasses/Examples/GetHeaderElement.mos"
        "Simulate and plot"));
end GetTimeSpanTMY3;
