within IBPSA.Fluid.HeatPumps.BaseClasses;
partial model PartialReversibleVapourCompressionMachine
  "Grey-box model for reversible heat pumps and 
  chillers using a black-box to simulate the vapour compression cycle"
  extends IBPSA.Fluid.Interfaces.PartialFourPortInterface(
    redeclare final package Medium1 = MediumCon,
    redeclare final package Medium2 = MediumEva,
    final m1_flow_nominal=mCon_flow_nominal,
    final m2_flow_nominal=mEva_flow_nominal,
    final allowFlowReversal1=allowFlowReversalCon,
    final allowFlowReversal2=allowFlowReversalEva,
    final m1_flow_small=1E-4*abs(mCon_flow_nominal),
    final m2_flow_small=1E-4*abs(mEva_flow_nominal));

  //General
  replaceable package MediumCon =
    Modelica.Media.Interfaces.PartialMedium "Medium at sink side"
    annotation (Dialog(tab = "Condenser"),choicesAllMatching=true);
  replaceable package MediumEva =
    Modelica.Media.Interfaces.PartialMedium "Medium at source side"
    annotation (Dialog(tab = "Evaporator"),choicesAllMatching=true);
  replaceable PartialBlackBoxVapourCompressionCycle vapComCyc constrainedby
    PartialBlackBoxVapourCompressionCycle(final use_rev=use_rev)
    "Blackbox model of refrigerant cycle of a vapour compression machine"
    annotation (Placement(transformation(extent={{-18,-18},{18,18}}, rotation=
            90)));
  parameter Modelica.Units.SI.HeatFlowRate QUse_flow_nominal
    "Nominal heat flow rate at useful side of the device"
    annotation (Dialog(group="Nominal Design"));

  parameter Real y_nominal "Nominal relative compressor speed"
    annotation (Dialog(group="Nominal Design"));
  replaceable model VapourCompressionCycleInertia =
     IBPSA.Fluid.HeatPumps.BlackBoxData.VapourCompressionInertias.NoInertia
    constrainedby
    IBPSA.Fluid.HeatPumps.BlackBoxData.VapourCompressionInertias.BaseClasses.PartialInertia
      "Inertia between the black-box outputs and the heat exchangers."
    annotation (choicesAllMatching=true, Dialog(group="Inertia"));
  parameter Boolean use_rev=true
    "Is the vapour compression machine reversible?"
    annotation(choices(checkBox=true));
  parameter Boolean use_internalSafetyControl=true
    "=true to enable internal safety control"
    annotation (Dialog(group="Safety Control"), choices(checkBox=true));

  parameter Boolean use_TSet=false
    "=true to use black-box internal control for supply 
    temperature of device with the given temperature set point TSet"
    annotation (
          choices(checkBox=true),
          Dialog(enable=not use_busConnectorOnly, group="Input Connectors"));
  //Condenser
  parameter Modelica.Units.SI.Time tauCon=30
    "Time constant of heat transfer at nominal flow"
    annotation (Dialog(tab="Condenser", group="Dynamics"));
  parameter Modelica.Units.SI.Temperature TCon_nominal
    "Nominal flow temperature at secondary condenser side"
    annotation (Dialog(group="Nominal Design", tab="Condenser"));
  parameter Modelica.Units.SI.TemperatureDifference dTCon_nominal
    "Nominal temperature difference at secondary condenser side"
    annotation (Dialog(group="Nominal Design", tab="Condenser"));
  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal
    "Manual input of the nominal mass flow rate (if not automatically calculated)"
    annotation (Dialog(
      group="Nominal Design",
      tab="Condenser",
      enable=not use_autoCalc));

  parameter Modelica.Units.SI.PressureDifference dpCon_nominal
    "Pressure drop at nominal mass flow rate"
    annotation (Dialog(group="Flow resistance", tab="Condenser"));
  parameter Real deltaMCon=0.1
    "Fraction of nominal mass flow rate where transition to turbulent occurs"
    annotation (Dialog(tab="Condenser", group="Flow resistance"));
  parameter Boolean use_conCap=true
    "If heat losses at capacitor side are considered or not"
    annotation (Dialog(group="Heat Losses", tab="Condenser"),
                                          choices(checkBox=true));
  parameter Modelica.Units.SI.HeatCapacity CCon
    "Heat capacity of Condenser (= cp*m). If you want to neglace the dry mass 
    of the condenser, you can set this value to zero"
    annotation (Dialog(
      group="Heat Losses",
      tab="Condenser",
      enable=use_conCap));
  parameter Modelica.Units.SI.ThermalConductance GConOut
    "Constant parameter for heat transfer to the ambient. 
    Represents a sum of thermal resistances such as conductance, 
    insulation and natural convection. If you want to simulate a condenser 
    with additional dry mass but without external heat losses, 
    set the value to zero"
    annotation (Dialog(
      group="Heat Losses",
      tab="Condenser",
      enable=use_conCap));
  parameter Modelica.Units.SI.ThermalConductance GConIns
    "Constant parameter for heat transfer to heat exchangers capacity. 
    Represents a sum of thermal resistances such as forced convection 
    and conduction inside of the capacity"
    annotation (Dialog(
      group="Heat Losses",
      tab="Condenser",
      enable=use_conCap));

  parameter Modelica.Units.SI.Density rhoCon=MediumCon.density(staCon_nominal)
    "Density of medium / fluid in condenser"
    annotation (Dialog(tab="Condenser", group="Medium properties"));
  parameter Modelica.Units.SI.SpecificHeatCapacity cpCon=
      MediumCon.specificHeatCapacityCp(staCon_nominal)
    "Specific heat capacaity of medium / fluid in condenser"
    annotation (Dialog(tab="Condenser", group="Medium properties"));

  //Evaporator
  parameter Modelica.Units.SI.Time tauEva=30
    "Time constant of heat transfer at nominal flow"
    annotation (Dialog(tab="Evaporator", group="Dynamics"));
  parameter Modelica.Units.SI.Temperature TEva_nominal
    "Nominal flow temperature at secondary evaporator side"
    annotation (Dialog(group="Nominal Design", tab="Evaporator"));
  parameter Modelica.Units.SI.TemperatureDifference dTEva_nominal
    "Nominal temperature difference at secondary evaporator side"
    annotation (Dialog(group="Nominal Design", tab="Evaporator"));
  parameter Modelica.Units.SI.MassFlowRate mEva_flow_nominal
    "Manual input of the nominal mass flow rate (if not automatically calculated)"
    annotation (Dialog(
      group="Nominal Design",
      tab="Evaporator",
      enable=not use_autoCalc));

  parameter Modelica.Units.SI.PressureDifference dpEva_nominal
    "Pressure drop at nominal mass flow rate" annotation (Dialog(group="Flow resistance",
        tab="Evaporator"), Evaluate=true);
  parameter Real deltaM_eva=0.1
    "Fraction of nominal mass flow rate where transition to turbulent occurs"
    annotation (Dialog(tab="Evaporator", group="Flow resistance"));
  parameter Boolean use_evaCap=true
    "If heat losses at capacitor side are considered or not"
    annotation (Dialog(group="Heat Losses", tab="Evaporator"),
                                          choices(checkBox=true));
  parameter Modelica.Units.SI.HeatCapacity CEva
    "Heat capacity of Evaporator (= cp*m). If you want to neglace the dry mass 
    of the evaporator, you can set this value to zero"
    annotation ( Dialog(
      group="Heat Losses",
      tab="Evaporator",
      enable=use_evaCap));
  parameter Modelica.Units.SI.ThermalConductance GEvaOut
    "Constant parameter for heat transfer to the ambient. Represents a sum of 
    thermal resistances such as conductance, insulation and natural convection. 
    If you want to simulate a evaporator with additional dry mass but 
    without external heat losses, set the value to zero"
    annotation ( Dialog(
      group="Heat Losses",
      tab="Evaporator",
      enable=use_evaCap));
  parameter Modelica.Units.SI.ThermalConductance GEvaIns
    "Constant parameter for heat transfer to heat exchangers capacity. 
    Represents a sum of thermal resistances such as forced convection 
    and conduction inside of the capacity"
    annotation ( Dialog(
      group="Heat Losses",
      tab="Evaporator",
      enable=use_evaCap));
  parameter Modelica.Units.SI.Density rhoEva=MediumEva.density(staEva_nominal)
    "Density of medium / fluid in evaporator"
    annotation (Dialog(tab="Evaporator", group="Medium properties"));
  parameter Modelica.Units.SI.SpecificHeatCapacity cpEva=
      MediumEva.specificHeatCapacityCp(staEva_nominal)
    "Specific heat capacaity of medium / fluid in evaporator"
    annotation (Dialog(tab="Evaporator", group="Medium properties"));

