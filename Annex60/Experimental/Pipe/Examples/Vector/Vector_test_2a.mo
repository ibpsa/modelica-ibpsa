within Annex60.Experimental.Pipe.Examples.Vector;
model Vector_test_2a
  extends Modelica.Icons.Example;
  parameter Modelica.SIunits.Pressure dp_test=200
    "Differential pressure for the test used in ramps";

  package Medium = Annex60.Media.Water;

  Fluid.Sources.Boundary_pT sin1(
    redeclare package Medium = Medium,
    use_p_in=true,
    use_T_in=true,
    T=283.15,
    nPorts=2)
    "Sink at with constant pressure, turns into source at the end of experiment"
    annotation (Placement(transformation(extent={{270,-20},{250,0}})));
  Fluid.Sources.Boundary_pT sou1(
    redeclare package Medium = Medium,
    use_p_in=true,
    T=283.15,
    nPorts=1)
    "Sink at with constant pressure, turns into source at the end of experiment"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-84,0})));
  Modelica.Blocks.Sources.Step stepT(
    height=10,
    offset=273.15 + 20,
    startTime=200)
    "Step temperature increase to test propagation of temperature wave"
    annotation (Placement(transformation(extent={{284,74},{304,94}})));
  Modelica.Blocks.Sources.Constant PAtm(k=101325) "Atmospheric pressure"
    annotation (Placement(transformation(extent={{284,42},{304,62}})));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=0.5
    "Nominal mass flow rate, used for regularization near zero flow";
  Modelica.Blocks.Sources.Constant reverseP(k=-dp_test)
    "Atmospheric pressure"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature
                                   const3(T=293.15)
    annotation (Placement(transformation(extent={{-52,56},{-32,76}})));
  PipeHeatLossMod                      pipeHeatLoss_PipeDelayMod_voctorized(
    redeclare package Medium = Medium,
    diameter=0.1,
    length=100,
    m_flow_nominal=2,
    thicknessIns=0.1,
    nPorts=2)
    annotation (Placement(transformation(extent={{-62,-10},{-42,10}})));
  PipeHeatLossMod                      pipeHeatLoss_PipeDelayMod_voctorized1(
    redeclare package Medium = Medium,
    diameter=0.1,
    length=100,
    m_flow_nominal=2,
    thicknessIns=0.1,
    nPorts=1) annotation (Placement(transformation(extent={{-24,-6},{-8,8}})));
  PipeHeatLossMod                      pipeHeatLoss_PipeDelayMod_voctorized2(
    redeclare package Medium = Medium,
    diameter=0.1,
    length=100,
    m_flow_nominal=2,
    thicknessIns=0.1,
    nPorts=1)
    annotation (Placement(transformation(extent={{28,-40},{48,-20}})));
  PipeHeatLossMod                      pipeHeatLoss_PipeDelayMod_voctorized3(
    redeclare package Medium = Medium,
    diameter=0.1,
    length=100,
    m_flow_nominal=2,
    thicknessIns=0.1,
    nPorts=2) annotation (Placement(transformation(extent={{20,-4},{36,10}})));
  PipeHeatLossMod                      pipeHeatLoss_PipeDelayMod_voctorized4(
    redeclare package Medium = Medium,
    diameter=0.1,
    length=100,
    m_flow_nominal=2,
    thicknessIns=0.1,
    nPorts=1) annotation (Placement(transformation(extent={{62,-4},{78,10}})));
  PipeHeatLossMod                      pipeHeatLoss_PipeDelayMod_voctorized5(
    redeclare package Medium = Medium,
    diameter=0.1,
    length=100,
    m_flow_nominal=2,
    thicknessIns=0.1,
    nPorts=1)
    annotation (Placement(transformation(extent={{178,-2},{194,12}})));
  PipeHeatLossMod                      pipeHeatLoss_PipeDelayMod_voctorized6(
    redeclare package Medium = Medium,
    diameter=0.1,
    length=100,
    m_flow_nominal=2,
    thicknessIns=0.1,
    nPorts=1)
    annotation (Placement(transformation(extent={{136,-2},{152,12}})));
  PipeHeatLossMod                      pipeHeatLoss_PipeDelayMod_voctorized7(
    redeclare package Medium = Medium,
    diameter=0.1,
    length=100,
    m_flow_nominal=2,
    thicknessIns=0.1,
    nPorts=1)
    annotation (Placement(transformation(extent={{92,-4},{108,10}})));
