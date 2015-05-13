within Annex60.Fluid.Examples.PerformanceExamples;
model Example1v1 "Example 1 model without mixing volume"
  extends Annex60.Fluid.Examples.PerformanceExamples.BaseClasses.Example1(
      allowFlowReversal(k=false), res(each from_dp=from_dp));
  parameter Boolean from_dp=false
    "= true, use m_flow = f(dp) else dp = f(m_flow)";
equation

  for i in 1:nRes.k loop
    connect(res[i].port_b, val.port_3) annotation (Line(
      points={{90,30},{100,30},{100,-10},{20,-10},{20,20}},
      color={0,127,255},
      smooth=Smooth.None));
  end for;
  annotation (experiment(
      StopTime=10000,
      __Dymola_NumberOfIntervals=10,
      __Dymola_Algorithm="Radau"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-20},{100,
            100}}), graphics={Ellipse(
          extent={{66,0},{74,-8}},
          lineColor={0,0,255},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,255})}),
    Documentation(info="<html>
</html>", revisions="<html>
<ul>
<li>
April 17, 2015, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}, preserveAspectRatio=
            false)),
    __Dymola_experimentSetupOutput(events=false));
end Example1v1;
