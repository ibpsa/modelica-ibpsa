within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.BorefieldData;
record BorefieldDataTrtUTube = Records.BorefieldData (
    pathMod = "IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.BorefieldData.BorefieldDataTrtUTube",
    pathCom = Modelica.Utilities.Files.loadResource("modelica://IBPSA/Fluid/HeatExchangers/GroundHeatExchangers/Data/BorefieldData/BorefieldDataTrtUTube.mo"),
    redeclare replaceable record Soi = SoilData.SoilTrt,
    redeclare replaceable record Fil = FillingData.FillingTrt,
    redeclare replaceable record Gen = GeneralData.GeneralTrtUTube)
    "BorefieldData TRT data, 1 U tube";
