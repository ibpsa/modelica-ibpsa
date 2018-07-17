within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers;
model BorefieldTwoUTube
  extends IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BaseClasses.partialBorefield;
  IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Boreholes.BoreholeTwoUTube borHol(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal,
    borFieDat=borFieDat,
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
    nSeg=nSeg,
    TGro_start=TGro_start)
               "Borehole"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}})));
equation
  connect(masFloDiv.port_a, borHol.port_a)
    annotation (Line(points={{-60,0},{-40,0},{-20,0}}, color={0,127,255}));
  connect(borHol.port_b, masFloMul.port_a)
    annotation (Line(points={{20,0},{40,0},{60,0}}, color={0,127,255}));
  connect(theCol.port_a, borHol.port_wall)
    annotation (Line(points={{-20,60},{0,60},{0,20}}, color={191,0,0}));

  annotation(Documentation(info="<html>
This model simulates a borefield containing one or many double U-Tube boreholes
using the parameters in the <code>borFieDat</code> record. The fluid mass flow rate
is adjusted to reflect the per-borehole fluid mass flow rate, and the borehole model
calculates both the dynamics between the uniform borehole wall and the surrounding soil
temperature (<code>TSoi</code>) as well as the dynamics within the borehole itself
using an axial discretization and a resistance-capacitance network for the internal
thermal resistances.
</html>", revisions="<html>
<ul>
<li>
July 10, 2018, by Alex Laferri&egrave;re:<br/>
First implementation.
</li>
</ul>
</html>"));
end BorefieldTwoUTube;
