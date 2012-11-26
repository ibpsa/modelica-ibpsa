within IDEAS.Thermal.Components.DHW;
model DHW_RealInput "DHW consumption with input for flowrate at 60 degC"

  extends IDEAS.Thermal.Components.DHW.partial_DHW;

equation
  m_flowInit = mDHW60C;

algorithm
  m_flowTotal := mDHW60C * (273.15+60-TCold) / (TDHWSet - TCold);
  m_flowCold := m_flowTotal* (THot - TSetVar)/(THot-TCold);
  m_flowHot := m_flowTotal - m_flowCold;

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
  annotation (Diagram(graphics));
end DHW_RealInput;
