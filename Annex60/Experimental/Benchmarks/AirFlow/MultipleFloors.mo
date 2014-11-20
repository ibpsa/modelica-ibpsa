within Annex60.Experimental.Benchmarks.AirFlow;
model MultipleFloors "Test case for air flow between multiple floors"
  extends Modelica.Icons.Example;

  package Medium = Modelica.Media.Air.SimpleAir;
  parameter Boolean forceErrorControlOnFlow = true;

  Airflow.Multizone.ZoneHallway zoneHallway(redeclare package Medium = Medium,
      forceErrorControlOnFlow=forceErrorControlOnFlow)
    annotation (Placement(transformation(extent={{42,-94},{62,-74}})));
  Airflow.Multizone.SimpleZone simpleZone(redeclare package Medium = Medium,
      forceErrorControlOnFlow=forceErrorControlOnFlow)
    annotation (Placement(transformation(extent={{12,-94},{32,-74}})));
  Airflow.Multizone.OutsideEnvironment outsideEnvironment(redeclare package
      Medium = Medium)
    annotation (Placement(transformation(extent={{72,-94},{92,-74}})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Airflow.Multizone.ZoneHallway zoneHallway1(redeclare package Medium = Medium,
      forceErrorControlOnFlow=forceErrorControlOnFlow)
    annotation (Placement(transformation(extent={{42,-54},{62,-34}})));
  Airflow.Multizone.ZoneHallway zoneHallway2(redeclare package Medium = Medium,
      forceErrorControlOnFlow=forceErrorControlOnFlow)
    annotation (Placement(transformation(extent={{42,-14},{62,6}})));
  Airflow.Multizone.ZoneHallway zoneHallway3(redeclare package Medium = Medium,
      forceErrorControlOnFlow=forceErrorControlOnFlow)
    annotation (Placement(transformation(extent={{42,26},{62,46}})));
  Airflow.Multizone.SimpleZone simpleZone1(TRoom=293.15, redeclare package
      Medium = Medium,
    forceErrorControlOnFlow=forceErrorControlOnFlow)
    annotation (Placement(transformation(extent={{12,-54},{32,-34}})));
  Airflow.Multizone.SimpleZone simpleZone2(TRoom=303.15, redeclare package
      Medium = Medium,
    forceErrorControlOnFlow=forceErrorControlOnFlow)
    annotation (Placement(transformation(extent={{12,-14},{32,6}})));
  Airflow.Multizone.SimpleZone simpleZone3(TRoom=300.15, redeclare package
      Medium = Medium,
    forceErrorControlOnFlow=forceErrorControlOnFlow)
    annotation (Placement(transformation(extent={{12,26},{32,46}})));
  Airflow.Multizone.OutsideEnvironment outsideEnvironment1
    annotation (Placement(transformation(extent={{72,-54},{92,-34}})));
  Airflow.Multizone.OutsideEnvironment outsideEnvironment2
    annotation (Placement(transformation(extent={{72,-14},{92,6}})));
  Airflow.Multizone.OutsideEnvironment outsideEnvironment3
    annotation (Placement(transformation(extent={{72,26},{92,46}})));
  Airflow.Multizone.ZoneHallway zoneHallway4(
                                            redeclare package Medium = Medium,
      forceErrorControlOnFlow=forceErrorControlOnFlow)
    annotation (Placement(transformation(extent={{-62,-94},{-42,-74}})));
  Airflow.Multizone.SimpleZone simpleZone4(
                                          redeclare package Medium = Medium,
      forceErrorControlOnFlow=forceErrorControlOnFlow)
    annotation (Placement(transformation(extent={{-92,-94},{-72,-74}})));
  Airflow.Multizone.OutsideEnvironment outsideEnvironment4(
                                                          redeclare package
      Medium = Medium)
    annotation (Placement(transformation(extent={{-32,-94},{-12,-74}})));
  Airflow.Multizone.ZoneHallway zoneHallway5(redeclare package Medium = Medium,
      forceErrorControlOnFlow=forceErrorControlOnFlow)
    annotation (Placement(transformation(extent={{-62,-54},{-42,-34}})));
  Airflow.Multizone.ZoneHallway zoneHallway6(redeclare package Medium = Medium,
      forceErrorControlOnFlow=forceErrorControlOnFlow)
    annotation (Placement(transformation(extent={{-62,-14},{-42,6}})));
  Airflow.Multizone.ZoneHallway zoneHallway7(redeclare package Medium = Medium,
      forceErrorControlOnFlow=forceErrorControlOnFlow)
    annotation (Placement(transformation(extent={{-62,26},{-42,46}})));
  Airflow.Multizone.SimpleZone simpleZone5(TRoom=293.15, redeclare package
      Medium = Medium,
    forceErrorControlOnFlow=forceErrorControlOnFlow)
    annotation (Placement(transformation(extent={{-92,-54},{-72,-34}})));
  Airflow.Multizone.SimpleZone simpleZone6(TRoom=303.15, redeclare package
      Medium = Medium,
    forceErrorControlOnFlow=forceErrorControlOnFlow)
    annotation (Placement(transformation(extent={{-92,-14},{-72,6}})));
  Airflow.Multizone.SimpleZone simpleZone7(TRoom=300.15, redeclare package
      Medium = Medium,
    forceErrorControlOnFlow=forceErrorControlOnFlow)
    annotation (Placement(transformation(extent={{-92,26},{-72,46}})));
  Airflow.Multizone.OutsideEnvironment outsideEnvironment5
    annotation (Placement(transformation(extent={{-32,-54},{-12,-34}})));
  Airflow.Multizone.OutsideEnvironment outsideEnvironment6
    annotation (Placement(transformation(extent={{-32,-14},{-12,6}})));
  Airflow.Multizone.OutsideEnvironment outsideEnvironment7
    annotation (Placement(transformation(extent={{-32,26},{-12,46}})));
  Airflow.Multizone.Staircase staircase annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={52,70})));
  Airflow.Multizone.Staircase staircase1 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-52,70})));
