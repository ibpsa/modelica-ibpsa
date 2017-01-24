within IDEAS.Electric.Data.Interfaces;
package DirectCurrent
extends Modelica.Icons.InterfacesPackage;
  record Cable "Low Voltage DC Cable Type"
  extends Modelica.Icons.MaterialProperty;
    parameter IDEAS.Electric.BaseClasses.Types.CharacteristicResistance RCha
      "Characteristic Resistance of the Cable";

  parameter Modelica.SIunits.ElectricCurrent In
      "Nominal Electrical Current Fused";
  end Cable;

  record GridImp "Describe a grid by matrices of layout and impedances"
  extends Modelica.Icons.MaterialProperty;

  parameter Integer nNodes;
  parameter Integer nodeMatrix[size(nodeMatrix,1),:];
  parameter Modelica.SIunits.Resistance R[size(nodeMatrix,1)];

  protected
  parameter Modelica.SIunits.ComplexImpedance Z[size(nodeMatrix,1)](re=R,each im=0);

  end GridImp;

  record GridType
    "Describes a grid using the layout matrix T_matrix and lengths and cable type vectors"

  extends Electric.Data.Interfaces.DirectCurrent.GridImp(R=CabTyp.RCha .*
          LenVec);

  parameter Modelica.SIunits.Length LenVec[nNodes]
      "Vector with the Length of each branch in the network, first value is 0";
  parameter Electric.Data.Interfaces.DirectCurrent.Cable CabTyp[nNodes]
      "Vector with the type of cable for each branch in the network, first value should be anything";

  end GridType;
end DirectCurrent;
