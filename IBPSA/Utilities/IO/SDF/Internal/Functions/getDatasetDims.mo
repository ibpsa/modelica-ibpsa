within IBPSA.Utilities.IO.SDF.Internal.Functions;
impure function getDatasetDims
  extends Modelica.Icons.Function;
  input String fileName;
  input String datasetName;
  output Integer dims[32];
external "C" ModelicaSDF_get_dataset_dims(fileName, datasetName, dims) annotation (
  Library={"ModelicaSDF"},
  LibraryDirectory="modelica://IBPSA/Utilities/IO/SDF/Resources/Library");
end getDatasetDims;
