within IBPSA.Utilities.IO.SDF.Internal.Functions;
impure function createGroup
  extends Modelica.Icons.Function;
  input String fileName;
  input String groupName;
  input String comment;
  output String errorMessage;
  external "C"  errorMessage = ModelicaSDF_create_group(fileName, groupName, comment) annotation (
  Library={"ModelicaSDF"},
  LibraryDirectory="modelica://IBPSA/Utilities/IO/SDF/Resources/Library");
end createGroup;
