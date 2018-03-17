within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.SoilData;
record SoilTrt
  "Soil properties for bore field validation using thermal response test"
  extends Records.Soil(
    pathMod="IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.SoilData.SoilTrt",
    pathCom=Modelica.Utilities.Files.loadResource("modelica://IBPSA/Fluid/HeatExchangers/GroundHeatExchangers/Data/SoilData/SoilTrt.mo"),
    k=2.19,
    c=1210,
    d=1785);
end SoilTrt;
