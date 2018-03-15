within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.ThermalResponseFactors;
function infiniteLineSource
  "Infinite line source model for borehole heat exchangers"

  input Real t "Time";
  input Real alpha "Ground thermal diffusivity";
  input Real dis "Radial distance between borehole axes";

  output Real h_ils "Thermal response factor of borehole 1 on borehole 2";

protected
  Real lowBou = dis^2/(4*alpha*t) "Lower bound of integration";
  // Upper bound is infinite

algorithm

  h_ils := IBPSA.Utilities.Math.Functions.exponentialIntegralE1(lowBou);

end infiniteLineSource;
