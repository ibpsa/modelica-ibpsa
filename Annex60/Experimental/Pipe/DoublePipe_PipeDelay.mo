within Annex60.Experimental.Pipe;
model DoublePipe_PipeDelay
  "Pipe model for double pipe case with single delay calculation"
  extends Annex60.Fluid.Interfaces.PartialFourPort(
      redeclare final package Medium1 = Medium,
      redeclare final package Medium2 = Medium,
      final allowFlowReversal1 = allowFlowReversal,
      final allowFlowReversal2 = allowFlowReversal);


  // Geometric parameters
  final parameter Modelica.SIunits.Diameter diameter=pipeData.Di
    "Pipe diameter";
  parameter Modelica.SIunits.Length length = 100 "Pipe length";
  parameter Modelica.SIunits.Length H = 2 "Buried depth of pipe";

  replaceable parameter
    BaseClasses.DoublePipeConfig.IsoPlusDoubleStandard.IsoPlusDR20S pipeData
    constrainedby BaseClasses.DoublePipeConfig.PipeData(H=H)
    "Select pipe dimensions" annotation (choicesAllMatching=true, Placement(
        transformation(extent={{-96,-96},{-76,-76}})));

  // Mass flow and pressure drop related
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium constrainedby
    Modelica.Media.Interfaces.PartialMedium annotation (
      choicesAllMatching=true);

  parameter Boolean allowFlowReversal=true
    "= true to allow flow reversal in medium, false restricts to design direction (port_a -> port_b)"
    annotation (Dialog(tab="Assumptions"), Evaluate=true);

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate" annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m_flow_small(min=0) = 1E-4*abs(
    m_flow_nominal) "Small mass flow rate for regularization of zero flow"
    annotation (Dialog(tab="Advanced"));
  parameter Modelica.SIunits.Height roughness=2.5e-5
    "Average height of surface asperities (default: smooth steel pipe)"
    annotation (Dialog(group="Geometry"));

  parameter Modelica.SIunits.Temperature T_start=393.15
    "Start temperature to initialize the problem";

  // Heat transfer coefficients
  final parameter Types.ThermalResistanceLength Ra=pipeData.haInvers/(pipeData.lambdaI
      *2*Modelica.Constants.pi) "Resistance for asymmetric problem, in Km/W";
  final parameter Types.ThermalResistanceLength Rs=pipeData.hsInvers/(pipeData.lambdaI
      *2*Modelica.Constants.pi) "Resistance for symmetric problem, in Km/W";
  final parameter Types.ThermalCapacityPerLength C=rho_default*Modelica.Constants.pi
      *(diameter/2)^2*cp_default;

  parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
      Medium.specificHeatCapacityCp(state=sta_default)
    "Heat capacity of Medium";

  // fixme: shouldn't dp(nominal) be around 100 Pa/m?
  // fixme: propagate use_dh and set default to false

protected
  parameter Medium.ThermodynamicState sta_default=Medium.setState_pTX(
      T=Medium.T_default,
      p=Medium.p_default,
      X=Medium.X_default) "Default medium state";

  parameter Modelica.SIunits.Density rho_default=Medium.density_pTX(
      p=Medium.p_default,
      T=Medium.T_default,
      X=Medium.X_default)
    "Default density (e.g., rho_liquidWater = 995, rho_air = 1.2)"
    annotation (Dialog(group="Advanced", enable=use_rho_nominal));

  parameter Modelica.SIunits.DynamicViscosity mu_default=
      Medium.dynamicViscosity(Medium.setState_pTX(
      p=Medium.p_default,
      T=Medium.T_default,
      X=Medium.X_default))
    "Default dynamic viscosity (e.g., mu_liquidWater = 1e-3, mu_air = 1.8e-5)"
    annotation (Dialog(group="Advanced", enable=use_mu_default));

  PipeAdiabaticPlugFlow pipeSupplyAdiabaticPlugFlow(
    final m_flow_small=m_flow_small,
    final allowFlowReversal=allowFlowReversal,
    dh=diameter,
    length=length,
    m_flow_nominal=m_flow_nominal,
    redeclare final package Medium = Medium,
    from_dp=from_dp)
    "Model for temperature wave propagation with spatialDistribution operator and hydraulic resistance"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));

public
  BaseClasses.HeatLossDoublePipeDelay heatLossSupplyReverse(
    redeclare final package Medium = Medium,
    diameter=diameter,
    length=length,
    C=C,
    Ra=Ra,
    Rs=Rs,
    m_flow_small=m_flow_small,
    m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-40,50},{-60,70}})));

  BaseClasses.HeatLossDoublePipeDelay heatLossSupply(
    redeclare final package Medium = Medium,
    diameter=diameter,
    length=length,
    C=C,
    Ra=Ra,
    Rs=Rs,
    m_flow_small=m_flow_small,
    m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{52,50},{72,70}})));

