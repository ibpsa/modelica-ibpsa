within IDEAS.Fluid.Production.BaseClasses;
partial model PartialHeatPump "Heat pump partial"
  extends IDEAS.Fluid.Interfaces.PartialFourPortInterface(
    m1_flow_nominal=heatPumpData.m1_flow_nominal,
    m2_flow_nominal=heatPumpData.m2_flow_nominal);

  replaceable parameter IDEAS.Fluid.Production.BaseClasses.HeatPumpData heatPumpData constrainedby
    HeatPumpData "Record containing heat pump performance data"
                                                   annotation (
      choicesAllMatching=true, Placement(transformation(extent={{-98,-98},{-78,-78}})));
  extends IDEAS.Fluid.Interfaces.OnOffInterface(use_onOffSignal=true);

  parameter Boolean use_scaling=false
    "scale the performance data based on the nominal power"
    annotation (Dialog(tab="Advanced"));
  parameter Boolean use_modulationSignal=false
    "enables an input for modulating the heat pump ideally (no change of COP, just scaling of the electrical and thermal power)"
    annotation (Dialog(tab="Advanced"));

  parameter Modelica.SIunits.Power P_the_nominal=heatPumpData.P_the_nominal
    "nominal thermal power of the heat pump"
    annotation (Dialog(enable=use_scaling, tab="Advanced"));

  final parameter Real sca=if use_scaling then P_the_nominal/heatPumpData.P_the_nominal
       else 1 "scaling factor for the nominal power of the heat pump";

  //From LumpedVolumeDeclarations
  // Assumptions
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Formulation of energy balance"
    annotation (Evaluate=true, Dialog(tab="Dynamics", group="Equations"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
    "Formulation of mass balance"
    annotation (Evaluate=true, Dialog(tab="Dynamics", group="Equations"));
  final parameter Modelica.Fluid.Types.Dynamics substanceDynamics=
      energyDynamics "Formulation of substance balance"
    annotation (Evaluate=true, Dialog(tab="Dynamics", group="Equations"));
  final parameter Modelica.Fluid.Types.Dynamics traceDynamics=energyDynamics
    "Formulation of trace substance balance"
    annotation (Evaluate=true, Dialog(tab="Dynamics", group="Equations"));

  // Initialization
  parameter Medium1.AbsolutePressure p_start=Medium1.p_default
    "Start value of primary circuit pressure"
    annotation (Dialog(tab="Initialization"));
  parameter Medium1.Temperature T_start=Medium1.T_default
    "Start value of primary circuit temperature"
    annotation (Dialog(tab="Initialization"));
  parameter Medium1.MassFraction X_start[Medium1.nX]=Medium1.X_default
    "Start value of primary circuit mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", enable=Medium1.nXi > 0));
  parameter Medium1.ExtraProperty C_start[Medium1.nC](quantity=
        Medium1.extraPropertiesNames) = fill(0, Medium1.nC)
    "Start value of primary circuit trace substances"
    annotation (Dialog(tab="Initialization", enable=Medium1.nC > 0));
  parameter Medium1.ExtraProperty C_nominal[Medium1.nC](quantity=
        Medium1.extraPropertiesNames) = fill(1E-2, Medium1.nC)
    "Nominal value of trace substances. (Set to typical order of magnitude.)"
    annotation (Dialog(tab="Initialization", enable=Medium1.nC > 0));

  parameter Medium2.AbsolutePressure p_start2=Medium2.p_default
    "Start value of secondary circuit pressure"
    annotation (Dialog(tab="Initialization"));
  parameter Medium2.Temperature T_start2=Medium2.T_default
    "Start value of secondary circuit temperature"
    annotation (Dialog(tab="Initialization"));
  parameter Medium2.MassFraction X_start2[Medium2.nX]=Medium2.X_default
    "Start value of secondary circuit mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", enable=Medium2.nXi > 0));
  parameter Medium2.ExtraProperty C_start2[Medium2.nC](quantity=
        Medium2.extraPropertiesNames) = fill(0, Medium2.nC)
    "Start value of secondary circuit trace substances"
    annotation (Dialog(tab="Initialization", enable=Medium2.nC > 0));
  parameter Medium2.ExtraProperty C_nominal2[Medium2.nC](quantity=
        Medium2.extraPropertiesNames) = fill(1E-2, Medium2.nC)
    "Nominal value of trace substances. (Set to typical order of magnitude.)"
    annotation (Dialog(tab="Initialization", enable=Medium2.nC > 0));
  parameter Real mFactor=1
    "Factor to scale the thermal mass of the evaporator and condensor"
    annotation (Dialog(tab="Advanced"));

  //From TwoPortFlowResistanceParameters:
  parameter Boolean computeFlowResistance=true
    "=true, compute flow resistance. Set to false to assume no friction"
    annotation (Evaluate=true, Dialog(tab="Flow resistance"));
  parameter Boolean from_dp=false
    "= true, use m_flow = f(dp) else dp = f(m_flow)" annotation (Evaluate=true,
      Dialog(enable=computeFlowResistance, tab="Flow resistance"));
  parameter Boolean linearizeFlowResistance=false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation (Dialog(enable=computeFlowResistance, tab="Flow resistance"));
  parameter Real deltaM=0.1
    "Fraction of nominal flow rate where flow transitions to laminar"
    annotation (Dialog(enable=computeFlowResistance, tab="Flow resistance"));
  parameter Boolean avoidEvents=false
    "Set to true to switch heat pumps on using a continuous transition"
    annotation (Dialog(tab="Advanced", group="Events"));

  parameter SI.Time riseTime=120
    "The time it takes to reach full/zero power when switching" annotation (
      Dialog(
      tab="Advanced",
      group="Events",
      enable=avoidEvents));
  Modelica.Blocks.Tables.CombiTable2D powerTable(table=heatPumpData.powerData,
      smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments)
    "Interpolation table for finding the electrical power"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  Modelica.Blocks.Tables.CombiTable2D copTable(table=heatPumpData.copData,
      smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments)
    annotation (Placement(transformation(extent={{-60,54},{-40,74}})));
  Boolean compressorOn;
  Modelica.Blocks.Sources.RealExpression Qevap(y=-P_evap)
    annotation (Placement(transformation(extent={{18,0},{0,20}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatEvap
    annotation (Placement(transformation(extent={{-12,0},{-32,20}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlowCond
    annotation (Placement(transformation(extent={{22,-20},{42,0}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductorLosses(G=
        heatPumpData.G) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={26,-70})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatLoss
    annotation (Placement(transformation(extent={{16,-110},{36,-90}})));

  Modelica.Blocks.Sources.RealExpression Qcond(y=P_cond)
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort T_in_evap(
    allowFlowReversal=allowFlowReversal,
    tau=10,
    redeclare package Medium = Medium1,
    m_flow_nominal=heatPumpData.m1_flow_nominal)
    annotation (Placement(transformation(extent={{-92,50},{-72,70}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort T_in_cond(
    tau=10,
    allowFlowReversal=allowFlowReversal,
    redeclare package Medium = Medium2,
    m_flow_nominal=heatPumpData.m2_flow_nominal)
    annotation (Placement(transformation(extent={{88,-70},{68,-50}})));

  Modelica.SIunits.Power P_el "Electrical power consumption";
  Modelica.SIunits.Power P_evap "Thermal power of the evaporator (positive)";
  Modelica.SIunits.Power P_cond "Thermal power of the condensor (positive)";
  Real cop "COP of the heat pump";
  Modelica.Blocks.Sources.RealExpression Pelec(y=P_el)
    annotation (Placement(transformation(extent={{60,70},{40,90}})));
  Modelica.Blocks.Interfaces.RealOutput P "Electrical power consumption"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,110})));
public
  parameter Boolean homotopyInitialization=true "= true, use homotopy method"
    annotation (Dialog(tab="Flow resistance"));

  parameter Boolean allowFlowReversal=true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation (Dialog(tab="Assumptions"));

  FixedResistances.Pipe_HeatPort evaporator(
    energyDynamics=energyDynamics,
    massDynamics=massDynamics,
    p_start=p_start,
    T_start=T_start,
    X_start=X_start,
    C_start=C_start,
    C_nominal=C_nominal,
    from_dp=from_dp,
    linearizeFlowResistance=linearizeFlowResistance,
    deltaM=deltaM,
    m=heatPumpData.mBrine*sca,
    mFactor=if avoidEvents then max(mFactor, 1 + riseTime*heatPumpData.P_the_nominal
        /Medium1.specificHeatCapacityCp(state_default_brine)/5/heatPumpData.mBrine)
         else mFactor,
    computeFlowResistance=computeFlowResistance,
    redeclare package Medium = Medium1,
    m_flow_nominal=heatPumpData.m1_flow_nominal*sca,
    dp_nominal=heatPumpData.dp1_nominal)         annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-60,10})));
  FixedResistances.Pipe_HeatPort condensor(
    energyDynamics=energyDynamics,
    massDynamics=massDynamics,
    from_dp=from_dp,
    linearizeFlowResistance=linearizeFlowResistance,
    deltaM=deltaM,
    p_start=p_start2,
    T_start=T_start2,
    X_start=X_start2,
    C_start=C_start2,
    C_nominal=C_nominal2,
    m=heatPumpData.mFluid*sca,
    mFactor=if avoidEvents then max(mFactor, 1 + riseTime*heatPumpData.P_the_nominal
        /Medium2.specificHeatCapacityCp(state_default_fluid)/5/heatPumpData.mFluid)
         else mFactor,
    computeFlowResistance=computeFlowResistance,
    redeclare package Medium = Medium2,
    m_flow_nominal=heatPumpData.m2_flow_nominal*sca,
    dp_nominal=heatPumpData.dp2_nominal)         annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={60,-10})));

  outer Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
protected
  parameter Medium1.ThermodynamicState state_default_brine=
      Medium1.setState_pTX(
      Medium1.p_default,
      Medium1.T_default,
      Medium1.X_default);
  parameter Medium2.ThermodynamicState state_default_fluid=
      Medium2.setState_pTX(
      Medium2.p_default,
      Medium2.T_default,
      Medium2.X_default);

  // ---------------- Control for temperature protection of evaporator and condenser
  Modelica.Blocks.Logical.Hysteresis hysteresisCond(
    pre_y_start=true,
    uLow=0,
    uHigh=5) "Temperature protection of the condenser"
    annotation (Placement(transformation(extent={{-42,-88},{-30,-76}})));
  Modelica.Blocks.Sources.RealExpression limit1(y=heatPumpData.T_cond_max -
        condensor.heatPort.T)
    annotation (Placement(transformation(extent={{-68,-92},{-48,-72}})));

  Modelica.Blocks.Logical.Hysteresis hysteresisEvap(
    pre_y_start=true,
    uLow=0,
    uHigh=5) "Temperature protection of the evaporator"
    annotation (Placement(transformation(extent={{-42,-102},{-30,-90}})));
  Modelica.Blocks.Sources.RealExpression limit2(y=evaporator.heatPort.T -
        heatPumpData.T_evap_min)
    annotation (Placement(transformation(extent={{-68,-106},{-48,-86}})));
  Modelica.Blocks.Logical.And tempProtection
    annotation (Placement(transformation(extent={{-24,-90},{-16,-82}})));

  // ---------------- Smoothing of the temperature protection control and on off control

public
  Modelica.Blocks.Sources.BooleanExpression compressorOnBlock(y=compressorOn) if avoidEvents
    annotation (Placement(transformation(extent={{-100,-68},{-60,-48}})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal if avoidEvents
    annotation (Placement(transformation(extent={{-52,-64},{-40,-52}})));
  Modelica.Blocks.Continuous.Filter modulationRate(f_cut=5/(2*Modelica.Constants.pi
        *riseTime),
    final analogFilter=Modelica.Blocks.Types.AnalogFilter.CriticalDamping,
    final filterType=Modelica.Blocks.Types.FilterType.LowPass,
    final order=2) if                                                                                   avoidEvents
    "Fictive modulation rate to avoid non-smooth on/off transitions causing events."
    annotation (Placement(transformation(extent={{-34,-64},{-22,-52}})));
protected
  Modelica.Blocks.Interfaces.RealInput modulationRate_internal
    " Internal variable for temperature safety modulation";
  Modelica.Blocks.Interfaces.RealOutput modulationSignal_internal
    " Internal variable for the modulation signal";

  // ----------------- Modulation of heat pump to work in partial load
public
  Modelica.Blocks.Interfaces.RealInput mod(min=0, max=1) if
                                                           use_modulationSignal
    "Modulation level" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={88,110})));
  Modelica.Blocks.Continuous.Filter modulationSignal(f_cut=5/(2*Modelica.Constants.pi
        *riseTime),
    final analogFilter=Modelica.Blocks.Types.AnalogFilter.CriticalDamping,
    final filterType=Modelica.Blocks.Types.FilterType.LowPass,
    final order=2) if                                                                                   use_modulationSignal
    "Smoothing of the modulation signal"
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={88,76})));
equation
  cop = copTable.y;
  P_evap = P_el*(cop - 1);
  P_cond = P_el*cop;

  P_el = powerTable.y*sca*modulationRate_internal*modulationSignal_internal;

  if avoidEvents then
    connect(modulationRate_internal, modulationRate.y);
    connect(compressorOnBlock.y, booleanToReal.u) annotation (Line(
      points={{-58,-58},{-53.2,-58}},
      color={255,0,255},
      smooth=Smooth.None));
    connect(modulationRate.u, booleanToReal.y) annotation (Line(
      points={{-35.2,-58},{-39.4,-58}},
      color={0,0,127},
      smooth=Smooth.None));
  else
    modulationRate_internal = if compressorOn then 1 else 0;
  end if;

  if use_modulationSignal then
    connect(mod, modulationSignal.u) annotation (Line(
        points={{88,110},{88,83.2}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(modulationSignal_internal, modulationSignal.y);
  else
    modulationSignal_internal = 1;
  end if;

  connect(heatLoss, thermalConductorLosses.port_a) annotation (Line(
      points={{26,-100},{26,-80}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedHeatEvap.Q_flow, Qevap.y) annotation (Line(
      points={{-12,10},{-0.9,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedHeatFlowCond.Q_flow, Qcond.y) annotation (Line(
      points={{22,-10},{1,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Pelec.y, P) annotation (Line(
      points={{39,80},{20,80},{20,110}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(evaporator.port_a, T_in_evap.port_b) annotation (Line(
      points={{-60,20},{-60,60},{-72,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(evaporator.heatPort,prescribedHeatEvap. port) annotation (Line(
      points={{-50,10},{-32,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_in_cond.port_b, condensor.port_a) annotation (Line(
      points={{68,-60},{60,-60},{60,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(prescribedHeatFlowCond.port, condensor.heatPort) annotation (Line(
      points={{42,-10},{50,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalConductorLosses.port_b, condensor.heatPort) annotation (Line(
      points={{26,-60},{26,-28},{50,-28},{50,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(limit1.y, hysteresisCond.u) annotation (Line(
      points={{-47,-82},{-43.2,-82}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(limit2.y, hysteresisEvap.u) annotation (Line(
      points={{-47,-96},{-43.2,-96}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hysteresisCond.y, tempProtection.u1) annotation (Line(
      points={{-29.4,-82},{-26,-82},{-26,-86},{-24.8,-86}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(hysteresisEvap.y, tempProtection.u2) annotation (Line(
      points={{-29.4,-96},{-26,-96},{-26,-89.2},{-24.8,-89.2}},
      color={255,0,255},
      smooth=Smooth.None));

  connect(port_a1, T_in_evap.port_a) annotation (Line(
      points={{-100,60},{-92,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(evaporator.port_b, port_b2) annotation (Line(
      points={{-60,0},{-60,-60},{-100,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_b1, condensor.port_b) annotation (Line(
      points={{100,60},{60,60},{60,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(T_in_cond.port_a, port_a2) annotation (Line(
      points={{88,-60},{100,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),
                    graphics),
    Icon(graphics={
        Rectangle(extent={{-60,60},{60,-60}}, lineColor={0,0,255}),
        Line(
          points={{-100,40},{-20,40},{-40,20},{-20,0},{-40,-20},{-20,-40},{-100,
              -40}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{100,40},{20,40},{40,20},{20,0},{40,-20},{20,-40},{100,-40}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-20,20},{20,20}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{10,30},{20,20},{10,10}},
          color={255,0,0},
          smooth=Smooth.None)}),
    Documentation(revisions="<html>
    <ul>
    <li>December 2014 by Damien Picard:<br/> 
    Make filter parameters final to avoid warning durings compilation.
</li>
<li>December 2014 by Damien Picard:<br/> 
Add value to internal variable modulationRate_internal to close the equations when avoidEvents is false. Add a modulation input.
</li>
<li>November 2014 by Filip Jorissen:<br/> 
Added 'AvoidEvents' parameter, temperature protection and documentation.
</li>
<li>March 2014 by Filip Jorissen:<br/> 
Initial version
</li>
</ul>
</html>", info="<html>
<p>This partial model provides an implementation for a heat pump. Heat is drawn from the fluid at the &apos;Brine&apos; side and injected into the &apos;Fluid&apos; side. The model uses performance tables to calculate the COP and electrical power.</p>
<p><b>Main equations</b> </p>
<p>The COP and electrical power Pel are read from performance tables as a function of the water inlet temperatures:</p>
<p>COP = f1(T_in_condensor, T_in_evaporator)</p>
<p>P_el = f2(T_in_condensor, T_in_evaporator)</p>
<p>These values are used to calculate the thermal powers:</p>
<p>Q_condensor = P_el*COP</p>
<p>Q_evaporator = P_el*(COP-1)</p>
<p>If the parameter use_scaling is true, the powers of the heat pump will be scaled with QNom / QNomRef. The nominal mass flow rate of the heat pump is also scaled to correctly scale the pressure losses.</p>
<p>The models also allows partial load if use_modulationSignal is set to true. The modulation is assumed to be ideal and it works then as a scaling input of the power.</p>
<p><br>The heat pump compressor will be switched off when:</p>
<ol>
<li>The external control signal is false</li>
<li>The over/under-temperature protection is activated</li>
</ol>
<p>In this case P_el will become zero. The transition from on to off can happen discretely or through a filter using the parameter &apos;avoidEvents&apos;.</p>
<h4>Assumptions and limitations </h4>
<ul>
<li>The transient behaviour of the thermodynamic cycle is not simulated.</li>
<li>The fluid mass flow rates do not have an impact on the values of COP and P_el.</li>
<li>Modulation of the power is not supported.</li>
<li>Maximum temperatures of the evaporator and minimum temperatures of the condensor are not considered.</li>
<li>Defrosting cycles etc are not considered.</li>
</ul>
<h4>Typical use and important parameters</h4>
<p>A record with the required parameters needs to be provided.</p>
<p><br>The parameter &apos;avoidEvents&apos; can be used to avoid an event when activating the over/under-temperature protection. When avoidEvents is true the thermal mass of the condensor and evaporator are increased to avoid undercooling/overheating the heat pump while it is switching off and the mass flow rate is zero. This factor can be quite significant and depends on the &apos;riseTime&apos;.</p>
<h4>Options</h4>
<ol>
<li>Typical options inherited through lumpedVolumeDeclarations can be used.</li>
</ol>
<h4>Validation</h4>
<p>Examples of this model can be found in<a href=\"modelica://IDEAS.Fluid.Production.Examples.HeatPump_BrineWater\"> IDEAS.Fluid.Production.Examples.HeatPump_BrineWater</a>, <a href=\"modelica://IDEAS.Fluid.Production.Examples.HeatPump_BrineWaterTset\">IDEAS.Fluid.Production.Examples.HeatPump_BrineWaterTset</a> and <a href=\"modelica://IDEAS.Fluid.Production.Examples.HeatPump_Events\">IDEAS.Fluid.Production.Examples.HeatPump_Events</a></p>
</html>"));
end PartialHeatPump;
