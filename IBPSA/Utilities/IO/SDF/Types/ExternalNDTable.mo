within IBPSA.Utilities.IO.SDF.Types;
class ExternalNDTable "External object of NDTable"
  extends ExternalObject;

  function constructor "Initialize table"
      input Integer ndims;
      input Real data[:];
      output ExternalNDTable externalTable;
  external"C" externalTable =
        ModelicaNDTable_open(ndims, data, size(data, 1)) annotation (
    Include="#include <ModelicaNDTable.c>",
    IncludeDirectory="modelica://IBPSA/Utilities/IO/SDF/Resources/C-Sources");

  end constructor;

  function destructor "Close table"
    input ExternalNDTable externalTable;
  external"C" ModelicaNDTable_close(externalTable) annotation (
  Include="#include <ModelicaNDTable.c>",
  IncludeDirectory="modelica://IBPSA/Utilities/IO/SDF/Resources/C-Sources");
  end destructor;

end ExternalNDTable;
