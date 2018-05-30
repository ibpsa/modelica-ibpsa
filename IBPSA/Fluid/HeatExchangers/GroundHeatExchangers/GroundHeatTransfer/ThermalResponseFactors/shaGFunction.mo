within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.ThermalResponseFactors;
function shaGFunction
  "Returns a SHA1 encryption of the formatted arguments for the g-function generation"
  extends Modelica.Icons.Function;
  input Integer nbBor "Number of boreholes";
  input Real cooBor[nbBor, 2] "Coordinates of boreholes";
  input Real hBor "Borehole length";
  input Real dBor "Borehole buried depth";
  input Real rBor "Borehole radius";
  input Real alpha "Ground thermal diffusivity used in g-function evaluation";
  input Integer nbSeg "Number of line source segments per borehole";
  input Integer nbTimSho "Number of time steps in short time region";
  input Integer nbTimLon "Number of time steps in long time region";
  input Real relTol "Relative tolerance on distance between boreholes";
  input Real ttsMax "Maximum adimensional time for gfunc calculation";

  output String sha
  "SHA1 encryption of the g-function arguments";

protected
  String shaStr =  "";
  String formatStr =  "1.3e";

algorithm
  assert(nbBor<=18,"The large number of
    boreholes means that there may be conflicts when storing the g-function in
    the .BfData directory. In order to avoid potential errors, it is recommended
    to either set the forceGFunCalc parameter to True for all future problems
    with a similar borefield or to clear the contents of the .BfData directory
    before trying to simulate a model with a different borefield.",
    AssertionLevel.warning);

  shaStr := shaStr + String(nbBor, format=formatStr);
  for i in 1:nbBor loop
   shaStr := shaStr + String(cooBor[i, 1], format=formatStr) + String(cooBor[i,
     2], format=formatStr);
  end for;
  shaStr := shaStr + String(hBor, format=formatStr);
  shaStr := shaStr + String(dBor, format=formatStr);
  shaStr := shaStr + String(rBor, format=formatStr);
  shaStr := shaStr + String(alpha, format=formatStr);
  shaStr := shaStr + String(nbSeg, format=formatStr);
  shaStr := shaStr + String(nbTimSho, format=formatStr);
  shaStr := shaStr + String(nbTimLon, format=formatStr);
  shaStr := shaStr + String(relTol, format=formatStr);
  shaStr := shaStr + String(ttsMax, format=formatStr);

  sha := IBPSA.Utilities.Cryptographics.BaseClasses.sha(shaStr);
end shaGFunction;
