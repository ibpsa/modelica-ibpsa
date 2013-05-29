within IDEAS.Thermal.Components.Examples;
model HPBW_Tester "Identical as the one in FluidHeatFlow_NoPressure"

extends Modelica.Icons.Example;

  Thermal.Components.BaseClasses.AbsolutePressure absolutePressure(medium=
        Data.Media.Water(), p=200000)
    annotation (Placement(transformation(extent={{58,62},{78,82}})));
  Thermal.Components.BaseClasses.Pump volumeFlow1(
    medium=Data.Media.Water(),
    m=1,
    m_flowNom=0.3,
    useInput=true)
    annotation (Placement(transformation(extent={{-54,38},{-34,58}})));
  IDEAS.Thermal.Components.BaseClasses.Pipe_HeatPort
                                            isolatedPipe1(
    medium=Data.Media.Water(),
    m=5,
    TInitial=313.15) annotation (Placement(transformation(extent={{-6,38},{14,
            58}})));
  IDEAS.Thermal.Components.Production.HP_BW
                      HP(
   medium=Data.Media.Water(),
   mediumEvap = Data.Media.Water(),
    TSet=pulse.y,
    tauHeatLoss=3600,
    mWater=10,
    cDry=10000,
    QNom=7000) annotation (Placement(transformation(extent={{34,38},{54,58}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(G=300)
    annotation (Placement(transformation(extent={{-24,2},{-4,22}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=293.15)
    annotation (Placement(transformation(extent={{-74,2},{-54,22}})));
  inner IDEAS.SimInfoManager         sim(redeclare
      IDEAS.Climate.Meteo.Files.min15
      detail, redeclare IDEAS.Climate.Meteo.Locations.Uccle city)
    annotation (Placement(transformation(extent={{-84,68},{-64,88}})));
  Modelica.Blocks.Sources.Pulse pulse(
    amplitude=45,
    period=10000,
    offset=273)
    annotation (Placement(transformation(extent={{-52,70},{-32,90}})));
 Real PElLossesInt( start = 0, fixed = true);

 Real QUsefulLossesInt( start = 0, fixed = true);

 Real SPFLosses( start = 0);

  VerticalHeatExchanger.VerticalHeatExchangerModels.BoreHole boreHole(medium = Data.Media.Water())
    annotation (Placement(transformation(extent={{38,-62},{18,-42}})));
  Thermal.Components.BaseClasses.Pump pump(
    medium=Data.Media.Water(),
    m=2,
    useInput=false,
    m_flowNom=0.5)
    annotation (Placement(transformation(extent={{48,-42},{68,-22}})));
  Thermal.Components.BaseClasses.AbsolutePressure absolutePressure1(medium=
        Data.Media.Water())
    annotation (Placement(transformation(extent={{16,-86},{36,-66}})));
equation
  volumeFlow1.m_flowSet = if pulse.y > 300 then 1 else 0;

  der(PElLossesInt) = HP.PEl;
  der(QUsefulLossesInt) =thermalConductor.port_b.Q_flow;
  SPFLosses = if noEvent(PElLossesInt > 0) then QUsefulLossesInt/PElLossesInt else 0;

  connect(volumeFlow1.flowPort_b, isolatedPipe1.flowPort_a) annotation (Line(
      points={{-34,48},{-6,48}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(isolatedPipe1.flowPort_b, HP.flowPort_a)            annotation (Line(
      points={{14,48},{34,48}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(HP.flowPort_b, volumeFlow1.flowPort_a)            annotation (Line(
      points={{54,48},{64,48},{64,-8},{-94,-8},{-94,48},{-54,48}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(thermalConductor.port_b, isolatedPipe1.heatPort) annotation (Line(
      points={{-4,12},{0,12},{0,38},{4,38}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fixedTemperature.port, thermalConductor.port_a) annotation (Line(
      points={{-54,12},{-24,12}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(absolutePressure.flowPort, HP.flowPort_a)            annotation (Line(
      points={{58,72},{30,72},{30,48},{34,48}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(HP.heatPort, fixedTemperature.port) annotation (Line(
      points={{44,58},{96,58},{96,-12},{-54,-12},{-54,12}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(HP.flowPortEvap_b, pump.flowPort_a) annotation (Line(
      points={{46,38},{46,-32},{48,-32}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(pump.flowPort_b, boreHole.flowPort_a) annotation (Line(
      points={{68,-32},{74,-32},{74,-52.2},{37.8,-52.2}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(HP.flowPortEvap_a, boreHole.flowPort_b) annotation (Line(
      points={{40,38},{38,38},{38,-32},{-2,-32},{-2,-52},{18.2,-52}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(absolutePressure1.flowPort, boreHole.flowPort_b) annotation (Line(
      points={{16,-76},{-24,-76},{-24,-90},{-28,-90},{-28,-60},{18.2,-60},{18.2,
          -52}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                      graphics),
    experiment(StopTime=25000),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}})),
    Commands(file="Scripts/Tester_HPBW.mos" "TestModel"));
end HPBW_Tester;
