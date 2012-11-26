within IDEAS.Thermal.Components.Production.VerticalGroundHeatExchanger.EssentialCalculations;
function CalculateRadius "This function calculates the radiuspoints of the earth given the radius of the pipe, the borehole radius,
  the last radius and the number of intervals."
input Real boreholeRadius "The radius of the borehole [m].";
input Real outerRadius "The farest radius [m].";
input Integer numberOfIntervals "The number of intervals [/].";
// **************
// OUTPUT
// **************
output Real radius[numberOfIntervals] "All the radius points of the model [m].";
algorithm
  radius[1]:=boreholeRadius;
for index in 2:numberOfIntervals loop
radius[index] := radius[index-1] + (outerRadius-boreholeRadius)*(1-2)/(1-2^(numberOfIntervals-1))*2^(index-2);
end for;
// Based on page 178 Bianchi
end CalculateRadius;
