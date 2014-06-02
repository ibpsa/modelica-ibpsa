within IDEAS.Fluid.HeatExchangers.GroundHeatExchanger.Borefield.Data.Records;
record Soil "Thermal properties of the ground"
  extends IDEAS.HeatTransfer.Data.Soil.Generic;
  parameter String name="Soil";
  final parameter Modelica.SIunits.DiffusionCoefficient alp=k/d/c;
end Soil;
