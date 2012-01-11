within IDEAS.Electric.Data.Interfaces;
record GridImp "Describe a grid by matrices of layout and impedances"
extends Modelica.Icons.MaterialProperty;
//extends IDEAS.Electric.Data.Interfaces.GridLayout;
//parameter Integer n(min=1);
//parameter Integer T_matrix[nNodes,nNodes];

parameter Integer nNodes "number of nodes  in the grid layout";

parameter Integer[nNodes,nNodes] nodeMatrix
    "Node-matrix describing the connection between the nodes";

parameter Modelica.SIunits.Resistance R[nNodes];
parameter Modelica.SIunits.Reactance X[nNodes];
parameter Modelica.SIunits.ComplexImpedance Z[nNodes](re=R,im=X);

end GridImp;
