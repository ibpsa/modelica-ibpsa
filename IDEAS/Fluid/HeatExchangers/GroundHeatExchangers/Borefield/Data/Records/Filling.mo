within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.Records;
record Filling "Thermal properties of the filling material of the boreholes"
  extends IDEAS.HeatTransfer.Data.BoreholeFillings.Generic;

  parameter String path="IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.Records.Filling";
  final parameter Modelica.SIunits.DiffusionCoefficient alp=k/d/c;

end Filling;
