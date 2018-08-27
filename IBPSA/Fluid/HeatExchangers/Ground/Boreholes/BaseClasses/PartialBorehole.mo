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
First implementation of partial model.
</li>
<li>
July 2014, by Damien Picard:<br/>
First implementation.
</ul>
</html>"),
Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={2,2},
        initialScale=0.5), graphics={
        Rectangle(
          extent={{-68,76},{72,-84}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,-56},{64,-64}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,54},{64,50}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,2},{64,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-70,76},{-60,-84}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{64,76},{74,-84}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward)}));
end PartialBorehole;
