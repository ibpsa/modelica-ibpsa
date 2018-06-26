within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Boreholes.Examples;
model BoreholeDynamics
  import IBPSA;
  extends Modelica.Icons.Example;
  package Medium = IBPSA.Media.Water;

  IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Boreholes.BoreholeOneUTube
    borHolOneUTubDyn(
    redeclare package Medium = Medium,
    borFieDat=borFieUTubDat,
    m_flow_nominal=borFieUTubDat.conDat.m_flow_nominal_bh,
    dp_nominal=10,
    dynFil=true) "Borehole with U-Tub configuration and grout dynamics"
    annotation (Placement(transformation(
        extent={{-14,-14},{14,14}},
        rotation=0,
        origin={0,60})));
  IBPSA.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    nPorts=1,
    use_T_in=false,
    m_flow=borFieUTubDat.conDat.m_flow_nominal_bh,
    T=303.15) "Source" annotation (Placement(transformation(extent={{-80,50},{-60,
            70}}, rotation=0)));
  IBPSA.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    use_p_in=false,
    use_T_in=false,
    nPorts=1,
    p=101330,
    T=283.15) "Sink" annotation (Placement(transformation(extent={{80,50},{60,70}},
                  rotation=0)));
  parameter
    IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.BorefieldData.SandBox_validation
    borFieUTubDat "Borefield parameters with UTube borehole configuration"
    annotation (Placement(transformation(extent={{80,20},{100,40}})));
  IBPSA.Fluid.Sensors.TemperatureTwoPort TBorIn(m_flow_nominal=borFieUTubDat.conDat.m_flow_nominal_bh,
      redeclare package Medium = Medium) "Inlet borehole temperature"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  IBPSA.Fluid.Sensors.TemperatureTwoPort TBor1UTubDyn(m_flow_nominal=
        borFieUTubDat.conDat.m_flow_nominal_bh, redeclare package Medium =
        Medium) "Outlet borehole temperature"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.GroundTemperatureResponse
    groTemRes(borFieDat=borFieUTubDat, tLoaAgg=60)
    "Ground temperature response"
    annotation (Placement(transformation(extent={{-70,80},{-50,100}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector therCol1(m=
        borFieUTubDat.conDat.nVer) "Thermal collector" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-36,90})));
  Modelica.Blocks.Sources.Constant TGroUn(k=borFieUTubDat.conDat.T_start)
    "Undisturbed ground temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,90})));
  IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Boreholes.BoreholeOneUTube
    borHolOneUTubSteSta(
    redeclare package Medium = Medium,
    borFieDat=borFieUTubDat,
    m_flow_nominal=borFieUTubDat.conDat.m_flow_nominal_bh,
    dp_nominal=10,
    dynFil=false) "Borehole with U-Tub configuration and steady states grout"
    annotation (Placement(transformation(
        extent={{-14,-14},{14,14}},
        rotation=0,
        origin={0,0})));
  IBPSA.Fluid.Sources.MassFlowSource_T sou1(
    redeclare package Medium = Medium,
    nPorts=1,
    use_T_in=false,
    m_flow=borFieUTubDat.conDat.m_flow_nominal_bh,
    T=303.15) "Source" annotation (Placement(transformation(extent={{-80,-10},{-60,
            10}}, rotation=0)));
  IBPSA.Fluid.Sources.Boundary_pT sin1(
    redeclare package Medium = Medium,
    use_p_in=false,
    use_T_in=false,
    nPorts=1,
    p=101330,
    T=283.15) "Sink" annotation (Placement(transformation(extent={{80,-10},{60,10}},
                  rotation=0)));
  IBPSA.Fluid.Sensors.TemperatureTwoPort TBorIn1(m_flow_nominal=borFieUTubDat.conDat.m_flow_nominal_bh,
      redeclare package Medium = Medium) "Inlet borehole temperature"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  IBPSA.Fluid.Sensors.TemperatureTwoPort TBor1UTubSteSta(m_flow_nominal=
        borFieUTubDat.conDat.m_flow_nominal_bh, redeclare package Medium =
        Medium) "Outlet borehole temperature"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.GroundTemperatureResponse
    groTemRes1(borFieDat=borFieUTubDat, tLoaAgg=60)
    "Ground temperature response"
    annotation (Placement(transformation(extent={{-70,20},{-50,40}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector therCol2(m=
        borFieUTubDat.conDat.nVer) "Thermal collector" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-36,30})));
  IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Boreholes.BoreholeTwoUTube
    borHol2UTubDyn(
    redeclare package Medium = Medium,
    dp_nominal=10,
    dynFil=true,
    m_flow_nominal=borFie2UTubDat.conDat.m_flow_nominal_bh,
    borFieDat=borFie2UTubDat)
    "Borehole with 2U-Tub configuration and grout dynamics" annotation (
      Placement(transformation(
        extent={{-14,-14},{14,14}},
        rotation=0,
        origin={0,-60})));
  IBPSA.Fluid.Sources.MassFlowSource_T sou2(
    redeclare package Medium = Medium,
    nPorts=1,
    use_T_in=false,
    m_flow=borFie2UTubDat.conDat.m_flow_nominal_bh,
    T=303.15) "Source" annotation (Placement(transformation(extent={{-80,-70},{-60,
            -50}}, rotation=0)));
  IBPSA.Fluid.Sources.Boundary_pT sin2(
    redeclare package Medium = Medium,
    use_p_in=false,
    use_T_in=false,
    nPorts=1,
    p=101330,
    T=283.15) "Sink" annotation (Placement(transformation(extent={{80,-70},{60,-50}},
                  rotation=0)));
  parameter
    IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.BorefieldData.SandBox_validation
    borFie2UTubDat(conDat=
        IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.ConfigurationData.SandBox_validation(
         borHolCon=IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Types.BoreHoleConfiguration.DoubleUTubeParallel))
    "Borefield parameters with UTube borehole configuration"
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
  IBPSA.Fluid.Sensors.TemperatureTwoPort TBorIn2(redeclare package Medium =
        Medium, m_flow_nominal=borFie2UTubDat.conDat.m_flow_nominal_bh)
    "Inlet borehole temperature"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  IBPSA.Fluid.Sensors.TemperatureTwoPort TBor2UTubDyn(redeclare package Medium =
        Medium, m_flow_nominal=borFie2UTubDat.conDat.m_flow_nominal_bh)
    "Outlet borehole temperature"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.GroundTemperatureResponse
    groTemRes2(tLoaAgg=60, borFieDat=borFie2UTubDat)
    "Ground temperature response"
    annotation (Placement(transformation(extent={{-70,-40},{-50,-20}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector therCol3(m=
        borFie2UTubDat.conDat.nVer) "Thermal collector" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-36,-30})));
  IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Boreholes.BoreholeTwoUTube
    borHol2UTubSteSta(
    redeclare package Medium = Medium,
    dp_nominal=10,
    dynFil=false,
    m_flow_nominal=borFie2UTubDat.conDat.m_flow_nominal_bh,
    borFieDat=borFie2UTubDat)
    "Borehole with 2U-Tub configuration and steady states grout" annotation (
      Placement(transformation(
        extent={{-14,-14},{14,14}},
        rotation=0,
        origin={0,-120})));
  IBPSA.Fluid.Sources.MassFlowSource_T sou3(
    redeclare package Medium = Medium,
    nPorts=1,
    use_T_in=false,
    m_flow=borFie2UTubDat.conDat.m_flow_nominal_bh,
    T=303.15) "Source" annotation (Placement(transformation(extent={{-80,-130},{
            -60,-110}}, rotation=0)));
  IBPSA.Fluid.Sources.Boundary_pT sin3(
    redeclare package Medium = Medium,
    use_p_in=false,
    use_T_in=false,
    nPorts=1,
    p=101330,
    T=283.15) "Sink" annotation (Placement(transformation(extent={{80,-130},{60,
            -110}},
                  rotation=0)));
  IBPSA.Fluid.Sensors.TemperatureTwoPort TBorIn3(redeclare package Medium =
        Medium, m_flow_nominal=borFie2UTubDat.conDat.m_flow_nominal_bh)
    "Inlet borehole temperature"
    annotation (Placement(transformation(extent={{-40,-130},{-20,-110}})));
  IBPSA.Fluid.Sensors.TemperatureTwoPort TBor2UTubSteSta(redeclare package
      Medium = Medium, m_flow_nominal=borFie2UTubDat.conDat.m_flow_nominal_bh)
    "Outlet borehole temperature"
    annotation (Placement(transformation(extent={{20,-130},{40,-110}})));
  IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.GroundHeatTransfer.GroundTemperatureResponse
    groTemRes3(tLoaAgg=60, borFieDat=borFie2UTubDat)
    "Ground temperature response"
    annotation (Placement(transformation(extent={{-70,-100},{-50,-80}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector therCol4(m=
        borFie2UTubDat.conDat.nVer) "Thermal collector" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-36,-90})));
