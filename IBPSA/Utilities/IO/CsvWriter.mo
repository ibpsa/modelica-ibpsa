within IBPSA.Utilities.IO;
model CsvWriter "Model for writing results to a .csv file"
  extends Modelica.Blocks.Icons.Block;
  parameter Integer nIn "Number of inputs";
  parameter String fileName = "result.csv" "File name, including extension";
  parameter String delimiter = "\t" "Delimiter for csv file"
    annotation(Dialog(group="Options"));
  parameter Real sampleTime "Sample interval";
  parameter Boolean writeHeader = true
    "=true, to specify header names, otherwise no header"
    annotation(Dialog(group="Options"));
  parameter String[nIn] headerNames = {"col"+String(i) for i in 1:nIn}
    "Header names, indices by default"
    annotation(Dialog(enable=writeHeader, group="Options"));

   Modelica.Blocks.Interfaces.RealInput[nIn] u "Variables that will be saved"
     annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

    function createFile
    "Create empty file"
      extends Modelica.Icons.Function;
      input String fileName "Name of the file, including extension";
      external"C" createFile(fileName)
        annotation (Include="#include <FileWriter.c>", IncludeDirectory="modelica://IBPSA/Resources/C-sources");
    end createFile;

    function appendString
    "Append string to existing file"
      extends Modelica.Icons.Function;
      input String fileName "Name of the file, including extension";
      input String string "String that is appended";
      input Real tim "Time";
      output Real y "Dummy return value for ensuring that function is evaluated";
      external"C" y = appendString(fileName, string, tim)
        annotation (Include="#include <FileWriter.h>", IncludeDirectory="modelica://IBPSA/Resources/C-sources");
    end appendString;

protected
  discrete String str "Intermediate variable for constructing a single line";
initial algorithm
  createFile(fileName);
  if writeHeader then
    str :="time" + delimiter;
    for i in 1:nIn-1 loop
      str :=str + headerNames[i] + delimiter;
    end for;
    str :=str + headerNames[nIn] + "\n";
    appendString(fileName, str, time);
  end if;


algorithm
  when sample(sampleTime,sampleTime) or initial() then
    str :=String(time) + delimiter;
    for i in 1:nIn-1 loop
      str :=str + String(u[i]) + delimiter;
    end for;
    str :=str + String(u[nIn]) + "\n";
    appendString(fileName, str, time);
  end when;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{2,-54},{92,-92}},
          lineColor={28,108,200},
          textString=".csv")}),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
May 10, 2018 by Filip Jorissen:<br/>
First implementation.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/924\">#924</a>.
</li>
</ul>
</html>",
        info="<html>
<p>This model samples the model inputs <code>u</code> and saves them to a .csv file,
which can directly be read using e.g. excel or python.</p>
</p>
<h4>Typical use and important parameters</h4>
<p>
The parameter <code>nIn</code> defines the number of variables that are stored.

</p>
<h4>Options</h4>
<p>
The parameter <code>delimiter</code> can be used to choose a custom separator.
The parameter <code>sampleTime</code> defines every how may seconds
the inputs are saved to the file. 
Inputs are also saved at the start time and end time of the simulation.
</p>
<h4>Dynamics</h4>
<p>
This model samples the outputs at an equidistant interval and
hence disregards the simulation tool output interval settings.
</p>
<h4>Implementation</h4>
<p>
Function <code>createFile</code> includes the .c file while
function <code>appendFile</code> includes the .h file.
Otherwise the c functions are defined multiple time when the 
.c file is included twice, or the function bodies are undefined
when the .h file is included twice.
</p>"));
end CsvWriter;
