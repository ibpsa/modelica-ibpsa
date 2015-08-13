within IDEAS.Fluid.Interfaces;
model HeightPortHeatMassExchanger
  "Model transporting four fluid streams between height ports with storing mass or energy"
  extends IDEAS.Fluid.Interfaces.PartialHeightPortInterface(
    final h_outflow_a1_start = h1_outflow_start,
    final h_outflow_b1_start = h1_outflow_start,
    final h_outflow_a2_start = h2_outflow_start,
    final h_outflow_b2_start = h2_outflow_start,
    final h_outflow_a3_start = h3_outflow_start,
    final h_outflow_b3_start = h3_outflow_start,
    final h_outflow_a4_start = h4_outflow_start,
    final h_outflow_b4_start = h4_outflow_start);

  extends IDEAS.Fluid.Interfaces.HeightPortFlowResistanceParameters(
     final computeFlowResistance1=true, final computeFlowResistance2=true,final computeFlowResistance3=true, final computeFlowResistance4=true);

  parameter Modelica.SIunits.Time tau1 = 30 "Time constant at nominal flow"
     annotation (Dialog(tab = "Dynamics", group="Nominal condition"));
  parameter Modelica.SIunits.Time tau2 = 30 "Time constant at nominal flow"
     annotation (Dialog(tab = "Dynamics", group="Nominal condition"));
  parameter Modelica.SIunits.Time tau3 = 30 "Time constant at nominal flow"
     annotation (Dialog(tab = "Dynamics", group="Nominal condition"));
  parameter Modelica.SIunits.Time tau4 = 30 "Time constant at nominal flow"
     annotation (Dialog(tab = "Dynamics", group="Nominal condition"));

  // Advanced
  parameter Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

  // Assumptions
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Formulation of energy balance"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
    "Formulation of mass balance"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));

  // Initialization
  parameter Medium1.AbsolutePressure p1_start = Medium1.p_default
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization", group = "Medium 1"));
  parameter Medium1.Temperature T1_start = Medium1.T_default
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization", group = "Medium 1"));
  parameter Medium1.MassFraction X1_start[Medium1.nX] = Medium1.X_default
    "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", group = "Medium 1", enable=Medium1.nXi > 0));
  parameter Medium1.ExtraProperty C1_start[Medium1.nC](
       quantity=Medium1.extraPropertiesNames)=fill(0, Medium1.nC)
    "Start value of trace substances"
    annotation (Dialog(tab="Initialization", group = "Medium 1", enable=Medium1.nC > 0));
  parameter Medium1.ExtraProperty C1_nominal[Medium1.nC](
       quantity=Medium1.extraPropertiesNames) = fill(1E-2, Medium1.nC)
    "Nominal value of trace substances. (Set to typical order of magnitude.)"
   annotation (Dialog(tab="Initialization", group = "Medium 1", enable=Medium1.nC > 0));

  parameter Medium2.AbsolutePressure p2_start = Medium2.p_default
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization", group = "Medium 2"));
  parameter Medium2.Temperature T2_start = Medium2.T_default
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization", group = "Medium 2"));
  parameter Medium2.MassFraction X2_start[Medium2.nX] = Medium2.X_default
    "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", group = "Medium 2", enable=Medium2.nXi > 0));
  parameter Medium2.ExtraProperty C2_start[Medium2.nC](
       quantity=Medium2.extraPropertiesNames)=fill(0, Medium2.nC)
    "Start value of trace substances"
    annotation (Dialog(tab="Initialization", group = "Medium 2", enable=Medium2.nC > 0));
  parameter Medium2.ExtraProperty C2_nominal[Medium2.nC](
       quantity=Medium2.extraPropertiesNames) = fill(1E-2, Medium2.nC)
    "Nominal value of trace substances. (Set to typical order of magnitude.)"
   annotation (Dialog(tab="Initialization", group = "Medium 2", enable=Medium2.nC > 0));

  parameter Medium3.AbsolutePressure p3_start = Medium3.p_default
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization", group = "Medium 3"));
  parameter Medium3.Temperature T3_start = Medium3.T_default
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization", group = "Medium 3"));
  parameter Medium3.MassFraction X3_start[Medium3.nX] = Medium3.X_default
    "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", group = "Medium 3", enable=Medium3.nXi > 0));
  parameter Medium3.ExtraProperty C3_start[Medium3.nC](
       quantity=Medium3.extraPropertiesNames)=fill(0, Medium3.nC)
    "Start value of trace substances"
    annotation (Dialog(tab="Initialization", group = "Medium 3", enable=Medium3.nC > 0));
  parameter Medium3.ExtraProperty C3_nominal[Medium3.nC](
       quantity=Medium3.extraPropertiesNames) = fill(1E-2, Medium3.nC)
    "Nominal value of trace substances. (Set to typical order of magnitude.)"
   annotation (Dialog(tab="Initialization", group = "Medium 3", enable=Medium3.nC > 0));

  parameter Medium4.AbsolutePressure p4_start = Medium4.p_default
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization", group = "Medium 4"));
  parameter Medium4.Temperature T4_start = Medium4.T_default
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization", group = "Medium 4"));
  parameter Medium4.MassFraction X4_start[Medium4.nX] = Medium4.X_default
    "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", group = "Medium 4", enable=Medium4.nXi > 0));
  parameter Medium4.ExtraProperty C4_start[Medium4.nC](
       quantity=Medium4.extraPropertiesNames)=fill(0, Medium4.nC)
    "Start value of trace substances"
    annotation (Dialog(tab="Initialization", group = "Medium 4", enable=Medium4.nC > 0));
  parameter Medium4.ExtraProperty C4_nominal[Medium4.nC](
       quantity=Medium4.extraPropertiesNames) = fill(1E-2, Medium4.nC)
    "Nominal value of trace substances. (Set to typical order of magnitude.)"
   annotation (Dialog(tab="Initialization", group = "Medium 4", enable=Medium4.nC > 0));

 Modelica.SIunits.HeatFlowRate Q1_flow = vol1.heatPort.Q_flow
    "Heat flow rate into medium 1";
  Modelica.SIunits.HeatFlowRate Q2_flow = vol2.heatPort.Q_flow
    "Heat flow rate into medium 2";
  Modelica.SIunits.HeatFlowRate Q3_flow = vol3.heatPort.Q_flow
    "Heat flow rate into medium 1";
  Modelica.SIunits.HeatFlowRate Q4_flow = vol4.heatPort.Q_flow
    "Heat flow rate into medium 2";

  IDEAS.Fluid.MixingVolumes.MixingVolume vol1(
    redeclare final package Medium = Medium1,
    nPorts = 2,
    V=m1_flow_nominal*tau1/rho1_nominal,
    final m_flow_nominal=m1_flow_nominal,
    energyDynamics=if tau1 > Modelica.Constants.eps
                         then energyDynamics else
                         Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=if tau1 > Modelica.Constants.eps
                         then massDynamics else
                         Modelica.Fluid.Types.Dynamics.SteadyState,
    final p_start=p1_start,
    final T_start=T1_start,
    final X_start=X1_start,
    final C_start=C1_start,
    final C_nominal=C1_nominal) "Volume for fluid 1"
                               annotation (Placement(transformation(extent={{-10,80},
            {10,60}})));

  IDEAS.Fluid.MixingVolumes.MixingVolume vol2(
    redeclare final package Medium = Medium2,
    nPorts=2,
    energyDynamics=if tau2 > Modelica.Constants.eps
                         then energyDynamics else
                         Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=if tau2 > Modelica.Constants.eps
                         then massDynamics else
                         Modelica.Fluid.Types.Dynamics.SteadyState,
    final p_start=p2_start,
    final T_start=T2_start,
    final X_start=X2_start,
    final C_start=C2_start,
    final C_nominal=C2_nominal,
    final m_flow_nominal=m2_flow_nominal,
    V=m2_flow_nominal*tau2/rho2_nominal) "Volume for fluid 2"
                               annotation (Placement(transformation(extent={{50,10},
            {70,-10}})));

  IDEAS.Fluid.MixingVolumes.MixingVolume vol3(
    redeclare final package Medium = Medium3,
    energyDynamics=if tau3 > Modelica.Constants.eps
                         then energyDynamics else
                         Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=if tau3 > Modelica.Constants.eps
                         then massDynamics else
                         Modelica.Fluid.Types.Dynamics.SteadyState,
    final p_start=p3_start,
    final T_start=T3_start,
    final X_start=X3_start,
    final C_start=C3_start,
    final C_nominal=C3_nominal,
    final m_flow_nominal=m3_flow_nominal,
    V=m3_flow_nominal*tau3/rho3_nominal,
    nPorts=2) "Volume for fluid 3"
   annotation (Placement(transformation(
        origin={0,-60},
        extent={{10,10},{-10,-10}},
        rotation=180)));
  IDEAS.Fluid.MixingVolumes.MixingVolume vol4(
    redeclare final package Medium = Medium4,
    nPorts=2,
    energyDynamics=if tau4 > Modelica.Constants.eps
                         then energyDynamics else
                         Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=if tau4 > Modelica.Constants.eps
                         then massDynamics else
                         Modelica.Fluid.Types.Dynamics.SteadyState,
    final p_start=p4_start,
    final T_start=T4_start,
    final X_start=X4_start,
    final C_start=C4_start,
    final C_nominal=C4_nominal,
    final m_flow_nominal=m4_flow_nominal,
    V=m4_flow_nominal*tau4/rho4_nominal) "Volume for fluid 4"
                               annotation (Placement(transformation(extent={{-50,-10},
            {-70,10}})));

  IDEAS.Fluid.FixedResistances.FixedResistanceDpM preDro1(
    redeclare final package Medium = Medium1,
    final use_dh=false,
    final m_flow_nominal=m1_flow_nominal,
    final deltaM=deltaM1,
    final allowFlowReversal=allowFlowReversal1,
    final show_T=false,
    final from_dp=from_dp1,
    final linearized=linearizeFlowResistance1,
    final homotopyInitialization=homotopyInitialization,
    final dp_nominal=dp1_nominal,
    final dh=1,
    final ReC=4000) "Pressure drop model for fluid 1"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));

  IDEAS.Fluid.FixedResistances.FixedResistanceDpM preDro2(
    redeclare final package Medium = Medium2,
    final use_dh=false,
    final m_flow_nominal=m2_flow_nominal,
    final deltaM=deltaM2,
    final allowFlowReversal=allowFlowReversal2,
    final show_T=false,
    final from_dp=from_dp2,
    final linearized=linearizeFlowResistance2,
    final homotopyInitialization=homotopyInitialization,
    final dp_nominal=dp2_nominal,
    final dh=1,
    final ReC=4000) "Pressure drop model for fluid 2"
    annotation (Placement(transformation(extent={{90,20},{70,40}})));
  IDEAS.Fluid.FixedResistances.FixedResistanceDpM preDro3(
    redeclare final package Medium = Medium3,
    final use_dh=false,
    final m_flow_nominal=m3_flow_nominal,
    final deltaM=deltaM3,
    final allowFlowReversal=allowFlowReversal3,
    final show_T=false,
    final from_dp=from_dp3,
    final linearized=linearizeFlowResistance3,
    final homotopyInitialization=homotopyInitialization,
    final dp_nominal=dp3_nominal,
    final dh=1,
    final ReC=4000) "Pressure drop model for fluid 3"
    annotation (Placement(transformation(extent={{-90,-42},{-70,-22}})));

  IDEAS.Fluid.FixedResistances.FixedResistanceDpM preDro4(
    redeclare final package Medium = Medium4,
    final use_dh=false,
    final m_flow_nominal=m4_flow_nominal,
    final deltaM=deltaM4,
    final allowFlowReversal=allowFlowReversal4,
    final show_T=false,
    final from_dp=from_dp4,
    final linearized=linearizeFlowResistance4,
    final homotopyInitialization=homotopyInitialization,
    final dp_nominal=dp4_nominal,
    final dh=1,
    final ReC=4000) "Pressure drop model for fluid 4"
    annotation (Placement(transformation(extent={{86,-90},{66,-70}})));
