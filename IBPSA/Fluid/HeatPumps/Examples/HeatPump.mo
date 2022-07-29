within IBPSA.Fluid.HeatPumps.Examples;
model HeatPump "Example for the reversible heat pump model."
 extends Modelica.Icons.Example;

  replaceable package Medium_sin = IBPSA.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium annotation (choicesAllMatching=true);
  replaceable package Medium_sou = IBPSA.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium annotation (choicesAllMatching=true);
  IBPSA.Fluid.Sources.MassFlowSource_T                sourceSideMassFlowSource(
    use_m_flow_in=true,
    use_T_in=true,
    m_flow=1,
    nPorts=1,
    redeclare package Medium = Medium_sou,
    T=275.15) "Ideal mass flow source at the inlet of the source side"
              annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));

  IBPSA.Fluid.Sources.Boundary_pT                  sourceSideFixedBoundary(
                                                                         nPorts=
       1, redeclare package Medium = Medium_sou)
          "Fixed boundary at the outlet of the source side"
          annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=0,
        origin={-70,-10})));
  Modelica.Blocks.Sources.Ramp TsuSourceRamp(
    duration=500,
    startTime=500,
    height=25,
    offset=278)
    "Ramp signal for the temperature input of the source side's ideal flow"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Modelica.Blocks.Sources.Constant T_amb_internal(k=291.15)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-12,-90})));
  IBPSA.Fluid.HeatPumps.HeatPump heatPump(
    redeclare model vapComIne =
        IBPSA.Fluid.HeatPumps.BlackBoxData.VapourCompressionInertias.NoInertia,
    use_safetyControl=true,
    use_busConnectorOnly=false,
    QUse_flow_nominal=1000,
    cpCon=4184,
    mEva_flow_nominal=mSouStep.offset,
    y_nominal=1,
    TCon_nominal=313.15,
    dTCon_nominal=7,
    GConIns=0,
    TEva_nominal=278.15,
    dTEva_nominal=3,
    CEva=100,
    GEvaOut=5,
    CCon=100,
    GConOut=5,
    dpEva_nominal=0,
    dpCon_nominal=0,
    VCon=0.4,
    use_conCap=false,
    redeclare package Medium_con = Medium_sin,
    redeclare package Medium_eva = Medium_sou,
    use_rev=true,
    GEvaIns=0,
    cpEva=4184,
    redeclare model BlaBoxHPHeating =
        IBPSA.Fluid.HeatPumps.BlackBoxData.EuropeanNorm2D (
        redeclare IBPSA.Fluid.HeatPumps.BlackBoxData.Frosting.NoFrosting
          iceFacCalc,
        dataTable=
            IBPSA.Fluid.HeatPumps.BlackBoxData.EuropeanNom2D.EN14511.Vitocal200AWO201()),
    redeclare model BlaBoxHPCooling =
        IBPSA.Fluid.Chillers.BlackBoxData.BlackBox.LookUpTable2D (smoothness=
            Modelica.Blocks.Types.Smoothness.LinearSegments, dataTable=
            IBPSA.Fluid.Chillers.BlackBoxData.EN14511.Vitocal200AWO201()),
    VEva=0.04,
    use_evaCap=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    use_autoCalc=false,
    TCon_start=303.15,
    redeclare
      IBPSA.Fluid.HeatPumps.SafetyControls.RecordsCollection.DefaultSafetyControl
      safetyControlParameters)
                       annotation (Placement(transformation(
        extent={{-24,-29},{24,29}},
        rotation=270,
        origin={0,-39})));

  Modelica.Blocks.Sources.BooleanStep booleanModeSetStep(startTime=1800,
      startValue=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,70})));

  IBPSA.Fluid.Sensors.TemperatureTwoPort senTAct(
    final m_flow_nominal=heatPump.m1_flow_nominal,
    final tau=1,
    final initType=Modelica.Blocks.Types.Init.InitialState,
    final tauHeaTra=1200,
    final allowFlowReversal=heatPump.allowFlowReversalCon,
    final transferHeat=false,
    redeclare final package Medium = Medium_sin,
    final T_start=303.15,
    final TAmb=291.15) "Temperature at sink inlet" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,-70})));
  Modelica.Blocks.Logical.Hysteresis hysHeating(
    pre_y_start=true,
    uLow=273.15 + 30,
    uHigh=273.15 + 35)
    annotation (Placement(transformation(extent={{60,80},{40,100}})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-10,10})));
  Modelica.Blocks.Sources.Sine sine(
    f=1/3600,
    amplitude=3000,
    offset=3000)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={90,90})));
  IBPSA.Fluid.Movers.SpeedControlled_Nrpm
                                    pumSou(
    redeclare final IBPSA.Fluid.Movers.Data.Pumps.Wilo.Stratos25slash1to8 per,
    final allowFlowReversal=true,
    final addPowerToMedium=false,
    redeclare final package Medium = Medium_sin,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Fan or pump at source side of HP" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={50,10})));

  IBPSA.Fluid.MixingVolumes.MixingVolume Room(
    nPorts=2,
    final use_C_flow=false,
    final m_flow_nominal=heatPump.m1_flow_nominal,
    final V=5,
    final allowFlowReversal=true,
    redeclare package Medium = Medium_sin,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Volume of Condenser" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={90,-30})));

  Modelica.Blocks.Sources.Constant nIn(k=100) annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={30,30})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow heatFlowRateCon
    "Heat flow rate of the condenser" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={90,10})));
  Modelica.Blocks.Math.Gain gain(k=-1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={90,50})));
  Modelica.Blocks.Logical.Not not2 "Negate output of hysteresis"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        origin={10,90},
        rotation=180)));
  IBPSA.Fluid.Sources.Boundary_pT   sinkSideFixedBoundary(      nPorts=1,
      redeclare package Medium = Medium_sin)
    "Fixed boundary at the outlet of the sink side" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={90,-70})));
  Modelica.Blocks.Logical.LogicalSwitch logicalSwitch
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-10,50})));
  Modelica.Blocks.Logical.Hysteresis hysCooling(
    pre_y_start=false,
    uLow=273.15 + 15,
    uHigh=273.15 + 19)
    annotation (Placement(transformation(extent={{40,60},{20,80}})));
  Modelica.Blocks.Sources.Pulse mSouStep(
    amplitude=-1,
    width=50,
    period=500,
    startTime=500,
    offset=1)
    "Step signal for the mass flow rate source side's ideal mass flow source"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
