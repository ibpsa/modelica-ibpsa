within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Boreholes;
partial model partialBorehole
  extends IBPSA.Fluid.Interfaces.PartialTwoPortInterface;

  extends IBPSA.Fluid.Interfaces.TwoPortFlowResistanceParameters;
  extends IBPSA.Fluid.Interfaces.LumpedVolumeDeclarations;

  parameter Boolean dynFil=true
      "Set to false to remove the dynamics of the filling material"
      annotation (Dialog(tab="Dynamics"));
  parameter Data.BorefieldData.Template borFieDat "Borefield parameters"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  parameter Integer nSeg(min=1) = 10
    "Number of segments to use in vertical discretization of the boreholes";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_wall[nSeg]
    "Thermal connection for borehole wall"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
end partialBorehole;
