within IDEAS.Thermal.HeatingSystems.Examples;
model Test_FloorHeatingSystem
  "Generic test for floor heating systems as defined in TME.HVAC"
  import IDEAS;

parameter Integer nZones = 1 "Number of zones";
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature[nZones] TAmb
    annotation (Placement(transformation(extent={{-96,10},{-84,22}})));
  IDEAS.Thermal.HeatingSystems.Heating_Embedded_DHW_STS heating(
    nZones=nZones,
    VZones={75*2.7 for i in 1:nZones},
    timeFilter=43200,
    QNom={1000 for i in 1:nZones},
    nOcc=4,
    volumeTank=0.3,
    solSys=true,
    AColTot=5,
    dTSupRetNom=5,
    FHChars={IDEAS.Thermal.Components.BaseClasses.FH_Characteristics(A_Floor=10)},
    TSupNom=313.15,
    redeclare IDEAS.Thermal.Components.Production.HP_AirWater heater)
    annotation (Placement(transformation(extent={{-2,-58},{48,-30}})));

  inner IDEAS.SimInfoManager               sim(
                                        redeclare
      IDEAS.Climate.Meteo.Locations.Uccle city, redeclare
      IDEAS.Climate.Meteo.Files.min5
      detail,
    occBeh=false,
    PV=false)
    annotation (Placement(transformation(extent={{70,70},{90,90}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor[nZones] heatCapacitor(C={i*1e6 for i in 1:nZones}, each T(fixed=false, start=292))
    annotation (Placement(transformation(extent={{-58,30},{-38,50}})));
  Modelica.Thermal.HeatTransfer.Components.Convection[nZones] convection
    annotation (Placement(transformation(extent={{-56,6},{-76,26}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor[nZones]
    temperatureSensor
    annotation (Placement(transformation(extent={{-40,-62},{-20,-42}})));
  Modelica.Blocks.Sources.Pulse[nZones] TOpSet(
    each amplitude=4,
    each width=67,
    each period=86400,
    each offset=289,
    startTime={3600*7,3600*9})
    annotation (Placement(transformation(extent={{-4,-86},{16,-66}})));
  IDEAS.Thermal.Components.Emission.NakedTabs[
                                        nZones] nakedTabs(
    each n1=3,
    each n2=3,
    FHChars(T=0.2, each A_Floor=10))
    annotation (Placement(transformation(extent={{-20,-28},{-40,-8}})));
  Modelica.Thermal.HeatTransfer.Components.Convection[nZones] convectionTabs
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-30,16})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Sources.VoltageSource voltageSource(
    f=50,
    V=230,
    phi=0) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={86,-66})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground ground
    annotation (Placement(transformation(extent={{80,-92},{92,-80}})));
  IDEAS.Interfaces.BaseClasses.CausalInhomeFeeder
                             dummyInHomeGrid
    annotation (Placement(transformation(extent={{56,-54},{76,-34}})));
  Modelica.Blocks.Sources.Pulse mDHW60C(
    each amplitude=0.2,
    each width=5,
    each period=20000,
    each offset=0,
    startTime=0)
    annotation (Placement(transformation(extent={{60,-86},{40,-66}})));
equation
  TAmb.T = sim.Te * ones(nZones);
  convection.Gc = heating.QNom/40;
  convectionTabs.Gc = 11 * nakedTabs.FHChars.A_Floor;
  connect(heatCapacitor.port, convection.solid) annotation (Line(
      points={{-48,30},{-48,16},{-56,16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(temperatureSensor.port, heatCapacitor.port) annotation (Line(
      points={{-40,-52},{-48,-52},{-48,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convectionTabs.fluid, heatCapacitor.port) annotation (Line(
      points={{-30,26},{-30,30},{-48,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(nakedTabs.port_a, convectionTabs.solid) annotation (Line(
      points={{-30,-8},{-30,6}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(voltageSource.pin_p,ground. pin) annotation (Line(
      points={{86,-76},{86,-80}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(dummyInHomeGrid.pinSingle, voltageSource.pin_n) annotation (Line(
      points={{76,-44},{86,-44},{86,-56}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(mDHW60C.y, heating.mDHW60C) annotation (Line(
      points={{39,-76},{30.5,-76},{30.5,-58.56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heating.plugLoad, dummyInHomeGrid.nodeSingle) annotation (Line(
      points={{48,-44},{56,-44}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(temperatureSensor.T, heating.TSensor) annotation (Line(
      points={{-20,-52},{-14,-52},{-14,-52.4},{-2.5,-52.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TOpSet.y, heating.TSet) annotation (Line(
      points={{17,-76},{23,-76},{23,-58.56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heating.heatPortEmb, nakedTabs.portCore) annotation (Line(
      points={{-2,-35.6},{-6,-35.6},{-6,-36},{-10,-36},{-10,-18},{-20,-18}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TAmb.port, convection.fluid) annotation (Line(
      points={{-84,16},{-76,16}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics),
    experiment(StopTime=300000, Interval=900),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end Test_FloorHeatingSystem;
