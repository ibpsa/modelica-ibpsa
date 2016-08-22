within IDEAS.Buildings.Components.Interfaces;
expandable connector ZoneBus
  extends Modelica.Icons.SignalBus;

  parameter Integer numIncAndAziInBus
    "Number of calculated azimuth angles, set to sim.numIncAndAziInBus";
  parameter Boolean computeConservationOfEnergy
    "Add variables for checking conservation of energy";

  Modelica.SIunits.Power QTra_design annotation ();
  Modelica.SIunits.Area area annotation ();
  Modelica.SIunits.Emissivity epsLw annotation ();
  Modelica.SIunits.Emissivity epsSw annotation ();
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a surfCon annotation ();
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b surfRad annotation ();
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a iSolDir annotation ();
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b iSolDif annotation ();
  IDEAS.Buildings.Components.Interfaces.WeaBus weaBus(numSolBus=numIncAndAziInBus)
    annotation(HideResult=true);
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b Qgai if computeConservationOfEnergy
    "Heat gains in model" annotation ();
  IDEAS.Buildings.Components.BaseClasses.ConservationOfEnergy.EnergyPort E if
                                                          computeConservationOfEnergy
    "Internal energy in model" annotation ();
  Modelica.SIunits.Angle inc annotation ();
  Modelica.SIunits.Angle azi annotation ();

end ZoneBus;
