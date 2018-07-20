within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Boreholes.BaseClasses;
partial model PartialBorehole
  "Partial model to implement multi-segment boreholes"
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
  parameter Modelica.SIunits.Temperature TGro_start = Medium.T_default
    "Start value of grout temperature"
    annotation (Dialog(tab="Initialization"));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_wall[nSeg]
    "Thermal connection for borehole wall"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));

    annotation(Documentation(info="<html>
<p>
Partial model to implement models simulating geothermal U-tube boreholes modeled
as several borehole segments, with a uniform borehole wall boundary condition.
</p>
</html>", revisions="<html>
<ul>
<li>
July 5, 2018, by Alex Laferri&egrave;re:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialBorehole;