//Assumptions
  parameter Boolean allowFlowReversalEva=true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation (Dialog(group="Evaporator", tab="Assumptions"));
  parameter Boolean allowFlowReversalCon=true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation (Dialog(group="Condenser", tab="Assumptions"));

//Initialization
  parameter Modelica.Blocks.Types.Init initType=
    Modelica.Blocks.Types.Init.InitialState
    "Type of initialization (InitialState and InitialOutput are identical)"
    annotation (Dialog(tab="Initialization", group="Parameters"));
  parameter Modelica.Media.Interfaces.Types.AbsolutePressure pCon_start=
      MediumCon.p_default "Start value of pressure"
    annotation (Dialog(tab="Initialization", group="Condenser"));
  parameter Modelica.Media.Interfaces.Types.Temperature TCon_start=
    MediumCon.T_default
    "Start value of temperature"
    annotation (Dialog(tab="Initialization", group="Condenser"));
  parameter Modelica.Units.SI.Temperature TConCap_start=MediumCon.T_default
    "Initial temperature of heat capacity of condenser" annotation (Dialog(
      tab="Initialization",
      group="Condenser",
      enable=use_conCap));
  parameter Modelica.Media.Interfaces.Types.MassFraction XCon_start[MediumCon.nX]=
     MediumCon.X_default "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", group="Condenser"));
  parameter Modelica.Media.Interfaces.Types.AbsolutePressure pEva_start=
      MediumEva.p_default "Start value of pressure"
    annotation (Dialog(tab="Initialization", group="Evaporator"));
  parameter Modelica.Media.Interfaces.Types.Temperature TEva_start=
    MediumEva.T_default
    "Start value of temperature"
    annotation (Dialog(tab="Initialization", group="Evaporator"));
  parameter Modelica.Units.SI.Temperature TEvaCap_start=MediumEva.T_default
    "Initial temperature of heat capacity at evaporator" annotation (Dialog(
      tab="Initialization",
      group="Evaporator",
      enable=use_evaCap));
  parameter Modelica.Media.Interfaces.Types.MassFraction XEva_start[MediumEva.nX]=
     MediumEva.X_default "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", group="Evaporator"));

