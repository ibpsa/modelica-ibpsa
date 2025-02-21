within IBPSA.Utilities.IO.SDF.Functions;
impure function createGroup "Create a group in an HDF5 file"
  extends Modelica.Icons.Function;
  input String fileName "File Name";
  input String groupName "Group Name";
  input String comment = "" "Comment (optional)";
protected
  String errorMessage;
algorithm
  (errorMessage) := SDF.Internal.Functions.createGroup(
    fileName,
    groupName,
    comment);
  assert(Modelica.Utilities.Strings.isEmpty(errorMessage), errorMessage);
end createGroup;