equation
  connect(simpleZone.port_a, zoneHallway.port_a) annotation (Line(
      points={{32,-78},{42,-78}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(simpleZone.port_b, zoneHallway.port_b) annotation (Line(
      points={{32,-90},{42,-90}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway.port_a1, outsideEnvironment.port_a) annotation (Line(
      points={{62,-78},{72,-78}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway.port_b1, outsideEnvironment.port_b) annotation (Line(
      points={{62,-90},{72,-90}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(simpleZone1.port_b, zoneHallway1.port_b) annotation (Line(
      points={{32,-50},{42,-50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(simpleZone1.port_a, zoneHallway1.port_a) annotation (Line(
      points={{32,-38},{42,-38}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway2.port_a, simpleZone2.port_a) annotation (Line(
      points={{42,2},{32,2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway2.port_b, simpleZone2.port_b) annotation (Line(
      points={{42,-10},{32,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway3.port_a, simpleZone3.port_a) annotation (Line(
      points={{42,42},{32,42}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway3.port_b, simpleZone3.port_b) annotation (Line(
      points={{42,30},{32,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway.port_a3, zoneHallway1.port_a2) annotation (Line(
      points={{46,-74},{46,-54}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway1.port_a3, zoneHallway2.port_a2) annotation (Line(
      points={{46,-34},{46,-14}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway2.port_a3, zoneHallway3.port_a2) annotation (Line(
      points={{46,6},{46,26}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway.port_b3, zoneHallway1.port_b2) annotation (Line(
      points={{58,-74},{58,-54}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway1.port_b3, zoneHallway2.port_b2) annotation (Line(
      points={{58,-34},{58,-14}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway2.port_b3, zoneHallway3.port_b2) annotation (Line(
      points={{58,6},{58,26}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway3.port_a1, outsideEnvironment3.port_a) annotation (Line(
      points={{62,42},{72,42}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway3.port_b1, outsideEnvironment3.port_b) annotation (Line(
      points={{62,30},{72,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway2.port_a1, outsideEnvironment2.port_a) annotation (Line(
      points={{62,2},{72,2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway2.port_b1, outsideEnvironment2.port_b) annotation (Line(
      points={{62,-10},{72,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway1.port_a1, outsideEnvironment1.port_a) annotation (Line(
      points={{62,-38},{72,-38}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway1.port_b1, outsideEnvironment1.port_b) annotation (Line(
      points={{62,-50},{72,-50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(simpleZone4.port_a, zoneHallway4.port_a) annotation (Line(
      points={{-72,-78},{-62,-78}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(simpleZone4.port_b, zoneHallway4.port_b) annotation (Line(
      points={{-72,-90},{-62,-90}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway4.port_a1, outsideEnvironment4.port_a) annotation (Line(
      points={{-42,-78},{-32,-78}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway4.port_b1, outsideEnvironment4.port_b) annotation (Line(
      points={{-42,-90},{-32,-90}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(simpleZone5.port_b,zoneHallway5. port_b) annotation (Line(
      points={{-72,-50},{-62,-50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(simpleZone5.port_a,zoneHallway5. port_a) annotation (Line(
      points={{-72,-38},{-62,-38}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway6.port_a,simpleZone6. port_a) annotation (Line(
      points={{-62,2},{-72,2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway6.port_b,simpleZone6. port_b) annotation (Line(
      points={{-62,-10},{-72,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway7.port_a,simpleZone7. port_a) annotation (Line(
      points={{-62,42},{-72,42}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway7.port_b,simpleZone7. port_b) annotation (Line(
      points={{-62,30},{-72,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway4.port_a3, zoneHallway5.port_a2) annotation (Line(
      points={{-58,-74},{-58,-54}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway5.port_a3,zoneHallway6. port_a2) annotation (Line(
      points={{-58,-34},{-58,-14}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway6.port_a3,zoneHallway7. port_a2) annotation (Line(
      points={{-58,6},{-58,26}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway4.port_b3, zoneHallway5.port_b2) annotation (Line(
      points={{-46,-74},{-46,-54}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway5.port_b3,zoneHallway6. port_b2) annotation (Line(
      points={{-46,-34},{-46,-14}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway6.port_b3,zoneHallway7. port_b2) annotation (Line(
      points={{-46,6},{-46,26}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway7.port_a1,outsideEnvironment7. port_a) annotation (Line(
      points={{-42,42},{-32,42}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway7.port_b1,outsideEnvironment7. port_b) annotation (Line(
      points={{-42,30},{-32,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway6.port_a1,outsideEnvironment6. port_a) annotation (Line(
      points={{-42,2},{-32,2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway6.port_b1,outsideEnvironment6. port_b) annotation (Line(
      points={{-42,-10},{-32,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway5.port_a1,outsideEnvironment5. port_a) annotation (Line(
      points={{-42,-38},{-32,-38}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway5.port_b1,outsideEnvironment5. port_b) annotation (Line(
      points={{-42,-50},{-32,-50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway3.port_b3, staircase.port_b) annotation (Line(
      points={{58,46},{58,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zoneHallway3.port_a3, staircase.port_a) annotation (Line(
      points={{46,46},{46,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(staircase.port_a3, staircase1.port_a2) annotation (Line(
      points={{42,64},{-42,64}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(staircase.port_b3, staircase1.port_b2) annotation (Line(
      points={{42,76},{-42,76}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(staircase1.port_b, zoneHallway7.port_b3) annotation (Line(
      points={{-46,60},{-46,46}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(staircase1.port_a, zoneHallway7.port_a3) annotation (Line(
      points={{-58,60},{-58,46}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    experiment(StopTime=3600),
    __Dymola_experimentSetupOutput);
end MultipleFloors;
