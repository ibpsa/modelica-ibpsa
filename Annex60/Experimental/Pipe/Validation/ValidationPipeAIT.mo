within Annex60.Experimental.Pipe.Validation;
model ValidationPipeAIT
  "Validation pipe against data from Austrian Institute of Technology"
extends Modelica.Icons.Example;

  Fluid.Sources.MassFlowSource_T Point1(
    redeclare package Medium = Medium,
    use_T_in=true,
    use_m_flow_in=true,
    nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={82,-42})));
  package Medium = Annex60.Media.Water;
  Fluid.Sources.MassFlowSource_T Point4(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1)           annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={8,88})));
  Fluid.Sources.MassFlowSource_T Point3(
    nPorts=1,
    redeclare package Medium = Medium,
    use_m_flow_in=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-46,-58})));
  Fluid.Sources.MassFlowSource_T Point2(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1)           annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-88,82})));
  PipeHeatLossMod pip1(
    redeclare package Medium = Medium,
    diameter=0.0825,
    thicknessIns=0.045,
    lambdaI=0.024,
    length=115,
    allowFlowReversal=allowFlowReversal,
    nPorts=2,
    m_flow_nominal=0.3,
    R=1/(2*0.024*Modelica.Constants.pi)*log(0.18/0.0899) + 1/(2*2.4*Modelica.Constants.pi)
        *log(2/0.18),
    thickness=thickness)
    annotation (Placement(transformation(extent={{50,0},{30,20}})));
  PipeHeatLossMod pip4(
    redeclare package Medium = Medium,
    length=29,
    thicknessIns=0.045,
    lambdaI=0.024,
    allowFlowReversal=allowFlowReversal,
    m_flow_nominal=0.3,
    diameter(displayUnit="mm") = 0.0337 - 2*0.0032,
    R=1/(2*0.024*Modelica.Constants.pi)*log(0.07/0.0337) + 1/(2*2.4*Modelica.Constants.pi)
        *log(2/0.07),
    thickness=thickness,
    nPorts=2)                            annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={8,38})));
  PipeHeatLossMod pip5(
    redeclare package Medium = Medium,
    length=20,
    diameter=0.0825,
    lambdaI=0.024,
    thicknessIns=0.045,
    allowFlowReversal=allowFlowReversal,
    nPorts=2,
    m_flow_nominal=0.3,
    R=1/(2*0.024*Modelica.Constants.pi)*log(0.18/0.0899) + 1/(2*2.4*Modelica.Constants.pi)
        *log(2/0.18),
    thickness=thickness)
    annotation (Placement(transformation(extent={{0,0},{-20,20}})));
  PipeHeatLossMod pip2(
    redeclare package Medium = Medium,
    length=76,
    thicknessIns=0.045,
    lambdaI=0.024,
    allowFlowReversal=allowFlowReversal,
    nPorts=1,
    m_flow_nominal=0.3,
    thickness=thickness,
    diameter=0.0337 - 2*0.0032,
    R=1/(2*0.024*Modelica.Constants.pi)*log(0.07/0.0337) + 1/(2*2.4*Modelica.Constants.pi)
        *log(2/0.07))                    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-88,30})));
  PipeHeatLossMod pip3(
    redeclare package Medium = Medium,
    length=38,
    thicknessIns=0.045,
    lambdaI=0.024,
    allowFlowReversal=allowFlowReversal,
    nPorts=1,
    m_flow_nominal=0.3,
    thickness=thickness,
    R=1/(2*0.024*Modelica.Constants.pi)*log(0.07/0.0337) + 1/(2*2.4*Modelica.Constants.pi)
        *log(2/0.07),
    diameter=0.0337 - 2*0.0032)          annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-46,-4})));
  Modelica.Blocks.Sources.CombiTimeTable DataReader(table=pipeDataAIT151218.data)
    annotation (Placement(transformation(extent={{0,-100},{20,-80}})));
  Data.PipeDataAIT151218 pipeDataAIT151218
    annotation (Placement(transformation(extent={{-30,-100},{-10,-80}})));
  Modelica.Blocks.Sources.RealExpression m_flow_p3(y=-DataReader.y[7])
    annotation (Placement(transformation(extent={{-100,-80},{-60,-60}})));
  Modelica.Blocks.Sources.RealExpression m_flow_p4(y=-DataReader.y[8])
    annotation (Placement(transformation(extent={{128,110},{88,130}})));
  Modelica.Blocks.Sources.RealExpression m_flow_p2(y=-DataReader.y[6])
    annotation (Placement(transformation(extent={{-14,90},{-54,110}})));
  Modelica.Blocks.Sources.RealExpression T_p1(y=DataReader.y[1])
    annotation (Placement(transformation(extent={{18,-74},{58,-54}})));
  Fluid.Sensors.TemperatureTwoPort
                            senTem_p3(redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    transferHeat=true,
    tauHeaTra=tauHeaTra)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-46,-34})));
  Fluid.Sensors.TemperatureTwoPort
                            senTem_p2(redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    transferHeat=true,
    tauHeaTra=tauHeaTra)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-88,56})));
  Fluid.Sensors.TemperatureTwoPort
                            senTem_p4(redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    transferHeat=true,
    tauHeaTra=tauHeaTra)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={8,62})));
  Fluid.Sensors.TemperatureTwoPort
                            senTem_p1(redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    transferHeat=true,
    tauHeaTra=tauHeaTra)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={34,-22})));
  PipeHeatLossMod pip0(
    redeclare package Medium = Medium,
    diameter=0.0825,
    thicknessIns=0.045,
    lambdaI=0.024,
    length=20,
    allowFlowReversal=allowFlowReversal,
    nPorts=2,
    m_flow_nominal=0.3,
    R=1/(2*0.024*Modelica.Constants.pi)*log(0.18/0.0899) + 1/(2*2.4*Modelica.Constants.pi)
        *log(2/0.18),
    thickness=thickness)                 annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={80,-2})));
  Fluid.Sources.FixedBoundary ExcludedBranch(          redeclare package Medium =
        Medium, nPorts=1)
                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={80,70})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
  Fluid.Sensors.TemperatureTwoPort
                            senTemIn_p2(redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    transferHeat=true,
    tauHeaTra=tauHeaTra)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  parameter Modelica.SIunits.Length Lcap=1
    "Length over which transient effects typically take place";
  parameter Boolean pipVol=true
    "Flag to decide whether volumes are included at the end points of the pipe";
  parameter Boolean allowFlowReversal=true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate, used for regularization near zero flow";
  parameter Modelica.SIunits.Time tauHeaTra=6500
    "Time constant for heat transfer, default 20 minutes";
  Modelica.Blocks.Logical.Switch switch
    annotation (Placement(transformation(extent={{54,96},{34,116}})));
  Modelica.Blocks.Sources.RealExpression m_flow_zero(y=0)
    annotation (Placement(transformation(extent={{134,88},{94,108}})));
  Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold=-0.001)
    annotation (Placement(transformation(extent={{78,104},{72,110}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{130,40},{110,60}})));
  Fluid.Sources.MassFlowSource_T Point5(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1)           annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={46,56})));
  parameter Modelica.SIunits.Length thickness=0.0032 "Pipe wall thickness";
