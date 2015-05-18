within Annex60.Fluid.Examples.PerformanceExamples;
model Example7
  extends Modelica.Icons.Example;
  parameter Integer nTem = 500;
  parameter Real R = 0.001;
  parameter Real C = 1000;
  parameter Real tauInv = 1/(R*C);

  Real[nTem] T;

equation
  der(T[1])= ((273.15+sin(time))-2*T[1] + T[2])*tauInv;
  for i in 2:nTem-1 loop
    der(T[i])=(T[i+1]+T[i-1]-2*T[i])*tauInv;
  end for;
  der(T[nTem])= (T[nTem-1]-T[nTem])*tauInv;

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
            false)));
end Example7;
