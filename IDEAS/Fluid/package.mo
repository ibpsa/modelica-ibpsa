within IDEAS;
package Fluid "Package with models for fluid flow systems"
  extends Modelica.Icons.Package;


annotation (
preferredView="info", Documentation(info="<html>
This package contains components for fluid flow systems such as
pumps, valves and sensors. For other fluid flow models, see 
<a href=\"modelica://Modelica.Fluid\">Modelica.Fluid</a>.
</html>"),
Icon(graphics={
        Polygon(points={{-70,26},{68,-44},{68,26},{2,-10},{-70,-42},{-70,26}},
            lineColor={0,0,0}),
        Line(points={{2,42},{2,-10}}, color={0,0,0}),
        Rectangle(
          extent={{-18,50},{22,42}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}));
end Fluid;
