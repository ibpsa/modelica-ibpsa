within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.Aggregation.BaseClasses;
function cellWidth
  " Calculates the width of the cell of each level. The width increase exponential with base 2 "
  extends Interface.partialAggFunction;

  output Integer[q_max] rArr "width of cell at each level";

algorithm
  for i in 1:q_max loop
    rArr[i] := integer(2^(i - 1));
  end for;

end cellWidth;
