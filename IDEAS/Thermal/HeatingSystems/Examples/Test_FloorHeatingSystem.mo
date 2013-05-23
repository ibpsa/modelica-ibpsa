within IDEAS.Thermal.HeatingSystems.Examples;
model Test_FloorHeatingSystem
  "Generic test for floor heating systems as defined in TME.HVAC"

parameter Integer nZones = 1 "Number of zones";
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature[nZones] TAmb
    annotation (Placement(transformation(extent={{32,-22},{12,-2}})));
  Heating_FH_TESandSTSforDHWonly                        heating(
    nZones=nZones,
    VZones={75*2.7 for i in 1:nZones},
    timeFilter=43200,
    QNom={1000 for i in 1:nZones},
    redeclare Thermal.Components.Production.HP_AWMod_Losses heater,
    nOcc=4,
    volumeTank=0.3,
    AColTot=0.001,
    solSys=true)
    annotation (Placement(transformation(extent={{0,-82},{50,-54}})));

  inner IDEAS.SimInfoManager               sim(
                                        redeclare
      IDEAS.Climate.Meteo.Locations.Uccle city, redeclare
      IDEAS.Climate.Meteo.Files.min5
      detail,
    occBeh=false)
    annotation (Placement(transformation(extent={{70,70},{90,90}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor[nZones] heatCapacitor(C={i*1e6 for i in 1:nZones}, each T(fixed=false, start=292))
    annotation (Placement(transformation(extent={{-56,-4},{-36,16}})));
  Modelica.Thermal.HeatTransfer.Components.Convection[nZones] convection
    annotation (Placement(transformation(extent={{-24,-22},{-4,-2}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor[nZones]
    temperatureSensor
    annotation (Placement(transformation(extent={{-30,-62},{-10,-42}})));
  Modelica.Blocks.Sources.Pulse[nZones] TOpSet(
    each amplitude=4,
    each width=67,
    each period=86400,
    each offset=289,
    startTime={3600*7,3600*9})
    annotation (Placement(transformation(extent={{-58,50},{-38,70}})));
  IDEAS.Thermal.Components.Emission.BaseClasses.NakedTabs[
                                        nZones] nakedTabs(
    FHChars(
    each A_Floor =         50),
    each n1=3,
    each n2=3)
    annotation (Placement(transformation(extent={{-64,-90},{-84,-70}})));
  Modelica.Thermal.HeatTransfer.Components.Convection[nZones] convectionTabs
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-74,-48})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Sources.VoltageSource voltageSource(
    f=50,
    V=230,
    phi=0) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={118,-64})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground ground
    annotation (Placement(transformation(extent={{108,-102},{128,-82}})));
  Interfaces.DummyInHomeGrid dummyInHomeGrid
    annotation (Placement(transformation(extent={{70,-90},{90,-70}})));
  Modelica.Blocks.Sources.Pulse mDHW60C(
    each amplitude=0.2,
    each width=5,
    each period=20000,
    each offset=0,
    startTime=0)
    annotation (Placement(transformation(extent={{-40,-108},{-20,-88}})));
equation
  TAmb.T = sim.Te * ones(nZones);
  convection.Gc = heating.QNom/40;
  convectionTabs.Gc = 11 * nakedTabs.FHChars.A_Floor;
  connect(heatCapacitor.port, convection.solid) annotation (Line(
      points={{-46,-4},{-46,-12},{-24,-12}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convection.fluid, TAmb.port) annotation (Line(
      points={{-4,-12},{12,-12}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(temperatureSensor.port, heatCapacitor.port) annotation (Line(
      points={{-30,-52},{-46,-52},{-46,-4}},
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
  connect(heating.TSet, TOpSet.y) annotation (Line(
      points={{25,-82.56},{26,-96},{44,-96},{44,62},{-37,62},{-37,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heating.TSensor, temperatureSensor.T) annotation (Line(
      points={{-0.5,-76.4},{2,-84},{-2,-84},{-2,-54},{-10,-54},{-10,-52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heating.heatPortEmb, nakedTabs.portCore) annotation (Line(
      points={{0,-59.6},{-26,-59.6},{-26,-80},{-64,-80}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(voltageSource.pin_p,ground. pin) annotation (Line(
      points={{118,-74},{118,-82}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(dummyInHomeGrid.pinSingle, voltageSource.pin_n) annotation (Line(
      points={{90,-80},{98,-80},{98,-48},{118,-48},{118,-54}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(heating.plugLoad[1], dummyInHomeGrid.nodeSingle) annotation (Line(
      points={{50,-68},{48,-68},{48,-78},{70,-78},{70,-80}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(mDHW60C.y, heating.mDHW60C) annotation (Line(
      points={{-19,-98},{32.5,-98},{32.5,-82.56}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics),
    experiment(StopTime=300000, Interval=900),
    __Dymola_experimentSetupOutput);
end Test_FloorHeatingSystem;
