within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.LoadAggregation;
function nextTimeStep
  "Performs the shifting operation for load aggregation"
  extends Modelica.Icons.Function;

  input Integer i "Number of aggregation cells";
  input Modelica.SIunits.HeatFlowRate Q_i[i] "Q_bar vector of size i";
  input Real rCel[i] "Aggregation cell widths";
  input Modelica.SIunits.Time nu[i] "Cell aggregation times";
  input Modelica.SIunits.Time curTim "Current simulation time";

  output Integer curCel "Current occupied aggregation cell";
  output Modelica.SIunits.HeatFlowRate Q_i_shift[i] "Shifted Q_bar vector";

algorithm
  curCel := 1;
  for j in (i-1):-1:1 loop
    if curTim>=nu[j+1] then
      Q_i_shift[j+1] :=((rCel[j+1] - 1)*Q_i[j+1] + Q_i[j])/rCel[j+1];
    elseif curTim>=nu[j] then
      Q_i_shift[j+1] :=(rCel[j+1]*Q_i[j+1] + Q_i[j])/rCel[j+1];
      curCel := j+1;
    end if;
  end for;

  Q_i_shift[1] := 0;

  annotation (Documentation(info="<html>
<p>Performs the shifting operation which propagates the thermal load history
towards the more distant aggregation cells, and then sets the current cell's
value at 0.
</p>
</html>", revisions="<html>
<ul>
<li>
March 5, 2018, by Alex Laferriere:<br/>
First implementation.
</li>
</ul>
</html>"));
end nextTimeStep;
