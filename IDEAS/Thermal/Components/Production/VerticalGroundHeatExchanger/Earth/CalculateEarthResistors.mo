within IDEAS.Thermal.Components.Production.VerticalGroundHeatExchanger.Earth;
function CalculateEarthResistors
// **************
// This function calculates an array of thermal conductances.
// **************
// This represents the 1/10 of the total depth of the borehole (m)
input Modelica.SIunits.Length depthOfEarth[:];
// This is the thermal conductivity of the earth (T)
input Modelica.SIunits.ThermalConductivity lambda[:];
// This is the weighted inner radius of the ring (m)
input Modelica.SIunits.Radius weightedInnerRadius[:];
// This is the weighted outer radius of the ring (m)
input Modelica.SIunits.Radius weightedOuterRadius[:];
// This is radius
input Modelica.SIunits.Radius radius[:];
// **************
// OUTPUT
// **************
// This is the thermal conductance (W/K)
output Modelica.SIunits.ThermalResistance thermalResistance[size(depthOfEarth,1)];
algorithm
for index in 1:size(depthOfEarth,1) loop
thermalResistance[index] := Modelica.Math.log(weightedOuterRadius[index]/weightedInnerRadius[index])/(depthOfEarth[index]*Modelica.Constants.pi*2*lambda[index]);
end for;
end CalculateEarthResistors;
