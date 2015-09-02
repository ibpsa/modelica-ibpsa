within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.SoilData;
record WetSand_validation
  "Soil properties for bore field validation using thermal response test of the Sand box Experiment"
  extends Records.Soil(
    pathMod="IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.SoilData.SoilTrt",
    pathCom=Modelica.Utilities.Files.loadResource("modelica://IDEAS/Fluid/HeatExchangers/GroundHeatExchangers/Borefield/Data/SoilData/SoilTrt.mo"),
    k=2.8,
    c=1600,
    d=2000);
end WetSand_validation;
