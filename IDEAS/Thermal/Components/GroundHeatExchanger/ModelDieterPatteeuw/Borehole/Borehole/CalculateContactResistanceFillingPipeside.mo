within IDEAS.Thermal.Components.GroundHeatExchanger.ModelDieterPatteeuw.Borehole.Borehole;
function CalculateContactResistanceFillingPipeside
  "The convective heattransfer"
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
// This is the thermal diffusivity of the brine
input Modelica.SIunits.ThermalDiffusivity alphaSole;
// This is the radius of the pipe
input Modelica.SIunits.Radius radiusPipe;
// **************
// OUTPUT
// **************
// This is the thermal conductance (W/K)
output Modelica.SIunits.ThermalResistance thermalResistance;
      // **************
      // * parameters *
      // **************
     // parameter Real uhx = 60; This is standard used in the EWS model.
// This parameter represents the weigthed inner radius.
algorithm
thermalResistance := 2/(alphaSole*Modelica.Constants.pi*depthOfEarth*radiusPipe);
end CalculateContactResistanceFillingPipeside;
