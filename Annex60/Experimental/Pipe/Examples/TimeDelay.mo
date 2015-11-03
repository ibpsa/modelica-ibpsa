within Annex60.Experimental.Pipe.Examples;
package TimeDelay
  extends Modelica.Icons.ExamplesPackage;
  model FlowReversal
    extends Modelica.Icons.Example;

    BaseClasses.PDETime timeDelay
      annotation (Placement(transformation(extent={{0,0},{20,20}})));
    Modelica.Blocks.Sources.Step velocityStep(
      startTime=100,
      height=-2*offset,
      offset=offset)
      annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
    parameter Real offset=0.1 "Offset of output signal y";
  equation
    connect(timeDelay.u, velocityStep.y)
      annotation (Line(points={{-2,10},{-20,10},{-39,10}}, color={0,0,127}));
    annotation (experiment(StopTime=1000, Interval=1),
        __Dymola_experimentSetupOutput);
  end FlowReversal;

  model ContinuouslyVaryingFlow
    extends Modelica.Icons.Example;

    BaseClasses.PDETime timeDelay
      annotation (Placement(transformation(extent={{0,0},{20,20}})));
    parameter Real offset=0.1 "Offset of output signal y";
    Modelica.Blocks.Sources.Sine sine(amplitude=0.1, freqHz=0.001)
      annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  equation
    connect(timeDelay.u, sine.y)
      annotation (Line(points={{-2,10},{-20,10},{-39,10}}, color={0,0,127}));
    annotation (experiment(StopTime=1000, Interval=1),
        __Dymola_experimentSetupOutput);
  end ContinuouslyVaryingFlow;

  model ZeroFlow
    "Unit test for PDETime operator for the case where zero flow occurs for a longer time"
    extends Modelica.Icons.Example;

    BaseClasses.PDETime timeDelay
      annotation (Placement(transformation(extent={{0,0},{20,20}})));
    parameter Real offset=0.1 "Offset of output signal y";
    Modelica.Blocks.Math.Add add
      annotation (Placement(transformation(extent={{-28,0},{-8,20}})));
    Modelica.Blocks.Sources.Pulse pulse(
      amplitude=offset,
      period=500,
      nperiod=1,
      width=20) annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
    Modelica.Blocks.Sources.Pulse pulse1(
      amplitude=-offset,
      width=50,
      period=500,
      nperiod=1,
      startTime=500)
      annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  equation
    connect(timeDelay.u, add.y)
      annotation (Line(points={{-2,10},{-7,10}}, color={0,0,127}));
    connect(pulse.y, add.u1) annotation (Line(points={{-59,30},{-42,30},{-42,16},{
            -30,16}}, color={0,0,127}));
    connect(pulse1.y, add.u2) annotation (Line(points={{-59,-10},{-42,-10},{-42,4},
            {-30,4}}, color={0,0,127}));
    annotation (experiment(StopTime=1000, Interval=1),
        __Dymola_experimentSetupOutput,
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
              100}})));
  end ZeroFlow;

  model DiffTimeZeroFlow
    "Unit test for PDETime operator for the case where zero flow occurs for a longer time"
    extends Modelica.Icons.Example;

    parameter Real offset=0.1 "Offset of output signal y";
    Modelica.Blocks.Math.Add add
      annotation (Placement(transformation(extent={{-28,0},{-8,20}})));
    Modelica.Blocks.Sources.Pulse pulse(
      amplitude=offset,
      period=500,
      nperiod=1,
      width=20) annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
    Modelica.Blocks.Sources.Pulse pulse1(
      amplitude=-offset,
      width=50,
      period=500,
      nperiod=1,
      startTime=500)
      annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
    TimeDelays.DiffTime diffTime
      annotation (Placement(transformation(extent={{10,0},{30,20}})));
    BaseClasses.PDETime_modified modified
      annotation (Placement(transformation(extent={{10,-30},{30,-10}})));
    BaseClasses.PDETime pDETime
      annotation (Placement(transformation(extent={{10,-62},{30,-42}})));
  equation
    connect(pulse.y, add.u1) annotation (Line(points={{-59,30},{-42,30},{-42,16},{
            -30,16}}, color={0,0,127}));
    connect(pulse1.y, add.u2) annotation (Line(points={{-59,-10},{-42,-10},{-42,4},
            {-30,4}}, color={0,0,127}));
    connect(add.y, diffTime.u)
      annotation (Line(points={{-7,10},{0,10},{8,10}}, color={0,0,127}));
    connect(add.y, modified.u) annotation (Line(points={{-7,10},{0,10},{0,-20},
            {8,-20}}, color={0,0,127}));
    connect(add.y, pDETime.u) annotation (Line(points={{-7,10},{0,10},{0,-52},{
            8,-52}}, color={0,0,127}));
    annotation (experiment(StopTime=1000, Interval=1),
        __Dymola_experimentSetupOutput,
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
              100}})));
  end DiffTimeZeroFlow;
end TimeDelay;
