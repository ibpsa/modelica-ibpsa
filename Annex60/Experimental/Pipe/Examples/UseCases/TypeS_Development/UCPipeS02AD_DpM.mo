within Annex60.Experimental.Pipe.Examples.UseCases.TypeS_Development;
model UCPipeS02AD_DpM
  "Comparing mass flow rates and pressure drops between new pipe and MSL pipe"

  extends Modelica.Icons.Example;

  package Medium = Annex60.Media.Water;
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 0.9
    "Nominal mass flow rate";

  parameter Modelica.SIunits.Pressure dp_test = 795
    "Differential pressure for the test used in ramps";

  Modelica.Blocks.Sources.Constant PAtm(k=101325) "Atmospheric pressure"
      annotation (Placement(transformation(extent={{126,66},{146,86}})));
  Fluid.Sources.Boundary_pT sourceP(
    redeclare package Medium = Medium,
    use_p_in=true,
    use_T_in=true,
    T=293.15,
    nPorts=1) "Source with high pressure during experiment"
    annotation (Placement(transformation(extent={{-88,18},{-68,38}})));
  Fluid.Sources.Boundary_pT         sink(          redeclare package Medium =
        Medium,
    nPorts=1,
    use_p_in=true,
    T=283.15) "Sink at with constant pressure"
                          annotation (Placement(transformation(extent={{140,18},
            {120,38}})));
  Fluid.Sensors.MassFlowRate masFloP_MSL(redeclare package Medium = Medium)
    "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{88,20},{108,40}})));
  Modelica.Blocks.Sources.Constant constTemp(k=273.15 + 60)
    "Constant supply temperature signal"
    annotation (Placement(transformation(extent={{-118,0},{-98,20}})));
  Modelica.Blocks.Sources.Constant constDP(k=dp_test)
    "Add pressure difference between source and sink"
    annotation (Placement(transformation(extent={{-156,30},{-136,50}})));
  Modelica.Blocks.Math.Add add "Combine input signal of two ramps"
    annotation (Placement(transformation(extent={{-118,50},{-98,70}})));
  Modelica.Fluid.Pipes.DynamicPipe pipeMSL(
    nNodes=10,
    redeclare package Medium = Medium,
    length=100,
    diameter=0.1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    flowModel(
    m_flow_small =         1e-4),
    T_start=293.15) "Dynamic pipe from MSL for reference test"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  inner Modelica.Fluid.System system "System for MSL pipe model"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Fluid.Sensors.FlowVelocity senVelP(
    redeclare package Medium = Medium,
    crossSection=0.1*0.1/4*Modelica.Constants.pi,
    m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-30,20},{-10,40}})));
  Fluid.Sources.Boundary_pT         sink1(         redeclare package Medium =
        Medium,
    nPorts=1,
    use_p_in=true,
    T=283.15) "Sink at with constant pressure"
                          annotation (Placement(transformation(extent={{140,-22},
            {120,-2}})));
  Fluid.Sensors.MassFlowRate masFloM_MSL(redeclare package Medium = Medium)
    "Mass flow rate sensor "
    annotation (Placement(transformation(extent={{88,-20},{108,0}})));
  Modelica.Fluid.Pipes.DynamicPipe pipeMSL1(
    nNodes=10,
    redeclare package Medium = Medium,
    length=100,
    diameter=0.1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    flowModel(
    m_flow_small =         1e-4),
    T_start=293.15) "Dynamic pipe from MSL for reference test"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Fluid.Sensors.FlowVelocity senVelM(
    redeclare package Medium = Medium,
    crossSection=0.1*0.1/4*Modelica.Constants.pi,
    m_flow_nominal=m_flow_nominal) "Velocity Sensor"
    annotation (Placement(transformation(extent={{-30,-20},{-10,0}})));
  Fluid.Sources.MassFlowSource_T sourceM(
    redeclare package Medium = Medium,
    m_flow=2,
    T=333.15,
    nPorts=1) "Mass flow source"
    annotation (Placement(transformation(extent={{-88,-20},{-68,0}})));
equation
  connect(PAtm.y,sink. p_in)
                            annotation (Line(points={{147,76},{154,76},{154,36},
          {142,36}},
                   color={0,0,127}));
  connect(sink.ports[1], masFloP_MSL.port_b) annotation (Line(
      points={{120,28},{108,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(constTemp.y, sourceP.T_in) annotation (Line(
      points={{-97,10},{-90,10},{-90,32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(constDP.y, add.u2) annotation (Line(
      points={{-135,40},{-128,40},{-128,54},{-120,54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, sourceP.p_in) annotation (Line(
      points={{-97,60},{-94,60},{-94,36},{-90,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PAtm.y, add.u1) annotation (Line(points={{147,76},{154,76},{154,100},{
          -128,100},{-128,66},{-120,66}}, color={0,0,127}));
  connect(senVelP.port_b, pipeMSL.port_a)
    annotation (Line(points={{-10,30},{0,30}}, color={0,127,255}));
  connect(sink1.ports[1], masFloM_MSL.port_b) annotation (Line(
      points={{120,-12},{108,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senVelM.port_b, pipeMSL1.port_a)
    annotation (Line(points={{-10,-10},{0,-10}}, color={0,127,255}));
  connect(PAtm.y, sink1.p_in) annotation (Line(points={{147,76},{154,76},{154,
          -4},{142,-4}}, color={0,0,127}));
  connect(sourceP.ports[1], senVelP.port_a)
    annotation (Line(points={{-68,28},{-30,30}}, color={0,127,255}));
  connect(pipeMSL.port_b, masFloP_MSL.port_a)
    annotation (Line(points={{20,30},{88,30}}, color={0,127,255}));
  connect(masFloM_MSL.port_a, pipeMSL1.port_b)
    annotation (Line(points={{88,-10},{20,-10}}, color={0,127,255}));
  connect(senVelM.port_a, sourceM.ports[1])
    annotation (Line(points={{-30,-10},{-68,-10}}, color={0,127,255}));
  annotation (Documentation(info="<html>
<p>Currently, there seems to be a significant difference in the mass flow rate/
pressure drop calculations between the new pipe model and
<code>Modelica.Fluid.Pipes.DynamicPipe</code>. To solve this issue, this use
case compares both pipe models and tries to verify their pressure drop
calculations for given mass flow rates and vice versa. </p>
<h4 id=\"typical-use-and-important-parameters\">Typical use and important parameters</h4>
<p>The pressure difference between <code>source</code> and <code>sink</code> can be adjusted via the
<code>dp_test</code> variable.</p>

</ul>
</html>", revisions="<html>
<ul>
<li>May 23, 2016 by Marcus Fuchs: <br>
First implementation</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-180,-120},{180,120}},
          preserveAspectRatio=false)),
    Icon(coordinateSystem(extent={{-180,-120},{180,120}})),
    experiment(StopTime=2000, Interval=1),
    __Dymola_experimentSetupOutput);
end UCPipeS02AD_DpM;
