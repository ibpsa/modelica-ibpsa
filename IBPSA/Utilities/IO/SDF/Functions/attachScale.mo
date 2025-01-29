within IBPSA.Utilities.IO.SDF.Functions;
impure function attachScale "Set one dataset as the scale for a dimension of another dataset"
  extends Modelica.Icons.Function;
  input String fileName "File Name";
  input String datasetName "Dataset Name";
  input String scaleName "Scale Name";
  input String dimensionName = "" "Dimension Name (optional)";
  input Integer dimension "Dimension Index";
protected
  String errorMessage;
algorithm
  errorMessage := SDF.Internal.Functions.attachScale(
    fileName,
    datasetName,
    scaleName,
    dimensionName,
    dimension - 1);
  assert(Modelica.Utilities.Strings.isEmpty(errorMessage), errorMessage);
end attachScale;
