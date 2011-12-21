within IDEAS.Thermal.Data.Interfaces;
partial record Medium "Record containing media properties"

  extends Modelica.Icons.MaterialProperty;

  parameter Modelica.SIunits.Density rho = 1 "Density";
  parameter Modelica.SIunits.SpecificHeatCapacity cp = 1
    "Specific heat capacity at constant pressure";
  parameter Modelica.SIunits.SpecificHeatCapacity cv = 1
    "Specific heat capacity at constant volume";
  parameter Modelica.SIunits.ThermalConductivity lamda = 1
    "Thermal conductivity";
  parameter Modelica.SIunits.KinematicViscosity nue = 1 "Kinematic viscosity";
  annotation (Documentation(info="<html>
Record containing (constant) medium properties.
</html>"));
end Medium;
