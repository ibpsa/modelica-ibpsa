within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Types;
type BoreHoleConfiguration = enumeration(
    SingleUTube
              "Single U-Tube configuration",
    DoubleUTubeParallel
                      "Double parallel U-Tube configuration: pipes connected in parallel",
    DoubleUTubeSerie
                   "Double serie U-Tube configuration: pipes connected in series") "Enumaration to define the borehole configurations";
