within Annex60.Fluid.MixingVolumes.Examples;
model MixingVolumeMassFlow "Test model for mass flow into and out of volume"
  extends Modelica.Icons.Example;
 package Medium = Annex60.Media.Air;

  parameter Modelica.SIunits.Pressure dp_nominal = 10 "Nominal pressure drop";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 0.5
    "Nominal mass flow rate";

  Modelica.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    nPorts=1,
    use_m_flow_in=false,
    m_flow=m_flow_nominal,
    T=313.15) "Flow source and sink"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Sources.Boundary_pT bou(
    redeclare package Medium = Medium,
    nPorts=1,
    p=Medium.p_default - dp_nominal,
    T=303.15) "Boundary condition"                         annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,0})));
  Annex60.Fluid.MixingVolumes.MixingVolume vol(
    V=1,
    redeclare package Medium = Medium,
    nPorts=2,
    allowFlowReversal=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=m_flow_nominal)
              annotation (Placement(transformation(extent={{-20,0},{0,20}})));

  FixedResistances.FixedResistanceDpM res(
    redeclare package Medium = Medium,
    dp_nominal=dp_nominal,
    m_flow_nominal=m_flow_nominal)
    "Fixed resistance to separate the pressure state of the volume from the constant pressure of the sink"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
equation
  connect(sou.ports[1], vol.ports[1]) annotation (Line(
      points={{-40,6.66134e-16},{-26,6.66134e-16},{-26,-5.55112e-16},{-12,-5.55112e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res.port_a, vol.ports[2]) annotation (Line(
      points={{20,0},{-8,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res.port_b, bou.ports[1]) annotation (Line(
      points={{40,0},{60,0}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Documentation(
        info="<html>
<p>
This model demonstrates the use of the mixing volume with air flowing into and out of the volume.
</p>
</html>", revisions="<html>
<ul>
<li>
March 26, 2015 by Michael Wetter:<br/>
Added resistance between the volume and the pressure boundary
condition to avoid an overspecified by consistent initial value problem.
This caused a warning in Dymola 2015 FD01, and caused
in Dymola 2016 beta 2 to not translate the model.
</li>
<li>
October 12, 2009 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
 __Dymola_Commands(file="modelica://Annex60/Resources/Scripts/Dymola/Fluid/MixingVolumes/Examples/MixingVolumeMassFlow.mos"
        "Simulate and plot"),
    experiment(StopTime=10),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics));
end MixingVolumeMassFlow;
