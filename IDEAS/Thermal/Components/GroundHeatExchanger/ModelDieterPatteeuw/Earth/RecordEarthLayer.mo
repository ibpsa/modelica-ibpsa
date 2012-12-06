within IDEAS.Thermal.Components.GroundHeatExchanger.ModelDieterPatteeuw.Earth;
record RecordEarthLayer
// **************
// This record contains all the parameters concerning the earth.
// **************
// This represents the radius of the earth.
parameter Modelica.SIunits.Length depthOfEarth= 10;
// This represents the 1/numberOfVerticalBottumLayers of the total depth of the earth beneath (m)
parameter Modelica.SIunits.Length depthOfEarthUnder = 10;
// This is the density of the earth (kg/m³)
parameter Modelica.SIunits.Density densityEarth= 1600;
// This represents the radius of the earth.
parameter Modelica.SIunits.Radius radius[numberOfHorizontalNodes];
// This is the thermal conductivity of the earth (T)
parameter Modelica.SIunits.ThermalConductivity lambda= 1.3;
// This is the specific heat capacity of the earth (J/(kg.K))
parameter Modelica.SIunits.SpecificHeatCapacity heatCapacitanceEarth= 850;
// This is the start temperature of the earth (K)
parameter Modelica.SIunits.Temperature startTemperature = 283;
// This is the temperature of the earth (K) of the undisturbed ground.
parameter Modelica.SIunits.Temperature endTemperature = 283;
// This is the temperature on top of the earth (K)
parameter Modelica.SIunits.Temperature outSideTemperature = 288;
// This parameter represents the number of vertical layers you want to divide the soil underneath the borehole.
parameter Integer numberOfVerticalBottumLayers = 11;
// This number represents the number of horizontalnodes outside the borehole.
parameter Integer numberOfHorizontalNodes = 17;
// This paramter represents the temperature gradient per meter in the earth (K/m)
parameter Real gradient = 0.15/100;
// This is the total depth.
parameter Real totalDepth = 120;
// This is the total depth of the block beneath the earth containing the borehole.
parameter Real metersOfEarthBlock = 20;
// This is the temperature on the bottum of the earth.
parameter Real bottumTemperature = 45;
end RecordEarthLayer;
