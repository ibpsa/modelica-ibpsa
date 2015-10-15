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
end TimeDelay;
