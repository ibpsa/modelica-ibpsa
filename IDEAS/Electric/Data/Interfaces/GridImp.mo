within IDEAS.Electric.Data.Interfaces;
record GridImp "Describe a grid by matrices of layout and impedances"
extends Modelica.Icons.MaterialProperty;

parameter Integer Pha=3;
parameter Integer n;
parameter Integer T_matrix[size(T_matrix,1),:];
parameter Modelica.SIunits.Resistance R[size(T_matrix,1)];
parameter Modelica.SIunits.Reactance X[size(T_matrix,1)];
parameter Modelica.SIunits.ComplexImpedance Z[size(T_matrix,1)](re=R,im=X);

end GridImp;
