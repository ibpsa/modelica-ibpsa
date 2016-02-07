within IDEAS.Fluid.Domestic_Hot_Water;
model Tap
   extends IDEAS.Fluid.Interfaces.PartialTwoPort;

  parameter Modelica.SIunits.Temperature TSource = 285.15;
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium annotation (
      __Dymola_choicesAllMatching=true);

  Modelica.Blocks.Interfaces.RealInput m_flow "Desired mass flow rate"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-30,100}),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-40,100})));
  Modelica.Blocks.Interfaces.RealInput TSet "Desired tap temperature"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={30,100}),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={40,100})));
  Movers.FlowControlled_m_flow pump(redeclare package Medium = Medium,
      addPowerToMedium=false)
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Sources.MassFlowSource_T boundary(
    use_m_flow_in=true,
    T=TSource,
    nPorts=1,
    redeclare package Medium = Medium)
               annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Sources.Boundary_pT bou(nPorts=1, redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{0,-10},{-20,10}})));
  Valves.Thermostatic3WayValve thermostatic3WayValve(m_flow_nominal=
        m_flow_nominal, redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Valves.ThreeWayValve threeWayValve(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
equation
  connect(m_flow, pump.m_flow_in) annotation (Line(points={{-30,100},{-30,100},{
          -30,20},{-40.2,20},{-40.2,12}}, color={0,0,127}));
  connect(m_flow, boundary.m_flow_in) annotation (Line(points={{-30,100},{-30,100},
          {-30,20},{10,20},{10,8},{30,8}},
                                         color={0,0,127}));
  connect(pump.port_b, bou.ports[1])
    annotation (Line(points={{-30,0},{-20,0}}, color={0,127,255}));
  connect(port_a, thermostatic3WayValve.port_a1)
    annotation (Line(points={{-100,0},{-90,0},{-80,0}}, color={0,127,255}));
  connect(thermostatic3WayValve.port_b, pump.port_a)
    annotation (Line(points={{-60,0},{-50,0}}, color={0,127,255}));
  connect(TSet, thermostatic3WayValve.TMixedSet) annotation (Line(points={{30,100},
          {30,40},{-70,40},{-70,10}}, color={0,0,127}));
  connect(boundary.ports[1], threeWayValve.port_a1)
    annotation (Line(points={{50,0},{56,0},{60,0}}, color={0,127,255}));
  connect(threeWayValve.port_b, port_b)
    annotation (Line(points={{80,0},{100,0}},         color={0,127,255}));
  connect(thermostatic3WayValve.port_a2, threeWayValve.port_a2) annotation (
      Line(points={{-70,-10},{-70,-30},{70,-30},{70,-10}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Tap;
