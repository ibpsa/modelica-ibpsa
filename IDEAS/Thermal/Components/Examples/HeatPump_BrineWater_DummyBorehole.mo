within IDEAS.Thermal.Components.Examples;
model HeatPump_BrineWater_DummyBorehole
  "General example and tester for a brine-water heat pump without borehole"

extends Modelica.Icons.Example;

  Thermal.Components.BaseClasses.AbsolutePressure absolutePressure(medium=
        Data.Media.Water(), p=200000)
    annotation (Placement(transformation(extent={{66,-36},{86,-16}})));
  Thermal.Components.BaseClasses.Pump pump(
    medium=Data.Media.Water(),
    m=1,
    useInput=false,
    m_flowNom=0.2)
    annotation (Placement(transformation(extent={{-14,-24},{-34,-4}})));
  IDEAS.Thermal.Components.BaseClasses.Pipe_HeatPort pipe(
    medium=Data.Media.Water(),
    m=5,
    TInitial=313.15) annotation (Placement(transformation(extent={{32,-24},{12,-4}})));
  Production.HP_BrineWater
                    heater(
    medium=Data.Media.Water(),
    tauHeatLoss=3600,
    cDry=10000,
    QNom=6000,
    mWater=10,
    fraLosDesNom=0.8,
    QDesign=0) annotation (Placement(transformation(extent={{-76,14},{-56,34}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=293.15)
    annotation (Placement(transformation(extent={{-94,-20},{-80,-6}})));
  inner IDEAS.SimInfoManager         sim(
              redeclare IDEAS.Climate.Meteo.Locations.Uccle city, redeclare
      IDEAS.Climate.Meteo.Files.min60 detail)
    annotation (Placement(transformation(extent={{-92,74},{-72,94}})));
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
    freqHz=1/5000,
    startTime=5000,
    amplitude=4,
    offset=273.15 + 30)
    annotation (Placement(transformation(extent={{-82,-62},{-62,-42}})));
  BaseClasses.Pipe borehole(
    medium=Data.Media.Water(),
    m=5000,
    TInitial=277.15) "Dummy borehole"
                     annotation (Placement(transformation(extent={{-46,-18},{
            -60,-4}})));
  Thermal.Components.BaseClasses.Pump pump1(
    medium=Data.Media.Water(),
    m=1,
    useInput=false,
    m_flowNom=0.2)
    annotation (Placement(transformation(extent={{-54,-2},{-44,8}})));
  Thermal.Components.BaseClasses.AbsolutePressure absolutePressure1(
                                                                   medium=
        Data.Media.Water(), p=200000)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-46,-28})));
equation
   heater.TSet=273.15+35;
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
      points={{-34,-14},{-36,-14},{-36,16},{-56,16},{-56,19.6364}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(borehole.flowPort_b, heater.flowPortBrine_a) annotation (Line(
      points={{-60,-11},{-62,-11},{-62,-12},{-63.4,-12},{-63.4,14}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(heater.flowPortBrine_b, pump1.flowPort_a) annotation (Line(
      points={{-58.4,14},{-58,14},{-58,3},{-54,3}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pump1.flowPort_b, borehole.flowPort_a) annotation (Line(
      points={{-44,3},{-40,3},{-40,-11},{-46,-11}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(absolutePressure.flowPort, pipe.flowPort_a) annotation (Line(
      points={{66,-26},{40,-26},{40,-14},{32,-14}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(absolutePressure1.flowPort, borehole.flowPort_a) annotation (Line(
      points={{-46,-22},{-46,-11}},
      color={0,0,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,
            -100},{100,100}}),
                      graphics),
    experiment(StopTime=15000),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}})),
    Commands(file="Scripts/Tester_Boiler.mos" "TestModel"),
    Documentation(info="<html>
<p>This example shows the behaviour of a brine-water heat pump when the inlet water temperature is changed. </p>
<p>The on/off control will avoid takting of the heat pump.</p>
</html>"));
end HeatPump_BrineWater_DummyBorehole;
