within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Examples;
model MultipleBoreholesWithHeatPump
  extends Modelica.Icons.Example;

  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater
    annotation (__Dymola_choicesAllMatching=true);

  parameter Data.BorefieldData.example_accurate
    bfData
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  parameter Integer lenSim=3600*24*20;

  MultipleBoreHoles multipleBoreholes(lenSim=lenSim, bfData=bfData,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-24,-48},{24,0}})));

  Production.HeatPumpOnOff heatPumpOnOff(
    redeclare package MediumBrine = Medium,
    redeclare package MediumFluid = Medium,
    allowFlowReversal=false,
    onOff=true,
    use_scaling=true,
    redeclare IDEAS.Fluid.Production.BaseClasses.VitoCal300GBWS301dotA45
      heatPumpData,
    use_onOffSignal=true,
    P_the_nominal=bfData.P_the_nominal/2)
                     annotation (Placement(transformation(
        extent={{-15,-17},{15,17}},
        rotation=90,
        origin={1,33})));
  Modelica.Blocks.Sources.Sine sine(
    freqHz=1/5000,
    amplitude=4,
    offset=273.15 + 30,
    startTime=2000)
    annotation (Placement(transformation(extent={{90,70},{70,90}})));
  Sources.Boundary_pT bou(          redeclare package Medium = Medium,
    nPorts=2,
    use_T_in=true,
    p=200000)
    annotation (Placement(transformation(extent={{52,66},{32,86}})));
  Movers.Pump       pump(
    m=1,
    useInput=false,
    redeclare package Medium = Medium,
    m_flow_nominal=bfData.m_flow_nominal)
    annotation (Placement(transformation(extent={{12,68},{-8,88}})));
  Movers.Pump pump_pri(
    m=1,
    useInput=false,
    redeclare package Medium = Medium,
    m_flow_nominal=bfData.m_flow_nominal) "pump of the primary circuit"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-44,-4})));
  Sensors.TemperatureTwoPort TSen_pri(
    redeclare package Medium = Medium,
    m_flow_nominal=bfData.m_flow_nominal,
    tau=60,
    T_start=bfData.steRes.T_ini) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={46,-6})));
  Sensors.TemperatureTwoPort TSen_sec(
    redeclare package Medium = Medium,
    m_flow_nominal=bfData.m_flow_nominal,
    tau=60,
    T_start=bfData.steRes.T_ini) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-24,62})));
  Modelica.Blocks.Sources.BooleanPulse booleanPulse(width=50, period=100000)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
equation
  connect(bou.ports[1], pump.port_a) annotation (Line(
      points={{32,78},{12,78}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heatPumpOnOff.fluidIn, bou.ports[2]) annotation (Line(
      points={{7.8,48},{32,48},{32,74}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sine.y, bou.T_in) annotation (Line(
      points={{69,80},{54,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multipleBoreholes.flowPort_b, pump_pri.port_a) annotation (Line(
      points={{-24,-24},{-44,-24},{-44,-14}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pump_pri.port_b, heatPumpOnOff.brineIn) annotation (Line(
      points={{-44,6},{-44,18},{-5.8,18}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heatPumpOnOff.brineOut, TSen_pri.port_a) annotation (Line(
      points={{7.8,18},{46,18},{46,4}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TSen_pri.port_b, multipleBoreholes.flowPort_a) annotation (Line(
      points={{46,-16},{46,-24},{24,-24}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pump.port_b, TSen_sec.port_a) annotation (Line(
      points={{-8,78},{-24,78},{-24,72}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TSen_sec.port_b, heatPumpOnOff.fluidOut) annotation (Line(
      points={{-24,52},{-24,48},{-5.8,48}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(booleanPulse.y, heatPumpOnOff.on) annotation (Line(
      points={{-59,30},{-17.36,30}},
      color={255,0,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics),
    experiment(StopTime=1.7e+006, __Dymola_NumberOfIntervals=100),
    __Dymola_experimentSetupOutput);
end MultipleBoreholesWithHeatPump;