protected
  parameter Medium1.ThermodynamicState sta1_nominal=Medium1.setState_pTX(
      T=Medium1.T_default, p=Medium1.p_default, X=Medium1.X_default);
  parameter Modelica.SIunits.Density rho1_nominal=Medium1.density(sta1_nominal)
    "Density, used to compute fluid volume";
  parameter Medium2.ThermodynamicState sta2_nominal=Medium2.setState_pTX(
      T=Medium2.T_default, p=Medium2.p_default, X=Medium2.X_default);
  parameter Modelica.SIunits.Density rho2_nominal=Medium2.density(sta2_nominal)
    "Density, used to compute fluid volume";
  parameter Medium1.ThermodynamicState sta3_nominal=Medium3.setState_pTX(
      T=Medium3.T_default, p=Medium3.p_default, X=Medium3.X_default);
  parameter Modelica.SIunits.Density rho3_nominal=Medium3.density(sta3_nominal)
    "Density, used to compute fluid volume";
  parameter Medium4.ThermodynamicState sta4_nominal=Medium4.setState_pTX(
      T=Medium4.T_default, p=Medium4.p_default, X=Medium4.X_default);
  parameter Modelica.SIunits.Density rho4_nominal=Medium4.density(sta4_nominal)
    "Density, used to compute fluid volume";

  parameter Medium1.ThermodynamicState sta1_start=Medium1.setState_pTX(
      T=T1_start, p=p1_start, X=X1_start);
  parameter Modelica.SIunits.SpecificEnthalpy h1_outflow_start = Medium1.specificEnthalpy(sta1_start)
    "Start value for outflowing enthalpy";
  parameter Medium2.ThermodynamicState sta2_start=Medium2.setState_pTX(
      T=T2_start, p=p2_start, X=X2_start);
  parameter Modelica.SIunits.SpecificEnthalpy h2_outflow_start = Medium2.specificEnthalpy(sta2_start)
    "Start value for outflowing enthalpy";
  parameter Medium3.ThermodynamicState sta3_start=Medium3.setState_pTX(
      T=T3_start, p=p3_start, X=X3_start);
  parameter Modelica.SIunits.SpecificEnthalpy h3_outflow_start = Medium3.specificEnthalpy(sta3_start)
    "Start value for outflowing enthalpy";
  parameter Medium4.ThermodynamicState sta4_start=Medium4.setState_pTX(
      T=T4_start, p=p4_start, X=X4_start);
  parameter Modelica.SIunits.SpecificEnthalpy h4_outflow_start = Medium4.specificEnthalpy(sta4_start)
    "Start value for outflowing enthalpy";

