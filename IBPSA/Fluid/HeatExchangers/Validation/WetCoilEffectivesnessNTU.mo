within IBPSA.Fluid.HeatExchangers.Validation;
model WetCoilEffectivesnessNTU
  "Validation of WetCoilEffectivesnessNTU based on fan coil unit performance data"
  extends Modelica.Icons.Example;
  package MediumAir = IBPSA.Media.Air;
  package MediumWater = IBPSA.Media.Water;
  parameter Modelica.SIunits.SpecificHeatCapacity cpWat = MediumWater.cp_const;
  IBPSA.Fluid.HeatExchangers.WetCoilEffectivesnessNTU cooCoi16(
    redeclare package Medium1 = MediumAir,
    redeclare package Medium2 = MediumWater,
    Q_flow_nominal=1176,
    dp1_nominal=0,
    dp2_nominal=0,
    m1_flow_nominal=485*1.2/3600,
    configuration=IBPSA.Fluid.Types.HeatExchangerConfiguration.CrossFlowUnmixed,
    m2_flow_nominal=1176/2/4180,
    X_w1_nominal=0.010203,
    T_a1_nominal=300.15,
    T_a2_nominal=289.15)
    "Cooling coil with nominal conditions for cooling at 16 degrees water inlet temperature"
    annotation (Placement(transformation(extent={{10,40},{-10,20}})));

  Sources.MassFlowSource_T bouAirCoo(
    redeclare package Medium = MediumAir,
    use_m_flow_in=true,
    T=273.15 + 27,
    nPorts=1,
    X={0.010203,1 - 0.010203})
                   "Air boundary: 27/19 dry/wet bulb temperature"
    annotation (Placement(transformation(extent={{58,14},{38,34}})));
  Modelica.Blocks.Sources.CombiTimeTable cooData(smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
      table=[0,485,1176,2176,2934; 10000,420,1053,1948,2657; 20000,330,865,1600,
        2209; 30000,236,626,1158,1618; 40000,123,389,720,1018; 50000,0,0.001,0.001,
        0.001])
    "manufacturers data for cooling mode - 1. air flow rate 2.power at 16 degC 3.sensible power at 7 degC 4.total power at 7degC"
    annotation (Placement(transformation(extent={{-102,46},{-82,66}})));
  Sources.MassFlowSource_T bouAirCoo1(
    redeclare package Medium = MediumAir,
    use_m_flow_in=true,
    T=273.15 + 27,
    nPorts=1,
    X={0.010203,1 - 0.010203})
                   "Air boundary: 27/19 dry/wet bulb temperature"
    annotation (Placement(transformation(extent={{58,-26},{38,-6}})));
  Modelica.Blocks.Math.Gain gainFloFcu16(k=1/4180/2)
    "Conversion factor from power to kg/s water "
    annotation (Placement(transformation(extent={{-66,38},{-54,50}})));
  Modelica.Blocks.Math.Gain gain(k=1.2/3600)
    "Conversion factor from l/h to kg/s"
    annotation (Placement(transformation(extent={{-2,46},{18,66}})));
  Sources.MassFlowSource_T bouWatCoo16(
    use_m_flow_in=true,
    redeclare package Medium = MediumWater,
    T=273.15 + 16,
    nPorts=1) "Water boundary at 16 degrees"
    annotation (Placement(transformation(extent={{-42,26},{-22,46}})));
  Sources.MassFlowSource_T bouWatCoo7(
    use_m_flow_in=true,
    redeclare package Medium = MediumWater,
    T=273.15 + 7,
    nPorts=1) "Water boundary at 7 degrees"
    annotation (Placement(transformation(extent={{-42,-14},{-22,6}})));
  Modelica.Blocks.Math.Gain gainFloFcu7(k=1/4180/5)
    "Conversion factor from power to kg/s water "
    annotation (Placement(transformation(extent={{-66,-2},{-54,10}})));
  IBPSA.Fluid.HeatExchangers.WetCoilEffectivesnessNTU cooCoi7(
    redeclare package Medium1 = MediumAir,
    redeclare package Medium2 = MediumWater,
    dp1_nominal=0,
    dp2_nominal=0,
    m1_flow_nominal=485*1.2/3600,
    configuration=IBPSA.Fluid.Types.HeatExchangerConfiguration.CrossFlowUnmixed,
    m2_flow_nominal=2934/5/4180,
    Q_flow_nominal=2934,
    X_w1_nominal=0.010203,
    T_a1_nominal=300.15,
    T_a2_nominal=280.15)
    "Cooling coil with nominal conditions for cooling at 7 degrees water inlet temperature"
    annotation (Placement(transformation(extent={{10,0},{-10,-20}})));

  Sources.Boundary_pT sinAir(redeclare package Medium = MediumAir, nPorts=3)
    "Air sink"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Sources.Boundary_pT sinWat(redeclare package Medium = MediumWater, nPorts=3)
    "Water sink"
    annotation (Placement(transformation(extent={{100,0},{80,20}})));
  IBPSA.Fluid.HeatExchangers.WetCoilEffectivesnessNTU cooCoi7Param16(
    redeclare package Medium1 = MediumAir,
    redeclare package Medium2 = MediumWater,
    Q_flow_nominal=1176,
    dp1_nominal=0,
    dp2_nominal=0,
    m1_flow_nominal=485*1.2/3600,
    configuration=IBPSA.Fluid.Types.HeatExchangerConfiguration.CrossFlowUnmixed,

    m2_flow_nominal=1176/2/4180,
    X_w1_nominal=0.010203,
    T_a1_nominal=300.15,
    T_a2_nominal=289.15)
    "Cooling coil with nominal conditions for cooling at 7 degrees water inlet temperature and boundary conditions of 16 degrees water inlet"
    annotation (Placement(transformation(extent={{10,-40},{-10,-60}})));
  Sources.MassFlowSource_T bouWatCoo7v2(
    use_m_flow_in=true,
    redeclare package Medium = MediumWater,
    T=273.15 + 7,
    nPorts=1) "Water boundary at 7 degrees"
    annotation (Placement(transformation(extent={{-40,-54},{-20,-34}})));
  Sources.MassFlowSource_T bouAirCoo2(
    redeclare package Medium = MediumAir,
    use_m_flow_in=true,
    T=273.15 + 27,
    nPorts=1,
    X={0.010203,1 - 0.010203})
                   "Air boundary: 27/19 dry/wet bulb temperature"
    annotation (Placement(transformation(extent={{58,-66},{38,-46}})));
