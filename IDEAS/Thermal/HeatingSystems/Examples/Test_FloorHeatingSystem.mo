within IDEAS.Thermal.HeatingSystems.Examples;
model Test_FloorHeatingSystem
  "Generic test for floor heating systems as defined in TME.HVAC"

parameter Integer n_C = 2 "Number of zones";
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature[n_C] TAmb
    annotation (Placement(transformation(extent={{52,-22},{32,-2}})));
  Thermal.HeatingSystems.Heating_FH_TESandSTSforDHWonly heating(
    n_C=n_C,
    V_C={75*2.7 for i in 1:n_C},
    timeFilter=43200,
    QNom={1000 for i in 1:n_C},
    redeclare Thermal.Components.Production.HP_AWMod_Losses heater,
    nOcc=4,
    volumeTank=0.3,
    AColTot=0.001,
    solSys=true)
    annotation (Placement(transformation(extent={{52,-92},{72,-72}})));

  inner Commons.SimInfoManager       sim(
                                        redeclare Commons.Meteo.Locations.Uccle
                                    city, redeclare Commons.Meteo.Files.min5
      detail)
    annotation (Placement(transformation(extent={{70,70},{90,90}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor[n_C] heatCapacitor(C={i*1e6 for i in 1:n_C}, T(each fixed=false, each start=292))
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
  IDEAS.Thermal.Components.Emission.NakedTabs[
                                        n_C] nakedTabs(
    FHChars(
    each A_Floor =         50),
    each n1=3,
    each n2=3)
    annotation (Placement(transformation(extent={{-64,-90},{-84,-70}})));
  Modelica.Thermal.HeatTransfer.Components.Convection[n_C] convectionTabs
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-74,-48})));
equation
  TAmb.T = sim.Te * ones(n_C);
  convection.Gc = heating.QNom/40;
  convectionTabs.Gc = 11 * nakedTabs.FHChars.A_Floor;
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
  connect(convectionTabs.fluid, heatCapacitor.port) annotation (Line(
      points={{-74,-38},{-74,-4},{-46,-4}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(nakedTabs.port_a, convectionTabs.solid) annotation (Line(
      points={{-74,-70},{-74,-58}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heating.TOpAsked, TOpSet.y) annotation (Line(
      points={{64,-72.4},{66,-72.4},{66,62},{-37,62},{-37,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heating.TOp, temperatureSensor.T) annotation (Line(
      points={{61.7143,-72.4},{62,-72.4},{62,-54},{20,-54},{20,-52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heating.heatPortFH, nakedTabs.portCore) annotation (Line(
      points={{55.6571,-72},{32,-72},{32,-78},{-26,-78},{-26,-80},{-64,-80}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics),
    experiment(StopTime=300000, Interval=900),
    __Dymola_experimentSetupOutput);
end Test_FloorHeatingSystem;