//Dynamics
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) 
    or steady state (only affects fluid-models)"
    annotation (Dialog(tab="Dynamics", group="Equation"));
//Advanced
  parameter Boolean from_dp=false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Dialog(tab="Advanced", group="Flow resistance"));
  parameter Boolean linearized=false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation (Dialog(tab="Advanced", group="Flow resistance"));
  parameter Real ySet_small=0.01
    "Value of ySet at which the device is considered turned on. 
    Default is 1 % as heat pumps and chillers currently invert down to 15 %."
    annotation (Dialog(tab="Advanced", group="Diagnostics"));
  IBPSA.Fluid.HeatExchangers.EvaporatorCondenserWithCapacity con(
    redeclare final package Medium = MediumCon,
    final allowFlowReversal=allowFlowReversalCon,
    final m_flow_small=1E-4*abs(mCon_flow_nominal),
    final show_T=show_T,
    final deltaM=deltaMCon,
    final tau=tauCon,
    final T_start=TCon_start,
    final p_start=pCon_start,
    final use_cap=use_conCap,
    final X_start=XCon_start,
    final from_dp=from_dp,
    final energyDynamics=energyDynamics,
    final is_con=true,
    final C=CCon*scaFac,
    final TCap_start=TConCap_start,
    final GOut=GConOut*scaFac,
    final m_flow_nominal=mCon_flow_nominal,
    final dp_nominal=dpCon_nominal*scaFac,
    final GInn=GConIns*scaFac) "Heat exchanger model for the condenser"
    annotation (Placement(transformation(extent={{-20,72},{20,112}})));
  IBPSA.Fluid.HeatExchangers.EvaporatorCondenserWithCapacity eva(
    redeclare final package Medium = MediumEva,
    final deltaM=deltaM_eva,
    final tau=tauEva,
    final use_cap=use_evaCap,
    final allowFlowReversal=allowFlowReversalEva,
    final m_flow_small=1E-4*abs(mEva_flow_nominal),
    final show_T=show_T,
    final T_start=TEva_start,
    final p_start=pEva_start,
    final X_start=XEva_start,
    final from_dp=from_dp,
    final energyDynamics=energyDynamics,
    final is_con=false,
    final C=CEva*scaFac,
    final m_flow_nominal=mEva_flow_nominal,
    final dp_nominal=dpEva_nominal*scaFac,
    final TCap_start=TEvaCap_start,
    final GOut=GEvaOut*scaFac,
    final GInn=GEvaIns*scaFac) "Heat exchanger model for the evaporator"
    annotation (Placement(transformation(extent={{20,-72},{-20,-112}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature varTempOutEva
 if use_evaCap "Foreces heat losses according to ambient temperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,-100})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature varTempOutCon
 if use_conCap "Foreces heat losses according to ambient temperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,110})));

  Modelica.Blocks.Interfaces.RealInput ySet
    if not use_busConnectorOnly and not use_TSet
    "Input signal speed for compressor relative between 0 and 1" annotation (Placement(
        transformation(extent={{-132,4},{-100,36}})));

  Modelica.Blocks.Interfaces.RealInput TEvaAmb(final unit="K", final
      displayUnit="degC") if use_evaCap and not use_busConnectorOnly
    "Ambient temperature on the evaporator side" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={110,-100})));
  Modelica.Blocks.Interfaces.RealInput TConAmb(final unit="K", final
      displayUnit="degC") if use_conCap and not use_busConnectorOnly
    "Ambient temperature on the condenser side" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={110,100})));

  Modelica.Blocks.Interfaces.RealInput TSet(final unit="K", final
      displayUnit="degC")
    if not use_busConnectorOnly and use_TSet
    "Input signal temperature for internal control"
    annotation (Placement(transformation(extent={{-132,24},{-100,56}})));
  Modelica.Blocks.Interfaces.BooleanInput onOffSet
    if not use_busConnectorOnly and use_TSet
    "Turn the device on (if internal temperature control is used)"
    annotation (Placement(transformation(extent={{-132,-36},{-100,-4}})));
  Modelica.Blocks.Interfaces.BooleanInput revSet
    if not use_busConnectorOnly and use_rev "Reverse the operation, =true for main operating mode"
    annotation (Placement(transformation(extent={{-132,-106},{-100,-74}})));

  IBPSA.Fluid.Sensors.MassFlowRate mFlow_eva(redeclare final package Medium =
        MediumEva, final allowFlowReversal=allowFlowReversalEva)
    "Mass flow sensor at the evaporator" annotation (Placement(transformation(
        origin={72,-60},
        extent={{10,-10},{-10,10}},
        rotation=0)));
  IBPSA.Fluid.Sensors.MassFlowRate mFlow_con(final allowFlowReversal=
        allowFlowReversalEva, redeclare final package Medium = MediumCon)
    "Mass flow sensor at the evaporator" annotation (Placement(transformation(
        origin={-50,92},
        extent={{-10,10},{10,-10}},
        rotation=0)));

  Modelica.Blocks.Logical.Hysteresis hys(
    final uLow=Modelica.Constants.eps,
    final uHigh=ySet_small,
    final pre_y_start=false) "Use default ySet value" annotation (Placement(
        transformation(extent={{10,-10},{-10,10}}, rotation=180,
        origin={-50,-50})));

  VapourCompressionCycleInertia vapComIneCon "Inertia model for condenser side"
                         annotation(Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,50})));
  VapourCompressionCycleInertia vapComIneEva "Inertia model for evaporator side"
                         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-50})));

  SenTempInflow senTConIn(final y=MediumCon.temperature(MediumCon.setState_phX(
        port_a1.p,
        inStream(port_a1.h_outflow),
        inStream(port_a1.Xi_outflow))))
    "Real expression for condenser inlet temperature" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,90})));
  SenTempInflow senTEvaIn(final y=MediumEva.temperature(MediumEva.setState_phX(
        port_a2.p,
        inStream(port_a2.h_outflow),
        inStream(port_a2.Xi_outflow))))
    "Real expression for evaporator inlet temperature" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,-40})));

