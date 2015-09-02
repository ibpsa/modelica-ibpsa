within IDEAS.Fluid.Production.Examples;
model HeatPump_AirWater
  "General example and tester for a modulating air-to-water heat pump"
  extends Modelica.Icons.Example;
  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater
    annotation (__Dymola_choicesAllMatching=true);
  Fluid.Movers.Pump pump(
    m=1,
    useInput=false,
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-14,-24},{-34,-4}})));
  IDEAS.Fluid.FixedResistances.Pipe_HeatPort pipe(
    m=5,
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    T_start(displayUnit="K") = 313.15)
    annotation (Placement(transformation(extent={{32,-4},{12,-24}})));
  HP_AirWater_TSet heater(
    tauHeatLoss=3600,
    cDry=10000,
    mWater=4,
    QNom=12000,
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-74,14},{-56,34}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=
        293.15)
    annotation (Placement(transformation(extent={{-94,-20},{-80,-6}})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TReturn
    annotation (Placement(transformation(extent={{-40,-62},{-20,-42}})));
  Modelica.Blocks.Sources.Sine sine(
    freqHz=1/5000,
    startTime=5000,
    amplitude=4,
    offset=273.15 + 30)
    annotation (Placement(transformation(extent={{-82,-62},{-62,-42}})));
  Sources.Boundary_pT bou(nPorts=1, redeclare package Medium = Medium,
    p=200000)
    annotation (Placement(transformation(extent={{-8,8},{-28,28}})));
  constant Modelica.SIunits.MassFlowRate m_flow_nominal=0.2
    "Nominal mass flow rate";
  inner SimInfoManager sim
    annotation (Placement(transformation(extent={{-100,78},{-80,98}})));
  Modelica.Blocks.Sources.Constant Tset(k=273.15 + 35) "Temperature set point"
    annotation (Placement(transformation(extent={{-22,44},{-42,64}})));
equation

  connect(heater.heatPort, fixedTemperature.port) annotation (Line(
      points={{-67.7,14},{-70,14},{-70,-12},{-76,-12},{-76,-13},{-80,-13}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TReturn.port, pipe.heatPort) annotation (Line(
      points={{-20,-52},{22,-52},{22,-24}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sine.y, TReturn.T) annotation (Line(
      points={{-61,-52},{-42,-52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heater.port_b, pipe.port_a) annotation (Line(
      points={{-56,30},{-56,36},{48,36},{48,-14},{32,-14}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pipe.port_b, pump.port_a) annotation (Line(
      points={{12,-14},{-14,-14}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pump.port_b, heater.port_a) annotation (Line(
      points={{-34,-14},{-56,-14},{-56,18}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(bou.ports[1], heater.port_a) annotation (Line(
      points={{-28,18},{-42,18},{-42,18},{-56,18}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(Tset.y, heater.TSet) annotation (Line(points={{-43,54},{-68.6,54},{-68.6,
          36}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    experiment(StopTime=15000),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}})),
    Commands(file=
          "Resources/Scripts/Dymola/Fluid/Production/Examples/HeatPump_AirWater.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>This example shows the modulation behaviour of an inverter controlled air-to-water heat pump when the inlet water temperature is changed. </p>
<p>The modulation level can be seen from heater.heatSource.modulation.</p>
</html>", revisions="<html>
<ul>
<li>March 2014 by Filip Jorissen:<br/> 
Annex60 compatibility
</li>
</ul>
</html>"));
end HeatPump_AirWater;
