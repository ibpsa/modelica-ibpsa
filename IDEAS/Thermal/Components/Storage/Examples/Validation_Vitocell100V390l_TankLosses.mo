within IDEAS.Thermal.Components.Storage.Examples;
model Validation_Vitocell100V390l_TankLosses
  "Check the total tank losses to environment"

  parameter Modelica.SIunits.ThermalConductance UACon(min=0)=1.61
    "Additional thermal conductance for connection losses and imperfect insulation";

  StorageTank_OneIntHX                   storageTank(
    medium=Data.Media.Water(),
    mediumHX=Data.Media.Water(),
    TInitial={273.15 + 65 for i in 1:storageTank.nbrNodes},
    UIns=0.4,
    UACon=UACon,
    preventNaturalDestratification=true,
    volumeTank=0.39,
    heightTank=1.4,
    lamBuo=1000,
    nbrNodes=40)
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
      points={{-9.8,16},{10,16}},
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
      points={{-74,55},{-80,55},{-80,54},{-84,54},{-84,24},{-16,24},{-16,26}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(absolutePressure.flowPort, storageTank.flowPortHXUpper) annotation (
      Line(
      points={{-74,55},{-76,55},{-76,18},{-26,18}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics),
    experiment(
      StopTime=86400,
      Interval=600,
      Algorithm="Lsodar"),
    __Dymola_experimentSetupOutput);
end Validation_Vitocell100V390l_TankLosses;
