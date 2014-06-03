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
    annotation (Placement(transformation(extent={{-22,-48},{26,0}})));

  Production.HeatPumpOnOff heatPumpOnOff(
    redeclare package MediumBrine = Medium,
    redeclare package MediumFluid = Medium,
    allowFlowReversal=false,
    use_onOffSignal=false,
    onOff=true,
    use_scaling=true,
    redeclare IDEAS.Fluid.Production.BaseClasses.VitoCal300GBWS301dotA45
      heatPumpData,
    P_the_nominal=bfData.P_the_nominal/40)
                     annotation (Placement(transformation(
        extent={{-15,-17},{15,17}},
        rotation=90,
        origin={1,29})));
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
  Sensors.TemperatureTwoPort TSen_pri1(
    redeclare package Medium = Medium,
    m_flow_nominal=bfData.m_flow_nominal,
    tau=60,
    T_start=bfData.steRes.T_ini) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-24,62})));
equation
  connect(heatPumpOnOff.P_evap_val, multipleBoreholes.Q_flow) annotation (Line(
      points={{1,12.5},{1,-1.02857},{2,-1.02857}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(bou.ports[1], pump.port_a) annotation (Line(
      points={{32,78},{12,78}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heatPumpOnOff.fluidIn, bou.ports[2]) annotation (Line(
      points={{7.8,44},{32,44},{32,74}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sine.y, bou.T_in) annotation (Line(
      points={{69,80},{54,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multipleBoreholes.flowPort_b, pump_pri.port_a) annotation (Line(
      points={{-22,-24},{-44,-24},{-44,-14}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pump_pri.port_b, heatPumpOnOff.brineIn) annotation (Line(
      points={{-44,6},{-44,14},{-5.8,14}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heatPumpOnOff.brineOut, TSen_pri.port_a) annotation (Line(
      points={{7.8,14},{46,14},{46,4}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TSen_pri.port_b, multipleBoreholes.flowPort_a) annotation (Line(
      points={{46,-16},{46,-24},{26,-24}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pump.port_b, TSen_pri1.port_a) annotation (Line(
      points={{-8,78},{-24,78},{-24,72}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TSen_pri1.port_b, heatPumpOnOff.fluidOut) annotation (Line(
      points={{-24,52},{-24,44},{-5.8,44}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),     graphics),
    experiment(StopTime=1.7e+006, __Dymola_NumberOfIntervals=100),
    __Dymola_experimentSetupOutput);
end MultipleBoreholesWithHeatPump;
