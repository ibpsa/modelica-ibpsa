within Annex60.Experimental.Pipe.Validation;
model ValidationMSLAIT
  "Validation pipe against data from Austrian Institute of Technology with standard library components"
  extends Modelica.Icons.Example;

  /*TODO: change nNodes for pipes. For fair comparison, n should be adapted to 
  make the Courant number close to 1, but this is only possible for a narrow 
  range of mass flow rates, which is a sstrength of the new pipe model.*/
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
    nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={10,70})));
  Fluid.Sources.MassFlowSource_T Point3(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-46,-50})));
  Fluid.Sources.MassFlowSource_T Point2(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-70,70})));
  Modelica.Blocks.Sources.CombiTimeTable DataReader(table=pipeDataAIT151218.data)
    annotation (Placement(transformation(extent={{0,-100},{20,-80}})));
  Data.PipeDataAIT151218 pipeDataAIT151218
    annotation (Placement(transformation(extent={{-30,-100},{-10,-80}})));
  Modelica.Blocks.Sources.RealExpression m_flow_p3(y=-DataReader.y[7])
    annotation (Placement(transformation(extent={{-100,-80},{-60,-60}})));
  Modelica.Blocks.Sources.RealExpression m_flow_p4(y=-DataReader.y[8])
    annotation (Placement(transformation(extent={{64,80},{24,100}})));
  Modelica.Blocks.Sources.RealExpression m_flow_p2(y=-DataReader.y[6])
    annotation (Placement(transformation(extent={{-16,80},{-56,100}})));
  Modelica.Blocks.Sources.RealExpression T_p1(y=DataReader.y[1])
    annotation (Placement(transformation(extent={{18,-74},{58,-54}})));
  Fluid.Sensors.Temperature senTem_p3(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-70,-32},{-90,-12}})));
  Fluid.Sensors.Temperature senTem_p2(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-50,50},{-30,70}})));
  Fluid.Sensors.Temperature senTem_p4(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{30,56},{50,76}})));
  Fluid.Sensors.Temperature senTem_p1(redeclare package Medium = Medium)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={50,-20})));
  Fluid.Sources.FixedBoundary ExcludedBranch(redeclare package Medium = Medium,
      nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={80,70})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
  Fluid.Sensors.Temperature senTemIn_p2(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  parameter Modelica.SIunits.Length Lcap=1
    "Length over which transient effects typically take place";
  parameter Boolean pipVol=true
    "Flag to decide whether volumes are included at the end points of the pipe";
  parameter Boolean allowFlowReversal=false
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)";
  Modelica.Fluid.Pipes.DynamicPipe pip0(
    nParallel=1,
    diameter=0.0825,
    redeclare package Medium = Medium,
    use_HeatTransfer=true,
    length=20,
    redeclare model HeatTransfer =
        Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.IdealFlowHeatTransfer,
    nNodes=20)         annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={80,-10})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  parameter Types.ThermalResistanceLength R=1/(lambdaI*2*Modelica.Constants.pi/
      Modelica.Math.log((diameter/2 + thicknessIns)/(diameter/2)));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor res0(R=R/pip0.length)
    annotation (Placement(transformation(extent={{120,-20},{140,0}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector col0(m=pip0.nNodes)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={102,-10})));
  Modelica.Fluid.Pipes.DynamicPipe pip1(
    nParallel=1,
    diameter=0.0825,
    redeclare package Medium = Medium,
    use_HeatTransfer=true,
    redeclare model HeatTransfer =
        Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.IdealFlowHeatTransfer,
    length=115,
    nNodes=115)        annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={38,10})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector col1(m=pip1.nNodes)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={50,30})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor res1(R=R/pip1.length)
    annotation (Placement(transformation(extent={{68,20},{88,40}})));
  Modelica.Fluid.Pipes.DynamicPipe pip2(
    nParallel=1,
    redeclare package Medium = Medium,
    use_HeatTransfer=true,
    redeclare model HeatTransfer =
        Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.IdealFlowHeatTransfer,
    length=76,
    diameter=diameter,
    nNodes=76)         annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-70,40})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector col2(m=pip2.nNodes)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,34})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor res2(R=R/pip2.length)
    annotation (Placement(transformation(extent={{-40,24},{-20,44}})));
  Modelica.Fluid.Pipes.DynamicPipe pip3(
    nParallel=1,
    diameter=0.0825,
    redeclare package Medium = Medium,
    use_HeatTransfer=true,
    redeclare model HeatTransfer =
        Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.IdealFlowHeatTransfer,
    length=38,
    nNodes=38)         annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-46,-12})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector col3(m=pip3.nNodes)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-28,-12})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor res3(R=R/pip3.length)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-10,-30})));
  Modelica.Fluid.Pipes.DynamicPipe pip4(
    nParallel=1,
    diameter=0.0825,
    redeclare package Medium = Medium,
    use_HeatTransfer=true,
    redeclare model HeatTransfer =
        Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.IdealFlowHeatTransfer,
    length=29,
    nNodes=29)         annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={10,40})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector col4(m=pip4.nNodes)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-4,76})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor res4(R=R/pip4.length)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-4,104})));
  Modelica.Fluid.Pipes.DynamicPipe pip5(
    nParallel=1,
    diameter=0.0825,
    redeclare package Medium = Medium,
    use_HeatTransfer=true,
    redeclare model HeatTransfer =
        Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.IdealFlowHeatTransfer,
    length=20,
    nNodes=20)         annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-10,10})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector col5(m=pip5.nNodes)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-36,120})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor res5(R=R/pip5.length)
    annotation (Placement(transformation(extent={{-28,124},{-8,144}})));
  parameter Modelica.SIunits.ThermalConductivity lambdaI=0.024
    "Heat conductivity";
  parameter Modelica.SIunits.Length thicknessIns=0.045
    "Thickness of pipe insulation";
  parameter Modelica.SIunits.Diameter diameter=0.085
    "Diameter of circular pipe";
