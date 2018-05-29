within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Examples;
model BorefieldTwoUTubePar
  "Borefield with a double U-Tube configuration in parallel"
  extends
    IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Examples.BorefieldOneUTube(
      redeclare
      IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BorefieldTwoUTube borFie(
        borFieDat),                                                                                                                                                 borFieDat(conDat=
          IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.ConfigurationData.ExampleConfigurationData(
           singleUTube=false)));
  replaceable
    .IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.BorefieldOneUTube borFie1(
      redeclare package Medium = Medium, borFieDat=borFieDat1)
    annotation (Placement(transformation(extent={{-20,42},{22,78}})));
  Sources.MassFlowSource_T             sou1(
    redeclare package Medium = Medium,
    nPorts=1,
    use_T_in=false,
    m_flow=borFieDat.conDat.m_flow_nominal,
    T=303.15) "Source" annotation (Placement(transformation(extent={{-98,50},{-78,
            70}},     rotation=0)));
  Sensors.TemperatureTwoPort TBorFieIn1(
      redeclare package Medium = Medium, m_flow_nominal=borFieDat.conDat.m_flow_nominal)
                                         "Inlet borefield temperature"
    annotation (Placement(transformation(extent={{-58,50},{-38,70}})));
  Sources.Boundary_pT             sin1(
    redeclare package Medium = Medium,
    use_p_in=false,
    use_T_in=false,
    nPorts=1,
    p=101330,
    T=283.15) "Sink" annotation (Placement(transformation(extent={{102,50},{82,70}},
                  rotation=0)));
  Sensors.TemperatureTwoPort TBorFieOut1(
      redeclare package Medium = Medium, m_flow_nominal=borFieDat.conDat.m_flow_nominal)
                                         "Outlet borefield temperature"
    annotation (Placement(transformation(extent={{42,50},{62,70}})));
  Data.BorefieldData.ExampleBorefieldData borFieDat1(conDat=
        IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.ConfigurationData.ExampleConfigurationData(
         parallel2UTube=false))
    annotation (Placement(transformation(extent={{-100,-68},{-80,-48}})));
equation
  connect(sou1.ports[1], TBorFieIn1.port_a)
    annotation (Line(points={{-78,60},{-58,60}}, color={0,127,255}));
  connect(TBorFieIn1.port_b, borFie1.port_a)
    annotation (Line(points={{-38,60},{-30,60},{-20,60}}, color={0,127,255}));
  connect(TBorFieOut1.port_a, borFie1.port_b)
    annotation (Line(points={{42,60},{22,60}}, color={0,127,255}));
  connect(TBorFieOut1.port_b, sin1.ports[1])
    annotation (Line(points={{62,60},{72,60},{82,60}}, color={0,127,255}));
end BorefieldTwoUTubePar;
