within IBPSA.BoundaryConditions.WeatherData.BaseClasses;
function getTimeSpanWeatherData
  "Get the time span of the weather data from the file"

  input String filNam "Name of weather data file";
  input String tabName "Name of weather table";
  output Modelica.SIunits.Time[2] timeSpan "start and end time of weather data";

protected
 String lin "Line that is used in parser";
 Integer iLin "Line number";
 Integer index =  0 "Index of string";
 Integer staInd "Start index used when parsing a real number";
 Integer nextIndex "dummy for return value of scanInteger / scanReal";
 Integer nrRows "number of rows in table";
 Boolean EOF "Flag, true if EOF has been reached";
 Boolean headerOn "still reading the header";
 Modelica.SIunits.Time avgIncrement "average time increment of weather data";
 Modelica.SIunits.Time startTime "end time of weather data";
 Modelica.SIunits.Time endTime "end time of weather data";

algorithm
  iLin :=0;
  EOF :=false;
  // Get line where table dimensions is defined
  while (not EOF) and (index == 0) loop
    iLin:=iLin + 1;
    (lin, EOF) :=Modelica.Utilities.Streams.readLine(fileName=filNam,
      lineNumber=iLin);
    index :=Modelica.Utilities.Strings.find(
      string=lin,
      searchString=tabName + "(",
      startIndex=1,
      caseSensitive=false);
  end while;
  assert(not EOF, "Error: Did not find definition of table" + tabName + " when scanning the weather file."
                      + "\n   Check for correct weather file syntax.");
  // Get number of rows
  staInd :=index + Modelica.Utilities.Strings.length(tabName) + 1;
  (nrRows, nextIndex) :=Modelica.Utilities.Strings.scanInteger(string=lin,
  startIndex=staInd);

  assert(nrRows > 1, "Error: Just " + String(nrRows) +" row in table " + tabName + " when scanning the weather file."
                      + "\n   You need at least two rows for the table");

  headerOn :=true;
  // Get first line of table
  while (not EOF) and (headerOn) loop
    iLin:=iLin + 1;
    (lin, EOF) :=Modelica.Utilities.Streams.readLine(fileName=filNam,
      lineNumber=iLin);
    index :=Modelica.Utilities.Strings.find(
    string=lin,
    searchString="#",
    startIndex=1,
    caseSensitive=false);
    if index == 0 then
      headerOn :=false;
    end if;
  end while;
  assert(not EOF, "Error: Did not find first line of table" + tabName + " when scanning the weather file."
                      + "\n   Check for correct weather file syntax.");
  // Get first time stamp
  (startTime, nextIndex) :=Modelica.Utilities.Strings.scanReal(string=lin,
  startIndex=1);
  // Get last line of table
  (lin, EOF) :=Modelica.Utilities.Streams.readLine(fileName=filNam,
   lineNumber= iLin + nrRows - 1);
   assert(not EOF, "Error: Did not find line number " + String( iLin + nrRows - 1) +  " in table" + tabName + " when scanning the weather file."
                      + "\n   Check for correct weather file syntax.");
  (endTime, nextIndex) :=Modelica.Utilities.Strings.scanReal(string=lin,
  startIndex=1);
  avgIncrement := (endTime - startTime) / (nrRows -1);
  timeSpan[1] :=startTime;
  timeSpan[2] :=endTime;

  annotation (Documentation(info="<html>
<p>This function returns the first and last time stamp, as well as the average increment of the TMY3 weather data file. </p>
</html>", revisions="<html>
<ul>
<li>
November 15, 2017, by Ana Constantin:<br/>
First implementation, as part of solution to <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/842\">#842</a>
</li>
</ul>
</html>"));
end getTimeSpanWeatherData;
