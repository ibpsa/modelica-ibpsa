within IDEAS.Thermal.Components.DHW;
partial model partial_DHW "partial DHW model"

  parameter Thermal.Data.Interfaces.Medium medium=Data.Media.Water();
  parameter Modelica.SIunits.Temperature TDHWSet(max=273.15+60) = 273.15 + 45
    "DHW temperature setpoint";
  parameter Modelica.SIunits.Temperature TCold=283.15;
  Modelica.SIunits.Temperature THot "Temperature of the hot source";
  Modelica.SIunits.Temperature TMixed(start=TDHWSet)=pumpHot.flowPort_b.h
    /medium.cp "Temperature of the hot source";

  Modelica.SIunits.MassFlowRate m_flowInit(start=0)
    "Initial mass flowrate of total DHW consumption";
  Modelica.SIunits.MassFlowRate m_flowTotal(start=0)
    "mass flowrate of total DHW consumption at TDHWSet, takes into account cut-off at very low flowrates";
  Modelica.SIunits.MassFlowRate m_flowCold(start=0)
    "mass flowrate of cold water to the mixing point";
  Modelica.SIunits.MassFlowRate m_flowHot(start=0)
    "mass flowrate of hot water to the mixing point";
  Modelica.SIunits.Power QHeatTotal = m_flowTotal * medium.cp * ( TMixed - TCold);

  // we need to specify the flowrate in the pump and mixingValve as relative values between 0 and 1
  // so we compute a maximum flowrate and use this as nominal flowrate for these components
  // We suppose the flowrate will always be lower than 1e3 kg/s.

protected
  parameter Modelica.SIunits.MassFlowRate m_flowNom=1e3
    "only used to set a reference";
  Real m_flowHotInput = m_flowHot/m_flowNom;
  Real m_flowColdInput = m_flowCold/m_flowNom;
  Real TSetVar;

  /*
  Slows down the simulation too much.  Should be in post processing
  Real m_flowIntegrated(start = 0, fixed = true);
  Real m_flowDiscomfort(start=0);
  Real discomfort; //base 1
  Real discomfortWeighted;
  Real dTDiscomfort;
  */

public
  Thermal.Components.BaseClasses.Ambient ambientCold(
    medium=medium,
    constantAmbientPressure=500000,
    constantAmbientTemperature=TCold)
    annotation (Placement(transformation(extent={{68,-28},{88,-8}})));
  Thermal.Components.BaseClasses.Ambient ambientMixed(
    medium=medium,
    constantAmbientPressure=400000,
    constantAmbientTemperature=283.15)
    annotation (Placement(transformation(extent={{66,28},{86,48}})));
  Thermal.Components.Interfaces.FlowPort_a flowPortHot(medium=medium)
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),
        iconTransformation(extent={{-110,-10},{-90,10}})));
  Thermal.Components.Interfaces.FlowPort_a flowPortCold(medium=medium)
    annotation (Placement(transformation(extent={{130,-10},{150,10}}),
        iconTransformation(extent={{130,-10},{150,10}})));

  Thermal.Components.BaseClasses.Ambient ambientCold1(
    medium=medium,
    constantAmbientPressure=500000,
    constantAmbientTemperature=TCold)
    annotation (Placement(transformation(extent={{70,-64},{90,-44}})));
  Thermal.Components.BaseClasses.Pump pumpCold(
    useInput=true,
    medium=medium,
    m=5,
    m_flowNom=m_flowNom)
    annotation (Placement(transformation(extent={{50,-28},{30,-8}})));

  Thermal.Components.BaseClasses.Pump pumpHot(
    useInput=true,
    medium=medium,
    m_flowNom=m_flowNom,
    m=1)                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,54})));

  Modelica.Blocks.Interfaces.RealInput mDHW60C
    "Mass flowrate of DHW at 60 degC in kg/s"
    annotation (Placement(transformation(extent={{-24,6},{16,46}}),
        iconTransformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={20,100})));
equation
  pumpCold.m_flowSet = m_flowColdInput;
  pumpHot.m_flowSet = m_flowHotInput;

  /*
  // computation of DHW discomfort: too slow here, ==> post processing
  der(m_flowIntegrated) =m_flowTotal;
  der(m_flowIntegrated) = m_flowTotal;
  der(m_flowDiscomfort) = if noEvent(TMixed < TDHWSet) then m_flowTotal else 0;
  der(discomfortWeighted) = if noEvent(TMixed < TDHWSet) then m_flowTotal * (TDHWSet - TMixed) else 0;
  discomfort = m_flowDiscomfort / max(m_flowIntegrated, 1);
  dTDiscomfort = discomfortWeighted / max(m_flowDiscomfort,1);
  */
algorithm

  THot := pumpHot.T;
  // put in the extended models: m_flowTotal := ...
  TSetVar := min(THot,TDHWSet);

equation
  connect(ambientCold.flowPort, pumpCold.flowPort_a)
                                                 annotation (Line(
      points={{68,-18},{50,-18}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(flowPortHot, pumpHot.flowPort_a)
                                          annotation (Line(
      points={{-100,0},{-100,64},{1.83697e-015,64}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(pumpHot.flowPort_b, ambientMixed.flowPort)
                                                   annotation (Line(
      points={{-1.83697e-015,44},{0,44},{0,38},{66,38}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(pumpCold.flowPort_b, pumpHot.flowPort_b)
                                             annotation (Line(
      points={{30,-18},{0,-18},{0,44},{-1.83697e-015,44}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(ambientCold1.flowPort, flowPortCold) annotation (Line(
      points={{70,-54},{140,-54},{140,0}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-100,-40},{140,100}}),
                      graphics), Icon(coordinateSystem(extent={{-100,-40},{140,100}},
          preserveAspectRatio=true),  graphics={
        Line(
          points={{-20,30},{20,-30},{-20,-30},{20,30},{-20,30}},
          color={100,100,100},
          smooth=Smooth.None,
          origin={-30,0},
          rotation=-90),
        Line(
          points={{-70,0},{-70,0},{-100,0}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{20,40},{20,0},{20,0}},
          color={100,100,100},
          smooth=Smooth.None),
        Line(
          points={{0,40},{40,40},{34,80},{4,80},{0,40}},
          color={100,100,100},
          smooth=Smooth.None),
        Line(
          points={{-70,20},{-70,-20}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{140,0},{140,0},{110,0}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{110,18},{110,-22}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-20,30},{20,-30},{-20,-30},{20,30},{-20,30}},
          color={100,100,100},
          smooth=Smooth.None,
          origin={70,0},
          rotation=-90),
        Line(
          points={{0,0},{40,0},{40,-2}},
          color={100,100,100},
          smooth=Smooth.None)}));
end partial_DHW;
