within IDEAS.Thermal.Components.Production.VerticalGroundHeatExchanger.Earth;
model EarthLayerNotInUse
  // Not in use anymore, could be faster if used. Difference, no earthring, less equations.

//  OPGELET! FOR LUS VAN CONNECTIES WERKEN NIET IN JMODELICA!
//  Vermits het niet werkt, alle connecties met de hand coderen!
// **************
// This model generates a connection of capacitors en resistors of the earth.
// The parameters for generating are given in the recordEarthLayer.
// Port_a is directed towards the borehole. port_b is directed opposited of port_a.
// The last resistor is connected to a fixed temperature, the end-temperature.
// **************
      // **************
      // * parameters *
      // **************
      // This record contains all the parameters concerning the earth.
      parameter RecordEarthLayer recordEarthLayer;
      // Calculate all the inductances of the earth resistor.
      parameter CalculateResistors calculatedRecordsEarthResistor(
       depthOfEarth=recordEarthLayer.depthOfEarth,
      radius=recordEarthLayer.radius,
      lambda=recordEarthLayer.lambda);
      // Calculate all the capacities of the earth capacitors
      parameter CalculateCapacitors calculatedRecordsEarthCapacitor(radius=recordEarthLayer.radius,
      depthOfEarth=recordEarthLayer.depthOfEarth,
      densityEarth=recordEarthLayer.densityEarth,
      heatCapacitanceEarth=recordEarthLayer.heatCapacitanceEarth);
      parameter Real numberOfLayer;
      parameter Real differenceToBottum= recordEarthLayer.totalDepth - recordEarthLayer.depthOfEarth*(numberOfLayer - 1/2);
      parameter Real offset = 0;
      // **************
      // * Variables *
      // **************
      // Define all the earth resistors.
public
      EarthResistor[size(recordEarthLayer.radius,1)-1] resistors(thermalResistance=calculatedRecordsEarthResistor.thermalResistance); //,each
      //startTemperature =       recordEarthLayer.startTemperature);
      // Define all the earth capacitors.
      EarthCapacitor[size(recordEarthLayer.radius,1)-1] capacitors(capacity = calculatedRecordsEarthCapacitor.capacities,each
      startTemperature =      -recordEarthLayer.gradient*differenceToBottum + recordEarthLayer.bottumTemperature);
      ContactResistanceEarthSideFilling contactResistanceEarthSideFilling(recordEarthLayer=recordEarthLayer);
      // Define the end temperature
      Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedTemperature(   Q_flow = 0);
      VerticalHeatExchangerModels.VerticalResistor[size(
    recordEarthLayer.radius, 1) - 1] verticalResistors(
    each lambda=recordEarthLayer.lambda,
    each depthOfEarth=recordEarthLayer.depthOfEarth/2,
    innerRadius=recordEarthLayer.radius[1:size(recordEarthLayer.radius,
        1) - 1],
    outerRadius=recordEarthLayer.radius[2:size(recordEarthLayer.radius,
        1)]);

   VerticalHeatExchangerModels.VerticalResistor[size(recordEarthLayer.radius,
    1) - 1] verticalResistorsUp(
    each lambda=recordEarthLayer.lambda,
    each depthOfEarth=recordEarthLayer.depthOfEarth/2,
    innerRadius=recordEarthLayer.radius[1:size(recordEarthLayer.radius,
        1) - 1],
    outerRadius=recordEarthLayer.radius[2:size(recordEarthLayer.radius,
        1)]);

equation
       connect(resistors[1].port_a, contactResistanceEarthSideFilling.port_b);
       for index in 1:size(resistors,1) loop
          connect(resistors[index].port_a,capacitors[index].portA);
       end for;
       for index in 1:size(resistors,1)-1 loop
          connect(resistors[index].port_b,resistors[index + 1].port_a);
       end for;
       connect(resistors[size(resistors,1)].port_b, fixedTemperature.port);
      for index in 1:size(capacitors,1) loop
          connect(capacitors[index].portA,verticalResistors[index].port_a);
      end for;
      for index in 1:size(capacitors,1) loop
          connect(capacitors[index].portA,verticalResistorsUp[index].port_b);
      end for;
end EarthLayerNotInUse;
