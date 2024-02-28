within IBPSA.Utilities.Math;
block Interpolate
  "Output the smooth interpolation of the input signal on the given curve"
  extends Modelica.Blocks.Interfaces.SISO;

  parameter Real[:] xd "X-axis support points";
  parameter Real[size(xd, 1)] yd "Y-axis support points";
  parameter Real[size(xd, 1)] d "Derivatives at the support points";
equation
  y = IBPSA.Utilities.Math.Functions.interpolate(u=u,xd=xd,yd=yd,d=d);

annotation (
defaultComponentName="int",
    Documentation(info="<html>
<p>
This block outputs the value on a cubic hermite spline through the given
support points and their spline derivatives at these points, using the function
<a href=\"modelica://IBPSA.Utilities.Math.Functions.interpolate\">
IBPSA.Utilities.Math.Functions.interpolate</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 29, 2024, by Hongxiang Fu:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1844\">IBPSA, #1844</a>.
</li>
</ul>
</html>"));
end Interpolate;
