within IBPSA.Fluid.PlugFlowPipes.BaseClasses;
model PipeCore
  "Pipe model using spatialDistribution for temperature delay with modified delay tracker"
  extends IBPSA.Fluid.Interfaces.PartialTwoPort;

  parameter Modelica.SIunits.Length dh
    "Hydraulic diameter (assuming a round cross section area)";
  parameter Modelica.SIunits.Length length(min=0) "Pipe length";
  parameter Modelica.SIunits.Length dIns(min=0) "Thickness of pipe insulation";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal(min=0)
    "Nominal mass flow rate" annotation (Dialog(group="Nominal condition"));

  parameter Modelica.SIunits.MassFlowRate m_flow_small(min=0) = 1E-4*abs(
    m_flow_nominal) "Small mass flow rate for regularization of zero flow"
    annotation (Dialog(tab="Advanced"));

  parameter Modelica.SIunits.Height roughness=2.5e-5
    "Average height of surface asperities (default: smooth steel pipe)"
    annotation (Dialog(group="Geometry"));

  parameter IBPSA.Fluid.PlugFlowPipes.Types.ThermalResistanceLength R=1/(
      kIns*2*Modelica.Constants.pi/Modelica.Math.log((dh/2 + dIns)/(
      dh/2))) "Thermal resistance per unit length from water to boundary";
  parameter IBPSA.Fluid.PlugFlowPipes.Types.ThermalCapacityPerLength C=
      rho_default*Modelica.Constants.pi*(dh/2)^2*cp_default "Thermal capacity per unit length of pipe";
  parameter Modelica.SIunits.ThermalConductivity kIns
    "Heat conductivity of insulation material";

  parameter Modelica.SIunits.SpecificHeatCapacity cpipe=2300 "Specific heat of pipe wall material. 2300 J/(kg.K) for PE, 500 J/(kg.K) For steel";
  parameter Modelica.SIunits.Density rho_wall=8000 "For steel";

  parameter Boolean from_dp=false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(tab="Advanced"));
  parameter Modelica.SIunits.Length thickness(min=0) "Pipe wall thickness";

  parameter Modelica.SIunits.Temperature T_start_in=Medium.T_default
    "Initialization temperature at pipe inlet"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.Temperature T_start_out=Medium.T_default
    "Initialization temperature at pipe outlet"
    annotation (Dialog(tab="Initialization"));
  parameter Boolean initDelay=false
    "Initialize delay for a constant mass flow rate if true, otherwise start from 0"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.SIunits.MassFlowRate m_flow_start=0
    annotation (Dialog(tab="Initialization", enable=initDelay));

  IBPSA.Fluid.PlugFlowPipes.BaseClasses.PipeAdiabaticPlugFlow
    pipeAdiabaticPlugFlow(
    redeclare final package Medium = Medium,
    final m_flow_small=m_flow_small,
    final allowFlowReversal=allowFlowReversal,
    dh=dh,
    length=length,
    m_flow_nominal=m_flow_nominal,
    from_dp=from_dp,
    T_start_in=T_start_in,
    T_start_out=T_start_out)
    "Model for temperature wave propagation with spatialDistribution operator and hydraulic resistance"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  IBPSA.Fluid.PlugFlowPipes.BaseClasses.HeatLossPipeDelay reverseHeatLoss(
    redeclare package Medium = Medium,
    C=C,
    R=R,
    m_flow_small=m_flow_small,
    T_start=T_start_in,
    m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-60,-10},{-80,10}})));

  IBPSA.Fluid.PlugFlowPipes.BaseClasses.HeatLossPipeDelay heatLoss(
    redeclare package Medium = Medium,
    C=C,
    R=R,
    m_flow_small=m_flow_small,
    T_start=T_start_out,
    m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  IBPSA.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-44,10},{-24,-10}})));
  IBPSA.Fluid.PlugFlowPipes.BaseClasses.TimeDelay timeDelay(
    length=length,
    dh=dh,
    rho=rho_default,
    initDelay=initDelay,
    m_flow_start=m_flow_start)
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    "Heat port to connect environment (positive heat flow for heat loss to surroundings)"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));

