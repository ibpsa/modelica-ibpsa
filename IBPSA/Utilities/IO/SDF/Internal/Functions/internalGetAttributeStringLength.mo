within IBPSA.Utilities.IO.SDF.Internal.Functions;
impure function internalGetAttributeStringLength
  extends Modelica.Icons.Function;
  input String fileName;
  input String datasetName;
  input String attributeName;
  output String errorMessage;
  output Integer length;
external "C" errorMessage = ModelicaSDF_get_attribute_string_length(fileName, datasetName, attributeName, length) annotation (
  Library={"ModelicaSDF"},
  LibraryDirectory="modelica://IBPSA/Utilities/IO/SDF/Resources/Library");
end internalGetAttributeStringLength;
