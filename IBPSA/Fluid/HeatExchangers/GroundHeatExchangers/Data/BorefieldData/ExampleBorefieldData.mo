within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.BorefieldData;
record ExampleBorefieldData
  extends Template(
    filDat=FillingData.Bentonite(),
    soiDat=SoilData.SandStone(),
    conDat=ConfigurationData.Test());

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ExampleBorefieldData;
