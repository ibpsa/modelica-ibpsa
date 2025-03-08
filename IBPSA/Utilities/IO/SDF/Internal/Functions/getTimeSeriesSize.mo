within IBPSA.Utilities.IO.SDF.Internal.Functions;
impure function getTimeSeriesSize
  extends Modelica.Icons.Function;
  input String fileName;
  input String datasetNames[:];
  output Integer length;
  output String errorMessage;
  external "C" errorMessage = ModelicaSDF_get_time_series_size(fileName, datasetNames, length) annotation (
  Library={"ModelicaSDF"},
  LibraryDirectory="modelica://IBPSA/Utilities/IO/SDF/Resources/Library");
end getTimeSeriesSize;
