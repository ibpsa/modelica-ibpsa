within IDEAS.Controls.ControlHeating;
model RunningMeanTemperatureEN15251_continuous
  "Calculate the running mean temperature of 7 days, acccording to norm EN15251"

  Modelica.Blocks.Interfaces.RealOutput TRm(unit="K", displayUnit="degC")
    "running mean average temperature"
    annotation (Placement(transformation(extent={{96,-10},{116,10}})));

  Real coeTRm[7]={1,0.8,0.6,0.5,0.4,0.3,0.2} ./ 3.8
    "Weighting coefficients for the running average according to the norm";

  IDEAS.Utilities.Math.MovingAverage ave_days(period=86400)
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Nonlinear.FixedDelay fixedDelay1(delayTime=86400)
    "Delay of one day"
    annotation (Placement(transformation(extent={{-24,46},{-8,62}})));
  Modelica.Blocks.Nonlinear.FixedDelay fixedDelay2(delayTime=2*86400)
    "Delay of two days"
    annotation (Placement(transformation(extent={{-24,20},{-8,36}})));
  Modelica.Blocks.Nonlinear.FixedDelay fixedDelay3(delayTime=3*86400)
    "Delay of three days"
    annotation (Placement(transformation(extent={{-24,-8},{-8,8}})));
  Modelica.Blocks.Nonlinear.FixedDelay fixedDelay6(delayTime=6*86400)
    "Delay of six days"
    annotation (Placement(transformation(extent={{-24,-88},{-8,-72}})));
  Modelica.Blocks.Nonlinear.FixedDelay fixedDelay5(delayTime=5*86400)
    "Delay of five days"
    annotation (Placement(transformation(extent={{-24,-62},{-8,-46}})));
  Modelica.Blocks.Nonlinear.FixedDelay fixedDelay4(delayTime=4*86400)
    "Delay of four days"
    annotation (Placement(transformation(extent={{-24,-36},{-8,-20}})));
  Modelica.Blocks.Math.Sum sum(nin=7, k={1,0.8,0.6,0.5,0.4,0.3,0.2} ./ 3.8)
    annotation (Placement(transformation(extent={{14,-6},{26,6}})));

  outer SimInfoManager       sim
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=sim.Te)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
equation
  connect(realExpression.y, fixedDelay6.u) annotation (Line(
      points={{-59,0},{-44,0},{-44,-80},{-25.6,-80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realExpression.y, fixedDelay5.u) annotation (Line(
      points={{-59,0},{-44,0},{-44,-54},{-25.6,-54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realExpression.y, fixedDelay4.u) annotation (Line(
      points={{-59,0},{-44,0},{-44,-28},{-25.6,-28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realExpression.y, fixedDelay3.u) annotation (Line(
      points={{-59,0},{-25.6,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realExpression.y, fixedDelay2.u) annotation (Line(
      points={{-59,0},{-44,0},{-44,28},{-25.6,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fixedDelay1.u, realExpression.y) annotation (Line(
      points={{-25.6,54},{-44,54},{-44,0},{-59,0}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(TRm, TRm) annotation (Line(
      points={{106,0},{106,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realExpression.y, sum.u[1]) annotation (Line(
      points={{-59,0},{-44,0},{-44,78},{6,78},{6,-1.02857},{12.8,-1.02857}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fixedDelay1.y, sum.u[2]) annotation (Line(
      points={{-7.2,54},{6,54},{6,-0.685714},{12.8,-0.685714}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fixedDelay2.y, sum.u[3]) annotation (Line(
      points={{-7.2,28},{6,28},{6,-0.342857},{12.8,-0.342857}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fixedDelay3.y, sum.u[4]) annotation (Line(
      points={{-7.2,0},{12.8,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fixedDelay4.y, sum.u[5]) annotation (Line(
      points={{-7.2,-28},{6,-28},{6,0.342857},{12.8,0.342857}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fixedDelay5.y, sum.u[6]) annotation (Line(
      points={{-7.2,-54},{6,-54},{6,0.685714},{12.8,0.685714}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fixedDelay6.y, sum.u[7]) annotation (Line(
      points={{-7.2,-80},{6,-80},{6,1.02857},{12.8,1.02857}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sum.y, ave_days.u) annotation (Line(
      points={{26.6,0},{38,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ave_days.y, TRm) annotation (Line(
      points={{61,0},{106,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics
        ={
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
          extent={{-100,142},{100,100}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-52,32},{54,-26}},
          lineColor={0,0,255},
          textString="EN15251")}));
end RunningMeanTemperatureEN15251_continuous;
