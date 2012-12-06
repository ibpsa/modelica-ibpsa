within IDEAS.Thermal.Components.GroundHeatExchanger.ModelDieterPatteeuw.EssentialCalculations;
function CalculateMassWeightedRadius
  "Calculates the masscentre of the radius with the given radius."
  // **********
  // This function calculates the mass weighted radius of the given array of radius.
  // The mass weigthed radius is the same as the inner weigthed radius.
  // **********
// **************
// INPUT
// **************
    // The radius to calculate the mass weigthed radius of.
    input Modelica.SIunits.Radius radius[:];
// **************
// OUTPUT
// **************
    output Modelica.SIunits.Radius weightedRadius[size(radius,1) - 1];
algorithm
  for index in 1:size(radius,1) - 1 loop
    weightedRadius[index] :=  sqrt((radius[index+1]^2  + radius[index]^2)/2);
  end for;
  // Based on Bianchi Bianchi p 179. EWS-model takes middlepoint. This is the massgravitycentre?
  // Fault in Biahchi, minussign should be plus sign...
end CalculateMassWeightedRadius;
