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
    annotation (Placement(transformation(extent={{-52,-34},{-30,34}})));
  Fluid.MixingVolumes.MixingVolume vol(prescribedHeatFlowRate=false, redeclare
      package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    V=m_flow_nominal*tau/1.204,
    nPorts=1+nZones) "Mixing volume for the air coming for the zones"
    annotation (Placement(transformation(extent={{-76,20},{-56,40}})));
  Fluid.Sources.FixedBoundary sink(final nPorts=1, redeclare package Medium =
               Medium)
    annotation (Placement(transformation(extent={{26,10},{6,30}})));
  Fluid.Sources.Boundary_pT sou(
    final nPorts=1,
    redeclare package Medium = Medium,
    use_T_in=true) "Ambient air"
    annotation (Placement(transformation(extent={{14,-30},{-6,-10}})));
  Fluid.Movers.Pump pump_out[nZones](m_flow_nominal=n ./ 3600.*1.204,
      redeclare package Medium = Medium,
    useInput=true,
    filteredMassFlowRate=true)
    annotation (Placement(transformation(extent={{-64,-10},{-84,-30}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=sim.Te)
    annotation (Placement(transformation(extent={{46,-26},{26,-6}})));
  outer Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
  Modelica.Blocks.Sources.Pulse    m_flow_val[nZones](period=36000, amplitude=1)
    annotation (Placement(transformation(extent={{-40,-60},{-60,-40}})));
equation
  wattsLawPlug.P[1] = sum(n .* VZones/3600)*sysPres/fanEff/motEff;
  wattsLawPlug.Q[1] = 0;

  for i in 1:nZones loop
    connect(pump_out[i].port_a, hex.port_b2) annotation (Line(
        points={{-64,-20},{-58,-20},{-58,-20.4},{-52,-20.4}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(vol.ports[i+1],flowPort_In[i]);
  end for;

  connect(hex.port_b1, sink.ports[1]) annotation (Line(
      points={{-30,20.4},{-18,20.4},{-18,20},{6,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pump_out.port_b, flowPort_Out) annotation (Line(
      points={{-84,-20},{-100,-20}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(sou.ports[1], hex.port_a2) annotation (Line(
      points={{-6,-20},{-18,-20},{-18,-20.4},{-30,-20.4}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(realExpression.y, sou.T_in) annotation (Line(
      points={{25,-16},{16,-16}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(vol.ports[1], hex.port_a1) annotation (Line(
      points={{-66,20},{-64,20},{-64,20.4},{-52,20.4}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(m_flow_val.y, pump_out.m_flowSet) annotation (Line(
      points={{-61,-50},{-66,-50},{-66,-48},{-74,-48},{-74,-30.4}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end ConstantAirFlowRecup;
