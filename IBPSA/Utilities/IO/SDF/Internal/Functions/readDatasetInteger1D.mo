within IBPSA.Utilities.IO.SDF.Internal.Functions;
impure function readDatasetInteger1D
  extends Modelica.Icons.Function;
  input String fileName;
  input String datasetName;
  input String unit;
  output String errorMessage;
  output Integer data[getDatasetDims(fileName, datasetName)*{1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}];
  external "C" errorMessage= ModelicaSDF_read_dataset_int(fileName, datasetName, unit, data) annotation (
  Library={"ModelicaSDF"},
  LibraryDirectory="modelica://IBPSA/Utilities/IO/SDF/Resources/Library");
end readDatasetInteger1D;
