within IBPSA.Utilities.IO.SDF.Functions;
impure function readDatasetInteger1D "Read a 1-dimensional dataset of type integer form an HDF5 fileRead a 1-dimensional dataset of type integer form an HDF5 file"
  extends Modelica.Icons.Function;
  input String fileName "File Name";
  input String datasetName "Dataset Name";
  input String unit = "" "Expected Unit (optional)";
  output Integer data[Internal.Functions.getDatasetDims(fileName, datasetName)*
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}];
protected
  String errorMessage;
algorithm
  (errorMessage,data) := SDF.Internal.Functions.readDatasetInteger1D(
    fileName,
    datasetName,
    unit);
  assert(Modelica.Utilities.Strings.isEmpty(errorMessage), errorMessage);
end readDatasetInteger1D;
