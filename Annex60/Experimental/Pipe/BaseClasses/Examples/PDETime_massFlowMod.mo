within Annex60.Experimental.Pipe.BaseClasses.Examples;
model PDETime_massFlowMod "Unit test of PDETime_massFlowMod"
  import Annex60;
  extends Modelica.Icons.Example;

  Annex60.Experimental.Pipe.BaseClasses.PDETime_massFlowMod pDETime_massFlowMod(
      length=4, diameter=0.1)
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=1,
    duration=3,
    startTime=3)
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.Ramp ramp1(
    height=-1,
    duration=3,
    startTime=20)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Modelica.Blocks.Sources.Ramp ramp2(
    height=-1,
    duration=3,
    startTime=30)
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Modelica.Blocks.Sources.Ramp ramp3(
    height=1,
    duration=3,
    startTime=40)
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Modelica.Blocks.Math.Sum sum1(nin=4)
    annotation (Placement(transformation(extent={{-20,20},{0,0}})));
equation
  connect(sum1.y, pDETime_massFlowMod.m_flow)
    annotation (Line(points={{1,10},{18,10}}, color={0,0,127}));
  connect(ramp.y, sum1.u[1]) annotation (Line(points={{-59,50},{-40,50},{-40,
          11.5},{-22,11.5}}, color={0,0,127}));
  connect(ramp1.y, sum1.u[2])
    annotation (Line(points={{-59,10},{-22,10},{-22,10.5}}, color={0,0,127}));
  connect(ramp2.y, sum1.u[3]) annotation (Line(points={{-59,-30},{-42,-30},{-42,
          9.5},{-22,9.5}}, color={0,0,127}));
  connect(ramp3.y, sum1.u[4]) annotation (Line(points={{-59,-70},{-40,-70},{-40,
          8.5},{-22,8.5}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Simplest example involving a delay tracker of type <a href=\"modelica://Annex60/Experimental/Pipe/BaseClasses/PDETime_massFlowMod.mo\">PDETime_massFlowMod</a>.</p>
</html>", revisions="<html>
<ul>
<li>September 8, 2016 by Bram van der Heijde <br>First implementation.</li>
</ul>
</html>"),
    experiment(StopTime=50, Interval=1),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Experimental/Pipe/BaseClasses/Examples/PDETime_massFlowMod.mos"
        "Simulate and Plot"));
end PDETime_massFlowMod;
