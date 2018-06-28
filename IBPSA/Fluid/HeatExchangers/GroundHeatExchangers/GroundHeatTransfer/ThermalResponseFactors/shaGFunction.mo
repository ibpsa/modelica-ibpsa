within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.ThermalResponseFactors;
function shaGFunction
  "Returns a SHA1 encryption of the formatted arguments for the g-function generation"
  extends Modelica.Icons.Function;
  input Integer nbBor "Number of boreholes";
  input Modelica.SIunits.Position cooBor[nbBor, 2] "Coordinates of boreholes";
  input Modelica.SIunits.Height hBor "Borehole length";
  input Modelica.SIunits.Height dBor "Borehole buried depth";
  input Modelica.SIunits.Radius rBor "Borehole radius";
  input Modelica.SIunits.ThermalDiffusivity aSoi "Ground thermal diffusivity used in g-function evaluation";
  input Integer nbSeg "Number of line source segments per borehole";
  input Integer nbTimSho "Number of time steps in short time region";
  input Integer nbTimLon "Number of time steps in long time region";
  input Real ttsMax "Maximum adimensional time for gfunc calculation";

  output String sha
  "SHA1 encryption of the g-function arguments";

protected
  String shaStr =  "";
  String formatStr =  "1.3e";

algorithm
  shaStr := shaStr + String(nbBor, format=formatStr);
  for i in 1:nbBor loop
   shaStr := shaStr + String(cooBor[i, 1], format=formatStr) + String(cooBor[i,
     2], format=formatStr);
  end for;
  shaStr := shaStr + String(hBor, format=formatStr);
  shaStr := shaStr + String(dBor, format=formatStr);
  shaStr := shaStr + String(rBor, format=formatStr);
  shaStr := shaStr + String(aSoi, format=formatStr);
  shaStr := shaStr + String(nbSeg, format=formatStr);
  shaStr := shaStr + String(nbTimSho, format=formatStr);
  shaStr := shaStr + String(nbTimLon, format=formatStr);
  shaStr := shaStr + String(ttsMax, format=formatStr);

  sha := IBPSA.Utilities.Cryptographics.sha(shaStr);

annotation (
Documentation(info="<html>
<p>
This function concatenates the various arguments required to generate the borefield's
thermal response into a single input string. Each argument is formatted in exponential notation
with four significant digits, for example &quot;1.234e+001&quot;, with no spaces or
other separating characters between each argument value. Because a borefield has a variable
number of boreholes, and because the (x,y) coordinates of each borehole are taken into
account, the total length of this input string is variable.
</p>
<p>
Once the input string has been put together, the SHA1 encryption of this string
is outputted using
<a href=\"modelica://IBPSA.Utilities.Cryptographics.sha\">IBPSA.Utilities.Cryptographics.sha</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
June 22, 2018 by Alex Laferri&egrave;re:<br/>
First implementation.
</li>
</ul>
</html>"));
end shaGFunction;
