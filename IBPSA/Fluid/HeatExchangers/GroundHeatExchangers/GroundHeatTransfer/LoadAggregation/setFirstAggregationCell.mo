within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.LoadAggregation;
function setFirstAggregationCell "Sets the load for the current time step"
  extends Modelica.Icons.Function;

  input Integer i "Size of vector";
  input Modelica.SIunits.HeatFlowRate QBor_flow
    "Averaged load over last aggregation step";
  input Modelica.SIunits.HeatFlowRate QAggShi_flow[i]
    "Shifted vector of aggregated loads from last aggregation step";

  output Modelica.SIunits.HeatFlowRate QAgg_flow[i]
    "Vector of aggregated loads";

algorithm
  QAgg_flow := QAggShi_flow;
  QAgg_flow[1] := QBor_flow;

  annotation (
Inline=true,
Documentation(info="<html>
<p>
After the cell shifting operation, this function sets the first aggregation
cell with the present thermal load value.
</p>
</html>", revisions="<html>
<ul>
<li>
March 5, 2018, by Alex Laferri&egrave;re:<br/>
First implementation.
</li>
</ul>
</html>"));
end setFirstAggregationCell;