equation
  connect(gainFloFcu16.u, cooData.y[2])
    annotation (Line(points={{-67.2,44},{-74,44},{-74,56},{-81,56}},
                                                     color={0,0,127}));
  connect(gain.u, cooData.y[1])
    annotation (Line(points={{-4,56},{-81,56}},   color={0,0,127}));
  connect(gain.y, bouAirCoo.m_flow_in)
    annotation (Line(points={{19,56},{60,56},{60,32}},    color={0,0,127}));
  connect(bouAirCoo1.m_flow_in, bouAirCoo.m_flow_in) annotation (Line(points={{60,-8},
          {60,32}},                         color={0,0,127}));
  connect(gainFloFcu16.y, bouWatCoo16.m_flow_in) annotation (Line(points={{-53.4,
          44},{-44,44}},             color={0,0,127}));
  connect(gainFloFcu7.y,bouWatCoo7. m_flow_in)
    annotation (Line(points={{-53.4,4},{-44,4}},     color={0,0,127}));
  connect(cooCoi16.port_a2, bouWatCoo16.ports[1])
    annotation (Line(points={{-10,36},{-22,36}},  color={0,127,255}));
  connect(cooCoi16.port_b2, sinWat.ports[1])
    annotation (Line(points={{10,36},{80,36},{80,12.6667}},
                                                        color={0,127,255}));
  connect(cooCoi16.port_a1, bouAirCoo.ports[1])
    annotation (Line(points={{10,24},{38,24}},   color={0,127,255}));
  connect(cooCoi16.port_b1, sinAir.ports[1]) annotation (Line(points={{-10,24},
          {-80,24},{-80,12.6667}},
                               color={0,127,255}));
  connect(cooCoi7.port_a2, bouWatCoo7.ports[1])
    annotation (Line(points={{-10,-4},{-22,-4}},  color={0,127,255}));
  connect(cooCoi7.port_b2, sinWat.ports[2])
    annotation (Line(points={{10,-4},{80,-4},{80,10}},   color={0,127,255}));
  connect(bouAirCoo1.ports[1], cooCoi7.port_a1)
    annotation (Line(points={{38,-16},{10,-16}}, color={0,127,255}));
  connect(cooCoi7.port_b1, sinAir.ports[2]) annotation (Line(points={{-10,-16},
          {-80,-16},{-80,10}},
                           color={0,127,255}));
  connect(gainFloFcu7.u, cooData.y[4]) annotation (Line(points={{-67.2,4},{-74,
          4},{-74,56},{-81,56}},     color={0,0,127}));
  connect(bouWatCoo7v2.ports[1], cooCoi7Param16.port_a2)
    annotation (Line(points={{-20,-44},{-10,-44}}, color={0,127,255}));
  connect(bouWatCoo7v2.m_flow_in, gainFloFcu7.y) annotation (Line(points={{-42,
          -36},{-53.4,-36},{-53.4,4}}, color={0,0,127}));
  connect(bouAirCoo2.ports[1], cooCoi7Param16.port_a1)
    annotation (Line(points={{38,-56},{10,-56}}, color={0,127,255}));
  connect(bouAirCoo2.m_flow_in, bouAirCoo1.m_flow_in)
    annotation (Line(points={{60,-48},{60,-48},{60,-8}}, color={0,0,127}));
  connect(sinWat.ports[3], cooCoi7Param16.port_b2) annotation (Line(points={{80,
          7.33333},{80,-44},{10,-44}}, color={0,127,255}));
  connect(cooCoi7Param16.port_b1, sinAir.ports[3]) annotation (Line(points={{
          -10,-56},{-80,-56},{-80,7.33333}}, color={0,127,255}));
  annotation (experiment(
      StopTime=50000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Lsodar"), __Dymola_Commands(file="Resources/Scripts/Dymola/Fluid/HeatExchangers/Validation/WetCoilEffectivenessNTU.mos"
        "Simulate and plot"));
end WetCoilEffectivesnessNTU;
