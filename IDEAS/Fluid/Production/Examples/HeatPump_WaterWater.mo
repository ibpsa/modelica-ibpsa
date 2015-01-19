within IDEAS.Fluid.Production.Examples;
model HeatPump_WaterWater
  "General example and tester for a modulating water-to-water heat pump"
  extends Modelica.Icons.Example;
  parameter Real scaling = 2;

  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater
    annotation (__Dymola_choicesAllMatching=true);
  constant SI.MassFlowRate m_flow_nominal=0.3 "Nominal mass flow rate";
  Fluid.Movers.Pump pump(
    m=1,
    useInput=false,
    redeclare package Medium = Medium,
    m_flow_nominal=2550/3600,
    dpFix=50000)
    annotation (Placement(transformation(extent={{40,50},{20,70}})));
  inner IDEAS.SimInfoManager sim
    annotation (Placement(transformation(extent={{-92,74},{-72,94}})));
  Modelica.Blocks.Sources.Sine sine(
    freqHz=1/5000,
    amplitude=4,
    offset=273.15 + 30,
    startTime=2000)
    annotation (Placement(transformation(extent={{100,50},{80,70}})));
  Sources.Boundary_pT bou(          redeclare package Medium = Medium,
    use_T_in=true,
    p=200000,
    nPorts=2)
    annotation (Placement(transformation(extent={{70,72},{50,52}})));
  Fluid.Movers.Pump pump1(
    m=1,
    useInput=false,
    redeclare package Medium = Medium,
    m_flow_nominal=4200/3600)
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Sources.Boundary_pT bou1(         redeclare package Medium = Medium,
    use_T_in=true,
    p=200000,
    nPorts=2)
    annotation (Placement(transformation(extent={{-88,72},{-68,52}})));
  Modelica.Blocks.Sources.Sine sine1(
    amplitude=4,
    offset=273.15 + 10,
    startTime=4000,
    freqHz=1/3000)
    annotation (Placement(transformation(extent={{-118,50},{-98,70}})));
  replaceable HP_WaterWater_OnOff heatPump(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    use_onOffSignal=false,
    redeclare IDEAS.Fluid.Production.BaseClasses.VitoCal300GBWS301dotA29
      heatPumpData,
    onOff=true,
    use_scaling=false,
    avoidEvents=false) constrainedby HP_WaterWater_OnOff
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-10,70})));
  Fluid.Movers.Pump pump2(
    m=1,
    useInput=false,
    redeclare package Medium = Medium,
    m_flow_nominal=scaling*2550/3600,
    dpFix=50000)
    annotation (Placement(transformation(extent={{40,-50},{20,-30}})));
  Modelica.Blocks.Sources.Sine sine2(
    freqHz=1/5000,
    amplitude=4,
    offset=273.15 + 30,
    startTime=2000)
    annotation (Placement(transformation(extent={{100,-50},{80,-30}})));
  Sources.Boundary_pT bou2(         redeclare package Medium = Medium,
    nPorts=2,
    use_T_in=true,
    p=200000)
    annotation (Placement(transformation(extent={{70,-28},{50,-48}})));
  Fluid.Movers.Pump pump3(
    m=1,
    useInput=false,
    redeclare package Medium = Medium,
    m_flow_nominal=scaling*4200/3600,
    dpFix=50000)
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Sources.Boundary_pT bou3(         redeclare package Medium = Medium,
    use_T_in=true,
    p=200000,
    nPorts=2)
    annotation (Placement(transformation(extent={{-88,-18},{-68,-38}})));
  Modelica.Blocks.Sources.Sine sine3(
    amplitude=4,
    offset=273.15 + 10,
    startTime=4000,
    freqHz=1/3000)
    annotation (Placement(transformation(extent={{-118,-42},{-98,-22}})));
  replaceable HP_WaterWater_OnOff heatPump1(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    use_onOffSignal=false,
    redeclare IDEAS.Fluid.Production.BaseClasses.VitoCal300GBWS301dotA29
      heatPumpData,
    use_scaling=true,
    onOff=true,
    P_the_nominal=scaling*heatPump1.heatPumpData.P_the_nominal,
    avoidEvents=false) constrainedby HP_WaterWater_OnOff
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-10,-30})));
  Sensors.TemperatureTwoPort senTemBrine_out(redeclare package Medium = Medium,
      m_flow_nominal=4200/3600)
    annotation (Placement(transformation(extent={{-40,50},{-60,70}})));
  Sensors.TemperatureTwoPort senTemBrine_out1(redeclare package Medium = Medium,
      m_flow_nominal=scaling*4200/3600)
    annotation (Placement(transformation(extent={{-40,-48},{-56,-32}})));
  Sensors.TemperatureTwoPort senTemWater_out(redeclare package Medium = Medium,
      m_flow_nominal=2550/3600)
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Sensors.TemperatureTwoPort senTemWater_out1(redeclare package Medium = Medium,
      m_flow_nominal=scaling*2550/3600)
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
equation
  connect(sine.y, bou.T_in) annotation (Line(
      points={{79,60},{78,60},{78,58},{72,58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pump2.port_a, bou2.ports[1]) annotation (Line(
      points={{40,-40},{50,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sine2.y, bou2.T_in) annotation (Line(
      points={{79,-40},{72,-40},{72,-42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sine3.y,bou3. T_in) annotation (Line(
      points={{-97,-32},{-90,-32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senTemWater_out1.port_b, bou2.ports[2]) annotation (Line(
      points={{40,-20},{40,-36},{50,-36}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heatPump1.port_b2, senTemWater_out1.port_a) annotation (Line(
      points={{-4,-20},{20,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pump2.port_b, heatPump1.port_a2) annotation (Line(
      points={{20,-40},{-4,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pump3.port_b, heatPump1.port_a1) annotation (Line(
      points={{-40,-20},{-16,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemBrine_out1.port_a, heatPump1.port_b1) annotation (Line(
      points={{-40,-40},{-16,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(bou3.ports[1], senTemBrine_out1.port_b) annotation (Line(
      points={{-68,-30},{-68,-40},{-56,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pump3.port_a, bou3.ports[2]) annotation (Line(
      points={{-60,-20},{-68,-20},{-68,-26}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heatPump.port_b2, senTemWater_out.port_a) annotation (Line(
      points={{-4,80},{20,80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pump.port_b, heatPump.port_a2) annotation (Line(
      points={{20,60},{-4,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pump.port_a, bou.ports[1]) annotation (Line(
      points={{40,60},{50,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemWater_out.port_b, bou.ports[2]) annotation (Line(
      points={{40,80},{50,80},{50,64}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sine1.y, bou1.T_in) annotation (Line(
      points={{-97,60},{-94,60},{-94,58},{-90,58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pump1.port_b, heatPump.port_a1) annotation (Line(
      points={{-40,80},{-16,80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heatPump.port_b1, senTemBrine_out.port_a) annotation (Line(
      points={{-16,60},{-40,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemBrine_out.port_b, bou1.ports[1]) annotation (Line(
      points={{-60,60},{-68,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pump1.port_a, bou1.ports[2]) annotation (Line(
      points={{-60,80},{-68,80},{-68,64}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics),
    experiment(StopTime=15000),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}})),
    __Dymola_Commands(file="modelica://IDEAS/Resources/Scripts/Dymola/Fluid/Production/Examples/HeatPump_WaterWater.mos"
        "Simulate and plot"),    Documentation(info="<html>
<p>This example demonstrates the use of a heat pump.</p>
</html>", revisions="<html>
<ul>
<li>March 2014 by Filip Jorissen:<br/> 
Initial version
</li>
</ul>
</html>"));
end HeatPump_WaterWater;
