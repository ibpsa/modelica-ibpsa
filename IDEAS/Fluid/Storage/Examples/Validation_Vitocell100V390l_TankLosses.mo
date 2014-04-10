within IDEAS.Fluid.Storage.Examples;
model Validation_Vitocell100V390l_TankLosses
  "Check the total tank losses to environment"

  extends Modelica.Icons.Example;

  parameter Modelica.SIunits.ThermalConductance UACon(min=0) = 1.61
    "Additional thermal conductance for connection losses and imperfect insulation";

  StorageTank_OneIntHX storageTank(
    medium=Thermal.Data.Media.Water(),
    mediumHX=Thermal.Data.Media.Water(),
    TInitial={273.15 + 65 for i in 1:storageTank.nbrNodes},
    UIns=0.4,
    UACon=UACon,
    preventNaturalDestratification=true,
    volumeTank=0.39,
    heightTank=1.4,
    nbrNodes=40)
    annotation (Placement(transformation(extent={{-26,6},{-10,28}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=
        293.15)
    annotation (Placement(transformation(extent={{-30,50},{-10,70}})));
  Modelica.Blocks.Continuous.Integrator integrator
    annotation (Placement(transformation(extent={{32,-30},{52,-10}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heatFlowSensor
    annotation (Placement(transformation(extent={{10,6},{30,26}})));
  Thermal.Components.BaseClasses.AbsolutePressure absolutePressure(medium=
        Thermal.Data.Media.Water(),
                            p=200000)
    annotation (Placement(transformation(extent={{-74,44},{-54,66}})));

  Real heatLosskWh24h=integrator.y/1e6/3.6;

equation
  connect(storageTank.heatExchEnv, heatFlowSensor.port_a) annotation (Line(
      points={{-12.6667,16.1538},{0.333333,16.1538},{0.333333,16},{10,16}},
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
      points={{-74,55},{-80,55},{-80,54},{-84,54},{-84,24},{-10,24},{-10,
          26.3077}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(absolutePressure.flowPort, storageTank.flowPortHXUpper) annotation (
      Line(
      points={{-74,55},{-76,55},{-76,12.7692},{-26,12.7692}},
      color={255,0,0},
      smooth=Smooth.None));
  annotation (
    Diagram(graphics),
    experiment(StopTime=86400, Interval=600),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>This validation model checks the 24h thermal losses of a storage tank at 60&deg;C.</p>
<p>These losses should amount to 2.78 kWh over 24h. The current model results in 2.78916 kWh/24h.</p>
</html>"));
end Validation_Vitocell100V390l_TankLosses;
