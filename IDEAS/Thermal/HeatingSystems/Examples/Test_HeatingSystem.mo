within IDEAS.Thermal.HeatingSystems.Examples;
model Test_HeatingSystem
  "Generic test for heating systems as defined in TME.HVAC"

parameter Integer nZones = 1 "Number of zones";
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature[nZones] TAmb
    annotation (Placement(transformation(extent={{66,-20},{46,0}})));
  Heating_DHW_TES_Radiators                        heating(
    nZones=nZones,
    VZones={75*2.7 for i in 1:nZones},
    redeclare IDEAS.Thermal.Components.Production.HP_AWMod_Losses heater,
    QNom={10000 for i in 1:nZones})
    annotation (Placement(transformation(extent={{14,-76},{34,-56}})));
  inner IDEAS.SimInfoManager               sim(redeclare
      IDEAS.Climate.Meteo.Files.min15 detail, redeclare
      IDEAS.Climate.Meteo.Locations.Uccle city,
    PV=false)
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor[nZones] heatCapacitor(C={i*1e6 for i in 1:nZones}, each T(start=292))
    annotation (Placement(transformation(extent={{-90,-2},{-70,18}})));
  Modelica.Thermal.HeatTransfer.Components.Convection[nZones] convection
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor[nZones]
    temperatureSensor
    annotation (Placement(transformation(extent={{-34,-60},{-14,-40}})));
  Modelica.Blocks.Sources.Pulse[nZones] TOpSet(
    each amplitude=4,
    each width=67,
    each period=86400,
    each offset=289,
    startTime={3600*7,3600*9})
    annotation (Placement(transformation(extent={{-92,52},{-72,72}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Sources.VoltageSource voltageSource(
    f=50,
    V=230,
    phi=0) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={90,-64})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground ground
    annotation (Placement(transformation(extent={{80,-102},{100,-82}})));
  Interfaces.BaseClasses.CausalInhomeFeeder
                             dummyInHomeGrid
    annotation (Placement(transformation(extent={{42,-76},{62,-56}})));
  Modelica.Blocks.Sources.Pulse mDHW60C(
    each amplitude=0.2,
    each width=5,
    each period=20000,
    each offset=0,
    startTime=0)
    annotation (Placement(transformation(extent={{-84,-94},{-64,-74}})));
equation
  TAmb.T = sim.Te * ones(nZones);
  convection.Gc = heating.QNom/40;
  connect(heatCapacitor.port, convection.solid) annotation (Line(
      points={{-80,-2},{-80,-10},{-40,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convection.fluid, TAmb.port) annotation (Line(
      points={{-20,-10},{46,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(temperatureSensor.port, heatCapacitor.port) annotation (Line(
      points={{-34,-50},{-80,-50},{-80,-2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heating.TSet, TOpSet.y) annotation (Line(
      points={{24,-76.4},{24,-80},{-58,-80},{-58,62},{-71,62}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heating.TSensor, temperatureSensor.T) annotation (Line(
      points={{13.8,-72},{-12,-72},{-12,-50},{-14,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heating.heatPortRad, heatCapacitor.port) annotation (Line(
      points={{14,-68},{-16,-68},{-64,-58},{-80,-58},{-80,-2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heating.heatPortCon, heatCapacitor.port) annotation (Line(
      points={{14,-64},{-2,-64},{-2,-28},{-80,-28},{-80,-2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(voltageSource.pin_p,ground. pin) annotation (Line(
      points={{90,-74},{90,-82}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(dummyInHomeGrid.pinSingle, voltageSource.pin_n) annotation (Line(
      points={{62,-66},{70,-66},{70,-48},{90,-48},{90,-54}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(mDHW60C.y, heating.mDHW60C) annotation (Line(
      points={{-63,-84},{26,-84},{28,-80},{27,-76.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heating.plugLoad, dummyInHomeGrid.nodeSingle) annotation (Line(
      points={{34,-66},{42,-66}},
      color={85,170,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics),
    experiment(StopTime=200000, Interval=900),
    __Dymola_experimentSetupOutput);
end Test_HeatingSystem;