// Line to delete if you don't want to use the bus externally
  Modelica.Blocks.Sources.BooleanConstant conRevSetTrue(final k=true) if not
    use_busConnectorOnly and not use_rev and not use_internalSafetyControl
    "Set revert mode to true" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,-110})));
protected
  Interfaces.VapourCompressionMachineControlBus sigBus
    "Bus with signal for device control" annotation (
          Placement(transformation(extent={{-120,-60},{-90,-26}}),
        iconTransformation(extent={{-108,-52},{-90,-26}})));

  parameter Boolean use_busConnectorOnly=false
    "=true to use bus connector for model inputs (revSet, ySet, TSet, onOffSet).
    =false to use the bus connector for outputs only. 
    Only possible if no internal safety control is used"
    annotation(choices(checkBox=true), Dialog(group="Input Connectors", enable=not
          use_internalSafetyControl));

// Line to add if you want to use the bus
//protected
  parameter Real scaFac "Scaling-factor of vapour compression machine";
  parameter MediumCon.ThermodynamicState staCon_nominal=MediumCon.setState_pTX(
      T=MediumCon.T_default, p=MediumCon.p_default, X=MediumCon.X_default)
      "Nominal / default state of condenser medium";

  parameter MediumEva.ThermodynamicState staEva_nominal=MediumEva.setState_pTX(
      T=MediumEva.T_default, p=MediumEva.p_default, X=MediumEva.X_default)
      "Nominal / default state of evaporator medium";

