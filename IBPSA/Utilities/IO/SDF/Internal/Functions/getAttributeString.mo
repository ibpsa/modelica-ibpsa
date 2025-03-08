within IBPSA.Utilities.IO.SDF.Internal.Functions;
impure function getAttributeString
  extends Modelica.Icons.Function;
  input String fileName;
  input String datasetName;
  input String attributeName;
  output String errorMessage;
  output String buffer = Modelica.Utilities.Strings.repeat(getAttributeStringLength(fileName, datasetName, attributeName));
external "C" errorMessage = ModelicaSDF_get_attribute_string(fileName, datasetName, attributeName, buffer) annotation (
  Library={"ModelicaSDF"},
  LibraryDirectory="modelica://IBPSA/Utilities/IO/SDF/Resources/Library");
end getAttributeString;
