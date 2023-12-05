within IBPSA.Fluid.HeatPumps.ModularReversible.BaseClasses;
partial model PartialReversibleRefrigerantMachine
  "Model for reversible heat pumps and chillers with a refrigerant cycle"
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
    Modelica.Media.Interfaces.PartialMedium "Medium on condenser side"
    annotation (Dialog(tab = "Condenser"),choicesAllMatching=true);
  replaceable package MediumEva =
    Modelica.Media.Interfaces.PartialMedium "Medium on evaporator side"
    annotation (Dialog(tab = "Evaporator"),choicesAllMatching=true);
  replaceable PartialModularRefrigerantCycle refCyc constrainedby
    PartialModularRefrigerantCycle(final use_rev=use_rev)
    "Model of the refrigerant cycle" annotation (Placement(transformation(
          extent={{-18,-18},{18,18}}, rotation=90)));
  parameter Modelica.Units.SI.HeatFlowRate QUse_flow_nominal
    "Nominal heat flow rate at useful side of the device"
    annotation (Dialog(group="Nominal condition"));

  parameter Real y_nominal "Nominal relative compressor speed"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.HeatFlowRate PEle_nominal
    "Nominal electrical power consumption"
    annotation (Dialog(group="Nominal condition"));

  replaceable model RefrigerantCycleInertia =
     IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Inertias.NoInertia
    constrainedby
    IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Inertias.BaseClasses.PartialInertia
      "Inertia between the refrigerant cycle outputs and the heat exchangers."
    annotation (choicesAllMatching=true, Dialog(group="Inertia"));
  parameter Boolean use_rev=true
    "=true if the chiller or heat pump is reversible"
    annotation(choices(checkBox=true));
  parameter Boolean use_intSafCtr=true
    "=true to enable internal safety control"
    annotation (Dialog(group="Safety Control"), choices(checkBox=true));
  replaceable parameter
    IBPSA.Fluid.HeatPumps.ModularReversible.Controls.Safety.Data.Wuellhorst2021 safCtrPar
    constrainedby
    IBPSA.Fluid.HeatPumps.ModularReversible.Controls.Safety.Data.Generic
    "Safety control parameters" annotation (Dialog(enable=use_intSafCtr,
    group="Safety Control"),
      choicesAllMatching=true);
  //Condenser
  parameter Modelica.Units.SI.Time tauCon=30
    "Condenser heat transfer time constant at nominal flow"
    annotation (Dialog(tab="Condenser", group="Dynamics"));
  parameter Modelica.Units.SI.Temperature TCon_nominal
    "Nominal temperature of condenser medium"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.TemperatureDifference dTCon_nominal
    "Nominal temperature difference in condenser medium"
    annotation (Dialog(group="Nominal condition", tab="Condenser"));
  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal
    "Nominal mass flow rate of the condenser medium"
    annotation (Dialog(
      group="Nominal condition",
      tab="Condenser"));

  parameter Modelica.Units.SI.PressureDifference dpCon_nominal(displayUnit="Pa")
    "Pressure drop at nominal mass flow rate"
    annotation (Dialog(group="Flow resistance", tab="Condenser"));
  parameter Real deltaMCon=0.1
    "Fraction of nominal mass flow rate where transition to turbulent occurs"
    annotation (Dialog(tab="Condenser", group="Flow resistance"));
  parameter Boolean use_conCap=true
    "=true if using capacitor model for condenser heat loss estimation"
    annotation (Dialog(group="Heat Losses", tab="Condenser"),
                                          choices(checkBox=true));
  parameter Modelica.Units.SI.HeatCapacity CCon
    "Heat capacity of the condenser"
    annotation (Dialog(
      group="Heat Losses",
      tab="Condenser",
      enable=use_conCap));
  parameter Modelica.Units.SI.ThermalConductance GConOut
    "Outer thermal conductance for condenser heat loss calculations"
    annotation (Dialog(
      group="Heat Losses",
      tab="Condenser",
      enable=use_conCap));
  parameter Modelica.Units.SI.ThermalConductance GConIns
    "Inner thermal conductance for condenser heat loss calculations"
    annotation (Dialog(
      group="Heat Losses",
      tab="Condenser",
      enable=use_conCap));

  parameter Modelica.Units.SI.Density rhoCon=MediumCon.density(staCon_nominal)
    "Condenser medium density"
    annotation (Dialog(tab="Condenser", group="Medium properties"));
  parameter Modelica.Units.SI.SpecificHeatCapacity cpCon=
      MediumCon.specificHeatCapacityCp(staCon_nominal)
    "Condenser medium specific heat capacity"
    annotation (Dialog(tab="Condenser", group="Medium properties"));

  //Evaporator
  parameter Modelica.Units.SI.Time tauEva=30
    "Evaporator heat transfer time constant at nominal flow"
    annotation (Dialog(tab="Evaporator", group="Dynamics"));
  parameter Modelica.Units.SI.Temperature TEva_nominal
    "Nominal temperature of evaporator medium"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.TemperatureDifference dTEva_nominal
    "Nominal temperature difference in evaporator medium"
    annotation (Dialog(group="Nominal condition", tab="Evaporator"));
  parameter Modelica.Units.SI.MassFlowRate mEva_flow_nominal
    "Nominal mass flow rate of the evaporator medium"
    annotation (Dialog(
      group="Nominal condition",
      tab="Evaporator"));

  parameter Modelica.Units.SI.PressureDifference dpEva_nominal(displayUnit="Pa")
    "Pressure drop at nominal mass flow rate" annotation (Dialog(group="Flow resistance",
        tab="Evaporator"));
  parameter Real deltaMEva=0.1
    "Fraction of nominal mass flow rate where transition to turbulent occurs"
    annotation (Dialog(tab="Evaporator", group="Flow resistance"));
  parameter Boolean use_evaCap=true
    "=true if using capacitor model for evaporator heat loss estimation"
    annotation (Dialog(group="Heat Losses", tab="Evaporator"),
                                          choices(checkBox=true));
  parameter Modelica.Units.SI.HeatCapacity CEva
    "Heat capacity of the evaporator"
    annotation ( Dialog(
      group="Heat Losses",
      tab="Evaporator",
      enable=use_evaCap));
  parameter Modelica.Units.SI.ThermalConductance GEvaOut
    "Outer thermal conductance for evaporator heat loss calculations"
    annotation ( Dialog(
      group="Heat Losses",
      tab="Evaporator",
      enable=use_evaCap));
  parameter Modelica.Units.SI.ThermalConductance GEvaIns
    "Inner thermal conductance for evaporator heat loss calculations"
    annotation ( Dialog(
      group="Heat Losses",
      tab="Evaporator",
      enable=use_evaCap));
  parameter Modelica.Units.SI.Density rhoEva=MediumEva.density(staEva_nominal)
    "Evaporator medium density"
    annotation (Dialog(tab="Evaporator", group="Medium properties"));
  parameter Modelica.Units.SI.SpecificHeatCapacity cpEva=
      MediumEva.specificHeatCapacityCp(staEva_nominal)
    "Evaporator medium specific heat capacity"
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
    "Threshold for relative speed for the device to be considered on"
    annotation (Dialog(tab="Advanced", group="Diagnostics"));
  IBPSA.Fluid.HeatPumps.ModularReversible.BaseClasses.EvaporatorCondenserWithCapacity con(
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
    final isCon=true,
    final C=CCon,
    final TCap_start=TConCap_start,
    final GOut=GConOut,
    final m_flow_nominal=mCon_flow_nominal,
    final dp_nominal=dpCon_nominal,
    final GInn=GConIns) "Heat exchanger model for the condenser"
    annotation (Placement(transformation(extent={{-20,72},{20,112}})));
  IBPSA.Fluid.HeatPumps.ModularReversible.BaseClasses.EvaporatorCondenserWithCapacity eva(
    redeclare final package Medium = MediumEva,
    final deltaM=deltaMEva,
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
    final isCon=false,
    final C=CEva,
    final m_flow_nominal=mEva_flow_nominal,
    final dp_nominal=dpEva_nominal,
    final TCap_start=TEvaCap_start,
    final GOut=GEvaOut,
    final GInn=GEvaIns) "Heat exchanger model for the evaporator"
    annotation (Placement(transformation(extent={{20,-72},{-20,-112}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature varTOutEva
    if use_evaCap "Forces heat losses according to ambient temperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,-100})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature varTOutCon
    if use_conCap "Forces heat losses according to ambient temperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,110})));
  IBPSA.Fluid.HeatPumps.ModularReversible.Controls.Safety.Safety safCtr(
    final mEva_flow_nominal=mEva_flow_nominal,
    final mCon_flow_nominal=mCon_flow_nominal,
    safCtrPar=safCtrPar,
    final ySet_small=ySet_small) if use_intSafCtr "Safety control models"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Modelica.Blocks.Interfaces.RealInput ySet if not use_busConOnl
    "Relative compressor speed between 0 and 1" annotation (Placement(
        transformation(extent={{-132,4},{-100,36}})));

  Modelica.Blocks.Interfaces.RealInput TEvaAmb(final unit="K", final
      displayUnit="degC") if use_evaCap and not use_busConOnl
    "Ambient temperature on the evaporator side" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={110,-100})));
  Modelica.Blocks.Interfaces.RealInput TConAmb(final unit="K", final
      displayUnit="degC") if use_conCap and not use_busConOnl
    "Ambient temperature on the condenser side" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={110,100})));

  IBPSA.Fluid.Sensors.MassFlowRate mEva_flow(redeclare final package Medium =
        MediumEva, final allowFlowReversal=allowFlowReversalEva)
    "Mass flow sensor at the evaporator" annotation (Placement(transformation(
        origin={72,-60},
        extent={{10,-10},{-10,10}},
        rotation=0)));
  IBPSA.Fluid.Sensors.MassFlowRate mCon_flow(final allowFlowReversal=
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

  RefrigerantCycleInertia refCycIneCon "Inertia model for condenser side"
                         annotation(Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,50})));
  RefrigerantCycleInertia refCycIneEva "Inertia model for evaporator side"
                         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-50})));

  IBPSA.Fluid.HeatPumps.ModularReversible.BaseClasses.InflowTemperatureSensor senTConIn(
    final y=MediumCon.temperature(MediumCon.setState_phX(
        port_a1.p,
        inStream(port_a1.h_outflow),
        inStream(port_a1.Xi_outflow))))
    "Real expression for condenser inlet temperature" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,90})));
  IBPSA.Fluid.HeatPumps.ModularReversible.BaseClasses.InflowTemperatureSensor senTEvaIn(
    final y=MediumEva.temperature(MediumEva.setState_phX(
        port_a2.p,
        inStream(port_a2.h_outflow),
        inStream(port_a2.Xi_outflow))))
    "Real expression for evaporator inlet temperature" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,-40})));

