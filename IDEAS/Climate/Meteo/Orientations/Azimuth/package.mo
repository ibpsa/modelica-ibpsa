within IDEAS.Climate.Meteo.Orientations;
package Azimuth "Enumeration for surface azimuth"


   extends Modelica.Icons.Package;

   constant Modelica.SIunits.Angle South = 0
  "Azimuth for an exterior wall whose outer surface faces south";
   constant Modelica.SIunits.Angle East = - Modelica.Constants.pi/2
  "Azimuth for an exterior wall whose outer surface faces east";
   constant Modelica.SIunits.Angle North = Modelica.Constants.pi
  "Azimuth for an exterior wall whose outer surface faces north";
   constant Modelica.SIunits.Angle West = + Modelica.Constants.pi/2
  "Azimuth for an exterior wall whose outer surface faces west";

end Azimuth;
