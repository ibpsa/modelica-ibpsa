within IDEAS.Electric.Photovoltaic.Components;
class SimpleInverter

  extends Modelica.Electrical.Analog.Interfaces.TwoPort;
  //v1,i1 =DC  <-> v2,i2 = AC
  extends Modelica.Blocks.Interfaces.BlockIcon;

  parameter Real eff=0.95;
  //For now
  flow Modelica.SIunits.ActivePower P_dc;
  flow Modelica.SIunits.ActivePower P;
  flow Modelica.SIunits.ApparentPower S;
  flow Modelica.SIunits.ReactivePower Q;
  parameter Real cosphi=1;
  //For now

equation
  S^2 = P^2 + Q^2;
  P = S*cosphi;
  P = eff*P_dc;
  P_dc = i1*v1;
  p2.v = 230;
  // Should also be V_node, but since p2.i depends on p2.v and P, P calculated in DCGrid is not dependent on this p2.v
  p2.v*p2.i = P;

  annotation (Icon(graphics={Text(
          extent={{-100,20},{-40,-20}},
          lineColor={0,0,0},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid,
          textString="DC"),Text(
          extent={{40,20},{100,-20}},
          lineColor={0,0,0},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid,
          textString="AC"),Line(
          points={{-36,0},{36,0},{0,12},{0,-12},{36,0}},
          color={0,0,0},
          smooth=Smooth.None)}));
end SimpleInverter;
