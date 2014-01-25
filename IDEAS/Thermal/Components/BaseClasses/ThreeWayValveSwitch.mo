within IDEAS.Thermal.Components.BaseClasses;
model ThreeWayValveSwitch "Switches between two circuits"
  parameter Thermal.Data.Interfaces.Medium medium=Data.Media.Water();
  parameter Modelica.SIunits.MassFlowRate mFlowMin = 0.01
    "Minimum outlet flowrate for mixing to start";
public
  Thermal.Components.Interfaces.FlowPort_a flowPort_option0(medium=medium, h(
      start=293.15*medium.cp,
      min=1140947,
      max=1558647))
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-110,-10},{-90,10}})));
  Thermal.Components.Interfaces.FlowPort_a flowPort_option1(medium=medium, h(
      start=293.15*medium.cp,
      min=1140947,
      max=1558647))
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}}),
        iconTransformation(extent={{-10,-110},{10,-90}})));
  Thermal.Components.Interfaces.FlowPort_a flowPort_fixed(medium=medium, h(
      start=293.15*medium.cp,
      min=1140947,
      max=1558647))
    annotation (Placement(transformation(extent={{90,-10},{110,10}}),
        iconTransformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Interfaces.BooleanInput switch annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,102}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,80})));
  BaseClasses.Pump pump_option1(
    medium=medium,
    useInput=true,
    m_flowNom=m_flowNom,
    m=0.1,
    TInitial=293.15)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-50})));
//protected
Modelica.SIunits.MassFlowRate m_flowFixed
    "mass flowrate of the fixed flow port";
Modelica.SIunits.MassFlowRate m_flowOption1(min=0)
    "mass flowrate of option 1 hydraulics to the fixed port";
parameter Modelica.SIunits.MassFlowRate m_flowNom=100
    "Just a large nominal flowrate";
  Real m_flowOption1Input(min=0) = m_flowOption1/m_flowNom "option 1";
  BaseClasses.MixingVolume mixingVolume(medium=medium,m=0.1)
    annotation (Placement(transformation(extent={{-54,4},{-34,24}})));
equation
  // the fixed mass flow rate is determined by the fixed port
  m_flowFixed=-flowPort_fixed.m_flow;
  // decide whether to connect with 1 or with 0
  if noEvent( switch and (flowPort_fixed.m_flow < -mFlowMin)) then
    m_flowOption1 = m_flowFixed;
  else
    m_flowOption1 = 0;
  end if;
  // feed the output to the pumps
  pump_option1.m_flowSet = m_flowOption1Input;
  connect(pump_option1.flowPort_a, flowPort_option1) annotation (Line(
      points={{-6.12323e-016,-60},{0,-60},{0,-100}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pump_option1.flowPort_b, flowPort_fixed) annotation (Line(
      points={{6.12323e-016,-40},{0,-40},{0,0},{100,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(mixingVolume.flowPorts[1], flowPort_option0) annotation (Line(
      points={{-44,3.5},{-76,3.5},{-76,0},{-100,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(mixingVolume.flowPorts[2], flowPort_fixed) annotation (Line(
      points={{-44,4.5},{-44,0},{100,0}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Icon(graphics={
        Polygon(
          points={{-60,30},{-60,-30},{0,0},{-60,30}},
          lineColor={100,100,100},
          smooth=Smooth.None),
        Polygon(
          points={{60,30},{60,-30},{0,0},{60,30}},
          lineColor={100,100,100},
          smooth=Smooth.None),
        Polygon(
          points={{-30,30},{-30,-30},{30,0},{-30,30}},
          lineColor={100,100,100},
          smooth=Smooth.None,
          origin={0,-30},
          rotation=90),
        Line(
          points={{-70,30},{-70,-30}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{70,30},{70,-30}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-30,-70},{30,-70}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-70,0},{-100,0}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{70,0},{100,0}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{0,-70},{0,-100}},
          color={0,0,127},
          smooth=Smooth.None),
        Text(
          extent={{-76,-20},{-22,16}},
          lineColor={255,0,0},
          textString="0"),
        Text(
          extent={{-28,-62},{26,-26}},
          lineColor={255,0,0},
          textString="1")}),
    Documentation(revisions="<html>
<p><ul>
<li>January 2014, Dieter Patteeuw<br/><i>First implementation</i></li>
</ul></p>
</html>"));
end ThreeWayValveSwitch;
