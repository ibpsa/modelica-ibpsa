within IBPSA.Utilities.IO.Examples;
model OverWritten
  import IBPSA;
 extends Modelica.Icons.Example;
   inner IBPSA.Utilities.IO.Configuration Config(samplePeriod=0.5, activation=
        IBPSA.Utilities.IO.Types.GlobalActivation.use_input)
    annotation (Placement(transformation(extent={{60,58},{80,80}})));
  IBPSA.Utilities.IO.OverWritten overwritten(
    numVar=2,
    samplePeriod=1,
    activation=IBPSA.Utilities.IO.Types.LocalActivation.always)
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

  Modelica.Blocks.Sources.Sine sine(amplitude=2, freqHz=1/60)
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Modelica.Blocks.Sources.Sine sine1(freqHz=1/30)
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y=true)
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
equation
  connect(sine.y, overwritten.u[1]) annotation (Line(points={{-59,-40},{-60,-40},
          {-20,-40},{-20,-1},{-2,-1}}, color={0,0,127}));
  connect(sine1.y, overwritten.u[2]) annotation (Line(points={{-59,20},{-20,20},
          {-20,1},{-2,1}}, color={0,0,127}));
  connect(booleanExpression.y, Config.activate) annotation (Line(points={{1,80},
          {30,80},{30,77.8},{58,77.8}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=240));
end OverWritten;
