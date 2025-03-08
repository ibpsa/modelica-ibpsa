within IBPSA.Utilities.IO.SDF.Internal.Functions;
impure function getAttributeStringLength
  extends Modelica.Icons.Function;
  input String fileName;
  input String datasetName;
  input String attributeName;
  output Integer length;
protected
  String errorMessage;
algorithm
  (errorMessage, length) := internalGetAttributeStringLength(
    fileName,
    datasetName,
    attributeName);
  assert(Modelica.Utilities.Strings.isEmpty(errorMessage), errorMessage);
end getAttributeStringLength;
