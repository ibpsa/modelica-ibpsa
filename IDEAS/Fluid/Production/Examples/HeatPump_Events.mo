within IDEAS.Fluid.Production.Examples;
model HeatPump_Events
  "General example and tester for a modulating water-to-water heat pump"
  extends Modelica.Icons.Example;
  parameter Real scaling = 2;

  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater
    annotation (__Dymola_choicesAllMatching=true);
  constant SI.MassFlowRate m_flow_nominal=0.3 "Nominal mass flow rate";
  Fluid.Movers.Pump pump(
    m=1,
    redeclare package Medium = Medium,
    useInput=true,
    m_flow_nominal=0.3,
    dpFix=50000)
    annotation (Placement(transformation(extent={{-10,44},{-30,64}})));
  inner IDEAS.SimInfoManager sim
    annotation (Placement(transformation(extent={{80,78},{100,98}})));
  Modelica.Blocks.Sources.Sine sine(
    freqHz=1/5000,
    amplitude=4,
    offset=273.15 + 30,
    startTime=2000)
    annotation (Placement(transformation(extent={{88,42},{68,62}})));
  Sources.Boundary_pT bou(          redeclare package Medium = Medium,
    nPorts=2,
    use_T_in=true,
    p=200000)
    annotation (Placement(transformation(extent={{54,66},{34,46}})));
  Fluid.Movers.Pump pump1(
    m=1,
    redeclare package Medium = Medium,
    m_flow_nominal=4200/3600,
    useInput=true)
    annotation (Placement(transformation(extent={{-10,28},{-30,8}})));
  Sources.Boundary_pT bou1(         redeclare package Medium = Medium,
    nPorts=2,
    use_T_in=true,
    p=200000)
    annotation (Placement(transformation(extent={{54,20},{34,0}})));
  Modelica.Blocks.Sources.Sine sine1(
    amplitude=4,
    offset=273.15 + 10,
    startTime=4000,
    freqHz=1/3000)
    annotation (Placement(transformation(extent={{88,-4},{68,16}})));
  replaceable HP_WaterWater_OnOff heatPump(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    redeclare IDEAS.Fluid.Production.BaseClasses.VitoCal300GBWS301dotA29
      heatPumpData,
    use_scaling=false,
    avoidEvents=avoidEvents.k,
    use_onOffSignal=true,
    riseTime=120) constrainedby HP_WaterWater_OnOff
    annotation (Placement(transformation(extent={{-62,48},{-42,68}})));
  Sensors.TemperatureTwoPort senTemBrine_out(redeclare package Medium = Medium,
      m_flow_nominal=4200/3600)
    annotation (Placement(transformation(extent={{-58,26},{-42,42}})));
  Sensors.TemperatureTwoPort senTemWater_out(redeclare package Medium = Medium,
      m_flow_nominal=2550/3600)
    annotation (Placement(transformation(extent={{-24,70},{-6,88}})));
  Fluid.Movers.Pump pump2(
    m=1,
    redeclare package Medium = Medium,
    useInput=true,
    m_flow_nominal=0.3,
    dpFix=50000)
    annotation (Placement(transformation(extent={{-4,-50},{-24,-30}})));
  Modelica.Blocks.Sources.Sine sine2(
    freqHz=1/5000,
    amplitude=4,
    offset=273.15 + 30,
    startTime=2000)
    annotation (Placement(transformation(extent={{94,-52},{74,-32}})));
  Sources.Boundary_pT bou2(         redeclare package Medium = Medium,
    nPorts=2,
    use_T_in=true,
    p=200000)
    annotation (Placement(transformation(extent={{60,-28},{40,-48}})));
  Fluid.Movers.Pump pump3(
    m=1,
    redeclare package Medium = Medium,
    m_flow_nominal=4200/3600,
    useInput=true)
    annotation (Placement(transformation(extent={{-4,-66},{-24,-86}})));
  Sources.Boundary_pT bou3(         redeclare package Medium = Medium,
    nPorts=2,
    use_T_in=true,
    p=200000)
    annotation (Placement(transformation(extent={{60,-74},{40,-94}})));
  Modelica.Blocks.Sources.Sine sine3(
    amplitude=4,
    offset=273.15 + 10,
    startTime=4000,
    freqHz=1/3000)
    annotation (Placement(transformation(extent={{94,-98},{74,-78}})));
  replaceable HP_WaterWater_OnOff heatPump1(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    redeclare IDEAS.Fluid.Production.BaseClasses.VitoCal300GBWS301dotA29
      heatPumpData,
    onOff=true,
    use_scaling=false,
    use_onOffSignal=true,
    avoidEvents=avoidEvents1.k,
    riseTime=120) constrainedby HP_WaterWater_OnOff
    annotation (Placement(transformation(extent={{-56,-46},{-36,-26}})));
  Sensors.TemperatureTwoPort senTemBrine_out1(
                                             redeclare package Medium = Medium,
      m_flow_nominal=4200/3600)
    annotation (Placement(transformation(extent={{-52,-68},{-36,-52}})));
  Sensors.TemperatureTwoPort senTemWater_out1(
                                             redeclare package Medium = Medium,
      m_flow_nominal=2550/3600)
    annotation (Placement(transformation(extent={{-18,-24},{0,-6}})));
   Modelica.Blocks.Sources.BooleanConstant avoidEvents1(k=true)
    "Switch to see influence on generated events"
     annotation (Placement(transformation(extent={{-102,-60},{-82,-40}})));
   Modelica.Blocks.Math.RealToBoolean realToBoolean
     annotation (Placement(transformation(extent={{-60,-20},{-52,-12}})));
   Modelica.Blocks.Sources.BooleanConstant avoidEvents(k=false)
    "Switch to see influence on generated events"
    annotation (Placement(transformation(extent={{-102,42},{-82,62}})));
   Modelica.Blocks.Sources.Step ramp1(
                                     startTime=15000,
    height=-1,
    offset=1)
     annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
   Modelica.Blocks.Math.RealToBoolean realToBoolean1
     annotation (Placement(transformation(extent={{-66,80},{-58,88}})));
