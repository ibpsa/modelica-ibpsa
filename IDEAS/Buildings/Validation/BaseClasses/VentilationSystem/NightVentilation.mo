within IDEAS.Buildings.Validation.BaseClasses.VentilationSystem;
model NightVentilation "BESTEST nightventilation system"
  extends IDEAS.Templates.Interfaces.BaseClasses.VentilationSystem(final nLoads=1);

protected
  IDEAS.BoundaryConditions.Occupants.Components.Schedule occ(occupancy=3600*{7,18},
      firstEntryOccupied=true) "Occupancy shedule";
  final parameter Real corrCV=0.822
    "Air density correction for BESTEST at high altitude";

public
  Fluid.Sources.MassFlowSource_T boundary(redeclare package Medium =
        IDEAS.Media.Air,
    use_m_flow_in=true, final nPorts=nZones,
    use_T_in=true)
    annotation (Placement(transformation(extent={{-68,10},{-88,30}})));
  Fluid.Sources.FixedBoundary bou(redeclare package Medium =
        IDEAS.Media.Air, final nPorts=nZones)
    annotation (Placement(transformation(extent={{-68,-30},{-88,-10}})));
  Modelica.Blocks.Sources.RealExpression m_flow_in(y=1703.16*(287*sim.Te/83200)/3600*ventilate)
    annotation (Placement(transformation(extent={{-12,38},{-32,58}})));
  Modelica.Blocks.Sources.RealExpression T_in(y=sim.Te)
    annotation (Placement(transformation(extent={{-10,-8},{-30,12}})));

protected
  Real ventilate = if occ.occupied then 0 else 1;

equation
  wattsLawPlug.P[1] = 0;
  wattsLawPlug.Q[1] = 0;

  for i in 1:nZones loop
    connect(flowPort_Out[i],boundary.ports[i]);
    connect(flowPort_In[i],bou.ports[i]);
  end for;

  connect(boundary.T_in, T_in.y) annotation (Line(
      points={{-66,24},{-50,24},{-50,2},{-31,2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(boundary.m_flow_in, m_flow_in.y) annotation (Line(
      points={{-68,28},{-50,28},{-50,48},{-33,48}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics));
end NightVentilation;
