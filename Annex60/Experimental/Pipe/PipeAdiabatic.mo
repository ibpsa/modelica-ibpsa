within Annex60.Experimental.Pipe;
model PipeAdiabatic
  "Pipe model using spatialDistribution for temperature delay without heat losses"
  extends Annex60.Fluid.Interfaces.PartialTwoPort;

  parameter Modelica.SIunits.Diameter D = 0.1 "Pipe diameter in m";
  parameter Modelica.SIunits.Length L = 100 "Pipe length in m";

  /*parameter Modelica.SIunits.ThermalConductivity k = 0.005 
    "Heat conductivity of pipe's surroundings in W/(m*K)";*/

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate"
  annotation(Dialog(group = "Nominal condition"));

  final parameter Modelica.SIunits.Pressure dpStraightPipe_nominal=
      Modelica.Fluid.Pipes.BaseClasses.WallFriction.Detailed.pressureLoss_m_flow(
      m_flow=m_flow_nominal,
      rho_a=rho_nominal,
      rho_b=rho_nominal,
      mu_a=mu_nominal,
      mu_b=mu_nominal,
      length=L,
      diameter=D,
      roughness=roughness,
      m_flow_small=m_flow_small)
    "Pressure loss of a straight pipe at m_flow_nominal";

  Annex60.Fluid.FixedResistances.FixedResistanceDpM res(
    redeclare package Medium = Medium,
    use_dh=true,
    dh=D,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal,
    dp(nominal=10*L)) "Pressure drop calculation for this pipe"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  BaseClasses.TempDelaySD
                   temperatureDelay(redeclare package Medium = Medium,
      m_flow_small=1e-5,
    D=D,
    L=L)
    "Model for temperature wave propagation with spatialDistribution operator"
    annotation (Placement(transformation(extent={{26,-10},{46,10}})));

  parameter Modelica.SIunits.MassFlowRate m_flow_small(min=0) = 1E-4*abs(m_flow_nominal)
    "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced"));

  parameter Modelica.SIunits.Height roughness=2.5e-5
    "Average height of surface asperities (default: smooth steel pipe)"
      annotation(Dialog(group="Geometry"));

  parameter Modelica.SIunits.Pressure dp_nominal(displayUnit="Pa")= 2*dpStraightPipe_nominal
    "Pressure drop at nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));

protected
  parameter Medium.ThermodynamicState sta_default=
     Medium.setState_pTX(T=Medium.T_default, p=Medium.p_default, X=Medium.X_default);

 parameter Modelica.SIunits.Density rho_nominal = Medium.density_pTX(Medium.p_default, Medium.T_default, Medium.X_default)
    "Nominal density (e.g., rho_liquidWater = 995, rho_air = 1.2)"
    annotation(Dialog(group="Advanced", enable=use_rho_nominal));

 parameter Modelica.SIunits.DynamicViscosity mu_nominal = Medium.dynamicViscosity(
                                                 Medium.setState_pTX(
                                                     Medium.p_default, Medium.T_default, Medium.X_default))
    "Nominal dynamic viscosity (e.g., mu_liquidWater = 1e-3, mu_air = 1.8e-5)"
    annotation(Dialog(group="Advanced", enable=use_mu_nominal));

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
          extent={{-70,30},{-10,-30}},
          lineColor={0,0,255},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,255}), Rectangle(
          extent={{12,30},{72,-30}},
          lineColor={0,0,255},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,255}),
        Text(
          extent={{-62,24},{-20,-22}},
          lineColor={255,255,255},
          lineThickness=0.5,
          textString="dp"),
        Text(
          extent={{22,24},{64,-22}},
          lineColor={255,255,255},
          lineThickness=0.5,
          textString="dt")}));
end PipeAdiabatic;
