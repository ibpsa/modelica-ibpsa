within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.FillingData;
record Bentonite_validation
  extends Records.Filling(
    pathMod=
        "IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.FillingData.Bentonite",
    pathCom=Modelica.Utilities.Files.loadResource(
        "modelica://IBPSA/Fluid/HeatExchangers/GroundHeatExchangers/Data/FillingData/Bentonite.mo"),
    k=0.73,
    d=2000,
    c=2000);

end Bentonite_validation;
