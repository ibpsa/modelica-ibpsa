within IDEAS.Electric.Data.Interfaces;
record GridType
  "Describes a grid using the layout matrix T_matrix and lengths and cable type vectors"
extends IDEAS.Electric.Data.Interfaces.GridImp(
                            R=CabTyp.RCha.*LenVec*Pha/3,X=CabTyp.XCha.*LenVec);
parameter Integer n;
parameter Integer T_matrix[n,n];
//parameter Modelica.SIunits.Length LenVec[size(T_matrix,1)]
parameter Modelica.SIunits.Length LenVec[n]
    "Vector with the Length of each branch in the network, first value is 0";
parameter IDEAS.Electric.Data.Interfaces.Cable
                               CabTyp[n]
    "Vector with the type of cable for each branch in the network, first value should be anything";

//parameter Modelica.SIunits.ComplexImpedance Z[size(T_matrix,1)](re=R,im=X);

end GridType;
