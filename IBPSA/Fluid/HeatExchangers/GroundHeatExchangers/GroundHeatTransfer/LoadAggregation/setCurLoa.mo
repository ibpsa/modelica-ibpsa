within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.LoadAggregation;
function setCurLoa "Sets the load for the current time step"
  extends Modelica.Icons.Function;

  input Integer i "Size of vector";
  input Real Qb "Load at current time step";
  input Modelica.SIunits.HeatFlowRate Q_shift[i]
    "Shifted Q_bar vector without current load";

  output Modelica.SIunits.HeatFlowRate Q_shift_cur[i]
    "Shifted Q_bar vector with current load";

algorithm
  Q_shift_cur := Q_shift;
  Q_shift_cur[1] := Qb;

  annotation (Documentation(info="<html>
<p>After the cell shifting operation, this function sets the first aggregation
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
end setCurLoa;
