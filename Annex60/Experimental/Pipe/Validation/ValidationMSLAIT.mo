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
        origin={40,88})));
  Fluid.Sources.MassFlowSource_T Point3(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-46,-70})));
  Fluid.Sources.MassFlowSource_T Point2(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-60,104})));
  Modelica.Blocks.Sources.CombiTimeTable DataReader(table=pipeDataAIT151218.data)
    annotation (Placement(transformation(extent={{0,-100},{20,-80}})));
  Data.PipeDataAIT151218 pipeDataAIT151218
    annotation (Placement(transformation(extent={{-30,-100},{-10,-80}})));
  Modelica.Blocks.Sources.RealExpression m_flow_p3(y=-DataReader.y[7])
    annotation (Placement(transformation(extent={{-100,-100},{-60,-80}})));
  Modelica.Blocks.Sources.RealExpression m_flow_p4(y=-DataReader.y[8])
    annotation (Placement(transformation(extent={{174,120},{134,140}})));
  Modelica.Blocks.Sources.RealExpression m_flow_p2(y=-DataReader.y[6])
    annotation (Placement(transformation(extent={{-100,120},{-60,140}})));
  Modelica.Blocks.Sources.RealExpression T_p1(y=DataReader.y[1])
    annotation (Placement(transformation(extent={{18,-74},{58,-54}})));
  Fluid.Sources.FixedBoundary ExcludedBranch(redeclare package Medium = Medium,
      nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={78,26})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));

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
    nNodes=20,
    redeclare model FlowModel =
        Modelica.Fluid.Pipes.BaseClasses.FlowModels.NominalTurbulentPipeFlow (
          dp_nominal(displayUnit="Pa") = 10*pip0.length, m_flow_nominal=0.3))
                       annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={80,-8})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  parameter Types.ThermalResistanceLength R=4.92141;
  parameter Types.ThermalResistanceLength R_old=1/(lambdaI*2*Modelica.Constants.pi/
      Modelica.Math.log((diameter/2 + thicknessIns)/(diameter/2)));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor res0(R=R/pip0.length)
    annotation (Placement(transformation(extent={{120,-18},{140,2}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector col0(m=pip0.nNodes)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={102,-8})));
  Modelica.Fluid.Pipes.DynamicPipe pip1(
    nParallel=1,
    diameter=0.0825,
    redeclare package Medium = Medium,
    use_HeatTransfer=true,
    redeclare model HeatTransfer =
        Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.IdealFlowHeatTransfer,
    length=115,
    nNodes=115,
    redeclare model FlowModel =
        Modelica.Fluid.Pipes.BaseClasses.FlowModels.NominalTurbulentPipeFlow (
          m_flow_nominal=0.3, dp_nominal=10*pip1.length))
                       annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={38,10})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector col1(m=pip1.nNodes)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={48,50})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor res1(R=R/pip1.length)
    annotation (Placement(transformation(extent={{66,40},{86,60}})));
  Modelica.Fluid.Pipes.DynamicPipe pip2(
    nParallel=1,
    redeclare package Medium = Medium,
    use_HeatTransfer=true,
    redeclare model HeatTransfer =
        Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.IdealFlowHeatTransfer,
    length=76,
    nNodes=76,
    diameter=0.0825,
    redeclare model FlowModel =
        Modelica.Fluid.Pipes.BaseClasses.FlowModels.NominalTurbulentPipeFlow (
          dp_nominal=10*pip2.length, m_flow_nominal=0.3))
                       annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-80,40})));
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
    nNodes=38,
    redeclare model FlowModel =
        Modelica.Fluid.Pipes.BaseClasses.FlowModels.NominalTurbulentPipeFlow (
          dp_nominal=10*pip3.length, m_flow_nominal=0.3))
                       annotation (Placement(transformation(
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
    nNodes=29,
    redeclare model FlowModel =
        Modelica.Fluid.Pipes.BaseClasses.FlowModels.NominalTurbulentPipeFlow (
          dp_nominal=10*pip4.length, m_flow_nominal=0.3))
                       annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={10,40})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector col4(m=pip4.nNodes)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-4,78})));
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
    nNodes=20,
    redeclare model FlowModel =
        Modelica.Fluid.Pipes.BaseClasses.FlowModels.NominalTurbulentPipeFlow (
          dp_nominal=10*pip5.length, m_flow_nominal=0.3))
                       annotation (Placement(transformation(
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
  parameter Modelica.SIunits.Diameter diameter=0.089
    "Outer diameter of pipe";
  Fluid.Sensors.TemperatureTwoPort
                            senTem_p2(redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    transferHeat=true,
    tauHeaTra=tauHeaTra)
    annotation (Placement(transformation(extent={{-78,60},{-58,80}})));
  Fluid.Sensors.TemperatureTwoPort
                            senTem_p3(redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    transferHeat=true,
    tauHeaTra=tauHeaTra)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-46,-38})));
  Fluid.Sensors.TemperatureTwoPort senTemIn_p2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    transferHeat=true,
    tauHeaTra=tauHeaTra)
    annotation (Placement(transformation(extent={{-60,0},{-80,20}})));
  Fluid.Sensors.TemperatureTwoPort
                            senTem_p1(redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    transferHeat=true,
    tauHeaTra=tauHeaTra)
    annotation (Placement(transformation(extent={{52,-42},{32,-22}})));
  Fluid.Sensors.TemperatureTwoPort
                            senTem_p4(redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    transferHeat=true,
    tauHeaTra=tauHeaTra)
    annotation (Placement(transformation(extent={{18,54},{38,74}})));

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate, used for regularization near zero flow";
  parameter Modelica.SIunits.Time tauHeaTra=6500
    "Time constant for heat transfer, default 20 minutes";

  Modelica.Blocks.Logical.Switch switch
    annotation (Placement(transformation(extent={{88,94},{68,114}})));
  Modelica.Blocks.Sources.RealExpression m_flow_zero(y=0)
    annotation (Placement(transformation(extent={{138,70},{98,90}})));
  Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold=-0.001)
    annotation (Placement(transformation(extent={{114,104},{108,110}})));
