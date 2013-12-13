within IDEAS;
package Constants "Constants for IDEAS"


extends Modelica.Icons.VariantsPackage;

final constant Modelica.SIunits.Angle Ceiling=0
  "Inclination for horizontal ceiling";
final constant Modelica.SIunits.Angle Wall=Modelica.Constants.pi/2
  "Inclination for vertical wall";
final constant Modelica.SIunits.Angle Floor=Modelica.Constants.pi
  "inclination for floor";
final constant Modelica.SIunits.Angle South=0
  "Azimuth for an exterior wall whose outer surface faces south";
final constant Modelica.SIunits.Angle East=-Modelica.Constants.pi/2
  "Azimuth for an exterior wall whose outer surface faces east";
final constant Modelica.SIunits.Angle North=Modelica.Constants.pi
  "Azimuth for an exterior wall whose outer surface faces north";
final constant Modelica.SIunits.Angle West=+Modelica.Constants.pi/2
  "Azimuth for an exterior wall whose outer surface faces west";

end Constants;
