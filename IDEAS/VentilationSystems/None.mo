within IDEAS.VentilationSystems;
model None "None"

  extends IDEAS.Interfaces.BaseClasses.VentilationSystem(nLoads=1);

  Fluid.Sources.MassFlowSource_T boundary(redeclare package Medium =
        IDEAS.Media.Air,
    use_m_flow_in=true, final nPorts=nZones)
    annotation (Placement(transformation(extent={{-70,10},{-90,30}})));
  Fluid.Sources.FixedBoundary bou(redeclare package Medium =
        IDEAS.Media.Air, final nPorts=nZones)
    annotation (Placement(transformation(extent={{-70,-30},{-90,-10}})));
  Modelica.Blocks.Sources.Constant const(k=0)
    annotation (Placement(transformation(extent={{-30,18},{-50,38}})));
equation
  wattsLawPlug.P[1] = 0;
  wattsLawPlug.Q[1] = 0;

  for i in 1:nZones loop
    connect(flowPort_Out[i],boundary.ports[i]);
    connect(flowPort_In[i],bou.ports[i]);
  end for;

  connect(boundary.m_flow_in, const.y) annotation (Line(
      points={{-70,28},{-51,28}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end None;
