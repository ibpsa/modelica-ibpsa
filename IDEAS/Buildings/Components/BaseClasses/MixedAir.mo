within IDEAS.Buildings.Components.BaseClasses;
model MixedAir "Mixed air capacity of the thermal zone"

  parameter Integer nSurf(min=1) "number of surfaces in contact with the zone";
  parameter Modelica.SIunits.Volume V "air volume of the zone";
  parameter Real corrCV = 5 "correction factor on the zone air capacity";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a conGain
    "convective internal gains"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b[nSurf] conSurf
    "convective gains on surfaces"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Interfaces.RealOutput TCon "convective zone temperature"
    annotation (Placement(transformation(extent={{20,-20},{-20,20}},
        rotation=90,
        origin={0,-100})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TiSensor
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-30})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCap(C=1012*1.204*
        V*corrCV, T(start=293.15)) "air capacity"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
equation
for i in 1:nSurf loop
  connect(heatCap.port, conSurf[i]) annotation (Line(
      points={{0,0},{100,0}},
      color={191,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
end for;
  connect(conGain, heatCap.port) annotation (Line(
      points={{-100,0},{0,0}},
      color={191,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));

  connect(heatCap.port, TiSensor.port) annotation (Line(
      points={{0,0},{0,2},{1.98721e-022,2},{1.98721e-022,-20},{1.83697e-015,-20}},
      color={191,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));

  connect(TiSensor.T, TCon) annotation (Line(
      points={{-1.83697e-015,-40},{0,-40},{0,-100}},
      color={0,0,127},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  annotation (Diagram(graphics), Icon(graphics={
        Polygon(
          points={{0,83},{-20,79},{-40,73},{-52,59},{-58,51},{-68,41},{-72,29},
              {-76,15},{-78,1},{-76,-15},{-76,-27},{-76,-37},{-70,-49},{-64,-57},
              {-48,-61},{-30,-67},{-18,-67},{-2,-69},{8,-73},{22,-73},{32,-71},
              {42,-65},{54,-59},{56,-57},{66,-45},{68,-37},{70,-35},{72,-19},{
              76,-5},{78,3},{78,19},{74,31},{66,41},{54,49},{44,57},{36,73},{26,
              81},{0,83}},
          lineColor={160,160,164},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-58,51},{-68,41},{-72,29},{-76,15},{-78,1},{-76,-15},{-76,
              -27},{-76,-37},{-70,-49},{-64,-57},{-48,-61},{-30,-67},{-18,-67},
              {-2,-69},{8,-73},{22,-73},{32,-71},{42,-65},{54,-59},{42,-61},{40,
              -61},{30,-63},{20,-65},{18,-65},{10,-65},{2,-61},{-12,-57},{-22,
              -57},{-30,-55},{-40,-49},{-50,-39},{-56,-27},{-58,-19},{-58,-9},{
              -60,3},{-60,11},{-60,23},{-58,33},{-56,35},{-52,43},{-48,51},{-44,
              61},{-40,73},{-58,51}},
          lineColor={0,0,0},
          fillColor={160,160,164},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-6,15},{6,4}},
          lineColor={0,0,127},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Text(
          extent={{11,29},{50,-9}},
          lineColor={0,0,0},
          textString="T"),
        Line(points={{0,4},{0,-80}},   color={0,0,127})}));
end MixedAir;
