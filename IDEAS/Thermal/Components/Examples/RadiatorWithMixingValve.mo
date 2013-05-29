within IDEAS.Thermal.Components.Examples;
model RadiatorWithMixingValve
  "Radiator circuit with a simplified boiler and thermal mixing valve"

extends Modelica.Icons.Example;

  Thermal.Components.BaseClasses.Pump volumeFlow1(
    medium=Data.Media.Water(),
    m=4,
    TInitial=313.15,
    m_flowNom=0.07)
    annotation (Placement(transformation(extent={{76,-86},{56,-66}})));
  IDEAS.Thermal.Components.BaseClasses.Pipe_HeatPort
                                            boiler(
    medium=Data.Media.Water(),
    m=5,
    TInitial=333.15) annotation (Placement(transformation(extent={{-26,-16},{-6,
            4}})));
  Emission.Radiator   radiator(
    medium=Data.Media.Water(),
    TInitial=293.15,
    QNom=5000) "Hydraulic radiator model"
               annotation (Placement(transformation(extent={{52,-10},{72,10}})));
  inner IDEAS.SimInfoManager         sim(redeclare
      IDEAS.Climate.Meteo.Files.min15
      detail, redeclare IDEAS.Climate.Meteo.Locations.Uccle city,
    occBeh=false,
    PV=false)
    annotation (Placement(transformation(extent={{-84,68},{-64,88}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature
    annotation (Placement(transformation(extent={{30,52},{50,72}})));
  Modelica.Blocks.Sources.Step step(
    offset=291,
    height=5,
    startTime=2000)
    annotation (Placement(transformation(extent={{-8,52},{12,72}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature
                                                      fixedHeatFlow(T=333.15)
    annotation (Placement(transformation(extent={{-50,-52},{-30,-32}})));

  BaseClasses.Thermostatic3WayValve thermostaticValve(mFlowMin=0.01)
    annotation (Placement(transformation(extent={{10,-16},{30,4}})));
  Thermal.Components.BaseClasses.AbsolutePressure absolutePressure
    annotation (Placement(transformation(extent={{52,-42},{72,-22}})));
  Modelica.Blocks.Sources.Constant const(k=273.15 + 45)
    annotation (Placement(transformation(extent={{-2,6},{10,18}})));
equation

  connect(volumeFlow1.flowPort_b, boiler.flowPort_a)        annotation (Line(
      points={{56,-76},{-70,-76},{-70,-6},{-26,-6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(radiator.flowPort_b, volumeFlow1.flowPort_a)      annotation (Line(
      points={{72,6.25},{94,6.25},{94,-76},{76,-76}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(step.y, prescribedTemperature.T) annotation (Line(
      points={{13,62},{28,62}},
      color={0,0,127},
      thickness=0.5,
      smooth=Smooth.None));
  connect(prescribedTemperature.port, radiator.heatPortRad) annotation (Line(
      points={{50,62},{67.8333,62},{67.8333,10}},
      color={191,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(fixedHeatFlow.port, boiler.heatPort) annotation (Line(
      points={{-30,-42},{-16,-42},{-16,-16}},
      color={191,0,0},
      thickness=0.5,
      smooth=Smooth.None));
  connect(boiler.flowPort_b, thermostaticValve.flowPortHot)     annotation (
      Line(
      points={{-6,-6},{10,-6}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(thermostaticValve.flowPortMixed, radiator.flowPort_a)     annotation (
     Line(
      points={{30,-6},{41,-6},{41,-6.25},{52,-6.25}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(volumeFlow1.flowPort_b, thermostaticValve.flowPortCold)
    annotation (Line(
      points={{56,-76},{20,-76},{20,-16}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(absolutePressure.flowPort, radiator.flowPort_a) annotation (Line(
      points={{52,-32},{42,-32},{42,-6.25},{52,-6.25}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(prescribedTemperature.port, radiator.heatPortCon) annotation (Line(
      points={{50,62},{56,62},{56,32},{64.5,32},{64.5,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(const.y, thermostaticValve.TMixedSet) annotation (Line(
      points={{10.6,12},{20,12},{20,4}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics),
    experiment(StopTime=3600),
    __Dymola_experimentSetupOutput);
end RadiatorWithMixingValve;
