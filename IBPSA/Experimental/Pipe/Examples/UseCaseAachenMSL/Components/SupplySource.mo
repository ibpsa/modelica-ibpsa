within IBPSA.Experimental.Pipe.Examples.UseCaseAachenMSL.Components;
model SupplySource "A simple supply model with source"

  extends UseCaseAachen.Components.SupplySource;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid), Polygon(
          points={{-80,80},{-80,-80},{76,0},{-80,80}},
          lineColor={28,108,200},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)),
  Documentation(revisions="<html>
<ul>
<li>December 12, 2016 by Marcus Fuchs:<br>First implementation. </li>
</ul>
</html>"));

end SupplySource;
