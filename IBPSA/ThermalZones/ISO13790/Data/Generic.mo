within IBPSA.ThermalZones.ISO13790.Data;
record Generic "Generic data record for thermal mass of building"
   extends Modelica.Icons.Record;

   parameter Real heaC(final unit="J/(K.m2)") "Thermal mass per floor area"
    annotation (Dialog(group="Thermal mass"));

  annotation (defaultComponentName="mas",
Documentation(revisions="<html>
<ul>
<li>
Mar 16, 2022, by Alessandro Maccarini:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Building thermal mass per unit area of the floor.
</p>
</html>"));
end Generic;
