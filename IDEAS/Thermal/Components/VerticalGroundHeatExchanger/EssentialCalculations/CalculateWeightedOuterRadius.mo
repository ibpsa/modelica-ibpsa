within IDEAS.Thermal.Components.VerticalGroundHeatExchanger.EssentialCalculations;
function CalculateWeightedOuterRadius
  "Calculates the weighted radius outwards the node."
  // **********
  // This function calculates the mass weigthed outer radius of the given array of radius and
  // the given weigthed radius.
  // **********
// **************
// INPUT
// **************
    // The radius to calculate the mass weigthed radius of.
    input Modelica.SIunits.Radius radius[:];
    // The weigthed radius to calculated with.
    input Modelica.SIunits.Radius weightedRadius[:];
// **************
// OUTPUT
// **************
    // The weigthed outer radius.
    output Modelica.SIunits.Radius weightedOuterRadius[size(radius,1)-1];
algorithm
for i in 1:size(weightedRadius,1)-1 loop
  weightedOuterRadius[i] := weightedRadius[i+1];
end for;
weightedOuterRadius[size(weightedOuterRadius,1)] := radius[size(radius,1)];
end CalculateWeightedOuterRadius;
