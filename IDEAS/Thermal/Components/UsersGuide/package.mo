within IDEAS.Thermal.Components;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;


annotation (__Dymola_DocumentationClass=true, Documentation(info="<html>
<p><h4><font color=\"#008000\">General description</font></h4></p>
<p>The package IDEAS.Thermal.Components contains thethermal building blocks of a heating cooling or ventilation (HVAC) system.</p>
<p>The models are divided in subclasses according to their main function in the HVAC system:</p>
<p><ul>
<li>heat or cold <b>production</b></li>
<li><b>emission</b> systems</li>
<li>thermal energy <b>storage</b></li>
<li><b>distribution</b> components</li>
<li>domestic hot water (<b>DHW</b>) systems </li>
<li><h4>ventilation</h4></li>
<li><b>ground heat exchanger </b>models (single + multiple boreholes)</li>
</ul></p>
<p><br/>Basic components like pipes, pumps, expansion vessel etc are grouped in the <b>BaseClasses</b> package, and even more basic stuff is grouped in <b>Interfaces.</b> </p>
<p>All examples and model verification tests are put together in <b>Examples</b> instead of putting them in each subpackage separately.</p>
</html>"));
end UsersGuide;
