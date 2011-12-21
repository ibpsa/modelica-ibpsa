within IDEAS.Thermal.Components.VerticalGroundHeatExchanger.Borehole.Fillingmaterial;
function CalculateFillingMaterialCapacitor "The filling material capacitor"
// **************
// This function calculates the capacity of the pipe filling material given the
// the length of the pipe, the density of the filling material,
// and the specific heat of the fiiling material, the inner radius and the
// outer radius.
// **************
// **************
// INPUT
// **************
// The length of the pipe (this is the 1/10 of the total length).
input Modelica.SIunits.Length depthOfEarth;
// The specific heat of the filling material.
input Modelica.SIunits.SpecificHeatCapacity heatCapacitanceFillig;
// The density of the filling material.
input Modelica.SIunits.Density densityFillig;
// The inner radius of the filling material.
input Modelica.SIunits.Radius innerRadius;
// The outer radius of the filling material;
input Modelica.SIunits.Radius outerRadius;
// **************
// OUTPUT
// **************
// The capacity of the filling material.
output Modelica.SIunits.HeatCapacity capacity;
algorithm
  // Minus two times the inner radius square, this is the space taken by the pipes.
capacity :=  Modelica.Constants.pi*densityFillig*heatCapacitanceFillig*(outerRadius^2-2*innerRadius^2)*depthOfEarth;
end CalculateFillingMaterialCapacitor;
