within IDEAS.Thermal.Components.Examples;
model StorageTank_Losses "Check the total tank losses to environment"

  extends Modelica.Icons.Example;

  Thermal.Components.Storage.StorageTank storageTank(
    medium=Data.Media.Water(),
    TInitial={273.15 + 60 for i in 1:storageTank.nbrNodes},
    volumeTank=0.3,
    heightTank=1.6,
    UIns=0.4,
    preventNaturalDestratification=true)
    annotation (Placement(transformation(extent={{-58,-36},{-10,32}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=
        293.15) annotation (Placement(transformation(extent={{6,48},{26,68}})));
  Modelica.Blocks.Continuous.Integrator integrator
    annotation (Placement(transformation(extent={{54,-62},{74,-42}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heatFlowSensor
    annotation (Placement(transformation(extent={{10,-12},{30,8}})));
  Thermal.Components.BaseClasses.AbsolutePressure absolutePressure(medium=
        Data.Media.Water(), p=200000)
    annotation (Placement(transformation(extent={{-74,44},{-54,66}})));

  Real heatLosskWh24h=integrator.y/1e6/3.6;

equation
  connect(storageTank.heatExchEnv, heatFlowSensor.port_a) annotation (Line(
      points={{-18,-4.61538},{0.333333,-4.61538},{0.333333,-2},{10,-2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatFlowSensor.port_b, fixedTemperature.port) annotation (Line(
      points={{30,-2},{38,-2},{38,58},{26,58}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatFlowSensor.Q_flow, integrator.u) annotation (Line(
      points={{20,-12},{20,-52},{52,-52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(absolutePressure.flowPort, storageTank.flowPort_a) annotation (Line(
      points={{-74,55},{-78,55},{-78,42},{-10,42},{-10,26.7692}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (
    Diagram(graphics),
    experiment(StopTime=86400),
    __Dymola_experimentSetupOutput);
end StorageTank_Losses;
