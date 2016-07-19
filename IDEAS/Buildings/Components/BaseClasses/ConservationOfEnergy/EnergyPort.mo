within IDEAS.Buildings.Components.BaseClasses.ConservationOfEnergy;
connector EnergyPort "Port for adding up energy"
  flow Modelica.SIunits.Energy E "Energy port";
  Modelica.SIunits.Energy Etot "Energy port";
  annotation (Documentation(info="<html>

</html>", revisions="<html>
<ul>
<li>
June 14, 2015, Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
end EnergyPort;
