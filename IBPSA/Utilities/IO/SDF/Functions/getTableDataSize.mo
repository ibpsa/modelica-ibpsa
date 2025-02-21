within IBPSA.Utilities.IO.SDF.Functions;
impure function getTableDataSize "Get the size of the table data vector for a dataset"
  extends Modelica.Icons.Function;
  input String fileName "File Name";
  input String datasetName "Dataset Name";
  output Integer length "Size of the table data vector returned by readTableData()";
protected
  String errorMessage;
algorithm
  (length, errorMessage) :=Internal.Functions.getTableDataSize(fileName, datasetName);
  assert(Modelica.Utilities.Strings.isEmpty(errorMessage), errorMessage);
  annotation(__Dymola_translate=true);
end getTableDataSize;
