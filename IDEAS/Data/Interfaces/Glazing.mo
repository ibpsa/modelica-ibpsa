within IDEAS.Data.Interfaces;
record Glazing

extends Modelica.Icons.MaterialProperty;

  parameter Integer nLay(min=1)
    "Number of layers of the glazing, including gaps";
  parameter IDEAS.Data.Interfaces.Material[nLay] mats "Array of materials";
  parameter Real[:,nLay + 1] SwAbs
    "Absorbed solar radiation for each layer as function of angle of incidence";
  parameter Real[:,2] SwTrans
    "Transmitted solar radiation as function of angle of incidence";

  parameter Real U_value "U-value";
  parameter Real g_value "g-value";

end Glazing;
