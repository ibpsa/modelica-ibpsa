within IDEAS.Templates.BaseCircuits.BaseClasses;
connector FluidTwoPort "For automatically connecting supply and return pipes"
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium model" annotation (choicesAllMatching=true);

  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium=Medium);
  Modelica.Fluid.Interfaces.FluidPort_a port_b(redeclare package Medium=Medium);

  annotation (Icon(graphics={             Ellipse(
          extent={{-100,50},{0,-50}},
          lineColor={0,0,0},
          fillColor={0,127,255},
          fillPattern=FillPattern.Solid), Ellipse(
          extent={{0,50},{100,-50}},
          lineColor={0,0,0},
          fillColor={0,127,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{8,42},{92,-42}},
          lineColor={0,127,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}), Documentation(revisions="<html>
<p><ul>
<li>November 2014 by Filip Jorissen:<br> 
Initial version</li>
</ul></p>
</html>"));
end FluidTwoPort;
