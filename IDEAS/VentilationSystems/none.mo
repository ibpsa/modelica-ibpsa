within IDEAS.VentilationSystems;
model None "No ventilation"
  extends IDEAS.Interfaces.BaseClasses.VentilationSystem(nLoads=0);

  Fluid.Sources.FixedBoundary sink[nZones](
                         each final nPorts=1, redeclare each package Medium = Medium)
    annotation (Placement(transformation(extent={{-156,-30},{-176,-10}})));
  Fluid.Sources.MassFlowSource_T sou[nZones](
    each use_m_flow_in=true,
    each final nPorts=1,
    redeclare each package Medium = Medium,
    each use_T_in=true) "Source"
    annotation (Placement(transformation(extent={{-154,10},{-174,30}})));
  Modelica.Blocks.Sources.Constant m_flow_val[nZones](each final k=0)
    annotation (Placement(transformation(extent={{-114,36},{-134,56}})));
  Modelica.Blocks.Sources.Constant TSet_val[nZones](each k=273.15+20)
    annotation (Placement(transformation(extent={{-114,0},{-134,20}})));
equation
  P[1:nLoads_min] = zeros(nLoads_min);
  Q[1:nLoads_min] = zeros(nLoads_min);
  connect(flowPort_Out[:], sou[:].ports[1]);
  connect(flowPort_In[:], sink[:].ports[1]);
  connect(sou.m_flow_in,m_flow_val. y) annotation (Line(
      points={{-154,28},{-140,28},{-140,46},{-135,46}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSet_val.y,sou. T_in) annotation (Line(
      points={{-135,10},{-140,10},{-140,24},{-152,24}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -100},{200,100}}), graphics), Icon(coordinateSystem(extent={{-200,
            -100},{200,100}})));
end None;
