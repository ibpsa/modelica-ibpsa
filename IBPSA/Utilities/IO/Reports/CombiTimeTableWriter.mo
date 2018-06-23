within IBPSA.Utilities.IO.Reports;
model CombiTimeTableWriter
  "Model for writing results to a format that is readable by the model CombiTimeTable"
  extends IBPSA.Utilities.IO.Reports.BaseClasses.FileWriter(final delimiter="\t");

protected
  function prependString
    "Prepend a string to an existing text file"
    extends Modelica.Icons.Function;
    input String fileName "Name of the file, including extension";
    input String string "Prepended string";
    external"C" prependString(fileName, string)
      annotation (
        Include="#include \"prependString.c\"",
        IncludeDirectory="modelica://IBPSA/Resources/C-Sources");
  end prependString;

initial algorithm
  str :="# time" + delimiter;
  for i in 1:nin-1 loop
    str :=str + headerNames[i] + delimiter;
  end for;
  str :=str + headerNames[nin];
  Modelica.Utilities.Streams.print(str, fileName);

equation
  // now that the file has been written completely, prepend the header
  // that is required for reading the csv file using combiTimeTables
  when terminal() then
    prependString(fileName,"#1\ndouble csv("+String(dataLinesWritten)+","+String(nin+1)+")\n");
  end when;
end CombiTimeTableWriter;
