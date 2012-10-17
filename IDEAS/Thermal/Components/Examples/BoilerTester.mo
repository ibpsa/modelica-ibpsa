within IDEAS.Thermal.Components.Examples;
model BoilerTester "Identical as the one in FluidHeatFlow_NoPressure"

  Thermal.Components.BaseClasses.AbsolutePressure absolutePressure(medium=
        Data.Media.Water(), p=200000)
    annotation (Placement(transformation(extent={{58,62},{78,82}})));
  Thermal.Components.BaseClasses.Pump volumeFlow1(
    medium=Data.Media.Water(),
    m=1,
    m_flowNom=1300/3600,
    useInput=true)
    annotation (Placement(transformation(extent={{-36,-16},{-16,4}})));
  Thermal.Components.BaseClasses.HeatedPipe isolatedPipe1(
    medium=Data.Media.Water(),
    m=5,
    TInitial=313.15) annotation (Placement(transformation(extent={{12,-16},{32,4}})));
  IDEAS.Thermal.Components.Production.Boiler
                    boiler(
    medium=Data.Media.Water(),
    QNom=5000,
    tauHeatLoss=3600,
    mWater=10,
    cDry=10000)
               annotation (Placement(transformation(extent={{54,-16},{74,4}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=293.15)
    annotation (Placement(transformation(extent={{46,-112},{66,-92}})));
  inner IDEAS.SimInfoManager         sim(
              redeclare IDEAS.Climate.Meteo.Locations.Uccle city, redeclare
      IDEAS.Climate.Meteo.Files.min5 detail)
    annotation (Placement(transformation(extent={{-84,68},{-64,88}})));
  Modelica.Blocks.Sources.TimeTable
                                pulse(offset=0, table=[0,0; 5000,100; 10000,400;
        15000,700; 20000,1000; 25000,1300; 50000,1300])
    annotation (Placement(transformation(extent={{-68,24},{-48,44}})));
//  Real PElLossesInt( start = 0, fixed = true);
//  Real PElNoLossesInt( start = 0, fixed = true);
//  Real QUsefulLossesInt( start = 0, fixed = true);
//  Real QUsefulNoLossesInt( start = 0, fixed = true);
//  Real SPFLosses( start = 0);
//  Real SPFNoLosses( start = 0);
//
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TReturn
    annotation (Placement(transformation(extent={{-14,-52},{6,-32}})));
  Modelica.Blocks.Sources.Sine sine(
    amplitude=30,
    freqHz=1/5000,
    offset=273.15+50,
    startTime=20000)
    annotation (Placement(transformation(extent={{-66,-52},{-46,-32}})));
equation
   boiler.TSet=273.15+82;
   volumeFlow1.m_flowSet = pulse.y / 1300;
//   der(PElLossesInt) = HP.PEl;
//   der(PElNoLossesInt) = HP_NoLosses.PEl;
//   der(QUsefulLossesInt) =thermalConductor.port_b.Q_flow;
//   der(QUsefulNoLossesInt) = thermalConductor1.port_b.Q_flow;
//   SPFLosses = if noEvent(PElLossesInt > 0) then QUsefulLossesInt/PElLossesInt else 0;
//   SPFNoLosses = if noEvent(PElNoLossesInt > 0) then QUsefulNoLossesInt/PElNoLossesInt else 0;

  connect(volumeFlow1.flowPort_b, isolatedPipe1.flowPort_a) annotation (Line(
      points={{-16,-6},{12,-6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(isolatedPipe1.flowPort_b, boiler.flowPort_a)        annotation (Line(
      points={{32,-6},{52,-6},{52,-8},{74,-8}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(boiler.flowPort_b, volumeFlow1.flowPort_a)        annotation (Line(
      points={{74,-4},{78,-4},{82,-62},{-76,-62},{-76,-6},{-36,-6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(absolutePressure.flowPort, boiler.flowPort_a)        annotation (Line(
      points={{58,72},{48,72},{48,-8},{74,-8}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(boiler.heatPort, fixedTemperature.port)
                                              annotation (Line(
      points={{64,4},{94,4},{94,-102},{66,-102}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TReturn.port, isolatedPipe1.heatPort)           annotation (Line(
      points={{6,-42},{22,-42},{22,-16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sine.y, TReturn.T) annotation (Line(
      points={{-45,-42},{-16,-42}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-200},
            {100,100}}),
                      graphics),
    experiment(StopTime=25000),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-200},{100,100}})),
    Commands(file="Scripts/Tester_Boiler.mos" "TestModel"));
end BoilerTester;
