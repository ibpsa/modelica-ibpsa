within Annex60.Experimental.Pipe;
model PipeHeatLoss_PipeDelayMod
  "Pipe model using spatialDistribution for temperature delay with heat losses modified and one delay operator at pipe level"
  extends Annex60.Fluid.Interfaces.PartialTwoPort;

  output Modelica.SIunits.HeatFlowRate heat_losses "Heat losses in this pipe";

  parameter Modelica.SIunits.Diameter diameter "Pipe diameter";
  parameter Modelica.SIunits.Length length "Pipe length";
  parameter Modelica.SIunits.Length thicknessIns "Thickness of pipe insulation";

  /*parameter Modelica.SIunits.ThermalConductivity k = 0.005 
    "Heat conductivity of pipe's surroundings";*/

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate" annotation (Dialog(group="Nominal condition"));

  parameter Modelica.SIunits.MassFlowRate m_flow_small(min=0) = 1E-4*abs(
    m_flow_nominal) "Small mass flow rate for regularization of zero flow"
    annotation (Dialog(tab="Advanced"));

  parameter Modelica.SIunits.Height roughness=2.5e-5
    "Average height of surface asperities (default: smooth steel pipe)"
    annotation (Dialog(group="Geometry"));

  parameter Modelica.SIunits.Pressure dp_nominal(displayUnit="Pa") = 2*
    dpStraightPipe_nominal "Pressure drop at nominal mass flow rate"
    annotation (Dialog(group="Nominal condition"));

  final parameter Modelica.SIunits.Pressure dpStraightPipe_nominal=
      Modelica.Fluid.Pipes.BaseClasses.WallFriction.Detailed.pressureLoss_m_flow(
      m_flow=m_flow_nominal,
      rho_a=rho_default,
      rho_b=rho_default,
      mu_a=mu_default,
      mu_b=mu_default,
      length=length,
      diameter=diameter,
      roughness=roughness,
      m_flow_small=m_flow_small)
    "Pressure loss of a straight pipe at m_flow_nominal";

  parameter Types.ThermalResistanceLength R=1/(lambdaI*2*Modelica.Constants.pi/Modelica.Math.log((diameter/2 + thicknessIns)/(diameter/2)));
  parameter Types.ThermalCapacityPerLength C=rho_default*Modelica.Constants.pi*(diameter/2)^2*cp_default;
  parameter Modelica.SIunits.ThermalConductivity lambdaI=0.026
    "Heat conductivity";

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

  PipeAdiabaticPlugFlow pipeAdiabaticPlugFlow(
    redeclare final package Medium = Medium,
    final m_flow_small=m_flow_small,
    final allowFlowReversal=allowFlowReversal,
    diameter=diameter,
    length=length,
    m_flow_nominal=m_flow_nominal)
    "Model for temperature wave propagation with spatialDistribution operator and hydraulic resistance"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
      Medium.specificHeatCapacityCp(state=sta_default)
    "Heat capacity of medium";

public
  Modelica.Blocks.Interfaces.RealInput T_amb
    "Ambient temperature for pipe's surroundings" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,100})));
  BaseClasses.HeatLossPipeDelay reverseHeatLoss(
    redeclare package Medium = Medium,
    diameter=diameter,
    length=length,
    thicknessIns=thicknessIns,
    C=C,
    R=R,
    m_flow_small=m_flow_small)
    annotation (Placement(transformation(extent={{-60,-10},{-80,10}})));

  BaseClasses.HeatLossPipeDelay heatLoss(
    redeclare package Medium = Medium,
    diameter=diameter,
    length=length,
    thicknessIns=thicknessIns,
    C=C,
    R=R,
    m_flow_small=m_flow_small)
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-44,10},{-24,-10}})));
  BaseClasses.PDETime_massFlowMod tau_unused_maxClause(diameter=diameter,
      length=length)
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  BaseClasses.PDETime_massFlowMod tau_used(length=length, diameter=
        diameter)
    annotation (Placement(transformation(extent={{2,-64},{22,-44}})));
equation
  heat_losses = actualStream(port_b.h_outflow) - actualStream(port_a.h_outflow);

  connect(port_a, reverseHeatLoss.port_b)
    annotation (Line(points={{-100,0},{-80,0}}, color={0,127,255}));
  connect(pipeAdiabaticPlugFlow.port_b, heatLoss.port_a)
    annotation (Line(points={{10,0},{40,0}},        color={0,127,255}));
  connect(port_b, heatLoss.port_b)
    annotation (Line(points={{100,0},{60,0}},        color={0,127,255}));
  connect(T_amb, reverseHeatLoss.T_amb) annotation (Line(points={{0,100},{0,100},
          {0,54},{0,40},{-70,40},{-70,10}}, color={0,0,127}));
  connect(heatLoss.T_amb, reverseHeatLoss.T_amb) annotation (Line(points={{50,10},
          {50,40},{-70,40},{-70,10}}, color={0,0,127}));
  connect(pipeAdiabaticPlugFlow.port_a, senMasFlo.port_b)
    annotation (Line(points={{-10,0},{-18,0},{-24,0}},
                                               color={0,127,255}));
  connect(senMasFlo.port_a, reverseHeatLoss.port_a)
    annotation (Line(points={{-44,0},{-52,0},{-60,0}},
                                               color={0,127,255}));
  connect(senMasFlo.m_flow, tau_unused_maxClause.m_flow) annotation (Line(
      points={{-34,-11},{-34,-40},{-22,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senMasFlo.m_flow, tau_used.m_flow) annotation (Line(
      points={{-34,-11},{-34,-54},{0,-54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tau_used.tau, reverseHeatLoss.tau) annotation (Line(
      points={{23,-54},{28,-54},{28,32},{-64,32},{-64,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tau_used.tau, heatLoss.tau) annotation (Line(
      points={{23,-54},{28,-54},{28,32},{44,32},{44,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),
                    graphics),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Ellipse(extent={{-90,92},{-48,50}}, lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
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
          extent={{-26,30},{30,-30}},
          lineColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder),
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
        Ellipse(
          extent={{-90,92},{-48,50}},
          lineColor={28,108,200},
          startAngle=30,
          endAngle=90,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid)}),
    Documentation(revisions="<html>
<ul>
<li>
October 10, 2015 by Marcus Fuchs:<br/>
Copy Icon from KUL implementation and rename model; Replace resistance and temperature delay by an adiabatic pipe;
</li>
<li>
September, 2015 by Marcus Fuchs:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>First implementation of a pipe with heat loss using the fixed resistance from Annex60 and the spatialDistribution operator for the temperature wave propagation through the length of the pipe. </p>
<p>This setup is meant as a benchmark for more sophisticated implementations. It seems to generally work ok except for the cooling effects on the standing fluid in case of zero mass flow.</p>
<p>The heat loss component adds a heat loss in design direction, and leaves the enthalpy unchanged in opposite flow direction. Therefore it is used before and after the time delay.</p>
</html>"));
end PipeHeatLoss_PipeDelayMod;
