within IDEAS.Building.Component.Elements.Wall;
model InteriorConvection "interior surface convection"

extends IDEAS.Building.Elements.StateDouble;
extends Modelica.Blocks.Interfaces.BlockIcon;

  parameter Modelica.SIunits.Area A "surface area";
  parameter Modelica.SIunits.Angle inc "inclination";

protected
  final parameter Boolean Ceiling = abs(sin(inc)) < 10E-5 and cos(inc) > 0
    "true if ceiling";
  final parameter Boolean Floor =  abs(sin(inc)) < 10E-5 and cos(inc) < 0
    "true if floor";

equation
if Ceiling then
  port_a.Q_flow = if noEvent(dT>0) then A*2.72*abs(dT)^1.13 else -A*2.27*abs(dT)^1.24;
elseif Floor then
  port_a.Q_flow = if noEvent(dT>0) then A*2.27*abs(dT)^1.24 else -A*2.72*abs(dT)^1.13;
else
  port_a.Q_flow = A * sign(dT)*2.07*abs(dT)^1.23;
end if;

port_a.Q_flow + port_b.Q_flow = 0 "no heat is stored";

  annotation (Icon(graphics={
        Line(
          points={{-100,0},{52,0}},
          color={127,0,0},
          smooth=Smooth.None),
        Ellipse(
          extent={{44,8},{58,-6}},
          lineColor={127,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={127,0,0}),
        Rectangle(
          extent={{-30,10},{10,-8}},
          lineColor={127,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-76.5,5.5},{76.5,-5.5}},
          lineColor={127,0,0},
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid,
          origin={-65.5,-0.5},
          rotation=90)}));
end InteriorConvection;
