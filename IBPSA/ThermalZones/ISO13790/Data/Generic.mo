within IBPSA.ThermalZones.ISO13790.Data;
record Generic "Generic data record building mass"
   extends Modelica.Icons.Record;

   parameter Real heaC
    "heat capacity"
    annotation (Dialog(group="Heat mass"));

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
Building mass data.
</p>
</html>"));
end Generic;
