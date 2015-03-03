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
  Real x = l1/d;
  Real y = l2/d;

  Real x1 = sqrt(1+x^2);
  Real y1 = sqrt(1+y^2);

algorithm
//   vieFac :=1/Modelica.Constants.pi/A^2*(log((A^2*(1+B^2)+2)^2/((Y^2+2)*(X^2+2))) +
//                                             ((Y^2+4)^0.5)*(Y*atan(Y/(Y^2+4)^0.5)-X*atan(X/(Y^2+4)^0.5)) +
//                                             ((X^2+4)^0.5)*(X*atan(X/(X^2+4)^0.5)-Y*atan(Y/(X^2+4)^0.5)));
vieFac := 1/Modelica.Constants.pi/x/y*(log(x1^2*y1^2/(x1^2+y1^2-1)) +
                                       2*x*(y1*atan(x/y1)-atan(x)) +
                                       2*y*(x1*atan(y/x1)-atan(y)));

  annotation (Documentation(info="<html>
<p>source: http://webserver.dmt.upm.es/~isidoro/tc3/Radiation&percnt;20View&percnt;20factors.pdf</p>
</html>"));
end viewFactorRectRectPar;
