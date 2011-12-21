within IDEAS.Thermal.Components.VerticalGroundHeatExchanger.Earth;
model EarthLayer
// **************
// This model generates a connection between different earthrings.
// The connection of earthrings defines a layer in the earth.
// The parameters for generating are given in the recordEarthLayer.
// Port_a is directed towards the borehole. port_b is directed opposited of port_a.
// **************
      // **************
      // * parameters *
      // **************
      // This record contains all the parameters concerning the earth.
      parameter RecordEarthLayer recordEarthLayer;
      // The number of the layer
      parameter Real numberOfLayer;
      // The temperature difference to the bottom
      parameter Real differenceToBottum= recordEarthLayer.totalDepth - recordEarthLayer.depthOfEarth*(numberOfLayer - 1/2);
      parameter Real offset = 0;
      // **************
      // * Variables *
      // **************
      // Define all the earth resistors.

    // The rings of the earth.
public
    Earthring[recordEarthLayer.numberOfHorizontalNodes - 1] earthRings(
    each recordEarthLayer=recordEarthLayer,
    innerRadius=recordEarthLayer.radius[1:(size(recordEarthLayer.radius, 1) - 1)],
    outerRadius=recordEarthLayer.radius[2:(size(recordEarthLayer.radius,
        1))],
    each startTemperature=-recordEarthLayer.gradient*
        differenceToBottum + recordEarthLayer.bottumTemperature);

     // boundary condition
      Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedHeatFlow(Q_flow = 0);
equation
  // Connect every ring
       for index in 1:(size(earthRings,1)-1) loop
          connect(earthRings[index].earthResistorOutWard.port_b,earthRings[index+1].earthResistorInWard.port_a);
       end for;

       // connect the boundary condition
       connect(earthRings[size(earthRings,1)].earthResistorOutWard.port_b, fixedHeatFlow.port);
end EarthLayer;
