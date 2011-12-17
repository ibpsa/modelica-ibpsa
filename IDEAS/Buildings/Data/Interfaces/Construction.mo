within IDEAS.Buildings.Data.Interfaces;
model Construction

extends Modelica.Icons.MaterialProperty;

  parameter Integer nLay(min=1)
    "Number of layers of the construction, including gaps";
  parameter Integer locGain(min=1) = 1 "Location of possible embedded system";
  replaceable parameter IDEAS.Buildings.Data.Interfaces.Insulation insulationType(d=insulationTickness)
    "Type of thermal insulation" annotation (choicesAllMatching = true);
  parameter IDEAS.Buildings.Data.Interfaces.Material[nLay] mats
    "Array of materials";
  parameter Modelica.SIunits.Length insulationTickness
    "Thermal insulation thickness";

end Construction;
