within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.BorefieldData;
record ExampleBorefieldData
  extends Template(
    filDat=IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.FillingData.Bentonite(),
    soiDat=IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.SoilData.SandStone(),
    conDat=IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.ConfigurationData.ExampleConfigurationData());

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ExampleBorefieldData;
