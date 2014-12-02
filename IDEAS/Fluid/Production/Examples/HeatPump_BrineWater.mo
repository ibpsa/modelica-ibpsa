within IDEAS.Fluid.Production.Examples;
model HeatPump_BrineWater
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
    annotation (Placement(transformation(extent={{-10,44},{-30,64}})));
  inner IDEAS.SimInfoManager sim
    annotation (Placement(transformation(extent={{-92,74},{-72,94}})));
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
    useInput=false,
    redeclare package Medium = Medium,
    m_flow_nominal=4200/3600)
    annotation (Placement(transformation(extent={{-10,8},{-30,28}})));
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
  replaceable HeatPumpOnOff
                heatPump(
    redeclare package MediumBrine = Medium,
    redeclare package MediumFluid = Medium,
    use_onOffSignal=false,
    redeclare IDEAS.Fluid.Production.BaseClasses.VitoCal300GBWS301dotA29
      heatPumpData,
    onOff=true,
    use_scaling=false,
    avoidEvents=false)
                      constrainedby HeatPumpOnOff
    annotation (Placement(transformation(extent={{-62,48},{-42,68}})));
  Fluid.Movers.Pump pump2(
    m=1,
    useInput=false,
    redeclare package Medium = Medium,
    m_flow_nominal=scaling*2550/3600,
    dpFix=50000)
    annotation (Placement(transformation(extent={{-6,-40},{-26,-20}})));
  Modelica.Blocks.Sources.Sine sine2(
    freqHz=1/5000,
    amplitude=4,
    offset=273.15 + 30,
    startTime=2000)
    annotation (Placement(transformation(extent={{92,-42},{72,-22}})));
  Sources.Boundary_pT bou2(         redeclare package Medium = Medium,
    nPorts=2,
    use_T_in=true,
    p=200000)
    annotation (Placement(transformation(extent={{58,-18},{38,-38}})));
  Fluid.Movers.Pump pump3(
    m=1,
    useInput=false,
    redeclare package Medium = Medium,
    m_flow_nominal=scaling*4200/3600,
    dpFix=50000)
    annotation (Placement(transformation(extent={{-6,-76},{-26,-56}})));
  Sources.Boundary_pT bou3(         redeclare package Medium = Medium,
    nPorts=2,
    use_T_in=true,
    p=200000)
    annotation (Placement(transformation(extent={{58,-64},{38,-84}})));
  Modelica.Blocks.Sources.Sine sine3(
    amplitude=4,
    offset=273.15 + 10,
    startTime=4000,
    freqHz=1/3000)
    annotation (Placement(transformation(extent={{92,-88},{72,-68}})));
  replaceable HeatPumpOnOff
                heatPump1(
    redeclare package MediumBrine = Medium,
    redeclare package MediumFluid = Medium,
    use_onOffSignal=false,
    redeclare IDEAS.Fluid.Production.BaseClasses.VitoCal300GBWS301dotA29
      heatPumpData,
    use_scaling=true,
    onOff=true,
    P_the_nominal=scaling*heatPump1.heatPumpData.P_the_nominal,
    avoidEvents=false)                                          constrainedby
    HeatPumpOnOff
    annotation (Placement(transformation(extent={{-58,-36},{-38,-16}})));
  Sensors.TemperatureTwoPort senTemBrine_out(redeclare package Medium = Medium,
      m_flow_nominal=4200/3600)
    annotation (Placement(transformation(extent={{-58,26},{-42,42}})));
  Sensors.TemperatureTwoPort senTemBrine_out1(redeclare package Medium = Medium,
      m_flow_nominal=scaling*4200/3600)
    annotation (Placement(transformation(extent={{-50,-62},{-34,-46}})));
  Sensors.TemperatureTwoPort senTemWater_out(redeclare package Medium = Medium,
      m_flow_nominal=2550/3600)
    annotation (Placement(transformation(extent={{-24,70},{-6,88}})));
  Sensors.TemperatureTwoPort senTemWater_out1(redeclare package Medium = Medium,
      m_flow_nominal=scaling*2550/3600)
    annotation (Placement(transformation(extent={{-20,-16},{-2,2}})));
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
  connect(heatPump.fluidIn, pump.port_b) annotation (Line(
      points={{-42,54},{-30,54}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heatPump.brineIn, pump1.port_b) annotation (Line(
      points={{-62,62},{-78,62},{-78,18},{-30,18}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pump2.port_a, bou2.ports[1]) annotation (Line(
      points={{-6,-30},{38,-30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sine2.y, bou2.T_in) annotation (Line(
      points={{71,-32},{60,-32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sine3.y,bou3. T_in) annotation (Line(
      points={{71,-78},{60,-78}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(bou3.ports[1],pump3. port_a) annotation (Line(
      points={{38,-76},{16,-76},{16,-66},{-6,-66}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heatPump1.fluidIn, pump2.port_b) annotation (Line(
      points={{-38,-30},{-26,-30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heatPump1.brineIn, pump3.port_b) annotation (Line(
      points={{-58,-22},{-74,-22},{-74,-66},{-26,-66}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heatPump.brineOut, senTemBrine_out.port_a) annotation (Line(
      points={{-62,54},{-62,34},{-58,34}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemBrine_out.port_b, bou1.ports[2]) annotation (Line(
      points={{-42,34},{34,34},{34,12}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heatPump1.brineOut, senTemBrine_out1.port_a) annotation (Line(
      points={{-58,-30},{-58,-54},{-50,-54}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemBrine_out1.port_b, bou3.ports[2]) annotation (Line(
      points={{-34,-54},{38,-54},{38,-72}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heatPump.fluidOut, senTemWater_out.port_a) annotation (Line(
      points={{-42,62},{-30,62},{-30,79},{-24,79}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemWater_out.port_b, bou.ports[2]) annotation (Line(
      points={{-6,79},{2,79},{2,58},{34,58}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heatPump1.fluidOut, senTemWater_out1.port_a) annotation (Line(
      points={{-38,-22},{-26,-22},{-26,-7},{-20,-7}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemWater_out1.port_b, bou2.ports[2]) annotation (Line(
      points={{-2,-7},{-2,-6},{6,-6},{6,-26},{38,-26}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),     graphics),
    experiment(StopTime=15000),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}})),
    Commands(file="Scripts/Tester_Boiler.mos" "TestModel"),
    Documentation(info="<html>
<p>This example demonstrates the use of a heat pump.</p>
</html>", revisions="<html>
<ul>
<li>March 2014 by Filip Jorissen:<br/> 
Initial version
</li>
</ul>
</html>"));
end HeatPump_BrineWater;