equation
  connect(sou.ports[1],TBorIn. port_a)
    annotation (Line(points={{-60,60},{-40,60}},
                                               color={0,127,255}));
  connect(TBorIn.port_b, borHolOneUTubDyn.port_a)
    annotation (Line(points={{-20,60},{-14,60}}, color={0,127,255}));
  connect(borHolOneUTubDyn.port_b, TBor1UTubDyn.port_a)
    annotation (Line(points={{14,60},{14,60},{20,60}}, color={0,127,255}));
  connect(TBor1UTubDyn.port_b, sin.ports[1])
    annotation (Line(points={{40,60},{60,60}}, color={0,127,255}));
  connect(therCol1.port_a, borHolOneUTubDyn.port_wall)
    annotation (Line(points={{-26,90},{0,90},{0,74}}, color={191,0,0}));
  connect(sou1.ports[1], TBorIn1.port_a)
    annotation (Line(points={{-60,0},{-40,0}}, color={0,127,255}));
  connect(TBorIn1.port_b, borHolOneUTubSteSta.port_a)
    annotation (Line(points={{-20,0},{-14,0}}, color={0,127,255}));
  connect(borHolOneUTubSteSta.port_b, TBor1UTubSteSta.port_a)
    annotation (Line(points={{14,0},{14,0},{20,0}}, color={0,127,255}));
  connect(TBor1UTubSteSta.port_b, sin1.ports[1])
    annotation (Line(points={{40,0},{60,0}}, color={0,127,255}));
  connect(therCol2.port_a, borHolOneUTubSteSta.port_wall)
    annotation (Line(points={{-26,30},{0,30},{0,14}}, color={191,0,0}));
  connect(sou2.ports[1], TBorIn2.port_a)
    annotation (Line(points={{-60,-60},{-40,-60}}, color={0,127,255}));
  connect(TBorIn2.port_b, borHol2UTubDyn.port_a)
    annotation (Line(points={{-20,-60},{-14,-60}}, color={0,127,255}));
  connect(borHol2UTubDyn.port_b, TBor2UTubDyn.port_a)
    annotation (Line(points={{14,-60},{14,-60},{20,-60}}, color={0,127,255}));
  connect(TBor2UTubDyn.port_b, sin2.ports[1])
    annotation (Line(points={{40,-60},{60,-60}}, color={0,127,255}));
  connect(therCol3.port_a, borHol2UTubDyn.port_wall)
    annotation (Line(points={{-26,-30},{0,-30},{0,-46}}, color={191,0,0}));
  connect(sou3.ports[1], TBorIn3.port_a)
    annotation (Line(points={{-60,-120},{-40,-120}}, color={0,127,255}));
  connect(TBorIn3.port_b, borHol2UTubSteSta.port_a)
    annotation (Line(points={{-20,-120},{-14,-120}}, color={0,127,255}));
  connect(borHol2UTubSteSta.port_b, TBor2UTubSteSta.port_a) annotation (Line(
        points={{14,-120},{14,-120},{20,-120}}, color={0,127,255}));
  connect(TBor2UTubSteSta.port_b, sin3.ports[1])
    annotation (Line(points={{40,-120},{60,-120}}, color={0,127,255}));
  connect(therCol4.port_a, borHol2UTubSteSta.port_wall)
    annotation (Line(points={{-26,-90},{0,-90},{0,-106}}, color={191,0,0}));
  connect(TGroUn.y, groTemRes.TSoi)
    annotation (Line(points={{-79,90},{-75.5,90},{-72,90}}, color={0,0,127}));
  connect(TGroUn.y, groTemRes1.TSoi) annotation (Line(points={{-79,90},{-80,90},
          {-80,30},{-72,30}}, color={0,0,127}));
  connect(TGroUn.y, groTemRes2.TSoi) annotation (Line(points={{-79,90},{-80,90},
          {-80,-30},{-72,-30}}, color={0,0,127}));
  connect(TGroUn.y, groTemRes3.TSoi) annotation (Line(points={{-79,90},{-80,90},
          {-80,-90},{-72,-90}}, color={0,0,127}));
  connect(groTemRes.borWall, therCol1.port_b)
    annotation (Line(points={{-50,90},{-48,90},{-46,90}}, color={191,0,0}));
  connect(groTemRes1.borWall, therCol2.port_b)
    annotation (Line(points={{-50,30},{-48,30},{-46,30}}, color={191,0,0}));
  connect(therCol3.port_b, groTemRes2.borWall)
    annotation (Line(points={{-46,-30},{-48,-30},{-50,-30}}, color={191,0,0}));
  connect(groTemRes3.borWall, therCol4.port_b)
    annotation (Line(points={{-50,-90},{-48,-90},{-46,-90}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-140},
            {100,100}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-140},{100,100}})),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/HeatExchangers/GroundHeatExchangers/Boreholes/Examples/BoreholeDynamics.mos"
        "Simulate and Plot"));
end BoreholeDynamics;
