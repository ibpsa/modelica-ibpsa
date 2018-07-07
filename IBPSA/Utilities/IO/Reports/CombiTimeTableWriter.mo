within IBPSA.Utilities.IO.Reports;
model CombiTimeTableWriter
  "Model for writing results to a format that is readable by the model CombiTimeTable"
  extends IBPSA.Utilities.IO.Reports.BaseClasses.FileWriter(
    final delimiter="\t",
    final isCombiTimeTable=true);


initial algorithm
  str :="# time" + delimiter;
  for i in 1:nin-1 loop
    str :=str + headerNames[i] + delimiter;
  end for;
  str :=str + headerNames[nin] + "\n";
  writeLine(filWri, str, 1);

end CombiTimeTableWriter;
