within IBPSA.Airflow.Multizone.BaseClasses;
function flowElementData
  "Function for the cubic spline interpolation of table input of a flow resistance"
  // fixme : I propose a more specific description for the function.
  // fixme : I am unsure if this implementation is efficient. The derivatives may be calculated at every call of the function (even though they are constant).
  // I only find one other model that uses spline interpolation with a time-dependent argument : IBPSA.Fluid.Actuators.Dampers.PressureIndependent.
  // It does not seem like the above implementation fits here. I would still consider splitting the function and evaluating the derivatives at initialization.

  input Real u "Independent variable";
  input Real table[:,:] "Table of mass or volume flow rate (second column) as a function of pressure difference (first column)";

  output Real z "Dependent variable with monotone interpolation";

protected
  Real[:] xd=table[:,1] "Support points";
  Real[size(xd, 1)] yd=table[:,2] "Support points";
  Real[size(xd, 1)] d(each fixed=false) "Derivatives at the support points";

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

// fixme : An example is missing in IBPSA.Airflow.Multizone.BaseClasses.Examples.
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
    <p>This function return the value on a cubic hermite spline through the given table input with monotonically increasing values. The last 2 points in the table are linearly interpolated.</p>


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
