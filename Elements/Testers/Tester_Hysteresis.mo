within IDEAS.Elements.Testers;
model Tester_Hysteresis

  IDEAS.Elements.General.Hyst_MinOff hyst(
    uLow=-1,
    uHigh=4,
    minOffTime=15)
    annotation (Placement(transformation(extent={{-26,36},{-6,56}})));
  IDEAS.Elements.General.Hyst_NoEvent hyst_NoEvent_MinOnOff(uLow=-1, uHigh=4)
    annotation (Placement(transformation(extent={{4,-14},{24,6}})));
  Modelica.Blocks.Sources.Sine sine(freqHz=0.1, amplitude=5)
    annotation (Placement(transformation(extent={{-84,36},{-64,56}})));
  Modelica.Blocks.Sources.Pulse pulse(period=7)
    annotation (Placement(transformation(extent={{-42,10},{-22,30}})));
equation
  connect(sine.y, hyst.u)         annotation (Line(
      points={{-63,46},{-26.8,46}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sine.y, hyst_NoEvent_MinOnOff.u) annotation (Line(
      points={{-63,46},{-52,46},{-52,-4},{3.2,-4}},
      color={0,0,127},
      smooth=Smooth.None));

  annotation (Diagram(graphics),
    experiment(StopTime=100, Interval=0.1),
    __Dymola_experimentSetupOutput);
end Tester_Hysteresis;
