within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data;
package BorefieldData
  record SandBox_validation
    extends Template(
      filDat=IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.FillingData.SandBox_validation(),
      soiDat=IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.SoilData.SandBox_validation(),
      conDat=IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.ConfigurationData.SandBox_validation());

    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end SandBox_validation;
end BorefieldData;
