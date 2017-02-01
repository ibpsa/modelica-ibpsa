within IDEAS.Experimental.Electric.Data.Interfaces.DirectCurrent;
record GridImp "Describe a grid by matrices of layout and impedances"
extends Modelica.Icons.MaterialProperty;

parameter Integer nNodes;
parameter Integer nodeMatrix[size(nodeMatrix,1),:];
parameter Modelica.SIunits.Resistance R[size(nodeMatrix,1)];

protected
parameter Modelica.SIunits.ComplexImpedance Z[size(nodeMatrix,1)](re=R,each im=0);

end GridImp;
