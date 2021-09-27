within IBPSA.Fluid.FixedResistances.Examples;
model MultiPlugFlowPipe
  extends Modelica.Icons.Example;
  replaceable package Medium = IBPSA.Media.Water "Medium in the pipe" annotation (
      choicesAllMatching=true);

  parameter Integer numPip=50 "Number of pipe object in series";
  final parameter Modelica.SIunits.MassFlowRate m_flow = 3 "Mass flow rate";

  parameter Real perHour=2 "Signal period in hours";


  Sources.MassFlowSource_T             sou(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    use_T_in=true,
    m_flow=m_flow,
    nPorts=1) "Flow source"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Sensors.TemperatureTwoPort             senTemIn(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow,
    tau=0,
    T_start=323.15) "Temperature sensor"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  replaceable IBPSA.Fluid.FixedResistances.PlugFlowPipe pip[numPip](
    redeclare each package Medium = Medium,
    each dh=0.1,
    each length=100,
    each dIns=0.05,
    each kIns=0.028,
    each m_flow_nominal=m_flow,
    each cPip=500,
    each thickness=0.0032,
    each initDelay=true,
    each m_flow_start=m_flow,
    each rhoPip=8000,
    each T_start_in=323.15,
    each T_start_out=323.15) "Pipe"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Sensors.TemperatureTwoPort             senTemOut(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow,
    tau=0,
    T_start=323.15) "Temperature sensor"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Sources.Boundary_pT sin1(
    redeclare package Medium = Medium,
    T=273.15 + 10,
    nPorts=1,
    p(displayUnit="Pa") = 101325) "Pressure boundary condition"
    annotation (Placement(transformation(extent={{100,-10},{80,10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature bou[numPip](each T=283.15)
    "Boundary temperature"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  IBPSA.Fluid.FixedResistances.Validation.PlugFlowPipes.Data.PipeDataAIT151218 pipeDataAIT151218 "Measurement data from AIT network"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Modelica.Blocks.Sources.CombiTimeTable DataReader(
    tableOnFile=true,
    tableName="dat",
    columns=2:pipeDataAIT151218.nCol,
    fileName=pipeDataAIT151218.filNam)
    "Read measurement data"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
equation
  connect(sou.ports[1], senTemIn.port_a)
    annotation (Line(points={{-40,0},{-30,0}}, color={0,127,255}));
  connect(senTemIn.port_b, pip[1].port_a)
    annotation (Line(points={{-10,0},{0,0}}, color={0,127,255}));
  for i in 2:numPip loop
    connect(pip[i-1].port_b, pip[i].port_a);
  end for;
  connect(pip[numPip].port_b, senTemOut.port_a)
    annotation (Line(points={{20,0},{40,0}}, color={0,127,255}));
  connect(senTemOut.port_b, sin1.ports[1])
    annotation (Line(points={{60,0},{80,0}}, color={0,127,255}));
  connect(bou.port, pip.heatPort)
    annotation (Line(points={{0,70},{10,70},{10,10}}, color={191,0,0}));
  connect(DataReader.y[1], sou.T_in) annotation (Line(points={{-79,0},{-68,0},{-68,
          4},{-62,4}}, color={0,0,127}));
  connect(DataReader.y[5], sou.m_flow_in) annotation (Line(points={{-79,0},{-68,
          0},{-68,14},{-62,14},{-62,8}}, color={0,0,127}));
  annotation (
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/FixedResistances/Examples/MultiPlugFlowPipe.mos"
        "Simulate and Plot"),
    experiment(
      StopTime=604800,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end MultiPlugFlowPipe;
