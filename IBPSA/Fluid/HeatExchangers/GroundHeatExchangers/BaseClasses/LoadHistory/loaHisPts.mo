within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.LoadHistory;
function loaHisPts
  "Counts the number of load aggregation points in load history"
  extends Modelica.Icons.Function;

  input Integer i "Number of aggregation points";
  input Modelica.SIunits.Time nu[i] "Time vector for load aggregation";
  input Modelica.SIunits.Time prevTim "Aggregation time at start of simulation";

  output Integer iCur "Number of aggregation points in load history";

algorithm
  iCur:=1;

  assert(nu[end]>=prevTim, "G-function input file doesn't cover load hitory");

  while nu[iCur]<prevTim loop
    iCur:=iCur+1;
  end while;
end loaHisPts;
