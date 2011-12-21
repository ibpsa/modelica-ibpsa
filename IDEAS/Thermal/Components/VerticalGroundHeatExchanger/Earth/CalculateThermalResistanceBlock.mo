within IDEAS.Thermal.Components.VerticalGroundHeatExchanger.Earth;
function CalculateThermalResistanceBlock
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
input Modelica.SIunits.Radius radiusPipe;
input Modelica.SIunits.Radius radiusBorehole;
// **************
// OUTPUT
// **************
// This is the thermal conductance (W/K)
output Modelica.SIunits.ThermalResistance thermalResistance[size(depthOfEarth,1)+3];
algorithm
thermalResistance[1] := 1/(lambda[1]*radiusPipe*2*Modelica.Constants.pi);
thermalResistance[2] := Modelica.Math.log(radiusBorehole/sqrt((radiusBorehole^2 + radiusPipe^2)/2))/(depthOfEarth[1]*Modelica.Constants.pi*2*lambda[1]);
thermalResistance[3] := Modelica.Math.log(weightedInnerRadius[1]/radiusBorehole)/(depthOfEarth[1]*Modelica.Constants.pi*2*lambda[1]);
for index in 1:size(depthOfEarth,1) loop
thermalResistance[index+3] :=
Modelica.Math.log(weightedOuterRadius[index]/weightedInnerRadius[index])/(depthOfEarth[index]*Modelica.Constants.pi*2*lambda[index]);
end for;
end CalculateThermalResistanceBlock;
