within IBPSA.Utilities.IO.SDF.Internal.Functions;
impure function makeDatasetDouble1D
  extends Modelica.Icons.Function;
  input String fileName;
  input String datasetName;
  input Real values[:];
  input String comment;
  input String displayName;
  input String unit;
  input String displayUnit;
  input Boolean relativeQuantity;
  output String errorMessage;
protected
  Integer dims[:] = { size(values, 1)};

  external"C" errorMessage = ModelicaSDF_make_dataset_double(
          fileName,
          datasetName,
          1,
          dims,
          values,
          comment,
          displayName,
          unit,
          displayUnit,
          relativeQuantity) annotation (
  Library={"ModelicaSDF"},
  LibraryDirectory="modelica://IBPSA/Utilities/IO/SDF/Resources/Library");
end makeDatasetDouble1D;
