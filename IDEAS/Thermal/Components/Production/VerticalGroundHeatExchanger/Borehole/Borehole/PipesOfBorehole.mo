within IDEAS.Thermal.Components.Production.VerticalGroundHeatExchanger.Borehole.Borehole;
model PipesOfBorehole
// **************
// This model represents a piece of borehole, containing two pipes, but no fillingmaterial.
// This model has aswell the connection point for the filling material, namely, the mean temperature.
// **************
      // **************
      // * parameters *
      // **************
// The record containing all the necasairy information for making two pipes.
parameter RecordPipes recordPipeCapacitor;
parameter AdaptedFluid.Medium medium;
// pipe upward. port_b is the port closest to the top of earth.
AdaptedFluid.HeatedPipe upwardPipe(
    len=recordPipeCapacitor.depthOfEarth,
    diam=recordPipeCapacitor.radiusPipe,
    medium=medium,
    medium2=medium,
    T0=recordPipeCapacitor.startTemperature,
    Rad=recordPipeCapacitor.radiusPipe,
    h_g=-recordPipeCapacitor.depthOfEarth,
    L=recordPipeCapacitor.depthOfEarth);
 // pipe downward port_a is the port closest to the top of earth.
AdaptedFluid.HeatedPipe downwardPipe(
    len=recordPipeCapacitor.depthOfEarth,
    diam=recordPipeCapacitor.radiusPipe,
    medium=medium,
    medium2=medium,
    T0=recordPipeCapacitor.startTemperature,
    Rad=recordPipeCapacitor.radiusPipe,
    h_g=recordPipeCapacitor.depthOfEarth,
    L=recordPipeCapacitor.depthOfEarth);
// The pipe convection.
ContactResistanceFillingPipeside contactResistanceUpwardPipe(
      recordPipeCapacitor=recordPipeCapacitor);
ContactResistanceFillingPipeside contactResistanceDownwardPipe(
      recordPipeCapacitor=recordPipeCapacitor);
equation
  connect(upwardPipe.heatPort,contactResistanceUpwardPipe.port_a);
  connect(downwardPipe.heatPort,contactResistanceDownwardPipe.port_a);
end PipesOfBorehole;
