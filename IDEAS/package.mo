within ;
package IDEAS "Integrated District Energy Assessment Simulation"


extends Modelica.Icons.Library;

import SI = Modelica.SIunits;


annotation (
  uses(Modelica(version="3.2.2")),
  Icon(graphics),
  version="1.0.0",
  versionDate="2017-01-12",
  dateModified = "2017-01-12",
  conversion(
 from(version={"0.2"},
      script="modelica://IDEAS/Resources/Scripts/convertIdeas030to100.mos")),
  Documentation(info="<html>
<p>Licensed by KU Leuven and 3E under the Modelica License 2 </p>
<p>Copyright &copy; 2013-2023, KU Leuven and 3E. </p>
<p>&nbsp; </p>
<p><i>This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>;</i>  <i>it can be redistributed and/or modified under the terms of the Modelica License 2. </i></p>
<p><i>For license conditions (including the disclaimer of warranty) see <a href=\"UrlBlockedError.aspx\">Modelica.UsersGuide.ModelicaLicense2</a> or visit <a href=\"https://www.modelica.org/licenses/ModelicaLicense2\">https://www.modelica.org/licenses/ModelicaLicense2</a>.</i> </p>
</html>"));
end IDEAS;
