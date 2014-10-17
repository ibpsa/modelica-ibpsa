within IDEAS.VentilationSystems;
model ConstantAirFlowRecup
  "Ventilation System with constant airflow rate and recuperation efficiency"

  extends IDEAS.Interfaces.BaseClasses.VentilationSystem(nLoads=1);

  parameter Real[nZones] n(unit="m3/h")
    "Air change rate (Air changes per hour ACH)";
  final parameter Modelica.SIunits.MassFlowRate m_flow_nominal = sum(n) / 3600 * 1.204
    "total ventilation mass flow rate";
  parameter Modelica.SIunits.Time tau = 30
    "time constant of the ventilation system";

  parameter Modelica.SIunits.Efficiency recupEff(
    min=0,
    max=1) = 0.84 "Efficiency of heat recuperation";

  parameter Modelica.SIunits.Pressure sysPres=150
    "Total static and dynamic pressure drop, Pa";
  parameter Modelica.SIunits.Efficiency fanEff(
    min=0,
    max=1) = 0.85 "Fan efficiency";
  parameter Modelica.SIunits.Efficiency motEff(
    min=0,
    max=1) = 0.80 "Motor efficiency";

  Fluid.HeatExchangers.ConstantEffectiveness hex(
    m1_flow_nominal=m_flow_nominal,
    m2_flow_nominal=m_flow_nominal,
    dp1_nominal=0,
    dp2_nominal=0,
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    eps=recupEff) "Heat exchanger for the recuperator"
    annotation (Placement(transformation(extent={{-148,-34},{-126,34}})));
  Fluid.MixingVolumes.MixingVolume vol(prescribedHeatFlowRate=false, redeclare
      package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    V=m_flow_nominal*tau/1.204,
    nPorts=1+nZones) "Mixing volume for the air coming for the zones"
    annotation (Placement(transformation(extent={{-172,20},{-152,40}})));
  Fluid.Sources.FixedBoundary sink(final nPorts=1, redeclare package Medium =
               Medium)
    annotation (Placement(transformation(extent={{-70,10},{-90,30}})));
  Fluid.Sources.Boundary_pT sou(
    final nPorts=1,
    redeclare package Medium = Medium,
    use_T_in=true) "Ambient air"
    annotation (Placement(transformation(extent={{-82,-30},{-102,-10}})));
  Fluid.Movers.Pump pump[nZones](
    m_flow_nominal=n ./ 3600.*1.204,
    redeclare each package Medium = Medium)
    annotation (Placement(transformation(extent={{-160,-10},{-180,-30}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=sim.Te)
    annotation (Placement(transformation(extent={{-50,-26},{-70,-6}})));
  outer Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
equation
  P[1:nLoads_min] = sum(n .* VZones/3600)*sysPres/fanEff/motEff / nLoads_min .*ones(nLoads_min);
  Q[1:nLoads_min] = zeros(nLoads_min);

  for i in 1:nZones loop
    connect(pump[i].port_a, hex.port_b2) annotation (Line(
        points={{-160,-20},{-154,-20},{-154,-20.4},{-148,-20.4}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(vol.ports[i+1],flowPort_In[i]);
  end for;

  connect(hex.port_b1, sink.ports[1]) annotation (Line(
      points={{-126,20.4},{-114,20.4},{-114,20},{-90,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pump.port_b, flowPort_Out) annotation (Line(
      points={{-180,-20},{-200,-20}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(sou.ports[1], hex.port_a2) annotation (Line(
      points={{-102,-20},{-114,-20},{-114,-20.4},{-126,-20.4}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(realExpression.y, sou.T_in) annotation (Line(
      points={{-71,-16},{-80,-16}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(vol.ports[1], hex.port_a1) annotation (Line(
      points={{-162,20},{-160,20},{-160,20.4},{-148,20.4}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -100},{200,100}}), graphics), Icon(coordinateSystem(extent={{-200,
            -100},{200,100}})));
end ConstantAirFlowRecup;
