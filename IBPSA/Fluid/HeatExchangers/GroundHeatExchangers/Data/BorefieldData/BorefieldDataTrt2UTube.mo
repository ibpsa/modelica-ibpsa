within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.BorefieldData;
record BorefieldDataTrt2UTube = Records.BorefieldData (
    pathMod = "IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.BorefieldData.BorefieldDataTrt2UTube",
    pathCom = Modelica.Utilities.Files.loadResource("modelica://IBPSA/Fluid/HeatExchangers/GroundHeatExchangers/Data/BorefieldData/BorefieldDataTrt2UTube.mo"),
    redeclare replaceable record Soi = SoilData.SoilTrt,
    redeclare replaceable record Fil = FillingData.FillingTrt,
    redeclare replaceable record Gen = GeneralData.GeneralTrt2UTube)
  "BorefieldData TRT data, 2 U tubes";
