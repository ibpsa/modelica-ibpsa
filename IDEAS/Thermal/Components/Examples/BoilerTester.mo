within IDEAS.Thermal.Components.Examples;
model BoilerTester "Identical as the one in FluidHeatFlow_NoPressure"

extends Modelica.Icons.Example;

  Thermal.Components.BaseClasses.AbsolutePressure absolutePressure(medium=
        Data.Media.Water(), p=200000)
    annotation (Placement(transformation(extent={{58,62},{78,82}})));
  Thermal.Components.BaseClasses.Pump volumeFlow1(
    medium=Data.Media.Water(),
    m=1,
    m_flowNom=1300/3600,
    useInput=true)
    annotation (Placement(transformation(extent={{-46,20},{-26,40}})));
  IDEAS.Thermal.Components.BaseClasses.Pipe_HeatPort
                                            isolatedPipe1(
    medium=Data.Media.Water(),
    m=5,
    TInitial=313.15) annotation (Placement(transformation(extent={{2,20},{22,40}})));
  IDEAS.Thermal.Components.Production.Boiler
                    boiler(
    medium=Data.Media.Water(),
    QNom=5000,
    tauHeatLoss=3600,
    mWater=10,
    cDry=10000)
               annotation (Placement(transformation(extent={{44,20},{64,40}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=293.15)
    annotation (Placement(transformation(extent={{36,-76},{56,-56}})));
  inner IDEAS.SimInfoManager         sim(
              redeclare IDEAS.Climate.Meteo.Locations.Uccle city, redeclare
      IDEAS.Climate.Meteo.Files.min5 detail)
    annotation (Placement(transformation(extent={{-84,68},{-64,88}})));
  Modelica.Blocks.Sources.TimeTable
                                pulse(offset=0, table=[0,0; 5000,100; 10000,400;
        15000,700; 20000,1000; 25000,1300; 50000,1300])
    annotation (Placement(transformation(extent={{-48,68},{-28,88}})));
//  Real PElLossesInt( start = 0, fixed = true);
//  Real PElNoLossesInt( start = 0, fixed = true);
//  Real QUsefulLossesInt( start = 0, fixed = true);
//  Real QUsefulNoLossesInt( start = 0, fixed = true);
//  Real SPFLosses( start = 0);
//  Real SPFNoLosses( start = 0);
//
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TReturn
    annotation (Placement(transformation(extent={{-24,-16},{-4,4}})));
  Modelica.Blocks.Sources.Sine sine(
    amplitude=30,
    freqHz=1/5000,
    offset=273.15+50,
    startTime=20000)
    annotation (Placement(transformation(extent={{-76,-16},{-56,4}})));
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
      points={{-26,30},{2,30}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(isolatedPipe1.flowPort_b, boiler.flowPort_a)        annotation (Line(
      points={{22,30},{42,30},{42,25.6364},{64,25.6364}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(boiler.flowPort_b, volumeFlow1.flowPort_a)        annotation (Line(
      points={{64,30.9091},{68,30.9091},{72,-26},{-86,-26},{-86,30},{-46,30}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(absolutePressure.flowPort, boiler.flowPort_a)        annotation (Line(
      points={{58,72},{38,72},{38,25.6364},{64,25.6364}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(boiler.heatPort, fixedTemperature.port)
                                              annotation (Line(
      points={{51,20},{84,20},{84,-66},{56,-66}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TReturn.port, isolatedPipe1.heatPort)           annotation (Line(
      points={{-4,-6},{12,-6},{12,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sine.y, TReturn.T) annotation (Line(
      points={{-55,-6},{-26,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                      graphics),
    experiment(StopTime=25000),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}})),
    Commands(file="Scripts/Tester_Boiler.mos" "TestModel"));
end BoilerTester;
