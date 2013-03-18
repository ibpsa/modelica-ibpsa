within IDEAS.Thermal.Components.GroundHeatExchanger.ModelDieterPatteeuw.Borehole.Fillingmaterial;
model FillingMaterialCapacitor "The fillingmaterials capacitor"
// **************
// This model represents the capacitor of the filling material.
// **************
      // **************
      // * parameters *
      // **************
// This parameter contains all the essential information for calculating the capacity.
parameter RecordFillingMaterialCapacitor recordFillingMaterialCapacitor;
// The capacity is calculated with the data in recordFillingMaterialCapacitor.
parameter Modelica.SIunits.HeatCapacity capacity = CalculateFillingMaterialCapacitor(
recordFillingMaterialCapacitor.depthOfEarth,
recordFillingMaterialCapacitor.heatCapacitanceFillig,
recordFillingMaterialCapacitor.densityFillig,
recordFillingMaterialCapacitor.innerRadius,
recordFillingMaterialCapacitor.outerRadius);
      // **************
      // * variables *
      // **************
// This variable represent the temperature of the filling material.
Modelica.SIunits.Temperature temperature(start=recordFillingMaterialCapacitor.startTemperature, displayUnit="degC")
    "Temperature of element";
// This heatport represents the heatport of the capacitor.
Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a portA;
equation
  temperature = portA.T;
  capacity*der(temperature) = portA.Q_flow;
end FillingMaterialCapacitor;
