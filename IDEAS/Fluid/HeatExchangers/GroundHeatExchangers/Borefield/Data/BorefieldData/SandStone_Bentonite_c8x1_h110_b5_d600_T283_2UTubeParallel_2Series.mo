within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.BorefieldData;
record SandStone_Bentonite_c8x1_h110_b5_d600_T283_2UTubeParallel_2Series =
                                                    Records.BorefieldData (
    pathMod=
        "IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.BorefieldData.SandStone_Bentonite_c8x1_h110_b5_d600_T283_2UTubeParallel_2Series",
    pathCom=Modelica.Utilities.Files.loadResource(
        "modelica://IDEAS/Fluid/HeatExchangers/GroundHeatExchangers/Borefield/Data/BorefieldData/SandStone_Bentonite_c8x1_h110_b5_d600_T283_2UTubeParallel_2Series.mo"),
    redeclare replaceable record Soi = SoilData.SandStone,
    redeclare replaceable record Fil = FillingData.Bentonite,
    redeclare replaceable record Gen =
        GeneralData.c8x1_h110_b5_d600_T283_2UTubeParallel_2Series)
  "Borefield with 8x1 boreholes with Bentonite filling and Sandstone soil";
