within IDEAS.Thermal.Components.BaseClasses;
model IdealMixer "Temperature based ideal mixer"

  parameter Thermal.Data.Interfaces.Medium medium=Data.Media.Water();
  Modelica.Blocks.Interfaces.RealInput TMixedSet
    "Mixed outlet temperature setpoint" annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=90,
        origin={0,106}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={0,100})));

  parameter Modelica.SIunits.MassFlowRate mFlowMin = 0.01
    "Minimum outlet flowrate for mixing to start";
  Modelica.SIunits.Temperature TCold=pumpCold.T;
  Modelica.SIunits.Temperature THot=mixingVolumeHot.T
    "Temperature of the hot source";
  Modelica.SIunits.Temperature TMixed(start=273.15 + 20)=flowPortMixed.h
    /medium.cp "Temperature of the mixed water";

protected
  Modelica.SIunits.MassFlowRate m_flowMixed=-flowPortMixed.m_flow
    "mass flowrate of the mixed flow";
  Modelica.SIunits.MassFlowRate m_flowCold(min=0)
    "mass flowrate of cold water to the mixing point";
  parameter Modelica.SIunits.MassFlowRate m_flowNom=100
    "Just a large nominal flowrate";
  Real m_flowColdInput(min=0) = m_flowCold/m_flowNom;
//  Real m_flowHotInput = m_flowHot/m_flowNom;

  Pump pumpCold(
    useInput=true,
    medium=medium,
    m_flowNom=m_flowNom,
    m=1)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={0,-28})));

public
  Thermal.Components.Interfaces.FlowPort_a flowPortHot(medium=medium, h(
      start=293.15*medium.cp,
      min=1140947,
      max=1558647))
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-110,-10},{-90,10}})));

  Thermal.Components.Interfaces.FlowPort_a flowPortCold(medium=medium, h(
      start=293.15*medium.cp,
      min=1140947,
      max=1558647))
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}}),
        iconTransformation(extent={{-10,-110},{10,-90}})));

  Thermal.Components.Interfaces.FlowPort_a flowPortMixed(medium=medium, h(
      start=293.15*medium.cp,
      min=1140947,
      max=1558647))
    annotation (Placement(transformation(extent={{90,-10},{110,10}}),
        iconTransformation(extent={{90,-10},{110,10}})));

protected
  MixingVolume mixingVolumeHot(
    medium=medium,
    m=5,
    nbrPorts=2)
    annotation (Placement(transformation(extent={{-36,28},{-16,48}})));
equation
  //m_flowTotal = table.y[profileType] * VDayAvg * medium.rho;
  pumpCold.m_flowSet = m_flowColdInput;
//  pumpHot.m_flowSet = m_flowHotInput;

    if noEvent(THot < TMixedSet) then
      // no mixing
      m_flowCold =  0;
    elseif noEvent(TCold > TMixedSet) then
       m_flowCold = m_flowMixed;
    elseif noEvent(flowPortMixed.m_flow < -mFlowMin) then
      m_flowCold =  - (flowPortHot.m_flow * THot + flowPortMixed.m_flow * TMixedSet) / TCold;
    else
      m_flowCold =  0;
    end if;

//m_flowCold = max(0, -(flowPortHot.m_flow*THot + flowPortMixed.m_flow* TMixedSet)/TCold);

//  flowPortMixed.p = 300000;
//  flowPortMixed.H_flow = semiLinear(flowPortMixed.m_flow,flowPortMixed.h,ambient.T*medium.cp);

  connect(flowPortCold, pumpCold.flowPort_a) annotation (Line(
      points={{0,-100},{0,-38},{-1.83697e-015,-38}},
      color={255,0,0},
      smooth=Smooth.None));

  connect(flowPortHot, mixingVolumeHot.flowPorts[1]) annotation (Line(
      points={{-100,0},{0,0},{-26,27.5}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(mixingVolumeHot.flowPorts[2], flowPortMixed) annotation (Line(
      points={{-26,28.5},{0,28.5},{0,0},{100,0}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(pumpCold.flowPort_b, flowPortMixed) annotation (Line(
      points={{1.83697e-015,-18},{0,-18},{0,0},{100,0}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(flowPortHot, flowPortHot) annotation (Line(
      points={{-100,0},{-100,0}},
      color={0,128,255},
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
        Ellipse(extent={{-20,80},{20,40}}, lineColor={100,100,100}),
        Line(
          points={{0,0},{0,40}},
          color={100,100,100},
          smooth=Smooth.None),
        Text(
          extent={{-10,70},{10,50}},
          lineColor={100,100,100},
          textString="M"),
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
          smooth=Smooth.None)}));
end IdealMixer;