equation

  connect(sourceSideMassFlowSource.ports[1], heatPump.port_a2) annotation (Line(
        points={{-40,-70},{-14.5,-70},{-14.5,-63}},         color={0,127,255}));
  connect(nIn.y, pumSou.Nrpm)
    annotation (Line(points={{41,30},{50,30},{50,22}},
                                                 color={0,0,127}));
  connect(Room.heatPort, heatFlowRateCon.port)
    annotation (Line(points={{90,-20},{90,0}},        color={191,0,0}));
  connect(sine.y, gain.u) annotation (Line(points={{90,79},{90,62}},
                      color={0,0,127}));
  connect(heatFlowRateCon.Q_flow, gain.y) annotation (Line(points={{90,20},{90,
          39}},                     color={0,0,127}));
  connect(heatPump.port_b2, sourceSideFixedBoundary.ports[1]) annotation (Line(
        points={{-14.5,-15},{-52,-15},{-52,-10},{-60,-10}},
                                                      color={0,127,255}));
  connect(heatPump.port_b1, senTAct.port_a) annotation (Line(points={{14.5,-63},
          {14.5,-70},{40,-70}},        color={0,127,255}));
  connect(Room.ports[1], pumSou.port_a) annotation (Line(points={{80,-29},{80,
          -32},{66,-32},{66,10},{60,10}},
                           color={0,127,255}));
  connect(pumSou.port_b, heatPump.port_a1) annotation (Line(points={{40,10},{
          14.5,10},{14.5,-15}}, color={0,127,255}));
  connect(senTAct.T, hysHeating.u) annotation (Line(points={{50,-59},{50,-56},{
          54,-56},{54,-8},{70,-8},{70,90},{62,90}},          color={0,0,127}));
  connect(hysHeating.y, not2.u)
    annotation (Line(points={{39,90},{22,90}},   color={255,0,255}));
  connect(senTAct.port_b, sinkSideFixedBoundary.ports[1]) annotation (Line(
        points={{60,-70},{80,-70}},                   color={0,127,255}));
  connect(senTAct.port_b, Room.ports[2]) annotation (Line(points={{60,-70},{66,
          -70},{66,-31},{80,-31}}, color={0,127,255}));
  connect(TsuSourceRamp.y, sourceSideMassFlowSource.T_in) annotation (Line(
        points={{-79,-90},{-62,-90},{-62,-66}},           color={0,0,127},
        smooth=Smooth.None));
  connect(logicalSwitch.u1, not2.y) annotation (Line(points={{-18,62},{-18,90},
          {-1,90}},          color={255,0,255}));
  connect(hysCooling.y, logicalSwitch.u3) annotation (Line(points={{19,70},{4,
          70},{4,62},{-2,62}},     color={255,0,255}));
  connect(senTAct.T, hysCooling.u) annotation (Line(points={{50,-59},{50,-56},{
          54,-56},{54,-8},{70,-8},{70,70},{42,70}},
        color={0,0,127}));
  connect(booleanModeSetStep.y, logicalSwitch.u2)
    annotation (Line(points={{-59,70},{-10,70},{-10,62}}, color={255,0,255}));
  connect(logicalSwitch.y, booleanToReal.u)
    annotation (Line(points={{-10,39},{-10,22}},       color={255,0,255}));
  connect(booleanModeSetStep.y, heatPump.modeSet) annotation (Line(points={{-59,
          70},{-28,70},{-28,-11.16},{-21.75,-11.16}}, color={255,0,255}));
  connect(booleanToReal.y, heatPump.ySet) annotation (Line(points={{-10,-1},{
          -10,-4},{4.83333,-4},{4.83333,-11.16}},
                               color={0,0,127}));
  connect(mSouStep.y, sourceSideMassFlowSource.m_flow_in)
    annotation (Line(points={{-79,-50},{-62,-50},{-62,-62}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://IBPSA/Resources/Scripts/Dymola/Fluid/HeatPumps/Examples/HeatPump.mos"
        "Simulate and plot"),
    Documentation(info="<html><h4>
  <span style=\"color: #008000\">Overview</span>
</h4>
<p>
  Simple test set-up for the HeatPumpDetailed model. The heat pump is
  turned on and off while the source temperature increases linearly.
  Outputs are the electric power consumption of the heat pump and the
  supply temperature.
</p>
<p>
  Besides using the default simple table data, the user should also
  test tabulated data from <a href=
  \"modelica://IBPSA.DataBase.HeatPump\">IBPSA.DataBase.HeatPump</a> or
  polynomial functions.
</p>
</html>",
      revisions="<html><ul>
  <li>
    <i>May 22, 2019</i> by Julian Matthes:<br/>
    Rebuild due to the introducion of the thermal machine partial model
    (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/715\">#715</a>)
  </li>
  <li>
    <i>November 26, 2018&#160;</i> by Fabian Wüllhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">#577</a>)
  </li>
</ul>
</html>"),
    __Dymola_Commands(file="Modelica://IBPSA/Resources/Scripts/Dymola/Fluid/HeatPumps/Examples/HeatPump.mos" "Simulate and plot"),
    Icon(coordinateSystem(extent={{-100,-100},{100,80}})));
end HeatPump;