initial algorithm
  // Check for tau1
  assert((energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) or
          tau1 > Modelica.Constants.eps,
"The parameter tau1, or the volume of the model from which tau may be derived, is unreasonably small.
 You need to set energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState to model steady-state.
 Received tau1 = " + String(tau1) + "\n");
  assert((massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) or
          tau1 > Modelica.Constants.eps,
"The parameter tau1, or the volume of the model from which tau may be derived, is unreasonably small.
 You need to set massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState to model steady-state.
 Received tau1 = " + String(tau1) + "\n");

 // Check for tau2
  assert((energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) or
          tau2 > Modelica.Constants.eps,
"The parameter tau2, or the volume of the model from which tau may be derived, is unreasonably small.
 You need to set energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState to model steady-state.
 Received tau2 = " + String(tau2) + "\n");
  assert((massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) or
          tau2 > Modelica.Constants.eps,
"The parameter tau2, or the volume of the model from which tau may be derived, is unreasonably small.
 You need to set massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState to model steady-state.
 Received tau2 = " + String(tau2) + "\n");

  // Check for tau1
  assert((energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) or
          tau3 > Modelica.Constants.eps,
"The parameter tau3, or the volume of the model from which tau may be derived, is unreasonably small.
 You need to set energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState to model steady-state.
 Received tau3 = " + String(tau3) + "\n");
  assert((massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) or
          tau3 > Modelica.Constants.eps,
"The parameter tau3, or the volume of the model from which tau may be derived, is unreasonably small.
 You need to set massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState to model steady-state.
 Received tau3 = " + String(tau3) + "\n");

 // Check for tau2
  assert((energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) or
          tau4 > Modelica.Constants.eps,
"The parameter tau4, or the volume of the model from which tau may be derived, is unreasonably small.
 You need to set energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState to model steady-state.
 Received tau4 = " + String(tau4) + "\n");
  assert((massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) or
          tau4 > Modelica.Constants.eps,
"The parameter tau4, or the volume of the model from which tau may be derived, is unreasonably small.
 You need to set massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState to model steady-state.
 Received tau4 = " + String(tau4) + "\n");

equation
  connect(vol1.ports[2], port_b1) annotation (Line(
      points={{2,80},{100,80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_a1, preDro1.port_a) annotation (Line(
      points={{-100,80},{-90,80},{-90,80},{-80,80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(preDro1.port_b, vol1.ports[1]) annotation (Line(
      points={{-60,80},{-2,80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_a2, preDro2.port_a) annotation (Line(
      points={{100,30},{90,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(preDro4.port_a, port_a4) annotation (Line(
      points={{86,-80},{100,-80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(preDro4.port_b, vol4.ports[1]) annotation (Line(
      points={{66,-80},{-58,-80},{-58,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_b4, vol4.ports[2]) annotation (Line(
      points={{-100,-80},{-62,-80},{-62,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_a3, preDro3.port_a) annotation (Line(
      points={{-100,-32},{-90,-32}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(preDro3.port_b, vol3.ports[1]) annotation (Line(
      points={{-70,-32},{-54,-32},{-54,-76},{-2,-76},{-2,-70}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_b3, vol3.ports[2]) annotation (Line(
      points={{100,-30},{90,-30},{90,-66},{62,-66},{62,-76},{2,-76},{2,-70}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_b2, vol2.ports[1]) annotation (Line(
      points={{-100,30},{58,30},{58,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(preDro2.port_b, vol2.ports[2]) annotation (Line(
      points={{70,30},{62,30},{62,10}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    Documentation(info="<html>
<p>
This component transports two fluid streams between four ports.
It provides the basic model for implementing a dynamic heat exchanger.
</p>
<p>
The model can be used as-is, although there will be no heat or mass transfer
between the two fluid streams.
To add heat transfer, heat flow can be added to the heat port of the two volumes.
See for example
<a href=\"IDEAS.Fluid.Chillers.Carnot\">
IDEAS.Fluid.Chillers.Carnot</a>.
To add moisture input into (or moisture output from) volume <code>vol2</code>,
the model can be replaced as shown in
<a href=\"modelica://IDEAS.Fluid.HeatExchangers.BaseClasses.HexElement\">
IDEAS.Fluid.HeatExchangers.BaseClasses.HexElement</a>.
</p>
<h4>Implementation</h4>
<p>
The variable names follow the conventions used in
<a href=\"modelica://Modelica.Fluid.HeatExchangers.BasicHX\">
Modelica.Fluid.HeatExchangers.BasicHX</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 6, 2014, by Michael Wetter:<br/>
Changed medium declaration in pressure drop elements to be final.
</li>
<li>
May 28, 2014, by Michael Wetter:<br/>
Removed <code>annotation(Evaluate=true)</code> for parameters <code>tau1</code>
and <code>tau2</code>.
This is needed to allow changing the time constant after translation.
</li>
<li>
November 12, 2013, by Michael Wetter:<br/>
Removed <code>import Modelica.Constants</code> statement.
</li>
<li>
October 8, 2013, by Michael Wetter:<br/>
Removed parameter <code>show_V_flow</code>.
</li>
<li>
September 26, 2013, by Michael Wetter:<br/>
Removed unrequired <code>sum</code> operator.
</li>
<li>
February 6, 2012, by Michael Wetter:<br/>
Updated documentation.
</li>
<li>
February 3, 2012, by Michael Wetter:<br/>
Removed assignment of <code>m_flow_small</code> as it is no
longer used in its base class.
</li>
<li>
July 29, 2011, by Michael Wetter:
<ul>
<li>
Changed values of
<code>h_outflow_a1_start</code>,
<code>h_outflow_b1_start</code>,
<code>h_outflow_a2_start</code> and
<code>h_outflow_b2_start</code>, and
declared them as final.
</li>
<li>
Set nominal values for <code>vol1.C</code> and <code>vol2.C</code>.
</li>
</ul>
</li>
<li>
July 11, 2011, by Michael Wetter:<br/>
Changed parameterization of fluid volume so that steady-state balance is
used when <code>tau = 0</code>.
</li>
<li>
March 25, 2011, by Michael Wetter:<br/>
Added homotopy operator.
</li>
<li>
April 13, 2009, by Michael Wetter:<br/>
Added model to compute flow friction.
</li>
<li>
September 10, 2008 by Michael Wetter:<br/>
Added <code>stateSelect=StateSelect.always</code> for temperature of volume 1.
</li>
<li>
Changed temperature sensor from Celsius to Kelvin.
Unit conversion should be made during output
processing.
<li>
August 5, 2008, by Michael Wetter:<br/>
Replaced instances of <code>Delays.DelayFirstOrder</code> with instances of
<code>MixingVolumes.MixingVolume</code>. This allows to extract liquid for a condensing cooling
coil model.
</li>
<li>
March 25, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={1,1}), graphics={
        Rectangle(
          extent={{-70,93},{69,-100}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-99,85},{102,75}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-98,35},{103,25}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-96,-27},{105,-37}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-101,-78},{100,-88}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics));
end HeightPortHeatMassExchanger;
