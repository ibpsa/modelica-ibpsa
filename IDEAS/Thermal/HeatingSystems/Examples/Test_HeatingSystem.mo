within IDEAS.Thermal.HeatingSystems.Examples;
model Test_HeatingSystem
  "Generic test for heating systems as defined in TME.HVAC"

parameter Integer n_C = 2 "Number of zones";
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature[n_C] TAmb
    annotation (Placement(transformation(extent={{52,-22},{32,-2}})));
  Thermal.HeatingSystems.Heating_DHW_TES_Radiators heating(
    n_C=n_C,
    V_C={75*2.7 for i in 1:n_C},
    QNom={100000 for i in 1:n_C},
    redeclare IDEAS.Thermal.Components.Production.HP_AWMod_Losses heater)
    annotation (Placement(transformation(extent={{52,-92},{72,-72}})));
  inner Commons.SimInfoManager       sim(redeclare Commons.Meteo.Files.min15
                                detail, redeclare Commons.Meteo.Locations.Uccle
                                    city)
    annotation (Placement(transformation(extent={{70,70},{90,90}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor[n_C] heatCapacitor(C={i*1e6 for i in 1:n_C}, T(each
        fixed=true, each start=292))
    annotation (Placement(transformation(extent={{-56,-4},{-36,16}})));
  Modelica.Thermal.HeatTransfer.Components.Convection[n_C] convection
    annotation (Placement(transformation(extent={{-6,-22},{14,-2}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor[n_C]
    temperatureSensor
    annotation (Placement(transformation(extent={{0,-62},{20,-42}})));
  Modelica.Blocks.Sources.Pulse[n_C] TOpSet(
    each amplitude=4,
    each width=67,
    each period=86400,
    each offset=289,
    startTime={3600*7,3600*9})
    annotation (Placement(transformation(extent={{-58,50},{-38,70}})));
  Modelica.Blocks.Sources.Pulse[n_C] TOpSet1(
    each amplitude=4,
    each width=67,
    each period=86400,
    each offset=289,
    startTime={3600*7,3600*9})
    annotation (Placement(transformation(extent={{28,22},{48,42}})));
equation
  TAmb.T = sim.Te * ones(n_C);
  convection.Gc = if time < 1500 then zeros(n_C) else heating.QNom/4;
  connect(heatCapacitor.port, convection.solid) annotation (Line(
      points={{-46,-4},{-46,-12},{-6,-12}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convection.fluid, TAmb.port) annotation (Line(
      points={{14,-12},{32,-12}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(temperatureSensor.port, heatCapacitor.port) annotation (Line(
      points={{0,-52},{-46,-52},{-46,-4}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heating.TOpAsked, TOpSet.y) annotation (Line(
      points={{64,-72.4},{64,60},{-37,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heating.TOp, temperatureSensor.T) annotation (Line(
      points={{61.7143,-72.4},{61.7143,-52},{20,-52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heating.heatPortRad, heatCapacitor.port) annotation (Line(
      points={{59.4286,-72},{59.4286,-26},{-46,-26},{-46,-4}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heating.heatPortConv, heatCapacitor.port) annotation (Line(
      points={{57.6,-72},{60,-72},{60,-30},{-46,-30},{-46,-4}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics),
    experiment(StopTime=200000, Interval=900),
    __Dymola_experimentSetupOutput);
end Test_HeatingSystem;
