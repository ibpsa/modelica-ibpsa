within IDEAS.Thermal.Components.Examples;
model HPTester "Identical as the one in FluidHeatFlow_NoPressure"

extends Modelica.Icons.Example;

  Thermal.Components.BaseClasses.AbsolutePressure absolutePressure(medium=
        Data.Media.Water(), p=200000)
    annotation (Placement(transformation(extent={{58,62},{78,82}})));
  Thermal.Components.BaseClasses.Pump volumeFlow1(
    medium=Data.Media.Water(),
    m=1,
    m_flowNom=0.3,
    useInput=true)
    annotation (Placement(transformation(extent={{-36,-16},{-16,4}})));
  IDEAS.Thermal.Components.BaseClasses.Pipe_HeatPort
                                            isolatedPipe1(
    medium=Data.Media.Water(),
    m=5,
    TInitial=313.15) annotation (Placement(transformation(extent={{12,-16},{32,4}})));
  IDEAS.Thermal.Components.Production.HP_AWMod_Losses
                      HP(
   medium=Data.Media.Water(),
    QNom=5000,
    TSet=pulse.y,
    tauHeatLoss=3600,
    mWater=10,
    cDry=10000)
               annotation (Placement(transformation(extent={{42,10},{62,30}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(G=300)
    annotation (Placement(transformation(extent={{-6,-52},{14,-32}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=293.15)
    annotation (Placement(transformation(extent={{-56,-52},{-36,-32}})));
  inner IDEAS.SimInfoManager         sim(redeclare
      IDEAS.Climate.Meteo.Files.min15
      detail, redeclare IDEAS.Climate.Meteo.Locations.Uccle city)
    annotation (Placement(transformation(extent={{-84,68},{-64,88}})));
  Modelica.Blocks.Sources.Pulse pulse(
    amplitude=45,
    period=10000,
    offset=273)
    annotation (Placement(transformation(extent={{-30,66},{-10,86}})));
  Thermal.Components.BaseClasses.Pump volumeFlow2(
    medium=Data.Media.Water(),
    m=1,
    m_flowNom=0.3,
    useInput=true)
    annotation (Placement(transformation(extent={{-32,-148},{-12,-128}})));
  IDEAS.Thermal.Components.BaseClasses.Pipe_HeatPort
                                            isolatedPipe2(
    medium=Data.Media.Water(),
    m=5,
    TInitial=313.15) annotation (Placement(transformation(extent={{16,-148},{36,
            -128}})));
  IDEAS.Thermal.Components.Production.HP_AWMod
                      HP_NoLosses(
    medium=Data.Media.Water(),
    QNom=5000,
    TSet=pulse.y)
               annotation (Placement(transformation(extent={{56,-148},{76,-128}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor1(
                                                                             G=300)
    annotation (Placement(transformation(extent={{-2,-184},{18,-164}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature1(
                                                                          T=293.15)
    annotation (Placement(transformation(extent={{-52,-184},{-32,-164}})));
  Thermal.Components.BaseClasses.AbsolutePressure absolutePressure1(medium=
        Data.Media.Water(), p=200000)
    annotation (Placement(transformation(extent={{54,-108},{74,-88}})));
 Real PElLossesInt( start = 0, fixed = true);
 Real PElNoLossesInt( start = 0, fixed = true);
 Real QUsefulLossesInt( start = 0, fixed = true);
 Real QUsefulNoLossesInt( start = 0, fixed = true);
 Real SPFLosses( start = 0);
 Real SPFNoLosses( start = 0);

equation
  pump.m_flowSet = if pulse.y > 300 then 1 else 0;
  volumeFlow2.m_flowSet = if pulse.y > 300 then 1 else 0;
  der(PElLossesInt) = HP.PEl;
  der(PElNoLossesInt) = HP_NoLosses.PEl;
  der(QUsefulLossesInt) =thermalConductor.port_b.Q_flow;
  der(QUsefulNoLossesInt) = thermalConductor1.port_b.Q_flow;
  SPFLosses = if noEvent(PElLossesInt > 0) then QUsefulLossesInt/PElLossesInt else 0;
  SPFNoLosses = if noEvent(PElNoLossesInt > 0) then QUsefulNoLossesInt/PElNoLossesInt else 0;

  connect(volumeFlow1.flowPort_b, isolatedPipe1.flowPort_a) annotation (Line(
      points={{-16,-6},{12,-6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(isolatedPipe1.flowPort_b, HP.flowPort_a)            annotation (Line(
      points={{32,-6},{52,-6},{52,15.6364},{62,15.6364}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(HP.flowPort_b, volumeFlow1.flowPort_a)            annotation (Line(
      points={{62,20.9091},{82,20.9091},{82,-62},{-76,-62},{-76,-6},{-36,-6}},
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
      points={{58,72},{80,72},{80,12},{76,12},{76,15.6364},{62,15.6364}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(HP.heatPort, fixedTemperature.port) annotation (Line(
      points={{49,10},{94,10},{94,-72},{-36,-72},{-36,-42}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(volumeFlow2.flowPort_b,isolatedPipe2. flowPort_a) annotation (Line(
      points={{-12,-138},{16,-138}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(isolatedPipe2.flowPort_b, HP_NoLosses.flowPort_a)   annotation (Line(
      points={{36,-138},{56,-138}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(HP_NoLosses.flowPort_b, volumeFlow2.flowPort_a)   annotation (Line(
      points={{76,-138},{86,-138},{86,-194},{-72,-194},{-72,-138},{-32,-138}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(thermalConductor1.port_b, isolatedPipe2.heatPort)
                                                           annotation (Line(
      points={{18,-174},{22,-174},{22,-148},{26,-148}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fixedTemperature1.port, thermalConductor1.port_a)
                                                          annotation (Line(
      points={{-32,-174},{-2,-174}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(absolutePressure1.flowPort, HP_NoLosses.flowPort_a)  annotation (Line(
      points={{54,-98},{54,-138},{56,-138}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                      graphics),
    experiment(StopTime=25000),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}})));
end HPTester;
