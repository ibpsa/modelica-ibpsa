within IDEAS.Buildings.Data.Interfaces;
record Glazing

extends Modelica.Icons.MaterialProperty;

  parameter Integer nLay(min=1)
    "Number of layers of the glazing, including gaps";
  parameter IDEAS.Buildings.Data.Interfaces.Material[nLay] mats
    "Array of materials";
  parameter Real[:,nLay + 1] SwAbs(unit="-")
    "Absorbed solar radiation for each layer as function of angle of incidence";
  parameter Real[:,2] SwTrans(unit="-")
    "Transmitted solar radiation as function of angle of incidence";

  parameter Real U_value(unit="W/(m2K)") "U-value";
  parameter Real g_value(unit="-") "g-value";

end Glazing;
