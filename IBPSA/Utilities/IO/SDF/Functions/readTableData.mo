within IBPSA.Utilities.IO.SDF.Functions;
impure function readTableData "Get the table data vector for a dataset. Format: {<number_of_dimensions>, <length_of_scale_1>,... <length_of_scale_N>, <values_of_scale_1>,... <values_of_scale_N>, <table_in_row_major_format>}"
  extends Modelica.Icons.Function;
  input String fileName "File Name";
  input String datasetName "Dataset Name";
  input String unit = "" "Expected Unit";
  input String scaleUnits[:] = {""} "Expected Scale Units" annotation (Dialog(enable=readFromFile));
  output Real data[getTableDataSize(fileName, datasetName)] "Table data vector";
protected
  String errorMessage;
algorithm
  (errorMessage, data) :=Internal.Functions.readTableData(
    fileName,
    datasetName,
    unit,
    scaleUnits,
    size(data, 1));
  assert(Modelica.Utilities.Strings.isEmpty(errorMessage), errorMessage);
end readTableData;
