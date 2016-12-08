within IDEAS.Buildings.Components.ZoneAirModels;
model None "Non-physical zone air model that disables convective heat transfer"
  extends IDEAS.Buildings.Components.ZoneAirModels.BaseClasses.PartialAirModel(
    m_flow_nominal=0,
    Vtot=0,
    nSurf=1,
    computeTSensorAsFunctionOfZoneAir=false,
    useFluPor=false);

  Modelica.Blocks.Sources.Constant inf(k=Modelica.Constants.inf)
    "Infinite value to trigger error if this value is used"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixHeaFloAir[nSeg](
    each final T_ref=Medium.T_default,
    each final Q_flow=1e-8,
    each final alpha=-1e16)
    "Very small alpha for avoiding singular system when both ends of the connection set Q_flow=0"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow fixHeaFloSur[nSurf](
    each final Q_flow=0,
    each final T_ref=Medium.T_default,
    each final alpha=1e-8)
    "Very small alpha for avoiding singular system when both ends of the connection set Q_flow=0"
    annotation (Placement(transformation(extent={{-60,-10},{-80,10}})));
  Modelica.Blocks.Sources.Constant zero(k=0)
    "Constant output for relative humidity"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
equation
  E=0;
  QGai=0;

  connect(inf.y,TAir)
    annotation (Line(points={{61,-60},{84,-60},{108,-60}},
                                                  color={0,0,127}));
  connect(fixHeaFloSur.port, ports_surf)
    annotation (Line(points={{-80,0},{-90,0},{-100,0}}, color={191,0,0}));
  connect(fixHeaFloAir.port, ports_air)
    annotation (Line(points={{80,0},{100,0}}, color={191,0,0}));
  connect(zero.y, phi)
    annotation (Line(points={{61,-40},{108,-40}}, color={0,0,127}));
  annotation (Documentation(revisions="<html>
<ul>
<li>
November 15, 2016 by Filip Jorissen:<br/>
Revised documentation.
</li>
<li>
August 26, 2016 by Filip Jorissen:<br/>
Added support for conservation of energy.
</li>
<li>
July 18, 2016 by Filip Jorissen:<br/>
First implementation
</li>
</ul>
</html>", info="<html>
<p>
Zone air model for debugging purposes only.
</p>
</html>"));
end None;
