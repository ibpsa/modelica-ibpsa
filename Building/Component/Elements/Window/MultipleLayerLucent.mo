within IDEAS.Building.Component.Elements.Window;
model MultipleLayerLucent "multiple non-opaque layers"

extends IDEAS.Building.Elements.StateDouble;
extends Modelica.Blocks.Interfaces.BlockIcon;

  parameter Modelica.SIunits.Area A "surface area";
  parameter Modelica.SIunits.Angle inc "inclination";
  parameter Integer nLay(min=1) "input: number of layers";
  parameter BWF.Bui.Mat mats[nLay] "input";

  IDEAS.Building.Component.Elements.Window.SingleLayerLucent[
                                                       nLay] nMat(
    each final A=A,
    each final inc=inc,
    mat=mats);

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[nLay] port_gain
    "port for gains by embedded active layers"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  Modelica.Blocks.Interfaces.RealOutput iEpsLw_b
    "output of the interior emissivity for radiative heat losses"
    annotation (Placement(transformation(extent={{90,70},{110,90}})));
  Modelica.Blocks.Interfaces.RealOutput iEpsSw_b
    "output of the interior emissivity for radiative heat losses"
    annotation (Placement(transformation(extent={{90,30},{110,50}})));
  Modelica.Blocks.Interfaces.RealOutput iEpsLw_a
    "output of the interior emissivity for radiative heat losses"
    annotation (Placement(transformation(extent={{-90,70},{-110,90}})));
  Modelica.Blocks.Interfaces.RealOutput iEpsSw_a
    "output of the interior emissivity for radiative heat losses"
    annotation (Placement(transformation(extent={{-90,30},{-110,50}})));

equation
connect(port_a,nMat[1].port_a);

  for j in 1:nLay-1 loop
    connect(nMat[j].port_b,nMat[j+1].port_a);
  end for;

connect(nMat.port_gain,port_gain);
connect(port_b,nMat[nLay].port_b);

iEpsLw_a = mats[1].epsLw;
iEpsSw_a = mats[1].epsSw;
iEpsLw_b = mats[nLay].epsLw;
iEpsSw_b = mats[nLay].epsSw;
  annotation (Diagram(graphics), Icon(graphics={
        Line(
          points={{-100,0},{100,0}},
          color={127,0,0},
          smooth=Smooth.None),
        Rectangle(
          extent={{-68,10},{-28,-8}},
          lineColor={127,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{26,10},{66,-8}},
          lineColor={127,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255}),
        Line(
          points={{0,0},{0,-20}},
          color={0,0,0},
          smooth=Smooth.None),
        Rectangle(
          extent={{-20,-20},{20,-30}},
          lineColor={127,0,0},
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-20,-36},{20,-46}},
          lineColor={127,0,0},
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{0,-40},{0,-100}},
          color={127,0,0},
          smooth=Smooth.None)}));
end MultipleLayerLucent;
