within IDEAS.Thermal.Components.VerticalGroundHeatExchanger.VerticalHeatExchangerModels;
model BoreHole "Vertical ground/brine heat exchanger, single borehole"

    replaceable parameter
    Thermal.Components.VerticalGroundHeatExchanger.VerticalHeatExchangerModels.AlTheParameters
    alTheParameters                                                                                                   annotation(choicesAllMatching=true);
    CreateRecords allTheRecords(alTheParameters=alTheParameters);
    parameter Thermal.Data.Interfaces.Medium medium=Data.Media.Water();
      // **************
      // * variables *
      // **************
      // This array contains the horizontallayers.

protected
    HorizontalLayer[allTheRecords.alTheParameters.numberOfVerticalBoreholeLayers
     - 1] horizontalLayers(
    each recordContactResistanceBorepipeFilling=allTheRecords.recordContactResistanceBorepipeFilling,
    each recordContactResistanceEarthBoreHole=allTheRecords.recordContactResistanceEarthBoreHole,
    each recordEarthLayer=allTheRecords.recordEarthLayer,
    each recordPipeCapacitor=allTheRecords.recordPipeCapacitor,
    each recordFillingMaterialCapacitor=allTheRecords.recordFillingMaterialCapacitor,
    each medium=medium,
    numberOfLayer=1:(allTheRecords.alTheParameters.numberOfVerticalBoreholeLayers
         - 1),
    each offset=0);

      // This variable represents the bottum horizontal layer.
    BottumHorizontalLayer bottumHorizontalLayer(
    recordContactResistanceBorepipeFilling=allTheRecords.recordContactResistanceBorepipeFilling,
    recordContactResistanceEarthBoreHole=allTheRecords.recordContactResistanceEarthBoreHole,
    recordEarthLayer=allTheRecords.recordEarthLayer,
    recordPipeCapacitor=allTheRecords.recordPipeCapacitor,
    recordFillingMaterialCapacitor=allTheRecords.recordFillingMaterialCapacitor,
    medium=medium,
    numberOfLayer=allTheRecords.alTheParameters.numberOfVerticalBoreholeLayers);

    Earth.BlockEarth blockEarth(recordEarthLayer=allTheRecords.recordEarthLayer,
      radiusPipe=allTheRecords.recordPipeCapacitor.radiusPipe);
    Earth.TopOnGround[size(horizontalLayers[1].earthLayer.earthRings,
    1)] topOnGround(each recordEarthLayer=allTheRecords.recordEarthLayer,
      index=1:size(horizontalLayers[1].earthLayer.earthRings, 1));

    Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixedFlowSpeciaal(Q_flow=0);

public
  Modelica.SIunits.Temperature TIn=flowPort_a.h/medium.cp;
  Modelica.SIunits.Temperature TOut=flowPort_b.h/medium.cp;
  Modelica.SIunits.Power QNet=flowPort_a.H_flow + flowPort_a.H_flow;

  AdaptedFluid.FlowPort_a flowPort_a(medium = medium)
    annotation (Placement(transformation(extent={{-108,-12},{-88,8}})));
  AdaptedFluid.FlowPort_b flowPort_b(medium = medium)
    annotation (Placement(transformation(extent={{88,-10},{108,10}})));
  outer IDEAS.SimInfoManager         sim
    annotation (Placement(transformation(extent={{-90,74},{-70,94}})));
