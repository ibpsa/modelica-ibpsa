within IDEAS.Thermal.Components.GroundHeatExchanger.ModelDieterPatteeuw.Earth;
model EarthringUnder "See earthring, should be inheritance... no time"
parameter RecordEarthLayer recordEarthLayer;
parameter Modelica.SIunits.Radius innerRadius = 1;
parameter Modelica.SIunits.Radius outerRadius = 10;
parameter Modelica.SIunits.Radius weightedRadius = sqrt((innerRadius^2 + outerRadius^2)/2);
parameter Modelica.SIunits.Temperature startTemperature=288;
EarthResistor earthResistorOutWard(thermalResistance=
        CalculateEarthResistance(
                  recordEarthLayer.depthOfEarthUnder,
                  recordEarthLayer.lambda,
                  outerRadius,
                  weightedRadius));
EarthResistor earthResistorInWard(thermalResistance=
        CalculateEarthResistance(
                  recordEarthLayer.depthOfEarthUnder,
                  recordEarthLayer.lambda,
                  weightedRadius,
                  innerRadius));
EarthCapacitor earthCapacitor(capacity=CalculateEarthCapacitie(
                  recordEarthLayer.depthOfEarthUnder,
                  recordEarthLayer.heatCapacitanceEarth,
                  recordEarthLayer.densityEarth,
                  innerRadius,
                  outerRadius), startTemperature=startTemperature);
VerticalHeatExchangerModels.VerticalResistor verticalResistorUp(
    lambda=recordEarthLayer.lambda,
    depthOfEarth=recordEarthLayer.depthOfEarthUnder/2,
    innerRadius=innerRadius,
    outerRadius=outerRadius);
VerticalHeatExchangerModels.VerticalResistor verticalResistorDown(
    lambda=recordEarthLayer.lambda,
    depthOfEarth=recordEarthLayer.depthOfEarthUnder/2,
    innerRadius=innerRadius,
    outerRadius=outerRadius);

// Help variable: Temperature of earthRing is defined on the outwardRadius;
Modelica.SIunits.Temperature getTemperature;

equation
connect(verticalResistorUp.port_b,earthCapacitor.portA);
connect(verticalResistorDown.port_a,earthCapacitor.portA);
connect(earthResistorOutWard.port_a,earthCapacitor.portA);
connect(earthResistorInWard.port_b,earthCapacitor.portA);

getTemperature = earthResistorOutWard.port_b.T;

end EarthringUnder;
