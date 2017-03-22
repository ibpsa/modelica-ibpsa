within IDEAS.Buildings.Components.Interfaces;
connector SolBus
  "Bus containing solar radiation for various incidence angles"
  extends Modelica.Icons.SignalBus;
  parameter Boolean outputAngles = true "Set to false when linearising in Dymola only";
  IDEAS.Buildings.Components.Interfaces.RealConnector iSolDir(start=100) annotation ();
  IDEAS.Buildings.Components.Interfaces.RealConnector iSolDif(start=100) annotation ();
  IDEAS.Buildings.Components.Interfaces.RealConnector angInc(
    final quantity="Angle",
    final unit="rad",
    displayUnit="deg") if outputAngles;
  IDEAS.Buildings.Components.Interfaces.RealConnector angZen(
    final quantity="Angle",
    final unit="rad",
    displayUnit="deg") if outputAngles;
  IDEAS.Buildings.Components.Interfaces.RealConnector angAzi(
    final quantity="Angle",
    final unit="rad",
    displayUnit="deg") if outputAngles;
  IDEAS.Buildings.Components.Interfaces.RealConnector Tenv(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    min = 0.0,
    start = 293.15,
    nominal = 300,
    displayUnit="degC") "Equivalent radiant temperature" annotation ();


  annotation (Documentation(info="<html>
<p>
Connector that contains all solar irridiation information for one inclination and tilt angle.
</p>
</html>", revisions="<html>
<ul>
<li>
March 21, 2017, by Filip Jorissen:<br/>
Changed Reals into connectors for JModelica compatibility.
Other compatibility changes. 
See issue <a href=https://github.com/open-ideas/IDEAS/issues/559>#559</a>.
</li>
<li>
October 22, 2016, by Filip Jorissen:<br/>
Revised documentation for IDEAS 1.0.
</li>
</ul>
</html>"));
end SolBus;
