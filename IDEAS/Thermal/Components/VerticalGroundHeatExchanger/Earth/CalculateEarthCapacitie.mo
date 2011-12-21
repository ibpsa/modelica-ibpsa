within IDEAS.Thermal.Components.VerticalGroundHeatExchanger.Earth;
function CalculateEarthCapacitie
// **************
// This function calculates an array of capacities..
// **************
// **************
// INPUT
// **************
// This represents the 1/10 of the total depth of the borehole (m)
input Modelica.SIunits.Length depthOfEarth;
// This is the specific heat capacity of the earth (J/(kg.K))
input Modelica.SIunits.SpecificHeatCapacity heatCapacitanceEarth;
// This is the density of the earth (kg/m³)
input Modelica.SIunits.Density densityEarth;
// This is the inner radius of the ring (m)
input Modelica.SIunits.Radius innerRadius;
// This is outer radius of the ring (m)
input Modelica.SIunits.Radius outerRadius;
// **************
// OUTPUT
// **************
// The heatcapacity of the earth (J/K)
output Modelica.SIunits.HeatCapacity capacity;
algorithm
capacity := Modelica.Constants.pi*depthOfEarth*densityEarth*heatCapacitanceEarth*(outerRadius^2-innerRadius^2);
end CalculateEarthCapacitie;
