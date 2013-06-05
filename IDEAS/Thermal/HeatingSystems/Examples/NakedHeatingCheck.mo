within IDEAS.Thermal.HeatingSystems.Examples;
model NakedHeatingCheck

  parameter Integer nZones = 1;
  Heating_Embedded_combiTES_DHW_STS                heating_DHW_TES(
    nZones=nZones,
    QNom={5000},
    VZones={100},
    heaterType=IDEAS.Thermal.Components.Production.BaseClasses.HeaterType.Boiler)
    annotation (Placement(transformation(extent={{-6,10},{18,30}})));
  inner IDEAS.SimInfoManager         sim(
      redeclare IDEAS.Climate.Meteo.Locations.Uccle city, redeclare
      IDEAS.Climate.Meteo.Files.min60 detail)
    annotation (Placement(transformation(extent={{-86,66},{-66,86}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature[nZones]
                                                         fixedTemperature
    annotation (Placement(transformation(extent={{-54,8},{-34,28}})));
  Modelica.Blocks.Sources.Constant[nZones] const(k=273.15 + 21)
    annotation (Placement(transformation(extent={{-54,-32},{-34,-12}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Sources.VoltageSource voltageSource(
    f=50,
    V=230,
    phi=0) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={74,-8})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground ground
    annotation (Placement(transformation(extent={{64,-58},{84,-38}})));
  Interfaces.BaseClasses.CausalInhomeFeeder
                             dummyInHomeGrid
    annotation (Placement(transformation(extent={{34,10},{54,30}})));
  Modelica.Blocks.Sources.Sine sine(
    amplitude=2,
    freqHz=1/86400,
    offset=294.20)
    annotation (Placement(transformation(extent={{-90,16},{-70,36}})));
  Modelica.Blocks.Sources.Pulse mDHW60C(
    each amplitude=0.2,
    each width=5,
    each period=20000,
    each offset=0,
    startTime=0)
    annotation (Placement(transformation(extent={{-54,-66},{-34,-46}})));
equation
  connect(fixedTemperature.port, heating_DHW_TES.heatPortRad) annotation (
      Line(
      points={{-34,18},{-6,18}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fixedTemperature.port, heating_DHW_TES.heatPortCon) annotation (
      Line(
      points={{-34,18},{-24,18},{-24,22},{-6,22}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fixedTemperature.port, heating_DHW_TES.heatPortEmb) annotation (
      Line(
      points={{-34,18},{-24,18},{-24,26},{-6,26}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(const.y, heating_DHW_TES.TSet) annotation (Line(
      points={{-33,-22},{6,-22},{6,9.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(voltageSource.pin_p,ground. pin) annotation (Line(
      points={{74,-18},{74,-38}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(dummyInHomeGrid.pinSingle, voltageSource.pin_n) annotation (Line(
      points={{54,20},{74,20},{74,2}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(sine.y, fixedTemperature[1].T) annotation (Line(
      points={{-69,26},{-62,26},{-62,18},{-56,18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sine.y, heating_DHW_TES.TSensor[1]) annotation (Line(
      points={{-69,26},{-62,26},{-62,-2},{-14,-2},{-14,14},{-6.24,14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mDHW60C.y, heating_DHW_TES.mDHW60C) annotation (Line(
      points={{-33,-56},{9.6,-56},{9.6,9.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heating_DHW_TES.plugLoad, dummyInHomeGrid.nodeSingle) annotation (
      Line(
      points={{18,20},{34,20}},
      color={85,170,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics),
    experiment(StopTime=200000, Interval=900),
    __Dymola_experimentSetupOutput);
end NakedHeatingCheck;
