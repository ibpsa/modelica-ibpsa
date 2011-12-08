within IDEAS.Building.Component.Elements;
model ExteriorConvection "exterior surface convection"

extends IDEAS.Building.Elements.StateSingle;
extends Modelica.Blocks.Interfaces.BlockIcon;

  outer IDEAS.SimInfoManager sim "simulation information manager";

  parameter Modelica.SIunits.Area A "surface area";

protected
  Real hcon "equivalent surface conductance";

equation
if noEvent(sim.Va <= 5) then
  hcon = 4.0 * sim.Va + 5.6;
else
  hcon = 7.1*abs(sim.Va)^(0.78);
end if;

port_a.Q_flow = hcon*A*(port_a.T-sim.Te);

  annotation (Diagram(graphics), Icon(graphics={
        Rectangle(
          extent={{-76.5,5.5},{76.5,-5.5}},
          lineColor={127,0,0},
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid,
          origin={-65.5,-0.5},
          rotation=90),
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
          fillPattern=FillPattern.Solid)}));
end ExteriorConvection;
