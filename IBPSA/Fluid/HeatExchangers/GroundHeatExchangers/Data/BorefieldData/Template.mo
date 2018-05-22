within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.BorefieldData;
record Template
  extends Modelica.Icons.Record;
  parameter FillingData.Template filDat "Filling data";
  parameter SoilData.Template soiDat "Soil data";
  parameter ConfigurationData.Template conDat "Configuration data";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Template;