protected
  final parameter Modelica.SIunits.HeatCapacity walCap=length*((dh + 2*thickness)^2 -
      dh^2)*Modelica.Constants.pi/4*cpipe*rho_wall "Heat capacity of pipe wall";
  parameter Medium.ThermodynamicState sta_default=Medium.setState_pTX(
      T=Medium.T_default,
      p=Medium.p_default,
      X=Medium.X_default) "Default medium state";

  parameter Modelica.SIunits.Density rho_default=Medium.density_pTX(
      p=Medium.p_default,
      T=Medium.T_default,
      X=Medium.X_default)
    "Default density (e.g., rho_liquidWater = 995, rho_air = 1.2)"
    annotation (Dialog(group="Advanced"));

  parameter Modelica.SIunits.DynamicViscosity mu_default=
      Medium.dynamicViscosity(Medium.setState_pTX(
      p=Medium.p_default,
      T=Medium.T_default,
      X=Medium.X_default))
    "Default dynamic viscosity (e.g., mu_liquidWater = 1e-3, mu_air = 1.8e-5)"
    annotation (Dialog(group="Advanced"));

  parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
      Medium.specificHeatCapacityCp(state=sta_default)
    "Heat capacity of medium";

equation

  connect(senMasFlo.m_flow, timeDelay.m_flow) annotation (Line(
      points={{-34,-11},{-34,-40},{-12,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(reverseHeatLoss.heatPort, heatPort) annotation (Line(points={{-70,10},
          {-70,40},{0,40},{0,100}}, color={191,0,0}));
  connect(heatLoss.heatPort, heatPort) annotation (Line(points={{50,10},{50,40},
          {0,40},{0,100}}, color={191,0,0}));

  connect(timeDelay.tauRev, reverseHeatLoss.tau) annotation (Line(points={{11,-36},
          {26,-36},{26,28},{-64,28},{-64,10}}, color={0,0,127}));
  connect(timeDelay.tau, heatLoss.tau) annotation (Line(points={{11,-44},{32,-44},
          {32,28},{44,28},{44,10}}, color={0,0,127}));

  connect(port_a, reverseHeatLoss.port_b)
    annotation (Line(points={{-100,0},{-80,0},{-80,0}}, color={0,127,255}));
  connect(reverseHeatLoss.port_a, senMasFlo.port_a)
    annotation (Line(points={{-60,0},{-52,0},{-44,0}}, color={0,127,255}));
  connect(senMasFlo.port_b, pipeAdiabaticPlugFlow.port_a)
    annotation (Line(points={{-24,0},{-17,0},{-10,0}}, color={0,127,255}));
  connect(heatLoss.port_b, port_b)
    annotation (Line(points={{60,0},{100,0}}, color={0,127,255}));
  connect(pipeAdiabaticPlugFlow.port_b, heatLoss.port_a)
    annotation (Line(points={{10,0},{40,0}}, color={0,127,255}));
  annotation (
    Line(points={{70,20},{72,20},{72,0},{100,0}}, color={0,127,255}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{-100,40},{100,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{-100,30},{100,-30}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Rectangle(
          extent={{-100,50},{100,40}},
          lineColor={175,175,175},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-100,-40},{100,-50}},
          lineColor={175,175,175},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Polygon(
          points={{0,100},{40,62},{20,62},{20,38},{-20,38},{-20,62},{-40,62},{0,
              100}},
          lineColor={0,0,0},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-30,30},{28,-30}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={215,202,187})}),
    Documentation(revisions="<html>
<ul>
<li>July 4, 2016 by Bram van der Heijde:<br/>Introduce <code>pipVol</code>.</li>
<li>October 10, 2015 by Marcus Fuchs:<br/>Copy Icon from KUL implementation and rename model; Replace resistance and temperature delay by an adiabatic pipe; </li>
<li>September, 2015 by Marcus Fuchs:<br/>First implementation. </li>
</ul>
</html>", info="<html>
<p>Implementation of a pipe with heat loss using the time delay based heat losses and the spatialDistribution operator for the temperature wave propagation through the length of the pipe.</p>
<p>The heat loss component adds a heat loss in design direction, and leaves the enthalpy unchanged in opposite flow direction. 
Therefore it is used in front of and behind the time delay. 
The delay time is calculated once on the pipe level and supplied to both heat loss operators.</p>
<p>This component uses a modified delay operator.</p>
</html>"));
end PipeCore;
