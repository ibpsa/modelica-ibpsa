within IDEAS.Thermal.Components.Examples;
model Radiator_EnergyBalance "Test for energy balance of the radiator model"

extends Modelica.Icons.Example;

  Real QBoiler( start = 0);
  Real QRadiator( start = 0);

  Thermal.Components.BaseClasses.AbsolutePressure absolutePressure(medium=
        Data.Media.Water(), p=200000)
    annotation (Placement(transformation(extent={{50,-52},{70,-32}})));
  Thermal.Components.BaseClasses.Pump volumeFlow1(
    medium=Data.Media.Water(),
    m=4,
    m_flowNom=0.05,
    TInitial=293.15,
    useInput=true)
    annotation (Placement(transformation(extent={{-36,-16},{-16,4}})));
  IDEAS.Thermal.Components.BaseClasses.Pipe_HeatPort
                                            boiler(
    medium=Data.Media.Water(),
    m=5,
    TInitial=293.15) annotation (Placement(transformation(extent={{12,-16},{32,4}})));
  Emission.Radiator   radiator(
    medium=Data.Media.Water(),
                          QNom=3000,
    TInNom=318.15,
    TOutNom=308.15,
    powerFactor=3.37) "Hydraulic radiator model"
               annotation (Placement(transformation(extent={{52,-16},{72,4}})));
  inner IDEAS.SimInfoManager         sim(redeclare
      IDEAS.Climate.Meteo.Files.min15
      detail, redeclare IDEAS.Climate.Meteo.Locations.Uccle city)
    annotation (Placement(transformation(extent={{-84,68},{-64,88}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature
    prescribedTemperature(T=293.15)
    annotation (Placement(transformation(extent={{32,24},{52,44}})));
  Modelica.Blocks.Sources.Pulse step(
    startTime=10000,
    offset=0,
    amplitude=3000,
    period=10000,
    nperiod=3)
    annotation (Placement(transformation(extent={{-62,-50},{-42,-30}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow
                                                      boilerHeatFlow
    annotation (Placement(transformation(extent={{-12,-50},{8,-30}})));
  Modelica.Blocks.Sources.Pulse step1(
    startTime=10000,
    offset=0,
    period=10000,
    amplitude=1,
    nperiod=5)
    annotation (Placement(transformation(extent={{-56,30},{-36,50}})));
equation
der(QBoiler) = boilerHeatFlow.Q_flow;
der(QRadiator) = -radiator.heatPortCon.Q_flow - radiator.heatPortRad.Q_flow;

  connect(volumeFlow1.flowPort_b, boiler.flowPort_a)        annotation (Line(
      points={{-16,-6},{12,-6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(boiler.flowPort_b, radiator.flowPort_a)             annotation (Line(
      points={{32,-6},{42,-6},{42,-12.25},{52,-12.25}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(radiator.flowPort_b, volumeFlow1.flowPort_a)      annotation (Line(
      points={{72,0.25},{82,0.25},{82,-62},{-76,-62},{-76,-6},{-36,-6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(absolutePressure.flowPort, radiator.flowPort_a)      annotation (Line(
      points={{50,-42},{50,-30},{48,-30},{48,-12.25},{52,-12.25}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(prescribedTemperature.port, radiator.heatPortRad) annotation (Line(
      points={{52,34},{67.8333,34},{67.8333,4}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(boilerHeatFlow.port, boiler.heatPort) annotation (Line(
      points={{8,-40},{14,-40},{14,-38},{22,-38},{22,-16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(step.y, boilerHeatFlow.Q_flow) annotation (Line(
      points={{-41,-40},{-12,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(step1.y, volumeFlow1.m_flowSet) annotation (Line(
      points={{-35,40},{-26,40},{-26,4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedTemperature.port, radiator.heatPortCon) annotation (Line(
      points={{52,34},{64.5,34},{64.5,4}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics),
    experiment(StopTime=100000),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>This model checks the energy balance of the radiator for flow and no-flow situations.</p>
<p>Plot the QBoiler and QRadiator variables over 100k seconds to make sure that in-out energy balance of the radiator is fine. </p>
</html>"));
end Radiator_EnergyBalance;
