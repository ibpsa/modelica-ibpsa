within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data;
package BorefieldData
  record SandBox_validation
    extends Template(
      filDat=FillingData.SandBox_validation(),
      soiDat=SoilData.SandBox_validation(),
      conDat=ConfigurationData.SandBox_validation());

    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end SandBox_validation;
end BorefieldData;
