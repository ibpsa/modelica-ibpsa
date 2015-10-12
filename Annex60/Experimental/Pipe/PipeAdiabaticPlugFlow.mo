within Annex60.Experimental.Pipe;
model PipeAdiabaticPlugFlow
  "Pipe model using spatialDistribution for temperature delay without heat losses"
  extends Annex60.Fluid.Interfaces.PartialTwoPort;

  parameter Modelica.SIunits.Diameter diameter "Pipe diameter";
  parameter Modelica.SIunits.Length length "Pipe length";

  /*parameter Modelica.SIunits.ThermalConductivity k = 0.005 
    "Heat conductivity of pipe's surroundings";*/

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate"
  annotation(Dialog(group = "Nominal condition"));

  parameter Modelica.SIunits.MassFlowRate m_flow_small(min=0) = 1E-4*abs(m_flow_nominal)
    "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced"));

  parameter Modelica.SIunits.Height roughness=2.5e-5
    "Average height of surface asperities (default: smooth steel pipe)"
      annotation(Dialog(group="Geometry"));

  parameter Modelica.SIunits.Pressure dp_nominal(displayUnit="Pa")= 2*dpStraightPipe_nominal
    "Pressure drop at nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));

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

  // fixme: shouldn't dp(nominal) be around 100 Pa/m?
  // fixme: propagate use_dh and set default to false
  Annex60.Fluid.FixedResistances.FixedResistanceDpM res(
    redeclare final package Medium = Medium,
    use_dh=true,
    final dh=diameter,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=dp_nominal,
    dp(nominal=if Medium.nXi == 0 then 100*length else 5*length))
    "Pressure drop calculation for this pipe"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

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

  Annex60.Experimental.Pipe.PipeLosslessPlugFlow temperatureDelay(
    redeclare final package Medium = Medium,
    final m_flow_small=m_flow_small,
    final D=diameter,
    final L=length,
    final allowFlowReversal=allowFlowReversal)
    "Model for temperature wave propagation with spatialDistribution operator"
    annotation (Placement(transformation(extent={{26,-10},{46,10}})));
equation
  connect(port_a, res.port_a) annotation (Line(
      points={{-100,0},{-60,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res.port_b, temperatureDelay.port_a) annotation (Line(
      points={{-40,0},{26,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_b, temperatureDelay.port_b) annotation (Line(
      points={{100,0},{46,0}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
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
          lineColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder)}),
    Documentation(revisions="<html>
<ul>
<li>
October 10, 2015 by Marcus Fuchs:<br/>
Copy Icon from KUL implementation and rename model.
</li>
<li>
June 23, 2015 by Marcus Fuchs:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>First implementation of an adiabatic pipe using the fixed resistance from Annex60 and the spatialDistribution operator for the temperature wave propagation through the length of the pipe. </p>
</html>"));
end PipeAdiabaticPlugFlow;
