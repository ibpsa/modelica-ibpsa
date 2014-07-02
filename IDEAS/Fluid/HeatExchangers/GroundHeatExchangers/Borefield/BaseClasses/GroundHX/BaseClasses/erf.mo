within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.GroundHX.BaseClasses;
function erf "Error function, using the external c-function"
  extends Modelica.Math.Nonlinear.Interfaces.partialScalarFunction;

external"C" y = erf(u);
  annotation (Include="#include <erf.c>", IncludeDirectory="modelica://IDEAS/Resources/C-Sources");
end erf;
