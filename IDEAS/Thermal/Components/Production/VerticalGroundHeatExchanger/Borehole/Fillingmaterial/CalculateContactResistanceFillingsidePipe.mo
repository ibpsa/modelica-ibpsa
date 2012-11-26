within IDEAS.Thermal.Components.Production.VerticalGroundHeatExchanger.Borehole.Fillingmaterial;
function CalculateContactResistanceFillingsidePipe
  "Calculates the contact resistance towards the pipes."
// **************
// This function calculates the thermal conductance of the contact resistance between the
// filling material and the pipes given the depth of earth, the thermal diffusivity of the brine,
// the thermal conductivity of the filling material, the radius of the pipe
// and the radius of the borehole.
// **************
// **************
// INPUT
// **************
// This represents the 1/10 of the total depth of the borehole (m)
input Modelica.SIunits.Length depthOfEarth;
// This is the thermal conductivity of the filling material
input Modelica.SIunits.ThermalConductivity lambdaFilling;
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
// This parameter represents the weigthed inner radius.
protected
Modelica.SIunits.Radius weightedInnerRadius =  sqrt((radiusBorehole^2 + radiusPipe^2)/2);
algorithm
weightedInnerRadius := sqrt((radiusBorehole^2 + radiusPipe^2)/2);
// What should this be? Is it 0.5*radiusBorehole or sqrt(2)*radiusborehole*2, bring in spacing between pipes?
// This is a crucial point...
// Paper describes the resistance with this formula... Don't forget to multiply the resistance by two...
thermalResistance := Modelica.Math.log((radiusBorehole-weightedInnerRadius) /(radiusPipe))/(4*Modelica.Constants.pi*depthOfEarth*lambdaFilling);
//thermalResistance :=  radiusBorehole^2/(lambdaFilling*(radiusBorehole - weightedInnerRadius)*foefel);
// The EWS Model gievers this as formula. I don't think the dimensions are right...
//thermalResistance :=  (radiusBorehole^2/sqrt(2))/(lambdaFilling);
// I propose the next:
//(radiusBorehole^2/sqrt(2))/(Modelica.Constants.pi*depthOfEarth*lambdaFilling);
end CalculateContactResistanceFillingsidePipe;