equation
  connect(m_flow_p3.y, Point3.m_flow_in) annotation (Line(
      points={{-58,-70},{-54,-70},{-54,-68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Point2.m_flow_in, m_flow_p2.y) annotation (Line(
      points={{-80,92},{-80,100},{-56,100}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T_p1.y, Point1.T_in) annotation (Line(
      points={{60,-64},{78,-64},{78,-54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(DataReader.y[5], Point1.m_flow_in) annotation (Line(
      points={{21,-90},{26,-90},{26,-72},{74,-72},{74,-52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(DataReader.y[9], prescribedTemperature.T)
    annotation (Line(points={{21,-90},{30,-90},{38,-90}}, color={0,0,127}));
  connect(pip4.heatPort, pip1.heatPort) annotation (Line(points={{18,38},{18,38},
          {40,38},{40,20}}, color={191,0,0}));
  connect(pip1.heatPort, pip0.heatPort) annotation (Line(points={{40,20},{40,26},
          {100,26},{100,-2},{90,-2}},   color={191,0,0}));
  connect(pip1.heatPort, pip2.heatPort) annotation (Line(points={{40,20},{40,26},
          {-54,26},{-54,30},{-78,30}}, color={191,0,0}));
  connect(pip5.heatPort, pip2.heatPort) annotation (Line(points={{-10,20},{-10,
          26},{-54,26},{-54,30},{-78,30}}, color={191,0,0}));
  connect(pip3.heatPort, pip2.heatPort) annotation (Line(points={{-36,-4},{-28,
          -4},{-28,26},{-54,26},{-54,30},{-78,30}},  color={191,0,0}));
  connect(prescribedTemperature.port, pip0.heatPort) annotation (Line(points={{60,-90},
          {100,-90},{100,-2},{90,-2}},           color={191,0,0}));
  connect(senTem_p2.port_b, Point2.ports[1]) annotation (Line(points={{-88,66},
          {-88,66},{-88,70},{-88,72}},                                    color=
         {0,127,255}));
  connect(Point3.ports[1], senTem_p3.port_b)
    annotation (Line(points={{-46,-48},{-46,-44}}, color={0,127,255}));
  connect(senTem_p4.port_b, Point4.ports[1]) annotation (Line(points={{8,72},{8,
          68},{8,78}},          color={0,127,255}));
  connect(Point1.ports[1], senTem_p1.port_b)
    annotation (Line(points={{82,-32},{82,-32},{34,-32}}, color={0,127,255}));
  connect(senTem_p1.port_a, pip0.port_a) annotation (Line(points={{34,-12},{70,
          -12},{80,-12}},              color={0,127,255}));
  connect(switch.u1, m_flow_p4.y) annotation (Line(points={{56,114},{72,114},{
          72,120},{86,120}},
                          color={0,0,127}));
  connect(m_flow_zero.y, switch.u3)
    annotation (Line(points={{92,98},{92,98},{56,98}}, color={0,0,127}));
  connect(switch.y, Point4.m_flow_in)
    annotation (Line(points={{33,106},{16,106},{16,98}},
                                                       color={0,0,127}));
  connect(switch.u2, lessThreshold.y)
    annotation (Line(points={{56,106},{71.7,106},{71.7,107}},
                                                           color={255,0,255}));
  connect(lessThreshold.u, m_flow_p4.y)
    annotation (Line(points={{78.6,107},{78.6,120},{86,120}},color={0,0,127}));
  connect(pip1.port_a, pip0.ports_b[1])
    annotation (Line(points={{50,10},{78,10},{78,8}}, color={0,127,255}));
  connect(pip1.ports_b[1], pip4.port_a)
    annotation (Line(points={{30,8},{8,8},{8,28}}, color={0,127,255}));
  connect(pip5.port_a, pip1.ports_b[2])
    annotation (Line(points={{0,10},{30,10},{30,12}}, color={0,127,255}));
  connect(pip4.ports_b[1], senTem_p4.port_a)
    annotation (Line(points={{6,48},{6,52},{8,52}}, color={0,127,255}));
  connect(Point5.ports[1], pip4.ports_b[2]) annotation (Line(points={{36,56},{
          26,56},{10,56},{10,48}}, color={0,127,255}));
  connect(pip5.ports_b[1], senTemIn_p2.port_b)
    annotation (Line(points={{-20,8},{-60,8},{-60,10}}, color={0,127,255}));
  connect(pip3.port_a, pip5.ports_b[2])
    annotation (Line(points={{-46,6},{-46,12},{-20,12}}, color={0,127,255}));
  connect(senTemIn_p2.port_a, pip2.port_a)
    annotation (Line(points={{-80,10},{-88,10},{-88,20}}, color={0,127,255}));
  connect(pip2.ports_b[1], senTem_p2.port_a)
    annotation (Line(points={{-88,40},{-88,43},{-88,46}}, color={0,127,255}));
  connect(pip3.ports_b[1], senTem_p3.port_a) annotation (Line(points={{-46,-14},
          {-46,-14},{-46,-24},{-46,-24}}, color={0,127,255}));
  connect(ExcludedBranch.ports[1], pip0.ports_b[2]) annotation (Line(points={{
          80,60},{82,60},{82,8},{82,8}}, color={0,127,255}));
  connect(switch1.y, Point5.m_flow_in) annotation (Line(points={{109,50},{84,50},
          {84,48},{56,48}}, color={0,0,127}));
  connect(m_flow_p4.y, switch1.u3) annotation (Line(points={{86,120},{86,120},{
          86,112},{86,88},{106,88},{144,88},{144,42},{132,42}}, color={0,0,127}));
  connect(m_flow_zero.y, switch1.u1) annotation (Line(points={{92,98},{94,98},{
          94,84},{94,80},{136,80},{136,58},{132,58}}, color={0,0,127}));
  connect(lessThreshold.y, switch1.u2) annotation (Line(points={{71.7,107},{66,
          107},{66,84},{140,84},{140,50},{132,50}}, color={255,0,255}));
  annotation (__Dymola_Commands(file=
          "Resources/Scripts/Dymola/Experimental/Pipe/Validation/ValidationPipeAIT.mos"
        "Simulate and Plot", file=
          "Resources/Scripts/Dymola/Experimental/Pipe/Validation/ExportValidationPipeAIT.mos"
        "Export CSV"));
end ValidationPipeAIT;
