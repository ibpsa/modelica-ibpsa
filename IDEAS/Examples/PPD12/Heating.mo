within IDEAS.Examples.PPD12;
model Heating "Ppd 12 example model"
  extends IDEAS.Examples.PPD12.Structure;


  //HVAC
  parameter Real dp_26mm = 992*(m_flow_nominal/0.4)^2 "Pressure drop per m of duct with diameter of 26/20 mm for flow rate of 0.4kg/s";
  parameter Real dp_20mm = 2871*(m_flow_nominal/0.4)^2 "Pressure drop per m of duct with diameter of 20/16 mm for flow rate of 0.4kg/s";
  parameter Real dp_16mm = 11320*(m_flow_nominal/0.4)^2 "Pressure drop per m of duct with diameter of 16/12 mm for flow rate of 0.4kg/s";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=0.4
    "Nominal water mass flow rate";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal_air=300*1.2/3600
    "Nominal air mass flow rate";

  //CONTROL
  parameter Modelica.SIunits.Temperature TSet=294.15 "Temperature set point";
  parameter Modelica.SIunits.Temperature TSet2=296.15 "Temperature set point";

  IDEAS.Fluid.HeatExchangers.Radiators.RadiatorEN442_2 radGnd(
    redeclare package Medium = MediumWater,
    Q_flow_nominal=4373,
    T_a_nominal=273.15 + 75,
    T_b_nominal=273.15 + 65,
    TAir_nominal=273.15 + 20,
    allowFlowReversal=false)
    "Radiator ground floor: Superia super design 33/500/2400"
                                                    annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-40,-170})));
  IDEAS.Fluid.HeatExchangers.Radiators.RadiatorEN442_2 radBed1(
    redeclare package Medium = MediumWater,
    allowFlowReversal=false,
    Q_flow_nominal=1844,
    T_a_nominal=273.15 + 75,
    T_b_nominal=273.15 + 65,
    TAir_nominal=273.15 + 20)
    "Radiator for first bedroom: Superia super design 22/500/1400"
                                                                 annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={60,-170})));
  IDEAS.Fluid.HeatExchangers.Radiators.RadiatorEN442_2 radBat2(
    redeclare package Medium = MediumWater,
    allowFlowReversal=false,
    Q_flow_nominal=676,
    T_a_nominal=273.15 + 75,
    T_b_nominal=273.15 + 65,
    TAir_nominal=273.15 + 20,
    n=1.2) "Towel dryer for bathroom: Brugman ibiza 1186/600" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={90,-170})));
  IDEAS.Fluid.HeatExchangers.Radiators.RadiatorEN442_2 radBed2(
    redeclare package Medium = MediumWater,
    allowFlowReversal=false,
    Q_flow_nominal=1844,
    T_a_nominal=273.15 + 75,
    T_b_nominal=273.15 + 65,
    TAir_nominal=273.15 + 20)
    "Radiator for bedroom 2: Superia super design 22/500/1400"   annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={230,-170})));
  IDEAS.Fluid.HeatExchangers.Radiators.RadiatorEN442_2 radBed3(
  redeclare package Medium = MediumWater,
    allowFlowReversal=false,
    Q_flow_nominal=1671,
    T_a_nominal=273.15 + 75,
    T_b_nominal=273.15 + 65,
    TAir_nominal=273.15 + 20)
    "Radiator for bedroom 3: Superia super design 22/800/900"    annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={270,-170})));
  IDEAS.Fluid.HeatExchangers.Radiators.RadiatorEN442_2 radBat1(
    redeclare package Medium = MediumWater,
    allowFlowReversal=false,
    Q_flow_nominal=1822,
    T_a_nominal=273.15 + 75,
    T_b_nominal=273.15 + 65,
    TAir_nominal=273.15 + 20)
    "Main radiator for bathroom: Superia super design 33/500/1000"
                                                    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={120,-170})));
  IDEAS.Fluid.Movers.FlowControlled_dp pump(
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    filteredSpeed=false,
    redeclare package Medium = MediumWater,
    dp_nominal=50000,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{330,-120},{310,-100}})));
  IDEAS.Fluid.HeatExchangers.HeaterCooler_T hea(
    m_flow_nominal=m_flow_nominal,
    Q_flow_maxHeat=30000,
    Q_flow_maxCool=0,
    dp_nominal=5000,
    redeclare package Medium = MediumWater,
    allowFlowReversal=false)
                     "Bulex thermo master T30/35"
    annotation (Placement(transformation(extent={{370,-120},{350,-100}})));
  IDEAS.Fluid.Sources.Boundary_pT       bou1(
    nPorts=1,
    redeclare package Medium = MediumWater,
    p=150000)
    annotation (Placement(transformation(extent={{400,-200},{380,-180}})));
  Modelica.Blocks.Sources.Constant Thea(k=273.15 + 70)
    "Supply water temperature set point"
    annotation (Placement(transformation(extent={{402,-114},{382,-94}})));
  Thermostat the "Custom thermostat"
    annotation (Placement(transformation(extent={{240,-90},{260,-70}})));
  Modelica.Blocks.Math.BooleanToReal booToRea(realTrue=50000, realFalse=0)
    "Conversion block of control signal to pump pressure set point"
    annotation (Placement(transformation(extent={{280,-90},{300,-70}})));
  IDEAS.Fluid.FixedResistances.Junction spl(
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare package Medium = MediumWater,
    m_flow_nominal={m_flow_nominal,m_flow_nominal,m_flow_nominal},
    dp_nominal=2*{0,0,dp_16mm*5},
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Leaving)
    annotation (Placement(transformation(extent={{240,-120},{220,-100}})));
  IDEAS.Fluid.FixedResistances.Junction spl1(
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare package Medium = MediumWater,
    m_flow_nominal={m_flow_nominal,m_flow_nominal,m_flow_nominal},
    dp_nominal=2*{dp_26mm*2,0,dp_16mm*2},
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Leaving)
    annotation (Placement(transformation(extent={{280,-120},{260,-100}})));
  IDEAS.Fluid.FixedResistances.Junction spl2(
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare package Medium = MediumWater,
    m_flow_nominal={m_flow_nominal,m_flow_nominal,m_flow_nominal},
    dp_nominal=2*{dp_26mm*3,0,dp_16mm*5},
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Leaving)
    annotation (Placement(transformation(extent={{130,-120},{110,-100}})));
  IDEAS.Fluid.FixedResistances.Junction spl3(
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare package Medium = MediumWater,
    m_flow_nominal={m_flow_nominal,m_flow_nominal,m_flow_nominal},
    dp_nominal=2*{0,0,dp_16mm*1.5},
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Leaving)
    annotation (Placement(transformation(extent={{100,-120},{80,-100}})));
  IDEAS.Fluid.FixedResistances.Junction spl4(
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare package Medium = MediumWater,
    m_flow_nominal={m_flow_nominal,m_flow_nominal,m_flow_nominal},
    dp_nominal=2*{0,dp_16mm*4*2 + dp_26mm*4*2,dp_16mm*5},
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Leaving)
    annotation (Placement(transformation(extent={{70,-120},{50,-100}})));
  Modelica.Blocks.Continuous.Integrator integrator(k=1/3600000)
    annotation (Placement(transformation(extent={{352,-76},{372,-56}})));
  IDEAS.Fluid.Actuators.Valves.TwoWayTRV valBed1(
    redeclare package Medium = MediumWater,
    TSet=TSet,
    m_flow_nominal=0.2,
    CvData=IDEAS.Fluid.Types.CvTypes.Kv,
    Kv=0.5,
    allowFlowReversal=false,
    filteredOpening=true,
    from_dp=true) "Thermostatic radiator valve for bedroom 1" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={60,-140})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTemRadBed1
    annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=90,
        origin={49,-155})));
  IDEAS.Fluid.Actuators.Valves.TwoWayTRV valBat2(
    redeclare package Medium = MediumWater,
    TSet=TSet,
    m_flow_nominal=m_flow_nominal,
    CvData=IDEAS.Fluid.Types.CvTypes.Kv,
    Kv=0.5,
    allowFlowReversal=false,
    filteredOpening=true,
    from_dp=true) "Thermostatic radiator valve for towel dryer in bathroom"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={90,-140})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTemRadBat2
    annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=90,
        origin={79,-155})));
  IDEAS.Fluid.Actuators.Valves.TwoWayTRV valBat1(
    redeclare package Medium = MediumWater,
    TSet=TSet,
    m_flow_nominal=m_flow_nominal,
    CvData=IDEAS.Fluid.Types.CvTypes.Kv,
    Kv=0.5,
    allowFlowReversal=false,
    filteredOpening=true,
    from_dp=true) "Thermostatic radiator valve for radiator in bathroom"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={120,-140})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTemRadBat1
    annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=90,
        origin={109,-155})));
  IDEAS.Fluid.Actuators.Valves.TwoWayTRV valBed2(
    redeclare package Medium = MediumWater,
    TSet=TSet,
    m_flow_nominal=m_flow_nominal,
    CvData=IDEAS.Fluid.Types.CvTypes.Kv,
    Kv=0.5,
    allowFlowReversal=false,
    filteredOpening=true,
    from_dp=true) "Thermostatic radiator valve for radiator in bedroom 2"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={230,-140})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTemRadBat3
    annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=90,
        origin={219,-155})));
  IDEAS.Fluid.Actuators.Valves.TwoWayTRV valBed3(
    redeclare package Medium = MediumWater,
    TSet=TSet,
    m_flow_nominal=m_flow_nominal,
    CvData=IDEAS.Fluid.Types.CvTypes.Kv,
    Kv=0.5,
    allowFlowReversal=false,
    filteredOpening=true,
    from_dp=true) "Thermostatic radiator valve for bedroom 3" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={270,-140})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTemRadBat4
    annotation (Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=90,
        origin={259,-155})));
  IDEAS.Fluid.Actuators.Valves.TwoWayTRV valGnd(
    redeclare package Medium = MediumWater,
    CvData=IDEAS.Fluid.Types.CvTypes.Kv,
    Kv=0.5,
    allowFlowReversal=false,
    filteredOpening=true,
    from_dp=true,
    m_flow_nominal=m_flow_nominal,
    dpFixed_nominal=0,
    TSet=TSet2)   "Thermostatic radiator valve for radiator on ground floor"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-40,-140})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTemGnd annotation (
     Placement(transformation(
        extent={{-7,-7},{7,7}},
        rotation=90,
        origin={-51,-155})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(G=
        500) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,10})));
