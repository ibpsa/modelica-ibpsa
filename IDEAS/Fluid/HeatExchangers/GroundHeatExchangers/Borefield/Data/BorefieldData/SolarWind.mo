within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.BorefieldData;
record SolarWind "Solarwind borefield data"
  extends
    IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.Records.BorefieldData(
    pathMod = "IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.BorefieldData.SolarWind",
    pathCom = Modelica.Utilities.Files.loadResource("modelica://IDEAS/Fluid/HeatExchangers/GroundHeatExchangers/Borefield/Data/BorefieldData/SolarWind.mo"),
    redeclare replaceable record Soi = SoilData.SoilTrt,
    redeclare replaceable record Fil = FillingData.FillingTrt,
    redeclare replaceable record Gen = GeneralData.GeneralSW);
end SolarWind;
