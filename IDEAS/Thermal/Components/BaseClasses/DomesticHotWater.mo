within IDEAS.Thermal.Components.BaseClasses;
model DomesticHotWater "DHW consumption to be coupled to a heat source"

  parameter Thermal.Data.Interfaces.Medium medium=Data.Media.Water();
  parameter Modelica.SIunits.Temperature TDHWSet=273.15 + 45
    "DHW temperature setpoint";
  parameter Modelica.SIunits.Temperature TCold=283.15;
  Modelica.SIunits.Temperature THot "Temperature of the hot source";
  Modelica.SIunits.Temperature TMixed(start=TDHWSet)=pumpHot.flowPort_b.h
    /medium.cp "Temperature of the hot source";
  parameter Modelica.SIunits.Volume VDayAvg "Average daily water consumption";

  Modelica.SIunits.MassFlowRate m_flowTotal
    "mass flowrate of total DHW consumption";
  Modelica.SIunits.MassFlowRate m_flowCold
    "mass flowrate of cold water to the mixing point";
  Modelica.SIunits.MassFlowRate m_flowHot
    "mass flowrate of hot water to the mixing point";

  // we need to specify the flowrate in the pump and mixingValve as relative values between 0 and 1
  // so we compute a maximum flowrate and use this as nominal flowrate for these components
  // We suppose the daily consumption will always be consumed in MORE than 10s.

  parameter Integer profileType = 1 "Type of the DHW tap profile";
  Modelica.Blocks.Tables.CombiTable1Ds table(
    tableOnFile = true,
    tableName = "data",
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    fileName= "..\\Inputs\\" + "DHWProfile.txt",
    columns=2:4)
    annotation(Placement(visible = true, transformation(origin={-62,66.5},   extent={{-15,15},
            {15,-15}},                                                                                     rotation = 0)));
protected
  parameter Modelica.SIunits.MassFlowRate m_flowNom=VDayAvg*medium.rho/100
    "only used to set a reference";
  Real m_flowHotInput = m_flowHot/m_flowNom;
  Real m_flowColdInput = m_flowCold/m_flowNom;
  Real TSetVar;
  Real m_minimum(start=0);
  Real onoff;

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
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  Thermal.Components.Interfaces.FlowPort_a flowPortCold(medium=medium)
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));

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

  Modelica.Blocks.Sources.Sine  sine(
    amplitude=0.1,
    startTime=7*3600,
    freqHz=1/86400,
    offset=0)
    annotation (Placement(transformation(extent={{-70,2},{-50,22}})));
equation
  //m_flowTotal = table.y[profileType] * VDayAvg * medium.rho;
  table.u =  time;
  pumpCold.m_flowSet = m_flowColdInput;
  pumpHot.m_flowSet = m_flowHotInput;
  //pumpHot1.m_flowSet = m_flowHotInput;
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

  if noEvent(table.y[profileType] > 0) then
    m_minimum :=1e-6;
    onoff :=1;
  else
    m_minimum :=0;
    onoff :=0;
  end if;

  THot := pumpHot.T;
  m_flowTotal := max(table.y[profileType], m_minimum)* VDayAvg * medium.rho;
  TSetVar := min(THot,TDHWSet);
  m_flowCold := if noEvent(onoff > 0.5) then m_flowTotal* (THot - TSetVar)/(THot*onoff-TCold) else 0;
  m_flowHot := if noEvent(onoff > 0.5) then m_flowTotal - m_flowCold else 0;

equation
  connect(ambientCold.flowPort, pumpCold.flowPort_a)
                                                 annotation (Line(
      points={{68,-18},{50,-18}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(flowPortHot, pumpHot.flowPort_a)
                                          annotation (Line(
      points={{0,100},{0,64},{1.83697e-015,64}},
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
      points={{70,-54},{0,-54},{0,-100}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end DomesticHotWater;
