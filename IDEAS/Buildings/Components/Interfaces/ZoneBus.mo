within IDEAS.Buildings.Components.Interfaces;
expandable connector ZoneBus
  extends Modelica.Icons.SignalBus;

  parameter Integer numAzi
    "Number of calculated azimuth angles, set to sim.numAzi";

  Modelica.SIunits.Power QTra_design;
  Modelica.SIunits.Area area;
  Modelica.SIunits.Emissivity epsLw;
  Modelica.SIunits.Emissivity epsSw;
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a surfCon;
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b surfRad;
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a iSolDir;
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b iSolDif;
  IDEAS.Buildings.Components.Interfaces.WeaBus weaBus(numSolBus=numAzi+1)
    annotation(HideResult=true);
end ZoneBus;
