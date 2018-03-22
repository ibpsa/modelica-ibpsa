within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.LoadAggregation;
function timSerFin "Reads the last time value in the g-function input file"
  extends Modelica.Icons.Function;

  input Integer nrow "Number of lines in input file";
  input Real[nrow+1,2] matrix "File path to where matrix data is stored";

  output Modelica.SIunits.Time timFin "Final time value";

algorithm
  timFin := matrix[nrow+1,1];
end timSerFin;
