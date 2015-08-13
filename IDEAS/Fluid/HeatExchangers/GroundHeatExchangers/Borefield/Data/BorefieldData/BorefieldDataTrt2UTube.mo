within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.BorefieldData;
record BorefieldDataTrt2UTube =
                          Records.BorefieldData (
    pathMod = "IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.BorefieldData.BorefieldDataTrt2UTube",
    pathCom = Modelica.Utilities.Files.loadResource("modelica://IDEAS/Fluid/HeatExchangers/GroundHeatExchangers/Borefield/Data/BorefieldData/BorefieldDataTrt2UTube.mo"),
    redeclare replaceable record Soi =
        SoilData.SoilTrt,
    redeclare replaceable record Fil =
        FillingData.FillingTrt,
    redeclare replaceable record Gen =
        GeneralData.GeneralTrt2UTube)
  "BorefieldData record for bore field validation using thermal response test";
