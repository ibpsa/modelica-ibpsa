within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.LoadAggregation;
function timSerFin "Reads the last time value in the g-function input file"
  extends Modelica.Icons.Function;

  input Integer nrow "Number of lines in input file";
  input String filNam "File path to where matrix data is stored";
  input Modelica.SIunits.ThermalDiffusivity as
    "Thermal diffusivity of soil";
  input Modelica.SIunits.Length H "Borehole vertical length";

  output Modelica.SIunits.Time timFin "Final time value";

protected
  String strLine;
  Real number1;
  Modelica.SIunits.Time ts;

algorithm
  ts := H^2/(9*as);
  strLine := Modelica.Utilities.Streams.readLine(filNam,nrow);
  number1 := Modelica.Utilities.Strings.scanReal(strLine);

  timFin := Modelica.Math.exp(number1)*ts;
end timSerFin;
