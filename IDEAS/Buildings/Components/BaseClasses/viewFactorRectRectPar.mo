within IDEAS.Buildings.Components.BaseClasses;
function viewFactorRectRectPar
  "View factor between two coaxial parallel rectangular surfaces with common height."
  extends Modelica.Icons.Function;
  //source: http://www.thermalradiation.net/sectionc/C-12.html
  input Real A1 "Area of surface 1";
  input Real A2 "Area of surface 2";
  input Real d "Distance between surfaces";
  input Real l1 "Length of surface 1";
  input Real l2 "Length of surface 2";

  output Real vieFac "View factor between surfaces";

protected
  Real A = l1/d;
  Real B = l2/d;

  Real X = A*(1+B);
  Real Y = A*(1-B);

algorithm
  vieFac :=1/Modelica.Constants.pi/A^2*(log((A^2*(1+B^2)+2)^2/((Y^2+2)*(X^2+2))) +
                                            ((Y^2+4)^0.5)*(Y*atan(Y/(Y^2+4)^0.5)-X*atan(X/(Y^2+4)^0.5)) +
                                            ((X^2+4)^0.5)*(X*atan(X/(X^2+4)^0.5)-Y*atan(Y/(X^2+4)^0.5)));
end viewFactorRectRectPar;
