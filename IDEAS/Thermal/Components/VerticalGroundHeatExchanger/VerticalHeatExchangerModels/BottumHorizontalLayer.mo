within IDEAS.Thermal.Components.VerticalGroundHeatExchanger.VerticalHeatExchangerModels;
model BottumHorizontalLayer "Represents the bottum horizontallayer"
                            extends HorizontalLayer(redeclare
      VerticalGroundHeatExchanger.Borehole.Borehole.BottumPipesOfBorehole
      pieceOfBoreHole(recordPipeCapacitor=recordPipeCapacitor));
// **************
// This model represents the bottom horizontal layer.
// A horizontal layer consists of earth, filling material and the borehole.
// All three of them are connected.
// The difference with the horizontal layer is the piece of borehole.
// **************
end BottumHorizontalLayer;
