within IDEAS.Fluid.FixedResistances.Examples;
model Pipe_HeatPortExample "Example of a Pipe_HeatPort"
  extends Modelica.Icons.Example;
  Pipe_HeatPort pipe_HeatPort(redeclare package Medium = Medium, m_flow_nominal=
       1) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
    annotation (Placement(transformation(extent={{-28,56},{-8,76}})));
  Modelica.Blocks.Sources.Constant const(k=10000)
    annotation (Placement(transformation(extent={{-92,56},{-72,76}})));
  Sources.MassFlowSource_T boundary(
    nPorts=1,
    redeclare package Medium = Medium,
    m_flow=1)
    annotation (Placement(transformation(extent={{-82,-10},{-62,10}})));
  replaceable package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater
    annotation (__Dymola_choicesAllMatching=true);
  Sources.Boundary_pT bou2(nPorts=1, redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{82,-10},{62,10}})));
equation
  connect(prescribedHeatFlow.port, pipe_HeatPort.heatPort) annotation (Line(
      points={{-8,66},{0,66},{0,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(const.y, prescribedHeatFlow.Q_flow) annotation (Line(
      points={{-71,66},{-28,66}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(boundary.ports[1], pipe_HeatPort.port_a) annotation (Line(
      points={{-62,0},{-10,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(bou2.ports[1], pipe_HeatPort.port_b) annotation (Line(
      points={{62,0},{10,0}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end Pipe_HeatPortExample;
