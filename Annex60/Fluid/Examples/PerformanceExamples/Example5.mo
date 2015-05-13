within Annex60.Fluid.Examples.PerformanceExamples;
model Example5
  extends Modelica.Icons.Example;
  parameter Boolean efficient = true
    annotation(Evaluate=true);

  parameter Real[3] a = 1:3;
  parameter Real b=sum(a);

  Real c;
equation
  der(c) = sin(time)*(if efficient then b else sum(a));

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -40},{40,60}}),    graphics),
    experiment(StopTime=100000),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=
            false)));
end Example5;
