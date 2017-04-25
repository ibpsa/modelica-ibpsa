within IDEAS.Buildings.Components.Interfaces;
connector ZoneBus
  extends Modelica.Icons.SignalBus;
  parameter Integer numIncAndAziInBus
    "Number of calculated azimuth angles, set to sim.numIncAndAziInBus";
  parameter Boolean outputAngles = true "Set to false when linearising in Dymola only";

  IDEAS.Buildings.Components.Interfaces.RealConnector QTra_design(
    final quantity="Power",
    final unit="W") annotation ();
  IDEAS.Buildings.Components.Interfaces.RealConnector area(
    final quantity="Area",
    final unit="m2") annotation ();
  IDEAS.Buildings.Components.Interfaces.RealConnector epsLw(
    final quantity="Emissivity",
    final unit="1") annotation ();
  IDEAS.Buildings.Components.Interfaces.RealConnector epsSw(
    final quantity="Emissivity",
    final unit="1") annotation ();
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a surfCon annotation ();
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b surfRad annotation ();
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a iSolDir annotation ();
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b iSolDif annotation ();
  IDEAS.Buildings.Components.Interfaces.WeaBus weaBus(numSolBus=numIncAndAziInBus, outputAngles=outputAngles)
    annotation(HideResult=true);
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b Qgai
    "Heat gains in model" annotation ();
  IDEAS.Buildings.Components.BaseClasses.ConservationOfEnergy.EnergyPort E
    "Internal energy in model" annotation ();
  IDEAS.Buildings.Components.Interfaces.RealConnector inc(
    final quantity="Angle",
    final unit="rad",
    displayUnit="deg") annotation ();
  IDEAS.Buildings.Components.Interfaces.RealConnector azi(
    final quantity="Angle",
    final unit="rad",
    displayUnit="deg") annotation ();

  annotation (Documentation(info="<html>
<p>
Connector that contains a weather bus and further
contains variables and connectors for exchanging 
heat and information between a zone and a surface.
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
end ZoneBus;
