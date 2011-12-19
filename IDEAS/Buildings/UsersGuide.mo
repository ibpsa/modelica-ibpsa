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

  class References "References"
    extends Modelica.Icons.References;

    annotation (Documentation(info="<html>
<table cellspacing=\"0\" cellpadding=\"2\" border=\"0\"><tr>
<td valign=\"top\"><p>[Defraye 2011]</p></td>
<td valign=\"top\"><p>T. Defraeye, B. Blocken, and J. Carmeliet, &QUOT;<a href=\"http://www.sciencedirect.com/science/article/pii/S019689041000333X\">Convective heat transfer coefficient for exterior building surfaces: Existing correlations and CFD modelling</a>,&QUOT; <i>Energy COnversion and Management</i>, vol. 52, no. 1, pp. 512-522, 2011.</p></td>
</tr>
<tr>
<td valign=\"top\"><p>[Jurges 1924]</p></td>
<td valign=\"top\"><p>W. Jurges, &QUOT;Der W&auml;rme&uuml;bergang an einer ebenen Wand,&QUOT; <i>Beiheft zum Gesunheits-Ingenieur</i>, vol. 1, no. 19, 1924.</p></td>
</tr>
<tr>
<td valign=\"top\"><p>[Mohr 2008]</p></td>
<td valign=\"top\"><p>P. J. Mohr, B. N. Taylor, and D. B. Newell, &QUOT;CODATA Tecommended values of the fundamental physical constants: 2006,&QUOT; <i>Review of Modern Physics</i>, vol. 80, pp. 633-730, 2008.</p></td>
</tr>
<tr>
<td valign=\"top\"><p>[Hamilton 1952]</p></td>
<td valign=\"top\"><p>D. C. Hamilton, and W. R. Morgan, &QUOT;<a href=\"http://naca.central.cranfield.ac.uk/reports/1952/naca-tn-2836.pdf\">Radiant-interchange configuration factors</a>,&QUOT; <i>Technical report National Advisory Comittee for Aeronautics</i>, Washington, 1952.</p></td>
</tr>
<tr>
<td valign=\"top\"><p>[Khalifa 2011]</p></td>
<td valign=\"top\"><p>A. J. N. Khalifa, &QUOT;<a href=\"http://www.sciencedirect.com/science/article/pii/S0196890400000431\">Natural convective heat transfer coefficient - a review : Surfaces in two- and three-dimensional enclosures</a>,&QUOT; <i>Energy Conversion and Management</i>, vol. 42, no. 4, pp. 505-517, 2011.</p></td>
</tr>
<tr>
<td valign=\"top\"><p>[Awbi 1999]</p></td>
<td valign=\"top\"><p>H. B. Awbi, and A. Hatton, &QUOT;<a href=\"http://www.sciencedirect.com/science/article/pii/S0378778899000043\">Natural convection from heated room surfaces</a>,&QUOT; <i>Energy and Buildings</i>, vol. 30, no. 3, pp. 233-244, 1999.</p></td>
</tr>
<tr>
<td valign=\"top\"><p>[Buchberg 1955]</p></td>
<td valign=\"top\"><p>H. Buchberg, &QUOT;Electric analogue prediction of thermal behavior of an inhabitable enclosure,&QUOT; <i>ASHRAE Transactions</i>, vol. 61, pp. 339-386, 1955.</p></td>
</tr>
<tr>
<td valign=\"top\"><p>[Oppenheim 1956]</p></td>
<td valign=\"top\"><p>A. K. Oppenheim, &QUOT;<a href=\"http://www.me.berkeley.edu/faculty/oppenheim/oppenheim1.pdf\">Radiation analysis by the network method</a>,&QUOT; <i>Transaction of American Society of Mechanical Engineers</i>, vol. 78, pp. 725-735, 1956.</p></td>
</tr>
<tr>
<td valign=\"top\"><p>[Kenelly 1899]</p></td>
<td valign=\"top\"><p>A. E. Kenelly, &QUOT;Equivalence of triangles and stars in conducting networks,&QUOT; <i>Electrical World and Engineer</i>, vol. 34, pp. 413-414, 1899.</p></td>
</tr>
<tr>
<td valign=\"top\"><p>[Liesen 1997]</p></td>
<td valign=\"top\"><p>R. J. LIesen, and C. O. Pedersen, &QUOT;<a href=\"http://www.hvac.okstate.edu/research/Documents/ASHRAE/CH-03-9-4.pdf\">An evaluation of inside surface heat balance models for cooling load calculations</a>,&QUOT; <i>ASHRAE Transactions</i>, vol. 103, no. 2, pp. 485-502, 1997.</p></td>
</tr>
<tr>
<td valign=\"top\"><p>[Waldon 1953]</p></td>
<td valign=\"top\"><p>G. N. Waldon, Thermal analysis research program refeence manual, Washington: U.S. Department of Commerce, National Bureau of Standards, 1993</p></td>
</tr>
<tr>
<td valign=\"top\"><p>[ISO 13370]</p></td>
<td valign=\"top\"><p>ISO/CD 133770, <a href=\"http://wiki.pato.metid.polimi.it/@api/deki/files/637/=ISO_13370-2007.pdf\">Thermal performance of buildings - Heat transfer via the ground - Calculation methods</a>.</p></td>
</tr>
<tr>
<td valign=\"top\"><p>[WINDOW 6.3]</p></td>
<td valign=\"top\"><p><a href=\"http://windows.lbl.gov/software/window/6/index.html\">WINDOW 6.3</a>, Lawrence Berkeley Laboratory, 1993</p></td>
</tr>
<tr>
<td valign=\"top\"></td>
<td valign=\"top\"><p><br/><br/><br/>....</p></td>
</tr>
</table>
</html>"));
  end References;

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

  class RevisionHistory "Revision History"
    extends Modelica.Icons.ReleaseNotes;

    annotation (Documentation(info="<html>
<p><h4>Version 1.0, 2011-12-11</h4></p>
<p>This is the first version integrated in the IDEAS tool and made available for the public. </p>
<p><h4>Previous Releases</h4></p>
<p><ul>
<li>Nov., 2011<br/>by Ruben Baetens: Buildings package set available as <code>BWF.mo</code> at the <code>KU Leuven Blackboard</code> for MSc and PhD students.</li>
<li>Nov., 2010<br/>by Ruben Baetens: First implementation.</li>
</ul></p>
</html>"));
  end RevisionHistory;

annotation (__Dymola_DocumentationClass=true, Documentation(info="<html>
<p>In this section, we describe in detail the dynamic building model and its possibilities that are implemented in <code>Modelica</code> as part of the <code>IDEAS</code> platform. The building model allows simulation of the energy demand for heating and cooling of a multi-zone building, energy flows in the building envelope and interconnection with dynamic models of thermal and electrical building energy systems within the <code>IDEAS</code> platform for comfort measures. </p>
<p>The description is divided into the description of the <i>building envelope</i> model and the <i>thermal zone</i> model. The window model and the model for ground losses are described more in detail as extend to the wall model.</p>
</html>"));
end UsersGuide;
