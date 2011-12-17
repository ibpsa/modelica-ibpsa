within IDEAS.Buildings.Data.Interfaces;
record Material "Properties of building materials"

extends Modelica.Icons.MaterialProperty;

parameter Modelica.SIunits.Length d "Layer thickness";
parameter Modelica.SIunits.ThermalConductivity k "Thermal conductivity";
parameter Modelica.SIunits.SpecificHeatCapacity c "Specific thermal capacity";
parameter Modelica.SIunits.Density rho "Density";
parameter Modelica.SIunits.Emissivity epsLw "Longwave emisivity";
parameter Modelica.SIunits.Emissivity epsSw "Shortwave emissivity";
parameter Integer nState(min=1)=1 "Number of states for thermal calculation";
parameter Boolean gas = false "Boolean wether the material is a gas";
parameter Real mhu(unit="m2/s") = 0
    "Viscosity, i.e. if the material is a fluid";

final parameter Real R(unit="m2K/W") = d/k;

end Material;
