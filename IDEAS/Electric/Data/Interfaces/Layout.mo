within IDEAS.Electric.Data.Interfaces;
partial record Layout "Describes a grid based on a grid layout"

  extends Modelica.Icons.MaterialProperty;

  parameter Integer nNodes(min=1) "number of nodes  in the grid layout";
  parameter Integer[nNodes,:] nodeMatrix
    "Node-matrix describing the connection between the nodes";

end Layout;
