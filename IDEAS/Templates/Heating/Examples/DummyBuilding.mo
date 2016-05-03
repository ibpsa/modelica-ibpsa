within IDEAS.Templates.Heating.Examples;
model DummyBuilding "Dummy building for testing heating systems"
  import IDEAS;
  extends IDEAS.Templates.Interfaces.BaseClasses.Structure;

  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature[nZones] TAmb
    annotation (Placement(transformation(extent={{-116,44},{-96,64}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor[nZones] heatCapacitor(
      C={VZones[i]*1.2*1012*10 for i in 1:nZones}, each T(start=292))
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Modelica.Thermal.HeatTransfer.Components.Convection[nZones] convection
    annotation (Placement(transformation(extent={{-62,44},{-82,64}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor[nZones]
    temperatureSensor
    annotation (Placement(transformation(extent={{-18,-70},{2,-50}})));
  Modelica.Blocks.Sources.Constant[nZones] insulationValue(each k=UA_building)
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-86,80})));
  Modelica.Blocks.Sources.RealExpression[nZones] TAmb_val(each y=sim.Te)
    annotation (Placement(transformation(extent={{-146,44},{-126,64}})));
  parameter Real UA_building=500 "Constant output value";
equation
  connect(heatCapacitor.port, convection.solid) annotation (Line(
      points={{-50,70},{-50,54},{-62,54}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convection.fluid, TAmb.port) annotation (Line(
      points={{-82,54},{-96,54}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(temperatureSensor.port, heatCapacitor.port) annotation (Line(
      points={{-18,-60},{-50,-60},{-50,70}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(temperatureSensor.T, TSensor) annotation (Line(
      points={{2,-60},{156,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heatCapacitor.port, heatPortCon) annotation (Line(
      points={{-50,70},{-50,20},{150,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatCapacitor.port, heatPortRad) annotation (Line(
      points={{-50,70},{-50,-20},{150,-20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(insulationValue.y, convection.Gc) annotation (Line(
      points={{-79.4,80},{-72,80},{-72,64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TAmb_val.y, TAmb.T) annotation (Line(
      points={{-125,54},{-118,54}},
      color={0,0,127},
      smooth=Smooth.None));
  if nEmb > 0 then
      connect(heatPortEmb, heatCapacitor.port) annotation (Line(
        points={{150,60},{-50,60},{-50,70}},
        color={191,0,0},
        smooth=Smooth.None));
  end if;

  connect(flowPort_Out, flowPort_In) annotation (Line(
      points={{-20,100},{2,100},{2,100},{20,100}},
      color={0,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-150,
            -100},{150,100}}), graphics));
end DummyBuilding;
