within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.BorefieldData;
record BorefieldDataTrt = Records.BorefieldData (
    pathMod = "IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.BorefieldData.BorefieldDataTrt",
    pathCom = Modelica.Utilities.Files.loadResource("modelica://IDEAS/Fluid/HeatExchangers/GroundHeatExchangers/Borefield/Data/BorefieldData/BorefieldDataTrt.mo"),
    redeclare replaceable record Soi =
        IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.SoilData.SoilTrt,
    redeclare replaceable record Fil =
        IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.FillingData.FillingTrt,
    redeclare replaceable record Gen =
        IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.GeneralData.GeneralTrt)
  "BorefieldData record for bore field validation using thermal response test";
