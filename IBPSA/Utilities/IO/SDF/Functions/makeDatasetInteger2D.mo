within IBPSA.Utilities.IO.SDF.Functions;
impure function makeDatasetInteger2D "Create a 2-dimensional dataset of type integer"
  extends Modelica.Icons.Function;
  input String fileName "File Name";
  input String datasetName "Dataset Name";
  input Integer values[:,:] "Values";
  input String comment = "" "Comment (optional)";
  input String displayName = "" "Display Name (optional)";
  input String unit = "" "Unit (optional)";
  input String displayUnit = "" "Display Unit (optional)";
  input Boolean relativeQuantity = false "Raltive Quantity";
protected
  String errorMessage;
algorithm
  errorMessage := SDF.Internal.Functions.makeDatasetInteger2D(
    fileName,
    datasetName,
    values,
    comment,
    displayName,
    unit,
    displayUnit,
    relativeQuantity);
  assert(Modelica.Utilities.Strings.isEmpty(errorMessage), errorMessage);
end makeDatasetInteger2D;
