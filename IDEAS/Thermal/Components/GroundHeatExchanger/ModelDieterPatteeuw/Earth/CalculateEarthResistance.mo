within IDEAS.Thermal.Components.GroundHeatExchanger.ModelDieterPatteeuw.Earth;
function CalculateEarthResistance
input Modelica.SIunits.Length depthOfEarth;
// This is the thermal conductivity of the earth (T)
input Modelica.SIunits.ThermalConductivity lambda;
// This is the weighted inner radius of the ring (m)
input Modelica.SIunits.Radius outerRadius;
// This is the weighted outer radius of the ring (m)
input Modelica.SIunits.Radius innerRadius;
// **************
// OUTPUT
// **************
// This is the thermal conductance (W/K)
output Modelica.SIunits.ThermalResistance thermalResistance;
algorithm
thermalResistance := if innerRadius == 0 then 1/(lambda*outerRadius*2*Modelica.Constants.pi) else Modelica.Math.log(outerRadius/innerRadius)/(depthOfEarth*Modelica.Constants.pi*2*lambda);
end CalculateEarthResistance;
