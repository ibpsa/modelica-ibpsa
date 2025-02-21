within IBPSA.Utilities.IO.SDF.Functions;
impure function makeDatasetDouble "Create a scalar dataset of type double"
  extends Modelica.Icons.Function;
  input String fileName "File Name";
  input String datasetName "Dataset Name";
  input Real value "Value";
  input String comment = "" "Comment (optional)";
  input String displayName = "" "Display Name (optional)";
  input String unit = "" "Unit (optional)";
  input String displayUnit = "" "Display Unit (optional)";
  input Boolean relativeQuantity = false "Raltive Quantity";
protected
  String errorMessage;
algorithm
  errorMessage := SDF.Internal.Functions.makeDatasetDouble(
    fileName,
    datasetName,
    value,
    comment,
    displayName,
    unit,
    displayUnit,
    relativeQuantity);
  assert(Modelica.Utilities.Strings.isEmpty(errorMessage), errorMessage);
end makeDatasetDouble;
