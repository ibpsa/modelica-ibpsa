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

  annotation (Documentation(info="<html>
<p>
Connector that contains all solar irridiation information for one inclination and tilt angle.
</p>
</html>", revisions="<html>
<ul>
<li>
October 22, 2016, by Filip Jorissen:<br/>
Revised documentation for IDEAS 1.0.
</li>
</ul>
</html>"));
end SolBus;
