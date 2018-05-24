within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.BorefieldData;
record Template
  extends Modelica.Icons.Record;
  parameter IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.FillingData.Template filDat "Filling data";
  parameter IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.SoilData.Template soiDat "Soil data";
  parameter IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.ConfigurationData.Template conDat "Configuration data";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Template;
