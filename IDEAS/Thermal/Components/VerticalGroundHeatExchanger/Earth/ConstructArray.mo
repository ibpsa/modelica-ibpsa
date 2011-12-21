within IDEAS.Thermal.Components.VerticalGroundHeatExchanger.Earth;
function ConstructArray
  // Constructs an array with the necessairy givens for creating a BlockEartLayer
// The radius of the pipe.
input Modelica.SIunits.Radius radiusPipe;
input Modelica.SIunits.Radius[:] radius;
input Integer size;
// **************
// OUTPUT
// **************
// All the radius points of the model.
output Real totalRadius[size];
algorithm
  totalRadius[1]:=0;
  totalRadius[2]:= radiusPipe;
for index in 3:size loop
totalRadius[index] := radius[index-2];
end for;
end ConstructArray;
