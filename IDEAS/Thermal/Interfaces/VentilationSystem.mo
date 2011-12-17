within IDEAS.Thermal.Interfaces;
partial model VentilationSystem

  parameter Integer nZones(min=1) "number of conditioned thermal zones";
  parameter Integer nLoads(min=1) "number of electric loads";
  parameter Real[nZones] VZones "conditioned (C) volumes (V) of the zones";
  parameter Modelica.SIunits.HeatCapacity[nZones] C = 1012*1.204*VZones*5
    "Heat capacity of the conditioned zones";

  outer IDEAS.Climate.SimInfoManager  sim
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[nZones] conv
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.PositivePin[nLoads]
    pin
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  annotation(Icon(graphics={
        Polygon(
          points={{6,62},{32,48},{32,18},{34,18},{44,26},{44,-26},{10,-24},{42,-42},
              {42,-74},{76,-40},{76,56},{48,76},{46,76},{6,62}},
          lineColor={127,0,0},
          smooth=Smooth.None,
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{6,62},{6,30},{32,18}},
          color={127,0,0},
          smooth=Smooth.None),
        Line(
          points={{10,-24},{10,-56},{42,-74}},
          color={127,0,0},
          smooth=Smooth.None)}),                                    Diagram(
        graphics));

end VentilationSystem;
