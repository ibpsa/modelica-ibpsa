within IDEAS.BaseClasses.Testers;
model Tester_Timer "Check correct operation of the Timer_NoEvent"

  IDEAS.BaseClasses.Control.Timer_NoEvents timer(duration=200, timerType=
        Commons.Time.Elements.TimerType.off)
    annotation (Placement(transformation(extent={{-12,2},{8,22}})));
equation
  timer.u = 2*sin(time/20);

  annotation (Diagram(graphics),
    experiment(
      StopTime=400,
      NumberOfIntervals=5000,
      Tolerance=1e-008),
    __Dymola_experimentSetupOutput);
end Tester_Timer;
