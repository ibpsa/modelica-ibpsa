within IDEAS.Elements;
package Testers "Testers of the models in this package"


  annotation (             Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={
        Rectangle(
          extent={{-100,-100},{80,50}},
          lineColor={175,175,175},
          fillColor={248,248,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-100,50},{-80,70},{100,70},{80,50},{-100,50}},
          lineColor={175,175,175},
          fillColor={248,248,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{100,70},{100,-80},{80,-100},{80,50},{100,70}},
          lineColor={175,175,175},
          fillColor={248,248,255},
          fillPattern=FillPattern.Solid)}));
end Testers;
