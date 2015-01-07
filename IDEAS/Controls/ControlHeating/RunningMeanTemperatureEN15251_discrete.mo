within IDEAS.Controls.ControlHeating;
model RunningMeanTemperatureEN15251_discrete
  "Calculate the running mean temperature of 7 days, acccording to norm EN15251"

  parameter Real[7] TAveDayIni(unit="K", displayUnit="degC") = ones(7).* 283.15
    "initial running mean temperature";

  // Interface
   discrete Modelica.Blocks.Interfaces.RealOutput TRm(unit="K",displayUnit = "degC")
    "running mean average temperature"
     annotation (Placement(transformation(extent={{96,-10},{116,10}})));

protected
  discrete Real[7] TAveDay(unit="K",displayUnit = "degC")
    "Vector with the average day temperatures of the previous nTermRm days";
  parameter Real coeTRm[7] = {1, 0.8, 0.6, 0.5, 0.4, 0.3, 0.2}./3.8
    "weighTAmb.yg coefficient for the running average";

  Real intTAmb "integral of TAmb.y";

public
  Modelica.Blocks.Sources.RealExpression TAmb(y=sim.Te)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  outer SimInfoManager       sim
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
equation
  der(intTAmb) =  TAmb.y;
algorithm
  when initial() then
    // initialization of the discrete variables
    TAveDay:=TAveDayIni;
    TRm:=TAveDayIni[1];
  elsewhen sample(24*3600,24*3600) then
    // Update of TAveDay
    for i in 2:7 loop
      TAveDay[i] := pre(TAveDay[i-1]);
    end for;
    TAveDay[1] := intTAmb / 24/3600;
    // reinitialisation of the intTAmb.y
    reinit(intTAmb,0);
    TRm :=TAveDay*coeTRm;
  end when;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    experiment(StopTime=864000),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{100,100},{-100,-100}},
          lineColor={100,100,100},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255}),
        Line(
          points={{0,100},{98,0},{0,-100}},
          color={100,100,100},
          smooth=Smooth.None),
        Text(
          extent={{-100,140},{100,100}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-48,32},{58,-26}},
          lineColor={0,0,255},
          textString="EN15251")}));
end RunningMeanTemperatureEN15251_discrete;
