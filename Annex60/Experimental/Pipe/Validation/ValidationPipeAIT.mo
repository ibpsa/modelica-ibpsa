within Annex60.Experimental.Pipe.Validation;
model ValidationPipeAIT
  "Validation pipe against data from Austrian Institute of Technology"
extends Modelica.Icons.Example;

  Fluid.Sources.Boundary_pT      Point1(
    redeclare package Medium = Medium,
    nPorts=2,
    use_T_in=true)
              annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={70,-30})));
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
    diameter=0.2,
    thicknessIns=0.1)
    annotation (Placement(transformation(extent={{52,0},{32,20}})));
  PipeHeatLoss_PipeDelayMod pip4(
    redeclare package Medium = Medium,
    length=29,
    m_flow_nominal=1,
    diameter=0.2,
    thicknessIns=0.01) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={10,40})));
  PipeHeatLoss_PipeDelayMod pip5(
    redeclare package Medium = Medium,
    length=20,
    m_flow_nominal=1,
    diameter=0.2,
    thicknessIns=0.01)
    annotation (Placement(transformation(extent={{-2,0},{-22,20}})));
  PipeHeatLoss_PipeDelayMod pip2(
    redeclare package Medium = Medium,
    length=76,
    m_flow_nominal=1,
    diameter=0.2,
    thicknessIns=0.01) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-70,40})));
  PipeHeatLoss_PipeDelayMod pip3(
    redeclare package Medium = Medium,
    length=38,
    m_flow_nominal=1,
    diameter=0.2,
    thicknessIns=0.01) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-46,-10})));
  Modelica.Blocks.Sources.CombiTimeTable TestDataReader(table=pipeDataAIT151218.data)
    annotation (Placement(transformation(extent={{0,-100},{20,-80}})));
  Data.PipeDataAIT151218 pipeDataAIT151218
    annotation (Placement(transformation(extent={{-30,-100},{-10,-80}})));
  Modelica.Blocks.Sources.RealExpression m_flow_p3(y=-TestDataReader.y[6])
    annotation (Placement(transformation(extent={{-100,-80},{-60,-60}})));
  Modelica.Blocks.Sources.RealExpression m_flow_p4(y=-TestDataReader.y[7])
    annotation (Placement(transformation(extent={{64,80},{24,100}})));
  Modelica.Blocks.Sources.RealExpression m_flow_p2(y=-TestDataReader.y[5])
    annotation (Placement(transformation(extent={{-16,80},{-56,100}})));
  Modelica.Blocks.Sources.RealExpression T_p1(y=TestDataReader.y[1])
    annotation (Placement(transformation(extent={{20,-60},{60,-40}})));
  Modelica.Blocks.Sources.Constant Tamb(k=10) "Ambient temperature in degrees"
    annotation (Placement(transformation(extent={{80,40},{60,60}})));
  Fluid.Sensors.Temperature senTem_p3(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-90,-32},{-70,-12}})));
  Fluid.Sensors.Temperature senTem_p2(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-50,50},{-30,70}})));
  Fluid.Sensors.Temperature senTem_p4(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{30,56},{50,76}})));
  Fluid.Sensors.Temperature senTem_p1(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{100,0},{80,20}})));
equation
  connect(pip1.port_a, Point1.ports[1]) annotation (Line(
      points={{52,10},{68,10},{68,-20}},
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
  connect(pip4.T_amb, Tamb.y) annotation (Line(
      points={{20,40},{34,40},{34,50},{59,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pip1.T_amb, Tamb.y) annotation (Line(
      points={{42,20},{42,50},{59,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pip5.T_amb, Tamb.y) annotation (Line(
      points={{-12,20},{34,20},{34,50},{59,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pip2.T_amb, Tamb.y) annotation (Line(
      points={{-60,40},{-40,40},{-40,20},{34,20},{34,50},{59,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pip3.T_amb, Tamb.y) annotation (Line(
      points={{-56,-10},{-62,-10},{-62,20},{34,20},{34,50},{59,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T_p1.y, Point1.T_in) annotation (Line(
      points={{62,-50},{66,-50},{66,-42}},
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
      points={{90,0},{68,0},{68,10},{52,10}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    experiment(StopTime=603900),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>
The example contains experimental data from a real DHN. See <a href=\"modelica://Annex60.Experimental.Pipe.Data.PipeDatauAIT151218\">
experimental data</a> for more information. This data is used to validate a pipe model.</p>

<p><b><span style=\"color: #008000;\">Test bench schematic</span></b> </p>
<p><img src=\"modelica://Annex60/Resources/Images/Experimental/AITTestBench.png\" border=\"1\"/></p>

</html>", revisions="<html>
<ul>
<li>
Januar 19, 2016 by Carles Ribas:<br/>
First implementation.
</li>
</ul>
</html>"));
end ValidationPipeAIT;
