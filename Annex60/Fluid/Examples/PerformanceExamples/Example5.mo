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
            -40},{40,60}}),    graphics={Text(
          extent={{-62,24},{-18,-4}},
          lineColor={0,0,255},
          textString="See code")}),
    experiment(StopTime=100000),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=
            false)),
    Documentation(revisions="<html>
<ul>
<li>
April 17, 2015, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
end Example5;
