within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.Aggregation;
function timAgg
  "Function which builds the time and cell width vectors for aggregation"
  extends Modelica.Icons.Function;

  input Integer i "Size of time vector";
  input Real lvlBas "Base for growth between each level, e.g. 2";
  input Integer p_max "Number of cells of same size per level";
  input Modelica.SIunits.Time lenAggSte "Aggregation step";
  input Modelica.SIunits.Time timFin "Total simulation max length";

  output Modelica.SIunits.Time nu[i] "Time vector nu of size i";
  output Real rCel[i] "Cell width vector of size i";

protected
  Real width_j;

algorithm
  width_j := 0;

  for j in 1:i loop
    width_j := width_j + lenAggSte*lvlBas^floor((j-1)/p_max);
    nu[j] := width_j;

    rCel[j] := lvlBas^floor((j-1)/p_max);
  end for;

  if nu[i]>timFin then
    nu[i] := timFin;
    rCel[i] := (nu[i]-nu[i-1])/lenAggSte;
  end if;

end timAgg;
