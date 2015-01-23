within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Examples;
model borefield8x8_accurate
  "Model of a borefield in a 8x8 boreholes square configuration and a constant heat injection rate"
  extends
    IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Examples.borefield8x1
    (                                                                                      redeclare
      Data.BorefieldData.SandStone_Bentonite_c8x8_h110_b5_d600_T283                                                                                                bfData);
end borefield8x8_accurate;
