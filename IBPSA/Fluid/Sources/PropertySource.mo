within IBPSA.Fluid.Sources;
model PropertySource
  "Model for overriding fluid properties that flow through the component"
  extends IBPSA.Fluid.Interfaces.PartialTwoPort;

  parameter Boolean use_h_in= false
    "Get the specific enthalpy from the input connector"
    annotation(Evaluate=true);
  parameter Boolean use_Xi_in= false
    "Get the composition from the input connector"
    annotation(Evaluate=true);
  parameter Boolean use_C_in= false
    "Get the trace substances from the input connector"
    annotation(Evaluate=true);

  Modelica.Blocks.Interfaces.RealInput h if use_h_in
    "Prescribed value for specific enthalpy" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-40,120})));
  Modelica.Blocks.Interfaces.RealInput Xi[Medium.nXi] if use_Xi_in
    "Prescribed values for composition" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,120})));
  Modelica.Blocks.Interfaces.RealInput C_in[Medium.nC](
    final quantity=Medium.extraPropertiesNames) if use_C_in
    "Prescribed values for trace substances" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={40,120})));
protected
  Modelica.Blocks.Interfaces.RealOutput h_internal_a
    "Internal outlet value of port_a.h_outflow";
  Modelica.Blocks.Interfaces.RealOutput h_internal_b
    "Internal outlet value of port_b.h_outflow";
  Modelica.Blocks.Interfaces.RealOutput h_in_a = inStream(port_a.h_outflow)
    "Connector for inStream value of port_a.h_outflow";
  Modelica.Blocks.Interfaces.RealOutput h_in_b = inStream(port_b.h_outflow)
    "Connector for inStream value of port_b.h_outflow";

  Modelica.Blocks.Interfaces.RealOutput[Medium.nXi] Xi_internal_a
    "Internal outlet value of port_a.Xi_outflow";
  Modelica.Blocks.Interfaces.RealOutput[Medium.nXi] Xi_internal_b
    "Internal outlet value of port_b.Xi_outflow";
  Modelica.Blocks.Interfaces.RealOutput[Medium.nXi] Xi_in_a = inStream(port_a.Xi_outflow)
    "Connector for inStream value of port_a.Xi_outflow";
  Modelica.Blocks.Interfaces.RealOutput[Medium.nXi] Xi_in_b = inStream(port_b.Xi_outflow)
    "Connector for inStream value of port_b.Xi_outflow";

  Modelica.Blocks.Interfaces.RealInput[Medium.nC] C_internal_a
    "Internal outlet value of port_a.C_outflow";
  Modelica.Blocks.Interfaces.RealInput[Medium.nC] C_internal_b
    "Internal outlet value of port_b.C_outflow";
  Modelica.Blocks.Interfaces.RealOutput[Medium.nC] C_in_a = inStream(port_a.C_outflow)
    "Connector for inStream value of port_a.C_outflow";
  Modelica.Blocks.Interfaces.RealOutput[Medium.nC] C_in_b = inStream(port_b.C_outflow)
    "Connector for inStream value of port_b.C_outflow";
equation
  connect(h_internal_a, h);
  connect(h_internal_b, h);
  if not (use_h_in) then
    connect(h_internal_a,h_in_b);
    connect(h_internal_b,h_in_a);
  end if;

  connect(Xi_internal_a, Xi);
  connect(Xi_internal_b, Xi);
  if not (use_Xi_in) then
    connect(Xi_internal_a,Xi_in_b);
    connect(Xi_internal_b,Xi_in_a);
  end if;

  connect(C_internal_a, C_in);
  connect(C_internal_b, C_in);
  if not (use_C_in) then
    connect(C_internal_a,C_in_b);
    connect(C_internal_b,C_in_a);
  end if;

  port_a.h_outflow=h_internal_a;
  port_b.h_outflow=h_internal_b;
  port_a.Xi_outflow=Xi_internal_a;
  port_b.Xi_outflow=Xi_internal_b;
  port_a.C_outflow=C_internal_a;
  port_b.C_outflow=C_internal_b;

  port_a.p=port_b.p;
  port_a.m_flow+port_b.m_flow=0;

  annotation (Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{100,100}}), graphics={
        Text(
          visible=use_Xi_in,
          extent={{-48,184},{54,144}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="Xi"),
        Text(
          visible=use_h_in,
          extent={{-92,184},{10,144}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="h"),
        Text(
          visible=use_C_in,
          extent={{-12,186},{90,146}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="C"),
        Rectangle(
          extent={{-100,60},{100,-60}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{-100,50},{100,-48}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255})}),
    Documentation(info="<html>
<p>
Model that changes the properties, 
but not the mass flow rate,
of the fluid that passes through it.
</p>
<h4>Typical use and important parameters</h4>
<p>
The fluid properties <code>h</code>, <code>Xi</code> and <code>C</code>
are only modified when the corresponding boolean parameter
<code>use_h_in</code>, <code>use_Xi_in</code> or <code>use_C_in</code>
is enabled.
</p>
<h4>Dynamics</h4>
<p>
This model has no dynamics.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 30, 2018, by Filip Jorissen:<br/>
First implementation.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/881\">#881</a>.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{
            100,100}})));
end PropertySource;
