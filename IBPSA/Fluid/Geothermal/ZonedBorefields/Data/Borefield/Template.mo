within IBPSA.Fluid.Geothermal.ZonedBorefields.Data.Borefield;
record Template
  "Template for borefield data records"
  extends Modelica.Icons.Record;

  parameter
    IBPSA.Fluid.Geothermal.ZonedBorefields.Data.Filling.Template filDat
    "Filling data";
  parameter IBPSA.Fluid.Geothermal.ZonedBorefields.Data.Soil.Template soiDat
    "Soil data";
  parameter
    IBPSA.Fluid.Geothermal.ZonedBorefields.Data.Configuration.Template conDat
    "Configuration data";

  annotation(
    defaultComponentPrefixes = "parameter",
    defaultComponentName = "borFieDat",
    Documentation(
      info = "<html>
<p>
This record is a template for the records in
<a href=\"modelica://IBPSA.Fluid.Geothermal.ZonedBorefields\">
IBPSA.Fluid.Geothermal.ZonedBorefields</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 2024, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end Template;
