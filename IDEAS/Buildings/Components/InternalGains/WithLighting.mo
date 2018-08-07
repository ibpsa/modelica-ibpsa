within IDEAS.Buildings.Components.InternalGains;
model WithLighting "internal gains model including lighting gains"
  extends Simple;

  parameter Modelica.SIunits.Power lightPow = 3*A "total lighting power installed in the zone in Watts";
  parameter Modelica.SIunits.Area A = A "zone area";

protected
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaFloRad1(final
      alpha=0) "Prescribed heat flow rate for radiative sensible heat"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
protected
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaFloLightRad(final
      alpha=0) "Prescribed heat flow rate for light radiative sensible heat"
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
public
  Modelica.Blocks.Sources.RealExpression realExpression(y=if nOcc > 0 then
        lightPow else 0)
    annotation (Placement(transformation(extent={{-10,-100},{10,-80}})));
equation
  connect(realExpression.y, preHeaFloLightRad.Q_flow)
    annotation (Line(points={{11,-90},{40,-90}}, color={0,0,127}));
  connect(preHeaFloLightRad.port, portRad)
    annotation (Line(points={{60,-90},{100,-90},{100,-60}}, color={191,0,0}));
end WithLighting;
