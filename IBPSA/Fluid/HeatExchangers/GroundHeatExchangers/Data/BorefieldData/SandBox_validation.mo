within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.BorefieldData;
record SandBox_validation=Records.BorefieldData (
    pathMod = "IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.BorefieldData.SandBox_validation",
    pathCom = Modelica.Utilities.Files.loadResource("modelica://IBPSA/Fluid/HeatExchangers/GroundHeatExchangers/Data/BorefieldData/SandBox_validation.mo"),
    redeclare replaceable record Soi =
       SoilData.WetSand_validation,
    redeclare replaceable record Fil =
        FillingData.Bentonite_validation,
    redeclare replaceable record Gen =
        GeneralData.SandBox_validation)
  "BorefieldData record for bore field validation using thermal response test";
