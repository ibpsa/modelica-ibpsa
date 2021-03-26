within IBPSA.Airflow.Multizone.BaseClasses;
function windPressureProfile
  "Function for the cubic spline interpolation of table input of a wind pressure profile"

  input Modelica.SIunits.Angle u "independent variable, wind incidence angle";
  input Real table[:,:]
    "First column: wind angle relative to the surface (degrees). Second column: corresponding Cp ";

  output Real z "Dependent variable without monotone interpolation, CpAct";



protected
  Real Radtable[:,:] = [Modelica.Constants.D2R*table[:,1],table[:,2]];
  // Extend table with 1 point at the beginning and end for correct derivative at 0 and 360
  Real prevPoint[1,2] = [Radtable[size(table, 1)-1, 1] - (2*Modelica.Constants.pi), Radtable[size(table, 1)-1, 2]];
  Real nextPoint[1,2] = [Radtable[2, 1] + (2*Modelica.Constants.pi), Radtable[2, 2]];
  Real exTable[:,:] = [prevPoint;Radtable;nextPoint]; //Extended table

  Real[:] xd=exTable[:,1] "Support points x-value";
  Real[size(xd, 1)] yd=exTable[:,2] "Support points y-value";
  Real[size(xd, 1)] d=IBPSA.Utilities.Math.Functions.splineDerivatives(
      x=xd,
      y=yd,
      ensureMonotonicity=false)
    "Derivative values at the support points";

  Integer i "Integer to select data interval";
  Real aR "u, restricted to 0...2*pi";

algorithm

  // Change sign to positive
  // fixme : If I am not mistaken, this should be aR := 2*pi-u.
  // An alternate solution that combines this and the constraint on [0, 2*pi] is to use the modulus : aR = mod(u, 2*pi)
  // (Symmetry around u=0 is not imposed)
  aR := if u < 0 then -u else u;

  // Constrain to [0...2*pi]
  if aR > 2*Modelica.Constants.pi then
  aR := aR - integer(aR/(2*Modelica.Constants.pi))*(2*Modelica.Constants.pi);
  end if;

  i := 1;
  for j in 1:size(xd, 1) - 1 loop
    if aR > xd[j] then
      i := j;
    end if;
  end for;

  // Interpolate the data

  z :=IBPSA.Utilities.Math.Functions.cubicHermiteLinearExtrapolation(
        x=aR,
        x1=xd[i],
        x2=xd[i + 1],
        y1=yd[i],
        y2=yd[i + 1],
        y1d=d[i],
        y2d=d[i + 1]);

// fixme : The documentation is missing.
// fixme : An example is also missing in IBPSA.Airflow.Multizone.BaseClasses.Examples.
  annotation (Documentation(revisions="<html>
<ul>
<li>
Jun 26, 2020, by Klaas De Jonge:<br/>
First implementation.
</li>
</ul>
</html>"));
end windPressureProfile;
