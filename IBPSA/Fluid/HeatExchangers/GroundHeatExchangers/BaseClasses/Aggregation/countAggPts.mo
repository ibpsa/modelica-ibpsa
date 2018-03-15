within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.Aggregation;
function countAggPts
  "Function which returns i, the size of the aggregation vectors"
  extends Modelica.Icons.Function;

  input Real lvlBas "Base for growth between each level, e.g. 2";
  input Integer p_max "Number of cells of same size per level";
  input Modelica.SIunits.Time timFin "Total simulation max length";
  input Modelica.SIunits.Time lenAggSte "Aggregation step";

  output Integer i "Size of aggregation vectors";

protected
  Real width_i, nu_i;

algorithm
  width_i := 0;
  nu_i := 0;
  i := 0;

  while nu_i<timFin loop
    i := i+1;
    width_i := lenAggSte*lvlBas^floor((i-1)/p_max);
    nu_i := nu_i + width_i;
  end while;

end countAggPts;
