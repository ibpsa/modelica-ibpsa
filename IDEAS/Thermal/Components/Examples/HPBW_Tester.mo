within IDEAS.Thermal.Components.Examples;
model HPBW_Tester "Identical as the one in FluidHeatFlow_NoPressure"
  import Commons;

  Thermal.Components.BaseClasses.AbsolutePressure absolutePressure(medium=
        Data.Media.Water(), p=200000)
    annotation (Placement(transformation(extent={{58,62},{78,82}})));
  Thermal.Components.BaseClasses.Pump volumeFlow1(
    medium=Data.Media.Water(),
    m=1,
    m_flowNom=0.3,
    useInput=true)
    annotation (Placement(transformation(extent={{-36,-16},{-16,4}})));
  Thermal.Components.BaseClasses.HeatedPipe isolatedPipe1(
    medium=Data.Media.Water(),
    m=5,
    TInitial=313.15) annotation (Placement(transformation(extent={{12,-16},{32,4}})));
  IDEAS.Thermal.Components.Production.HP_BW
                      HP(
   medium=Data.Media.Water(),
   mediumEvap = Data.Media.Water(),
    TSet=pulse.y,
    tauHeatLoss=3600,
    mWater=10,
    cDry=10000,
    QNom=7000) annotation (Placement(transformation(extent={{52,-16},{72,4}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(G=300)
    annotation (Placement(transformation(extent={{-6,-52},{14,-32}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=293.15)
    annotation (Placement(transformation(extent={{-56,-52},{-36,-32}})));
  inner Commons.SimInfoManager sim(redeclare Commons.Meteo.Files.min15
      detail, redeclare Commons.Meteo.Locations.Uccle city)
    annotation (Placement(transformation(extent={{-84,68},{-64,88}})));
  Modelica.Blocks.Sources.Pulse pulse(
    amplitude=45,
    period=10000,
    offset=273)
    annotation (Placement(transformation(extent={{-30,66},{-10,86}})));
 Real PElLossesInt( start = 0, fixed = true);

 Real QUsefulLossesInt( start = 0, fixed = true);

 Real SPFLosses( start = 0);

  VerticalHeatExchanger.VerticalHeatExchangerModels.BoreHole boreHole(medium = Data.Media.Water())
    annotation (Placement(transformation(extent={{56,-116},{36,-96}})));
  Thermal.Components.BaseClasses.Pump pump(
    medium=Data.Media.Water(),
    m=2,
    useInput=false,
    m_flowNom=0.5)
    annotation (Placement(transformation(extent={{66,-96},{86,-76}})));
  Thermal.Components.BaseClasses.AbsolutePressure absolutePressure1(medium=
        Data.Media.Water())
    annotation (Placement(transformation(extent={{2,-158},{22,-138}})));
equation
  volumeFlow1.m_flowSet = if pulse.y > 300 then 1 else 0;

  der(PElLossesInt) = HP.PEl;
  der(QUsefulLossesInt) =thermalConductor.port_b.Q_flow;
  SPFLosses = if noEvent(PElLossesInt > 0) then QUsefulLossesInt/PElLossesInt else 0;

  connect(volumeFlow1.flowPort_b, isolatedPipe1.flowPort_a) annotation (Line(
      points={{-16,-6},{12,-6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(isolatedPipe1.flowPort_b, HP.flowPort_a)            annotation (Line(
      points={{32,-6},{52,-6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(HP.flowPort_b, volumeFlow1.flowPort_a)            annotation (Line(
      points={{72,-6},{82,-6},{82,-62},{-76,-62},{-76,-6},{-36,-6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(thermalConductor.port_b, isolatedPipe1.heatPort) annotation (Line(
      points={{14,-42},{18,-42},{18,-16},{22,-16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fixedTemperature.port, thermalConductor.port_a) annotation (Line(
      points={{-36,-42},{-6,-42}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(absolutePressure.flowPort, HP.flowPort_a)            annotation (Line(
      points={{58,72},{48,72},{48,-6},{52,-6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(HP.heatPort, fixedTemperature.port) annotation (Line(
      points={{62,4},{114,4},{114,-66},{-36,-66},{-36,-42}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(HP.flowPortEvap_b, pump.flowPort_a) annotation (Line(
      points={{64,-16},{64,-86},{66,-86}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(pump.flowPort_b, boreHole.flowPort_a) annotation (Line(
      points={{86,-86},{92,-86},{92,-106.2},{55.8,-106.2}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(HP.flowPortEvap_a, boreHole.flowPort_b) annotation (Line(
      points={{58,-16},{56,-16},{56,-86},{16,-86},{16,-106},{36.2,-106}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(absolutePressure1.flowPort, boreHole.flowPort_b) annotation (Line(
      points={{2,-148},{-6,-148},{-6,-144},{-10,-144},{-10,-114},{36.2,-114},{36.2,
          -106}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-200},
            {100,100}}),
                      graphics),
    experiment(StopTime=25000),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-200},{100,100}})),
    Commands(file="Scripts/Tester_HPBW.mos" "TestModel"));
end HPBW_Tester;
