within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.SoilData;
record Template "Thermal properties of the borehole soil material"
  extends Modelica.Icons.Record;
  parameter Modelica.SIunits.ThermalConductivity k "Thermal conductivity";
  parameter Modelica.SIunits.SpecificHeatCapacity c "Specific heat capacity";
  parameter Modelica.SIunits.Density d "Mass density";
  parameter Boolean steadyState= (c == 0 or d == 0)
    "Flag, if true, then material is computed using steady-state heat conduction"
    annotation(Evaluate=true);
  final parameter Modelica.SIunits.DiffusionCoefficient alp=k/d/c
    "Heat diffusion coefficient of the filling material";
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
