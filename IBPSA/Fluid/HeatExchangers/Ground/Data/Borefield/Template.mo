within IBPSA.Fluid.HeatExchangers.Ground.Data.Borefield;
record Template
  "Template for borefield data records"
  extends Modelica.Icons.Record;
  parameter IBPSA.Fluid.HeatExchangers.Ground.Data.Filling.Template filDat
    "Filling data";
  parameter IBPSA.Fluid.HeatExchangers.Ground.Data.Soil.Template soiDat
    "Soil data";
  parameter IBPSA.Fluid.HeatExchangers.Ground.Data.Configuration.Template conDat
    "Configuration data";

  annotation (
  defaultComponentPrefixes="parameter",
  defaultComponentName="borFieDat",
Documentation(
info="<html>
<p>
This record is a template for the records in
<a href=\"modelica://IBPSA.Fluid.HeatExchangers.Ground.Data.Borefield\">
IBPSA.Fluid.HeatExchangers.Ground.Data.Borefield</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 15, 2018, by Michael Wetter:<br/>
Revised implementation, added <code>defaultComponentPrefixes</code> and
<code>defaultComponentName</code>.
</li>
<li>
June 28, 2018, by Damien Picard:<br/>
First implementation.
</li>
</ul>
</html>"));
end Template;
