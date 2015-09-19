within Annex60.Controls.Continuous.Examples;
model HeatingCurve "Heating curve model"
  import Annex60;
  extends Modelica.Icons.Example;
  Annex60.Controls.Continuous.HeatingCurve heatingCurve(
    uVals={283.15,293.15,296.15},
    useBounds=true,
    yUpper=300.15,
    yVals={284.15,294.15,299.15}) "Heating curve without night set back"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=20,
    offset=283.15,
    duration=1) "Temperature measurement"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Annex60.Controls.Continuous.HeatingCurve heatingCurveSetBack(
    uVals={283.15,293.15,296.15},
    useBounds=true,
    yUpper=300.15,
    yVals={284.15,294.15,299.15},
    useNightSetBack=true,
    yValsNight={283.15,293.15,297.15},
    yLower=288) "Heating curve with night set back"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Modelica.Blocks.Sources.BooleanStep booleanStep(startTime=0.5, startValue=
        true) "Step for activating night set back"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
equation

  connect(ramp.y, heatingCurve.u)
    annotation (Line(points={{-19,10},{-0.5,10},{18,10}}, color={0,0,127}));
  connect(heatingCurveSetBack.u, ramp.y) annotation (Line(points={{18,-30},{0,
          -30},{0,-2},{0,10},{-19,10}}, color={0,0,127}));
  connect(booleanStep.y, heatingCurveSetBack.day) annotation (Line(points={{-19,
          -30},{-6,-30},{-6,-26},{18,-26}}, color={255,0,255}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    Documentation(info="<html>
<p>
This example demonstrates the use of a heating curve block.
</p>
</html>"),
    __Dymola_Commands(file=
          "modelica://Annex60/Resources/Scripts/Dymola/Controls/Continuous/Examples/HeatingCurve.mos"
        "Simulate and plot"));
end HeatingCurve;
