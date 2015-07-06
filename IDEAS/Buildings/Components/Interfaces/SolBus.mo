within IDEAS.Buildings.Components.Interfaces;
expandable connector SolBus
  "Bus containing solar radiation for various incidence angles"
  extends Modelica.Icons.SignalBus;

  Real iSolDir;
  Real iSolDif;

  Modelica.SIunits.Angle angZen;
  Modelica.SIunits.Angle angAzi;
  Modelica.SIunits.Angle angInc;

  Modelica.SIunits.Temperature Tenv;
end SolBus;
