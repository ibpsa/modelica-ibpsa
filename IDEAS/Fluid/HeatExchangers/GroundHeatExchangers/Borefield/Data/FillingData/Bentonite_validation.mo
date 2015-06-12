within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.FillingData;
record Bentonite_validation
  extends Records.Filling(
    pathMod=
        "IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.FillingData.Bentonite",
    pathCom=Modelica.Utilities.Files.loadResource(
        "modelica://IDEAS/Fluid/HeatExchangers/GroundHeatExchangers/Borefield/Data/FillingData/Bentonite.mo"),
    k=0.73,
    d=2000,
    c=2000);

end Bentonite_validation;
