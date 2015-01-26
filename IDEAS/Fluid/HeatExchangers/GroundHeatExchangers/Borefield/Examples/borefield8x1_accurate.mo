within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Examples;
model borefield8x1_accurate
  "Model of a borefield in a 8x1 boreholes line configuration and a constant heat injection rate"
  extends
    IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Examples.borefield8x1
    ( redeclare
      IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.BorefieldData.SandStone_Bentonite_c8x1_h110_b5_d600_T283
                                                                                                          bfData);
end borefield8x1_accurate;
