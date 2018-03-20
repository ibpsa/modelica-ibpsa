within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.ThermalResponseFactors;
function cylindricalHeatSource_Integrand
  "Integrand function for cylindrical heat source evaluation"
  extends Modelica.Icons.Function;

  input Real u "Normalized integration variable";
  input Real Fo "Fourier number";
  input Real p "Ratio of distance over radius";

  output Real y "Value of integrand";

algorithm

  y := 1.0/(u^2*Modelica.Constants.pi^2)*(exp(-u^2*Fo) - 1.0)/(IBPSA.Utilities.Math.Functions.besselJ1(u)^2+IBPSA.Utilities.Math.Functions.besselY1(u)^2)*(IBPSA.Utilities.Math.Functions.besselJ0(p*u)*IBPSA.Utilities.Math.Functions.besselY1(u)-IBPSA.Utilities.Math.Functions.besselJ1(u)*IBPSA.Utilities.Math.Functions.besselY0(p*u));

end cylindricalHeatSource_Integrand;
