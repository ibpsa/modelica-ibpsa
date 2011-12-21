within IDEAS.Thermal.Components.VerticalGroundHeatExchanger.Borehole.Fillingmaterial;
record RecordContactResistanceEarthBoreHole
  "Record containing the information for the contact resistance."
parameter Modelica.SIunits.Length depthOfEarth = 10
    "This represents the 1/10 of the total depth of the borehole (m)";
parameter Modelica.SIunits.ThermalConductivity lambdaFillMaterial =  2.6
    "This is the thermal conductivity of the filling material (W/(m.K))";
parameter Modelica.SIunits.ThermalConductivity lambdaEarth =  1.3
    "This is the thermal conductivity of the earth (W/(m.K))";
parameter Modelica.SIunits.Radius radiusBorehole =  0.057
    "This is the radius of the borehole (m)";
parameter Modelica.SIunits.Radius radiusPipe = 0.015
    "This is the radius of the pipe (m)";
end RecordContactResistanceEarthBoreHole;
