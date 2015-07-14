within Annex60.Fluid.Examples.Performance;
model Example8 "Common subexpression elimination example"
  extends Modelica.Icons.Example;
  Real a = sin(time+1);
  Real b = sin(time+1);

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -40},{40,60}}),    graphics={Text(
          extent={{-62,24},{-18,-4}},
          lineColor={0,0,255},
          textString="See code")}),
    experiment(
      StopTime=100,
      __Dymola_NumberOfIntervals=1,
      __Dymola_fixedstepsize=0.001,
      __Dymola_Algorithm="Euler"),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=
            false)),
    Documentation(revisions="<html>
<ul>
<li>
June 18, 2015, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This is a very simple example demonstrating common subexpression elimination. 
The Dymola C-code of this model is:
</p>
<p>
W_[0] = sin(Time+1);<br/>
W_[1] = W_[0];
</p>
<p>
I.e. the sine and addition are not evaluated twice, which is more efficient.
</p>
</html>"),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/Examples/PerformanceExamples/Example8.mos"
        "Simulate and plot"));
end Example8;
