within IDEAS.Thermal.Components.VerticalGroundHeatExchanger.Earth;
function CalculateContactResistanceEarthSideFilling
// **************
// This function calculates the thermal conductance of the contact resistor between the
// filling material and the earth given the depth of earth, the thermal diffusivity of the filling material,
// the thermal conductivity of the earth, the radius of the pipe,
// the radius of the borehole and the first radius of the earth.
// **************
// **************
// INPUT
// **************
// This represents the 1/10 of the total depth of the borehole (m)
input Modelica.SIunits.Length depthOfEarth;
// This is the thermal conductivity of the earth
input Modelica.SIunits.ThermalConductivity lambdaEarth;
// This is the radius of the borehole.
input Modelica.SIunits.Radius radiusBorehole;
// The first radius of the earth.
input Modelica.SIunits.Radius firstRadiusEarth;
// **************
// OUTPUT
// **************
// This is the thermal conductance (W/K)
output Modelica.SIunits.ThermalResistance thermalResistance;
// Otherwise Jmodelica isn't running..
protected
Modelica.SIunits.Radius weightedRadius =  sqrt((firstRadiusEarth^2 + radiusBorehole^2)/2);
algorithm
// This parameter represents the weighted outer radius.
weightedRadius := sqrt((firstRadiusEarth^2 + radiusBorehole^2)/2);
thermalResistance := Modelica.Math.log(weightedRadius/radiusBorehole)/(depthOfEarth*Modelica.Constants.pi*2*lambdaEarth);
end CalculateContactResistanceEarthSideFilling;
