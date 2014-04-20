within IDEAS.Climate.Meteo;
package TMY3
   extends Modelica.Icons.Package;

  function getAbsolutePath "Gets the absolute path of a URI"
    input String uri "A uri";
    output String path "The absolute path of the file pointed to by the URI";

  protected
    function loadResource
      input String name "Name of the resource";
      output String path
        "Full path of the resource, or a string of length 0 if it does not exist";
    algorithm
      path :=ModelicaServices.ExternalReferences.loadResource(name);
      if Modelica.Utilities.Strings.length(path) > 0 then
        path := Modelica.Utilities.Files.fullPathName(name=path);
      end if;
    end loadResource;

  algorithm
    // If uri does not start with file:// or modelica://, then add file:// to it.
    // This is done because a data reader uses as a parameter the file name without file://
    if (Modelica.Utilities.Strings.find(uri, "file://", startIndex=1, caseSensitive=false) == 0
    and Modelica.Utilities.Strings.find(uri, "modelica://", startIndex=1, caseSensitive=false) == 0) then
    // try file://+uri
      path := loadResource("file://" + uri);
      if not Modelica.Utilities.Files.exist(path) then
        // try modelica://+uri
        path := loadResource("modelica://" + uri);
        if not Modelica.Utilities.Files.exist(path) then
          // try modelica://Buildings/+uri
          path := loadResource("modelica://Buildings/" + uri);

          assert(Modelica.Utilities.Files.exist(path), "File '" + uri + "' does not exist.
  Expected to find either 'file://"   + uri + "
                       or 'modelica://"   + uri + " +
                       or 'modelica://Buildings/"   + uri);
        end if;
      end if;
    else
      path := ModelicaServices.ExternalReferences.loadResource(uri);
      path := Modelica.Utilities.Files.fullPathName(name=path);

      assert(Modelica.Utilities.Files.exist(path), "File '" + uri + "' does not exist.");

    end if;

    annotation (Documentation(info="<html>
<p>
This function returns the absolute path of the uniform resource identifier
by searching for a file with the name
</p>
<pre>
file://uri
modelica://uri
modelica://Buildings/uri
</pre>
<p>
The function returns the absolute path of the first file that is found, using the above search order.
If the file is not found, then this function terminates with an <code>assert</code>.
</p>
<p>
This function has been introduced to allow users to specify the name of weather data
files with a path that is relative to the library path.
This allows users to change the current working directory while still being able to read
the files.
</p>                       
</html>",   revisions="<html>
<ul>
<li>
October 8, 2013, by Michael Wetter:<br/>
Improved algorithm that determines the absolute path of the file.
Now the function works from any directory as long as the <code>Buildings</code> library
is on the <code>MODELICAPATH</code>.
</li>
<li>
May 2, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
  end getAbsolutePath;

  function getHeaderElementTMY3
    "Gets an element from the header of a TMY3 weather data file"
   input String filNam "Name of weather data file"
   annotation (Dialog(
          __Dymola_loadSelector(filter="Weather files (*.mos)", caption=
              "Select weather file")));
   input String start "Start of the string that contains the elements";
   input String name "Name of data element, used in error reporting";
   input Integer position(min=1)
      "Position of the element on the line that contains 'start'";
   output String element
      "Element at position 'pos' of the line that starts with 'start'";
  protected
   String lin "Line that is used in parser";
   Integer iLin "Line number";
   Integer index =  0 "Index of string #LOCATION";
   Integer staInd "Start index used when parsing a real number";
   Integer nexInd "Next index used when parsing a real number";
   Boolean found "Flag, true if #LOCATION has been found";
   Boolean EOF "Flag, true if EOF has been reached";
   String fouDel "Found delimiter";
  algorithm
    // Get line that starts with 'start'
    iLin :=0;
    EOF :=false;
    while (not EOF) and (index == 0) loop
      iLin:=iLin + 1;
      (lin, EOF) :=Modelica.Utilities.Streams.readLine(fileName=getAbsolutePath(filNam),
        lineNumber=iLin);
      index :=Modelica.Utilities.Strings.find(
        string=lin,
        searchString=start,
        startIndex=1,
        caseSensitive=false);
    end while;
    assert(not EOF, "Error: Did not find '" + start + "' when scanning the weather file."
                        + "\n   Check for correct weather file syntax.");
    // Loop over the tokens until the position is reached
    nexInd :=1;
    for i in 1:position-1 loop
    nexInd :=Modelica.Utilities.Strings.find(
        string=lin,
        searchString=  ",",
        startIndex=nexInd+1);
     assert(nexInd > 0, "Error when scanning weather file. Not enough tokens to find " + name + "."
           + "\n   Check for correct file syntax." + "\n   The scanned line is '" +
          lin + "'.");
    end for;
    staInd := nexInd;
    // Find the next delimiter
    nexInd :=Modelica.Utilities.Strings.find(
        string=lin,
        searchString=  ",",
        startIndex=nexInd+1);
    assert(nexInd > 0, "Error when scanning weather file. Not enough tokens to find " + name + "."
           + "\n   Check for correct file syntax." + "\n   The scanned line is '" +
           lin + "'.");
    // Get the element
    element :=Modelica.Utilities.Strings.substring(lin, startIndex=staInd+1, endIndex=nexInd-1);
    annotation (Inline=false,
    Documentation(info="<html>
This function scans the weather data file for a line that starts with the string <pre>
start
</pre>
where <code>start</code> is a parameter.
When this line is found, the function returns the element at the position number
<code>position</code>, where <code>position</code> is a parameter.
A comma is used as the delimiter of the elements.
</html>",   revisions="<html>
<ul>
<li>
May 2, 2013, by Michael Wetter:<br/>
Added function call to <code>getAbsolutePath</code>.
</li>
<li>
February 25, 2012, by Michael Wetter:<br/>
Removed default value for parameter <code>name</code>.
</li>
<li>
March 5, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
  end getHeaderElementTMY3;

  function getLatitudeTMY3 "Gets the latitude from a TMY3 weather data file"
   input String filNam "Name of weather data file"
   annotation (Dialog(
          __Dymola_loadSelector(filter="Weather files (*.mos)", caption=
              "Select weather file")));
   output Modelica.SIunits.Angle lat "Latitude from the weather file";
  protected
   Integer nexInd "Next index, used for error handling";
   String element "String representation of the returned element";
  algorithm
    element :=
      Buildings.BoundaryConditions.WeatherData.BaseClasses.getHeaderElementTMY3(
        filNam=filNam,
        start="#LOCATION",
        name=  "longitude",
        position=7);
     (nexInd, lat) :=Modelica.Utilities.Strings.Advanced.scanReal(
      string=element,
      startIndex=1,
      unsigned=false);
     assert(nexInd > 1, "Error when converting the latitude '" +
                        element + "' from a String to a Real.");
     // Convert from degree to rad
     lat :=lat*Modelica.Constants.pi/180;
     // Check if latitude is valid
     assert(abs(lat) <= Modelica.Constants.pi+Modelica.Constants.eps,
         "Wrong value for latitude. Received lat = " +
         String(lat) + " (= " + String(lat*180/Modelica.Constants.pi) + " degrees).");

    annotation (Documentation(info="<html>
This function returns the latitude of the TMY3 weather data file.
</html>",   revisions="<html>
<ul>
<li>
February 25, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
  end getLatitudeTMY3;

  function getLongitudeTMY3 "Gets the longitude from a TMY3 weather data file"
   input String filNam "Name of weather data file"
   annotation (Dialog(
          __Dymola_loadSelector(filter="Weather files (*.mos)", caption=
              "Select weather file")));
   output Modelica.SIunits.Angle lon "Longitude from the weather file";
  protected
   Integer nexInd "Next index, used for error handling";
   String element "String representation of the returned element";
  algorithm
    element :=
      Buildings.BoundaryConditions.WeatherData.BaseClasses.getHeaderElementTMY3(
        filNam=filNam,
        start="#LOCATION",
        name=  "longitude",
        position=8);
     (nexInd, lon) :=Modelica.Utilities.Strings.Advanced.scanReal(
      string=element,
      startIndex=1,
      unsigned=false);
     assert(nexInd > 1, "Error when converting the longitude '" +
                        element + "' from a String to a Real.");
     // Convert from degree to rad
     lon :=lon*Modelica.Constants.pi/180;
     // Check if longitude is valid
     assert(abs(lon) < 2*Modelica.Constants.pi,
         "Wrong value for longitude. Received lon = " +
         String(lon) + " (= " + String(lon*180/Modelica.Constants.pi) + " degrees).");

    annotation (Documentation(info="<html>
This function returns the longitude of the TMY3 weather data file.
</html>",   revisions="<html>
<ul>
<li>
March 5, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
  end getLongitudeTMY3;

  function getTimeZoneTMY3 "Gets the time zone from a TMY3 weather data file"
   input String filNam "Name of weather data file"
   annotation (Dialog(
          __Dymola_loadSelector(filter="Weather files (*.mos)", caption=
              "Select weather file")));
   output Modelica.SIunits.Time timZon "Time zone from the weather file";
  protected
   Integer nexInd "Next index, used for error handling";
   String element "String representation of the returned element";
  algorithm
    element :=
      Buildings.BoundaryConditions.WeatherData.BaseClasses.getHeaderElementTMY3(
        filNam=filNam,
        start="#LOCATION",
        name=  "longitude",
        position=9);
     (nexInd, timZon) :=Modelica.Utilities.Strings.Advanced.scanReal(
      string=element,
      startIndex=1,
      unsigned=false);
     assert(nexInd > 1, "Error when converting the time zone '" +
                        element + "' from a String to a Real.");
     timZon :=timZon*3600;
     // Check if time zone is valid
     assert(abs(timZon) < 24*3600,
         "Wrong value for time zone. Received timZon = " +
         String(timZon) + " (= " + String(timZon/3600) + " hours).");

    annotation (Documentation(info="<html>
This function returns the time zone of the TMY3 weather data file.
</html>",   revisions="<html>
<ul>
<li>
March 5, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
  end getTimeZoneTMY3;

end TMY3;
