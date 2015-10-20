within Annex60.Experimental.Pipe;
model PipeHeatLossKUL_Reverse
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
    annotation (Placement(transformation(extent={{-32,-10},{-12,10}})));

  Modelica.Blocks.Interfaces.RealInput TBoundary annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,110}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={2,50})));
  BaseClasses.PDETime_modified            pDETime
    annotation (Placement(transformation(extent={{-34,74},{-14,94}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=u)
    annotation (Placement(transformation(extent={{-100,74},{-80,94}})));
  BaseClasses.ExponentialDecay          tempDecay(C=C, R=R)
    annotation (Placement(transformation(extent={{4,58},{24,78}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTem(m_flow_nominal=m_flow_nominal,
      redeclare package Medium = Medium,
    tau=0)
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
  Annex60.Fluid.MixingVolumes.MixingVolume idealHeater(
    m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium,
    nPorts=2,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    V=V,
    massDynamics=massDynamics,
    allowFlowReversal=allowFlowReversal)
    annotation (Placement(transformation(extent={{74,0},{94,20}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature1
    annotation (Placement(transformation(extent={{62,34},{74,46}})));

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

public
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{-40,-86},{-60,-66}})));
  Modelica.Blocks.Logical.Switch switch2
    annotation (Placement(transformation(extent={{34,30},{54,50}})));
  Fluid.Sensors.Temperature senTemB(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{94,-30},{74,-10}})));
  BaseClasses.ExponentialDecay          tempDecay1(
                                                  C=C, R=R)
    annotation (Placement(transformation(extent={{-36,28},{-56,48}})));
  Annex60.Fluid.Sensors.TemperatureTwoPort senTem2(
                                                  m_flow_nominal=m_flow_nominal,
      redeclare package Medium = Medium,
    tau=0)
    annotation (Placement(transformation(extent={{-56,-10},{-36,10}})));
  Annex60.Fluid.MixingVolumes.MixingVolume idealHeater1(
    m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium,
    nPorts=2,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    V=V,
    massDynamics=massDynamics,
    allowFlowReversal=allowFlowReversal)
    annotation (Placement(transformation(extent={{-70,0},{-90,-20}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature prescribedTemperature2
    annotation (Placement(transformation(extent={{-56,-46},{-68,-34}})));
  Fluid.Sensors.Temperature senTemA(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-110,-68},{-90,-88}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression1(y=pDETime.u >= 0)
    annotation (Placement(transformation(extent={{62,-82},{22,-62}})));
equation
  //Normalized speed of the fluid [1/s]
  u = port_a.m_flow/(rho_default*A);
  Q_Losses = -idealHeater.heatPort.Q_flow/length;

  connect(pDETime.u, realExpression.y) annotation (Line(
      points={{-36,84},{-79,84}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pipeAdiabaticPlugFlow.port_b, senTem.port_a) annotation (Line(
      points={{-12,0},{-8,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTem.T, tempDecay.TIn) annotation (Line(
      points={{2,11},{2,64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TBoundary, tempDecay.Tb) annotation (Line(
      points={{0,110},{0,88},{14,88},{14,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(idealHeater.heatPort, prescribedTemperature1.port)
    annotation (Line(points={{74,10},{74,10},{74,40}},
                                               color={191,0,0}));
  connect(senTem.port_b, idealHeater.ports[1])
    annotation (Line(points={{12,0},{12,0},{82,0}},
                                             color={0,127,255}));
  connect(idealHeater.ports[2], port_b)
    annotation (Line(points={{86,0},{86,0},{100,0}}, color={0,127,255}));
  connect(pDETime.tau, tempDecay.td) annotation (Line(
      points={{-13,84},{-2,84},{-2,72},{2,72}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(switch2.u1, tempDecay.TOut) annotation (Line(
      points={{32,48},{32,68},{25,68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(port_b, senTemB.port) annotation (Line(
      points={{100,0},{100,-30},{84,-30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(switch2.u3, senTemB.T) annotation (Line(
      points={{32,32},{30,32},{30,-20},{77,-20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(switch2.y, prescribedTemperature1.T) annotation (Line(
      points={{55,40},{60.8,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tempDecay1.Tb, TBoundary) annotation (Line(
      points={{-46,50},{-46,90},{-46,90},{-46,110},{0,110}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tempDecay1.td, pDETime.tau) annotation (Line(
      points={{-34,42},{-10,42},{-10,84},{-13,84}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pipeAdiabaticPlugFlow.port_a, senTem2.port_b) annotation (Line(
      points={{-32,0},{-36,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(idealHeater1.ports[1], senTem2.port_a) annotation (Line(
      points={{-78,0},{-56,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_a, idealHeater1.ports[2]) annotation (Line(
      points={{-100,0},{-82,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(prescribedTemperature2.port, idealHeater1.heatPort) annotation (Line(
      points={{-68,-40},{-70,-40},{-70,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(senTem2.T, tempDecay1.TIn) annotation (Line(
      points={{-46,11},{-46,16},{-18,16},{-18,34},{-34,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tempDecay1.TOut, switch1.u3) annotation (Line(
      points={{-57,38},{-64,38},{-64,-24},{70,-24},{70,-84},{-38,-84}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(port_a, senTemA.port) annotation (Line(
      points={{-100,0},{-100,-68}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemA.T, switch1.u1) annotation (Line(
      points={{-93,-78},{-76,-78},{-76,-58},{-28,-58},{-28,-68},{-38,-68},{-38,
          -68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(switch1.y, prescribedTemperature2.T) annotation (Line(
      points={{-61,-76},{-62,-76},{-62,-52},{-46,-52},{-46,-40},{-54.8,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(switch1.u2, booleanExpression1.y) annotation (Line(
      points={{-38,-76},{-22,-76},{-22,-76},{0,-76},{0,-72},{20,-72}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(booleanExpression1.y, switch2.u2) annotation (Line(
      points={{20,-72},{20,40},{32,40}},
      color={255,0,255},
      smooth=Smooth.None));
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
          extent={{-100,-100},{100,100}}), graphics),
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
end PipeHeatLossKUL_Reverse;
