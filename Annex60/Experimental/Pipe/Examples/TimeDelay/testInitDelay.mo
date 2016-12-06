within Annex60.Experimental.Pipe.Examples.TimeDelay;
model testInitDelay "Test of delay initialization"
  extends Modelica.Icons.Example;
  Fluid.Sources.MassFlowSource_T boundary(redeclare package Medium = Medium,
      m_flow=1,
    nPorts=1)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  replaceable package Medium = Annex60.Media.Water;
  Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-20,40},{0,20}})));
  BaseClasses.TimeDelay timeDelay(m_flowInit=1, initDelay=true)
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Fluid.Sources.Boundary_pT bou(nPorts=1, redeclare package Medium = Medium)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,30})));
equation
  connect(boundary.ports[1], senMasFlo.port_a)
    annotation (Line(points={{-40,30},{-20,30}}, color={0,127,255}));
  connect(senMasFlo.m_flow, timeDelay.m_flow) annotation (Line(points={{-10,19},
          {-10,19},{-10,-10},{-2,-10}}, color={0,0,127}));
  connect(senMasFlo.port_b, bou.ports[1])
    annotation (Line(points={{0,30},{60,30}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end testInitDelay;
