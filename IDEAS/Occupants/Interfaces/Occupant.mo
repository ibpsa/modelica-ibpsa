within IDEAS.Occupants.Interfaces;
partial model Occupant

  outer IDEAS.Climate.SimInfoManager  sim
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));

parameter Integer nZones(min=1) "number of conditioned thermal zones";
parameter Integer nLoads(min=1) "number of electric loads";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[nZones] heatPortCon
    annotation (Placement(transformation(extent={{-110,10},{-90,30}}),
        iconTransformation(extent={{-110,10},{-90,30}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b[nZones] heatPortRad
    annotation (Placement(transformation(extent={{-110,-30},{-90,-10}}),
        iconTransformation(extent={{-110,-30},{-90,-10}})));
  Modelica.Blocks.Interfaces.RealOutput[nZones] TSet
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,100})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Interfaces.PositivePin[nLoads]
    pin
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Electric.BaseClasses.OhmsLaw[nLoads] ohmsLaw
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
equation
  connect(ohmsLaw.pin, pin) annotation (Line(
      points={{80,0},{100,0}},
      color={85,170,255},
      smooth=Smooth.None));
  annotation(Icon(graphics={
        Ellipse(extent={{-12,74},{12,48}}, lineColor={127,0,0}),
        Polygon(
          points={{4,48},{-4,48},{-8,44},{-14,32},{-18,16},{-20,-6},{-14,-20},{14,
              -20},{-14,-20},{-10,-46},{-8,-56},{-8,-64},{-8,-72},{-10,-76},{4,-76},
              {4,-64},{2,-56},{2,-46},{4,-38},{8,-40},{12,-42},{12,-54},{12,-64},
              {14,-70},{18,-76},{24,-76},{22,-64},{22,-56},{22,-48},{24,-40},{24,
              -30},{22,-24},{20,-18},{18,-8},{18,4},{18,12},{18,14},{18,26},{14,
              38},{10,44},{8,46},{4,48}},
          lineColor={127,0,0},
          smooth=Smooth.None),
        Line(
          points={{-58,-76},{60,-76}},
          color={127,0,0},
          smooth=Smooth.None)}),                                    Diagram(
        graphics));

end Occupant;