protected
  PipeAdiabaticPlugFlow pipeReturnAdiabaticPlugFlow(
    redeclare final package Medium = Medium,
    final m_flow_small=m_flow_small,
    final allowFlowReversal=allowFlowReversal,
    dh=diameter,
    length=length,
    m_flow_nominal=m_flow_nominal,
    from_dp=from_dp)
    "Model for temperature wave propagation with spatialDistribution operator and hydraulic resistance"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={0,-60})));
public
  BaseClasses.HeatLossDoublePipeDelay heatLossReturn(
    redeclare final package Medium = Medium,
    diameter=diameter,
    length=length,
    C=C,
    Ra=Ra,
    Rs=Rs,
    m_flow_small=m_flow_small,
    m_flow_nominal=m_flow_nominal)
                               annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-62,-58})));

  BaseClasses.HeatLossDoublePipeDelay heatLossReturnReverse(
    redeclare final package Medium = Medium,
    diameter=diameter,
    length=length,
    C=C,
    Ra=Ra,
    Rs=Rs,
    m_flow_small=m_flow_small,
    m_flow_nominal=m_flow_nominal)
                               annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={50,-60})));

  BaseClasses.TimeDelay        pDETime_massFlow(len=length, diameter=diameter)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Fluid.Sensors.MassFlowRate senMasFlo(redeclare final package Medium = Medium)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-26,60})));

  parameter Boolean from_dp=false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Dialog(tab="Advanced"));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    "Ambient temperature of pipe's surroundings (undisturbed ground/surface)"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));

