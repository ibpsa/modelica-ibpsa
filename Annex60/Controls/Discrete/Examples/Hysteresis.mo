within Annex60.Controls.Discrete.Examples;
model Hysteresis "Example of a hysteresis controller"
  import Annex60;
  extends Modelica.Icons.Example;
  Annex60.Controls.Discrete.Hysteresis hysteresis
    "Normal hysteresis implementation"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Modelica.Blocks.Sources.Cosine cosine(amplitude=2, freqHz=5) "Input signal"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Annex60.Controls.Discrete.Hysteresis hysteresisInvert(invert=true)
    "Hysteresis with output inversion"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Annex60.Controls.Discrete.Hysteresis hysteresisVariableBounds(useBoundInput=
        true) "Hysteresis with variable upper and lower bounds"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Annex60.Controls.Discrete.Hysteresis hysteresisHysDelta(useHysDelta=true,
      hysDelta=0.1) "Hysteresis with constant delta"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  Modelica.Blocks.Sources.Ramp rampUpper(
    duration=1,
    offset=1,
    height=1) "Upper bound ramp"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Blocks.Sources.Ramp rampLower(
    duration=1,
    offset=0,
    height=-1) "Lower bound ramp"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
equation
  connect(cosine.y, hysteresisInvert.u)
    annotation (Line(points={{-39,10},{-20,10},{-2,10}}, color={0,0,127}));
  connect(cosine.y, hysteresis.u) annotation (Line(points={{-39,10},{-22,10},{
          -22,50},{-2,50}}, color={0,0,127}));
  connect(cosine.y, hysteresisHysDelta.u) annotation (Line(points={{-39,10},{
          -22,10},{-22,-70},{-2,-70}}, color={0,0,127}));
  connect(cosine.y, hysteresisVariableBounds.u) annotation (Line(points={{-39,
          10},{-22,10},{-22,-30},{-2,-30}}, color={0,0,127}));
  connect(rampUpper.y, hysteresisVariableBounds.uHigh) annotation (Line(points=
          {{-39,-30},{-26,-30},{-26,-24},{-2,-24}}, color={0,0,127}));
  connect(rampLower.y, hysteresisVariableBounds.uLow) annotation (Line(points={
          {-39,-70},{-26,-70},{-26,-36},{-2,-36}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    __Dymola_Commands(file=
          "modelica://Annex60/Resources/Scripts/Dymola/Controls/Discrete/Examples/Hysteresis.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example demonstrates the use of the various options of the hysteresis controller.
</p>
</html>", revisions="<html>
<ul>
<li>
September 19, 2015, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
end Hysteresis;
