within Annex60.Fluid.Examples;
model SimpleHouse
  replaceable package MediumAir = Annex60.Media.Air;
  replaceable package MediumWater = Annex60.Media.Water;
  parameter Modelica.SIunits.Area A_wall = 100 "Wall area";
  parameter Modelica.SIunits.Volume V_zone = A_wall*3 "Wall area";

  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor walCap(C=10*A_wall*0.1
        *1000*1000)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={142,20})));
  MixingVolumes.MixingVolume zone(
    redeclare package Medium = MediumAir,
    V=V_zone,
    nPorts=2,
    m_flow_nominal=0.01)
    annotation (Placement(transformation(extent={{102,120},{82,140}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor convRes(R=1/2/A_wall)
    "Convection"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={130,70})));
  IDEAS.Fluid.HeatExchangers.Radiators.Radiator radiator(
    redeclare package Medium = MediumWater,
    dp_nominal=2000,
    QNom=3000)
    annotation (Placement(transformation(extent={{104,-128},{124,-108}})));

  Sources.Boundary_pT bouAir(redeclare package Medium = MediumAir, nPorts=2,
    T=273.15 + 10)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,120})));
  Sources.Boundary_pT bouWater(redeclare package Medium = MediumWater, nPorts=1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={46,-90})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam="modelica://Annex60/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    annotation (Placement(transformation(extent={{-200,10},{-180,30}})));
  BoundaryConditions.WeatherData.Bus weaBus1 "Weather data bus"
    annotation (Placement(transformation(extent={{-130,10},{-110,30}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor wallRes(R=0.5/A_wall
        /0.02)
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature Tout
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  HeatExchangers.HeaterCooler_u hea1(
    redeclare package Medium = MediumWater,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=1000,
    Q_flow_nominal=5000)
    annotation (Placement(transformation(extent={{44,-128},{64,-108}})));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=radiator.m_flow_nominal
    "Nominal mass flow rate";
  Buildings.Fluid.Movers.FlowControlled_m_flow pump2(
    redeclare package Medium = MediumWater,
    filteredSpeed=false,
    inputType=Buildings.Fluid.Types.InputType.Continuous,
    m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{80,-190},{60,-170}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TzoneAir
    annotation (Placement(transformation(extent={{40,140},{20,160}})));
  IDEAS.Fluid.Production.HP_WaterWater_OnOff hP_WaterWater_OnOff(
    redeclare package Medium1 = MediumWater,
    redeclare package Medium2 = MediumWater,
    redeclare
      IDEAS.Fluid.Production.Data.PerformanceMaps.VitoCal300GBWS301dotA08
      heatPumpData) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={10,-160})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pump1(
    redeclare package Medium = MediumWater,
    filteredSpeed=false,
    inputType=Buildings.Fluid.Types.InputType.Constant,
    m_flow_nominal=2*m_flow_nominal)
    annotation (Placement(transformation(extent={{-96,-156},{-76,-136}})));
  Sources.Boundary_pT waterWell(
    redeclare package Medium = MediumWater,
    nPorts=2,
    T=273.15 + 10) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-146,-148})));
  Controller heatCon(m_flow_nominal=m_flow_nominal) annotation (Placement(
        transformation(rotation=0, extent={{-26,-132},{-6,-112}})));
  Actuators.Dampers.VAVBoxExponential vavDam(
    redeclare package Medium = MediumAir,
    m_flow_nominal=0.01,
    dp_nominal=dp_nominal) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={0,100})));
  parameter Modelica.SIunits.Pressure dp_nominal=200
    "Pressure drop at nominal mass flow rate";
  Buildings.Fluid.Movers.FlowControlled_dp fan2(
    redeclare package Medium = MediumAir,
    m_flow_nominal=0.01,
    inputType=Buildings.Fluid.Types.InputType.Constant,
    dp_nominal=dp_nominal,
    filteredSpeed=false) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,100})));
  Modelica.Blocks.Logical.Hysteresis hysteresis(uLow=273.15 + 24, uHigh=273.15
         + 22)
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal
    annotation (Placement(transformation(extent={{-50,80},{-30,100}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow window
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  HeatExchangers.ConstantEffectiveness hexRecup(
    redeclare package Medium1 = MediumAir,
    redeclare package Medium2 = MediumAir,
    m1_flow_nominal=0.01,
    m2_flow_nominal=0.01,
    dp1_nominal=dp_nominal,
    dp2_nominal=dp_nominal,
    eps=0.85) annotation (Placement(transformation(extent={{78,94},{48,126}})));
equation
  connect(convRes.port_b, walCap.port)
    annotation (Line(points={{130,60},{130,60},{130,20},{132,20}},
                                                             color={191,0,0}));
  connect(convRes.port_a, zone.heatPort) annotation (Line(points={{130,80},{130,
          126},{102,126},{102,130}}, color={191,0,0}));
  connect(radiator.heatPortCon, zone.heatPort) annotation (Line(points={{119,
          -108},{160,-108},{160,130},{102,130}}, color={191,0,0}));
  connect(radiator.heatPortRad, walCap.port)
    annotation (Line(points={{123,-108},{132,-108},{132,20}},
                                                           color={191,0,0}));
  connect(weaDat.weaBus, weaBus1) annotation (Line(
      points={{-180,20},{-180,20},{-120,20}},
      color={255,204,51},
      thickness=0.5));
  connect(wallRes.port_b, walCap.port) annotation (Line(points={{80,30},{132,30},
          {132,20}},            color={191,0,0}));
  connect(Tout.T, weaBus1.TDryBul)
    annotation (Line(points={{-22,30},{-120,30},{-120,20}}, color={0,0,127}));
  connect(Tout.port, wallRes.port_a)
    annotation (Line(points={{0,30},{0,30},{60,30}}, color={191,0,0}));
  connect(hea1.port_b, radiator.port_a)
    annotation (Line(points={{64,-118},{84,-118},{104,-118}},
                                                        color={0,127,255}));
  connect(bouWater.ports[1], hea1.port_a)
    annotation (Line(points={{46,-100},{44,-100},{44,-118}},
                                                color={0,127,255}));
  connect(radiator.port_b, pump2.port_a) annotation (Line(points={{124,-118},{
          144,-118},{144,-180},{80,-180}}, color={0,127,255}));
  connect(TzoneAir.port, zone.heatPort) annotation (Line(points={{40,150},{40,
          150},{102,150},{102,130}}, color={191,0,0}));
  connect(hP_WaterWater_OnOff.port_a2, pump2.port_b) annotation (Line(points={{
          16,-170},{18,-170},{18,-180},{60,-180}}, color={0,127,255}));
  connect(hP_WaterWater_OnOff.port_b2, hea1.port_a) annotation (Line(points={{16,-150},
          {18,-150},{18,-134},{18,-118},{44,-118}},
                                                color={0,127,255}));
  connect(waterWell.ports[1], pump1.port_a) annotation (Line(points={{-136,-146},
          {-118,-146},{-96,-146}}, color={0,127,255}));
  connect(pump1.port_b, hP_WaterWater_OnOff.port_a1) annotation (Line(points={{
          -76,-146},{4,-146},{4,-150}}, color={0,127,255}));
  connect(hP_WaterWater_OnOff.port_b1, waterWell.ports[2]) annotation (Line(
        points={{4,-170},{2,-170},{2,-174},{2,-180},{-136,-180},{-136,-150}},
        color={0,127,255}));
  connect(heatCon.y, hP_WaterWater_OnOff.on) annotation (Line(points={{-16,-132},
          {-16,-158},{-0.8,-158}}, color={255,0,255}));
  connect(heatCon.y1, hea1.u)
    annotation (Line(points={{-6,-120},{-6,-112},{42,-112}}, color={0,0,127}));
  connect(heatCon.y2, pump2.m_flow_in) annotation (Line(points={{-6,-132},{10,
          -132},{70,-132},{70,-150},{70.2,-150},{70.2,-168}}, color={0,0,127}));
  connect(heatCon.u, Tout.T) annotation (Line(points={{-26,-116},{-100,-116},{
          -100,30},{-22,30}}, color={0,0,127}));
  connect(vavDam.port_b, fan2.port_a)
    annotation (Line(points={{10,100},{10,100},{20,100}}, color={0,127,255}));
  connect(vavDam.port_a, bouAir.ports[1]) annotation (Line(points={{-10,100},{
          -10,122},{-20,122}}, color={0,127,255}));
  connect(hysteresis.y, booleanToReal.u)
    annotation (Line(points={{-59,90},{-59,90},{-52,90}}, color={255,0,255}));
  connect(booleanToReal.y, vavDam.y)
    annotation (Line(points={{-29,90},{0,90},{0,88}}, color={0,0,127}));
  connect(window.port, walCap.port) annotation (Line(points={{0,0},{132,0},{132,
          16},{132,20}}, color={191,0,0}));
  connect(window.Q_flow, weaBus1.HGloHor)
    annotation (Line(points={{-20,0},{-120,0},{-120,20}}, color={0,0,127}));
  connect(TzoneAir.T, heatCon.u1) annotation (Line(points={{20,150},{20,150},{
          -100,150},{-100,-120},{-26,-120}}, color={0,0,127}));
  connect(hysteresis.u, heatCon.u1) annotation (Line(points={{-82,90},{-100,90},
          {-100,-120},{-26,-120}}, color={0,0,127}));
  connect(bouAir.ports[2], hexRecup.port_b1) annotation (Line(points={{-20,118},
          {-20,119.6},{48,119.6}}, color={0,127,255}));
  connect(hexRecup.port_a1, zone.ports[1]) annotation (Line(points={{78,119.6},
          {85,119.6},{85,120},{94,120}}, color={0,127,255}));
  connect(fan2.port_b, hexRecup.port_a2) annotation (Line(points={{40,100},{44,
          100},{44,100.4},{48,100.4}}, color={0,127,255}));
  connect(hexRecup.port_b2, zone.ports[2]) annotation (Line(points={{78,100.4},
          {90,100.4},{90,120}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -200},{200,200}})),
    experiment(StopTime=1e+06),
    __Dymola_experimentSetupOutput(events=false));
end SimpleHouse;
