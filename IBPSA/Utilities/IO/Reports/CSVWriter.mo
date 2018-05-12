within IBPSA.Utilities.IO.Reports;
model CSVWriter "Model for writing results to a .csv file"
  extends Modelica.Blocks.Icons.Block;
  parameter Integer nin "Number of inputs"
    annotation(Evaluate=true, Dialog(connectorSizing=true));
  parameter String fileName = getInstanceName() + ".csv" "File name, including extension";
  parameter String delimiter = "\t" "Delimiter for csv file"
    annotation(Dialog(group="Options"));
  parameter Modelica.SIunits.Time samplePeriod "Sample interval";
  parameter Boolean writeHeader = true
    "=true, to specify header names, otherwise no header"
    annotation(Dialog(group="Options"));
  parameter String[nin] headerNames = {"col"+String(i) for i in 1:nin}
    "Header names, indices by default"
    annotation(Dialog(enable=writeHeader, group="Options"));
   Modelica.Blocks.Interfaces.RealVectorInput[nin] u "Variables that will be saved"
     annotation (Placement(transformation(extent={{-130,-20},{-90,20}})));

    function createFile
    "Create empty file"
      extends Modelica.Icons.Function;
      input String fileName "Name of the file, including extension";
      external"C" createFile(fileName)
        annotation (Include="#include <FileWriter.c>", IncludeDirectory="modelica://IBPSA/Resources/C-sources");
    end createFile;

protected
  parameter Modelica.SIunits.Time t0(fixed=false)
    "First sample time instant";
  discrete String str "Intermediate variable for constructing a single line";
  output Boolean sampleTrigger "True, if sample time instant";

initial equation
  t0 = time;

initial algorithm
  createFile(fileName);
  if writeHeader then
    str :="time" + delimiter;
    for i in 1:nin-1 loop
      str :=str + headerNames[i] + delimiter;
    end for;
    str :=str + headerNames[nin];
    Modelica.Utilities.Streams.print(str, fileName);
  end if;

equation
  sampleTrigger = sample(t0, samplePeriod);

algorithm
  when sampleTrigger then
    str :=String(time) + delimiter;
    for i in 1:nin-1 loop
      str :=str + String(u[i]) + delimiter;
    end for;
    str :=str + String(u[nin]);
    Modelica.Utilities.Streams.print(str, fileName);
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
The parameter <code>nin</code> defines the number of variables that are stored.
</p>
<h4>Options</h4>
<p>
The parameter <code>delimiter</code> can be used to choose a custom separator.
The parameter <code>samplePeriod</code> defines every how may seconds
the inputs are saved to the file. 
The parameter <code>startTime</code> defines when the first sample
should be saved.
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
end CSVWriter;
