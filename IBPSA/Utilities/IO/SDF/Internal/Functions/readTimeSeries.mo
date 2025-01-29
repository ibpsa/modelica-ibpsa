within IBPSA.Utilities.IO.SDF.Internal.Functions;
impure function readTimeSeries
  extends Modelica.Icons.Function;
  input String fileName;
  input String datasetNames[:];
  input String datasetUnits[:];
  input String scaleUnit;
  input Integer nsamples;
  output String errorMessage;
  output Real data[nsamples, size(datasetNames, 1) + 1];
  external "C" errorMessage= ModelicaSDF_read_time_series(fileName, size(datasetNames, 1), datasetNames, datasetUnits, scaleUnit, nsamples, data) annotation (
  Library={"ModelicaSDF"},
  LibraryDirectory="modelica://IBPSA/Utilities/IO/SDF/Resources/Library");
end readTimeSeries;
