within IDEAS.Thermal.Components.VerticalGroundHeatExchanger.Borehole.Fillingmaterial;
function CalculateContactResistanceFillingsideEarth
  "Calculates the resistance from the fillingmaterial towards the earth."
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
// This is the thermal conductivity of the filling material
input Modelica.SIunits.ThermalConductivity lambdaFillMaterial;
// This is the radius of the pipe
input Modelica.SIunits.Radius radiusPipe;
// This is the radius of the borehole.
input Modelica.SIunits.Radius radiusBorehole;
// **************
// OUTPUT
// **************
// This is the thermal conductance (W/K)
output Modelica.SIunits.ThermalResistance thermalResistance;
      // **************
      // * parameters *
      // **************
// This parameter represents the weighted inner radius.
protected
Modelica.SIunits.Radius weightedInnerRadius =  sqrt((radiusBorehole^2 + radiusPipe^2)/2);
algorithm
// This parameter represents the weighted inner radius.
weightedInnerRadius := sqrt((radiusBorehole^2 + radiusPipe^2)/2);
thermalResistance := Modelica.Math.log(radiusBorehole/(weightedInnerRadius))/(depthOfEarth*Modelica.Constants.pi*2*lambdaFillMaterial);
end CalculateContactResistanceFillingsideEarth;
