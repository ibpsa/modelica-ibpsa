within IBPSA.Fluid.HeatPumps.Examples;
model HeatPump "Example for the reversible heat pump model."
 extends Modelica.Icons.Example;

  replaceable package MediumSin = IBPSA.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    annotation (choicesAllMatching=true);
  replaceable package MediumSou = IBPSA.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    annotation (choicesAllMatching=true);
  IBPSA.Fluid.Sources.MassFlowSource_T souSidSou(
    use_m_flow_in=true,
    use_T_in=true,
    m_flow=1,
    nPorts=1,
    redeclare package Medium = MediumSou,
    T=275.15) "Ideal mass flow source at the inlet of the source side"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));

  Sources.Boundary_pT souSidFixBou(nPorts=1, redeclare package Medium =
        MediumSou) "Fixed boundary at the outlet of the source side"
          annotation (Placement(transformation(extent={{-50,20},{-30,0}},
          rotation=0)));
  Modelica.Blocks.Sources.Ramp TSouRamp(
    duration=500,
    startTime=500,
    height=25,
    offset=278)
    "Ramp signal for the temperature input of the source side's ideal flow"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Modelica.Blocks.Sources.Constant TAmbInternal(k=291.15)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}}, rotation=-90)));
  IBPSA.Fluid.HeatPumps.HeatPump heaPum(
    redeclare model VapourCompressionCycleInertia =
        IBPSA.Fluid.HeatPumps.BlackBoxData.VapourCompressionInertias.NoInertia,
    redeclare package MediumCon = MediumSin,
    redeclare package MediumEva = MediumSou,
    tauCon=3600,
    mEva_flow_nominal=heaPum.vapComCyc.blaBoxHeaPumHea.datTab.mEva_flow_nominal,
    redeclare model BlackBoxHeatPumpHeating =
        IBPSA.Fluid.HeatPumps.BlackBoxData.EuropeanNorm2D (datTab=
            IBPSA.Fluid.HeatPumps.BlackBoxData.EuropeanNorm2DData.EN14511.Vitocal200AWO201()),
    redeclare model BlackBoxHeatPumpCooling =
        IBPSA.Fluid.Chillers.BlackBoxData.EuropeanNorm2D (
        redeclare IBPSA.Fluid.HeatPumps.BlackBoxData.Frosting.NoFrosting
          iceFacCal,
        smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
        datTab=
            IBPSA.Fluid.Chillers.BlackBoxData.EuropeanNorm2DData.EN14511.Vitocal200AWO201()),
    redeclare
      IBPSA.Fluid.HeatPumps.SafetyControls.RecordsCollection.DefaultSafetyControl
      safCtrlPar(
      minRunTime=100,
      minLocTime=200,
      use_minFlowCtrl=true),
    CCon=100,
    CEva=100,
    GConIns=0,
    GConOut=5,
    GEvaIns=0,
    GEvaOut=5,
    QUse_flow_nominal=6000,
    TCon_nominal(displayUnit="K") = 313.15,
    TCon_start(displayUnit="K") = 303.15,
    TEva_nominal(displayUnit="K") = 278.15,
    cpCon=4184,
    cpEva=4184,
    dTCon_nominal=7,
    dTEva_nominal=3,
    dpCon_nominal(displayUnit="Pa") = 1000,
    dpEva_nominal(displayUnit="Pa") = 0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    use_busConnectorOnly=false,
    use_conCap=false,
    use_evaCap=false,
    use_rev=true,
    use_safetyControl=true,
    y_nominal=1) annotation (Placement(transformation(extent={{-24,-29},{24,29}},
          rotation=270)));

  Modelica.Blocks.Sources.BooleanStep boorevSetStep(startTime=1800, startValue=
       true)           annotation (Placement(transformation(extent={{-100,-20},{
            -80,0}},
                  rotation=0)));

  Modelica.Blocks.Logical.Hysteresis hysHea(
    pre_y_start=true,
    uLow=273.15 + 30,
    uHigh=273.15 + 35)
    annotation (Placement(transformation(extent={{60,80},{40,100}})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-90,70})));
  Modelica.Blocks.Sources.Sine sine(
    f=1/3600,
    amplitude=heaPum.QUse_flow_nominal/2,
    offset=heaPum.QUse_flow_nominal/2) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={90,90})));
  Movers.FlowControlled_m_flow pumSou(
    m_flow_nominal=heaPum.mCon_flow_nominal,
    redeclare final IBPSA.Fluid.Movers.Data.Pumps.Wilo.Stratos32slash1to12 per,
    final allowFlowReversal=true,
    final addPowerToMedium=false,
    redeclare final package Medium = MediumSin,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dp_nominal=heaPum.dpCon_nominal) "Fan or pump at source side of HP"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={50,10})));

  MixingVolumes.MixingVolume dem(
    nPorts=2,
    final use_C_flow=false,
    final m_flow_nominal=heaPum.mCon_flow_nominal,
    final V=0.001,
    final allowFlowReversal=true,
    redeclare package Medium = MediumSin,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Volume of demand"    annotation (Placement(transformation(extent={{-10,-10},
            {10,10}}, rotation=270,
        origin={90,-22})));

  Modelica.Blocks.Sources.Constant constMCon_flow(final k=heaPum.mCon_flow_nominal)
      annotation (Placement(
        transformation(extent={{10,-10},{-10,10}}, rotation=180,
        origin={30,32})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heatFlowRateCon
    "Heat flow rate of the condenser" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={90,8})));
  Modelica.Blocks.Math.Product product1   annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={90,50})));
  Modelica.Blocks.Logical.Not notHys "Negate output of hysteresis"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={10,90})));
  IBPSA.Fluid.Sources.Boundary_pT sinSidFixBou(redeclare package Medium =
        MediumSin, nPorts=1) "Fixed boundary at the outlet of the sink side"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={50,-30})));
  Modelica.Blocks.Logical.LogicalSwitch logicalSwitch
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-10,50})));
  Modelica.Blocks.Logical.Hysteresis hysCoo(
    pre_y_start=false,
    uLow=273.15 + 15,
    uHigh=273.15 + 19)
    annotation (Placement(transformation(extent={{40,58},{20,78}})));
  Modelica.Blocks.Sources.Pulse mSouStep(
    amplitude=heaPum.mEva_flow_nominal,
    width=95,
    period=1800,
    startTime=0,
    offset=0)
    "Step signal for the mass flow rate source side's ideal mass flow source"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor  heatFlowRateCon1
    "Heat flow rate of the condenser" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={60,50})));
  Modelica.Blocks.Math.BooleanToReal booleanToRealMode(realTrue=-1, realFalse=1)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-70,30})));
