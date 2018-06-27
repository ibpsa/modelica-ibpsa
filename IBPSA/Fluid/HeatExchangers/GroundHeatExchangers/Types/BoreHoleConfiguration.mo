within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Types;
type BoreholeConfiguration = enumeration(
    SingleUTube
    "Single U-Tube configuration",
    DoubleUTubeParallel
    "Double parallel U-Tube configuration: pipes connected in parallel",
    DoubleUTubeSeries
    "Double series U-Tube configuration: pipes connected in series")
  "Enumaration to define the borehole configurations";
