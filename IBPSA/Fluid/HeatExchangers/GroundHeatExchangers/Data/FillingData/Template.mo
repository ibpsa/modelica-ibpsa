within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.FillingData;
record Template
  "Template for FillingData records"
  extends Modelica.Icons.Record;
  parameter Modelica.SIunits.ThermalConductivity kFil
    "Thermal conductivity of the borehole filling material";
  parameter Modelica.SIunits.SpecificHeatCapacity cFil
    "Specific heat capacity of the borehole filling material";
  parameter Modelica.SIunits.Density dFil
    "Density of the borehole filling material";
  parameter Boolean steadyState = (cFil == 0 or dFil == 0)
    "Flag, if true, then material is computed using steady-state heat conduction"
    annotation(Evaluate=true);
  final parameter Modelica.SIunits.ThermalDiffusivity aFil = kFil/(dFil*cFil)
    "Heat diffusion coefficient of the borehole filling material";
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram( coordinateSystem(preserveAspectRatio=false)),
    Documentation(
info="<html>
<p>This record is a template for the records in
<a href=\"modelica://IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.FillingData\">
IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.FillingData</a>.</p>
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
