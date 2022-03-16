within IBPSA.ThermalZones.ISO13790.BaseClasses;
model GainSurface "Surface node heat flow"

  Real Am;
  Real At;
  parameter Real HwinG;
  parameter Real f_ms;
  parameter Real Af;
  parameter Real f_at;

  Modelica.Blocks.Interfaces.RealInput intG
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealInput solG
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealOutput y=(1 - Am/At - HwinG/(9.1*At))*(
        0.5*intG + solG)
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  Am  = f_ms*Af;
  At  = f_at*Af;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
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
        coordinateSystem(preserveAspectRatio=false)));
end GainSurface;
