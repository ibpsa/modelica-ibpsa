within IDEAS.Buildings.Components.BaseClasses;
model Ventilation "zone ventilation"

extends IDEAS.Buildings.Components.Interfaces.StateSingle;
extends Modelica.Blocks.Interfaces.BlockIcon;

  outer IDEAS.Climate.SimInfoManager
                             sim "Simulation information manager";

  parameter Modelica.SIunits.Volume V "zone air volume";
  parameter Real ACH = 0.5 "ventilation rate";
  parameter Real n50 = 0 "n50-value of airtightness";
  parameter Modelica.SIunits.Efficiency RecupEff = 0.84
    "efficientie on heat recuperation of ventilation air";

  parameter Boolean recuperation = false "true if recuperation is present";

equation
if noEvent(time > 8E6) and noEvent(time <2.6E7) and recuperation then
  port_a.Q_flow=(port_a.T-sim.Te)*1012*1.204*V/3600*(n50/20+ACH*(1-RecupEff));
else
  port_a.Q_flow=(port_a.T-sim.Te)*1012*1.204*V/3600*(n50/20+ACH);
end if;

  annotation (Icon(graphics={
        Rectangle(
          extent={{-76.5,5.5},{76.5,-5.5}},
          lineColor={127,0,0},
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid,
          origin={-63.5,-0.5},
          rotation=90),
        Line(
          points={{-98,0},{54,0}},
          color={127,0,0},
          smooth=Smooth.None),
        Ellipse(
          extent={{46,8},{60,-6}},
          lineColor={127,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={127,0,0}),
        Rectangle(
          extent={{-28,10},{12,-8}},
          lineColor={127,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end Ventilation;
