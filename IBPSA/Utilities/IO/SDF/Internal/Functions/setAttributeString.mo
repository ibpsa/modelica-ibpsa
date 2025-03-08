within IBPSA.Utilities.IO.SDF.Internal.Functions;
impure function setAttributeString
  extends Modelica.Icons.Function;
  input String fileName;
  input String datasetName;
  input String attributeName;
  input String value;
  output String errorMessage;
external "C" errorMessage = ModelicaSDF_set_attribute_string(fileName, datasetName, attributeName, value) annotation (
  Library={"ModelicaSDF"},
  LibraryDirectory="modelica://IBPSA/Utilities/IO/SDF/Resources/Library");
end setAttributeString;
