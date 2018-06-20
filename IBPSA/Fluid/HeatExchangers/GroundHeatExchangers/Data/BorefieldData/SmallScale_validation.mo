within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.BorefieldData;
record SmallScale_validation
  extends Template(
    filDat=IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.FillingData.SmallScale_validation(),
    soiDat=IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.SoilData.SmallScale_validation(),
    conDat=IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.ConfigurationData.SmallScale_validation());

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SmallScale_validation;
