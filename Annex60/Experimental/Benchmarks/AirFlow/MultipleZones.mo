within Annex60.Experimental.Benchmarks.AirFlow;
model MultipleZones "Test case for air flow between multiple zones"
  extends Modelica.Icons.Example;

  Airflow.Multizone.ZoneHallway zoneHallway
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Airflow.Multizone.SimpleZone simpleZone
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Airflow.Multizone.OutsideEnvironment outsideEnvironment
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{70,70},{90,90}})));
equation
  connect(simpleZone.port_a, zoneHallway.port_a) annotation (Line(
      points={{-60,6},{-10,6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(simpleZone.port_b, zoneHallway.port_b) annotation (Line(
      points={{-60,-6},{-10,-6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway.port_a1, outsideEnvironment.port_a) annotation (Line(
      points={{10,6},{60,6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway.port_b1, outsideEnvironment.port_b) annotation (Line(
      points={{10,-6},{60,-6}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end MultipleZones;
