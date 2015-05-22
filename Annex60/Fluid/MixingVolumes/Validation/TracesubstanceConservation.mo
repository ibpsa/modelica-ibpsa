within Annex60.Fluid.MixingVolumes.Validation;
model TracesubstanceConservation
  "This test checks if trace substance mass flow rates are conserved"
  extends Modelica.Icons.Example;
  constant String substanceName="CO2";
  package Medium = Annex60.Media.Air(extraPropertiesNames=fill(substanceName, 1));
  Annex60.Fluid.Sources.MassFlowSource_h source(
    redeclare package Medium = Medium,
    nPorts=1,
    m_flow=1,
    X={0.01,0.99},
    C=fill(0.001, Medium.nC)) "Air source with moisture and trace substances"
    annotation (Placement(transformation(extent={{-100,10},{-80,-10}})));

  Annex60.Fluid.MixingVolumes.MixingVolumeMoistAir vol1(
    redeclare package Medium = Medium,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=1,
    V=1,
    nPorts=2,
    allowFlowReversal=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Mixing volume for adding moisture"
              annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Modelica.Blocks.Sources.Constant Twat(k=273.15) "Water supply temperature"
    annotation (Placement(transformation(extent={{-80,9},{-70,19}})));
  Modelica.Blocks.Sources.Constant mWatFlo(k=0.001) "Water mass flow rate "
    annotation (Placement(transformation(extent={{-80,30},{-70,40}})));
  Annex60.Utilities.Diagnostics.AssertEquality assEquTra2(threShold=1E-10,
      message="Measured trace quantities are not equal")
    "Assert equality of trace substances"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
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
  Annex60.Fluid.Sources.Boundary_pT bou(redeclare package Medium = Medium,
      nPorts=1)
    annotation (Placement(transformation(extent={{100,-10},{80,10}})));
  Annex60.Utilities.Diagnostics.AssertEquality assEquTra1(threShold=1E-10,
      message="Measured trace quantity does not equal set point")
    "Assert equality of trace substances"
    annotation (Placement(transformation(extent={{40,-40},{60,-60}})));
  Modelica.Blocks.Sources.Constant const(k=source.m_flow*source.C[1])
    "Set point of trace substance concentration"
    annotation (Placement(transformation(extent={{8,-62},{20,-50}})));
equation
  connect(vol1.TWat, Twat.y) annotation (Line(
      points={{-22,14.8},{-68,14.8},{-68,14},{-69.5,14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mWatFlo.y, vol1.mWat_flow) annotation (Line(
      points={{-69.5,35},{-40,35},{-40,18},{-22,18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(source.ports[1], senTraSubIn.port_a) annotation (Line(
      points={{-80,0},{-60,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTraSubIn.port_b, vol1.ports[1]) annotation (Line(
      points={{-40,0},{-12,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol1.ports[2], senTraSubOut.port_a) annotation (Line(
      points={{-8,0},{20,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(bou.ports[1], senTraSubOut.port_b) annotation (Line(
      points={{80,0},{40,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(assEquTra2.u1, senTraSubOut.C) annotation (Line(
      points={{38,-24},{30,-24},{30,-11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(assEquTra2.u2, senTraSubIn.C) annotation (Line(
      points={{38,-36},{-50,-36},{-50,-11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(assEquTra1.u2, senTraSubIn.C) annotation (Line(
      points={{38,-44},{-50,-44},{-50,-11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.y, assEquTra1.u1) annotation (Line(
      points={{20.6,-56},{38,-56}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (                   Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics),
    experiment(Tolerance=1e-08),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>This test checks if the trace substance flow rate is conserved when adding moisture.</p>
</html>", revisions="<html>
<ul>
<li>
May 22 2015 by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
end TracesubstanceConservation;
