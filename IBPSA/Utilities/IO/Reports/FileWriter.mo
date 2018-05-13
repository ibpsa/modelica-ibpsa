within IBPSA.Utilities.IO.Reports;
class FileWriter
  "Class used to ensure that each CSV writer writes to a unique file"
extends ExternalObject;
    function constructor
    "Construct an extendable array that can be used to store double valuesCreate empty file"
      extends Modelica.Icons.Function;
      input String instanceName "Instance name of the file write";
      input String fileName "Name of the file, including extension";
      output FileWriter fileWriter "Pointer to the file writer";
      external"C" fileWriter = fileWriterInit(instanceName, fileName)
        annotation (
          Include="#include <fileWriterInit.c>",
          IncludeDirectory="modelica://IBPSA/Resources/C-Sources");

    annotation(Documentation(info="<html>
<p>
Creates an empty file with name <code>fileName</code>.
If <code>fileName</code> is used in another instance of
<a href=\"modelica://IBPSA.Utilities.IO.Reports.CSVWriter\">
IBPSA.Utilities.IO.Reports.CSVWriter</a>,
the simulation stops with an error.
</p>
</html>", revisions="<html>
c
</html>"));
    end constructor;

  function destructor "Release storage of table and close the external object"
    input FileWriter fileWriter "Pointer to file writer object";
    external "C" fileWriterFree(fileWriter)
    annotation(Include=" #include <fileWriterFree.c>",
    IncludeDirectory="modelica://Buildings/Resources/C-Sources");
  annotation(Documentation(info="<html>
<p>
Destructor that frees the memory of the object
<code>FileWriter</code>.
</p>
</html>",
  revisions="<html>
<ul>
<li>
May 12, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
  end destructor;

annotation(Documentation(info="<html>
<p>
Class derived from <code>ExternalObject</code> having two local external function definition,
named <code>destructor</code> and <code>constructor</code> respectively.
<p>
These functions create and release an external object that allows the storage
of real parameters in an array of extendable dimension.

</html>",
revisions="<html>
<ul>
<li>
July 28 2011, by Pierre Vigouroux:<br/>
First implementation.
</li>
</ul>
</html>"));
end FileWriter;
