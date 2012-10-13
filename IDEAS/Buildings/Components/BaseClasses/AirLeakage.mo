within IDEAS.Buildings.Components.BaseClasses;
model AirLeakage "air leakage due to limied air tightness"

  parameter Modelica.SIunits.Volume V "zone air volume";
  parameter Real n50 = 0 "n50-value of airtightness";

Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a(T(start=289.15))
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
outer IDEAS.SimInfoManager sim "Simulation information manager"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));

equation
  port_a.Q_flow=(port_a.T-sim.Te)*1012*1.204*V/3600*n50/20;

  annotation (Icon(graphics={
        Line(points={{-30,80},{-30,-80}}, color={0,127,255}),
        Line(points={{-30,-80},{-40,-60}}, color={0,127,255}),
        Line(points={{-30,-80},{-20,-60}}, color={0,127,255}),
        Line(points={{10,-80},{0,-60}}, color={0,127,255}),
        Line(points={{10,80},{10,-80}},
                                      color={0,127,255}),
        Line(points={{10,-80},{20,-60}},color={0,127,255}),
        Line(points={{44,-80},{34,-60}}, color={0,127,255}),
        Line(points={{44,80},{44,-80}}, color={0,127,255}),
        Line(points={{44,-80},{54,-60}}, color={0,127,255}),
        Line(points={{80,-80},{70,-60}}, color={0,127,255}),
        Line(points={{80,80},{80,-80}}, color={0,127,255}),
        Line(points={{80,-80},{90,-60}}, color={0,127,255}),
        Line(points={{-60,-80},{-70,-60}}, color={0,127,255}),
        Line(points={{-60,80},{-60,-80}}, color={0,127,255}),
        Line(points={{-60,-80},{-50,-60}}, color={0,127,255})}));
end AirLeakage;