equation
  connect(m_flow_p3.y, Point3.m_flow_in) annotation (Line(
      points={{-58,-70},{-54,-70},{-54,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Point2.m_flow_in, m_flow_p2.y) annotation (Line(
      points={{-62,80},{-62,90},{-58,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Point4.m_flow_in, m_flow_p4.y) annotation (Line(
      points={{18,80},{18,90},{22,90}},
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
  connect(senTem_p1.port, pip0.port_a)
    annotation (Line(points={{60,-20},{70,-20},{80,-20}}, color={0,127,255}));
  connect(pip0.port_a, Point1.ports[1])
    annotation (Line(points={{80,-20},{80,-32},{82,-32}}, color={0,127,255}));
  connect(pip0.port_b, ExcludedBranch.ports[1])
    annotation (Line(points={{80,0},{80,60}}, color={0,127,255}));
  connect(prescribedTemperature.port, res0.port_b) annotation (Line(points={{60,
          -90},{60,-90},{146,-90},{146,-10},{140,-10}}, color={191,0,0}));
  connect(pip0.heatPorts, col0.port_a) annotation (Line(points={{84.4,-9.9},{92,
          -9.9},{92,-10}}, color={127,0,0}));
  connect(res0.port_a, col0.port_b)
    annotation (Line(points={{120,-10},{116,-10},{112,-10}}, color={191,0,0}));
  connect(col1.port_b, res1.port_a)
    annotation (Line(points={{60,30},{68,30}}, color={191,0,0}));
  connect(pip1.heatPorts, col1.port_a) annotation (Line(points={{37.9,14.4},{37.9,
          30.2},{40,30.2},{40,30}}, color={127,0,0}));
  connect(res1.port_b, res0.port_b) annotation (Line(points={{88,30},{146,30},{146,
          -10},{140,-10}}, color={191,0,0}));
  connect(senTem_p2.port, pip2.port_b)
    annotation (Line(points={{-40,50},{-70,50}}, color={0,127,255}));
  connect(pip2.port_b, Point2.ports[1])
    annotation (Line(points={{-70,50},{-70,60}}, color={0,127,255}));
  connect(senTemIn_p2.port, pip2.port_a) annotation (Line(points={{-90,10},{-84,
          10},{-70,10},{-70,30}}, color={0,127,255}));
  connect(col2.port_a, pip2.heatPorts) annotation (Line(points={{-60,34},{-65.6,
          34},{-65.6,40.1}}, color={191,0,0}));
  connect(col2.port_b, res2.port_a)
    annotation (Line(points={{-40,34},{-40,34}}, color={191,0,0}));
  connect(res2.port_b, res0.port_b) annotation (Line(points={{-20,34},{-16,34},{
          -16,124},{-12,124},{146,124},{146,-10},{140,-10}}, color={191,0,0}));
  connect(pip3.port_b, Point3.ports[1])
    annotation (Line(points={{-46,-22},{-46,-40}}, color={0,127,255}));
  connect(pip3.port_a, pip2.port_a) annotation (Line(points={{-46,-2},{-46,10},{
          -70,10},{-70,30}}, color={0,127,255}));
  connect(pip3.heatPorts, col3.port_a) annotation (Line(points={{-41.6,-12.1},{-40,
          -12.1},{-40,-12},{-38,-12}}, color={127,0,0}));
  connect(col3.port_b, res3.port_a)
    annotation (Line(points={{-18,-12},{-10,-12},{-10,-20}}, color={191,0,0}));
  connect(res3.port_b, res0.port_b) annotation (Line(points={{-10,-40},{-10,-54},
          {146,-54},{146,-10},{140,-10}}, color={191,0,0}));
  connect(Point4.ports[1], pip4.port_b)
    annotation (Line(points={{10,60},{10,55},{10,50}}, color={0,127,255}));
  connect(senTem_p4.port, pip4.port_b)
    annotation (Line(points={{40,56},{10,56},{10,50}}, color={0,127,255}));
  connect(col4.port_a, pip4.heatPorts)
    annotation (Line(points={{-4,66},{-4,40.1},{5.6,40.1}}, color={191,0,0}));
  connect(res4.port_a, col4.port_b)
    annotation (Line(points={{-4,94},{-4,86}}, color={191,0,0}));
  connect(res4.port_b, res0.port_b) annotation (Line(points={{-4,114},{-4,124},{
          146,124},{146,-10},{140,-10}}, color={191,0,0}));
  connect(pip4.port_a, pip1.port_b)
    annotation (Line(points={{10,30},{10,10},{28,10}}, color={0,127,255}));
  connect(pip5.port_a, pip1.port_b)
    annotation (Line(points={{0,10},{28,10}}, color={0,127,255}));
  connect(pip5.port_b, pip2.port_a)
    annotation (Line(points={{-20,10},{-70,10},{-70,30}}, color={0,127,255}));
  connect(col5.port_a, pip5.heatPorts) annotation (Line(points={{-36,110},{-36,110},
          {-36,64},{-12,64},{-12,14.4},{-10.1,14.4}}, color={191,0,0}));
  connect(col5.port_b, res5.port_a)
    annotation (Line(points={{-36,130},{-36,134},{-28,134}}, color={191,0,0}));
  connect(res5.port_b, res0.port_b) annotation (Line(points={{-8,134},{30,134},{
          30,124},{146,124},{146,-10},{140,-10}}, color={191,0,0}));
  connect(pip1.port_a, pip0.port_b) annotation (Line(points={{48,10},{62,10},{80,
          10},{80,0}}, color={0,127,255}));
  connect(senTem_p3.port, pip3.port_b) annotation (Line(points={{-80,-32},{-46,-32},
          {-46,-22}}, color={0,127,255}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    experiment(StopTime=603900),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>The example contains <a href=\"modelica://Annex60.Experimental.Pipe.Data.PipeDataAIT151218\">experimental data</a> from a real district heating network. This data is used to validate a pipe model in <a href=\"modelica://Annex60.Experimental.Pipe.Validation.ValidationPipeAIT\">ValidationPipeAIT</a>. This model compares its performance with the original Modelica Standard Library pipes.</p>
<p>Pipes&apos; temperatures are not initialized, thus results of outflow temperature before apprixmately the first 10000 seconds should no be considered. </p>
<p><b><span style=\"color: #008000;\">Test bench schematic</span></b> </p>
<p><img src=\"modelica://Annex60/Resources/Images/Experimental/AITTestBench.png\"/> </p>
<p><b><span style=\"color: #008000;\">Calibration</span></b> </p>
<p>To calculate the length specific thermal resistance <code><span style=\"font-family: Courier New,courier;\">R</span></code> of the pipe, the thermal resistance of the surrounding ground is added. </p>
<p><code><span style=\"font-family: Courier New,courier;\">R=1/(0.208)+1/(2*lambda_g*Modelica.Constants.pi)*log(1/0.18)</span></code> </p>
<p>Where the thermal conductivity of the ground <code><span style=\"font-family: Courier New,courier;\">lambda_g = 2.4 </span></code>W/mK. </p>
</html>", revisions="<html>
<ul>
<li>August 24, 2016 by Bram van der Heijde:<br>
Implement validation with MSL pipes for comparison, based on AIT validation.</li>
<li>July 4, 2016 by Bram van der Heijde:<br>Added parameters to test the influence of allowFlowReversal and the presence of explicit volumes in the pipe.</li>
<li>January 26, 2016 by Carles Ribas:<br>First implementation. </li>
</ul>
</html>"),
    __Dymola_Commands(file=
          "modelica://Annex60/Resources/Scripts/Dymola/Experimental/Pipe/Validation/ValidationMSLAIT.mos"
        "Simulate and plot"));
end ValidationMSLAIT;
