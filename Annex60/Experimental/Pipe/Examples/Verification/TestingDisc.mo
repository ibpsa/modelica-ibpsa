within Annex60.Experimental.Pipe.Examples.Verification;
model TestingDisc

package Medium = Annex60.Media.Water;

  Modelica.Fluid.Pipes.DynamicPipe pipeMSL(
    nNodes=10,
    redeclare package Medium = Medium,
    diameter=0.1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    flowModel(
    m_flow_small =         1e-4),
    length=100,
    T_start=293.15) "Dynamic pipe from MSL for reference test"
    annotation (Placement(transformation(extent={{-10,-20},{10,0}})));
  Fluid.Sources.MassFlowSource_T
                            source(
    redeclare package Medium = Medium,
    nPorts=1,
    use_T_in=true,
    m_flow=1,
    T=323.15) "Source with high pressure during experiment"
    annotation (Placement(transformation(extent={{-48,-20},{-28,0}})));
  Fluid.Sources.FixedBoundary
                            source1(
    redeclare package Medium = Medium, nPorts=1)
              "Source with high pressure during experiment"
    annotation (Placement(transformation(extent={{82,-20},{62,0}})));
  Fluid.Sources.MassFlowSource_T
                            source2(
    redeclare package Medium = Medium,
    nPorts=1,
    use_T_in=true,
    m_flow=1,
    T=323.15) "Source with high pressure during experiment"
    annotation (Placement(transformation(extent={{-48,-60},{-28,-40}})));
  Fluid.Sources.FixedBoundary
                            source3(
    redeclare package Medium = Medium, nPorts=1)
              "Source with high pressure during experiment"
    annotation (Placement(transformation(extent={{80,-60},{60,-40}})));
  PipeHeatLossMod pipe(
  redeclare package Medium = Medium,
  from_dp=true,
    diameter=0.1,
    thicknessIns=0.001,
    m_flow_nominal=1,
    m_flow_small=0.001,
    roughness=0.000001,
    lambdaI=0.1,
    length=100,
    dp_nominal=2000000)
  "Pipe model for district heating connection"
  annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));
  Modelica.Blocks.Sources.Ramp step_m_flow(
    startTime=1000,
    offset=293.15,
    height=10,
    duration=60) "Step temperature increase to test propagation of mass flow"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Fluid.Sensors.TemperatureTwoPort senTemMSL_n10(redeclare package Medium =
        Medium, m_flow_nominal=0.5)
    "Temperature of the inflow to the A60 temperature delay"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Fluid.Sensors.TemperatureTwoPort senTemA60(redeclare package Medium = Medium,
      m_flow_nominal=0.5)
    "Temperature of the inflow to the A60 temperature delay"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Modelica.Fluid.Pipes.DynamicPipe pipeMSL1(
    redeclare package Medium = Medium,
    diameter=0.1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    flowModel(
    m_flow_small =         1e-4),
    length=100,
    T_start=293.15,
    nNodes=100)     "Dynamic pipe from MSL for reference test"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  Fluid.Sources.MassFlowSource_T
                            source4(
    redeclare package Medium = Medium,
    nPorts=1,
    use_T_in=true,
    m_flow=1,
    T=323.15) "Source with high pressure during experiment"
    annotation (Placement(transformation(extent={{-48,20},{-28,40}})));
  Fluid.Sources.FixedBoundary
                            source5(
    redeclare package Medium = Medium, nPorts=1)
              "Source with high pressure during experiment"
    annotation (Placement(transformation(extent={{82,20},{62,40}})));
  Fluid.Sensors.TemperatureTwoPort senTemMSL_n100(redeclare package Medium =
        Medium, m_flow_nominal=0.5)
    "Temperature of the inflow to the A60 temperature delay"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Modelica.Fluid.Pipes.DynamicPipe pipeMSL2(
    redeclare package Medium = Medium,
    diameter=0.1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    flowModel(
    m_flow_small =         1e-4),
    nNodes=400,
    length=100,
    T_start=293.15) "Dynamic pipe from MSL for reference test"
    annotation (Placement(transformation(extent={{-10,60},{10,80}})));
  Fluid.Sources.MassFlowSource_T
                            source6(
    redeclare package Medium = Medium,
    nPorts=1,
    use_T_in=true,
    m_flow=1,
    T=323.15) "Source with high pressure during experiment"
    annotation (Placement(transformation(extent={{-48,60},{-28,80}})));
  Fluid.Sources.FixedBoundary
                            source7(
    redeclare package Medium = Medium, nPorts=1)
              "Source with high pressure during experiment"
    annotation (Placement(transformation(extent={{82,60},{62,80}})));
  Fluid.Sensors.TemperatureTwoPort senTemMSL_n400(redeclare package Medium =
        Medium, m_flow_nominal=0.5)
    "Temperature of the inflow to the A60 temperature delay"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
equation
  connect(source.ports[1], pipeMSL.port_a)
    annotation (Line(points={{-28,-10},{-28,-10},{-10,-10}},
                                                       color={0,127,255}));
  connect(source2.ports[1], pipe.port_a) annotation (Line(points={{-28,-50},{
          -28,-50},{-10,-50}}, color={0,127,255}));
  connect(step_m_flow.y, source.T_in) annotation (Line(points={{-79,10},{-68,10},
          {-68,-6},{-50,-6}}, color={0,0,127}));
  connect(step_m_flow.y, source2.T_in) annotation (Line(points={{-79,10},{-79,
          10},{-74,10},{-68,10},{-68,-46},{-58,-46},{-50,-46}}, color={0,0,127}));
  connect(pipeMSL.port_b, senTemMSL_n10.port_a)
    annotation (Line(points={{10,-10},{20,-10}}, color={0,127,255}));
  connect(senTemMSL_n10.port_b, source1.ports[1])
    annotation (Line(points={{40,-10},{40,-10},{62,-10}}, color={0,127,255}));
  connect(pipe.port_b, senTemA60.port_a)
    annotation (Line(points={{10,-50},{20,-50}}, color={0,127,255}));
  connect(senTemA60.port_b, source3.ports[1])
    annotation (Line(points={{40,-50},{40,-50},{60,-50}}, color={0,127,255}));
  connect(source4.ports[1], pipeMSL1.port_a)
    annotation (Line(points={{-28,30},{-28,30},{-10,30}}, color={0,127,255}));
  connect(pipeMSL1.port_b, senTemMSL_n100.port_a)
    annotation (Line(points={{10,30},{20,30}}, color={0,127,255}));
  connect(senTemMSL_n100.port_b, source5.ports[1])
    annotation (Line(points={{40,30},{40,30},{62,30}}, color={0,127,255}));
  connect(step_m_flow.y, source4.T_in) annotation (Line(points={{-79,10},{-68,
          10},{-68,34},{-50,34}}, color={0,0,127}));
  connect(source6.ports[1], pipeMSL2.port_a)
    annotation (Line(points={{-28,70},{-28,70},{-10,70}}, color={0,127,255}));
  connect(pipeMSL2.port_b, senTemMSL_n400.port_a)
    annotation (Line(points={{10,70},{20,70}}, color={0,127,255}));
  connect(senTemMSL_n400.port_b, source7.ports[1])
    annotation (Line(points={{40,70},{40,70},{62,70}}, color={0,127,255}));
  connect(step_m_flow.y, source6.T_in) annotation (Line(points={{-79,10},{-68,
          10},{-68,72},{-50,72},{-50,74}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end TestingDisc;
