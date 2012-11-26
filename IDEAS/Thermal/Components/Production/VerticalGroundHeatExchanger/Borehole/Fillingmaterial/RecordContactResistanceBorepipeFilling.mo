within IDEAS.Thermal.Components.Production.VerticalGroundHeatExchanger.Borehole.Fillingmaterial;
record RecordContactResistanceBorepipeFilling
  "Record containing the information for the contact resistance."

parameter Modelica.SIunits.Length depthOfEarth = 10
    "This represents the 1/10 of the total depth of the borehole (m)";
parameter Modelica.SIunits.ThermalDiffusivity alphaSole = 4.36*2.6/(0.014*2)
    "This is the thermal diffusivity of the brine... not necessairy in here I think";
parameter Modelica.SIunits.Radius radiusPipe=0.015
    "This is the radius of the pipe (m)";
parameter Modelica.SIunits.Radius radiusBorehole=0.057
    "This is the radius of the borehole (m)";
parameter Modelica.SIunits.ThermalConductivity lambdaFilling=2.6
    "This is the thermal conductivity of the filling material (W/(m.K))";

end RecordContactResistanceBorepipeFilling;