equation
  connect(m_flow_p3.y, Point3.m_flow_in) annotation (Line(
      points={{-58,-90},{-54,-90},{-54,-80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Point2.m_flow_in, m_flow_p2.y) annotation (Line(
      points={{-52,114},{-52,130},{-58,130}},
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
  connect(pip0.port_b, ExcludedBranch.ports[1])
    annotation (Line(points={{80,2},{80,16},{78,16}},
                                              color={0,127,255}));
  connect(prescribedTemperature.port, res0.port_b) annotation (Line(points={{60,-90},
          {60,-90},{146,-90},{146,-8},{140,-8}},        color={191,0,0}));
  connect(pip0.heatPorts, col0.port_a) annotation (Line(points={{84.4,-7.9},{92,
          -7.9},{92,-8}},  color={127,0,0}));
  connect(res0.port_a, col0.port_b)
    annotation (Line(points={{120,-8},{112,-8}},             color={191,0,0}));
  connect(col1.port_b, res1.port_a)
    annotation (Line(points={{58,50},{66,50}}, color={191,0,0}));
  connect(pip1.heatPorts, col1.port_a) annotation (Line(points={{37.9,14.4},{37.9,
          30.2},{38,30.2},{38,50}}, color={127,0,0}));
  connect(res1.port_b, res0.port_b) annotation (Line(points={{86,50},{146,50},{
          146,-8},{140,-8}},
                           color={191,0,0}));
  connect(col2.port_a, pip2.heatPorts) annotation (Line(points={{-60,34},{-75.6,
          34},{-75.6,40.1}}, color={191,0,0}));
  connect(col2.port_b, res2.port_a)
    annotation (Line(points={{-40,34},{-40,34}}, color={191,0,0}));
  connect(res2.port_b, res0.port_b) annotation (Line(points={{-20,34},{-16,34},
          {-16,124},{-12,124},{146,124},{146,-8},{140,-8}},  color={191,0,0}));
  connect(pip3.heatPorts, col3.port_a) annotation (Line(points={{-41.6,-12.1},{-40,
          -12.1},{-40,-12},{-38,-12}}, color={127,0,0}));
  connect(col3.port_b, res3.port_a)
    annotation (Line(points={{-18,-12},{-10,-12},{-10,-20}}, color={191,0,0}));
  connect(res3.port_b, res0.port_b) annotation (Line(points={{-10,-40},{-10,-54},
          {146,-54},{146,-8},{140,-8}},   color={191,0,0}));
  connect(col4.port_a, pip4.heatPorts)
    annotation (Line(points={{-4,68},{-4,40.1},{5.6,40.1}}, color={191,0,0}));
  connect(res4.port_a, col4.port_b)
    annotation (Line(points={{-4,94},{-4,92},{-4,88}},
                                               color={191,0,0}));
  connect(res4.port_b, res0.port_b) annotation (Line(points={{-4,114},{-4,124},
          {146,124},{146,-8},{140,-8}},  color={191,0,0}));
  connect(pip4.port_a, pip1.port_b)
    annotation (Line(points={{10,30},{10,10},{28,10}}, color={0,127,255}));
  connect(pip5.port_a, pip1.port_b)
    annotation (Line(points={{0,10},{28,10}}, color={0,127,255}));
  connect(col5.port_a, pip5.heatPorts) annotation (Line(points={{-36,110},{-36,110},
          {-36,64},{-12,64},{-12,14.4},{-10.1,14.4}}, color={191,0,0}));
  connect(col5.port_b, res5.port_a)
    annotation (Line(points={{-36,130},{-36,134},{-28,134}}, color={191,0,0}));
  connect(res5.port_b, res0.port_b) annotation (Line(points={{-8,134},{30,134},
          {30,124},{146,124},{146,-8},{140,-8}},  color={191,0,0}));
  connect(pip1.port_a, pip0.port_b) annotation (Line(points={{48,10},{62,10},{80,
          10},{80,2}}, color={0,127,255}));
  connect(pip2.port_b, senTem_p2.port_a)
    annotation (Line(points={{-80,50},{-80,70},{-78,70}}, color={0,127,255}));
  connect(senTem_p2.port_b, Point2.ports[1]) annotation (Line(points={{-58,70},{
          -58,82},{-58,94},{-60,94}}, color={0,127,255}));
  connect(senTem_p3.port_a, pip3.port_b) annotation (Line(points={{-46,-28},{-46,
          -28},{-46,-22}}, color={0,127,255}));
  connect(senTem_p3.port_b, Point3.ports[1]) annotation (Line(points={{-46,-48},
          {-46,-48},{-46,-58},{-46,-60}}, color={0,127,255}));
  connect(pip3.port_a, pip5.port_b) annotation (Line(points={{-46,-2},{-48,-2},{
          -48,8},{-48,10},{-20,10}}, color={0,127,255}));
  connect(senTemIn_p2.port_a, pip5.port_b)
    annotation (Line(points={{-60,10},{-20,10}}, color={0,127,255}));
  connect(senTemIn_p2.port_b, pip2.port_a)
    annotation (Line(points={{-80,10},{-80,24},{-80,30}}, color={0,127,255}));
  connect(pip4.port_b, senTem_p4.port_a) annotation (Line(points={{10,50},{10,50},
          {10,64},{18,64}}, color={0,127,255}));
  connect(senTem_p4.port_b, Point4.ports[1])
    annotation (Line(points={{38,64},{38,74},{38,78},{40,78}},
                                               color={0,127,255}));
  connect(senTem_p1.port_a, Point1.ports[1])
    annotation (Line(points={{52,-32},{82,-32}}, color={0,127,255}));
  connect(senTem_p1.port_b, pip0.port_a) annotation (Line(points={{32,-32},{32,-32},
          {32,-18},{80,-18}}, color={0,127,255}));
  connect(m_flow_zero.y,switch. u3)
    annotation (Line(points={{96,80},{96,96},{90,96}}, color={0,0,127}));
  connect(switch.u1, m_flow_p4.y) annotation (Line(points={{90,112},{114,112},{
          114,130},{132,130}}, color={0,0,127}));
  connect(Point4.m_flow_in, switch.y) annotation (Line(points={{48,98},{48,98},
          {48,104},{67,104}}, color={0,0,127}));
  connect(switch.u2, lessThreshold.y) annotation (Line(points={{90,104},{107.7,
          104},{107.7,107}}, color={255,0,255}));
  connect(lessThreshold.u, m_flow_p4.y) annotation (Line(points={{114.6,107},{
          130,107},{130,130},{132,130}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    experiment(StopTime=603900, Tolerance=1e-005),
    __Dymola_experimentSetupOutput(events=false),
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
<li>November 28, 2016 by Bram van der Heijde:<br>Remove <code>pipVol.</code></li>
<li>August 24, 2016 by Bram van der Heijde:<br>
Implement validation with MSL pipes for comparison, based on AIT validation.</li>
<li>July 4, 2016 by Bram van der Heijde:<br>Added parameters to test the influence of allowFlowReversal and the presence of explicit volumes in the pipe.</li>
<li>January 26, 2016 by Carles Ribas:<br>First implementation. </li>
</ul>
</html>"),
    __Dymola_Commands(file="modelica://Annex60/Resources/Scripts/Dymola/Experimental/Pipe/Validation/ValidationMSLAIT.mos"
    "Simulate and plot",
    file="modelica://Annex60/Resources/Scripts/Dymola/Experimental/Pipe/Validation/ExportValidationMSLAIT.mos"
    "Export csv file"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=true,
      OutputCPUtime=true,
      OutputFlatModelica=false));
end ValidationMSLAIT;
