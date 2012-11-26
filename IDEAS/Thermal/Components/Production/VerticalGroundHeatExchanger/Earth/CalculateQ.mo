within IDEAS.Thermal.Components.Production.VerticalGroundHeatExchanger.Earth;
function CalculateQ
  "This function calculates the heatflow in a cilinder, given the heatflow per square and the radius of the cilinder."
input Real QperSquare "Heatflow per square";
input Real[:] radias "Radia to calculate with";
input Integer size;
output Real[size] Q;
algorithm
  for index in 1:size loop
    Q[index] :=QperSquare*Modelica.Constants.pi*(radias[index + 1]^2 - radias[index]^2);
  end for;
end CalculateQ;
