within IBPSA.Airflow.Multizone.BaseClasses;
function flowElementData
  "CubicSplineData with last points linearly interpolated, yd values must be increasing"

  input Real u "independent variable";
  input Real table[:,:];

  output Real z "Dependent variable with monotone interpolation";

protected
  Real[:] xd=table[:,1] "Support points";
  Real[size(xd, 1)] yd=table[:,2] "Support points";
  Real[size(xd, 1)] d(each fixed=false);

  Integer i "Integer to select data interval";

algorithm

    // Get the derivative values at the support points, monotonicity is ensured

  d := IBPSA.Utilities.Math.Functions.splineDerivatives(
    x=xd,
    y=yd,
    ensureMonotonicity=true);

  i := 1;
  for j in 1:size(xd, 1) - 1 loop
    if u > xd[j] then
      i := j;
    end if;
  end for;

  // Extrapolate or interpolate the data

  if i == (size(xd, 1) - 1) then
    z:=yd[end-1]+(u-xd[end-1])*(yd[end]-yd[end-1])/(xd[end]-xd[end-1]);
  else
    z :=IBPSA.Utilities.Math.Functions.cubicHermiteLinearExtrapolation(
        x=u,
        x1=xd[i],
        x2=xd[i + 1],
        y1=yd[i],
        y2=yd[i + 1],
        y1d=d[i],
        y2d=d[i + 1]);
  end if;

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This function return the value on a cubic hermite spline through the given table input. The last 2 point in the table are linearly interpolated.</p>


<p><br>A similar model is also used in the CONTAM software (Dols and Walton, 2015).</p>
<h4>References</h4>
<ul>
<li><b>W. S. Dols and B. J. Polidoro</b>,<b>2015</b>. <i>CONTAM User Guide and Program Documentation Version 3.2</i>, National Institute of Standards and Technology, NIST TN 1887, Sep. 2015. doi: <a href=\"https://doi.org/10.6028/NIST.TN.1887\">10.6028/NIST.TN.1887</a>. </li>
</ul>


</html>", revisions="<html>
<ul>
<li>
Jun 26, 2020, by Klaas De Jonge:<br/>
Initial implementation
</li>
</u1>
</html>"));
end flowElementData;
