within IDEAS.Thermal.Components.DHW;
model DHW_ProfileReader
  "DHW consumption with profile reader.  RealInput mDHW60C is not used."

extends IDEAS.Thermal.Components.DHW.partial_DHW;

  parameter Modelica.SIunits.Volume VDayAvg "Average daily water consumption";
  parameter Integer profileType = 1 "Type of the DHW tap profile";
  Real onoff;
  Real m_minimum(start=0);

  Modelica.Blocks.Tables.CombiTable1Ds table(
    tableOnFile = true,
    tableName = "data",
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    fileName= "..\\Inputs\\" + "DHWProfile.txt",
    columns=2:4)
    annotation(Placement(visible = true, transformation(origin={-62,66.5},   extent={{-15,15},
            {15,-15}},                                                                                     rotation = 0)));

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

equation
  table.u =  time;
  m_flowInit = table.y[profileType]* VDayAvg * medium.rho;

algorithm
  if m_flowInit > 0 then
    m_minimum :=1e-3;
    onoff :=1;
  else
    m_minimum :=0;
    onoff :=0;
  end if;
  m_flowTotal := onoff * max(m_flowInit, m_minimum);

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
end DHW_ProfileReader;
