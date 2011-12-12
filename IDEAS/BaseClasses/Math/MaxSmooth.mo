within IDEAS.BaseClasses.Math;
function MaxSmooth

input Real u1 "first argument for maximum";
input Real u2 "second argument for maximum";
input Real delta "width of the transition interval";
output Real y "smooth maximum resultresult";

algorithm
y := Modelica.Media.Air.MoistAir.Utilities.spliceFunction(pos=  u1, neg=  u2, x=  u1-u2, deltax=  delta);

end MaxSmooth;
