within Annex60.Experimental.Pipe;
model PipeHeatLoss
  "Pipe model using spatialDistribution for temperature delay with heat losses"
  extends Annex60.Fluid.Interfaces.PartialTwoPort;

  output Modelica.SIunits.HeatFlowRate heat_losses "Heat losses in this pipe";

  parameter Modelica.SIunits.Diameter diameter "Pipe diameter";
  parameter Modelica.SIunits.Length length "Pipe length";
  parameter Modelica.SIunits.Length thicknessIns "Thickness of pipe insulation";

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

  parameter Real thermTransmissionCoeff(unit="W/(m2/K)")
    "Thermal transmission coefficient between pipe medium and surrounding";

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

  Annex60.Experimental.Pipe.BaseClasses.TempDelaySD temperatureDelay(
    redeclare final package Medium = Medium,
    final m_flow_small=m_flow_small,
    final D=diameter,
    final L=length,
    final allowFlowReversal=allowFlowReversal)
    "Model for temperature wave propagation with spatialDistribution operator"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
public
  BaseClasses.HeatLoss heatLoss(
    redeclare package Medium = Medium,
    m_flow_small=m_flow_small,
    diameter=diameter,
    length=length,
    thicknessIns=thicknessIns,
    thermTransmissionCoeff=thermTransmissionCoeff)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-10,0})));
public
  BaseClasses.HeatLoss heatLoss1(
    redeclare package Medium = Medium,
    m_flow_small=m_flow_small,
    diameter=diameter,
    length=length,
    thicknessIns=thicknessIns,
    thermTransmissionCoeff=thermTransmissionCoeff)
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
equation
  heat_losses = actualStream(port_b.h_outflow) - actualStream(port_a.h_outflow);

  connect(port_a, res.port_a) annotation (Line(
      points={{-100,0},{-60,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res.port_b, heatLoss.port_b)
    annotation (Line(points={{-40,0},{-20,0}}, color={0,127,255}));
  connect(heatLoss.port_a, temperatureDelay.port_a)
    annotation (Line(points={{0,0},{20,0}}, color={0,127,255}));
  connect(temperatureDelay.port_b, heatLoss1.port_a)
    annotation (Line(points={{40,0},{60,0}}, color={0,127,255}));
  connect(heatLoss1.port_b, port_b)
    annotation (Line(points={{80,0},{100,0}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),                 Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
          Rectangle(
          extent={{-70,30},{-10,-30}},
          lineColor={238,46,47},
          fillPattern=FillPattern.Solid,
          fillColor={238,46,47}),
                                Rectangle(
          extent={{12,30},{72,-30}},
          lineColor={238,46,47},
          fillPattern=FillPattern.Solid,
          fillColor={238,46,47}),
        Text(
          extent={{-62,24},{-20,-22}},
          lineColor={255,255,255},
          lineThickness=0.5,
          textString="dp"),
        Text(
          extent={{22,24},{64,-22}},
          lineColor={255,255,255},
          lineThickness=0.5,
          textString="dt"),               Polygon(
          points={{0,98},{40,60},{20,60},{20,36},{-20,36},{-20,60},{-40,60},{0,98}},
          lineColor={0,0,0},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid)}),
    Documentation(revisions="<html>
<ul>
<li>
June 23, 2015 by Marcus Fuchs:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>First implementation of an adiabatic pipe using the fixed resistance from Annex60 and the spatialDistribution operator for the temperature wave propagation through the length of the pipe. </p>
</html>"));
end PipeHeatLoss;
