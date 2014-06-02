within IDEAS.Thermal.Components.GroundHeatExchanger.Borefield.Data.Records;
record Soil "Thermal properties of the ground"
  import Buildings;

  extends Buildings.HeatTransfer.Data.Soil.Generic;
  parameter String name="Soil";
  final parameter Modelica.SIunits.DiffusionCoefficient alp=k/d/c;
end Soil;
