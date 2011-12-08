within IDEAS.Building.Elements;
record Material "\"properties of building materials\""

extends Modelica.Icons.Record;

parameter Modelica.SIunits.Length d;
parameter Modelica.SIunits.ThermalConductivity k;
parameter Modelica.SIunits.SpecificHeatCapacity c;
parameter Modelica.SIunits.Density rho;
parameter Modelica.SIunits.Emissivity epsLw "long wave emisivity";
parameter Modelica.SIunits.Emissivity epsSw "short wave emissivity";
parameter Integer nState(min=1)=1 "number of states for thermal calculation";
parameter Boolean gas = false;
parameter Real mhu = 0;

final parameter Real R(unit="m2.K/W")=d/k;

end Material;
