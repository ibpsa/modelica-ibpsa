within IDEAS.Thermal.Components.VerticalGroundHeatExchanger.Earth;
model BlockEarth
      // This record contains all the parameters concerning the earth.
      parameter RecordEarthLayer recordEarthLayer;
      // Radius of a pipe.
      parameter Modelica.SIunits.Radius radiusPipe = 0.025;
// Layers beneath the borehole.
parameter Integer layers = recordEarthLayer.numberOfVerticalBottumLayers;
// The layers in the block beneath the borehole.
BlockEarthLayer[layers] blockEarthLayer(
    each recordEarthLayer=recordEarthLayer,
    each radiusPipe=radiusPipe,
    numberOfLayer=1:recordEarthLayer.numberOfVerticalBottumLayers);
//UNCOMMENT VOOR FLUX ONDERAAN
// The fixed temperature beneath downwards.
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow[size(blockEarthLayer[1].earthRings,1)]
    earthFlux(   Q_flow=CalculateQ(0.040,radia,size(recordEarthLayer.radius,1)+1));
Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow[size(blockEarthLayer[1].earthRings,1)]
    fixedFlows(each Q_flow = 0);
parameter Real[size(recordEarthLayer.radius,1)+2] radia = ConstructArray(               radiusPipe,recordEarthLayer.radius,size(recordEarthLayer.radius,1)+2);
equation
        // Connect the layers in between.
       for index in 1:layers-1 loop
          for index2 in 1:size(blockEarthLayer[1].earthRings,1) loop
              connect(blockEarthLayer[index].earthRings[index2].verticalResistorDown.port_b,blockEarthLayer[index+1].earthRings[index2].verticalResistorUp.port_a);
          end for;
       // Connect the bottum layer with the fixed tempeartues.
       end for;
       for index in 1:size(blockEarthLayer[1].earthRings,1) loop
              connect(blockEarthLayer[layers].earthRings[index].verticalResistorDown.port_b,fixedFlows[index].port);
       end for;
//UNCOMMENT VOOR FLUX ONDERAAN
         for index in 1:size(blockEarthLayer[1].earthRings,1) loop
                connect(blockEarthLayer[layers].earthRings[index].verticalResistorDown.port_a,earthFlux[index].port);
         end for;
end BlockEarth;