// To avoid using the bus, set the section below to protected
// <!-- @include_Buildings @include_IDEAS @include_BuildingSystems
protected
// -->
  RefrigerantMachineControlBus sigBus
    "Bus with model outputs and possibly inputs" annotation (Placement(transformation(
          extent={{-120,-60},{-90,-26}}), iconTransformation(extent={{-108,-52},
            {-90,-26}})));

  parameter Boolean use_busConOnl=false
    "=true to allow input to bus connector,
    not applicable with internal safety control"
    annotation(choices(checkBox=true), Dialog(group="Input Connectors", enable=not
          use_intSafCtr));

// <!-- @include_AixLib
protected
// -->

  parameter Real scaFac "Scaling factor";
  parameter MediumCon.ThermodynamicState staCon_nominal=MediumCon.setState_pTX(
      T=MediumCon.T_default, p=MediumCon.p_default, X=MediumCon.X_default)
      "Nominal state of condenser medium";

  parameter MediumEva.ThermodynamicState staEva_nominal=MediumEva.setState_pTX(
      T=MediumEva.T_default, p=MediumEva.p_default, X=MediumEva.X_default)
      "Nominal state of evaporator medium";

equation

  // Non bus connections
  connect(safCtr.sigBus, sigBus) annotation (Line(
      points={{-59.9167,-16.0833},{-59.9167,-16},{-76,-16},{-76,-43},{-105,-43}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(safCtr.yOut, sigBus.ySet) annotation (Line(points={{-39.1667,-8.33333},
          {-30,-8.33333},{-30,-66},{-76,-66},{-76,-43},{-105,-43}},
                                                    color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(ySet, safCtr.ySet) annotation (Line(points={{-116,20},{-80,20},{-80,
          -8.33333},{-61.3333,-8.33333}},
                       color={0,0,127}));
  connect(TConAmb, varTOutCon.T) annotation (Line(
      points={{110,100},{88,100},{88,110},{82,110}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(varTOutCon.port, con.port_out) annotation (Line(
      points={{60,110},{40,110},{40,118},{0,118},{0,112}},
      color={191,0,0},
      pattern=LinePattern.Dash));
  connect(TEvaAmb, varTOutEva.T) annotation (Line(
      points={{110,-100},{82,-100}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(eva.port_out, varTOutEva.port) annotation (Line(
      points={{0,-112},{0,-118},{54,-118},{54,-100},{60,-100}},
      color={191,0,0},
      pattern=LinePattern.Dash));
  connect(port_b2, port_b2) annotation (Line(points={{-100,-60},{-100,-60}},
                 color={0,127,255}));
  connect(mEva_flow.port_a, port_a2)
    annotation (Line(points={{82,-60},{100,-60}}, color={0,127,255}));
  connect(port_a1,mCon_flow. port_a)
    annotation (Line(points={{-100,60},{-68,60},{-68,92},{-60,92}},
                                                  color={0,127,255}));
  connect(mEva_flow.port_b, eva.port_a) annotation (Line(points={{62,-60},{32,-60},
          {32,-92},{20,-92}}, color={0,127,255}));
  connect(eva.port_b, port_b2) annotation (Line(points={{-20,-92},{-70,-92},{-70,
          -60},{-100,-60}}, color={0,127,255}));
  connect(refCyc.QEva_flow, refCycIneEva.u) annotation (Line(points={{-1.22125e-15,
          -19.8},{-1.22125e-15,-28.9},{2.22045e-15,-28.9},{2.22045e-15,-38}},
        color={0,0,127}));
  connect(eva.Q_flow,refCycIneEva. y) annotation (Line(points={{2.22045e-16,-68},
          {2.22045e-16,-65.9},{-1.9984e-15,-65.9},{-1.9984e-15,-61}}, color={0,0,
          127}));
  connect(refCycIneCon.y, con.Q_flow) annotation (Line(points={{7.21645e-16,61},
          {7.21645e-16,69.9},{-2.22045e-16,69.9},{-2.22045e-16,68}}, color={0,0,
          127}));
  connect(refCycIneCon.u, refCyc.QCon_flow) annotation (Line(points={{-6.66134e-16,
          38},{-6.66134e-16,28.9},{1.22125e-15,28.9},{1.22125e-15,19.8}}, color=
         {0,0,127}));
  connect(mCon_flow.port_b, con.port_a)
    annotation (Line(points={{-40,92},{-20,92}}, color={0,127,255}));
  connect(con.port_b, port_b1) annotation (Line(points={{20,92},{78,92},{78,60},
          {100,60}}, color={0,127,255}));
  // External bus connections
  connect(mEva_flow.m_flow, sigBus.mEvaMea_flow) annotation (Line(points={{72,-49},
          {72,-40},{26,-40},{26,-30},{-30,-30},{-30,-66},{-76,-66},{-76,-43},{-105,
          -43}},                                                color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(mCon_flow.m_flow, sigBus.mConMea_flow) annotation (Line(points={{-50,81},
          {-50,32},{-76,32},{-76,-43},{-105,-43}},
                                                 color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(refCyc.sigBus, sigBus) annotation (Line(
      points={{-18.54,0.18},{-30,0.18},{-30,-66},{-76,-66},{-76,-43},{-105,-43}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));

  connect(refCyc.PEle, sigBus.PEleMea) annotation (Line(points={{19.89,0.09},{26,
          0.09},{26,-30},{-30,-30},{-30,-66},{-76,-66},{-76,-43},{-105,-43}},
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
  connect(varTOutCon.T, sigBus.TConAmbMea) annotation (Line(
      points={{82,110},{88,110},{88,82},{38,82},{38,32},{-76,32},{-76,-43},{-105,
          -43}},
      color={0,0,127},
      pattern=LinePattern.Dash), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(varTOutEva.T, sigBus.TEvaAmbMea) annotation (Line(
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
  if not use_intSafCtr then
    connect(ySet, sigBus.ySet) annotation (Line(points={{-116,20},{-80,20},{-80,-43},
          {-105,-43}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  end if;

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
<p>
  This partial model defines all components which are equally required
  for heat pump and chillers. This encompasses
</p>
<ul>
<li>the heat exchangers (evaporator and condenser),</li>
<li>sensors for temperature and mass flow rates,</li>
<li>the replaceable model for refrigerant inertia,</li>
<li>safety controls,</li>
<li>connectors and parameters,</li>
<li>and the replaceable refrigerant cycle model <code>refCyc</code></li>
</ul>
<p>
  The model <code>refCyc</code> is replaced in the ModularReversible
  model for heat pumps and chillers, e.g. by
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.BaseClasses.RefrigerantCycle\">
  IBPSA.Fluid.HeatPumps.ModularReversible.BaseClasses.RefrigerantCycle</a>
  in <a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.ModularReversible\">
  IBPSA.Fluid.HeatPumps.ModularReversible.ModularReversible</a>.
</p>
<p>
  For more information on the approach, please read the
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.ModularReversibleUsersGuide\">
  UsersGuide</a>.
</p>
</html>"));
end PartialReversibleRefrigerantMachine;
