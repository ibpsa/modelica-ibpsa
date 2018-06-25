within IBPSA.Utilities.IO.Reports;
model CSVWriter
  "Model for writing results to a .csv file"
  extends IBPSA.Utilities.IO.Reports.BaseClasses.FileWriter(final isCombiTimeTable=false);


initial algorithm
  if writeHeader then
    str :=str+"time" + delimiter;
    for i in 1:nin-1 loop
      str :=str + headerNames[i] + delimiter;
    end for;
    str :=str + headerNames[nin];
    Modelica.Utilities.Streams.print(str, fileName);
  end if;

end CSVWriter;
