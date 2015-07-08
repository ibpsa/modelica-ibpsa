within IDEAS.Buildings.Components.Interfaces;
expandable connector ZoneBus
  extends Modelica.Icons.SignalBus;

  parameter Integer numAzi
    "Number of calculated azimuth angles, set to sim.numAzi";

  Modelica.SIunits.Power QTra_design annotation ();
  Modelica.SIunits.Area area annotation ();
  Modelica.SIunits.Emissivity epsLw annotation ();
  Modelica.SIunits.Emissivity epsSw annotation ();
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a surfCon annotation ();
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b surfRad annotation ();
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a iSolDir annotation ();
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b iSolDif annotation ();
  BoundaryConditions.WeatherData.Bus weaBus(numSolBus=numAzi+1)
    annotation(HideResult=true);
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b Qgai
    "Heat gains in model" annotation ();
end ZoneBus;