equation
  connect(pump.port_a, bou.ports[1]) annotation (Line(
      points={{-10,54},{34,54}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sine.y, bou.T_in) annotation (Line(
      points={{67,52},{56,52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sine1.y, bou1.T_in) annotation (Line(
      points={{67,6},{56,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(bou1.ports[1], pump1.port_a) annotation (Line(
      points={{34,8},{12,8},{12,18},{-10,18}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemBrine_out.port_b, bou1.ports[2]) annotation (Line(
      points={{-42,34},{34,34},{34,12}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemWater_out.port_b, bou.ports[2]) annotation (Line(
      points={{-6,79},{2,79},{2,58},{34,58}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pump2.port_a, bou2.ports[1]) annotation (Line(
      points={{-4,-40},{40,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sine2.y, bou2.T_in) annotation (Line(
      points={{73,-42},{62,-42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sine3.y,bou3. T_in) annotation (Line(
      points={{73,-88},{62,-88}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(bou3.ports[1],pump3. port_a) annotation (Line(
      points={{40,-86},{18,-86},{18,-76},{-4,-76}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemBrine_out1.port_b, bou3.ports[2]) annotation (Line(
      points={{-36,-60},{40,-60},{40,-82}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemWater_out1.port_b, bou2.ports[2]) annotation (Line(
      points={{0,-15},{8,-15},{8,-36},{40,-36}},
      color={0,127,255},
      smooth=Smooth.None));
   connect(realToBoolean.y, heatPump1.on) annotation (Line(
       points={{-51.6,-16},{-48,-16},{-48,-25.2}},
       color={255,0,255},
       smooth=Smooth.None));
  connect(ramp1.y, realToBoolean1.u) annotation (Line(
      points={{-79,90},{-70,90},{-70,84},{-66.8,84}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realToBoolean1.y, heatPump.on) annotation (Line(
      points={{-57.6,84},{-54,84},{-54,68.8}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(ramp1.y, pump.m_flowSet) annotation (Line(
      points={{-79,90},{-20,90},{-20,64.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ramp1.y, pump1.m_flowSet) annotation (Line(
      points={{-79,90},{-70,90},{-70,6},{-20,6},{-20,7.6}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(pump1.port_b, heatPump.port_a1) annotation (Line(
      points={{-30,18},{-74,18},{-74,64},{-62,64}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemBrine_out.port_a, heatPump.port_b2) annotation (Line(
      points={{-58,34},{-68,34},{-68,52},{-62,52}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pump3.port_b, heatPump1.port_a1) annotation (Line(
      points={{-24,-76},{-70,-76},{-70,-30},{-56,-30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemBrine_out1.port_a, heatPump1.port_b2) annotation (Line(
      points={{-52,-60},{-64,-60},{-64,-42},{-56,-42}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heatPump1.port_b1, senTemWater_out1.port_a) annotation (Line(
      points={{-36,-30},{-28,-30},{-28,-15},{-18,-15}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heatPump1.port_a2, pump2.port_b) annotation (Line(
      points={{-36,-42},{-30,-42},{-30,-40},{-24,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heatPump.port_a2, pump.port_b) annotation (Line(
      points={{-42,52},{-36,52},{-36,54},{-30,54}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heatPump.port_b1, senTemWater_out.port_a) annotation (Line(
      points={{-42,64},{-32,64},{-32,79},{-24,79}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pump3.m_flowSet, ramp1.y) annotation (Line(
      points={{-14,-86.4},{-44,-86.4},{-44,-86},{-79,-86},{-79,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realToBoolean.u, ramp1.y) annotation (Line(
      points={{-60.8,-16},{-79,-16},{-79,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pump2.m_flowSet, realToBoolean.u) annotation (Line(
      points={{-14,-29.6},{-16,-29.6},{-16,-4},{-64,-4},{-64,-16},{-60.8,-16}},

      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics),
    experiment(StopTime=30000),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}})),
    Commands(file=
          "modelica://Annex60/Resources/Scripts/Dymola/Fluid/Production/Examples/HeatPump_Events.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>This example demonstrates the use of a heat pump.</p>
</html>", revisions="<html>
<ul>
<li>March 2014 by Filip Jorissen:<br/> 
Initial version
</li>
</ul>
</html>"));
end HeatPump_Events;
