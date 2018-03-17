within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.FillingData;
record Bentonite
  extends Records.Filling(
    pathMod=
        "IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.FillingData.Bentonite",
    pathCom=Modelica.Utilities.Files.loadResource(
        "modelica://IBPSA/Fluid/HeatExchangers/GroundHeatExchangers/Data/FillingData/Bentonite.mo"),
    k=1.15,
    d=1600,
    c=800);

end Bentonite;
