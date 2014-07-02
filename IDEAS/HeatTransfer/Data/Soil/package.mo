within IDEAS.HeatTransfer.Data;
package Soil "Package with solid material for soil, characterized by thermal conductance, density and specific heat capacity"
    extends Modelica.Icons.MaterialPropertiesPackage;



  annotation (preferredView="info",
Documentation(
info="<html>
<p>
Package with records for solid materials.
The material is characterized by its 
thermal conductivity, mass density and specific
heat capacity.
</p>
<p>
These properties are used to compute heat conduction in circular coordinates.
Hence, as opposed to 
<a href=\"modelica://Buildings.HeatTransfer.Data.Solids\">
Buildings.HeatTransfer.Data.Solids</a>,
they do not include the material thickness and the generation of the
spatial grid.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 9, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Soil;
