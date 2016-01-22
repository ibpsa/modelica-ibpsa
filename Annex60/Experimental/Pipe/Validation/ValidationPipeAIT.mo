within Annex60.Experimental.Pipe.Validation;
model ValidationPipeAIT
  "Validation pipe against data from Austrian Institute of Technology"
extends Modelica.Icons.Example;

  Fluid.Sources.Boundary_pT      Point1(
    redeclare package Medium = Medium,
    nPorts=1,
    use_T_in=true)
              annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={88,-28})));
  package Medium = Annex60.Media.Water;
  Fluid.Sources.MassFlowSource_T Point4(
    nPorts=1,
    redeclare package Medium = Medium,
    use_m_flow_in=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={10,70})));
  Fluid.Sources.MassFlowSource_T Point3(
    nPorts=1,
    redeclare package Medium = Medium,
    use_m_flow_in=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-46,-50})));
  Fluid.Sources.MassFlowSource_T Point2(
    nPorts=1,
    redeclare package Medium = Medium,
    use_m_flow_in=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-70,70})));
  PipeHeatLoss_PipeDelayMod pip1(
    redeclare package Medium = Medium,
    length=135,
    m_flow_nominal=1,
    diameter=0.0825,
    thicknessIns=0.045,
    lambdaI=0.024,
    R=1/0.208 + 1/(2*2.4*Modelica.Constants.pi)*log(1/0.18))
    annotation (Placement(transformation(extent={{52,0},{32,20}})));
  PipeHeatLoss_PipeDelayMod pip4(
    redeclare package Medium = Medium,
    length=29,
    m_flow_nominal=1,
    diameter=0.0825,
    thicknessIns=0.045,
    lambdaI=0.024,
    R=1/0.208 + 1/(2*2.4*Modelica.Constants.pi)*log(1/0.18))
                       annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={10,40})));
  PipeHeatLoss_PipeDelayMod pip5(
    redeclare package Medium = Medium,
    length=20,
    m_flow_nominal=1,
    diameter=0.0825,
    lambdaI=0.024,
    thicknessIns=0.045,
    R=1/0.208 + 1/(2*2.4*Modelica.Constants.pi)*log(1/0.18))
    annotation (Placement(transformation(extent={{-2,0},{-22,20}})));
  PipeHeatLoss_PipeDelayMod pip2(
    redeclare package Medium = Medium,
    length=76,
    m_flow_nominal=1,
    diameter=0.0825,
    thicknessIns=0.045,
    lambdaI=0.024,
    R=1/0.208 + 1/(2*2.4*Modelica.Constants.pi)*log(1/0.18))
                       annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-70,40})));
  PipeHeatLoss_PipeDelayMod pip3(
    redeclare package Medium = Medium,
    length=38,
    m_flow_nominal=1,
    diameter=0.0825,
    thicknessIns=0.045,
    lambdaI=0.024,
    R=1/0.208 + 1/(2*2.4*Modelica.Constants.pi)*log(1/0.18))
                       annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-46,-10})));
  Modelica.Blocks.Sources.CombiTimeTable DataReader(table=pipeDataAIT151218.data)
    annotation (Placement(transformation(extent={{0,-100},{20,-80}})));
  Data.PipeDataAIT151218 pipeDataAIT151218
    annotation (Placement(transformation(extent={{-30,-100},{-10,-80}})));
  Modelica.Blocks.Sources.RealExpression m_flow_p3(y=-DataReader.y[6])
    annotation (Placement(transformation(extent={{-100,-80},{-60,-60}})));
  Modelica.Blocks.Sources.RealExpression m_flow_p4(y=-DataReader.y[7])
    annotation (Placement(transformation(extent={{64,80},{24,100}})));
  Modelica.Blocks.Sources.RealExpression m_flow_p2(y=-DataReader.y[5])
    annotation (Placement(transformation(extent={{-16,80},{-56,100}})));
  Modelica.Blocks.Sources.RealExpression T_p1(y=DataReader.y[1])
    annotation (Placement(transformation(extent={{20,-60},{60,-40}})));
  Fluid.Sensors.Temperature senTem_p3(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-90,-32},{-70,-12}})));
  Fluid.Sensors.Temperature senTem_p2(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-50,50},{-30,70}})));
  Fluid.Sensors.Temperature senTem_p4(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{30,56},{50,76}})));
  Fluid.Sensors.Temperature senTem_p1(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{64,-36},{44,-16}})));
  Modelica.Blocks.Math.UnitConversions.To_degC Tamb
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
equation
  connect(pip1.port_a, Point1.ports[1]) annotation (Line(
      points={{52,10},{88,10},{88,-18}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pip3.port_a, pip5.port_b) annotation (Line(
      points={{-46,0},{-46,10},{-22,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pip5.port_b, pip2.port_a) annotation (Line(
      points={{-22,10},{-70,10},{-70,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pip2.port_b, Point2.ports[1]) annotation (Line(
      points={{-70,50},{-70,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pip4.port_b, Point4.ports[1]) annotation (Line(
      points={{10,50},{10,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pip5.port_a, pip1.port_b) annotation (Line(
      points={{-2,10},{32,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pip4.port_a, pip1.port_b) annotation (Line(
      points={{10,30},{10,10},{32,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pip3.port_b, Point3.ports[1]) annotation (Line(
      points={{-46,-20},{-46,-40}},
      color={0,127,255},
      smooth=Smooth.None));
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
      points={{62,-50},{84,-50},{84,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senTem_p3.port, pip3.port_b) annotation (Line(
      points={{-80,-32},{-46,-32},{-46,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pip4.port_b, senTem_p4.port) annotation (Line(
      points={{10,50},{10,56},{40,56}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pip2.port_b, senTem_p2.port) annotation (Line(
      points={{-70,50},{-40,50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTem_p1.port, pip1.port_a) annotation (Line(
      points={{54,-36},{66,-36},{66,10},{52,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(DataReader.y[8], Tamb.u) annotation (Line(
      points={{21,-90},{38,-90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Tamb.y, pip1.T_amb) annotation (Line(
      points={{61,-90},{100,-90},{100,40},{42,40},{42,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Tamb.y, pip4.T_amb) annotation (Line(
      points={{61,-90},{100,-90},{100,40},{20,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Tamb.y, pip5.T_amb) annotation (Line(
      points={{61,-90},{100,-90},{100,26},{-12,26},{-12,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Tamb.y, pip3.T_amb) annotation (Line(
      points={{61,-90},{68,-90},{68,-74},{-28,-74},{-28,-10},{-36,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Tamb.y, pip2.T_amb) annotation (Line(
      points={{61,-90},{68,-90},{68,-74},{-28,-74},{-28,40},{-60,40}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    experiment(StopTime=603900),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>
The example contains <a href=\"modelica://Annex60.Experimental.Pipe.Data.PipeDatauAIT151218\">
experimental data</a> from a real district heating network. This data is used to validate a pipe model.</p>
<p>
Pipes' temperatures are not initialized, thus results of outflow temperature before apprixmately the first 10000 seconds should no be considered.
</p>

<p><b><span style=\"color: #008000;\">Test bench schematic</span></b> </p>
<p><img src=\"modelica://Annex60/Resources/Images/Experimental/AITTestBench.png\" border=\"1\"/></p>

<p><b><span style=\"color: #008000;\">Calibration</span></b> </p>
<p>
To calculate the length specific thermal resistance <code>R</code> of the pipe, the thermal resistance of the surrounding ground is added. </p>
<p>
<code>R=1/(0.208)+1/(2*lambda_g*Modelica.Constants.pi)*log(1/0.18)</code>  
</p>
<p>
Where the thermal conductivity of the ground <code>lambda_g = 2.4 </code> W/mK.
</p>


</html>", revisions="<html>
<ul>
<li>
Januar 19, 2016 by Carles Ribas:<br/>
First implementation.
</li>
</ul>
</html>"), __Dymola_Commands(file="modelica://Annex60/Resources/Scripts/Dymola/Experimental/Pipe/Validation/ValidationPipeAIT.mos"
        "Simulate and plot"));
end ValidationPipeAIT;
