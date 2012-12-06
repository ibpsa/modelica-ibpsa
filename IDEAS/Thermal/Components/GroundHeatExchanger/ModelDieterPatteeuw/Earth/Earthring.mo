within IDEAS.Thermal.Components.GroundHeatExchanger.ModelDieterPatteeuw.Earth;
model Earthring
  "This class represents a ring of earth, containing a earth capacitor and for connections (up, down, inward, outward)"
parameter RecordEarthLayer recordEarthLayer
    "Record containing the necessairy information";
parameter Modelica.SIunits.Radius innerRadius = 1 "The inner radius";
parameter Modelica.SIunits.Radius outerRadius = 10 "the outer radius ";
parameter Modelica.SIunits.Radius weightedRadius = sqrt((innerRadius^2 + outerRadius^2)/2)
    "The weighted radius";
parameter Modelica.SIunits.Temperature startTemperature=288
    "The starttemperature of this ring of earth";

// Two earth resistors, inward and outward.
EarthResistor earthResistorOutWard(thermalResistance=
        CalculateEarthResistance(
                  recordEarthLayer.depthOfEarth,
                  recordEarthLayer.lambda,
                  outerRadius,
                  weightedRadius));
EarthResistor earthResistorInWard(thermalResistance=
        CalculateEarthResistance(
                  recordEarthLayer.depthOfEarth,
                  recordEarthLayer.lambda,
                  weightedRadius,
                  innerRadius));

// The earth capacitor
EarthCapacitor earthCapacitor(capacity=CalculateEarthCapacitie(
                  recordEarthLayer.depthOfEarth,
                  recordEarthLayer.heatCapacitanceEarth,
                  recordEarthLayer.densityEarth,
                  innerRadius,
                  outerRadius), startTemperature=startTemperature);

//Two vertical resistors.
VerticalHeatExchangerModels.VerticalResistor verticalResistorUp(
    lambda=recordEarthLayer.lambda,
    depthOfEarth=recordEarthLayer.depthOfEarth/2,
    innerRadius=innerRadius,
    outerRadius=outerRadius);
VerticalHeatExchangerModels.VerticalResistor verticalResistorDown(
    lambda=recordEarthLayer.lambda,
    depthOfEarth=recordEarthLayer.depthOfEarth/2,
    innerRadius=innerRadius,
    outerRadius=outerRadius);

// Help variable: Temperature of earthRing is defined on the outwardRadius;
Modelica.SIunits.Temperature getTemperature;
equation

//Every resistor is connected to one point. Towards the borehole is always port_a in the horizontal direction.
//  In the vertical direction is port_a the most upper port.
connect(verticalResistorUp.port_b,earthCapacitor.portA);
connect(verticalResistorDown.port_a,earthCapacitor.portA);
connect(earthResistorOutWard.port_a,earthCapacitor.portA);
connect(earthResistorInWard.port_b,earthCapacitor.portA);

getTemperature = earthResistorOutWard.port_b.T;

end Earthring;
