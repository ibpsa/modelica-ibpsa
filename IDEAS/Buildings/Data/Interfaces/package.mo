within IDEAS.Buildings.Data;
package Interfaces "Building data interfaces"


extends Modelica.Icons.InterfacesPackage;










partial record Screen "Solar screen"
  extends Modelica.Icons.MaterialProperty;
  parameter Real As(min=0, max=1) "Solar licht absoprtion";
  parameter Real Rs(min=0, max=1) "Solar licht reflection";
  parameter Real Ts(min=0, max=1) "Solar licht transmission";
  parameter Real Tv(min=0, max=1) "Visible licht transmission";
  parameter Real G(min=0, max=1) "Solar factor acc. EN 13363-1";

end Screen;

end Interfaces;