equation
  connect(hallway.proBusD, living.proBusB) annotation (Line(
      points={{-73,50},{-45,50},{-45,40}},
      color={255,204,51},
      thickness=0.5));
  connect(Diner.proBusC, living.proBusA) annotation (Line(
      points={{-36,-19},{-30,-19},{-30,37}},
      color={255,204,51},
      thickness=0.5));
  connect(Diner.proBusExt[1], hallway.proBusA) annotation (Line(
      points={{-48,-36.5},{-76,-36.5},{-76,41}},
      color={255,204,51},
      thickness=0.5));
  connect(Diner.proBusExt[2], com1.propsBus_a) annotation (Line(
      points={{-48,-37.5},{-48,-36},{-94.8333,-36},{-94.8333,-60}},
      color={255,204,51},
      thickness=0.5));
  connect(out1.propsBus_a, Diner.proBusExt[3]) annotation (Line(
      points={{-91,-89.8333},{-91,-38.5},{-48,-38.5}},
      color={255,204,51},
      thickness=0.5));
  connect(Porch.proBusC, Diner.proBusA) annotation (Line(
      points={{-34,-67},{-34,-48},{-42,-48},{-42,-37}},
      color={255,204,51},
      thickness=0.5));
  connect(Porch.proBusD, Diner.proBusExt[4]) annotation (Line(
      points={{-43,-76},{-88,-76},{-88,-38},{-48,-38},{-48,-39.5}},
      color={255,204,51},
      thickness=0.5));
  connect(bedRoom1.proBusFlo, cei2.propsBus_a) annotation (Line(
      points={{130,76},{120,76},{120,60},{103.167,60}},
      color={255,204,51},
      thickness=0.5));
  connect(cei2.propsBus_b, living.proBusCei) annotation (Line(
      points={{94.8333,60},{-35.8,60},{-35.8,40}},
      color={255,204,51},
      thickness=0.5));
  connect(bedRoom1.proBusExt[1], cei1.propsBus_a) annotation (Line(
      points={{142,61},{144,61},{144,80},{79.1667,80}},
      color={255,204,51},
      thickness=0.5));
  connect(cei1.propsBus_b, hallway.proBusCei) annotation (Line(
      points={{70.8333,80},{-81.8,80},{-81.8,44}},
      color={255,204,51},
      thickness=0.5));
  connect(bedRoom1.proBusA, bathRoom.proBusC) annotation (Line(
      points={{136,61},{136,52},{136,25},{130,25}},
      color={255,204,51},
      thickness=0.5));
  connect(bathRoom.proBusFlo, living.proBusExt[1]) annotation (Line(
      points={{130,22},{96,22},{96,32},{96,38},{-24,38},{-24,36}},
      color={255,204,51},
      thickness=0.5));
  connect(stairWay.proBusC, bedRoom1.proBusExt[2]) annotation (Line(
      points={{76,25},{76,25},{76,50},{76,52},{142,52},{142,59}},
      color={255,204,51},
      thickness=0.5));
  connect(stairWay.proBusFlo, hallway.proBusExt[1]) annotation (Line(
      points={{76,22},{46,22},{-70,22},{-70,40}},
      color={255,204,51},
      thickness=0.5));
  connect(stairWay.proBusD, bathRoom.proBusB) annotation (Line(
      points={{85,16},{121,16},{121,10}},
      color={255,204,51},
      thickness=0.5));
  connect(bedRoom2.proBusFlo, bedRoom1.proBusCei) annotation (Line(
      points={{266,78},{266,90},{192,90},{192,64},{130.2,64}},
      color={255,204,51},
      thickness=0.5));
  connect(bedRoom3.proBusC, bedRoom2.proBusA) annotation (Line(
      points={{270,39},{264,39},{264,63},{272,63}},
      color={255,204,51},
      thickness=0.5));
  connect(bedRoom3.proBusFlo, bathRoom.proBusCei) annotation (Line(
      points={{270,36},{202,36},{202,10},{130.2,10}},
      color={255,204,51},
      thickness=0.5));
  connect(out2.propsBus_a, bedRoom3.proBusA) annotation (Line(
      points={{233,2.16667},{233,14},{276,14},{276,21}},
      color={255,204,51},
      thickness=0.5));
  connect(winBed3.propsBus_a, bedRoom3.proBusExt[1]) annotation (Line(
      points={{307,2.16667},{307,21.3333},{282,21.3333}},
      color={255,204,51},
      thickness=0.5));
  connect(Roof1.propsBus_a, bedRoom3.proBusExt[2]) annotation (Line(
      points={{281,2.16667},{281,11.5},{282,11.5},{282,20}},
      color={255,204,51},
      thickness=0.5));
  connect(Roof2.propsBus_a, bedRoom3.proBusCei) annotation (Line(
      points={{261,2.16667},{261,24},{270.2,24}},
      color={255,204,51},
      thickness=0.5));
  connect(cei3.propsBus_a, bedRoom3.proBusExt[3]) annotation (Line(
      points={{191.167,-10},{282,-10},{282,18.6667}},
      color={255,204,51},
      thickness=0.5));
  connect(cei3.propsBus_b, stairWay.proBusCei) annotation (Line(
      points={{182.833,-10},{76.2,-10},{76.2,10}},
      color={255,204,51},
      thickness=0.5));
  connect(pump.port_a,hea. port_b)
    annotation (Line(points={{330,-110},{340,-110},{350,-110}},
                                                     color={0,127,255}));
  connect(radGnd.port_b,radBed1. port_b) annotation (Line(points={{-40,-180},{-40,
          -180},{60,-180}},                          color={0,127,255}));
  connect(radBed1.port_b,radBat2. port_b) annotation (Line(points={{60,-180},{60,
          -180},{90,-180}},                color={0,127,255}));
  connect(radBat2.port_b,radBat1. port_b) annotation (Line(points={{90,-180},{90,
          -180},{120,-180}},                color={0,127,255}));
  connect(radBat1.port_b,radBed2. port_b) annotation (Line(points={{120,-180},{120,
          -180},{230,-180}},                           color={0,127,255}));
  connect(radBed2.port_b,radBed3. port_b) annotation (Line(points={{230,-180},{230,
          -180},{270,-180}},                           color={0,127,255}));
  connect(radBed3.port_b,hea. port_a) annotation (Line(points={{270,-180},{270,
          -180},{378,-180},{378,-110},{370,-110}},            color={0,127,255}));
  connect(bou1.ports[1],hea. port_b) annotation (Line(points={{380,-190},{350,
          -190},{350,-110}}, color={0,127,255}));
  connect(radGnd.heatPortRad, living.gainRad) annotation (Line(
      points={{-47.2,-172},{-66,-172},{-66,52},{-46,52}},
      color={191,0,0},
      visible=false));
  connect(radGnd.heatPortCon, living.gainCon) annotation (Line(
      points={{-47.2,-168},{-64,-168},{-64,49},{-46,49}},
      color={191,0,0},
      visible=false));
  connect(radBed1.heatPortCon, bedRoom1.gainCon) annotation (Line(
      points={{52.8,-168},{38,-168},{38,73},{120,73}},
      color={191,0,0},
      visible=false));
  connect(radBed1.heatPortRad, bedRoom1.gainRad) annotation (Line(
      points={{52.8,-172},{34,-172},{34,76},{120,76}},
      color={191,0,0},
      visible=false));
  connect(radBat1.heatPortCon, bathRoom.gainCon) annotation (Line(
      points={{112.8,-168},{104,-168},{104,19},{120,19}},
      color={191,0,0},
      visible=false));
  connect(radBat1.heatPortRad, bathRoom.gainRad) annotation (Line(
      points={{112.8,-172},{100,-172},{100,22},{120,22}},
      color={191,0,0},
      visible=false));
  connect(radBat2.heatPortRad, bathRoom.gainRad) annotation (Line(
      points={{82.8,-172},{72,-172},{72,22},{120,22}},
      color={191,0,0},
      visible=false));
  connect(radBat2.heatPortCon, bathRoom.gainCon) annotation (Line(
      points={{82.8,-168},{76,-168},{76,19},{120,19}},
      color={191,0,0},
      visible=false));
  connect(radBed2.heatPortCon, bedRoom2.gainCon) annotation (Line(points={{222.8,
          -168},{218,-168},{218,75},{256,75}}, color={191,0,0},
      visible=false));
  connect(radBed2.heatPortRad, bedRoom2.gainRad) annotation (Line(points={{222.8,
          -172},{198,-172},{198,78},{256,78}}, color={191,0,0},
      visible=false));
  connect(radBed3.heatPortCon, bedRoom3.gainCon) annotation (Line(points={{262.8,
          -168},{242,-168},{242,33},{260,33}}, color={191,0,0},
      visible=false));
  connect(radBed3.heatPortRad, bedRoom3.gainRad) annotation (Line(points={{262.8,
          -172},{238,-172},{238,36},{260,36}}, color={191,0,0},
      visible=false));
  connect(the.y, booToRea.u) annotation (Line(points={{260.6,-80},{260.6,-80},{278,
          -80}}, color={255,0,255}));
  connect(booToRea.y, pump.dp_in) annotation (Line(points={{301,-80},{320.2,-80},
          {320.2,-98}}, color={0,0,127}));
  connect(the.u, living.TSensor) annotation (Line(points={{239.4,-80},{-46.6,-80},
          {-46.6,46}}, color={0,0,127}));
  connect(hea.TSet, Thea.y) annotation (Line(points={{372,-104},{378,-104},{381,
          -104}},            color={0,0,127}));
  connect(spl1.port_1, pump.port_b)
    annotation (Line(points={{280,-110},{296,-110},{310,-110}},
                                                     color={0,127,255}));
  connect(spl1.port_2, spl.port_1)
    annotation (Line(points={{260,-110},{250,-110},{240,-110}},
                                                     color={0,127,255}));
  connect(spl2.port_1, spl.port_2) annotation (Line(points={{130,-110},{220,-110}},
                       color={0,127,255}));
  connect(spl2.port_2, spl3.port_1) annotation (Line(points={{110,-110},{106,-110},
          {100,-110}}, color={0,127,255}));
  connect(spl3.port_2, spl4.port_1)
    annotation (Line(points={{80,-110},{70,-110}}, color={0,127,255}));
  connect(integrator.u, hea.Q_flow) annotation (Line(points={{350,-66},{349,-66},
          {349,-104}}, color={0,0,127}));
  connect(senTemRadBed1.T, valBed1.T) annotation (Line(points={{49,-148},{49.4,-148},
          {49.4,-140}}, color={0,0,127}));
  connect(senTemRadBed1.port, radBed1.heatPortCon) annotation (Line(points={{49,
          -162},{49,-168},{52.8,-168}}, color={191,0,0}));
  connect(valBed1.port_a, spl4.port_3) annotation (Line(points={{60,-130},{60,-130},
          {60,-120}}, color={0,127,255}));
  connect(valBed1.port_b, radBed1.port_a) annotation (Line(points={{60,-150},{60,
          -155},{60,-160}}, color={0,127,255}));
  connect(senTemRadBat2.T, valBat2.T) annotation (Line(points={{79,-148},{79.4,-148},
          {79.4,-140}}, color={0,0,127}));
  connect(valBat2.port_b, radBat2.port_a) annotation (Line(points={{90,-150},{90,
          -150},{90,-160}}, color={0,127,255}));
  connect(radBat2.heatPortCon, senTemRadBat2.port) annotation (Line(points={{82.8,
          -168},{79,-168},{79,-162}}, color={191,0,0}));
  connect(valBat2.port_a, spl3.port_3) annotation (Line(points={{90,-130},{90,-125},
          {90,-120}}, color={0,127,255}));
  connect(senTemRadBat1.T, valBat1.T) annotation (Line(points={{109,-148},{109.4,
          -148},{109.4,-140}}, color={0,0,127}));
  connect(valBat1.port_a, spl2.port_3)
    annotation (Line(points={{120,-130},{120,-120}}, color={0,127,255}));
  connect(valBat1.port_b, radBat1.port_a) annotation (Line(points={{120,-150},{120,
          -150},{120,-160}}, color={0,127,255}));
  connect(senTemRadBat1.port, radBat1.heatPortCon) annotation (Line(points={{109,
          -162},{108,-162},{108,-168},{112.8,-168}}, color={191,0,0}));
  connect(senTemRadBat3.T, valBed2.T) annotation (Line(points={{219,-148},{219.4,
          -148},{219.4,-140}}, color={0,0,127}));
  connect(valBed2.port_a, spl.port_3)
    annotation (Line(points={{230,-130},{230,-120}}, color={0,127,255}));
  connect(valBed2.port_b, radBed2.port_a) annotation (Line(points={{230,-150},{230,
          -150},{230,-160}}, color={0,127,255}));
  connect(senTemRadBat3.port, radBed2.heatPortCon) annotation (Line(points={{219,
          -162},{219,-168},{222.8,-168}}, color={191,0,0}));
  connect(senTemRadBat4.T, valBed3.T) annotation (Line(points={{259,-148},{259.4,
          -148},{259.4,-140}}, color={0,0,127}));
  connect(radBed3.port_a, valBed3.port_b) annotation (Line(points={{270,-160},{270,
          -155},{270,-150}}, color={0,127,255}));
  connect(valBed3.port_a, spl1.port_3) annotation (Line(points={{270,-130},{270,
          -120}},            color={0,127,255}));
  connect(senTemRadBat4.port, radBed3.heatPortCon) annotation (Line(points={{259,
          -162},{260,-162},{260,-168},{262.8,-168}}, color={191,0,0}));
  connect(senTemGnd.T, valGnd.T) annotation (Line(points={{-51,-148},{-50.6,
          -148},{-50.6,-140}},
                         color={0,0,127}));
  connect(valGnd.port_a, spl4.port_2) annotation (Line(points={{-40,-130},{-40,-110},
          {50,-110}}, color={0,127,255}));
  connect(senTemGnd.port, radGnd.heatPortCon) annotation (Line(points={{-51,
          -162},{-50,-162},{-50,-168},{-47.2,-168}},
                                               color={191,0,0}));
  connect(radGnd.port_a, valGnd.port_b) annotation (Line(points={{-40,-160},{-40,
          -150}},            color={0,127,255}));
  connect(sim.weaBus, weaBus1) annotation (Line(
      points={{384,50.8},{380,50.8},{380,80}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(thermalConductor.port_a, Diner.gainCon)
    annotation (Line(points={{20,0},{20,-25},{-26,-25}}, color={191,0,0}));
  connect(thermalConductor.port_b, living.gainCon)
    annotation (Line(points={{20,20},{20,49},{-46,49}}, color={191,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -200},{400,240}},
        initialScale=0.1), graphics={
        Line(points={{-72,-100},{-100,-100},{-100,100},{-68,100},{-68,-10},{0,-10},
              {0,100},{-68,100}}, color={28,108,200}),
        Line(points={{-72,-98}}, color={28,108,200}),
        Line(points={{-72,-100},{-72,-50},{0,-50},{0,-8}}, color={28,108,200}),
        Line(points={{-60,-10},{-100,-10}}, color={28,108,200}),
        Line(points={{-72,-100},{0,-100},{0,-50}}, color={28,108,200}),
        Line(points={{60,100},{160,100},{160,46},{60,46},{60,100}}, color={28,108,
              200}),
        Line(
          points={{92,100},{92,46}},
          color={28,108,200},
          pattern=LinePattern.Dash),
        Line(points={{60,46},{160,46},{160,-8},{60,-8},{60,46}}, color={28,108,200}),
        Line(points={{92,46},{92,-8}}, color={28,108,200}),
        Line(points={{220,100},{320,100},{320,46},{220,46},{220,100}},
                                                                    color={28,108,
              200}),
        Line(points={{220,46},{320,46},{320,-8},{220,-8},{220,46}}, color={28,108,
              200}),
        Line(
          points={{-68,46},{0,46}},
          color={28,108,200},
          pattern=LinePattern.Dash)}),
                                Icon(coordinateSystem(
        preserveAspectRatio=false,
        initialScale=0.1)),
    experiment(
      StopTime=500000,
      __Dymola_NumberOfIntervals=5000,
      __Dymola_fixedstepsize=15,
      __Dymola_Algorithm="Euler"),
    __Dymola_Commands,
    Documentation(info="<html>
<p>
Example model of a partially renovated terraced house in Belgium.
This model adds the building heating system.
</p>
</html>", revisions="<html>
<ul>
<li>
January 9, 2017 by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
end Heating;
