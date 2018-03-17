within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.BorefieldData;
record SolarWind "Solarwind borefield data"
  extends
    IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.Records.BorefieldData(
    pathMod=
        "IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.BorefieldData.SolarWind",
    pathCom=Modelica.Utilities.Files.loadResource(
        "modelica://IBPSA/Fluid/HeatExchangers/GroundHeatExchangers/Data/BorefieldData/SolarWind.mo"),
    redeclare replaceable record Soi = SoilData.SoilTrt,
    redeclare replaceable record Fil = FillingData.FillingTrt,
    redeclare replaceable record Gen = GeneralData.GeneralSW);

end SolarWind;
