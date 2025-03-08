within IBPSA.Utilities.IO.SDF.Functions;
impure function readDatasetInteger "Read a scalar dataset of type integer form an HDF5 fileRead a scalar dataset of type integer form an HDF5 file"
  extends Modelica.Icons.Function;
  input String fileName "File Name";
  input String datasetName "Dataset Name";
  input String unit = "" "Expected Unit (optional)";
  output Integer data;
protected
  String errorMessage;
algorithm
  (errorMessage,data) := SDF.Internal.Functions.readDatasetInteger(
    fileName,
    datasetName,
    unit);
  assert(Modelica.Utilities.Strings.isEmpty(errorMessage), errorMessage);
end readDatasetInteger;
