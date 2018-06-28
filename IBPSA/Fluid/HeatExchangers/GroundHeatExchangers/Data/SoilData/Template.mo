within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.SoilData;
record Template
  "Template for SoilData records"
  extends Modelica.Icons.Record;
  parameter Modelica.SIunits.ThermalConductivity kSoi
    "Thermal conductivity of the soil material";
  parameter Modelica.SIunits.SpecificHeatCapacity cSoi
    "Specific heat capacity of the soil material";
  parameter Modelica.SIunits.Density dSoi "Density of the soil material";
  parameter Boolean steadyState = (cSoi == 0 or dSoi == 0)
    "Flag, if true, then material is computed using steady-state heat conduction"
    annotation(Evaluate=true);
  final parameter Modelica.SIunits.ThermalDiffusivity aSoi=kSoi/(dSoi*cSoi)
    "Heat diffusion coefficient of the soil material";
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram( coordinateSystem(preserveAspectRatio=false)),
    Documentation(
info="<html>
<p>This record is a template for the records in
<a href=\"modelica://IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.SoilData\">
IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.SoilData</a>.</p>
</html>",
revisions="<html>
<ul>
<li>
July 28, 2018, by Damien Picard:<br/>
First implementation.
</li>
</ul>
</html>"));
end Template;
