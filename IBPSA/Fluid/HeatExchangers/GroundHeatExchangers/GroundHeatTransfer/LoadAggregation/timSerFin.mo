within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.LoadAggregation;
function timSerFin "Finds the maximum aggregation time"
  extends Modelica.Icons.Function;

  input Integer nrow "Length of step response matrix";
  input Real[nrow+1,2] matrix "Temperature step response matrix";

  output Modelica.SIunits.Time timFin "Final time value";

algorithm
  timFin := matrix[nrow+1,1];

  annotation (Documentation(info="<html>
<p>Finds the maximum aggregation time in the temperature step response matrix,
which is the value stored in the first column of the last row of the matrix.
</p>
</html>", revisions="<html>
<ul>
<li>
March 5, 2018, by Alex Laferri&egrave;re:<br/>
First implementation.
</li>
</ul>
</html>"));
end timSerFin;
