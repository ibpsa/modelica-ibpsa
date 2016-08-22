within IDEAS.Buildings.Components.Interfaces;
expandable connector SolBus
  "Bus containing solar radiation for various incidence angles"
  extends Modelica.Icons.SignalBus;
  parameter Boolean outputAngles = true "Set to false when linearising only";

  Real iSolDir(start=100) annotation ();
  Real iSolDif(start=100) annotation ();
  Real angInc if outputAngles;
  Real angZen if outputAngles annotation ();
  Real angAzi if outputAngles;
  Modelica.SIunits.Temperature Tenv(start=293.15) annotation ();

end SolBus;
