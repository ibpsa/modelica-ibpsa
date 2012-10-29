within IDEAS.Thermal.Components.VerticalGroundHeatExchanger.Borehole.Borehole;
record RecordPipes "Containing every information necaissary for the pipes."
parameter Modelica.SIunits.Radius radiusPipe =  0.03045
    "This is the radius of the pipes (m)";
parameter Modelica.SIunits.Length depthOfEarth =  10
    "This represents the 1/10 of the total depth of the borehole (m)";
parameter Modelica.SIunits.Density densitySole =  1111
    "This is the density of the brine (kg/m3)";
parameter Modelica.SIunits.SpecificHeatCapacity heatCapacitanceSole =  3990
    "This is the specific heat capacity of the brine (J/(kg.K))";
parameter Modelica.SIunits.Temperature startTemperature = 293
    "This is the start temperature of the brine in the pipes (K)";
parameter Modelica.SIunits.ThermalDiffusivity alphaSole = 64
    "This is the thermal diffusity of the brine (m2/s)";
parameter Modelica.SIunits.ThermalConductivity lambdaFillMaterial = 2.9
    "This is the thermal conductivity of the filling material (W/(m.K))";
end RecordPipes;
