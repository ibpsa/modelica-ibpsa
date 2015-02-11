within IDEAS.Utilities.Math.Functions;
function isAngle
  "Return true if angles are mathematically equal up to a certain precision"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.Angle ang1;
  input Modelica.SIunits.Angle ang2;
  input Real precision = 0.01;

  output Boolean result;

algorithm
  result :=abs(sin((ang1 - ang2)/2)) < 0.01;
end isAngle;
