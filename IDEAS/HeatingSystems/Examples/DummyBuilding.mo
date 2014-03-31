within IDEAS.HeatingSystems.Examples;
model DummyBuilding "Dummy building for testing heating systems"
  import IDEAS;
  extends IDEAS.Interfaces.BaseClasses.Structure;
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature[nZones] TAmb
    annotation (Placement(transformation(extent={{42,52},{22,72}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor[nZones] heatCapacitor(
      C={i*1e6 for i in 1:nZones}, each T(start=292))
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Modelica.Thermal.HeatTransfer.Components.Convection[nZones] convection
    annotation (Placement(transformation(extent={{-14,52},{6,72}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor[nZones]
    temperatureSensor
    annotation (Placement(transformation(extent={{-18,-70},{2,-50}})));
  Modelica.Blocks.Sources.Pulse[nZones] pulse(
    each amplitude=100,
    each period=3600,
    each offset=500) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-4,92})));
equation
  TAmb.T = sim.Te*ones(nZones);

  connect(heatCapacitor.port, convection.solid) annotation (Line(
      points={{-50,70},{-50,62},{-14,62}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convection.fluid, TAmb.port) annotation (Line(
      points={{6,62},{22,62}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(temperatureSensor.port, heatCapacitor.port) annotation (Line(
      points={{-18,-60},{-50,-60},{-50,70}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(temperatureSensor.T, TSensor) annotation (Line(
      points={{2,-60},{28,-60},{28,-60},{34,-60},{34,-60},{156,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heatCapacitor.port, heatPortEmb) annotation (Line(
      points={{-50,70},{-50,42},{118,42},{118,60},{150,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatCapacitor.port, heatPortCon) annotation (Line(
      points={{-50,70},{-50,20},{150,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatCapacitor.port, heatPortRad) annotation (Line(
      points={{-50,70},{-50,-20},{150,-20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pulse.y, convection.Gc) annotation (Line(
      points={{-4,85.4},{-4,72}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-150,
            -100},{150,100}}), graphics));
end DummyBuilding;
