within Annex60.Fluid.MixingVolumes.Examples;
model MixingVolumeInitialization "Test model for mixing volume initialization"
  extends Modelica.Icons.Example;
 package Medium = Annex60.Media.Air;

  Annex60.Fluid.Sources.Boundary_pT sou1(redeclare package Medium =
        Medium,
    p=101330,
    T=293.15,
    nPorts=1)                                       annotation (Placement(
        transformation(extent={{-92,10},{-72,30}}, rotation=0)));
  Annex60.Fluid.Sources.Boundary_pT sin1(redeclare package Medium =
        Medium,
    p=101320,
    T=293.15,
    nPorts=1)                                       annotation (Placement(
        transformation(extent={{162,10},{142,30}}, rotation=0)));
  Modelica.Fluid.Pipes.StaticPipe pipe1(
    redeclare package Medium = Medium,
    length=1,
    diameter=0.25,
    flowModel(m_flow_nominal=2)) annotation (Placement(transformation(extent={{-30,10},
            {-10,30}},
          rotation=0)));
  Modelica.Fluid.Pipes.StaticPipe pipe2(
    redeclare package Medium = Medium,
    length=1,
    diameter=0.25,
    flowModel(m_flow_nominal=2)) annotation (Placement(transformation(extent={{80,10},
            {100,30}},
          rotation=0)));
  MixingVolumes.MixingVolume vol1(
    redeclare package Medium = Medium,
    V=0.1,
    m_flow_nominal=2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nPorts=2)
    annotation (Placement(transformation(extent={{20,28},{40,48}}, rotation=0)));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Interfaces.AdaptorModelicaFluid ada(redeclare package MediumAnnex60 = Medium)
    "Adaptor to Modelica Fluid connector"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Interfaces.AdaptorModelicaFluid ada1(redeclare package MediumAnnex60 = Medium)
    "Adaptor to Modelica Fluid connector"
    annotation (Placement(transformation(extent={{20,10},{0,30}})));
  Interfaces.AdaptorModelicaFluid ada2(redeclare package MediumAnnex60 = Medium)
    "Adaptor to Modelica Fluid connector"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Interfaces.AdaptorModelicaFluid ada3(redeclare package MediumAnnex60 = Medium)
    "Adaptor to Modelica Fluid connector"
    annotation (Placement(transformation(extent={{130,10},{110,30}})));
equation
  connect(sou1.ports[1], ada.portAnnex60) annotation (Line(
      points={{-72,20},{-60,20}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(ada.portMSL, pipe1.port_a) annotation (Line(
      points={{-40,20},{-30,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe1.port_b, ada1.portMSL) annotation (Line(
      points={{-10,20},{0,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(ada1.portAnnex60, vol1.ports[1]) annotation (Line(
      points={{20,20},{26,20},{26,26},{30,26}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(vol1.ports[2], ada2.portAnnex60) annotation (Line(
      points={{30,30},{34,30},{34,20},{40,20}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(ada2.portMSL, pipe2.port_a) annotation (Line(
      points={{60,20},{80,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipe2.port_b, ada3.portMSL) annotation (Line(
      points={{100,20},{110,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(ada3.portAnnex60, sin1.ports[1]) annotation (Line(
      points={{130,20},{136,20},{136,20},{142,20}},
      color={0,127,0},
      smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{180,100}}),      graphics),
experiment(StopTime=0.001),
__Dymola_Commands(file="modelica://Annex60/Resources/Scripts/Dymola/Fluid/MixingVolumes/Examples/MixingVolumeInitialization.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model tests the initialization of the mixing volume.
</p>
</html>", revisions="<html>
<ul>
<li>
January 23, 2014, by Michael Wetter:<br/>
Changed fluid port from using <code>h_outflow</code> to <code>T_outflow</code>.
</li>
<li>
October 24, 2013 by Michael Wetter:<br/>
Set <code>flowModel(m_flow_nominal=2)</code> in the pipe models to 
avoid a cyclic definition of
<code>pipe1.flowModel.m_flow_nominal</code>
and
<code>pipe2.flowModel.m_flow_nominal</code>.
</li>
<li>
October 12, 2009 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end MixingVolumeInitialization;
