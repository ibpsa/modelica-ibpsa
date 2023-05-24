within IBPSA.Fluid.Geothermal.Aquifer.Data;
record Template
  "Template for soil data records"
  extends Modelica.Icons.Record;
  parameter Modelica.Units.SI.ThermalConductivity kSoi
    "Thermal conductivity of the soil material";
  parameter Modelica.Units.SI.SpecificHeatCapacity cSoi
    "Specific heat capacity of the soil material";
  parameter Modelica.Units.SI.Density dSoi(displayUnit="kg/m3")
    "Density of the soil material";
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Template;
