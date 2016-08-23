within Annex60.Experimental.Pipe.Examples.Comparisons;
model Precalculated_dp "Example to show use of the function dpPre"
  extends Modelica.Icons.Example;
  package Medium = Annex60.Media.Water;
  package MediumMSLpipe =
      Annex60.Media.Specialized.Water.TemperatureDependentDensity;

  //Parameter pipe
  parameter Modelica.SIunits.Length length = 100 "Pipe length";
  parameter Modelica.SIunits.Diameter d = 0.04
                                              "Pipe diameter";
  parameter Modelica.SIunits.MassFlowRate m_flow = 3 "Nominal mass flow rate";


  Fluid.Sources.MassFlowSource_T sou_T40(
    redeclare package Medium = Medium,
    nPorts=1,
    m_flow=m_flow)
    "Source with high pressure at beginning and lower pressure at end of experiment"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Fluid.Sources.Boundary_pT sink1(
    redeclare package Medium = Medium,
    use_p_in=false,
    nPorts=3,
    T=283.15)
    "Sink at with constant pressure, turns into source at the end of experiment"
    annotation (Placement(transformation(extent={{120,82},{100,102}})));
  Fluid.Sensors.Pressure P_pipe_T60_out(redeclare package Medium = Medium)
    "Pressure sensor"
    annotation (Placement(transformation(extent={{42,40},{22,60}})));
  Fluid.FixedResistances.FixedResistanceDpM pipeAdiabaticPlugFlow(redeclare
      package Medium = Medium,
    m_flow_nominal=m_flow,
    dp_nominal=Annex60.Experimental.Pipe.BaseClasses.dPpre(
        length,
        d,
        m_flow,
        273.15 + 60))
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Fluid.FixedResistances.FixedResistanceDpM pipeAdiabaticPlugFlow1(redeclare
      package Medium = Medium,
    m_flow_nominal=m_flow,
    dp_nominal=Annex60.Experimental.Pipe.BaseClasses.dPpre(
        length,
        d,
        m_flow,
        273.15 + 80))
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Fluid.FixedResistances.FixedResistanceDpM pipeAdiabaticPlugFlow2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow,
    dp_nominal=Annex60.Experimental.Pipe.BaseClasses.dPpre(
        length,
        d,
        m_flow,
        273.15 + 40))
    annotation (Placement(transformation(extent={{-20,80},{0,100}})));
  Modelica.Fluid.Pipes.DynamicPipe pipeAdiabaticPlugFlow3(redeclare package
      Medium = MediumMSLpipe,
    length=length,
    diameter=d,
    redeclare model FlowModel =
        Modelica.Fluid.Pipes.BaseClasses.FlowModels.DetailedPipeFlow,
    nNodes=10,
    T_start=273.15 + 10)
    annotation (Placement(transformation(extent={{-20,-100},{0,-80}})));
  Fluid.Sensors.Pressure P_pipe_T40_in(redeclare package Medium = Medium)
    "Pressure sensor"
    annotation (Placement(transformation(extent={{-50,100},{-30,120}})));
  Fluid.Sources.MassFlowSource_T sou_T60(
    redeclare package Medium = Medium,
    nPorts=1,
    m_flow=m_flow)
    "Source with high pressure at beginning and lower pressure at end of experiment"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Fluid.Sensors.Pressure                   P_pipe_T60_in(
                                                        redeclare package
      Medium = Medium) "Pressure sensor"
    annotation (Placement(transformation(extent={{-50,40},{-30,60}})));
  Fluid.Sensors.Pressure                   P_pipe_T80_in(
                                                        redeclare package
      Medium = Medium)
    "Pressure sensor"
    annotation (Placement(transformation(extent={{-50,-20},{-30,0}})));
  Fluid.Sensors.Pressure P_pipeMSL_in(redeclare package Medium = MediumMSLpipe)
    "Pressure sensor"
    annotation (Placement(transformation(extent={{-50,-80},{-30,-60}})));
  Fluid.Sources.MassFlowSource_T sou_T80(
    redeclare package Medium = Medium,
    nPorts=1,
    m_flow=m_flow)
    "Source with high pressure at beginning and lower pressure at end of experiment"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Fluid.Sources.MassFlowSource_T sou_MSL(
    nPorts=1,
    redeclare package Medium = MediumMSLpipe,
    use_T_in=true,
    m_flow=m_flow)
    "Source with high pressure at beginning and lower pressure at end of experiment"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  Fluid.Sensors.Pressure P_pipe_T40_out(redeclare package Medium = Medium)
    "Pressure sensor"
    annotation (Placement(transformation(extent={{40,100},{20,120}})));
  Fluid.Sensors.Pressure P_pipe_T80_out(redeclare package Medium = Medium)
    "Pressure sensor"
    annotation (Placement(transformation(extent={{40,-20},{20,0}})));
  Fluid.Sensors.Pressure                   P_pipeMSL_out(redeclare package
      Medium = MediumMSLpipe) "Pressure sensor"
    annotation (Placement(transformation(extent={{40,-80},{20,-60}})));
  Fluid.Sources.Boundary_pT sinkMSL(
    use_p_in=false,
    nPorts=1,
    redeclare package Medium = MediumMSLpipe,
    T=283.15)
    "Sink at with constant pressure, turns into source at the end of experiment"
    annotation (Placement(transformation(extent={{120,-100},{100,-80}})));
  Modelica.Blocks.Math.Feedback dp_MSL
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
  Modelica.Blocks.Math.Feedback dp_T80
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Modelica.Blocks.Math.Feedback dp_T60
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  Modelica.Blocks.Math.Feedback dp_T40
    annotation (Placement(transformation(extent={{-20,110},{0,130}})));
  Modelica.Blocks.Sources.Ramp ramp_T_MSL(
    duration=2000,
    offset=273.15 + 10,
    startTime=500,
    height=100)    annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));
  Fluid.Sensors.Temperature T_pipeMSL_out(redeclare package Medium =
        MediumMSLpipe)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{70,-80},{50,-60}})));
