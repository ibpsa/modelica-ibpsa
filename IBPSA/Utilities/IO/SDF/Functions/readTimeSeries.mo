within IBPSA.Utilities.IO.SDF.Functions;
impure function readTimeSeries
  "Get the table data vector for a dataset. Format: {<number_of_dimensions>, <length_of_scale_1>,... <length_of_scale_N>, <values_of_scale_1>,... <values_of_scale_N>, <table_in_row_major_format>}"
  extends Modelica.Icons.Function;
  input String fileName "File Name";
  input String datasetNames[:] "Dataset Names";
  input String datasetUnits[:] = fill("", size(datasetNames, 1)) "Dataset Units";
  input String scaleUnit = "" "Scale Unit";
  output Real data[getTimeSeriesSize(fileName, datasetNames), size(datasetNames, 1) + 1] "Table data vector";
protected
  String errorMessage;
algorithm
  (errorMessage, data) :=Internal.Functions.readTimeSeries(
    fileName,
    datasetNames,
    datasetUnits,
    scaleUnit,
    size(data, 1));
  assert(Modelica.Utilities.Strings.isEmpty(errorMessage), errorMessage);
end readTimeSeries;
