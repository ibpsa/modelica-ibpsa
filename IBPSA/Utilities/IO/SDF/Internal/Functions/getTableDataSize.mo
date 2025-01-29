within IBPSA.Utilities.IO.SDF.Internal.Functions;
impure function getTableDataSize
  extends Modelica.Icons.Function;
  input String fileName;
  input String datasetName;
  output Integer length;
  output String errorMessage;
  external "C" errorMessage = ModelicaSDF_get_table_data_size(fileName, datasetName, length) annotation (
  Library={"ModelicaSDF"},
  LibraryDirectory="modelica://IBPSA/Utilities/IO/SDF/Resources/Library");
end getTableDataSize;
