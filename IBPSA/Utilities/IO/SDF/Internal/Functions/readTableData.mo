within IBPSA.Utilities.IO.SDF.Internal.Functions;
impure function readTableData
  extends Modelica.Icons.Function;
  input String fileName;
  input String datasetName;
  input String unit;
  input String scaleUnits[:];
  input Integer length;
  output String errorMessage;
  output Real data[length];
  external "C" errorMessage= ModelicaSDF_read_table_data(fileName, datasetName, size(scaleUnits, 1), unit, scaleUnits, data) annotation (
  Library={"ModelicaSDF"},
  LibraryDirectory="modelica://IBPSA/Utilities/IO/SDF/Resources/Library");
end readTableData;
