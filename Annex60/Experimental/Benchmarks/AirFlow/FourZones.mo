within Annex60.Experimental.Benchmarks.AirFlow;
model FourZones "Test case for air flow between multiple zones"
  extends Modelica.Icons.Example;

  package Medium = Modelica.Media.Air.SimpleAir;

  Airflow.Multizone.ZoneHallway zoneHallway(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-10,-80},{10,-60}})));
  Airflow.Multizone.SimpleZone simpleZone(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Airflow.Multizone.OutsideEnvironment outsideEnvironment(redeclare package
      Medium = Medium)
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{70,70},{90,90}})));
  Airflow.Multizone.ZoneHallway zoneHallway1(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  Airflow.Multizone.SimpleZone simpleZone1(TRoom=293.15, redeclare package
      Medium = Medium)
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
equation
  connect(simpleZone.port_a, zoneHallway.port_a) annotation (Line(
      points={{-60,-64},{-10,-64}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(simpleZone.port_b, zoneHallway.port_b) annotation (Line(
      points={{-60,-76},{-10,-76}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway.port_a1, outsideEnvironment.port_a) annotation (Line(
      points={{10,-64},{60,-64}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway.port_b1, outsideEnvironment.port_b) annotation (Line(
      points={{10,-76},{60,-76}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(simpleZone1.port_b, zoneHallway1.port_b) annotation (Line(
      points={{-60,-36},{-10,-36}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(simpleZone1.port_a, zoneHallway1.port_a) annotation (Line(
      points={{-60,-24},{-10,-24}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway.port_a3, zoneHallway1.port_a2) annotation (Line(
      points={{0,-60},{0,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(outsideEnvironment.port_b, zoneHallway1.port_b1) annotation (Line(
      points={{60,-76},{40,-76},{40,-36},{10,-36}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(outsideEnvironment.port_a, zoneHallway1.port_a1) annotation (Line(
      points={{60,-64},{48,-64},{48,-24},{10,-24}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    experiment(StopTime=3600),
    __Dymola_experimentSetupOutput);
end FourZones;
