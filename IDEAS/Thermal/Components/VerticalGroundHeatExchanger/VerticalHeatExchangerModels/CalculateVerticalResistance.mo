within IDEAS.Thermal.Components.VerticalGroundHeatExchanger.VerticalHeatExchangerModels;
function CalculateVerticalResistance
            input Modelica.SIunits.Length depthOfEarth;
            // This is the thermal conductivity of the earth (T)
            input Modelica.SIunits.ThermalConductivity lambda;
            input Modelica.SIunits.Radius innerRadius;
            // This is outer radius of the ring (m)
            input Modelica.SIunits.Radius outerRadius;
// **************
// OUTPUT
// **************
// The capacity of the filling material.
output Modelica.SIunits.ThermalResistance thermalResistance;
algorithm
  thermalResistance := depthOfEarth/(lambda*Modelica.Constants.pi*(outerRadius^2 - innerRadius^2));
end CalculateVerticalResistance;
