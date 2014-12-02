within IDEAS.Fluid.Production.BaseClasses;
partial model PartialHeatPump "Heat pump partial"

  Modelica.Fluid.Interfaces.FluidPort_a brineIn(redeclare package Medium =
        MediumBrine)
    annotation (Placement(transformation(extent={{-110,30},{-90,50}})));
  Modelica.Fluid.Interfaces.FluidPort_b fluidOut(redeclare package Medium =
        MediumFluid)
    annotation (Placement(transformation(extent={{90,30},{110,50}})));
  Modelica.Fluid.Interfaces.FluidPort_a fluidIn(redeclare package Medium =
        MediumFluid)
    annotation (Placement(transformation(extent={{90,-50},{110,-30}})));
  Modelica.Fluid.Interfaces.FluidPort_b brineOut(redeclare package Medium =
        MediumBrine)
    annotation (Placement(transformation(extent={{-110,-50},{-90,-30}})));
  replaceable package MediumBrine =
    IDEAS.Media.Water.Simple constrainedby
    Modelica.Media.Interfaces.PartialMedium "Brine medium at primary side"
    annotation(choicesAllMatching=true);
  replaceable package MediumFluid =
    IDEAS.Media.Water.Simple constrainedby
    Modelica.Media.Interfaces.PartialMedium "Fluid medium at secondary side"
    annotation(choicesAllMatching=true);
  replaceable parameter HeatPumpData heatPumpData
  constrainedby HeatPumpData "Record containing heat pump performance data"
    annotation (choicesAllMatching=true, Placement(transformation(extent={{-98,-98},{-78,-78}})));
  extends IDEAS.Fluid.Interfaces.OnOffInterface(use_onOffSignal=true);

  parameter Boolean use_scaling = false
    "scale the performance data based on the nominal power"
    annotation(Dialog(tab="Advanced"));
  parameter Modelica.SIunits.Power P_the_nominal = heatPumpData.P_the_nominal
    "nominal thermal power of the heat pump"
    annotation (Dialog(enable=use_scaling, tab="Advanced"));

  final parameter Real sca = if use_scaling then P_the_nominal / heatPumpData.P_the_nominal else 1
    "scaling factor for the nominal power of the heat pump";

    //From LumpedVolumeDeclarations
      // Assumptions
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Formulation of energy balance"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
    "Formulation of mass balance"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  final parameter Modelica.Fluid.Types.Dynamics substanceDynamics=energyDynamics
    "Formulation of substance balance"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  final parameter Modelica.Fluid.Types.Dynamics traceDynamics=energyDynamics
    "Formulation of trace substance balance"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));

  // Initialization
  parameter MediumBrine.AbsolutePressure p_start = MediumBrine.p_default
    "Start value of primary circuit pressure"
    annotation(Dialog(tab = "Initialization"));
  parameter MediumBrine.Temperature T_start=MediumBrine.T_default
    "Start value of primary circuit temperature"
    annotation(Dialog(tab = "Initialization"));
  parameter MediumBrine.MassFraction X_start[MediumBrine.nX] = MediumBrine.X_default
    "Start value of primary circuit mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", enable=MediumBrine.nXi > 0));
  parameter MediumBrine.ExtraProperty C_start[MediumBrine.nC](
       quantity=MediumBrine.extraPropertiesNames)=fill(0, MediumBrine.nC)
    "Start value of primary circuit trace substances"
    annotation (Dialog(tab="Initialization", enable=MediumBrine.nC > 0));
  parameter MediumBrine.ExtraProperty C_nominal[MediumBrine.nC](
       quantity=MediumBrine.extraPropertiesNames) = fill(1E-2, MediumBrine.nC)
    "Nominal value of trace substances. (Set to typical order of magnitude.)"
   annotation (Dialog(tab="Initialization", enable=MediumBrine.nC > 0));

  parameter MediumFluid.AbsolutePressure p_start2 = MediumFluid.p_default
    "Start value of secondary circuit pressure"
    annotation(Dialog(tab = "Initialization"));
  parameter MediumFluid.Temperature T_start2=MediumFluid.T_default
    "Start value of secondary circuit temperature"
    annotation(Dialog(tab = "Initialization"));
  parameter MediumFluid.MassFraction X_start2[MediumFluid.nX] = MediumFluid.X_default
    "Start value of secondary circuit mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", enable=MediumFluid.nXi > 0));
  parameter MediumFluid.ExtraProperty C_start2[MediumFluid.nC](
       quantity=MediumFluid.extraPropertiesNames)=fill(0, MediumFluid.nC)
    "Start value of secondary circuit trace substances"
    annotation (Dialog(tab="Initialization", enable=MediumFluid.nC > 0));
  parameter MediumFluid.ExtraProperty C_nominal2[MediumFluid.nC](
       quantity=MediumFluid.extraPropertiesNames) = fill(1E-2, MediumFluid.nC)
    "Nominal value of trace substances. (Set to typical order of magnitude.)"
   annotation (Dialog(tab="Initialization", enable=MediumFluid.nC > 0));
  parameter Real mFactor=1
    "Factor to scale the thermal mass of the evaporator and condensor"
    annotation(Dialog(tab="Advanced"));

  //From TwoPortFlowResistanceParameters:
  parameter Boolean computeFlowResistance = true
    "=true, compute flow resistance. Set to false to assume no friction"
    annotation (Evaluate=true, Dialog(tab="Flow resistance"));
  parameter Boolean from_dp = false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(enable = computeFlowResistance,
                tab="Flow resistance"));
  parameter Boolean linearizeFlowResistance = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Dialog(enable = computeFlowResistance,
               tab="Flow resistance"));
  parameter Real deltaM = 0.1
    "Fraction of nominal flow rate where flow transitions to laminar"
    annotation(Dialog(enable = computeFlowResistance, tab="Flow resistance"));
  parameter Boolean avoidEvents = false
    "Set to true to switch heat pumps on using a continuous transition"
    annotation(Dialog(tab="Advanced", group="Events"));

  parameter SI.Time riseTime=120
    "The time it takes to reach full/zero power when switching"
    annotation(Dialog(tab="Advanced", group="Events", enable=avoidEvents));
  Modelica.Blocks.Tables.CombiTable2D powerTable(              table=
        heatPumpData.powerData, smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments)
    "Interpolation table for finding the electrical power"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  Modelica.Blocks.Tables.CombiTable2D copTable(                table=
        heatPumpData.copData, smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments)
    annotation (Placement(transformation(extent={{-60,54},{-40,74}})));
  Boolean compressorOn;
  Modelica.Blocks.Sources.RealExpression realExpression(y=-P_evap)
    annotation (Placement(transformation(extent={{18,0},{0,20}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
    annotation (Placement(transformation(extent={{-12,0},{-32,20}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow1
    annotation (Placement(transformation(extent={{22,-20},{42,0}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(G=
        heatPumpData.G)
           annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={26,-70})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatLoss
    annotation (Placement(transformation(extent={{16,-110},{36,-90}})));

  Modelica.Blocks.Sources.RealExpression realExpression1(y=P_cond)
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort T_in_evap(
    redeclare package Medium = MediumBrine,
    allowFlowReversal=allowFlowReversal,
    tau=10,
    m_flow_nominal=heatPumpData.m_flow_nominal_fluid)
            annotation (Placement(transformation(extent={{-92,30},{-72,50}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort T_in_cond(
    redeclare package Medium = MediumFluid,
    tau=10,
    allowFlowReversal=allowFlowReversal,
    m_flow_nominal=heatPumpData.m_flow_nominal_fluid)
    annotation (Placement(transformation(extent={{88,-50},{68,-30}})));

  Modelica.SIunits.Power P_el "Electrical power consumption";
  Modelica.SIunits.Power P_evap "Thermal power of the evaporator (positive)";
  Modelica.SIunits.Power P_cond "Thermal power of the condensor (positive)";
  Real cop "COP of the heat pump";
  Modelica.Blocks.Sources.RealExpression realExpression2(y=P_el)
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
    annotation(Dialog(tab="Assumptions"));

  FixedResistances.Pipe_HeatPort evaporator(
    redeclare package Medium = MediumBrine,
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
    dp_nominal=heatPumpData.dp_nominal_brine,
    m_flow_nominal=heatPumpData.m_flow_nominal_brine*sca,
    mFactor=if avoidEvents then max(mFactor, 1+riseTime*heatPumpData.P_the_nominal
        /MediumBrine.specificHeatCapacityCp(state_default_brine)/5/heatPumpData.mBrine)
         else mFactor,
    computeFlowResistance=computeFlowResistance)
              annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-60,10})));
  FixedResistances.Pipe_HeatPort condensor(
    energyDynamics=energyDynamics,
    massDynamics=massDynamics,
    from_dp=from_dp,
    linearizeFlowResistance=linearizeFlowResistance,
    deltaM=deltaM,
    redeclare package Medium = MediumFluid,
    p_start=p_start2,
    T_start=T_start2,
    X_start=X_start2,
    C_start=C_start2,
    C_nominal=C_nominal2,
    m=heatPumpData.mFluid*sca,
    dp_nominal=heatPumpData.dp_nominal_fluid,
    m_flow_nominal=heatPumpData.m_flow_nominal_fluid*sca,
    mFactor=if avoidEvents then max(mFactor, 1+riseTime*heatPumpData.P_the_nominal
        /MediumFluid.specificHeatCapacityCp(state_default_fluid)/5/heatPumpData.mFluid)
         else mFactor,
    computeFlowResistance=computeFlowResistance)
                                 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={60,-10})));

  outer Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
protected
  parameter MediumBrine.ThermodynamicState state_default_brine = MediumBrine.setState_pTX(MediumBrine.p_default, MediumBrine.T_default, MediumBrine.X_default);
  parameter MediumFluid.ThermodynamicState state_default_fluid = MediumFluid.setState_pTX(MediumFluid.p_default, MediumFluid.T_default, MediumFluid.X_default);

  Modelica.Blocks.Logical.Hysteresis hysteresisCond(
    pre_y_start=true,
    uLow=0,
    uHigh=5)
    annotation (Placement(transformation(extent={{-42,-88},{-30,-76}})));
  Modelica.Blocks.Sources.RealExpression limit1(y=heatPumpData.T_cond_max -
        condensor.heatPort.T)
    annotation (Placement(transformation(extent={{-68,-92},{-48,-72}})));
  Modelica.Blocks.Logical.Hysteresis hysteresisEvap(
    pre_y_start=true,
    uLow=0,
    uHigh=5)
    annotation (Placement(transformation(extent={{-42,-102},{-30,-90}})));
  Modelica.Blocks.Sources.RealExpression limit2(y=evaporator.heatPort.T -
        heatPumpData.T_evap_min)
    annotation (Placement(transformation(extent={{-68,-106},{-48,-86}})));
  Modelica.Blocks.Logical.And tempProtection
    annotation (Placement(transformation(extent={{-24,-90},{-16,-82}})));
public
  Modelica.Blocks.Sources.BooleanExpression compressorOnBlock(y=compressorOn) if avoidEvents
    annotation (Placement(transformation(extent={{-100,-68},{-60,-48}})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal if avoidEvents
    annotation (Placement(transformation(extent={{-52,-64},{-40,-52}})));
  Modelica.Blocks.Continuous.Filter modulationRate(f_cut=5/(2*Modelica.Constants.pi*riseTime)) if avoidEvents
    "Fictive modulation rate to avoid non-smooth on/off transitions causing events."
    annotation (Placement(transformation(extent={{-34,-64},{-22,-52}})));
protected
   Modelica.Blocks.Interfaces.RealInput modulationInternal;

equation
  cop = copTable.y;
  if avoidEvents then
    connect(modulationInternal, modulationRate.y);
  else
    modulationInternal = if compressorOn then 1 else 0;
  end if;
  if avoidEvents then
    P_el = powerTable.y * sca*modulationInternal;
  else
    P_el = if compressorOn then  powerTable.y * sca else 0;
  end if;
  P_evap=P_el*(cop-1);
  P_cond=P_el*cop;
  connect(heatLoss, thermalConductor.port_a) annotation (Line(
      points={{26,-100},{26,-80}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedHeatFlow.Q_flow, realExpression.y) annotation (Line(
      points={{-12,10},{-0.9,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedHeatFlow1.Q_flow, realExpression1.y) annotation (Line(
      points={{22,-10},{1,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(brineIn, T_in_evap.port_a) annotation (Line(
      points={{-100,40},{-92,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fluidIn, T_in_cond.port_a) annotation (Line(
      points={{100,-40},{88,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(realExpression2.y,P)  annotation (Line(
      points={{39,80},{20,80},{20,110}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(evaporator.port_a, T_in_evap.port_b) annotation (Line(
      points={{-60,20},{-60,40},{-72,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(evaporator.heatPort, prescribedHeatFlow.port) annotation (Line(
      points={{-50,10},{-32,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(evaporator.port_b, brineOut) annotation (Line(
      points={{-60,0},{-60,-40},{-100,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(T_in_cond.port_b, condensor.port_a) annotation (Line(
      points={{68,-40},{60,-40},{60,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(condensor.port_b, fluidOut) annotation (Line(
      points={{60,0},{60,40},{100,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(prescribedHeatFlow1.port, condensor.heatPort) annotation (Line(
      points={{42,-10},{50,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalConductor.port_b, condensor.heatPort) annotation (Line(
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
  connect(compressorOnBlock.y, booleanToReal.u) annotation (Line(
      points={{-58,-58},{-53.2,-58}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(modulationRate.u, booleanToReal.y) annotation (Line(
      points={{-35.2,-58},{-39.4,-58}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(graphics={
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
