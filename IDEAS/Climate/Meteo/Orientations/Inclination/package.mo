within IDEAS.Climate.Meteo.Orientations;
package Inclination "Enumeration for surface inclinations"


  extends Modelica.Icons.Package;

  constant Modelica.SIunits.Angle Ceiling = 0 "inclination for ceiling";
  constant Modelica.SIunits.Angle Wall = Modelica.Constants.pi/2
  "inclination for vertical wall";
  constant Modelica.SIunits.Angle Floor = Modelica.Constants.pi
  "inclination for floor";

end Inclination;
