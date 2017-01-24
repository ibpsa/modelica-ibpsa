within IDEAS.Electric.Data.Interfaces;
record GridImp "Describe a grid by matrices of layout and impedances"
  extends Modelica.Icons.MaterialProperty;
  //extends IDEAS.Electric.Data.Interfaces.GridLayout;
  //parameter Integer n(min=1);
  //parameter Integer T_matrix[nNodes,nNodes];

  parameter Integer nNodes;
  parameter Integer nodeMatrix[size(nodeMatrix, 1), :];
  parameter Modelica.SIunits.Resistance R[size(nodeMatrix, 1)];
  parameter Modelica.SIunits.Reactance X[size(nodeMatrix, 1)];
  parameter Modelica.SIunits.ComplexImpedance Z[size(nodeMatrix, 1)](re=R, im=X);

end GridImp;
