within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.LoadAggregation;
function setCurLoa "Sets the load for the current time step"
  extends Modelica.Icons.Function;

  input Integer i "Size of vector";
  input Real Qb "Load at current time step";
  input Modelica.SIunits.HeatFlowRate Q_shift[i]
    "Shifted Q_bar vector of size i";

  output Modelica.SIunits.HeatFlowRate Q_shift_cur[i]
    "Shifted Q_bar vector of size i";

algorithm
  Q_shift_cur := Q_shift;
  Q_shift_cur[1] := Qb;

end setCurLoa;
