within IBPSA.Utilities.IO.SDF.Functions;
impure function getAttributeString "Get a string attribute for a dataset"
  extends Modelica.Icons.Function;
  input String fileName "File Name";
  input String datasetName "Dataset Name";
  input String attributeName "Attribute Name";
  output String value "Attribute Value";
protected
  String errorMessage;
algorithm
  (errorMessage,value) :=Internal.Functions.getAttributeString(
    fileName,
    datasetName,
    attributeName);
  assert(Modelica.Utilities.Strings.isEmpty(errorMessage), errorMessage);
end getAttributeString;