equation
  // Non bus connections
  connect(TConAmb, varTempOutCon.T) annotation (Line(
      points={{110,100},{88,100},{88,110},{82,110}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(varTempOutCon.port, con.port_out) annotation (Line(
      points={{60,110},{40,110},{40,118},{0,118},{0,112}},
      color={191,0,0},
      pattern=LinePattern.Dash));
  connect(TEvaAmb, varTempOutEva.T) annotation (Line(
      points={{110,-100},{82,-100}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(eva.port_out, varTempOutEva.port) annotation (Line(
      points={{0,-112},{0,-118},{54,-118},{54,-100},{60,-100}},
      color={191,0,0},
      pattern=LinePattern.Dash));
  connect(port_b2, port_b2) annotation (Line(points={{-100,-60},{-100,-60},{-100,
          -60}}, color={0,127,255}));
  connect(mFlow_eva.port_a, port_a2)
    annotation (Line(points={{82,-60},{100,-60}}, color={0,127,255}));
  connect(port_a1, mFlow_con.port_a)
    annotation (Line(points={{-100,60},{-68,60},{-68,92},{-60,92}},
                                                  color={0,127,255}));
  connect(mFlow_eva.port_b, eva.port_a) annotation (Line(points={{62,-60},{32,-60},
          {32,-92},{20,-92}}, color={0,127,255}));
  connect(eva.port_b, port_b2) annotation (Line(points={{-20,-92},{-70,-92},{-70,
          -60},{-100,-60}}, color={0,127,255}));
  connect(vapComCyc.QEva_flow, vapComIneEva.u) annotation (Line(points={{-1.22125e-15,
          -19.8},{-1.22125e-15,-28.9},{2.22045e-15,-28.9},{2.22045e-15,-38}},
        color={0,0,127}));
  connect(eva.Q_flow, vapComIneEva.y) annotation (Line(points={{2.22045e-16,-68},
          {2.22045e-16,-65.9},{-1.9984e-15,-65.9},{-1.9984e-15,-61}}, color={0,0,
          127}));
  connect(vapComIneCon.y, con.Q_flow) annotation (Line(points={{7.21645e-16,61},
          {7.21645e-16,69.9},{-2.22045e-16,69.9},{-2.22045e-16,68}}, color={0,0,
          127}));
  connect(vapComIneCon.u, vapComCyc.QCon_flow) annotation (Line(points={{-6.66134e-16,
          38},{-6.66134e-16,28.9},{1.22125e-15,28.9},{1.22125e-15,19.8}}, color=
         {0,0,127}));
  connect(mFlow_con.port_b, con.port_a)
    annotation (Line(points={{-40,92},{-20,92}}, color={0,127,255}));
  connect(con.port_b, port_b1) annotation (Line(points={{20,92},{78,92},{78,60},
          {100,60}}, color={0,127,255}));
  // External bus connections
  connect(mFlow_eva.m_flow, sigBus.m_flowEvaMea) annotation (Line(points={{72,-49},
          {72,-40},{26,-40},{26,-30},{-30,-30},{-30,-66},{-76,-66},{-76,-43},{-105,
          -43}},                                                color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(mFlow_con.m_flow, sigBus.m_flowConMea) annotation (Line(points={{-50,81},
          {-50,32},{-76,32},{-76,-43},{-105,-43}},
                                                 color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(vapComCyc.sigBus, sigBus) annotation (Line(
      points={{-18.54,0.18},{-30,0.18},{-30,-66},{-76,-66},{-76,-43},{-105,-43}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(vapComCyc.PEle, sigBus.PelMea) annotation (Line(points={{19.89,0.09},{
          26,0.09},{26,-30},{-30,-30},{-30,-66},{-76,-66},{-76,-43},{-105,-43}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(hys.y, sigBus.onOffMea) annotation (Line(points={{-39,-50},{-34,-50},{
          -34,-36},{-74,-36},{-74,-43},{-105,-43}},
                                           color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(varTempOutCon.T, sigBus.TConAmbMea) annotation (Line(
      points={{82,110},{88,110},{88,82},{38,82},{38,32},{-76,32},{-76,-43},{-105,
          -43}},
      color={0,0,127},
      pattern=LinePattern.Dash), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(varTempOutEva.T, sigBus.TEvaAmbMea) annotation (Line(
      points={{82,-100},{88,-100},{88,-118},{-76,-118},{-76,-43},{-105,-43}},
      color={0,0,127},
      pattern=LinePattern.Dash), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(hys.u, sigBus.ySet) annotation (Line(points={{-62,-50},{-74,-50},{-74,
          -43},{-105,-43}},
                       color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(con.T, sigBus.TConOutMea) annotation (Line(points={{22.4,82},{38,82},{
          38,32},{-76,32},{-76,-43},{-105,-43}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(senTConIn.y, sigBus.TConInMea) annotation (Line(points={{-79,90},{-72,
          90},{-72,32},{-76,32},{-76,-43},{-105,-43}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(eva.T, sigBus.TEvaOutMea) annotation (Line(points={{-22.4,-82},{-76,-82},
          {-76,-43},{-105,-43}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(senTEvaIn.y, sigBus.TEvaInMea) annotation (Line(points={{79,-40},{26,-40},
          {26,-30},{-30,-30},{-30,-66},{-76,-66},{-76,-43},{-105,-43}}, color={0,
          0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(conRevSetTrue.y, sigBus.revSet) annotation (Line(points={{-79,-110},{-78,
          -110},{-78,-112},{-76,-112},{-76,-43},{-105,-43}}, color={255,0,255}),
      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  if not use_internalSafetyControl then
    connect(ySet, sigBus.ySet) annotation (Line(points={{-116,20},{-80,20},{-80,-43},
          {-105,-43}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
    connect(revSet, sigBus.revSet) annotation (Line(points={{-116,-90},{-76,-90},
          {-76,-43},{-105,-43}}, color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  end if;
  /* // Internal bus connections --> No graphics required
  connect(mFlow_eva.m_flow, sigBusInt.m_flowEvaMea);
  connect(mFlow_con.m_flow, sigBusInt.m_flowConMea);
  connect(vapComCyc.sigBus, sigBusInt);
  connect(vapComCyc.PEle, sigBusInt.PelMea);
  connect(hys.y, sigBusInt.onOffMea);
  connect(varTempOutCon.T, sigBusInt.TConAmbMea);
  connect(varTempOutEva.T, sigBusInt.TEvaAmbMea);
  connect(hys.u, sigBusInt.ySet);
  connect(con.T, sigBusInt.TConOutMea);
  connect(senTConIn.y, sigBusInt.TConInMea);
  connect(eva.T, sigBusInt.TEvaOutMea);
  connect(senTEvaIn.y, sigBusInt.TEvaInMea);*/

  annotation (Icon(graphics={
        Rectangle(
          extent={{-16,83},{16,-83}},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0},
          origin={1,-64},
          rotation=90),
        Rectangle(
          extent={{-17,83},{17,-83}},
          fillColor={255,0,128},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0},
          origin={1,61},
          rotation=90),
        Line(
          points={{-9,40},{9,40},{-5,-2},{9,-40},{-9,-40}},
          color={0,0,0},
          smooth=Smooth.None,
          origin={-3,-60},
          rotation=-90),
        Line(
          points={{9,40},{-9,40},{5,-2},{-9,-40},{9,-40}},
          color={0,0,0},
          smooth=Smooth.None,
          origin={-5,56},
          rotation=-90),
        Rectangle(
          extent={{-82,42},{84,-46}},
          lineColor={238,46,47},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{-88,60},{88,60}}, color={28,108,200}),
        Line(points={{-88,-60},{88,-60}}, color={28,108,200}),
    Line(
    origin={-75.5,-80.333},
    points={{43.5,8.3333},{37.5,0.3333},{25.5,-1.667},{33.5,-9.667},{17.5,-11.667},{27.5,-21.667},{13.5,-23.667},
              {11.5,-31.667}},
      smooth=Smooth.Bezier,
      visible=use_evaCap),
        Polygon(
          points={{-70,-122},{-68,-108},{-58,-114},{-70,-122}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,0},
          visible=use_evaCap),
    Line( origin={40.5,93.667},
          points={{39.5,6.333},{37.5,0.3333},{25.5,-1.667},{33.5,-9.667},{17.5,
              -11.667},{27.5,-21.667},{13.5,-23.667},{11.5,-27.667}},
          smooth=Smooth.Bezier,
          visible=use_conCap),
        Polygon(
          points={{86,110},{84,96},{74,102},{86,110}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,0},
          visible=use_conCap),
        Line(
          points={{-42,72},{34,72}},
          color={0,0,0},
          arrow={Arrow.None,Arrow.Filled},
          thickness=0.5),
        Line(
          points={{-38,0},{38,0}},
          color={0,0,0},
          arrow={Arrow.None,Arrow.Filled},
          thickness=0.5,
          origin={0,-74},
          rotation=180)}),                Diagram(coordinateSystem(extent={{-100,
            -120},{100,120}})),
    Documentation(revisions="<html><ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    Adjusted based on the discussion in this issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
  <li>
    <i>May 22, 2019</i> by Julian Matthes:<br/>
    Rebuild due to the introducion of the thermal machine partial model
    (see issue <a href=
    \"https://github.com/RWTH-EBC/IBPSA/issues/715\">#715</a>)
  </li>
  <li>
    <i>November 26, 2018</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/IBPSA/issues/577\">#577</a>)
  </li>
</ul>
</html>", info="<html>
<p>This partial model for a generic grey-box vapour compression machine (heat pump or chiller) uses empirical data to model the refrigerant cycle. The modelling of system inertias and heat losses allow the simulation of transient states. </p>
<p>Resulting in the chosen model structure, several configurations are possible: </p>
<ol>
<li>Compressor type: on/off or inverter controlled </li>
<li>Reversible operation / only main operation </li>
<li>Source/Sink: Any combination of mediums is possible </li>
<li>Generik: Losses and inertias can be switched on or off. </li>
</ol>
<h4>Concept </h4>
<p>Using a signal bus as a connector, all relevant data is aggregated. In order to control both chillers and heat pumps, both flow and return temperature are aggregated. The revSet signal chooses the operation type of the vapour compression machine: </p>
<ul>
<li>mode = true: Main operation mode (heat pump: heating; chiller: cooling) </li>
<li>mode = false: Reversible operation mode (heat pump: cooling; chiller: heating) </li>
</ul>
<p>To model both on/off and inverter controlled vapour compression machines, the compressor speed is normalizd to a relative value between 0 and 1. </p>
<p>Possible icing of the evaporator is modelled with an input value between 0 and 1. </p>
<p>The model structure is as follows. To understand each submodel, please have a look at the corresponding model information: </p>
<ol>
<li><a href=\"IBPSA.Fluid.HeatPumps.BaseClasses.PartialBlackBoxVapourCompressionCycle\">IBPSA.Fluid.HeatPumps.BaseClasses.PartialBlackBoxVapourCompressionCycle</a> (Black-Box): Here, users can use between several input models or just easily create their own, modular black-box model. Please look at the model description for more info. </li>
<li><a href=\"IBPSA.Fluid.HeatPumps.BlackBoxData.VapourCompressionInertias\">IBPSA.Fluid.HeatPumps.BlackBoxData.VapourCompressionInertias</a>: An n-order element may be used (or other SISO models) model system inertias (mass and thermal) of components inside the refrigerant cycle (compressor, pipes, expansion valve) </li>
<li><a href=\"modelica://IBPSA.Fluid.HeatExchangers.EvaporatorCondenserWithCapacity\">IBPSA.Fluid.HeatExchangers.EvaporatorCondenserWithCapacity</a>: This new model also enable modelling of thermal interias and heat losses in a heat exchanger. Please look at the model description for more info. </li>
</ol>
<h4>Assumptions </h4>
<p>Several assumptions where made in order to model the vapour compression machine. For a detailed description see the corresponding model. </p>
<ol>
<li><b>Inertia</b>: The default value of the n-th order element is set to 3. This follows comparisons with experimental data. Previous heat pump models are using n = 1 as a default. However, it was pointed out that a higher order element fits a real heat pump better in </li>
<li><b>Scaling factor</b>: A scaling facor <span style=\"font-family: Courier New;\">scaFac</span> is implemented for scaling of the thermal power and capacity. The factor scales the parameters <span style=\"font-family: Courier New;\">V</span>, <span style=\"font-family: Courier New;\">m_flow_nominal</span>, <span style=\"font-family: Courier New;\">C</span>, <span style=\"font-family: Courier New;\">GIns</span>, <span style=\"font-family: Courier New;\">GOut</span> and <span style=\"font-family: Courier New;\">dp_nominal</span>. As a result, the vapour compression machine can supply more heat with the COP staying nearly constant. However, one has to make sure that the supplied pressure difference or mass flow is also scaled with this factor, as the nominal values do not increase said mass flow. </li>
</ol>
<h4>Known Limitations </h4>
<ul>
<li>Reversing the mode: A normal 4-way-exchange valve suffers from heat losses and irreversibilities due to switching from one mode to another. Theses losses are not taken into account. </li>
</ul>
</html>"));
end PartialReversibleVapourCompressionMachine;
