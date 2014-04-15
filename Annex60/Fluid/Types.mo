within Annex60.Fluid;
package Types "Package with type definitions"

  type CvTypes = enumeration(
      OpPoint "flow coefficient defined by m_flow_nominal/sqrt(dp_nominal)",
      Kv "Kv (metric) flow coefficient",
      Cv "Cv (US) flow coefficient",
      Av "Av (metric) flow coefficient")
    "Enumeration to define the choice of valve flow coefficient" annotation (
      Documentation(info="<html>
 
<p>
Enumeration to define the choice of valve flow coefficient
(to be selected via choices menu):
</p>
 
<table summary=\"summary\"  border=\"1\">
<tr><th>Enumeration</th>
    <th>Description</th></tr>
 
<tr><td>OpPoint</td>
    <td>flow coefficient defined by ratio m_flow_nominal/sqrt(dp_nominal)</td></tr>
 
<tr><td>Kv</td>
    <td>Kv (metric) flow coefficient</td></tr>
 
<tr><td>Cv</td>
    <td>Cv (US) flow coefficient</td></tr>
 
<tr><td>Av</td>
    <td>Av (metric) flow coefficient</td></tr>

</table>

<p>
The details of the coefficients are explained in the 
<a href=\"modelica://Modelica.Fluid.UsersGuide.ComponentDefinition.ValveCharacteristics\">
Users Guide</a>.
</p>
 
</html>"));

annotation (preferredView="info", Documentation(info="<html>
This package contains type definitions.
</html>"));
end Types;
