within Annex60.Experimental.Pipe.Archive;
model PipeHeatLossKUL
  "Pipe model with a temperature plug flow, pressure losses and heat exchange to the environment"

  //Extensions
  extends Annex60.Fluid.Interfaces.PartialTwoPortInterface;
  extends Annex60.Fluid.Interfaces.LumpedVolumeDeclarations(
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState);
  extends Annex60.Fluid.Interfaces.TwoPortFlowResistanceParameters(dp_nominal = 2*dpStraightPipe_nominal);

  //Parameters
  parameter Modelica.SIunits.Diameter diameter "Pipe diameter";
  parameter Modelica.SIunits.Length length "Pipe length";
  parameter Modelica.SIunits.Length thicknessIns "Thickness of pipe insulation";

  parameter Modelica.SIunits.Height roughness=2.5e-5
    "Average height of surface asperities (default: smooth steel pipe)"
      annotation(Dialog(group="Geometry"));

  final constant Real pi = Modelica.Constants.pi;
  final parameter Modelica.SIunits.Area A=pi*(diameter/2)^2;
  final parameter Modelica.SIunits.Volume V=length*A;

  parameter Boolean dynamicBalance = true
    "Set to true to use a dynamic balance, which often leads to smaller systems of equations"
    annotation (Evaluate=true, Dialog(tab="Dynamics", group="Equations"));
  parameter Modelica.SIunits.ThermalConductivity lambdaI=0.026
    "Heat conductivity";

  parameter Modelica.SIunits.ThermalConductivity R=1/(lambdaI*2*pi/Modelica.Math.log((diameter/2+thicknessIns)/(diameter/2)));
  final parameter Real C=rho_default*pi*(diameter/2)^2*cp_default;

  parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
    Medium.specificHeatCapacityCp(state=sta_default) "Heat capacity of medium";

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

  //Variables
  Real u;
  Real Q_Losses;

  //Components
  PipeAdiabaticPlugFlow pipeAdiabaticPlugFlow(
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal,
    redeclare package Medium = Medium,
    allowFlowReversal=allowFlowReversal,
    diameter=diameter,
    length=length,
    roughness=roughness)
    "Model for temperature wave propagation with spatialDistribution operator and hydraulic resistance"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  Modelica.Blocks.Interfaces.RealInput TBoundary annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,110}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={2,50})));
  BaseClasses.PDETime_massFlow            pDETime
    annotation (Placement(transformation(extent={{-28,24},{-8,44}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=u)
    annotation (Placement(transformation(extent={{-58,24},{-38,44}})));
  ExponentialDecay tempDecay(C=C, R=R)
    annotation (Placement(transformation(extent={{12,20},{32,40}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTem(m_flow_nominal=m_flow_nominal,
      redeclare package Medium = Medium,
    tau=0)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Annex60.Fluid.MixingVolumes.MixingVolume idealHeater(
    m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium,
    nPorts=2,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    V=V,
    massDynamics=massDynamics,
    allowFlowReversal=allowFlowReversal)
    annotation (Placement(transformation(extent={{62,0},{82,20}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature1
    annotation (Placement(transformation(extent={{46,4},{58,16}})));

protected
  parameter Medium.ThermodynamicState sta_default=
     Medium.setState_pTX(
       T=Medium.T_default,
       p=Medium.p_default,
       X=Medium.X_default) "Default medium state";

  parameter Modelica.SIunits.Density rho_default=
      Medium.density_pTX(
       p=Medium.p_default,
       T=Medium.T_default,
       X=Medium.X_default)
    "Default density (e.g., rho_liquidWater = 995, rho_air = 1.2)"
    annotation(Dialog(group="Advanced", enable=use_rho_nominal));

  parameter Modelica.SIunits.DynamicViscosity mu_default=
    Medium.dynamicViscosity(Medium.setState_pTX(
      p=  Medium.p_default,
      T=  Medium.T_default,
      X=  Medium.X_default))
    "Default dynamic viscosity (e.g., mu_liquidWater = 1e-3, mu_air = 1.8e-5)"
    annotation(Dialog(group="Advanced", enable=use_mu_default));

equation
  //Normalized speed of the fluid [1/s]
  u = port_a.m_flow/(rho_default*V);
  Q_Losses = -idealHeater.heatPort.Q_flow/length;

  connect(port_a, pipeAdiabaticPlugFlow.port_a) annotation (Line(
      points={{-100,0},{-60,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipeAdiabaticPlugFlow.port_b, senTem.port_a) annotation (Line(
      points={{-40,0},{-10,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTem.T, tempDecay.TIn) annotation (Line(
      points={{0,11},{0,26},{10,26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pDETime.tau, tempDecay.td) annotation (Line(
      points={{-7,34},{10,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TBoundary, tempDecay.Tb) annotation (Line(
      points={{0,110},{0,60},{22,60},{22,42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(idealHeater.heatPort, prescribedTemperature1.port)
    annotation (Line(points={{62,10},{58,10}}, color={191,0,0}));
  connect(senTem.port_b, idealHeater.ports[1])
    annotation (Line(points={{10,0},{70,0}}, color={0,127,255}));
  connect(idealHeater.ports[2], port_b)
    annotation (Line(points={{74,0},{74,0},{100,0}}, color={0,127,255}));
  connect(tempDecay.TOut, prescribedTemperature1.T) annotation (Line(points={{33,
          30},{40,30},{40,10},{44.8,10}}, color={0,0,127}));
  connect(realExpression.y, pDETime.m_flow)
    annotation (Line(points={{-37,34},{-30,34}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),
                   graphics={
        Polygon(
          points={{20,-70},{60,-85},{20,-100},{20,-70}},
          lineColor={0,128,255},
          smooth=Smooth.None,
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          visible=showDesignFlowDirection),
        Polygon(
          points={{20,-75},{50,-85},{20,-95},{20,-75}},
          lineColor={255,255,255},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=allowFlowReversal),
        Polygon(
          points={{20,-75},{50,-85},{20,-95},{20,-75}},
          lineColor={255,255,255},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=allowFlowReversal),
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
        Line(
          points={{55,-85},{-60,-85}},
          color={0,128,255},
          smooth=Smooth.None,
          visible=showDesignFlowDirection),
        Rectangle(
          extent={{-100,50},{100,40}},
          lineColor={175,175,175},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward),
        Rectangle(
          extent={{-100,-40},{100,-50}},
          lineColor={175,175,175},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward)}),
                           Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}})),
    Documentation(revisions="<html>
<ul>
<li>
October 10, 2015 by Marcus Fuchs:<br/>
Use adiabatic plug flow pipe from A60 implementation; Rename variables; Use default fluid properties;
</li>
<li>
2015 by Bram van der Heijde:<br/>
First implementation.
</li>
</ul>
</html>"));
end PipeHeatLossKUL;
