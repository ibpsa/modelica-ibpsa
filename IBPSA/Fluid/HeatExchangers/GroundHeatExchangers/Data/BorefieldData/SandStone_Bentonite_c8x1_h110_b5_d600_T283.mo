within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.BorefieldData;
record SandStone_Bentonite_c8x1_h110_b5_d600_T283 = Records.BorefieldData (
    pathMod=
        "IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.BorefieldData.SandStone_Bentonite_c8x1_h110_b5_d600_T283",
    pathCom=Modelica.Utilities.Files.loadResource(
        "modelica://IBPSA/Fluid/HeatExchangers/GroundHeatExchangers/Data/BorefieldData/SandStone_Bentonite_c8x1_h110_b5_d600_T283.mo"),
    redeclare replaceable record Soi = SoilData.SandStone,
    redeclare replaceable record Fil = FillingData.Bentonite,
    redeclare replaceable record Gen = GeneralData.c8x1_h110_b5_d600_T283)
  "Borefield with 8x1 boreholes with Bentonite filling and Sandstone soil";
