within Annex60.Experimental.Pipe.BaseClasses.Examples;
model PDETime_massFlowMod "Unit test of PDETime_massFlowMod"
  import Annex60;
  extends Modelica.Icons.Example;

  Annex60.Experimental.Pipe.BaseClasses.PDETime_massFlowMod pDETime_massFlowMod(diameter=
        0.01, length=20)
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(table=[-50,1; 20,1; 23,
        0; 30,0; 33,-1; 40,-1; 43,0; 100,0], timeScale=3)
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
equation
  connect(combiTimeTable.y[1], pDETime_massFlowMod.m_flow)
    annotation (Line(points={{21,10},{40,10},{58,10}}, color={0,0,127}));
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
end PDETime_massFlowMod;
