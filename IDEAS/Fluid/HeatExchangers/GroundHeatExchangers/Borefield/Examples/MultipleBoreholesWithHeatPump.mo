within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Examples;
model MultipleBoreholesWithHeatPump
  "Model of a borefield with axb borefield and a constant heat injection rate"

  extends Modelica.Icons.Example;

  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;

  parameter Modelica.SIunits.HeatFlowRate q = 30
    "heat flow rate which is injected per meter depth of borehole";

  parameter Data.BorefieldData.SandStone_Bentonite_c8x1_h110_b5_d600_T283
    bfData
    annotation (Placement(transformation(extent={{74,74},{94,94}})));
  parameter Integer lenSim=3600*24*20 "length of the simulation";

  MultipleBoreHolesUTube multipleBoreholes(
    lenSim=lenSim,
    bfData=bfData,
    redeclare package Medium = Medium,
    dp_nominal=1000) "borefield"
    annotation (Placement(transformation(extent={{12,-78},{-28,-38}})));

  IDEAS.Fluid.Movers.FlowControlled_m_flow pum(
    redeclare package Medium = Medium,
    T_start=bfData.gen.T_start,
    m_flow_nominal=bfData.m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    annotation (Placement(transformation(extent={{-52,24},{-32,4}})));
  Modelica.Blocks.Sources.Constant mFlo(k=1)
    annotation (Placement(transformation(extent={{-14,-18},{-26,-6}})));
  Modelica.Fluid.Sources.Boundary_pT boundary(          redeclare package
      Medium = Medium, nPorts=1)
    annotation (Placement(transformation(extent={{-94,-68},{-74,-48}})));
  IDEAS.Fluid.Production.HP_WaterWater_OnOff heatPumpOnOff(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    onOff=true,
    use_scaling=true,
    use_onOffSignal=true,
    P_the_nominal=bfData.PThe_nominal/2,
    redeclare
      IDEAS.Fluid.Production.Data.PerformanceMaps.VitoCal300GBWS301dotA45
      heatPumpData)  annotation (Placement(transformation(
        extent={{15,-17},{-15,17}},
        rotation=180,
        origin={1,25})));
  Modelica.Blocks.Sources.BooleanPulse booleanPulse(width=50, period=100000)
    annotation (Placement(transformation(extent={{20,-26},{0,-6}})));
  Sensors.TemperatureTwoPort TSen_sec(
    redeclare package Medium = Medium,
    m_flow_nominal=bfData.m_flow_nominal,
    tau=60,
    T_start=bfData.gen.T_start) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={-22,52})));

  IDEAS.Fluid.Movers.FlowControlled_m_flow pump(
    redeclare package Medium = Medium,
    T_start=bfData.gen.T_start,
    m_flow_nominal=bfData.m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    inputType=IDEAS.Fluid.Types.InputType.Constant)
    annotation (Placement(transformation(extent={{30,72},{50,92}})));
  Sources.Boundary_pT bou(          redeclare package Medium = Medium,
    nPorts=2,
    use_T_in=true,
    p=200000)
    annotation (Placement(transformation(extent={{-42,70},{-22,90}})));
  Modelica.Blocks.Sources.Sine sine(
    amplitude=4,
    offset=273.15 + 30,
    startTime=2000,
    freqHz=1/50000)
    annotation (Placement(transformation(extent={{-76,70},{-56,90}})));
  Sensors.TemperatureTwoPort TSen_pri(
    redeclare package Medium = Medium,
    m_flow_nominal=bfData.m_flow_nominal,
    tau=60,
    T_start=bfData.gen.T_start) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={-62,-26})));
equation
  connect(boundary.ports[1], multipleBoreholes.port_b) annotation (Line(
      points={{-74,-58},{-28,-58}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(booleanPulse.y,heatPumpOnOff. on) annotation (Line(
      points={{-1,-16},{-2,-16},{-2,6.64}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(bou.ports[1],pump. port_a) annotation (Line(
      points={{-22,82},{30,82}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(bou.T_in, sine.y) annotation (Line(
      points={{-44,84},{-50,84},{-50,80},{-55,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pum.port_a, TSen_pri.port_b) annotation (Line(
      points={{-52,14},{-62,14},{-62,-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TSen_pri.port_a, multipleBoreholes.port_b) annotation (Line(
      points={{-62,-36},{-62,-58},{-28,-58}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heatPumpOnOff.port_a1, pum.port_b) annotation (Line(
      points={{-14,14.8},{-14,14},{-32,14}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heatPumpOnOff.port_b1, multipleBoreholes.port_a) annotation (Line(
      points={{16,14.8},{60,14.8},{60,-58},{12,-58}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heatPumpOnOff.port_b2, TSen_sec.port_a) annotation (Line(
      points={{-14,35.2},{-22,35.2},{-22,42}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TSen_sec.port_b, bou.ports[2]) annotation (Line(
      points={{-22,62},{-22,78}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pump.port_b, heatPumpOnOff.port_a2) annotation (Line(
      points={{50,82},{60,82},{60,35.2},{16,35.2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(mFlo.y, pum.m_flow_in) annotation (Line(points={{-26.6,-12},{-42.2,
          -12},{-42.2,2}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    experiment(StopTime=1.7e+006, __Dymola_NumberOfIntervals=100),
    __Dymola_experimentSetupOutput,
    __Dymola_Commands(file="modelica://IDEAS/Resources/Scripts/Dymola/Fluid/HeatExchangers/GroundHeatExchangers/Borefield/Examples/MultipleBoreholesWithHeatPump.mos"
        "Simulate and plot"));
end MultipleBoreholesWithHeatPump;
