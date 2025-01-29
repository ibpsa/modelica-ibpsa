within IBPSA.Utilities.IO.SDF.Internal.Functions;
impure function makeDatasetDouble
  extends Modelica.Icons.Function;
  input String fileName;
  input String datasetName;
  input Real value;
  input String comment;
  input String displayName;
  input String unit;
  input String displayUnit;
  input Boolean relativeQuantity;
  output String errorMessage;
protected
  Integer dims[:] = { 1};
  Real data[1] = { value};
  external"C" errorMessage = ModelicaSDF_make_dataset_double(
          fileName,
          datasetName,
          0,
          dims,
          data,
          comment,
          displayName,
          unit,
          displayUnit,
          relativeQuantity) annotation (
  Library={"ModelicaSDF"},
  LibraryDirectory="modelica://IBPSA/Utilities/IO/SDF/Resources/Library");
end makeDatasetDouble;
