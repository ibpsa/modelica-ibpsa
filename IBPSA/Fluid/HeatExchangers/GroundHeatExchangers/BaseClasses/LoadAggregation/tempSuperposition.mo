within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.LoadAggregation;
function tempSuperposition "Performs temporal superposition"
  extends Modelica.Icons.Function;

  input Integer i "Number of aggregation cells";
  input Modelica.SIunits.HeatFlowRate Q_i[i]
    "Shifted Q_bar vector of size i";
  input Modelica.SIunits.Temperature kappa[i]
    "Weight factor for each aggregation cell";
  input Integer curCel "Current occupied aggregation cell";

  output Modelica.SIunits.TemperatureDifference deltaTb "Delta T at wall";

algorithm
  deltaTb := (Q_i[1:curCel]*kappa[1:curCel]);

end tempSuperposition;
