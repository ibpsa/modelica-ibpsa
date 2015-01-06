within IDEAS.Fluid.BaseCircuits;
model ThermostaticRadiatiorValve
  "Simple TRV model approximated by a P-control action"
  extends Interfaces.Circuit;
  Actuators.Valves.TwoWayLinear             val1(
    redeclare package Medium = Medium,
    final CvData=IDEAS.Fluid.Types.CvTypes.Kv,
    m_flow_nominal=m_flow_nominal,
    Kv=Kv) annotation (Placement(transformation(extent={{10,-70},{-10,-50}})));
  Modelica.Blocks.Sources.Constant hlift(k=1)
    "Constant opening of the balancing valve"
    annotation (Placement(transformation(extent={{-38,-20},{-18,0}})));
  Actuators.Valves.TwoWayEqualPercentage val(
    m_flow(nominal=0.1),
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    CvData=IDEAS.Fluid.Types.CvTypes.Kv,
    Kv=Kvs) annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  Modelica.Blocks.Continuous.LimPID PID(controllerType=Modelica.Blocks.Types.SimpleController.P,
      k=1) annotation (Placement(transformation(extent={{34,62},{54,82}})));
  Modelica.Blocks.Interfaces.RealInput TZone "Zone sensor temperature"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-20,110}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-20,100})));
  Modelica.Blocks.Interfaces.RealInput TSet "Zone setpoint temperature"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={20,112}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={20,100})));
equation
  connect(val1.port_b, port_b2) annotation (Line(
      points={{-10,-60},{-100,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hlift.y,val1. y) annotation (Line(
      points={{-17,-10},{0,-10},{0,-48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(val.port_b, port_b1) annotation (Line(
      points={{10,30},{80,30},{80,60},{100,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipeSupply.port_b,val. port_a) annotation (Line(
      points={{-60,60},{-36,60},{-36,30},{-10,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(val1.port_a, pipeReturn.port_b) annotation (Line(
      points={{10,-60},{60,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(PID.y, val.y) annotation (Line(
      points={{55,72},{66,72},{66,50},{0,50},{0,42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TZone, PID.u_m) annotation (Line(
      points={{-20,110},{-20,56},{44,56},{44,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSet, PID.u_s) annotation (Line(
      points={{20,112},{20,72},{32,72}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics
        ={
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
          points={{0,40},{0,60}},
          color={0,0,127},
          smooth=Smooth.None),
        Rectangle(
          extent={{-4,44},{4,36}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{20,100},{6,80},{0,60}},
          color={0,255,128},
          smooth=Smooth.None),
        Line(
          points={{0,-60},{0,-40}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-10,-40},{10,-40}},
          color={0,0,127},
          smooth=Smooth.None),
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
        Text(
          extent={{4,44},{24,24}},
          lineColor={0,0,127},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          textString="T"),
        Line(
          points={{-20,100},{-6,80},{0,60}},
          color={255,0,0},
          smooth=Smooth.None)}));
end ThermostaticRadiatiorValve;
