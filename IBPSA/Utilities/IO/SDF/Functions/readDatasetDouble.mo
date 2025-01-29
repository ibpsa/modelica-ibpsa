within IBPSA.Utilities.IO.SDF.Functions;
impure function readDatasetDouble "Read a scalar dataset of type double from an HDF5 file"
  extends Modelica.Icons.Function;
  input String fileName "File Name";
  input String datasetName "Dataset Name";
  input String unit = "" "Expected Unit (optional)";
  output Real data;
protected
  String errorMessage;
algorithm
  (errorMessage,data) := SDF.Internal.Functions.readDatasetDouble(
    fileName,
    datasetName,
    unit);
  assert(Modelica.Utilities.Strings.isEmpty(errorMessage), errorMessage);
end readDatasetDouble;
