within IBPSA.Utilities.IO.SDF.Internal.Functions;
impure function makeDatasetInteger
  extends Modelica.Icons.Function;
  input String fileName;
  input String datasetName;
  input Integer value;
  input String comment;
  input String displayName;
  input String unit;
  input String displayUnit;
  input Boolean relativeQuantity;
  output String errorMessage;
protected
  Integer dims[:] = { 1};
  Integer data[1] = { value};
  external"C" errorMessage = ModelicaSDF_make_dataset_int(
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
end makeDatasetInteger;
