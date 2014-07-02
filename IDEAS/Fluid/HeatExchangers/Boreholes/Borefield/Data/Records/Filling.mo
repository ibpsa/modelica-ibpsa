within IDEAS.Thermal.Components.GroundHeatExchanger.Borefield.Data.Records;
record Filling "Thermal properties of the filling material of the boreholes"
  import Buildings;

  extends Buildings.HeatTransfer.Data.BoreholeFillings.Generic;

  parameter String name="Filling";
  final parameter Modelica.SIunits.DiffusionCoefficient alp=k/d/c;

end Filling;
