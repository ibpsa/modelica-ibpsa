within IDEAS.Buildings.Components.BaseClasses;
model ZoneLwDistribution "internal longwave radiative heat exchange"

extends Modelica.Blocks.Interfaces.BlockIcon;

  parameter Integer nSurf(min=1) "number of surfaces in contact with the zone";

  Real[nSurf] F = A ./ (ones(nSurf)*sum(A)-A) "view factor per surface";
  Real[nSurf] R = (ones(nSurf)-epsLw)./(A.*epsLw) + (ones(nSurf)-F)./A
    "heat resistance for logwave radiative heat exchange";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[nSurf] port_a
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  IDEAS.Buildings.Components.BaseClasses.HeatRadiation[nSurf] radRes(R=R);

  Modelica.Blocks.Interfaces.RealInput[nSurf] A "surface areas" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={40,100})));
  Modelica.Blocks.Interfaces.RealInput[nSurf] epsLw
    "longwave surface emissivities"                                                 annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,100})));
equation
for i in 1:nSurf loop
  connect(radRes[i].port_b,port_a[i]);
  end for;

for i in 1:nSurf-1 loop
  connect(radRes[i].port_a,radRes[i+1].port_a);
  end for;

  annotation (Diagram(graphics), Icon(graphics={
        Rectangle(
          extent={{-76.5,5.5},{76.5,-5.5}},
          lineColor={127,0,0},
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid,
          origin={72.5,-0.5},
          rotation=90),
        Line(
          points={{-52,0},{100,0}},
          color={127,0,0},
          smooth=Smooth.None),
        Ellipse(
          extent={{-60,8},{-46,-6}},
          lineColor={127,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={127,0,0}),
        Rectangle(
          extent={{-8,10},{32,-8}},
          lineColor={127,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end ZoneLwDistribution;
