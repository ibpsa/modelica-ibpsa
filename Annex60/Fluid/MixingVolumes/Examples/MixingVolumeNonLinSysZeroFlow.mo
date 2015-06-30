within Annex60.Fluid.MixingVolumes.Examples;
model MixingVolumeNonLinSysZeroFlow
  "Mixing volume with a non-linear system around zero flow"
  extends Modelica.Icons.Example;
  package Medium = Annex60.Media.Water;
  Annex60.Fluid.MixingVolumes.MixingVolume vol(
    nPorts=2,
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    V=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=false,
    prescribedHeatFlowRate=true) "Steady state mixing volume"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
  Annex60.Fluid.Sources.MassFlowSource_T sou(
    nPorts=1,
    redeclare package Medium = Medium,
    use_m_flow_in=true) "Source"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Annex60.Fluid.Sources.Boundary_pT sin(nPorts=1, redeclare package Medium =
        Medium) "Sink"
    annotation (Placement(transformation(extent={{60,-10},{40,10}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=-1,
    duration=1,
    offset=1) "Mass flow rate ramp"
    annotation (Placement(transformation(extent={{-100,-2},{-80,18}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHea
    "Prescribed heat flow"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Modelica.Blocks.Sources.RealExpression reaExp(y=(290 - vol.heatPort.T)*10)
    "Thermal resistance equation"
    annotation (Placement(transformation(extent={{-100,36},{-58,64}})));
equation

    assert(abs(vol.heatPort.Q_flow)<Modelica.Constants.small or time<1, "Heat flow leakage around zero flow!");
  connect(sou.ports[1], vol.ports[1])
    annotation (Line(points={{-40,0},{-2,0}}, color={0,127,255}));
  connect(vol.ports[2],sin. ports[1])
    annotation (Line(points={{2,0},{2,0},{40,0}}, color={0,127,255}));
  connect(ramp.y, sou.m_flow_in)
    annotation (Line(points={{-79,8},{-60,8}}, color={0,0,127}));
  connect(preHea.port, vol.heatPort)
    annotation (Line(points={{-20,50},{-10,50},{-10,10}}, color={191,0,0}));
  connect(reaExp.y, preHea.Q_flow) annotation (Line(points={{-55.9,50},{-55.9,50},
          {-40,50}}, color={0,0,127}));
  annotation (                                                         Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    experiment(
      StopTime=2,
      __Dymola_fixedstepsize=20,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput,
    Documentation(revisions="<html>
<ul>
<li>
June 30, 2015 by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model verifies if energy is conserved around zero 
flow when the heat flow rate is calculated from a non-linear system.
</p>
</html>"));

end MixingVolumeNonLinSysZeroFlow;
