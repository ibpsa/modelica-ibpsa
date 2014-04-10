within IDEAS.Fluid.Storage.Examples;
model StorageTank_Losses "Check the total tank losses to environment"

  extends Modelica.Icons.Example;
   package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater annotation (
      __Dymola_choicesAllMatching=true);

  Fluid.Storage.StorageTank storageTank(
    T_start={273.15 + 60 for i in 1:storageTank.nbrNodes},
    volumeTank=0.3,
    heightTank=1.6,
    UIns=0.4,
    preventNaturalDestratification=true,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-58,-36},{-10,32}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=
        293.15) annotation (Placement(transformation(extent={{6,48},{26,68}})));
  Modelica.Blocks.Continuous.Integrator integrator
    annotation (Placement(transformation(extent={{54,-62},{74,-42}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heatFlowSensor
    annotation (Placement(transformation(extent={{10,-12},{30,8}})));

  Real heatLosskWh24h=integrator.y/1e6/3.6;

  Sources.Boundary_pT             bou(
    redeclare package Medium = Medium,
    nPorts=1,
    p=200000) annotation (Placement(transformation(extent={{-74,52},{-54,72}})));
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
  connect(bou.ports[1], storageTank.port_a) annotation (Line(
      points={{-54,62},{-10,62},{-10,26.7692}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
            graphics),
    experiment(StopTime=86400),
    __Dymola_experimentSetupOutput,
    Documentation(revisions="<html>
<ul>
<li>March 2014 by Filip Jorissen:<br/> 
Annex60 compatibility
</li>
</ul>
</html>"));
end StorageTank_Losses;
