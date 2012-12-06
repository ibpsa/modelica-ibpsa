within IDEAS.Thermal.Components.GroundHeatExchanger.ModelDieterPatteeuw.Borehole.Borehole;
model BottumPipesOfBorehole "The two bottumpipes of the borehole"
  extends PipesOfBorehole;
// **************
// This model represents a piece of borehole, containing two pipes, but no fillingmaterial.
// This model has aswell the connection point for the filling material, namely, the mean temperature.
// Its the bottom piece of borehole, so the upwardpipe and the downward pipe are connected.
// **************
equation
  connect(downwardPipe.flowPort_b,upwardPipe.flowPort_a);
end BottumPipesOfBorehole;
