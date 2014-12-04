within IDEAS.Controls.ControlHeating;
model RunningMeanTemperatureEN15251_continuous
  "Calculate the running mean temperature of 7 days, acccording to norm EN15251"
  extends Simplified2ZonesOfficeBuilding.Control.Interfaces.SubController;
  import SI = Modelica.SIunits;

  Modelica.Blocks.Interfaces.RealOutput TRm(unit="K",displayUnit = "degC")
    "running mean average temperature"
     annotation (Placement(transformation(extent={{96,-10},{116,10}})));
  Modelica.Blocks.Interfaces.RealInput TIn(unit="K",displayUnit = "degC")
    "Temperature for which the running mean is calculated"
     annotation (Placement(transformation(extent={{-126,-20},{-86,20}})));

  Real coeTRm[7] = {1, 0.8, 0.6, 0.5, 0.4, 0.3, 0.2}./3.8
    "Weighting coefficients for the running average according to the norm";

  IDEAS.Utilities.Math.MovingAverage ave_day1(period=86400)
    annotation (Placement(transformation(extent={{8,70},{28,90}})));
  IDEAS.Utilities.Math.MovingAverage ave_day2(period=86400)
    annotation (Placement(transformation(extent={{8,44},{28,64}})));
  IDEAS.Utilities.Math.MovingAverage ave_day3(period=86400)
    annotation (Placement(transformation(extent={{8,18},{28,38}})));
  IDEAS.Utilities.Math.MovingAverage ave_day4(period=86400)
    annotation (Placement(transformation(extent={{8,-10},{28,10}})));
  IDEAS.Utilities.Math.MovingAverage ave_day5(period=86400)
    annotation (Placement(transformation(extent={{8,-38},{28,-18}})));
  IDEAS.Utilities.Math.MovingAverage ave_day6(period=86400)
    annotation (Placement(transformation(extent={{8,-64},{28,-44}})));
  IDEAS.Utilities.Math.MovingAverage ave_day7(period=86400)
    annotation (Placement(transformation(extent={{8,-90},{28,-70}})));
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
    annotation (Placement(transformation(extent={{60,-6},{72,6}})));

equation
  connect(fixedDelay6.y, ave_day7.u) annotation (Line(
      points={{-7.2,-80},{6,-80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fixedDelay5.y, ave_day6.u) annotation (Line(
      points={{-7.2,-54},{6,-54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fixedDelay4.y, ave_day5.u) annotation (Line(
      points={{-7.2,-28},{6,-28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fixedDelay3.y, ave_day4.u) annotation (Line(
      points={{-7.2,0},{6,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fixedDelay2.y, ave_day3.u) annotation (Line(
      points={{-7.2,28},{6,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fixedDelay1.y, ave_day2.u) annotation (Line(
      points={{-7.2,54},{6,54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TIn,fixedDelay6. u) annotation (Line(
      points={{-106,0},{-44,0},{-44,-80},{-25.6,-80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TIn, fixedDelay5.u) annotation (Line(
      points={{-106,0},{-44,0},{-44,-54},{-25.6,-54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TIn,fixedDelay4. u) annotation (Line(
      points={{-106,0},{-44,0},{-44,-28},{-25.6,-28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TIn,fixedDelay3. u) annotation (Line(
      points={{-106,0},{-25.6,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TIn,fixedDelay2. u) annotation (Line(
      points={{-106,0},{-44,0},{-44,28},{-25.6,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fixedDelay1.u, TIn) annotation (Line(
      points={{-25.6,54},{-44,54},{-44,0},{-106,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ave_day1.u, TIn) annotation (Line(
      points={{6,80},{-44,80},{-44,0},{-106,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ave_day1.y, sum.u[1]) annotation (Line(
      points={{29,80},{54,80},{54,-1.02857},{58.8,-1.02857}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ave_day2.y, sum.u[2]) annotation (Line(
      points={{29,54},{54,54},{54,-0.685714},{58.8,-0.685714}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ave_day3.y, sum.u[3]) annotation (Line(
      points={{29,28},{54,28},{54,-0.342857},{58.8,-0.342857}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ave_day4.y, sum.u[4]) annotation (Line(
      points={{29,0},{58.8,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ave_day5.y, sum.u[5]) annotation (Line(
      points={{29,-28},{54,-28},{54,0.342857},{58.8,0.342857}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ave_day6.y, sum.u[6]) annotation (Line(
      points={{29,-54},{54,-54},{54,0.685714},{58.8,0.685714}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(ave_day7.y, sum.u[7]) annotation (Line(
      points={{29,-80},{54,-80},{54,1.02857},{58.8,1.02857}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TRm, TRm) annotation (Line(
      points={{106,0},{106,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sum.y, TRm) annotation (Line(
      points={{72.6,0},{106,0}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end RunningMeanTemperatureEN15251_continuous;
