within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses;
partial model partialBorefield
  "Borefield model using single U-tube borehole heat exchanger configuration.Calculates the average fluid temperature T_fts of the borefield for a given (time dependent) load Q_flow"

  extends IBPSA.Fluid.Interfaces.PartialTwoPortInterface(
    m_flow_nominal=borFieDat.conDat.mBorFie_flow_nominal);

  extends IBPSA.Fluid.Interfaces.LumpedVolumeDeclarations;
  extends IBPSA.Fluid.Interfaces.TwoPortFlowResistanceParameters(
    dp_nominal=borFieDat.conDat.dp_nominal);

  // Simulation parameters
  parameter Modelica.SIunits.Time tLoaAgg=300 "Time resolution of load aggregation";
  parameter Integer nCel(min=1)=5 "Number of cells per aggregation level";
  parameter Integer nSeg(min=1)=10
    "Number of segments to use in vertical discretization of the boreholes";
  parameter Modelica.SIunits.Temperature TGro_start = Medium.T_default
    "Start value of grout temperature"
    annotation (Dialog(tab="Initialization"));
  parameter Boolean forceGFunCalc = false
    "Set to true to force the thermal response to be calculated at the start instead of checking whether this has been pre-computed"
    annotation (Dialog(tab="Advanced"));

  // General parameters of borefield
  parameter IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.BorefieldData.Template borFieDat "Borefield data"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

  parameter Boolean dynFil=true
    "Set to false to remove the dynamics of the filling material."
    annotation (Dialog(tab="Dynamics"));

  IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.MassFlowRateMultiplier masFloDiv(
    redeclare package Medium = Medium,
    allowFlowReversal=allowFlowReversal,
    k=borFieDat.conDat.nBor) "Division of flow rate"
    annotation (Placement(transformation(extent={{-60,-10},{-80,10}})));
  IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.MassFlowRateMultiplier masFloMul(
    redeclare package Medium = Medium,
    allowFlowReversal=allowFlowReversal,
    k=borFieDat.conDat.nBor) "Mass flow multiplier"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.GroundTemperatureResponse groTemRes(
    tLoaAgg=tLoaAgg,
    nCel=nCel,
    borFieDat=borFieDat,
    forceGFunCalc=forceGFunCalc)
                         "Ground temperature response"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector theCol(m=nSeg)
    "Thermal collector to connect the unique ground temperature to each borehole wall temperature of each segment"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-30,60})));

  Modelica.Blocks.Interfaces.RealInput TSoi
    "Temperature input for undisturbed ground conditions"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  replaceable Boreholes.BaseClasses.PartialBorehole borHol constrainedby
    Boreholes.BaseClasses.PartialBorehole(
    redeclare package Medium = Medium,
    borFieDat=borFieDat,
    nSeg=nSeg,
    m_flow_nominal=m_flow_nominal/borFieDat.conDat.nBor,
    dp_nominal=dp_nominal,
    allowFlowReversal=allowFlowReversal,
    m_flow_small=m_flow_small,
    show_T=show_T,
    computeFlowResistance=computeFlowResistance,
    from_dp=from_dp,
    linearizeFlowResistance=linearizeFlowResistance,
    deltaM=deltaM,
    energyDynamics=energyDynamics,
    massDynamics=massDynamics,
    p_start=p_start,
    T_start=T_start,
    X_start=X_start,
    C_start=C_start,
    C_nominal=C_nominal,
    mSenFac=mSenFac,
    dynFil=dynFil,
    TGro_start=TGro_start) "Borehole"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(masFloMul.port_b, port_b)
    annotation (Line(points={{80,0},{86,0},{100,0}}, color={0,127,255}));
  connect(groTemRes.borWall, theCol.port_b)
    annotation (Line(points={{-60,60},{-50,60},{-40,60}}, color={191,0,0}));
  connect(masFloDiv.port_b, port_a)
    annotation (Line(points={{-80,0},{-100,0}}, color={0,127,255}));
  connect(TSoi, groTemRes.TSoi)
    annotation (Line(points={{-120,60},{-82,60}},          color={0,0,127}));
  connect(masFloDiv.port_a, borHol.port_a)
    annotation (Line(points={{-60,0},{-36,0},{-10,0}}, color={0,127,255}));
  connect(borHol.port_b, masFloMul.port_a)
    annotation (Line(points={{10,0},{35,0},{60,0}}, color={0,127,255}));
  connect(theCol.port_a, borHol.port_wall)
    annotation (Line(points={{-20,60},{0,60},{0,10}}, color={191,0,0}));
  annotation (
    experiment(StopTime=70000, __Dymola_NumberOfIntervals=50),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{-100,60},{100,-66}},
          lineColor={0,0,0},
          fillColor={234,210,210},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-88,-6},{-32,-62}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-82,-12},{-38,-56}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-88,54},{-32,-2}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-82,48},{-38,4}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-26,54},{30,-2}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-20,48},{24,4}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-28,-6},{28,-62}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{-22,-12},{22,-56}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{36,56},{92,0}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{42,50},{86,6}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{38,-4},{94,-60}},
          lineColor={0,0,0},
          fillColor={223,188,190},
          fillPattern=FillPattern.Forward),
        Ellipse(
          extent={{44,-10},{88,-54}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Forward)}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),Documentation(info="<html>
<p>
This model simulates a borefield containing one or multiple boreholes
using the parameters in the <code>borFieDat</code> record.
</p>
<p>
Heat transfer to the soil is modeled using only one borehole heat exchanger
(To be added in an extended model). The
fluid mass flow rate into the borehole is divided to reflect the per-borehole
fluid mass flow rate. The borehole model calculates the dynamics within the
borehole itself using an axial discretization and a resistance-capacitance
network for the internal thermal resistances between the individual pipes and
between each pipe and the borehole wall.
</p>
<p>
The thermal interaction between the borehole wall and the surrounding soil
is modeled using <a href=\"modelica://IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.GroundTemperatureResponse\">IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.GroundTemperatureResponse</a>,
which uses a cell-shifting load aggregation technique to calculate the borehole wall
temperature after calculating and/or read (from a previous calculation) the borefield's thermal response factor.
</p>
</html>", revisions="<html>
<ul>
<li>
July 2018, by Alex Laferri&egrave;re:<br/>
Changed into a partial model and changed documentation to reflect the new approach
used by the borefield models.
</li>
<li>
July 2014, by Damien Picard:<br/>
First implementation.
</li>
</ul>
</html>"));
end partialBorefield;
