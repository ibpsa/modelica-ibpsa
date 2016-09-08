within Annex60.Experimental.Pipe;
model PipeAdiabaticPlugFlow
  "Pipe model using spatialDistribution for temperature delay without heat losses"
  extends Annex60.Fluid.Interfaces.PartialTwoPort;

  parameter Modelica.SIunits.Length thickness=0.002;
  parameter Modelica.SIunits.Length Lcap=1
    "Length over which transient effects typically take place";
  parameter Modelica.SIunits.Length dh=0.05 "Hydraulic diameter"
    annotation (Dialog(enable=use_dh));
  parameter Modelica.SIunits.Length length "Pipe length";
  parameter Modelica.SIunits.HeatCapacity Cpipe=length*((dh + thickness)^2 - dh
      ^2)*Modelica.Constants.pi/4*cpipe*rho_wall "Heat capacity of pipe wall";
  parameter Modelica.SIunits.SpecificHeatCapacity cpipe=500 "For steel";
  parameter Modelica.SIunits.Density rho_wall=8000 "For steel";

  parameter Boolean pipVol=true
    "Flag to decide whether volumes are included at the end points of the pipe";

  /*parameter Modelica.SIunits.ThermalConductivity k = 0.005
    "Heat conductivity of pipe's surroundings";*/

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate" annotation (Dialog(group="Nominal condition"));

  parameter Modelica.SIunits.MassFlowRate m_flow_small(min=0) = 1E-4*abs(
    m_flow_nominal) "Small mass flow rate for regularization of zero flow"
    annotation (Dialog(tab="Advanced"));

  parameter Modelica.SIunits.Pressure dp_nominal(displayUnit="Pa")=
    dpStraightPipe_nominal "Pressure drop at nominal mass flow rate"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.SIunits.Height roughness=2.5e-5
    "Average height of surface asperities (default: smooth steel pipe)"
    annotation (Dialog(group="Geometry"));

  final parameter Modelica.SIunits.Pressure dpStraightPipe_nominal=
      Modelica.Fluid.Pipes.BaseClasses.WallFriction.Detailed.pressureLoss_m_flow(
      m_flow=m_flow_nominal,
      rho_a=rho_default,
      rho_b=rho_default,
      mu_a=mu_default,
      mu_b=mu_default,
      length=length,
      diameter=dh,
      roughness=roughness,
      m_flow_small=m_flow_small)
    "Pressure loss of a straight pipe at m_flow_nominal";

  Annex60.Fluid.FixedResistances.FixedResistance_dh res(
    redeclare final package Medium = Medium,
    final dh=dh,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=dp_nominal,
    from_dp=from_dp) "Pressure drop calculation for this pipe"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

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

  Annex60.Experimental.Pipe.PipeLosslessPlugFlow temperatureDelay(
    redeclare final package Medium = Medium,
    final m_flow_small=m_flow_small,
    final D=dh,
    final L=length,
    final allowFlowReversal=allowFlowReversal)
    "Model for temperature wave propagation with spatialDistribution operator"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
public
  Fluid.MixingVolumes.MixingVolume vol(
    nPorts=2,
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    V=Lcap*dh^2/4*Modelica.Constants.pi) if pipVol
    annotation (Placement(transformation(extent={{-60,0},{-80,20}})));
  Fluid.MixingVolumes.MixingVolume vol1(
    nPorts=2,
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    V=Lcap*dh^2/4*Modelica.Constants.pi) if pipVol
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  parameter Boolean from_dp=false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(tab="Advanced"));

equation
  connect(res.port_b, temperatureDelay.port_a) annotation (Line(
      points={{-20,0},{20,0}},
      color={0,127,255},
      smooth=Smooth.None));
  if pipVol then
    connect(port_a, vol.ports[1])
      annotation (Line(points={{-100,0},{-68,0},{-68,0}}, color={0,127,255}));
    connect(vol.ports[2], res.port_a)
      annotation (Line(points={{-72,0},{-72,0},{-40,0}}, color={0,127,255}));
    connect(temperatureDelay.port_b, vol1.ports[1])
      annotation (Line(points={{40,0},{68,0},{68,0}}, color={0,127,255}));
    connect(vol1.ports[2], port_b)
      annotation (Line(points={{72,0},{72,0},{100,0}}, color={0,127,255}));
  else
    connect(port_a, res.port_a)
      annotation (Line(points={{-100,0},{-70,0},{-40,0}}, color={0,127,255}));
    connect(temperatureDelay.port_b, port_b)
      annotation (Line(points={{40,0},{70,0},{100,0}}, color={0,127,255}));
  end if;

  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={
        Rectangle(
          extent={{-100,40},{100,-42}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{-100,30},{100,-28}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),
        Rectangle(
          extent={{-26,30},{30,-28}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={215,202,187})}),
    Documentation(revisions="<html>
<ul>
<li>July 4, 2016 by Bram van der Heijde:<br>Introduce <code><span style=\"font-family: Courier New,courier;\">pipVol</span></code>.</li>
<li>May 27, 2016 by Marcus Fuchs:<br>Introduce <code><span style=\"font-family: Courier New,courier;\">use_dh</span></code> and adjust <code><span style=\"font-family: Courier New,courier;\">dp_nominal</span></code>. </li>
<li>May 19, 2016 by Marcus Fuchs:<br>Add current issue and link to example in documentation.</li>
<li>April 2, 2016 by Bram van der Heijde:<br>Add volumes and pipe capacity at inlet and outlet of the pipe.</li>
<li>October 10, 2015 by Marcus Fuchs:<br>Copy Icon from KUL implementation and rename model. </li>
<li>June 23, 2015 by Marcus Fuchs:<br>First implementation. </li>
</ul>
</html>", info="<html>
<p>First implementation of an adiabatic pipe using the fixed resistance from Annex60 and the spatialDistribution operator for the temperature wave propagation through the length of the pipe. The temperature propagation is handled by the PipeLosslessPlugFlow component.</p>
<p>This component includes water volumes at the in- and outlet to account for the thermal capacity of the pipe walls. Logically, each volume should contain half of the pipe&apos;s real water volume. However, this leads to an overestimation, probably because only part of the pipe is affected by temperature changes (see Benonysson, 1991). The ratio of the pipe to be included in the thermal capacity is to be investigated further. </p>
</html>"));
end PipeAdiabaticPlugFlow;
