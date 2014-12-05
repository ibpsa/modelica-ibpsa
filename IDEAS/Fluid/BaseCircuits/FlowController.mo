within IDEAS.Fluid.BaseCircuits;
model FlowController
  //Extensions
  extends PartialCircuit;

  //Parameters
  parameter Real Kv "Kv value of the balancing valve";
  parameter Real Kvs "Kv value of the controllable valve";

  //Interfaces
  Modelica.Blocks.Interfaces.RealInput opening "Valve opening signal"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,114}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,114})));

  //Components
  IDEAS.Fluid.Actuators.Valves.TwoWayLinear val1(
    redeclare package Medium = Medium,
    CvData=IDEAS.Fluid.Types.CvTypes.Kv,
    Kv=Kv) annotation (Placement(transformation(extent={{10,-70},{-10,-50}})));

  Modelica.Blocks.Sources.Constant hlift(k=1)
    "Constant opening of the balancing valve"
    annotation (Placement(transformation(extent={{-38,-20},{-18,0}})));

  Actuators.Valves.TwoWayEqualPercentage val(
    m_flow(nominal=0.1),
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    CvData=IDEAS.Fluid.Types.CvTypes.Kv,
    Kv=Kvs) annotation (Placement(transformation(extent={{-10,50},{10,70}})));

equation
  connect(val1.port_b, port_b2) annotation (Line(
      points={{-10,-60},{-100,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hlift.y, val1.y) annotation (Line(
      points={{-17,-10},{0,-10},{0,-48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(val.port_b, port_b1) annotation (Line(
      points={{10,60},{100,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(opening, val.y) annotation (Line(
      points={{0,114},{0,72}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pipeSupply.port_b, val.port_a) annotation (Line(
      points={{-60,60},{-10,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(val1.port_a, pipeReturn.port_b) annotation (Line(
      points={{10,-60},{60,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Polygon(
          points={{-20,-50},{-20,-70},{0,-60},{-20,-50}},
          lineColor={0,0,127},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{20,-50},{20,-70},{0,-60},{20,-50}},
          lineColor={0,0,127},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{0,-60},{0,-40}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-10,-40},{10,-40}},
          color={0,0,127},
          smooth=Smooth.None),
        Polygon(
          points={{-20,70},{-20,50},{0,60},{-20,70}},
          lineColor={0,0,127},
          smooth=Smooth.None,
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{20,70},{20,50},{0,60},{20,70}},
          lineColor={0,0,127},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{0,60},{0,80}},
          color={0,0,127},
          smooth=Smooth.None),
        Rectangle(
          extent={{-4,88},{4,80}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{0,102},{6,80},{0,60}},
          color={0,255,128},
          smooth=Smooth.None)}));
end FlowController;