equation

  connect(souSidSou.ports[1], heaPum.port_a2) annotation (Line(points={{-40,-70},
          {-14.5,-70},{-14.5,-24}}, color={0,127,255}));
  connect(dem.heatPort, heatFlowRateCon.port)
    annotation (Line(points={{90,-12},{90,-2}},            color={191,0,0}));
  connect(heatFlowRateCon.Q_flow, product1.y)
    annotation (Line(points={{90,18},{90,39}}, color={0,0,127}));
  connect(heaPum.port_b2, souSidFixBou.ports[1]) annotation (Line(points={{-14.5,
          24},{-14.5,34},{-30,34},{-30,10}},
                                        color={0,127,255}));
  connect(dem.ports[1], pumSou.port_a) annotation (Line(points={{80,-21},{68,-21},
          {68,-10},{66,-10},{66,10},{60,10}},
                                     color={0,127,255}));
  connect(pumSou.port_b, heaPum.port_a1)
    annotation (Line(points={{40,10},{14.5,10},{14.5,24}}, color={0,127,255}));
  connect(hysHea.y, notHys.u)
    annotation (Line(points={{39,90},{22,90}}, color={255,0,255}));
  connect(TSouRamp.y, souSidSou.T_in) annotation (Line(
      points={{-79,-90},{-62,-90},{-62,-66}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(logicalSwitch.u1, notHys.y)
    annotation (Line(points={{-18,62},{-18,90},{-1,90}}, color={255,0,255}));
  connect(hysCoo.y, logicalSwitch.u3)
    annotation (Line(points={{19,68},{-2,68},{-2,62}}, color={255,0,255}));
  connect(boorevSetStep.y, logicalSwitch.u2)
    annotation (Line(points={{-79,-10},{-54,-10},{-54,52},{-26,52},{-26,68},{-10,
          68},{-10,62}},                               color={255,0,255}));
  connect(logicalSwitch.y, booleanToReal.u)
    annotation (Line(points={{-10,39},{-10,38},{-50,38},{-50,88},{-90,88},{-90,82}},
                                                       color={255,0,255}));
  connect(boorevSetStep.y, heaPum.revSet) annotation (Line(points={{-79,-10},{
          -54,-10},{-54,32},{-28,32},{-28,34},{-21.75,34},{-21.75,27.84}},
                                          color={255,0,255}));
  connect(booleanToReal.y, heaPum.ySet) annotation (Line(points={{-90,59},{-90,50},
          {-52,50},{-52,36},{-8,36},{-8,34},{4.83333,34},{4.83333,27.84}},
                                         color={0,0,127}));
  connect(mSouStep.y, souSidSou.m_flow_in)
    annotation (Line(points={{-79,-50},{-62,-50},{-62,-62}}, color={0,0,127}));
  connect(heaPum.port_b1, dem.ports[2]) annotation (Line(points={{14.5,-24},{14.5,
          -46},{70,-46},{70,-23},{80,-23}},           color={0,127,255}));
  connect(sinSidFixBou.ports[1], pumSou.port_a) annotation (Line(points={{50,-20},
          {50,-10},{66,-10},{66,10},{60,10}}, color={0,127,255}));
  connect(heatFlowRateCon1.port, dem.heatPort) annotation (Line(points={{60,40},
          {60,24},{76,24},{76,-6},{90,-6},{90,-12}},
                                           color={191,0,0}));
  connect(heatFlowRateCon1.T, hysCoo.u)
    annotation (Line(points={{60,61},{60,68},{42,68}}, color={0,0,127}));
  connect(heatFlowRateCon1.T, hysHea.u) annotation (Line(points={{60,61},{60,70},
          {68,70},{68,90},{62,90}}, color={0,0,127}));
  connect(constMCon_flow.y, pumSou.m_flow_in) annotation (Line(points={{41,32},{
          41,28},{50,28},{50,22}},     color={0,0,127}));
  connect(product1.u1, sine.y) annotation (Line(points={{96,62},{96,70},{90,70},
          {90,79}}, color={0,0,127}));
  connect(boorevSetStep.y, booleanToRealMode.u) annotation (Line(points={{-79,-10},
          {-54,-10},{-54,44},{-88,44},{-88,30},{-82,30}},
                                                        color={255,0,255}));
  connect(booleanToRealMode.y, product1.u2) annotation (Line(points={{-59,30},{
          10,30},{10,52},{58,52},{58,62},{84,62}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://IBPSA/Resources/Scripts/Dymola/Fluid/HeatPumps/Examples/HeatPump.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>  Example for the reversible heat pump model</p>
</html>",
      revisions="<html><ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    Adjusted based on the discussion in this issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
  <li>
    <i>May 22, 2019</i> by Julian Matthes:<br/>
    Rebuild due to the introducion of the thermal machine partial model
    (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/715\">AixLib #715</a>)
  </li>
  <li>
    <i>November 26, 2018</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>"));
end HeatPump;
