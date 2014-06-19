within IDEAS.Buildings.Components.Interfaces;
expandable connector ZoneBus
  extends Modelica.Icons.SignalBus;

  Modelica.SIunits.Area area;
  Modelica.SIunits.Emissivity epsLw;
  Modelica.SIunits.Emissivity epsSw;
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a surfCon;
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b surfRad;
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a iSolDir;
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b iSolDif;
end ZoneBus;
