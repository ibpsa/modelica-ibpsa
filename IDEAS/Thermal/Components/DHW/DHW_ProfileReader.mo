within IDEAS.Thermal.Components.DHW;
model DHW_ProfileReader
  "DHW consumption with profile reader.  RealInput mDHW60C is not used."

extends IDEAS.Thermal.Components.DHW.partial_DHW;

  parameter Modelica.SIunits.Volume VDayAvg "Average daily water consumption";
  parameter Integer profileType = 1 "Type of the DHW tap profile";

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

  m_flowTotal := onoff * max(m_flowInit, m_minimum);

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
  annotation (Diagram(graphics), Icon(graphics={
        Polygon(
          points={{42,6},{38,-16},{24,-34},{18,-44},{22,-60},{34,-70},{46,-70},
              {58,-66},{64,-54},{64,-40},{56,-26},{48,-18},{42,6}},
          lineColor={0,128,255},
          smooth=Smooth.None,
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{16,20},{56,10}},
          lineColor={0,128,255},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-22,68},{0,46}},
          lineColor={0,128,255},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-46,68},{-24,46}},
          lineColor={0,128,255},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-24,26},{-24,0},{-120,0}},
          color={0,0,127},
          smooth=Smooth.None),
        Rectangle(
          extent={{-34,42},{50,20}},
          lineColor={0,128,255},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid)}));
end DHW_ProfileReader;