equation
  // The upwardpipe of layer x is connected with the upwardpipe of layer x + 1 (the massflow and the heatresistance)
  // The downwardpipe of layer x is connected with the downwardpipe of layer x + 1 (the massflow and the heatresistance)
       for index in 1:size(horizontalLayers,1)-1 loop
          connect(horizontalLayers[index].pieceOfBoreHole.downwardPipe.flowPort_b,horizontalLayers[index + 1].pieceOfBoreHole.downwardPipe.flowPort_a);
          connect(horizontalLayers[index].pieceOfBoreHole.upwardPipe.flowPort_a,horizontalLayers[index + 1].pieceOfBoreHole.upwardPipe.flowPort_b);
          connect(horizontalLayers[index].fillingMaterial.verticalResistor.port_b,horizontalLayers[index+1].fillingMaterial.verticalResistorUp.port_a);
          for index2 in 1:size(horizontalLayers[index].earthLayer.earthRings,1) loop
              connect(horizontalLayers[index].earthLayer.earthRings[index2].verticalResistorDown.port_b,horizontalLayers[index+1].earthLayer.earthRings[index2].verticalResistorUp.port_a);
          end for;
       end for;
      connect(horizontalLayers[size(horizontalLayers,1)].pieceOfBoreHole.downwardPipe.flowPort_b,bottumHorizontalLayer.pieceOfBoreHole.downwardPipe.flowPort_a);
      connect(horizontalLayers[size(horizontalLayers,1)].pieceOfBoreHole.upwardPipe.flowPort_a,bottumHorizontalLayer.pieceOfBoreHole.upwardPipe.flowPort_b);
      connect(horizontalLayers[size(horizontalLayers,1)].fillingMaterial.verticalResistor.port_b,bottumHorizontalLayer.fillingMaterial.verticalResistorUp.port_a);
      for index2 in 1:size(horizontalLayers[1].earthLayer.earthRings,1) loop
        connect(horizontalLayers[size(horizontalLayers,1)].earthLayer.earthRings[index2].verticalResistorDown.port_b,bottumHorizontalLayer.earthLayer.earthRings[index2].verticalResistorUp.port_a);
      end for;
      connect(bottumHorizontalLayer.fillingMaterial.verticalResistor.port_b,blockEarth.blockEarthLayer[1].earthRings[1].verticalResistorUp.port_a);
      connect(bottumHorizontalLayer.fillingMaterial.verticalResistor.port_b,blockEarth.blockEarthLayer[1].earthRings[2].verticalResistorUp.port_a);
      for index2 in 1:size(horizontalLayers[1].earthLayer.earthRings,1) loop
        connect(bottumHorizontalLayer.earthLayer.earthRings[index2].verticalResistorDown.port_b,blockEarth.blockEarthLayer[1].earthRings[index2+2].verticalResistorUp.port_a);
      end for;
       for index3 in 1:size(horizontalLayers[1].earthLayer.earthRings,1) loop
         connect(horizontalLayers[1].earthLayer.earthRings[index3].verticalResistorUp.port_a,topOnGround[index3].fixedTemperature.port);
       end for;
       for index3 in 1:size(horizontalLayers[1].earthLayer.earthRings,1) loop
         topOnGround[index3].fixedTemperature.port.T = sim.Te;
       end for;
    connect(fixedFlowSpeciaal.port,horizontalLayers[1].fillingMaterial.verticalResistorUp.port_a);
    connect(flowPort_a, horizontalLayers[1].pieceOfBoreHole.downwardPipe.flowPort_a);
    connect(flowPort_b, horizontalLayers[1].pieceOfBoreHole.upwardPipe.flowPort_b);
  annotation (Icon(graphics={Line(
          points={{-60,0},{-10,0},{-10,-96},{10,-96},{10,0},{62,0}},
          color={0,0,255},
          thickness=1,
          smooth=Smooth.None)}), Documentation(info="<html>
<p>The model is composed of different horizontal layers, each containing:</p>
<p><ul>
<li>a downward and upward pipe for the brine flow</li>
<li>filling material</li>
<li>different earth rings</li>
</ul></p>
<p>Below these layers there are a few layers without pipe to simulate the ground in more detail. </p>
<p>The layers are connected vertically, meaning that vertical heat transfer is possible. The initial temperature of each layer is different, but all capacities in a given layer are initialized on the same temperature. It depends on the geometry of the model, the vertical temperature gradient and the initial temperature at the depth of the borehole. </p>
<p>Attention: the references &apos;upward&apos; and &apos;downward&apos; pipe suppose connection of the input flowrate to the a-port.</p>
</html>", revisions="<html>
<p>Originally developed by Harm Leenders in his master thesis in 2010-2011.</p>
<p>26/11/2011 - Better initialization of the brine and filling material temperatures, Roel De Coninck.</p>
</html>"));
end BoreHole;
