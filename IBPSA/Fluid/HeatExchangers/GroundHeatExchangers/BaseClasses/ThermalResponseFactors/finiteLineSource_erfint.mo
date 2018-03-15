within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.ThermalResponseFactors;
function finiteLineSource_erfint "Integral of the error function"
  extends Modelica.Math.Nonlinear.Interfaces.partialScalarFunction;

algorithm
  y := u*Modelica.Math.Special.erf(u) - 1/sqrt(Modelica.Constants.pi)*(1 - exp(-u^2));

end finiteLineSource_erfint;
