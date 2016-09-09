within Annex60.Experimental.Pipe.BaseClasses.Examples;
model TimeDelayComparison
  "Comparison of different time delay implementations"
  import Annex60;
  extends Modelica.Icons.Example;

  Annex60.Experimental.Pipe.BaseClasses.PDETime_massFlowMod pDETime_massFlowMod(length=
        length, diameter=diameter)
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(table=[-50,1; 20,1; 23,
        0; 30,0; 33,-1; 40,-1; 43,0; 100,0], timeScale=3)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Annex60.Experimental.Pipe.BaseClasses.PDETime_massFlow pDETime_massFlow(
      diameter=diameter, len=length)
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  parameter Modelica.SIunits.Length length=20 "Pipe length";
  parameter Modelica.SIunits.Length diameter=0.01 "diameter of pipe";
equation
  connect(combiTimeTable.y[1], pDETime_massFlowMod.m_flow)
    annotation (Line(points={{-39,0},{-20,0},{-20,30},{0,30},{18,30}},
                                                       color={0,0,127}));
  connect(combiTimeTable.y[1], pDETime_massFlow.m_flow) annotation (Line(points=
         {{-39,0},{-20,0},{-20,-30},{18,-30}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Simplest example involving a delay tracker of type <a href=\"modelica://Annex60/Experimental/Pipe/BaseClasses/PDETime_massFlowMod.mo\">PDETime_massFlowMod</a>.</p>
</html>", revisions="<html>
<ul>
<li>September 8, 2016 by Bram van der Heijde <br>First implementation.</li>
</ul>
</html>"),
    experiment(
      StartTime=-50,
      StopTime=50,
      Interval=1),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Experimental/Pipe/BaseClasses/Examples/PDETime_massFlowMod.mos"
        "Simulate and Plot"));
end TimeDelayComparison;
