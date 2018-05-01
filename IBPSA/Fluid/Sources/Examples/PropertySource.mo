within IBPSA.Fluid.Sources.Examples;
model PropertySource
  "Model that illustrates the use of PropertySource"
  extends Modelica.Icons.Example;
  package Medium = IBPSA.Media.Air(extraPropertiesNames={"CO2"});

  IBPSA.Fluid.Sources.PropertySource propertySourceXi(
    redeclare package Medium = Medium,
    use_Xi_in=true,
    use_h_in=false,
    use_C_in=false) "Property source that prescribes Xi"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  IBPSA.Fluid.Sources.MassFlowSource_h bouXi(
    redeclare package Medium = Medium,
    nPorts=1,
    use_m_flow_in=true)
              "Boundary for Xi test"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  IBPSA.Fluid.Sources.Boundary_ph sin(redeclare package Medium = Medium, nPorts=
       3) "Sink model"
          annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  IBPSA.Fluid.Sources.PropertySource propertySourceH(
    redeclare package Medium = Medium,
    use_h_in=true,
    use_Xi_in=false,
    use_C_in=false) "Property source that prescribes the specific enthalpy"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  IBPSA.Fluid.Sources.PropertySource propertySourceC(
    redeclare package Medium = Medium,
    use_C_in=true,
    use_h_in=false,
    use_Xi_in=false) "Property source that prescribes C"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  IBPSA.Fluid.Sources.MassFlowSource_h bouH(
    redeclare package Medium = Medium,
    nPorts=1,
    use_m_flow_in=true)
              "Boundary for specific enthalpy test"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  IBPSA.Fluid.Sources.MassFlowSource_h bouC(
    redeclare package Medium = Medium,
    nPorts=1,
    use_m_flow_in=true)
              "Boundary for C test"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Modelica.Blocks.Sources.Constant h(k=Medium.h_default + 1e3)
    "Fixed specific enthalpy value"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Modelica.Blocks.Sources.Constant Xi(k=0.123) "Fixed Xi value"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Modelica.Blocks.Sources.Constant C(k=0.1) "Fixed C value"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=-2,
    duration=1,
    offset=1) "Ramp for mass flow rate"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
equation
  connect(bouXi.ports[1], propertySourceXi.port_a)
    annotation (Line(points={{-40,0},{-10,0}}, color={0,127,255}));
  connect(bouC.ports[1], propertySourceC.port_a)
    annotation (Line(points={{-40,-40},{-10,-40}}, color={0,127,255}));
  connect(bouH.ports[1], propertySourceH.port_a)
    annotation (Line(points={{-40,40},{-10,40}}, color={0,127,255}));
  connect(propertySourceH.port_b,sin. ports[1]) annotation (Line(points={{10,40},
          {60,40},{60,2.66667}}, color={0,127,255}));
  connect(propertySourceXi.port_b,sin. ports[2]) annotation (Line(points={{10,0},
          {36,0},{36,-2.22045e-16},{60,-2.22045e-16}}, color={0,127,255}));
  connect(propertySourceC.port_b,sin. ports[3]) annotation (Line(points={{10,-40},
          {60,-40},{60,-2.66667}}, color={0,127,255}));
  connect(h.y, propertySourceH.h_in)
    annotation (Line(points={{-19,60},{-4,60},{-4,52}}, color={0,0,127}));
  connect(Xi.y, propertySourceXi.Xi_in[1])
    annotation (Line(points={{-19,20},{0,20},{0,12}}, color={0,0,127}));
  connect(C.y, propertySourceC.C_in[1])
    annotation (Line(points={{-19,-20},{4,-20},{4,-28}}, color={0,0,127}));
  connect(bouH.m_flow_in, ramp.y) annotation (Line(points={{-62,48},{-72,48},{-72,
          70},{-79,70}}, color={0,0,127}));
  connect(ramp.y, bouXi.m_flow_in) annotation (Line(points={{-79,70},{-72,70},{-72,
          8},{-62,8}}, color={0,0,127}));
  connect(ramp.y, bouC.m_flow_in) annotation (Line(points={{-79,70},{-72,70},{-72,
          -32},{-62,-32}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
Example model that illustrates the use of
the <code>PropertySource</code> model.
</p>
</html>", revisions="<html>
<ul>
<li>
April 30, 2018, by Filip Jorissen:<br/>
First implementation.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/881\">#881</a>.
</li>
</ul>
</html>"),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/Sources/Examples/PropertySource.mos"
        "Simulate and plot"),
    experiment(
      StopTime=1,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"));
end PropertySource;