equation

  connect(pipeSupplyAdiabaticPlugFlow.port_b, heatLossSupply.port_a)
    annotation (Line(points={{10,60},{52,60}},         color={0,127,255}));
  connect(heatLossReturn.port_a, pipeReturnAdiabaticPlugFlow.port_b)
    annotation (Line(points={{-52,-58},{-52,-60},{-10,-60}}, color={0,127,255}));
  connect(pipeReturnAdiabaticPlugFlow.port_a, heatLossReturnReverse.port_a)
    annotation (Line(points={{10,-60},{26,-60},{40,-60}}, color={0,127,255}));
  connect(port_a1, heatLossSupplyReverse.port_b)
    annotation (Line(points={{-100,60},{-60,60}},          color={0,127,255}));
  connect(heatLossSupply.port_b, port_b1)
    annotation (Line(points={{72,60},{72,60},{100,60}}, color={0,127,255}));
  connect(port_b2, heatLossReturn.port_b) annotation (Line(points={{-100,-60},{
          -72,-60},{-72,-58}}, color={0,127,255}));
  connect(heatLossReturnReverse.port_b, port_a2) annotation (Line(points={{60,-60},
          {100,-60}},           color={0,127,255}));
  connect(heatLossSupplyReverse.port_a, senMasFlo.port_a)
    annotation (Line(points={{-40,60},{-36,60}}, color={0,127,255}));
  connect(senMasFlo.port_b, pipeSupplyAdiabaticPlugFlow.port_a)
    annotation (Line(points={{-16,60},{-13,60},{-10,60}}, color={0,127,255}));
  connect(senMasFlo.m_flow, pDETime_massFlow.m_flow) annotation (Line(points={{
          -26,49},{-26,49},{-26,0},{-12,0}}, color={0,0,127}));
  connect(heatLossSupplyReverse.T_2out, heatLossReturnReverse.T_2in)
    annotation (Line(points={{-56,50},{-56,-26},{44,-26},{44,-50}}, color={0,0,
          127}));
  connect(heatLossReturnReverse.T_2out, heatLossSupplyReverse.T_2in)
    annotation (Line(points={{56,-50},{56,26},{-44,26},{-44,50}}, color={0,0,
          127}));
  connect(heatLossReturn.T_2out, heatLossSupply.T_2in) annotation (Line(points=
          {{-68,-48},{-68,30},{56,30},{56,50}}, color={0,0,127}));
  connect(heatLossSupply.T_2out, heatLossReturn.T_2in) annotation (Line(points=
          {{68,50},{68,-30},{-56,-30},{-56,-48}}, color={0,0,127}));
  connect(pDETime_massFlow.tau, heatLossSupplyReverse.Tau_in) annotation (Line(
        points={{11,0},{24,0},{24,76},{-44,76},{-44,70}}, color={0,0,127}));
  connect(heatLossSupply.Tau_in, heatLossSupplyReverse.Tau_in) annotation (Line(
        points={{56,70},{56,76},{-44,76},{-44,70}}, color={0,0,127}));
  connect(pDETime_massFlow.tau, heatLossReturn.Tau_in) annotation (Line(points=
          {{11,0},{24,0},{24,-80},{-56,-80},{-56,-68}}, color={0,0,127}));
  connect(heatLossReturnReverse.Tau_in, heatLossReturn.Tau_in) annotation (Line(
        points={{44,-70},{44,-80},{-56,-80},{-56,-68}}, color={0,0,127}));
  connect(heatLossReturnReverse.heatPort, heatLossReturn.heatPort) annotation (
      Line(points={{50,-70},{50,-84},{-62,-84},{-62,-68}}, color={191,0,0}));
  connect(heatLossSupplyReverse.heatPort, heatPort) annotation (Line(points={{
          -50,70},{-50,86},{0,86},{0,100}}, color={191,0,0}));
  connect(heatLossSupply.heatPort, heatPort) annotation (Line(points={{62,70},{
          62,86},{0,86},{0,100}}, color={191,0,0}));
  connect(heatPort, heatPort)
    annotation (Line(points={{0,100},{0,100}}, color={191,0,0}));
  connect(heatLossReturnReverse.heatPort, heatPort) annotation (Line(points={{
          50,-70},{50,-84},{28,-84},{28,86},{0,86},{0,100}}, color={191,0,0}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Rectangle(
          extent={{-100,80},{100,40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{-100,74},{100,46}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Rectangle(
          extent={{-100,84},{100,80}},
          lineColor={175,175,175},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-100,40},{100,36}},
          lineColor={175,175,175},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Polygon(
          points={{0,31},{40,-7},{20,-7},{20,-31},{-20,-31},{-20,-7},{-40,-7},{
              0,31}},
          lineColor={0,0,0},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          origin={-40,15},
          rotation=180),
        Line(
          points={{55,-39},{-60,-39}},
          color={0,128,255},
          smooth=Smooth.None,
          visible=showDesignFlowDirection),
        Rectangle(
          extent={{-100,-40},{100,-80}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{-100,-46},{100,-74}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Rectangle(
          extent={{-100,-36},{100,-40}},
          lineColor={175,175,175},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-100,-80},{100,-84}},
          lineColor={175,175,175},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Polygon(
          points={{0,31},{40,-7},{20,-7},{20,-31},{-20,-31},{-20,-7},{-40,-7},{
              0,31}},
          lineColor={0,0,0},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          origin={40,-15},
          rotation=360),
        Polygon(
          points={{40,74},{40,46},{66,60},{40,74}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-28,74},{28,46}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={215,202,187}),
        Polygon(
          points={{-13,14},{-13,-14},{13,0},{-13,14}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-53,-60},
          rotation=180),
        Line(
          points={{-40,60},{42,60}},
          color={255,255,255},
          thickness=0.5),
        Rectangle(
          extent={{-28,-46},{28,-74}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={215,202,187}),
        Line(
          points={{-41,0},{41,0}},
          color={255,255,255},
          thickness=0.5,
          origin={-5,-60},
          rotation=180),
        Ellipse(
          extent={{-86,96},{-44,54}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{24,22},{-24,-22}},
          lineColor={28,108,200},
          startAngle=30,
          endAngle=90,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid,
          origin={-46,96},
          rotation=180)}),
    Documentation(revisions="<html>
<ul>
<li><span style=\"font-family: MS Shell Dlg 2;\">July 4, 2016 by Bram van der Heijde:<br>Introduce <code></span><span style=\"font-family: Courier New,courier;\">pipVol</code></span><span style=\"font-family: MS Shell Dlg 2;\">.</span></li>
<li>February 15, 2015 by Bram van der Heijde:<br>Fix issues due to new implementation of PartialFourPort. </li>
<li>December 1, 2015 by Bram van der Heijde:<br>First implementation using Annex 60 components, based on the single pipe model lay-out. </li>
<li>July 2015 by Arnout Aertgeerts:<br>First implementation (outside Annex 60) of double heat loss pipe. Flow reversal not possible.</li>
</ul>
</html>", info="<html>
<p>Implementation of twin or double pipe (supply and return in the same ensemble) using delay dependent heat losses for opposite flow of supply and return. </p>
<p>Because of the way in which the temperature change is calculated, input information from one pipe must be supplied to the opposite pipe, hence the cross-connections. </p>
<p>The delay time is calculated once for the whole setup, since equal but opposite flow in both pipes is assumed. </p>
<h4>Assumptions</h4>
<ul>
<li>This model is assuming equal but opposite flow in the two pipes for the calculation of heat losses. </li>
</ul>
</html>"));
end DoublePipe_PipeDelay;