equation
  connect(sou_MSL.ports[1], pipeAdiabaticPlugFlow3.port_a)
    annotation (Line(points={{-60,-90},{-40,-90},{-20,-90}}, color={0,127,255}));
  connect(P_pipeMSL_in.port, pipeAdiabaticPlugFlow3.port_a) annotation (Line(
        points={{-40,-80},{-40,-80},{-40,-86},{-40,-90},{-20,-90}}, color={0,127,
          255}));
  connect(sou_T80.ports[1], pipeAdiabaticPlugFlow1.port_a)
    annotation (Line(points={{-60,-30},{-40,-30},{-20,-30}}, color={0,127,255}));
  connect(P_pipe_T80_in.port, pipeAdiabaticPlugFlow1.port_a) annotation (Line(
        points={{-40,-20},{-40,-30},{-20,-30}}, color={0,127,255}));
  connect(P_pipe_T60_in.port, pipeAdiabaticPlugFlow.port_a)
    annotation (Line(points={{-40,40},{-40,30},{-20,30}}, color={0,127,255}));
  connect(sou_T60.ports[1], pipeAdiabaticPlugFlow.port_a)
    annotation (Line(points={{-60,30},{-40,30},{-20,30}}, color={0,127,255}));
  connect(P_pipe_T40_in.port, pipeAdiabaticPlugFlow2.port_a)
    annotation (Line(points={{-40,100},{-40,90},{-20,90}}, color={0,127,255}));
  connect(sou_T40.ports[1], pipeAdiabaticPlugFlow2.port_a)
    annotation (Line(points={{-60,90},{-20,90}}, color={0,127,255}));
  connect(pipeAdiabaticPlugFlow.port_b, P_pipe_T60_out.port) annotation (Line(
        points={{0,30},{16,30},{32,30},{32,40}}, color={0,127,255}));
  connect(pipeAdiabaticPlugFlow2.port_b, P_pipe_T40_out.port) annotation (Line(
        points={{0,90},{16,90},{30,90},{30,100}}, color={0,127,255}));
  connect(pipeAdiabaticPlugFlow1.port_b, P_pipe_T80_out.port)
    annotation (Line(points={{0,-30},{30,-30},{30,-20}}, color={0,127,255}));
  connect(pipeAdiabaticPlugFlow3.port_b,P_pipeMSL_out. port) annotation (Line(
        points={{0,-90},{16,-90},{30,-90},{30,-80}}, color={0,127,255}));
  connect(pipeAdiabaticPlugFlow2.port_b, sink1.ports[1])
    annotation (Line(points={{0,90},{100,90},{100,94.6667}}, color={0,127,255}));
  connect(pipeAdiabaticPlugFlow.port_b, sink1.ports[2])
    annotation (Line(points={{0,30},{48,30},{100,30},{100,92}}, color={0,127,255}));
  connect(pipeAdiabaticPlugFlow1.port_b, sink1.ports[3]) annotation (Line(points={{0,-30},
          {50,-30},{100,-30},{100,89.3333}}, color={0,127,255}));
  connect(pipeAdiabaticPlugFlow3.port_b, sinkMSL.ports[1])
    annotation (Line(points={{0,-90},{100,-90}},          color={0,127,255}));
  connect(P_pipeMSL_in.p, dp_MSL.u1) annotation (Line(points={{-29,-70},{-24,-70},{-24,-60},
          {-18,-60}}, color={0,0,127}));
  connect(dp_MSL.u2, P_pipeMSL_out.p)
    annotation (Line(points={{-10,-68},{-10,-70},{19,-70}}, color={0,0,127}));
  connect(dp_T80.u2, P_pipe_T80_out.p)
    annotation (Line(points={{-10,-8},{-10,-10},{19,-10}}, color={0,0,127}));
  connect(P_pipe_T80_in.p, dp_T80.u1)
    annotation (Line(points={{-29,-10},{-24,-10},{-24,0},{-18,0}}, color={0,0,127}));
  connect(dp_T60.u2, P_pipe_T60_out.p)
    annotation (Line(points={{-10,52},{-10,52},{-10,50},{21,50}}, color={0,0,127}));
  connect(P_pipe_T60_in.p, dp_T60.u1)
    annotation (Line(points={{-29,50},{-24,50},{-24,60},{-18,60}}, color={0,0,127}));
  connect(dp_T40.u2, P_pipe_T40_out.p)
    annotation (Line(points={{-10,112},{-10,110},{19,110}}, color={0,0,127}));
  connect(P_pipe_T40_in.p, dp_T40.u1) annotation (Line(points={{-29,110},{-26,110},{-26,120},
          {-18,120}}, color={0,0,127}));
  connect(ramp_T_MSL.y, sou_MSL.T_in) annotation (Line(points={{-99,-70},{-92,-70},{-82,-70},
          {-82,-86}}, color={0,0,127}));
  connect(T_pipeMSL_out.port, pipeAdiabaticPlugFlow3.port_b)
    annotation (Line(points={{60,-80},{60,-90},{0,-90}}, color={0,127,255}));
  annotation (__Dymola_Commands(file="Resources/Scripts/Dymola/Experimental/Pipe/Examples/Comparisons/Precalculated_dp.mos"
        "Simulate and plot"),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},
            {120,120}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,120}})));
end Precalculated_dp;
