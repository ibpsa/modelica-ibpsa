within IDEAS.Templates.Ventilation.Examples;
model none
  "Model that illustrates redeclarations using the ventilation system"
  extends IDEAS.Templates.Ventilation.Examples.ConstantAirFlowRecup(
    redeclare IDEAS.Templates.Ventilation.None constantAirFlowRecup);
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics),
    Documentation(info="<html>
<p>
Model demonstrating the use of the ventilation system template 
by redeclaring the ventilation model of 
<a href=modelica://IDEAS.Templates.Ventilation.Examples.ConstantAirFlowRecup>ConstantAirFlowRecup</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 23, 2017 by Glenn Reynders:<br/>
Revised implementation
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://IDEAS/Resources/Scripts/Dymola/Templates/Ventilation/Examples/none.mos"
        "Simulate and Plot"));
end none;
