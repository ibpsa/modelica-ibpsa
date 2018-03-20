within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.ThermalResponseFactors;
function cylindricalHeatSource
  "Cylindrical heat source solution from Carslaw and Jaeger"
  extends Modelica.Icons.Function;

  input Real t "Time";
  input Real alpha "Ground thermal diffusivity";
  input Real dis "Radial distance between borehole axes";
  input Real rBor "Radius of emitting borehole";

  output Real G "Thermal response factor of borehole 1 on borehole 2";

protected
  Real Fo = alpha*t/rBor^2 "Fourier number";
  Real p = dis/rBor "Fourier number";

algorithm

  G := Modelica.Math.Nonlinear.quadratureLobatto(
    function
      IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.ThermalResponseFactors.cylindricalHeatSource_Integrand(
      Fo=Fo, p=p),
    1e-12,
    100,
    1e-6);

end cylindricalHeatSource;
