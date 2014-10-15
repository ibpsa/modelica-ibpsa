within ;
package IDEAS "Integrated District Energy Assessment Simulation"


extends Modelica.Icons.Library;

import SI = Modelica.SIunits;


annotation (
  uses(Modelica(version="3.2.1"), IDEAS(version="0.1")),
  Icon(graphics),
  version="0.1",
  conversion(noneFromVersion="", noneFromVersion="1"),
  Documentation(info="<html>
<p>Important changes since before Annex60 conversion:</p>
<p>- material sturctures such as in IDEAS.Buildings.Data.Constructions have a reversed order for IDEAS.Buildings.Components.InternalWall models</p>
<p>- TOpStart in zone model has been removed and is changed into T_start.</p>
<p><br>Licensed by KU Leuven and 3E under the Modelica License 2 </p>
<p>Copyright &copy; 2013-2023, KU Leuven and 3E. </p>
<p>&nbsp; </p>
<p><i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>;</i> <i>it can be redistributed and/or modified under the terms of the Modelica License 2. </i></p>
<p><i>For license conditions (including the disclaimer of warranty) see <a href=\"UrlBlockedError.aspx\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"https://www.modelica.org/licenses/ModelicaLicense2\">https://www.modelica.org/licenses/ModelicaLicense2</a>.</i> </p>
</html>"));
end IDEAS;
