within Annex60.Experimental.Pipe.Examples.Vector;
model Vector_test_21a
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
    annotation (Placement(transformation(extent={{222,-20},{202,0}})));
  Fluid.Sources.Boundary_pT sou1(
    redeclare package Medium = Medium,
    use_p_in=true,
    T=283.15,
    nPorts=1)
    "Sink at with constant pressure, turns into source at the end of experiment"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-70,0})));
  Modelica.Blocks.Sources.Step stepT(
    height=10,
    offset=273.15 + 20,
    startTime=200)
    "Step temperature increase to test propagation of temperature wave"
    annotation (Placement(transformation(extent={{202,62},{222,82}})));
  Modelica.Blocks.Sources.Constant PAtm(k=101325) "Atmospheric pressure"
    annotation (Placement(transformation(extent={{202,30},{222,50}})));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=0.5
    "Nominal mass flow rate, used for regularization near zero flow";
  Modelica.Blocks.Sources.Constant reverseP(k=-dp_test)
    "Atmospheric pressure"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  PipeHeatLossMod           pipeHeatLoss_PipeDelayMod_voctorized(
    redeclare package Medium = Medium,
    diameter=0.1,
    length=100,
    m_flow_nominal=2,
    thicknessIns=0.1,
    nPorts=2)
    annotation (Placement(transformation(extent={{-28,-10},{-8,10}})));
  PipeHeatLossMod           pipeHeatLoss_PipeDelayMod_voctorized1(
    redeclare package Medium = Medium,
    diameter=0.1,
    length=100,
    m_flow_nominal=2,
    thicknessIns=0.1,
    nPorts=1)
    annotation (Placement(transformation(extent={{6,-28},{26,-8}})));
  PipeHeatLossMod           pipeHeatLoss_PipeDelayMod_voctorized2(
    redeclare package Medium = Medium,
    diameter=0.1,
    length=100,
    m_flow_nominal=2,
    thicknessIns=0.1,
    nPorts=1)
    annotation (Placement(transformation(extent={{10,12},{22,24}})));
  PipeHeatLossMod           pipeHeatLoss_PipeDelayMod_voctorized3(
    redeclare package Medium = Medium,
    diameter=0.1,
    length=100,
    m_flow_nominal=2,
    thicknessIns=0.1,
    nPorts=1)
    annotation (Placement(transformation(extent={{28,12},{40,24}})));
  PipeHeatLossMod           pipeHeatLoss_PipeDelayMod_voctorized4(
    redeclare package Medium = Medium,
    diameter=0.1,
    length=100,
    m_flow_nominal=2,
    thicknessIns=0.1,
    nPorts=1)
    annotation (Placement(transformation(extent={{44,12},{56,24}})));
  PipeHeatLossMod           pipeHeatLoss_PipeDelayMod_voctorized5(
    redeclare package Medium = Medium,
    diameter=0.1,
    length=100,
    m_flow_nominal=2,
    thicknessIns=0.1,
    nPorts=1)
    annotation (Placement(transformation(extent={{64,8},{76,20}})));
  PipeHeatLossMod           pipeHeatLoss_PipeDelayMod_voctorized6(
    redeclare package Medium = Medium,
    diameter=0.1,
    length=100,
    m_flow_nominal=2,
    thicknessIns=0.1,
    nPorts=1)
    annotation (Placement(transformation(extent={{82,8},{94,20}})));
  PipeHeatLossMod           pipeHeatLoss_PipeDelayMod_voctorized7(
    redeclare package Medium = Medium,
    diameter=0.1,
    length=100,
    m_flow_nominal=2,
    thicknessIns=0.1,
    nPorts=1)
    annotation (Placement(transformation(extent={{98,8},{110,20}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=
        293.15) annotation (Placement(transformation(extent={{0,60},{20,80}})));
equation
  connect(stepT.y, sin1.T_in)
    annotation (Line(points={{223,72},{270,72},{270,-6},{224,-6}},
                                                             color={0,0,127}));
  connect(PAtm.y, sin1.p_in) annotation (Line(points={{223,40},{223,36},{264,36},
          {264,-2},{224,-2}},
                      color={0,0,127}));
  connect(reverseP.y, sou1.p_in) annotation (Line(points={{-79,50},{-56,50},{
          -56,26},{-82,26},{-82,8}}, color={0,0,127}));
  connect(sou1.ports[1], pipeHeatLoss_PipeDelayMod_voctorized.port_a)
    annotation (Line(points={{-60,0},{-28,0}}, color={0,127,255}));
  connect(pipeHeatLoss_PipeDelayMod_voctorized.ports_b[1],
    pipeHeatLoss_PipeDelayMod_voctorized1.port_a) annotation (Line(points={{-8,
          -2},{-4,-2},{-4,-18},{6,-18}}, color={0,127,255}));
  connect(pipeHeatLoss_PipeDelayMod_voctorized.ports_b[2],
    pipeHeatLoss_PipeDelayMod_voctorized2.port_a) annotation (Line(points={{-8,
          2},{-2,2},{-2,18},{10,18}}, color={0,127,255}));
  connect(pipeHeatLoss_PipeDelayMod_voctorized2.ports_b[1],
    pipeHeatLoss_PipeDelayMod_voctorized3.port_a)
    annotation (Line(points={{22,18},{25,18},{28,18}}, color={0,127,255}));
  connect(pipeHeatLoss_PipeDelayMod_voctorized3.ports_b[1],
    pipeHeatLoss_PipeDelayMod_voctorized4.port_a)
    annotation (Line(points={{40,18},{42,18},{44,18}}, color={0,127,255}));
  connect(pipeHeatLoss_PipeDelayMod_voctorized4.ports_b[1],
    pipeHeatLoss_PipeDelayMod_voctorized5.port_a)
    annotation (Line(points={{56,18},{64,18},{64,14}}, color={0,127,255}));
  connect(pipeHeatLoss_PipeDelayMod_voctorized5.ports_b[1],
    pipeHeatLoss_PipeDelayMod_voctorized6.port_a)
    annotation (Line(points={{76,14},{79,14},{82,14}}, color={0,127,255}));
  connect(pipeHeatLoss_PipeDelayMod_voctorized6.ports_b[1],
    pipeHeatLoss_PipeDelayMod_voctorized7.port_a)
    annotation (Line(points={{94,14},{96,14},{98,14}}, color={0,127,255}));
  connect(pipeHeatLoss_PipeDelayMod_voctorized1.ports_b[1], sin1.ports[1])
    annotation (Line(points={{26,-18},{80,-18},{184,-18},{184,-8},{202,-8}},
        color={0,127,255}));
  connect(pipeHeatLoss_PipeDelayMod_voctorized7.ports_b[1], sin1.ports[2])
    annotation (Line(points={{110,14},{184,14},{184,-12},{202,-12}}, color={0,
          127,255}));
  connect(fixedTemperature.port, pipeHeatLoss_PipeDelayMod_voctorized4.heatPort)
    annotation (Line(points={{20,70},{50,70},{50,24}}, color={191,0,0}));
  connect(pipeHeatLoss_PipeDelayMod_voctorized.heatPort,
    pipeHeatLoss_PipeDelayMod_voctorized4.heatPort) annotation (Line(points={{
          -18,10},{-18,36},{50,36},{50,24}}, color={191,0,0}));
  connect(pipeHeatLoss_PipeDelayMod_voctorized2.heatPort,
    pipeHeatLoss_PipeDelayMod_voctorized4.heatPort) annotation (Line(points={{
          16,24},{16,36},{50,36},{50,24}}, color={191,0,0}));
  connect(pipeHeatLoss_PipeDelayMod_voctorized3.heatPort,
    pipeHeatLoss_PipeDelayMod_voctorized4.heatPort) annotation (Line(points={{
          34,24},{34,36},{50,36},{50,24}}, color={191,0,0}));
  connect(pipeHeatLoss_PipeDelayMod_voctorized7.heatPort,
    pipeHeatLoss_PipeDelayMod_voctorized4.heatPort) annotation (Line(points={{
          104,20},{104,36},{50,36},{50,24}}, color={191,0,0}));
  connect(pipeHeatLoss_PipeDelayMod_voctorized6.heatPort,
    pipeHeatLoss_PipeDelayMod_voctorized4.heatPort) annotation (Line(points={{
          88,20},{88,36},{50,36},{50,24}}, color={191,0,0}));
  connect(pipeHeatLoss_PipeDelayMod_voctorized5.heatPort,
    pipeHeatLoss_PipeDelayMod_voctorized4.heatPort) annotation (Line(points={{
          70,20},{70,36},{50,36},{50,24}}, color={191,0,0}));
  connect(pipeHeatLoss_PipeDelayMod_voctorized1.heatPort,
    pipeHeatLoss_PipeDelayMod_voctorized4.heatPort) annotation (Line(points={{
          16,-8},{16,6},{24,6},{24,36},{50,36},{50,24}}, color={191,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{300,100}})),
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
    Icon(coordinateSystem(extent={{-100,-100},{300,100}})),
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=true,
      OutputCPUtime=true,
      OutputFlatModelica=false));
end Vector_test_21a;
