within IDEAS.Building.Component.Elements;
model MonoLayerOpaque "single material layer"

extends IDEAS.Building.Elements.StateDouble;

  parameter Modelica.SIunits.Area A "layer area";
  parameter IDEAS.Building.Elements.Material mat "layer material";
  parameter Modelica.SIunits.Angle inc "inclination";

  final parameter Real R = mat.d / mat.k "total specific thermal resistance";

//protected
  final parameter Integer nRes = mat.nState * 2
    "number of resistors in the RC-network";
  final parameter Integer nCap = mat.nState * 2 - 1
    "odd number of capacitors in the RC-network";
  IDEAS.Building.Component.Elements.HeatResistor[nRes] Res(each final A=A, each final R=mat.d/
        mat.k/nRes) "number of resistors in the RC-network";
  IDEAS.Building.Component.Elements.HeatCapacity[nCap] Cap(each final C=A*mat.rho*mat.c*mat.d/
        nCap) "number of capacitors in the RC-network";

public
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_gain
    "port for gains by embedded active layers"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));

equation
connect(port_a,Res[1].port_a);
connect(Res[nRes].port_b,port_b);

  for k in 1:nCap loop
    connect(Res[k].port_b,Cap[k].port_a);
    connect(Cap[k].port_a,Res[k+1].port_a);
  end for;

connect(port_gain,Cap[mat.nState].port_a);

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
          points={{0,20},{0,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Rectangle(
          extent={{-20,44},{20,34}},
          lineColor={127,0,0},
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-20,30},{20,20}},
          lineColor={127,0,0},
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{0,96},{0,36}},
          color={127,0,0},
          smooth=Smooth.None)}));
end MonoLayerOpaque;
