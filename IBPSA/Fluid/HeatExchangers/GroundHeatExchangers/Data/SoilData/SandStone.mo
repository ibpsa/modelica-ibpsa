within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.SoilData;
record SandStone
  extends Records.Soil(
    pathMod=
        "IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.SoilData.SandStone",
    pathCom=Modelica.Utilities.Files.loadResource(
        "modelica://IBPSA/Fluid/HeatExchangers/GroundHeatExchangers/Data/SoilData/SandStone.mo"),
    k=2.8,
    d=540,
    c=1210);

end SandStone;
