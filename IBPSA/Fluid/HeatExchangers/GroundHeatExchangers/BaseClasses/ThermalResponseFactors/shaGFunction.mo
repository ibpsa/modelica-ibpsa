within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.ThermalResponseFactors;
function shaGFunction
  "Return a pseudo sha code of the formatted arguments for the g-function generation"
  extends Modelica.Icons.Function;
  input Integer nbBor "Number of boreholes";
  input Real cooBor[nbBor, 2] "Coordinates of boreholes";
  input Real hBor "Borehole length";
  input Real dBor "Borehole buried depth";
  input Real rBor "Borehole radius";
  input Real alpha "Ground thermal diffusivity used in g-function evaluation";

  output String sha
  "Pseudo sha code of the g-function arguments";

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
  shaStr := shaStr + String(alpha, format=formatStr);

  sha := IBPSA.Utilities.Cryptographics.BaseClasses.sha(shaStr);
end shaGFunction;
