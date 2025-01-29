within IBPSA.Utilities.IO.SDF.Functions;
impure function setAttributeString "Set a string attribute for a dataset"
  extends Modelica.Icons.Function;
  input String fileName "File Name";
  input String datasetName "Dataset Name";
  input String attributeName "Attribute Name";
  input String value "Attribute Value";
protected
  String errorMessage;
algorithm
  errorMessage :=Internal.Functions.setAttributeString(
    fileName,
    datasetName,
    attributeName,
    value);
  assert(Modelica.Utilities.Strings.isEmpty(errorMessage), errorMessage);
end setAttributeString;
