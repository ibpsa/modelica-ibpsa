within IDEAS.Thermal.Components.Examples;
model IdealHeater "Very basic hydraulic circuit with an IdealHeater"

extends Modelica.Icons.Example;

  Thermal.Components.BaseClasses.AbsolutePressure absolutePressure(medium=
        Data.Media.Water(), p=200000)
    annotation (Placement(transformation(extent={{-36,10},{-16,30}})));
  Thermal.Components.BaseClasses.Pump pump(
    medium=Data.Media.Water(),
    m=1,
    m_flowNom=1300/3600,
    useInput=true)
    annotation (Placement(transformation(extent={{-14,-24},{-34,-4}})));
  IDEAS.Thermal.Components.BaseClasses.Pipe_HeatPort pipe(
    medium=Data.Media.Water(),
    m=5,
    TInitial=313.15) annotation (Placement(transformation(extent={{32,-24},{12,-4}})));
  Production.IdealHeater
                    heater(
    medium=Data.Media.Water(),
    tauHeatLoss=3600)
               annotation (Placement(transformation(extent={{-76,14},{-56,34}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=293.15)
    annotation (Placement(transformation(extent={{-94,-20},{-80,-6}})));
  inner IDEAS.SimInfoManager         sim(
              redeclare IDEAS.Climate.Meteo.Locations.Uccle city, redeclare
      IDEAS.Climate.Meteo.Files.min60 detail)
    annotation (Placement(transformation(extent={{-92,74},{-72,94}})));
  Modelica.Blocks.Sources.TimeTable
                                pulse(offset=0, table=[0,0; 5000,0; 5000,400; 10000,
        400; 10000,1000; 25000,1000; 30000,1300])
    annotation (Placement(transformation(extent={{-50,72},{-30,92}})));
//  Real PElLossesInt( start = 0, fixed = true);
//  Real PElNoLossesInt( start = 0, fixed = true);
//  Real QUsefulLossesInt( start = 0, fixed = true);
//  Real QUsefulNoLossesInt( start = 0, fixed = true);
//  Real SPFLosses( start = 0);
//  Real SPFNoLosses( start = 0);
//
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TReturn
    annotation (Placement(transformation(extent={{-40,-62},{-20,-42}})));
  Modelica.Blocks.Sources.Sine sine(
    amplitude=30,
    freqHz=1/5000,
    offset=273.15+50,
    startTime=20000)
    annotation (Placement(transformation(extent={{-82,-62},{-62,-42}})));
equation
   heater.TSet=273.15+82;
   pump.m_flowSet = pulse.y / 1300;
//   der(PElLossesInt) = HP.PEl;
//   der(PElNoLossesInt) = HP_NoLosses.PEl;
//   der(QUsefulLossesInt) =thermalConductor.port_b.Q_flow;
//   der(QUsefulNoLossesInt) = thermalConductor1.port_b.Q_flow;
//   SPFLosses = if noEvent(PElLossesInt > 0) then QUsefulLossesInt/PElLossesInt else 0;
//   SPFNoLosses = if noEvent(PElNoLossesInt > 0) then QUsefulNoLossesInt/PElNoLossesInt else 0;

  connect(heater.heatPort, fixedTemperature.port)
                                              annotation (Line(
      points={{-69,14},{-70,14},{-70,-12},{-76,-12},{-76,-13},{-80,-13}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TReturn.port, pipe.heatPort)                    annotation (Line(
      points={{-20,-52},{22,-52},{22,-24}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sine.y, TReturn.T) annotation (Line(
      points={{-61,-52},{-42,-52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heater.flowPort_b, pipe.flowPort_a) annotation (Line(
      points={{-56,24.9091},{-56,36},{48,36},{48,-14},{32,-14}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pipe.flowPort_b, pump.flowPort_a) annotation (Line(
      points={{12,-14},{-14,-14}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pump.flowPort_b, heater.flowPort_a) annotation (Line(
      points={{-34,-14},{-56,-14},{-56,19.6364}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(heater.flowPort_a, absolutePressure.flowPort) annotation (Line(
      points={{-56,19.6364},{-44,19.6364},{-44,20},{-36,20}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},
            {100,100}}),
                      graphics),
    experiment(StopTime=40000),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}})),
    Commands(file="Scripts/Tester_Boiler.mos" "TestModel"),
    Documentation(info="<html>
<p>This model, with abruptly changin water return temperatures to an IdealHeater, shows that the heater is able to reach the setpoint in almost all time instants. </p>
</html>"));
end IdealHeater;
