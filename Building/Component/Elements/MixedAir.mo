within IDEAS.Building.Component.Elements;
model MixedAir "convective part of the zone"

extends Modelica.Blocks.Interfaces.BlockIcon;

  parameter Integer nSurf(min=1) "number of surfaces in contact with the zone";
  parameter Modelica.SIunits.Volume V "air volume of the zone";
  parameter Real corrCV = 5 "correction factor on the zone air capacity";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a conGain
    "convective internal gains"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b[nSurf] conSurf
    "convective gains on surfaces"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  IDEAS.Building.Component.Elements.HeatCapacity
                           heatCap(C = 1012*1.204*V*corrCV, T(start=293.15))
    "air capacity"                                                                                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,30})));
  Modelica.Blocks.Interfaces.RealOutput TCon "convective zone temperature"
    annotation (Placement(transformation(extent={{20,-20},{-20,20}},
        rotation=90,
        origin={0,-100})));

equation
  connect(conGain, heatCap.port_a) annotation (Line(
      points={{-100,0},{-6.12323e-016,0},{-6.12323e-016,20}},
      color={191,0,0},
      smooth=Smooth.None));

for i in 1:nSurf loop
  connect(heatCap.port_a, conSurf[i]) annotation (Line(
      points={{-6.12323e-016,20},{0,20},{0,0},{100,0}},
      color={191,0,0},
      smooth=Smooth.None));
end for;

TCon = heatCap.T;

  annotation (Diagram(graphics), Icon(graphics={
        Line(
          points={{-100,0},{100,0}},
          color={127,0,0},
          smooth=Smooth.None),
        Line(
          points={{0,20},{0,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Rectangle(
          extent={{-20,30},{20,20}},
          lineColor={127,0,0},
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-20,46},{20,36}},
          lineColor={127,0,0},
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-6,-12},{8,-26}},
          lineColor={0,0,127},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,127}),
        Line(
          points={{0,-20},{0,-80}},
          color={0,0,127},
          smooth=Smooth.None)}));
end MixedAir;
