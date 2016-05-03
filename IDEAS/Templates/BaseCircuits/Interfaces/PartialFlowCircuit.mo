within IDEAS.Templates.BaseCircuits.Interfaces;
model PartialFlowCircuit
  import IDEAS;

  // Extensions ----------------------------------------------------------------

  extends PartialCircuitBalancingValve;

  // Parameters ----------------------------------------------------------------

  parameter Boolean measurePower=true
    "Set to false to remove the power consumption measurement of the flow regulator"
    annotation(Dialog(group = "Settings"));

  parameter Boolean realInput = true;
  parameter Boolean booleanInput = false;

  // Components ----------------------------------------------------------------

protected
  replaceable IDEAS.Fluid.Interfaces.PartialTwoPortInterface flowRegulator(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));

public
  Modelica.Blocks.Interfaces.RealInput u if realInput
    "Setpoint of the flow regulator"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,108})));
  Modelica.Blocks.Interfaces.BooleanInput u2 if booleanInput
    "Setpoint of the flow regulator"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,108})));
  Modelica.Blocks.Interfaces.RealOutput power if measurePower
    "Power consumption of the flow regulator"
                                             annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,108}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={42,104})));

equation
  if not includePipes then
    connect(flowRegulator.port_a, port_a1);
  end if;

  if not measureSupplyT then
    connect(flowRegulator.port_b, port_b1);
  end if;

  connect(flowRegulator.port_b, senTemSup.port_a) annotation (Line(
      points={{10,60},{60,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipeSupply.port_b, flowRegulator.port_a) annotation (Line(
      points={{-70,60},{-10,60}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                               graphics={
        Line(
          points={{42,100},{48,80},{46,60}},
          color={255,0,0},
          smooth=Smooth.None,
          visible=measurePower),
        Ellipse(
          extent={{44,62},{48,58}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          visible=measurePower)}));
end PartialFlowCircuit;
