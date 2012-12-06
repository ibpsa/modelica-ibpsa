within IDEAS.Thermal.Components.GroundHeatExchanger.ModelDieterPatteeuw.Borehole.Fillingmaterial;
record RecordFillingMaterialCapacitor
  "Record containing the neccaisary inforamtion about the filling material capacitor."
parameter Modelica.SIunits.Temperature startTemperature = 288
    "This is the start temperature of the capacitor (K).";
parameter Modelica.SIunits.Length depthOfEarth =  10
    " This represents the 1/10 of the total depth of the borehole (m)";
parameter Modelica.SIunits.SpecificHeatCapacity heatCapacitanceFillig =  750
    "This is the specific heat capacity of the earth (J/(kg.K))";
parameter Modelica.SIunits.Density densityFillig =  3000
    " This is the density of the fillling material (kg/m3";
parameter Modelica.SIunits.Radius innerRadius = 0.01
    "This is the inner of the pipe (m)";
parameter Modelica.SIunits.Radius outerRadius = 0.13
    "This is the radius of the borehole (m)";
end RecordFillingMaterialCapacitor;
