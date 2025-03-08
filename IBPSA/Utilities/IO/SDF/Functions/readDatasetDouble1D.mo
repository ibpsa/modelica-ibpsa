within IBPSA.Utilities.IO.SDF.Functions;
impure function readDatasetDouble1D "Read a 1-dimensional dataset of type double form an HDF5 file"
  extends Modelica.Icons.Function;
  input String fileName "File Name";
  input String datasetName "Dataset Name";
  input String unit = "" "Expected Unit (optional)";
  output Real data[Internal.Functions.getDatasetDims(fileName, datasetName)*{1,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}];
protected
  String errorMessage;
algorithm
  (errorMessage,data) := SDF.Internal.Functions.readDatasetDouble1D(
    fileName,
    datasetName,
    unit);
  assert(Modelica.Utilities.Strings.isEmpty(errorMessage), errorMessage);
end readDatasetDouble1D;
