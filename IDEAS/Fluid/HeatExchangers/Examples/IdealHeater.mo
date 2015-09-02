within IDEAS.Fluid.HeatExchangers.Examples;
model IdealHeater "Very basic hydraulic circuit with an IdealHeater"

  extends Modelica.Icons.Example;
  constant SI.MassFlowRate m_flow_nominal=1300/3600 "Nominal mass flow rate";
  Fluid.Movers.Pump pump(
    m=1,
    useInput=true,
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{-14,-24},{-34,-4}})));
  IDEAS.Fluid.FixedResistances.Pipe_HeatPort pipe(
    m=5,
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    T_start=313.15)
    annotation (Placement(transformation(extent={{32,-4},{12,-24}})));
  Fluid.Production.IdealHeater heater(
  tauHeatLoss=3600,
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial)
              annotation (Placement(transformation(extent={{-76,14},{-56,34}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=
        293.15)
    annotation (Placement(transformation(extent={{-94,-20},{-80,-6}})));
  inner IDEAS.SimInfoManager sim
    annotation (Placement(transformation(extent={{-92,74},{-72,94}})));
  Modelica.Blocks.Sources.TimeTable pulse(
  offset=0,
  table=[0, 0; 5000, 0; 5000, 400; 10000, 400;
         10000, 1000; 25000, 1000; 30000, 1300])
    annotation (Placement(transformation(extent={{-50,72},{-30,92}})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TReturn
    annotation (Placement(transformation(extent={{-40,-62},{-20,-42}})));
  Modelica.Blocks.Sources.Sine sine(
    amplitude=30,
    freqHz=1/5000,
    offset=273.15 + 50,
    startTime=20000)
    annotation (Placement(transformation(extent={{-82,-62},{-62,-42}})));
  Sources.Boundary_pT bou(
    redeclare package Medium = Medium,
    nPorts=1,
    p=200000) annotation (Placement(transformation(extent={{-14,10},{-34,30}})));
  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater
    annotation (__Dymola_choicesAllMatching=true);

  Modelica.Blocks.Math.Gain gain(k=1/1300)
    annotation (Placement(transformation(extent={{-18,72},{2,92}})));
  Modelica.Blocks.Sources.Constant const(k=273.15 + 82)
    annotation (Placement(transformation(extent={{-100,48},{-88,60}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(
    T=0.1,
    initType=Modelica.Blocks.Types.Init.InitialState,
    y_start=0) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={16,62})));
equation
  connect(heater.heatPort, fixedTemperature.port) annotation (Line(
      points={{-69,14},{-70,14},{-70,-12},{-76,-12},{-76,-13},{-80,-13}},
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
      points={{-34,20},{-34,18},{-56,18}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(gain.u, pulse.y) annotation (Line(
      points={{-20,82},{-29,82}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.y, heater.TSet) annotation (Line(
      points={{-87.4,54},{-78,54},{-78,36},{-70,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.y, firstOrder.u) annotation (Line(
      points={{3,82},{16,82},{16,74}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(firstOrder.y, pump.m_flowSet) annotation (Line(
      points={{16,51},{16,4},{-24,4},{-24,-3.6}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),     graphics),
    experiment(StopTime=40000),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}})),
    Commands(file="Scripts/Tester_Boiler.mos" "TestModel"),
    Documentation(info="<html>
<p>This model, with abruptly changin water return temperatures to an IdealHeater, shows that the heater is able to reach the setpoint in almost all time instants. </p>
</html>", revisions="<html>
<ul>
<li>March 2014 by Filip Jorissen:<br/> 
Annex60 compatibility
</li>
</ul>
</html>"));
end IdealHeater;
