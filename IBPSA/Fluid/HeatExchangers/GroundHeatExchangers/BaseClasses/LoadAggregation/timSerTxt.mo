within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.LoadAggregation;
function timSerTxt "Imports g-function time-series matrix with
    2 columns from an external textual file"
  extends Modelica.Icons.Function;
  input String filNam "File path to where matrix data is stored";
  input Modelica.SIunits.ThermalDiffusivity as
    "Thermal diffusivity of soil";
  input Modelica.SIunits.ThermalConductivity ks
    "Thermal conductivity of soil";
  input Modelica.SIunits.Length H "Borehole vertical length";
  input Integer nrow "Number of lines in file";

  output Real matrix[nrow+1, 2] "2D Real array with 2 columns";

protected
  Integer nextIndex1, nextIndex2;
  Real number1, number2;
  String strLine;
  Modelica.SIunits.Time ts;
algorithm
  ts := H^2/(9*as);

  matrix[1,1] := 0;
  matrix[1,2] := 0;
  for i in 1:nrow loop
    strLine := Modelica.Utilities.Streams.readLine(filNam,i);
    (number1, nextIndex1) := Modelica.Utilities.Strings.scanReal(strLine);
    (number2, nextIndex2) := Modelica.Utilities.Strings.scanReal(strLine, nextIndex1);

    matrix[i+1,1] := Modelica.Math.exp(number1)*ts;
    matrix[i+1,2] := number2/(2*Modelica.Constants.pi*H*ks);
  end for;
end timSerTxt;
