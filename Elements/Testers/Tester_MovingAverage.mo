within IDEAS.Elements.Testers;
model Tester_MovingAverage

  IDEAS.Elements.Math.MovingAverage movingAverage(period=3)
    annotation (Placement(transformation(extent={{-16,8},{4,28}})));
  Modelica.Blocks.Sources.Pulse step(
    offset=50,
    startTime=5,
    amplitude=150,
    period=1)
    annotation (Placement(transformation(extent={{-74,8},{-54,28}})));
equation
  connect(step.y, movingAverage.u) annotation (Line(
      points={{-53,18},{-53,18},{-18,18}},
      color={0,0,127},
      thickness=0.5,
      smooth=Smooth.Bezier));
  annotation (
    Diagram(graphics),
    experiment(StopTime=20),
    __Dymola_experimentSetupOutput);
end Tester_MovingAverage;
