within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.FillingData;
record Template "Thermal properties of the borehole filling material"
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
  annotation (Documentation(info="<html>
 <p>Thermal properties of the borehole filling material and record path.</p>
</html>", revisions="<html>
<ul>
<li>
July 2014, by Damien Picard:<br>
First implementation.
</li>
</ul>
</html>"));
end Template;
