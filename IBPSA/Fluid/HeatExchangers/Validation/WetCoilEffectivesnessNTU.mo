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
    annotation (Placement(transformation(extent={{12,-26},{-8,-46}})));

  Sources.MassFlowSource_T bouAirCoo(
    redeclare package Medium = MediumAir,
    use_m_flow_in=true,
    T=273.15 + 27,
    nPorts=1,
    X={0.010203,1 - 0.010203})
                   "Air boundary: 27/19 dry/wet bulb temperature"
    annotation (Placement(transformation(extent={{60,-52},{40,-32}})));
  Modelica.Blocks.Sources.CombiTimeTable cooData(smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
      table=[0,485,1176,2176,2934; 10000,420,1053,1948,2657; 20000,330,865,1600,
        2209; 30000,236,626,1158,1618; 40000,123,389,720,1018; 50000,0,0.001,0.001,
        0.001])
    "manufacturers data for cooling mode - 1. air flow rate 2.power at 16 degC 3.sensible power at 7 degC 4.total power at 7degC"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Sources.MassFlowSource_T bouAirCoo1(
    redeclare package Medium = MediumAir,
    use_m_flow_in=true,
    T=273.15 + 27,
    nPorts=1,
    X={0.010203,1 - 0.010203})
                   "Air boundary: 27/19 dry/wet bulb temperature"
    annotation (Placement(transformation(extent={{60,-92},{40,-72}})));
  Modelica.Blocks.Math.Gain gainFloFcu16(k=1/4180/2)
    "Conversion factor from power to kg/s water "
    annotation (Placement(transformation(extent={{-64,-28},{-52,-16}})));
  Modelica.Blocks.Math.Gain gain(k=1.2/3600)
    "Conversion factor from l/h to kg/s"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Sources.MassFlowSource_T bouWatCoo16(
    use_m_flow_in=true,
    redeclare package Medium = MediumWater,
    T=273.15 + 16,
    nPorts=1) "Water boundary at 16 degrees"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Sources.MassFlowSource_T bouWatCoo7(
    use_m_flow_in=true,
    redeclare package Medium = MediumWater,
    T=273.15 + 7,
    nPorts=1) "Water boundary at 7 degrees"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Modelica.Blocks.Math.Gain gainFloFcu7(k=1/4180/5)
    "Conversion factor from power to kg/s water "
    annotation (Placement(transformation(extent={{-64,-68},{-52,-56}})));
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
    annotation (Placement(transformation(extent={{12,-66},{-8,-86}})));

  Sources.Boundary_pT sinAir(redeclare package Medium = MediumAir, nPorts=2)
    "Air sink"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  Sources.Boundary_pT sinWat(redeclare package Medium = MediumWater, nPorts=2)
    "Water sink"
    annotation (Placement(transformation(extent={{100,-10},{80,10}})));
equation
  connect(gainFloFcu16.u, cooData.y[2])
    annotation (Line(points={{-65.2,-22},{-72,-22},{-72,-10},{-79,-10}},
                                                     color={0,0,127}));
  connect(gain.u, cooData.y[1])
    annotation (Line(points={{-2,-10},{-79,-10}}, color={0,0,127}));
  connect(gain.y, bouAirCoo.m_flow_in)
    annotation (Line(points={{21,-10},{62,-10},{62,-34}}, color={0,0,127}));
  connect(bouAirCoo1.m_flow_in, bouAirCoo.m_flow_in) annotation (Line(points={{62,-74},
          {64,-74},{64,-34},{62,-34}},      color={0,0,127}));
  connect(gainFloFcu16.y, bouWatCoo16.m_flow_in) annotation (Line(points={{-51.4,
          -22},{-42,-22},{-42,-22}}, color={0,0,127}));
  connect(gainFloFcu7.y,bouWatCoo7. m_flow_in)
    annotation (Line(points={{-51.4,-62},{-42,-62}}, color={0,0,127}));
  connect(cooCoi16.port_a2, bouWatCoo16.ports[1])
    annotation (Line(points={{-8,-30},{-20,-30}}, color={0,127,255}));
  connect(cooCoi16.port_b2, sinWat.ports[1])
    annotation (Line(points={{12,-30},{80,-30},{80,2}}, color={0,127,255}));
  connect(cooCoi16.port_a1, bouAirCoo.ports[1])
    annotation (Line(points={{12,-42},{40,-42}}, color={0,127,255}));
  connect(cooCoi16.port_b1, sinAir.ports[1]) annotation (Line(points={{-8,-42},{
          -80,-42},{-80,-48}}, color={0,127,255}));
  connect(cooCoi7.port_a2, bouWatCoo7.ports[1])
    annotation (Line(points={{-8,-70},{-20,-70}}, color={0,127,255}));
  connect(cooCoi7.port_b2, sinWat.ports[2])
    annotation (Line(points={{12,-70},{80,-70},{80,-2}}, color={0,127,255}));
  connect(bouAirCoo1.ports[1], cooCoi7.port_a1)
    annotation (Line(points={{40,-82},{12,-82}}, color={0,127,255}));
  connect(cooCoi7.port_b1, sinAir.ports[2]) annotation (Line(points={{-8,-82},{
          -80,-82},{-80,-52}},
                           color={0,127,255}));
  connect(gainFloFcu7.u, cooData.y[4]) annotation (Line(points={{-65.2,-62},{-72,
          -62},{-72,-10},{-79,-10}}, color={0,0,127}));
  annotation (experiment(
      StopTime=50000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Lsodar"), __Dymola_Commands(file="Resources/Scripts/Dymola/Fluid/HeatExchangers/Validation/WetCoilEffectivenessNTU.mos"
        "Simulate and plot"));
end WetCoilEffectivesnessNTU;
