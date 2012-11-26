within IDEAS.Thermal.Components.Production.VerticalGroundHeatExchanger.AdaptedFluid;
record Medium "Record containing media properties"
  extends Modelica.Icons.Record;
  parameter Modelica.SIunits.Density rho = 1 "Density";
  parameter Modelica.SIunits.SpecificHeatCapacity cp = 1
    "Specific heat capacity at constant pressure";
  parameter Modelica.SIunits.SpecificHeatCapacity cv = 1
    "Specific heat capacity at constant volume";
  parameter Modelica.SIunits.ThermalConductivity lamda = 0.615
    "Thermal conductivity";
  parameter Modelica.SIunits.KinematicViscosity nue= 0.8E-6
    "kinematic viscosity";
  annotation (Documentation(info="<html>
Record containing (constant) medium properties.
</html>"));
end Medium;
