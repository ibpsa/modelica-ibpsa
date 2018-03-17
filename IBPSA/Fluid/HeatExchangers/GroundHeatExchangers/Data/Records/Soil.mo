within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.Records;
record Soil "Thermal properties of the ground"
  extends IBPSA.HeatTransfer.Data.Soil.Generic;
  parameter String pathMod=
      "IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.Records.Soil"
    "Modelica path of the record";
  parameter String pathCom=Modelica.Utilities.Files.loadResource(
      "modelica://IBPSA/Fluid/HeatExchangers/GroundHeatExchangers/Data/Records/Soil.mo")
    "Computer path of the record";
  final parameter Modelica.SIunits.DiffusionCoefficient alp=k/d/c;
  annotation (Documentation(info="<html>
  <p>Thermal properties of the ground and record path.</p>
</html>", revisions="<html>
<ul>
<li>
July 2014, by Damien Picard:<br>
First implementation.
</li>
</ul>
</html>"));
end Soil;
