within Annex60.Fluid.Examples.PerformanceExamples;
model Example6 "Example model demonstrating performance of basic equations"
  extends Modelica.Icons.Example;
  parameter Integer nCapacitors = 500;
  parameter Real R = 0.001;
  parameter Real C = 1000;

  Real[nCapacitors] T;
  Real[nCapacitors+1] Q_flow;
equation
  Q_flow[1]=((273.15+sin(time))-T[1])/R;
  der(T[1])=(Q_flow[1]-Q_flow[2])/C;
  for i in 2:nCapacitors loop
    Q_flow[i] = (T[i-1] - T[i])/R;
    der(T[i])=(Q_flow[i]-Q_flow[i+1])/C;
  end for;
  Q_flow[nCapacitors+1]=0; //adiabatic

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -40},{40,60}}),    graphics={Text(
          extent={{-62,24},{-18,-4}},
          lineColor={0,0,255},
          textString="See code")}),
    experiment(
      StopTime=100,
      __Dymola_NumberOfIntervals=1,
      __Dymola_fixedstepsize=0.001,
      __Dymola_Algorithm="Rkfix4"),
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
end Example6;
