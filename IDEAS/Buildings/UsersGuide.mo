within IDEAS.Buildings;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;

  class Implementation "Implementation notes"
    extends Modelica.Icons.Information;

    annotation (Documentation(info="<html>
<p>The relevant material properties of the surfaces are complex functions of the surface temperature, angle and wavelength for each participating surface. The assumptions used frequently in engineering applications <a href=\"IDEAS.Buildings.UsersGuide.References\">[Walton 1983]</a> are that </p>
<p><ol>
<li>each surface emits or reflects diffusely, that </li>
<li>each surface is at a uniform temperature, that </li>
<li>the energy flux leaving a surface is evenly distributed across the surface and</li>
<li>the energy flux leaving a surface is one-dimensional.</li>
</ol></p>
</html>"));
  end Implementation;

  class Contact "Contact"
    extends Modelica.Icons.Contact;

    annotation (Documentation(info="<html>
<p>This package is developed an maintained by the following contributors </p>
<table cellspacing=\"0\" cellpadding=\"2\" border=\"1\"><tr>
<td></td>
<td><p>Name</p></td>
<td><p>Affiliation</p></td>
</tr>
<tr>
<td valign=\"top\"><p>Library officer</p></td>
<td valign=\"top\"><p><a href=\"mailto:ruben.baetens@bwk.kuleuven.be\">R. Baetens</a> </p></td>
<td valign=\"top\"><p><a href=\"http://bwk.kuleuven.be/bwf/\">KU Leuven - University of Leuven</a></p><p>Building Physics Section, Department of Civil Engineering, KU Leuven, Kasteelpark Arenberg 40 bus 2447, BE-3001 Leuven (Heverlee) Belgium </p></td>
</tr>
<tr>
<td valign=\"top\"><p>Contributor</p></td>
<td valign=\"top\"><p><a href=\"mailto:dirk.saelens@bwk.kuleuven.be\">D. Saelens</a> </p></td>
<td valign=\"top\"><p><a href=\"http://bwk.kuleuven.be/bwf/\">KU Leuven - University of Leuven</a></p><p>Building Physics Section, Department of Civil Engineering, KU Leuven, Kasteelpark Arenberg 40 bus 2447, BE-3001 Leuven (Heverlee) Belgium </p></td>
</tr>
</table>
</html>"));
  end Contact;

annotation (__Dymola_DocumentationClass=true, Documentation(info="<html>
<p>In this section, we describe in detail the dynamic building model and its possibilities that are implemented in <code>Modelica</code> as part of the <code>IDEAS</code> platform. The building model allows simulation of the energy demand for heating and cooling of a multi-zone building, energy flows in the building envelope and interconnection with dynamic models of thermal and electrical building energy systems within the <code>IDEAS</code> platform for comfort measures. </p>
<p>The description is divided into the description of the <i>building envelope</i> model and the <i>thermal zone</i> model. The window model and the model for ground losses are described more in detail as extend to the wall model.</p>
</html>"));
end UsersGuide;
