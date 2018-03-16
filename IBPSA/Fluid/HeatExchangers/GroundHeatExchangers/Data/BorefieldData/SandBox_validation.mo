within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.BorefieldData;
record SandBox_validation=Records.BorefieldData (
    pathMod = "IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.BorefieldData.SandBox_validation",
    pathCom = Modelica.Utilities.Files.loadResource("modelica://IDEAS/Fluid/HeatExchangers/GroundHeatExchangers/Borefield/Data/BorefieldData/SandBox_validation.mo"),
    redeclare replaceable record Soi =
       SoilData.WetSand_validation,
    redeclare replaceable record Fil =
        FillingData.Bentonite_validation,
    redeclare replaceable record Gen =
        GeneralData.SandBox_validation)
  "BorefieldData record for bore field validation using thermal response test";
