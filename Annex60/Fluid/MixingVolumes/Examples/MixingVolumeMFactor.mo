within Annex60.Fluid.MixingVolumes.Examples;
model MixingVolumeMFactor
  "A check for verifying the implementation of the parameter mSenFac"
  extends Annex60.Fluid.MixingVolumes.Examples.MixingVolumeMassFlow(
  sou(X={0.02,0.98},
      T=Medium.T_default),
  vol(mSenFac=10));
  Annex60.Fluid.MixingVolumes.MixingVolume volMFactor(
    redeclare package Medium = Medium,
    mSenFac=10,
    V=1,
    nPorts=2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=m_flow_nominal) "Mixing volume using mSenFac = 10"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Annex60.Fluid.MixingVolumes.MixingVolume vol1(
    redeclare package Medium = Medium,
    V=10,
    nPorts=2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=m_flow_nominal)
    "MixingVolume with V = 10 instead of mSenFac = 10"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Annex60.Fluid.Sources.Boundary_pT bou1(
    redeclare package Medium = Medium,
    p=Medium.p_default - dp_nominal,
    nPorts=2) "Sink"
              annotation (Placement(transformation(extent={{80,-70},{60,-50}})));
  Annex60.Fluid.Sources.MassFlowSource_T boundaryMFactor(
    redeclare package Medium = Medium,
    T=300,
    nPorts=1,
    m_flow=1,
    X={0.02,0.98}) "Flow source for mixing volume using mSenFac"
              annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Annex60.Fluid.Sources.MassFlowSource_T boundary(
    redeclare package Medium = Medium,
    T=300,
    nPorts=1,
    m_flow=1,
    X={0.02,0.98}) "Flow source for mixing volume using larger volume"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  FixedResistances.FixedResistanceDpM res1(
    redeclare package Medium = Medium,
    dp_nominal=dp_nominal,
    m_flow_nominal=m_flow_nominal)
    "Fixed resistance to separate the pressure state of the volume from the constant pressure of the sink"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  FixedResistances.FixedResistanceDpM res2(
    redeclare package Medium = Medium,
    dp_nominal=dp_nominal,
    m_flow_nominal=m_flow_nominal)
    "Fixed resistance to separate the pressure state of the volume from the constant pressure of the sink"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
equation
  connect(boundaryMFactor.ports[1],volMFactor. ports[1]) annotation (Line(
      points={{-40,-40},{-12,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(boundary.ports[1], vol1.ports[1]) annotation (Line(
      points={{-40,-80},{-12,-80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res1.port_a, volMFactor.ports[2]) annotation (Line(
      points={{20,-40},{-8,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res2.port_a, vol1.ports[2]) annotation (Line(
      points={{20,-80},{-8,-80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res1.port_b, bou1.ports[1]) annotation (Line(
      points={{40,-40},{50,-40},{50,-58},{60,-58}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res2.port_b, bou1.ports[2]) annotation (Line(
      points={{40,-80},{50,-80},{50,-62},{60,-62}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Documentation(info="<html>
<p>This model contains two verifications for the implementation of <code>mSenFac</code>:</p>
<ol>
<li>
The mixingVolume temperature <code>vol.T</code> should be constant. 
This is to check the correct implementation of the parameter <code>mSenFac</code> for moist air media.
</li>
<li>
The temperature response of <code>volMFactor.T</code> and <code>vol1.T</code> should be nearly identical.
Furthermore the response of the species concentration <code>Xi</code> demonstrates the 
difference between using an <code>mSenFac = 10</code> and multiplying volume by <i>10</i>.
</li>
</ol>
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
December, 2014 by Filip Jorissen:<br/>
Added temperature verification.
</li>
<li>
November 25, 2014 by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"), __Dymola_Commands(file=
          "modelica://Annex60/Resources/Scripts/Dymola/Fluid/MixingVolumes/Examples/MixingVolumeMFactor.mos"
        "Simulate and plot"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics));
end MixingVolumeMFactor;
