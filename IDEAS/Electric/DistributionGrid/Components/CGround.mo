within IDEAS.Electric.DistributionGrid.Components;
model CGround

          IDEAS.Electric.BaseClasses.CPosPin
                  p annotation (Placement(transformation(
              origin={0,100},
              extent={{10,-10},{-10,10}},
              rotation=270)));
equation
        p.v = 0+0*Modelica.ComplexMath.j;
       annotation (
          Documentation(info="<html>
<p>Ground of an electrical circuit. The potential at the ground node is zero. Every electrical circuit has to contain at least one ground object.</p>
</html>",
       revisions="<html>
<ul>
<li><i> 1998   </i>
       by Christoph Clauss<br> initially implemented<br>
       </li>
</ul>
</html>"),Icon(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics={
              Line(points={{-60,50},{60,50}}, color={0,0,255}),
              Line(points={{-40,30},{40,30}}, color={0,0,255}),
              Line(points={{-20,10},{20,10}}, color={0,0,255}),
              Line(points={{0,90},{0,50}}, color={0,0,255}),
              Text(
                extent={{-144,-19},{156,-59}},
                textString="%name",
                lineColor={0,0,255})}),
          Diagram(coordinateSystem(
              preserveAspectRatio=true,
              extent={{-100,-100},{100,100}},
              grid={2,2}), graphics={
              Line(
                points={{-60,50},{60,50}},
                thickness=0.5,
                color={0,0,255}),
              Line(
                points={{-40,30},{40,30}},
                thickness=0.5,
                color={0,0,255}),
              Line(
                points={{-20,10},{20,10}},
                thickness=0.5,
                color={0,0,255}),
              Line(
                points={{0,96},{0,50}},
                thickness=0.5,
                color={0,0,255}),
              Text(
                extent={{-24,-38},{22,-6}},
                textString="p.v=0",
                lineColor={0,0,255})}));
end CGround;
