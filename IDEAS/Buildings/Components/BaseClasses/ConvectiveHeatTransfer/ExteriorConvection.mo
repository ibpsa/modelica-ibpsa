within IDEAS.Buildings.Components.BaseClasses.ConvectiveHeatTransfer;
model ExteriorConvection "exterior surface convection"

  parameter Modelica.SIunits.Area A "surface area";
  parameter Boolean linearise = false "Use constant convection coefficient"
    annotation(Evaluate=true);
  parameter Modelica.SIunits.CoefficientOfHeatTransfer hConExtLin = 18.3
    "Fixed exterior convection coefficient used when linearising equations"
     annotation(Dialog(enable=linearize));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));

  Modelica.Blocks.Interfaces.RealInput Te(unit="K",displayUnit="degC")
    annotation (Placement(transformation(extent={{-120,-68},{-80,-28}})));
  Modelica.Blocks.Interfaces.RealInput hConExt(unit="W/(m2.K)")
    "Exterior convective heat transfer coefficient"
    annotation (Placement(transformation(extent={{-120,-110},{-80,-70}})));

equation
  if linearise then
    port_a.Q_flow = A*hConExtLin *(port_a.T - Te);
  else
    port_a.Q_flow = A*hConExt*(port_a.T - Te);
  end if;

  annotation (Icon(graphics={
        Rectangle(
          extent={{-90,80},{-60,-80}},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None),
        Line(points={{-60,20},{76,20}}, color={191,0,0}),
        Line(points={{-34,80},{-34,-80}}, color={0,127,255}),
        Line(points={{-60,-20},{76,-20}}, color={191,0,0}),
        Line(points={{56,30},{76,20}}, color={191,0,0}),
        Line(points={{56,10},{76,20}}, color={191,0,0}),
        Line(points={{56,-10},{76,-20}}, color={191,0,0}),
        Line(points={{56,-30},{76,-20}}, color={191,0,0}),
        Line(points={{6,80},{6,-80}}, color={0,127,255}),
        Line(points={{40,80},{40,-80}}, color={0,127,255}),
        Line(points={{76,80},{76,-80}}, color={0,127,255}),
        Line(points={{-34,-80},{-44,-60}}, color={0,127,255}),
        Line(points={{-34,-80},{-24,-60}}, color={0,127,255}),
        Line(points={{6,-80},{-4,-60}}, color={0,127,255}),
        Line(points={{6,-80},{16,-60}}, color={0,127,255}),
        Line(points={{40,-80},{30,-60}}, color={0,127,255}),
        Line(points={{40,-80},{50,-60}}, color={0,127,255}),
        Line(points={{76,-80},{66,-60}}, color={0,127,255}),
        Line(points={{76,-80},{86,-60}}, color={0,127,255}),
        Text(
          extent={{-150,-90},{150,-130}},
          textString="%name",
          lineColor={0,0,255}),
        Line(
          points={{-60,80},{-60,-80}},
          color={0,0,0},
          thickness=0.5)}), Documentation(info="<html>
<p>The exterior convective heat flow is computed as </p>
<p align=\"center\"><img src=\"modelica://IDEAS/Images/equations/equation-dlroqBUD.png\"/></p>
<p>where <img src=\"modelica://IDEAS/Images/equations/equation-pvb42RGk.png\"/> is the surface area, <img src=\"modelica://IDEAS/Images/equations/equation-EFr6uClx.png\"/> is the dry-bulb exterior air temperature, <img src=\"modelica://IDEAS/Images/equations/equation-9BU57cj4.png\"/> is the surface temperature and <img src=\"modelica://IDEAS/Images/equations/equation-HvwkeunV.png\"/> is the wind speed in the undisturbed flow at 10 meter above the ground and where the stated correlation is valid for a <img src=\"modelica://IDEAS/Images/equations/equation-HvwkeunV.png\"/> range of [0.15,7.5] meter per second <a href=\"IDEAS.Buildings.UsersGuide.References\">[Defraeye 2011]</a>. The <img src=\"modelica://IDEAS/Images/equations/equation-HvwkeunV.png\"/>-dependent term denoting the exterior convective heat transfer coefficient <img src=\"modelica://IDEAS/Images/equations/equation-W7Ft8vaa.png\"/> is determined as <img src=\"modelica://IDEAS/Images/equations/equation-aZcbMNkz.png\"/> in order to take into account buoyancy effects at low wind speeds <a href=\"IDEAS.Buildings.UsersGuide.References\">[Jurges 1924]</a>.</p>
</html>", revisions="<html>
<ul>
<li>
November 15, 2016, by Filip Jorissen:<br/>
Revised documentation for IDEAS 1.0.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end ExteriorConvection;
