within IBPSA.Utilities.IO.Reports;
model CSVWriter "Model for writing results to a .csv file"
  extends Modelica.Blocks.Icons.DiscreteBlock;

  parameter Integer nin "Number of inputs"
    annotation(Evaluate=true, Dialog(connectorSizing=true));
  parameter String fileName = getInstanceName() + ".csv" "File name, including extension";
  parameter Modelica.SIunits.Time samplePeriod "Sample period";
  parameter String delimiter = "\t" "Delimiter for csv file"
    annotation(Dialog(tab="Advanced"));
  parameter Boolean writeHeader = true
    "=true, to specify header names, otherwise no header"
    annotation(Dialog(tab="Advanced"));
  parameter String[nin] headerNames = {"col"+String(i) for i in 1:nin}
    "Header names, indices by default"
    annotation(Dialog(enable=writeHeader, tab="Advanced"));
  Modelica.Blocks.Interfaces.RealVectorInput[nin] u "Variables that are saved"
     annotation (Placement(transformation(extent={{-130,20},{-90,-20}})));

protected
  parameter Modelica.SIunits.Time t0(fixed=false)
    "First sample time instant";
  parameter String insNam = getInstanceName() "Instance name";
  IBPSA.Utilities.IO.Reports.BaseClasses.FileWriter filWri=
    IBPSA.Utilities.IO.Reports.BaseClasses.FileWriter(insNam, fileName)
    "Data structure that ensure that each instance writes to a unique file";

  discrete String str "Intermediate variable for constructing a single line";
  output Boolean sampleTrigger "True, if sample time instant";

initial equation
  t0 = time;

initial algorithm
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

  annotation (
  defaultComponentName="csvWri",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-86,-54},{90,-96}},
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="%fileName"),                                        Text(
          extent={{-86,-54},{90,-96}},
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="%fileName"),                                        Text(
          extent={{-86,-16},{90,-58}},
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Right,
          textString="%samplePeriod")}),                         Diagram(
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
<p>
The parameter <code>fileName</code> defines to what file name the results
are stored. Results are saved in the current working directory
unless an absolute path is provided.
</p>
<p>
The parameter <code>samplePeriod</code> defines every how may seconds
the inputs are saved to the file. 
</p>
<h4>Options</h4>
<p>
The parameter <code>delimiter</code> can be used to choose a custom separator.
</p>
<p>
By default the first line of the csv file consists of the file header.
The column names can be defined using parameter <code>headerNames</code>
or the header can be removed by setting <code>writeHeader=false</code>
</p>
<h4>Dynamics</h4>
<p>
This model samples the outputs at an equidistant interval and
hence disregards the simulation tool output interval settings.
</p>
</html>"));
end CSVWriter;
