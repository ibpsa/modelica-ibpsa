within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.LoadAggregation;
function timSerFin "Reads the last time value in the g-function input file"
  extends Modelica.Icons.Function;

  input Integer nrow "Number of lines in input file";
  input Real[nrow+1,2] matrix "File path to where matrix data is stored";

  output Modelica.SIunits.Time timFin "Final time value";

algorithm
  timFin := matrix[nrow+1,1];

  annotation (Documentation(info="<html>
<p>Counts the size of the aggregation vectors <code>nu</code> and 
<code>kappa</code> based on the maximum time for thermal response-related
calculations.
</p>
<p>
Uses the step response time-series matrix to determine the maximum permissible
simulation time for ground thermal response-related calculations.
</p>
</html>", revisions="<html>
<ul>
<li>
March 5, 2018, by Alex Laferriere:<br/>
First implementation.
</li>
</ul>
</html>"));
end timSerFin;
