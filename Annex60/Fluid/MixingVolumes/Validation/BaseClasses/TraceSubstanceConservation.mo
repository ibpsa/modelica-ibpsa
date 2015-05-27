within Annex60.Fluid.MixingVolumes.Validation.BaseClasses;
model TraceSubstanceConservation
  "This test checks if trace substance mass flow rates are conserved"
  extends Modelica.Icons.Example;
  constant String substanceName="CO2";
  package Medium = Annex60.Media.Air(extraPropertiesNames=fill(substanceName, 1));
  Annex60.Fluid.Sources.MassFlowSource_h sou(
    redeclare package Medium = Medium,
    nPorts=1,
    m_flow=1,
    X={0.01,0.99},
    C=fill(0.001, Medium.nC)) "Air source with moisture and trace substances"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));

  Annex60.Fluid.MixingVolumes.MixingVolumeMoistAir vol(
    redeclare package Medium = Medium,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=1,
    V=1,
    nPorts=2,
    allowFlowReversal=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Mixing volume for adding moisture"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Modelica.Blocks.Sources.Constant TWat(k=273.15) "Water supply temperature"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Sources.Constant mWatFlo(k=0.001) "Water mass flow rate "
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Annex60.Fluid.Sensors.TraceSubstancesTwoPort senTraSubIn(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    tau=0,
    allowFlowReversal=false,
    substanceName=substanceName) "Measured inlet trace substances"
    annotation (Placement(transformation(extent={{-60,10},{-40,-10}})));
  Annex60.Fluid.Sensors.TraceSubstancesTwoPort senTraSubOut(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    tau=0,
    allowFlowReversal=false,
    substanceName=substanceName) "Measured outlet trace substances"
    annotation (Placement(transformation(extent={{20,10},{40,-10}})));
  Annex60.Fluid.Sources.Boundary_pT sin(redeclare package Medium = Medium,
      nPorts=1) "Air sink"
    annotation (Placement(transformation(extent={{100,-10},{80,10}})));
equation
  connect(vol.TWat, TWat.y) annotation (Line(
      points={{-22,14.8},{-40,14.8},{-40,30},{-59,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mWatFlo.y, vol.mWat_flow) annotation (Line(
      points={{-59,70},{-30,70},{-30,18},{-22,18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou.ports[1], senTraSubIn.port_a) annotation (Line(
      points={{-80,0},{-60,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTraSubIn.port_b, vol.ports[1]) annotation (Line(
      points={{-40,0},{-12,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol.ports[2], senTraSubOut.port_a) annotation (Line(
      points={{-8,0},{20,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin.ports[1], senTraSubOut.port_b) annotation (Line(
      points={{80,0},{40,0}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (                   Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics),
    experiment(Tolerance=1e-08),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>
This model is reconfigured to a steady state or 
dynamic check for conservation of trace substances.
</p>
</html>", revisions="<html>
<ul>
<li>
May 22 2015 by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
end TraceSubstanceConservation;