equation
  connect(stepT.y, sin1.T_in)
    annotation (Line(points={{305,84},{320,84},{320,-6},{272,-6}},
                                                             color={0,0,127}));
  connect(PAtm.y, sin1.p_in) annotation (Line(points={{305,52},{310,52},{314,
          52},{314,-2},{272,-2}},
                      color={0,0,127}));
  connect(reverseP.y, sou1.p_in) annotation (Line(points={{-79,50},{-56,50},{
          -56,26},{-96,26},{-96,8}}, color={0,0,127}));
  connect(sou1.ports[1], pipeHeatLoss_PipeDelayMod_voctorized.port_a)
    annotation (Line(points={{-74,0},{-62,0}},   color={0,127,255}));
  connect(pipeHeatLoss_PipeDelayMod_voctorized2.port_a,
    pipeHeatLoss_PipeDelayMod_voctorized.ports_b[1]) annotation (Line(points={{28,-30},
          {18,-30},{18,-2},{-42,-2}},                   color={0,127,255}));
  connect(pipeHeatLoss_PipeDelayMod_voctorized2.ports_b[1], sin1.ports[1])
    annotation (Line(points={{48,-30},{54,-30},{54,-8},{250,-8}},     color={
          0,127,255}));
  connect(pipeHeatLoss_PipeDelayMod_voctorized1.ports_b[1],
    pipeHeatLoss_PipeDelayMod_voctorized3.port_a) annotation (Line(points={{-8,1},{
          18,1},{18,3},{20,3}},                 color={0,127,255}));
  connect(pipeHeatLoss_PipeDelayMod_voctorized3.ports_b[1],
    pipeHeatLoss_PipeDelayMod_voctorized4.port_a) annotation (Line(points={{36,1.6},
          {58,1.6},{58,3},{62,3}},                color={0,127,255}));
  connect(pipeHeatLoss_PipeDelayMod_voctorized1.port_a,
    pipeHeatLoss_PipeDelayMod_voctorized.ports_b[2]) annotation (Line(points={{-24,1},
          {-33.24,1},{-33.24,2},{-42,2}},                   color={0,127,255}));
  connect(pipeHeatLoss_PipeDelayMod_voctorized4.ports_b[1],
    pipeHeatLoss_PipeDelayMod_voctorized7.port_a) annotation (Line(points={{78,3},{
          86,3},{86,3},{92,3}},                 color={0,127,255}));
  connect(pipeHeatLoss_PipeDelayMod_voctorized7.ports_b[1],
    pipeHeatLoss_PipeDelayMod_voctorized6.port_a) annotation (Line(points={{108,3},
          {122,3},{122,5},{136,5}},                 color={0,127,255}));
  connect(pipeHeatLoss_PipeDelayMod_voctorized6.ports_b[1],
    pipeHeatLoss_PipeDelayMod_voctorized5.port_a) annotation (Line(points={{152,5},
          {165,5},{165,5},{178,5}},                 color={0,127,255}));
  connect(pipeHeatLoss_PipeDelayMod_voctorized5.ports_b[1], sin1.ports[2])
    annotation (Line(points={{194,5},{221,5},{221,-12},{250,-12}},
        color={0,127,255}));
  connect(const3.port, pipeHeatLoss_PipeDelayMod_voctorized.heatPort)
    annotation (Line(points={{-32,66},{78,66},{78,20},{-52,20},{-52,10}}, color
        ={191,0,0}));
  connect(pipeHeatLoss_PipeDelayMod_voctorized1.heatPort,
    pipeHeatLoss_PipeDelayMod_voctorized.heatPort) annotation (Line(points={{
          -16,8},{-16,20},{-52,20},{-52,10}}, color={191,0,0}));
  connect(pipeHeatLoss_PipeDelayMod_voctorized3.heatPort,
    pipeHeatLoss_PipeDelayMod_voctorized.heatPort) annotation (Line(points={{28,
          10},{28,20},{-52,20},{-52,10}}, color={191,0,0}));
  connect(pipeHeatLoss_PipeDelayMod_voctorized5.heatPort,
    pipeHeatLoss_PipeDelayMod_voctorized.heatPort) annotation (Line(points={{
          186,12},{186,20},{-52,20},{-52,10}}, color={191,0,0}));
  connect(pipeHeatLoss_PipeDelayMod_voctorized4.heatPort,
    pipeHeatLoss_PipeDelayMod_voctorized.heatPort) annotation (Line(points={{70,
          10},{70,20},{-52,20},{-52,10}}, color={191,0,0}));
  connect(pipeHeatLoss_PipeDelayMod_voctorized7.heatPort,
    pipeHeatLoss_PipeDelayMod_voctorized.heatPort) annotation (Line(points={{
          100,10},{100,20},{-52,20},{-52,10}}, color={191,0,0}));
  connect(pipeHeatLoss_PipeDelayMod_voctorized6.heatPort,
    pipeHeatLoss_PipeDelayMod_voctorized.heatPort) annotation (Line(points={{
          144,12},{144,20},{-52,20},{-52,10}}, color={191,0,0}));
  connect(pipeHeatLoss_PipeDelayMod_voctorized2.heatPort,
    pipeHeatLoss_PipeDelayMod_voctorized.heatPort) annotation (Line(points={{38,
          -20},{38,20},{-52,20},{-52,10}}, color={191,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{280,100}})),
    experiment(StopTime=20000, __Dymola_NumberOfIntervals=5000),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>Test to check behaviour of the <code><span style=\"font-family: Courier New,courier;\">PipeAdiabaticPlugFlow</span></code> in reverse flow. The flow propagates from the outlet to the inlet and a temperature step is applied. </p>
</html>", revisions="<html>
<ul>
<li>February 16, 2016 by Bram van der Heijde:<br>Update description and revision history.</li>
<li><span style=\"font-family: MS Shell Dlg 2;\">June 23, 2015 by Marcus Fuchs:<br>First implementation. </span></li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-100,-100},{280,100}})),
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=true,
      OutputCPUtime=true,
      OutputFlatModelica=false));
end Vector_test_2a;
