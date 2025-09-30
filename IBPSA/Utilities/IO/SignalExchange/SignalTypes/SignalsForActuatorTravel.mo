within IBPSA.Utilities.IO.SignalExchange.SignalTypes;
type SignalsForActuatorTravel = enumeration(
    None
      "Not used for control actuators",
    Damper
      "Damper",
    Valve
      "Valve",
    Fan
      "Fan",
    Pump
      "Pump",
    HVACEquipment
      "HVAC Equipment",
    Other
      "Other")
  "Signals used for the calculation of key performance indexes"
  annotation (Documentation(info="<html>
<p>This enumeration defines the actuator signal types that are used by BOPTEST to compute the actuator travel. </p>
<p>The following signal types are supported. </p>
<table cellspacing=\"0\" cellpadding=\"2\" border=\"1\"><tr>
<td><p align=\"center\"><h4>Value</h4></p></td>
<td><p align=\"center\"><h4>Description</h4></p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Courier New;\">None</span></p></td>
<td><p>Not used for actuator travel</p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Courier New;\">Damper</span></p></td>
<td><p>Damper signal (e.g., damper openess signal)</p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Courier New;\">Valve</span></p></td>
<td><p>Valve signal (e.g., valve openess signal)</p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Courier New;\">Fan</span></p></td>
<td><p>Fan signal (e.g., fan speed signal)</p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Courier New;\">Pump</span></p></td>
<td><p>Pump signal (e.g., pump speed signal)</p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Courier New;\">HVACEquipment</span></p></td>
<td><p>HVAC equipment signal (e.g., heat pump signal)</p></td>
</tr>
<tr>
<td><p><span style=\"font-family: Courier New;\">Other</span></p></td>
<td><p>Other actuator signal</p></td>
</tr>
</table>
</html>", revisions="<html>
<ul>
<li>
September 30, 2025, by Xing Lu:<br/>
First implementation.
</li>
</ul>
</html>"));
