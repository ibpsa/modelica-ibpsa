within IDEAS.Buildings.Components.BaseClasses;
model InteriorConvection "interior surface convection"

  parameter Modelica.SIunits.Area A "surface area";
  parameter Modelica.SIunits.Angle inc "inclination";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a(T(start=289.15))
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b(T(start=289.15))
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

protected
  Modelica.SIunits.TemperatureDifference dT;
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
dT = port_a.T-port_b.T;

  annotation (Icon(graphics={
        Rectangle(
          extent={{-90,80},{-60,-80}},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward,
          pattern=LinePattern.None),
        Line(points={{-60,20},{76,20}}, color={191,0,0}),
        Line(points={{-34,80},{-34,-80}}, color={0,127,255}),
        Line(points={{-60,-20},{76,-20}}, color={191,0,0}),
        Line(points={{56,30},{76,20}}, color={191,0,0}),
        Line(points={{56,10},{76,20}}, color={191,0,0}),
        Line(points={{56,-10},{76,-20}}, color={191,0,0}),
        Line(points={{56,-30},{76,-20}}, color={191,0,0}),
        Line(points={{6,80},{6,-80}}, color={0,127,255}),
        Line(points={{40,80},{40,-80}}, color={0,127,255}),
        Line(points={{76,80},{76,-80}}, color={0,127,255}),
        Line(points={{-34,-80},{-44,-60}}, color={0,127,255}),
        Line(points={{-34,-80},{-24,-60}}, color={0,127,255}),
        Line(points={{6,-80},{-4,-60}}, color={0,127,255}),
        Line(points={{6,-80},{16,-60}}, color={0,127,255}),
        Line(points={{40,-80},{30,-60}}, color={0,127,255}),
        Line(points={{40,-80},{50,-60}}, color={0,127,255}),
        Line(points={{76,-80},{66,-60}}, color={0,127,255}),
        Line(points={{76,-80},{86,-60}}, color={0,127,255}),
        Text(
          extent={{-150,-90},{150,-130}},
          textString="%name",
          lineColor={0,0,255}),
        Line(
          points={{-60,80},{-60,-80}},
          color={0,0,0},
          thickness=0.5)}));
end InteriorConvection;
