within IDEAS.Airflow.VentilationUnit;
model Adsolair58 "Menerga Adsolair type 58 air handling unit"
  extends IDEAS.Fluid.Interfaces.LumpedVolumeDeclarations(redeclare final
      package Medium =
      MediumAir);
  replaceable package MediumAir =
      IDEAS.Media.Air annotation (
      __Dymola_choicesAllMatching=true);
  replaceable package MediumHeating =
      IDEAS.Media.Water
    annotation (__Dymola_choicesAllMatching=true);
  replaceable parameter IDEAS.Airflow.VentilationUnit.BaseClasses.Adsolair14200
    adsolairData constrainedby
    IDEAS.Airflow.VentilationUnit.BaseClasses.AdsolairData annotation (
      choicesAllMatching=true, Placement(transformation(extent={{-138,82},{-122,
            98}})));

  //PARAMETERS
  parameter Boolean use_onOffSignal = true
    "Set to true to switch device on/off using external signal";
  parameter Boolean onOff=true "Set to true if device is on"
  annotation (Dialog(enable= not use_onOffSignal));
  final parameter Boolean allowFlowReversal=false
    "Flow reversal is not supported"
    annotation(Dialog(tab="Advanced"));
  parameter Modelica.SIunits.MassFlowRate m_flow_small=adsolairData.m_flow_nominal1/50
    "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab="Advanced"));
  parameter Modelica.SIunits.Time tau=60
    "Thermal time constant at nominal flow rate";
  parameter Modelica.SIunits.Pressure dp_fouling_top=0
    "Nominal pressure drop in top channel due to filter fouling";
  parameter Modelica.SIunits.Pressure dp_fouling_bot=0
    "Nominal pressure drop in bottom channel due to filter fouling";
  parameter Real alpha = 0.5
    "Pressure recovery factor for fixed pressure drop in bottom bypass channel";
  parameter Boolean use_eNTU=true "Use NTU method for efficiency calculation";
  parameter Real k1=0.45
    "Flow coefficient for y=1, k1 = pressure drop divided by dynamic pressure";

  //EQUATIONS
  Modelica.SIunits.Energy E=adCrFlHe.E+evaporator.U + condensor.U;
  Real BPF=min(1,max(0,IDEAS.Utilities.Math.Functions.spliceFunction(
         x=abs(adCrFlHe.T_out_bot - evaporator.heatPort.T)-0.2,
         pos=(evaporator.heatPort.T - simpleCompressor.Teva)*IDEAS.Utilities.Math.Functions.inverseXRegularized(x=adCrFlHe.T_out_bot-simpleCompressor.Teva, delta=0.1),
         neg=1,
         deltax=0.1))) "Fraction of air that is bypassed in the evaporator";
  Real X_sat_evap = IDEAS.Utilities.Psychrometrics.Functions.X_pSatpphi(
     pSat=IDEAS.Media.Air.saturationPressure(simpleCompressor.Teva), p=evaporator.ports[1].p, phi=1)
    "Water fraction at saturation in evaporator at refrigerant temperature";
  Real x_out = BPF*adCrFlHe.port_b2.Xi_outflow[1] + (1-BPF)*min(X_sat_evap,adCrFlHe.port_b2.Xi_outflow[1])
    "Outlet water mass fraction based on BPF";
  Boolean onAdia = on_internal and Tset < T_fresh_in.T and (pre(onAdia) or Tset<adCrFlHe.T_out_bot)
    "Hysteresis implementation for switching adiabatic cooling on or off";
  Boolean onComp = on_internal and onDelAdi.y and Tset < adCrFlHe.T_out_bot and (pre(onComp) or Tset+0.1<adCrFlHe.T_out_bot)
    "Hysteresis implementation for switching the compressor on or off";
  Modelica.SIunits.MassFlowRate m_condens = adCrFlHe.port_a2.m_flow * (adCrFlHe.port_b2.Xi_outflow[1]-x_out)
    "Water condensation mass flow rate in the evaporator.";

  // PORTS
  Modelica.Blocks.Interfaces.BooleanInput on if use_onOffSignal annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-20,108})));
  Modelica.Fluid.Interfaces.FluidPort_a extractedAir(
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    redeclare package Medium = MediumAir)
    annotation (Placement(transformation(extent={{-150,10},{-130,30}})));
  Modelica.Fluid.Interfaces.FluidPort_b injectedAir(
    m_flow(max=if allowFlowReversal then Modelica.Constants.inf else 0),
    redeclare package Medium = MediumAir)
    annotation (Placement(transformation(extent={{-150,-30},{-130,-10}})));
  Modelica.Fluid.Interfaces.FluidPort_a freshAir(
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    redeclare package Medium = MediumAir)
    annotation (Placement(transformation(extent={{90,-36},{110,-16}})));
  Modelica.Fluid.Interfaces.FluidPort_b dumpedAir(
    m_flow(max=if allowFlowReversal then Modelica.Constants.inf else 0),
    redeclare package Medium = MediumAir) annotation (Placement(transformation(extent={{90,10},{110,30}})));
  Modelica.Fluid.Interfaces.FluidPort_b heatingOut(
    m_flow(max=if allowFlowReversal then Modelica.Constants.inf else 0),
    redeclare package Medium = MediumHeating)
    annotation (Placement(transformation(extent={{-100,-110},{-80,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_a heatingIn(
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    redeclare package Medium = MediumHeating)
    annotation (Placement(transformation(extent={{-138,-110},{-118,-90}})));
  Modelica.Blocks.Interfaces.RealInput Tset "Setpoints of the valves"
    annotation (Placement(transformation(
        extent={{14,-14},{-14,14}},
        rotation=270,
        origin={8,-102}),  iconTransformation(
        extent={{-14,-14},{14,14}},
        rotation=270,
        origin={60,102})));
  Modelica.Blocks.Interfaces.RealInput[2] dpSet
    "Top and bottom fan pressure set points" annotation (Placement(
        transformation(
        extent={{14,-14},{-14,14}},
        rotation=90,
        origin={-38,104}), iconTransformation(
        extent={{-14,-14},{14,14}},
        rotation=270,
        origin={20,102})));
  Modelica.Blocks.Interfaces.RealOutput P
    annotation (Placement(transformation(extent={{96,80},{116,100}})));
  Modelica.Blocks.Interfaces.RealOutput yValve
    "Control signal for external 3way valve"
    annotation (Placement(transformation(extent={{96,-102},{116,-82}})));
    //COMPONENTS
  IDEAS.Fluid.HeatExchangers.ConstantEffectiveness heater(
    redeclare package Medium1 = MediumAir,
    redeclare package Medium2 = MediumHeating,
    m1_flow_nominal=adsolairData.m1_flow_nominal_heater,
    m2_flow_nominal=adsolairData.m2_flow_nominal_heater,
    eps=adsolairData.epsHeating,
    dp2_nominal=adsolairData.dp2_nominal_heater,
    dp1_nominal=0,
    allowFlowReversal1=allowFlowReversal,
    allowFlowReversal2=false) "Heat exchanger"
    annotation (Placement(transformation(extent={{-100,-36},{-120,-16}})));
  IDEAS.Fluid.HeatExchangers.IndirectEvaporativeHex adCrFlHe(
    p1_start=p_start,
    T1_start=T_start,
    X1_start=X_start,
    C1_start=C_start,
    C1_nominal=C_nominal,
    p2_start=p_start,
    T2_start=T_start,
    X2_start=X_start,
    C2_start=C_start,
    C2_nominal=C_nominal,
    m_flow_small=m_flow_small,
    redeclare package Medium1 = MediumAir,
    redeclare package Medium2 = MediumAir,
    m1_flow_nominal=adsolairData.m_flow_nominal1,
    m2_flow_nominal=adsolairData.m_flow_nominal2,
    eps_adia_on=adsolairData.eps_adia_on,
    eps_adia_off=adsolairData.eps_adia_off,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    use_eNTU=use_eNTU,
    tau=tau)
            annotation (Placement(transformation(extent={{-4,-38},{58,20}})));
  IDEAS.Fluid.MixingVolumes.MixingVolume condensor(
    nPorts=2,
    redeclare package Medium = MediumAir,
    m_flow_nominal=adsolairData.m_flow_nominal1,
    mSenFac=mSenFac,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_small=m_flow_small,
    allowFlowReversal=allowFlowReversal,
    p_start=p_start,
    T_start=T_start,
    X_start=X_start,
    C_start=C_start,
    C_nominal=C_nominal,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    V=adsolairData.m_flow_nominal1/rho_default*tau)
           annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=90,
        origin={65,35})));
  IDEAS.Fluid.Movers.FlowControlled_dp fanTop(
    redeclare package Medium = MediumAir,
    allowFlowReversal=allowFlowReversal,
    p_start=p_start,
    T_start=T_start,
    X_start=X_start,
    C_start=C_start,
    C_nominal=C_nominal,
    addPowerToMedium=true,
    per(
      speed_rpm_nominal=adsolairData.speed_rpm_nominal,
      hydraulicEfficiency=adsolairData.hydraulicEfficiency,
      motorEfficiency=adsolairData.motorEfficiency,
      power=adsolairData.power,
      use_powerCharacteristic=adsolairData.use_powerCharacteristic,
      pressure=adsolairData.pressure),
    init=Modelica.Blocks.Types.Init.NoInit,
    m_flow_small=adsolairData.m_flow_nominal1/50,
    riseTime=600,
    filteredSpeed=false,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=adsolairData.m_flow_nominal1) "Top fan"
    annotation (Placement(transformation(extent={{-70,10},{-50,30}})));
  IDEAS.Fluid.MixingVolumes.MixingVolumeMoistAir evaporator(
    redeclare package Medium = MediumAir,
    m_flow_nominal=adsolairData.m_flow_nominal2,
    mSenFac=mSenFac,
    m_flow_small=m_flow_small,
    allowFlowReversal=allowFlowReversal,
    p_start=p_start,
    T_start=T_start,
    X_start=X_start,
    C_start=C_start,
    C_nominal=C_nominal,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    nPorts=2,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    V=adsolairData.m_flow_nominal2/rho_default*tau)
               annotation (Placement(transformation(
        extent={{-8,-8},{8,8}},
        rotation=180,
        origin={-4,-52})));
  IDEAS.Fluid.Movers.FlowControlled_dp fanBot(
    redeclare package Medium = MediumAir,
    p_start=p_start,
    T_start=T_start,
    X_start=X_start,
    C_start=C_start,
    C_nominal=C_nominal,
    allowFlowReversal=allowFlowReversal,
    addPowerToMedium=true,
    per(
      speed_rpm_nominal=adsolairData.speed_rpm_nominal,
      motorEfficiency=adsolairData.motorEfficiency,
      hydraulicEfficiency=adsolairData.hydraulicEfficiency,
      power=adsolairData.power,
      use_powerCharacteristic=adsolairData.use_powerCharacteristic,
      pressure=adsolairData.pressure),
    init=Modelica.Blocks.Types.Init.NoInit,
    m_flow_small=adsolairData.m_flow_nominal2/50,
    riseTime=600,
    filteredSpeed=false,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=adsolairData.m_flow_nominal2) "Bottom fan"
    annotation (Placement(transformation(extent={{-50,-30},{-70,-10}})));
  IDEAS.Airflow.VentilationUnit.BaseClasses.SimpleCompressorTable
    simpleCompressor(fraPmin=adsolairData.fraPmin, C=tau/4*adsolairData.G_condensor)
                                                   annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={32,42})));
  Modelica.Blocks.Math.Sum sum(nin=5) "Total electrical power consumption"
    annotation (Placement(transformation(extent={{78,82},{94,98}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort T_fresh_in(
    redeclare package Medium = MediumAir,
    m_flow_nominal=adsolairData.m_flow_nominal2,
    T_start=293,
    allowFlowReversal=allowFlowReversal,
    tau=0) "Fresh inlet air temperature"
    annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={28,-68})));
  Modelica.Blocks.Sources.RealExpression m_condens_exp(y=-m_condens)
    "Real expression for setting water condensation mass flow rate"
    annotation (Placement(transformation(extent={{54,-48},{34,-68}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTemEva
    "Temperatuer sensor of evaporator"
    annotation (Placement(transformation(extent={{16,-52},{32,-36}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor conCon(G=
        adsolairData.G_condensor)
    "Conductor describing the temperature drop in the condensor" annotation (
      Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=0,
        origin={50,42})));
  Modelica.Blocks.Sources.RealExpression fan_flow_set[2](y=if on_internal then
        dpSet + {-dumpedAir.p + fanTop.port_b.p,-fanBot.port_a.p + freshAir.p}
         else {0.1,0.1}) "Fan flow set points"
    annotation (Placement(transformation(extent={{-140,42},{-72,28}})));
  Modelica.Blocks.Sources.BooleanExpression onAdiaExp(y=onAdia)
    "Expression for outputting onAdia"
    annotation (Placement(transformation(extent={{120,-6},{100,6}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductionFanTop(G=1)
    "Thermal losses in top fan: needed for avoiding singularity when mass flow rate is zero"
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-86,6})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=
        273.15 + 20)
    annotation (Placement(transformation(extent={{-112,0},{-100,12}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductionfanBot(G=1)
    "Thermal losses in top fan: needed for avoiding singularity when mass flow rate is zero"
    annotation (Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=0,
        origin={-86,-6})));
  Modelica.Blocks.Interfaces.RealOutput TrecupPul
    "Temperature of pulsion stream before heating battery"
    annotation (Placement(transformation(extent={{96,-82},{116,-62}})));
  Modelica.Blocks.Sources.BooleanExpression piHeaterOn(y=on_internal and not
        onAdiaExp.y and not onCompExp.y and (damPid.y > 0.97 or damPid.y < 0.03))
    "Enable PI controllers"
    annotation (Placement(transformation(extent={{0,-90},{40,-74}})));
  IDEAS.Fluid.FixedResistances.FixedResistanceDpM resTop(
    allowFlowReversal=allowFlowReversal,
    m_flow_nominal=adsolairData.m_flow_nominal1,
    redeclare package Medium = MediumAir,
    from_dp=false,
    dp_nominal=adsolairData.dp_nominal_top + dp_fouling_top)
    "Top pressure drop component"
    annotation (Placement(transformation(extent={{-40,30},{-20,10}})));
  IDEAS.Fluid.FixedResistances.FixedResistanceDpM resBot(
    allowFlowReversal=allowFlowReversal,
    redeclare package Medium = MediumAir,
    m_flow_nominal=adsolairData.m_flow_nominal2,
    from_dp=false,
    dp_nominal=adsolairData.dp_nominal_bottom + dp_fouling_bot)
    "Bottom pressure drop component"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-30,-20})));
  TwoWayEqualPercentageAdd                  valBypassBottom(
    redeclare package Medium = MediumAir,
    m_flow_nominal=adsolairData.m_flow_nominal2,
    allowFlowReversal=allowFlowReversal,
    filteredOpening=false,
    from_dp=true,
    l=0.001,
    dpAdd=1,
    A=adsolairData.A_dam_byp_bot,
    dpFixed_nominal=(1 - alpha)*(adsolairData.m_flow_nominal2/(adsolairData.A_byp_bot_min))
        ^2/rho_default/2,
    k1=k1)
    annotation (Placement(transformation(extent={{88,-76},{72,-60}})));
  TwoWayEqualPercentageAdd                  valRecupBot(
    redeclare package Medium = MediumAir,
    m_flow_nominal=adsolairData.m_flow_nominal2,
    dpFixed_nominal=adsolairData.dp_nominal_bottom_recup,
    allowFlowReversal=allowFlowReversal,
    filteredOpening=false,
    from_dp=true,
    l=0.001,
    dpAdd=1,
    A=adsolairData.A_dam_rec_bot,
    k1=k1)
    annotation (Placement(transformation(extent={{88,-34},{72,-18}})));
  Modelica.Blocks.Sources.RealExpression bypassBoty(y=if on_internal then (if
        onComp then 0 else min(2 - 2*damPid.y, 1)) else 0)
    annotation (Placement(transformation(extent={{166,-46},{114,-34}})));
  Modelica.Blocks.Sources.RealExpression recupBoty(y=if on_internal then (if
        onComp then 1 else min(2*damPid.y, 1)) else 0)
    annotation (Placement(transformation(extent={{166,-16},{114,-4}})));
  TwoWayEqualPercentageAdd                  valBypassTop(
    redeclare package Medium = MediumAir,
    allowFlowReversal=allowFlowReversal,
    filteredOpening=false,
    from_dp=true,
    l=0.001,
    m_flow_nominal=adsolairData.m_flow_nominal1,
    dpAdd=1,
    dpFixed_nominal=(adsolairData.m_flow_nominal1/adsolairData.A_byp_top_min)^2
        /rho_default/2,
    A=adsolairData.A_dam_byp_top,
    k1=k1)
    annotation (Placement(transformation(extent={{78,58},{94,74}})));
  TwoWayEqualPercentageAdd                  valRecupTop(
    redeclare package Medium = MediumAir,
    m_flow_nominal=adsolairData.m_flow_nominal2,
    dpFixed_nominal=adsolairData.dp_nominal_top_recup,
    allowFlowReversal=allowFlowReversal,
    filteredOpening=false,
    from_dp=true,
    l=0.001,
    dpAdd=adsolairData.dp_adiabatic,
    A=adsolairData.A_dam_rec_top,
    k1=k1)
    annotation (Placement(transformation(extent={{78,36},{94,52}})));
  Modelica.Blocks.Sources.RealExpression bypassTopy(y=if not onAdia and
        on_internal and not onComp then 1 -damPid.y  else 0)
    annotation (Placement(transformation(extent={{156,70},{116,80}})));
  Modelica.Blocks.Sources.RealExpression recupTopy(y=if on_internal then 1
         else 0)
    annotation (Placement(transformation(extent={{154,60},{114,48}})));
  Solarwind.Controls.SolarwindComponents.BaseClasses.LimPIDAdvanced comPid(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti=180,
    yMax=1,
    yMin=0,
    Bp=10,
    revActPar=true,
    use_onOffSignal=true,
    yOutOff=0.6,
    sat=0.02) "Pi controller for compressor"
    annotation (Placement(transformation(extent={{4,48},{14,58}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort T_heater_in(
    redeclare package Medium = MediumAir,
    m_flow_nominal=adsolairData.m_flow_nominal2,
    tau=tau,
    transferHeat=true,
    TAmb=fixedTemperature.T,
    tauHeaTra=3600,
    allowFlowReversal=allowFlowReversal) "Inlet temperature of the heater"
                                               annotation (Placement(
        transformation(
        extent={{-6,6},{6,-6}},
        rotation=180,
        origin={-86,-20})));
  Solarwind.Controls.SolarwindComponents.BaseClasses.LimPIDAdvanced heaPid(
    Td=0,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    yMin=0,
    yMax=1,
    use_onOffSignal=true,
    sat=0.2,
    Bp=5,
    yOutOff=0,
    useDerYLimit=true,
    derYMaxConst=true,
    derYMinConst=true,
    derYmaxyVals={0.03},
    derYminyVals={-0.03},
    Ti=120) "PI controller for heating coil valve"
    annotation (Placement(transformation(extent={{42,-98},{54,-86}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort T_heater_out(
    redeclare package Medium = MediumAir,
    m_flow_nominal=adsolairData.m_flow_nominal2,
    tau=tau,
    transferHeat=true,
    tauHeaTra=3600,
    TAmb=fixedTemperature.T,
    allowFlowReversal=allowFlowReversal) "Inlet temperature of the heater"
                                               annotation (Placement(
        transformation(
        extent={{-6,6},{6,-6}},
        rotation=180,
        origin={-128,-20})));
  Modelica.Blocks.Sources.BooleanExpression onCompExp(y=onComp)
    "On signal for compressor and its PI controller"
    annotation (Placement(transformation(extent={{-20,74},{0,92}})));
model TwoWayEqualPercentageAdd
    "Damper with possibility for adding fixed pressure drop using boolean input"
  extends IDEAS.Fluid.Actuators.BaseClasses.PartialTwoWayValveKv(
    dpValve_nominal= k1^2*m_flow_nominal^2/2/Medium.density(sta_default)/A^2,
    phi=sqrt(1/(1/((l+(1-l)*(c*{y_actual^3, y_actual^2, y_actual}))^2) + (if addPreDro then 1/yAdd^2 else 0))));
  parameter Modelica.SIunits.Pressure dpAdd
      "Additional pressure drop when addPreDro is true";
  parameter Real k1(min=0)= 0.45
      "Flow coefficient for y=1, k1 = pressure drop divided by dynamic pressure"
  annotation(Dialog(tab="Damper coefficients"));
  parameter Modelica.SIunits.Area A "Damper face area";
  Modelica.Blocks.Interfaces.BooleanInput addPreDro
      "Add additional pressure drop"
                                   annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-40,106})));
  protected
  constant Real[3] c= {0.582675,0.222823,0.192212}
      "Polynomial coefficients for pressure drop curve based on ASHRAE fundamentals, 2009, P134, fig 13B, A=1";
  parameter Medium.Density rho_default=Medium.density(sta_default)
      "Density, used to compute fluid volume";
  parameter Real yAdd(unit="", min=0) = if dpAdd > Modelica.Constants.eps
    then m_flow_nominal / sqrt(dpAdd)/Kv_SI else 9999999;
initial equation
  // Since the flow model IDEAS.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow computes
  // 1/k^2, the parameter l must not be zero.
  assert(l > 0, "Valve leakage parameter l must be bigger than zero.");
  annotation (
    defaultComponentName="val",
    Documentation(info=""), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Text(
          extent={{-74,20},{-36,-24}},
          lineColor={255,255,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="%%")}));
end TwoWayEqualPercentageAdd;
protected
  final parameter Modelica.SIunits.Density rho_default=MediumAir.density(
     MediumAir.setState_pTX(
      T=MediumAir.T_default,
      p=MediumAir.p_default,
      X=MediumAir.X_default[1:MediumAir.nXi]))
    "Density, used to compute condensor/evaporator volume";
public
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theConEva(G=100)
    "Required for simulating heat losses in evaporator" annotation (Placement(
        transformation(
        extent={{-6,6},{6,-6}},
        rotation=0,
        origin={-70,0})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theConCon(G=100)
    "Required for simulating heat losses in condenser" annotation (Placement(
        transformation(
        extent={{-6,6},{6,-6}},
        rotation=0,
        origin={-70,10})));
  Modelica.Blocks.MathBoolean.OnDelay onDelAdi(delayTime=5*tau)
    "On delay before compressor may be activated"
    annotation (Placement(transformation(extent={{94,4},{86,12}})));
  Solarwind.Controls.SolarwindComponents.BaseClasses.LimPIDAdvanced damPid(
    useBpInput=true,
    useyMinInput=false,
    useyMaxInput=false,
    use_onOffSignal=true,
    useRevActIn=true,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti=120,
    yMax=1,
    yMin=0,
    sat=0.5,
    initType=Modelica.Blocks.Types.InitPID.InitialState,
    yOutOff=0) "PI controller for dampers"
    annotation (Placement(transformation(extent={{-38,60},{-28,70}})));
  Modelica.Blocks.Math.Add add(k1=-1, k2=+1)
    annotation (Placement(transformation(extent={{-70,60},{-60,70}})));
  Modelica.Blocks.Math.Abs abs1
    annotation (Placement(transformation(extent={{-56,60},{-46,70}})));
  Modelica.Blocks.Sources.BooleanExpression revAct(y=onAdia or onComp or
        adCrFlHe.T_out_bot < T_fresh_in.T)
    annotation (Placement(transformation(extent={{-86,70},{-46,90}})));
  Modelica.Blocks.Sources.RealExpression PPum(y=if onAdiaExp.y then 770 else 0)
    "Electrical power consumption of circulation pump"
    annotation (Placement(transformation(extent={{40,98},{60,78}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(final k=false)
    "Only valRecupTop has conditional Kv value"
    annotation (Placement(transformation(extent={{50,70},{60,80}})));
  Modelica.Blocks.Sources.RealExpression PUnit(y=if on_internal then 780 else 150)
    "Remaing electrical power consumption from unit"
    annotation (Placement(transformation(extent={{40,86},{60,106}})));
  Modelica.Blocks.Sources.BooleanExpression piValOn(y=on_internal)
    "Enable PI controllers"
    annotation (Placement(transformation(extent={{-86,84},{-66,100}})));
protected
  Modelica.Blocks.Interfaces.BooleanInput on_internal
    "Needed to connect to conditional connector";
equation
  connect(on,on_internal);
  if not use_onOffSignal then
    on_internal=onOff;
  end if;
  connect(heatingOut, heater.port_b2) annotation (Line(
      points={{-90,-100},{-90,-32},{-100,-32}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heater.port_a2, heatingIn) annotation (Line(
      points={{-120,-32},{-128,-32},{-128,-100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sum.y, P) annotation (Line(
      points={{94.8,90},{106,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_condens_exp.y, evaporator.mWat_flow) annotation (Line(
      points={{33,-58},{14,-58},{14,-58.4},{5.6,-58.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senTemEva.port, evaporator.heatPort) annotation (Line(
      points={{16,-44},{16,-52},{4,-52}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(simpleCompressor.port_b, conCon.port_a) annotation (Line(
      points={{42,42},{44,42}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conCon.port_b, condensor.heatPort) annotation (Line(
      points={{56,42},{65,42}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fanTop.P, sum.u[2]) annotation (Line(
      points={{-49,28},{-58,28},{-58,76},{76.4,76},{76.4,89.36}},
      color={0,0,127},
      smooth=Smooth.None,
      visible=false));
  connect(fanBot.P, sum.u[3]) annotation (Line(
      points={{-71,-12},{-72,-12},{-72,-8},{-78,-8},{-78,90},{76.4,90}},
      color={0,0,127},
      smooth=Smooth.None,
      visible=false));
  connect(simpleCompressor.P, sum.u[4]) annotation (Line(
      points={{40,51.8},{26,51.8},{26,90.64},{76.4,90.64}},
      color={0,0,127},
      visible=false));
  connect(fixedTemperature.port, thermalConductionFanTop.port_a) annotation (
      Line(
      points={{-100,6},{-92,6}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalConductionFanTop.port_b, fanTop.heatPort) annotation (Line(
      points={{-80,6},{-60,6},{-60,13.2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalConductionfanBot.port_b, fanBot.heatPort) annotation (Line(
      points={{-80,-6},{-80,-6},{-76,-6},{-76,-26},{-68,-26},{-68,-26.8},{-60,-26.8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fanTop.port_b, resTop.port_a) annotation (Line(
      points={{-50,20},{-40,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(resBot.port_b, fanBot.port_a) annotation (Line(
      points={{-40,-20},{-50,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(bypassBoty.y, valBypassBottom.y) annotation (Line(
      points={{111.4,-40},{80,-40},{80,-58.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(recupBoty.y, valRecupBot.y) annotation (Line(
      points={{111.4,-10},{80,-10},{80,-16.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(bypassTopy.y, valBypassTop.y) annotation (Line(
      points={{114,75},{86,75},{86,75.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(valRecupTop.port_b, dumpedAir) annotation (Line(
      points={{94,44},{100,44},{100,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(valBypassTop.port_b, dumpedAir) annotation (Line(
      points={{94,66},{100,66},{100,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(onAdiaExp.y, adCrFlHe.adiabaticOn) annotation (Line(
      points={{99,0},{59.24,0},{59.24,-9}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(comPid.y, simpleCompressor.mod) annotation (Line(points={{14.3,53},{24,
          53},{24,51},{23.6,51}}, color={0,0,127}));
  connect(fan_flow_set[1].y, fanTop.dp_in) annotation (Line(
      points={{-68.6,35},{-60,35},{-60,32},{-60.2,32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fan_flow_set[2].y, fanBot.dp_in) annotation (Line(
      points={{-68.6,35},{-60,35},{-60,-2},{-59.8,-2},{-59.8,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T_heater_in.port_a, fanBot.port_b) annotation (Line(
      points={{-80,-20},{-70,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(T_heater_in.port_b, heater.port_a1) annotation (Line(
      points={{-92,-20},{-100,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(T_heater_in.T, TrecupPul) annotation (Line(
      points={{-86,-13.4},{-86,-72},{106,-72}},
      color={0,0,127},
      smooth=Smooth.None,
      visible=false));
  connect(fanTop.port_a, extractedAir) annotation (Line(
      points={{-70,20},{-140,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heaPid.y, yValve) annotation (Line(
      points={{54.36,-92},{106,-92}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaPid.u_s, Tset) annotation (Line(
      points={{40.8,-92},{8,-92},{8,-102}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heater.port_b1, T_heater_out.port_a) annotation (Line(
      points={{-120,-20},{-122,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(T_heater_out.port_b, injectedAir) annotation (Line(
      points={{-134,-20},{-140,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(T_heater_out.T, heaPid.u_m) annotation (Line(
      points={{-128,-13.4},{-128,-124},{48,-124},{48,-99.2}},
      color={0,0,127},
      smooth=Smooth.None,
      visible=false));
  connect(recupTopy.y, valRecupTop.y) annotation (Line(points={{112,54},{88.85,54},
          {88.85,53.6},{86,53.6}},     color={0,0,127}));
  connect(comPid.u_s, Tset) annotation (Line(
      points={{3,53},{-34,53},{-34,-102},{8,-102}},
      color={0,0,127},
      visible=false));
  connect(thermalConductionfanBot.port_a, thermalConductionFanTop.port_a)
    annotation (Line(points={{-92,-6},{-92,0},{-92,6}}, color={191,0,0}));
  connect(evaporator.TWat, adCrFlHe.T_out_bot) annotation (Line(
      points={{5.6,-55.84},{5.6,-34.52},{60.48,-34.52}},
      color={0,0,127},
      visible=false));
  connect(adCrFlHe.port_b1, condensor.ports[1]) annotation (Line(points={{58,8.4},
          {62,8.4},{62,8},{72,8},{72,36.4}}, color={0,127,255}));
  connect(condensor.ports[2], valRecupTop.port_a)
    annotation (Line(points={{72,33.6},{72,44},{78,44}}, color={0,127,255}));
  connect(valBypassTop.port_a, resTop.port_b) annotation (Line(points={{78,66},{
          -4,66},{-4,20},{-20,20}},
                                  color={0,127,255}));
  connect(adCrFlHe.port_a1, resTop.port_b) annotation (Line(points={{-4,8.4},{-4,
          8.4},{-4,18},{-4,20},{-20,20}}, color={0,127,255}));
  connect(adCrFlHe.port_b2, evaporator.ports[1]) annotation (Line(points={{-4,-26.4},
          {-4,-44},{-2.4,-44}}, color={0,127,255}));
  connect(onCompExp.y, simpleCompressor.on) annotation (Line(points={{1,83},{28,
          83},{28,51},{28.8,51}},
                              color={255,0,255}));
  connect(piHeaterOn.y, heaPid.on) annotation (Line(points={{42,-82},{46.8,-82},
          {46.8,-85.52}}, color={255,0,255}));
  connect(freshAir, valRecupBot.port_a)
    annotation (Line(points={{100,-26},{96,-26},{88,-26}}, color={0,127,255}));
  connect(valRecupBot.port_b, adCrFlHe.port_a2) annotation (Line(points={{72,-26},
          {67,-26},{67,-26.4},{58,-26.4}}, color={0,127,255}));
  connect(valBypassBottom.port_b, T_fresh_in.port_a)
    annotation (Line(points={{72,-68},{64,-68},{34,-68}}, color={0,127,255}));
  connect(T_fresh_in.port_b, resBot.port_a) annotation (Line(points={{22,-68},{-20,
          -68},{-20,-20}}, color={0,127,255}));
  connect(valBypassBottom.port_a, freshAir) annotation (Line(points={{88,-68},{100,
          -68},{100,-26}}, color={0,127,255}));
  connect(evaporator.ports[2], resBot.port_a) annotation (Line(points={{-5.6,-44},
          {-20,-44},{-20,-20}}, color={0,127,255}));
  connect(comPid.u_m, T_heater_out.T) annotation (Line(
      points={{9,47},{9,-13.4},{-128,-13.4}},
      color={0,0,127},
      visible=false));
  connect(theConEva.port_a, fixedTemperature.port)
    annotation (Line(points={{-76,0},{-100,0},{-100,6}}, color={191,0,0}));
  connect(theConEva.port_b, evaporator.heatPort) annotation (Line(
      points={{-64,0},{4,0},{4,-52}},
      color={191,0,0},
      visible=false));
  connect(theConCon.port_a, theConEva.port_a)
    annotation (Line(points={{-76,10},{-76,5},{-76,0}}, color={191,0,0}));
  connect(theConCon.port_b, conCon.port_b) annotation (Line(
      points={{-64,10},{-24,10},{-24,12},{56,12},{56,42}},
      color={191,0,0},
      visible=false));
  connect(onDelAdi.u, onAdiaExp.y)
    annotation (Line(points={{95.6,8},{99,8},{99,0}}, color={255,0,255}));
  connect(T_fresh_in.T, add.u1) annotation (Line(
      points={{28,-61.4},{-2,-61.4},{-2,-62},{-66,-62},{-66,68},{-71,68}},
      color={0,0,127},
      visible=false));
  connect(T_heater_in.T,damPid. u_m) annotation (Line(
      points={{-86,-13.4},{-86,59},{-33,59}},
      color={0,0,127},
      visible=false));
  connect(senTemEva.T, add.u2) annotation (Line(
      points={{32,-44},{-71,-44},{-71,62}},
      color={0,0,127},
      visible=false));
  connect(add.y, abs1.u)
    annotation (Line(points={{-59.5,65},{-57,65}}, color={0,0,127}));
  connect(abs1.y,damPid. BpInput) annotation (Line(points={{-45.5,65},{-42.75,65},
          {-42.75,70},{-39,70}}, color={0,0,127}));
  connect(Tset,damPid. u_s) annotation (Line(
      points={{8,-102},{-2,-102},{-39,-102},{-39,65}},
      color={0,0,127},
      visible=false));
  connect(damPid.revAct, revAct.y) annotation (Line(points={{-32.6,70.4},{-32.6,
          80},{-44,80}}, color={255,0,255}));
  connect(PPum.y, sum.u[5]) annotation (Line(points={{61,88},{76.4,88},{76.4,91.28}},
        color={0,0,127}));
  connect(valRecupTop.addPreDro, onAdiaExp.y) annotation (Line(points={{82.8,52.48},
          {76,52.48},{76,0},{99,0}}, color={255,0,255}));
  connect(booleanConstant.y, valBypassTop.addPreDro) annotation (Line(points={{60.5,75},
          {68,75},{68,74.48},{82.8,74.48}},        color={255,0,255}));
  connect(valBypassTop.addPreDro, valRecupBot.addPreDro) annotation (Line(
        points={{82.8,74.48},{82.8,28.24},{83.2,28.24},{83.2,-17.52}}, color={
          255,0,255}));
  connect(valBypassBottom.addPreDro, valRecupBot.addPreDro) annotation (Line(
        points={{83.2,-59.52},{83.2,-37.76},{83.2,-17.52}}, color={255,0,255}));
  connect(PUnit.y, sum.u[1]) annotation (Line(points={{61,96},{62,96},{62,88.72},
          {76.4,88.72}}, color={0,0,127}));
  connect(comPid.on, onCompExp.y) annotation (Line(points={{8,58.4},{8,58.4},{8,
          83},{1,83}}, color={255,0,255}));
  connect(simpleCompressor.port_a, evaporator.heatPort)
    annotation (Line(points={{22,42},{4,42},{4,-52}}, color={191,0,0}));
  connect(piValOn.y,damPid. on) annotation (Line(points={{-65,92},{-34,92},{-34,
          70.4}}, color={255,0,255}));
  connect(adCrFlHe.T_out_bot, simpleCompressor.TinEva) annotation (Line(points={
          {60.48,-34.52},{34,-34.52},{34,50.8}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,
            -100},{100,100}})),           Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-140,-100},{100,100}})),
    experiment(
      StopTime=3000,
      Tolerance=0.001,
      __Dymola_Algorithm="Lsodar"),
    __Dymola_experimentSetupOutput(events=false),
    Documentation(revisions="<html>
<ul>
<li>
October 11, 2016, by Filip Jorissen:<br/>
Added first implementation.
</li>
</ul>
</html>"));
end Adsolair58;
