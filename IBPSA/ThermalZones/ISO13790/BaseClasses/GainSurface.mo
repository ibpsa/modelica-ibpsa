within IBPSA.ThermalZones.ISO13790.BaseClasses;
model GainSurface "Surface node heat flow"

  Real Am;
  parameter Real At;
  parameter Real HwinG;
  parameter Real f_ms;
  parameter Real Af;


  Modelica.Blocks.Interfaces.RealInput intG
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealInput solG
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealOutput y=(1 - Am/At - HwinG/(9.1*At))*(
        0.5*intG + solG)
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  Am  = f_ms*Af;

  annotation (defaultComponentName="phiSur",Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{28,-46},{-26,-100}},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Text(
          extent={{-110,138},{112,106}},
          lineColor={0,0,255},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This model calculates the heat gains injected to the surface node. More information
can be found in the documentation of <a href=\"modelica://IBPSA.ThermalZones.ISO13790.Zone5R1C.Zone\">
IBPSA.ThermalZones.ISO13790.Zone5R1C.Zone</a>
</p>
</html>", revisions="<html><ul>
<li>
Mar 16, 2022, by Alessandro Maccarini:<br/>
First implementation.
</li>
</ul></html>"));
end GainSurface;
