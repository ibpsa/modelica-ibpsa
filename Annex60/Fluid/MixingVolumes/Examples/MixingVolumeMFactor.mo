within Annex60.Fluid.MixingVolumes.Examples;
model MixingVolumeMFactor
  "A check for verifying the implementation of the parameter mFactor"
  import Annex60;
  extends Annex60.Fluid.MixingVolumes.Examples.MixingVolumeMassFlow(
  sou(X={0.02,0.98},
      T=Medium.T_default),
  vol(mFactor=10));
  Annex60.Fluid.MixingVolumes.MixingVolume volMFactor(
    redeclare package Medium = Medium,
    mFactor=10,
    m_flow_nominal=1,
    V=1,
    nPorts=2) "mixing volume using mFactor = 10"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Annex60.Fluid.MixingVolumes.MixingVolume vol1(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    V=10,
    nPorts=2) "MixingVolume with V = 10 instead of mFactor = 10"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  Annex60.Fluid.Sources.Boundary_pT bou1(
    redeclare package Medium = Medium,
    nPorts=2) "Sink"
              annotation (Placement(transformation(extent={{60,-70},{40,-50}})));
  Annex60.Fluid.Sources.MassFlowSource_T boundaryMFactor(
    redeclare package Medium = Medium,
    T=300,
    nPorts=1,
    m_flow=1,
    X={0.02,0.98}) "Flow source for mixing volume using mFactor"
              annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Annex60.Fluid.Sources.MassFlowSource_T boundary(
    redeclare package Medium = Medium,
    T=300,
    nPorts=1,
    m_flow=1,
    X={0.02,0.98}) "Flow source for mixing volume using larger volume"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
equation
  connect(vol1.ports[1], bou1.ports[1]) annotation (Line(
      points={{-12,-80},{40,-80},{40,-58}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volMFactor.ports[1], bou1.ports[2]) annotation (Line(
      points={{-12,-40},{40,-40},{40,-62}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(boundaryMFactor.ports[1],volMFactor. ports[2]) annotation (Line(
      points={{-60,-40},{-8,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(boundary.ports[1], vol1.ports[2]) annotation (Line(
      points={{-60,-80},{-8,-80}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Documentation(info="<html>
<p>This model contains two verifications for the implementation of mFactor:</p>
<p>1)  The mixingVolume temperature vol.T should be constant. 
This is to check the correct implementation of the parameter mFactor for moist air media.</p>
<p>2)  The temperature response of volMFactor.T and vol1.T should be (nearly) identical. 
Furthermore the response of the species concentration Xi demonstrates the 
difference between using an mFactor = 10 and multiplying the mixingVolume volume 
&QUOT;V&QUOT; by 10.</p>
</html>", revisions="<html>
<ul>
<li>
December, 2014 by Filip Jorissen:<br/>
Added temperature verification
</li>
<li>
November 25, 2014 by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"), __Dymola_Commands(file=
          "modelica://Annex60/Resources/Scripts/Dymola/Fluid/MixingVolumes/Examples/MixingVolumeMFactor.mos"
        "Simulate and plot"));
end MixingVolumeMFactor;
