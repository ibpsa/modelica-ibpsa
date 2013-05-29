within IDEAS.Thermal.Components.Examples;
model TankLosses "Check the total tank losses to environment"

extends Modelica.Icons.Example;

  Thermal.Components.Storage.StorageTank storageTank(
    medium=Data.Media.Water(),
    TInitial={273.15 + 60 for i in 1:storageTank.nbrNodes},
    volumeTank=0.3,
    heightTank=1.6,
    U=0.4,
    preventNaturalDestratification=true)
    annotation (Placement(transformation(extent={{-26,6},{-6,26}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=293.15)
    annotation (Placement(transformation(extent={{-30,50},{-10,70}})));
  Modelica.Blocks.Continuous.Integrator integrator
    annotation (Placement(transformation(extent={{32,-30},{52,-10}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heatFlowSensor
    annotation (Placement(transformation(extent={{10,6},{30,26}})));
  Thermal.Components.BaseClasses.AbsolutePressure absolutePressure(medium=
        Data.Media.Water(), p=200000)
    annotation (Placement(transformation(extent={{-74,44},{-54,66}})));

  Real heatLosskWh24h = integrator.y/1e6/3.6;

equation
  connect(storageTank.heatExchEnv, heatFlowSensor.port_a) annotation (Line(
      points={{-9.33333,15.2308},{0.333333,15.2308},{0.333333,16},{10,16}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatFlowSensor.port_b, fixedTemperature.port) annotation (Line(
      points={{30,16},{38,16},{38,60},{-10,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatFlowSensor.Q_flow, integrator.u) annotation (Line(
      points={{20,6},{20,-20},{30,-20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(absolutePressure.flowPort, storageTank.flowPort_a) annotation (Line(
      points={{-74,55},{-80,55},{-80,54},{-84,54},{-84,24},{-6,24},{-6,24.4615}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics));
end TankLosses;
