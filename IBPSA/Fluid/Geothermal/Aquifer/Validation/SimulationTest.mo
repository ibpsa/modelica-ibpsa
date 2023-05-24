within IBPSA.Fluid.Geothermal.Aquifer.Validation;
model SimulationTest
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.CombiTimeTable
                                   combiTimeTable(table=[0.0,1; 86400*120,1; 86400
        *120,0; 86400*180,0.0; 86400*180,-1; 86400*300,-1])
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Sources.MassFlowSource_T boundary(
    redeclare package Medium = IBPSA.Media.Water,
    use_m_flow_in=true,
    T=393.15,
    nPorts=1) annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  SingleWell aquWel(
    redeclare package Medium = IBPSA.Media.Water,
    nVol=232,
    griFac=1.1,
    T_ini=307.15,
    TGro=307.15)
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
equation
  connect(combiTimeTable.y[1], boundary.m_flow_in) annotation (Line(points={{-59,
          50},{-40,50},{-40,18},{-22,18}}, color={0,0,127}));
  connect(boundary.ports[1], aquWel.port_a)
    annotation (Line(points={{0,10},{50,10},{50,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SimulationTest;
