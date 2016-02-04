within IDEAS.Fluid.HeatExchangers.RadiantSlab;
model EmbeddedPipe
  "Embedded pipe model based on prEN 15377 and (Koschenz, 2000), water capacity lumped to TOut"
  extends IDEAS.Fluid.HeatExchangers.Interfaces.EmissionTwoPort;
  extends IDEAS.Fluid.Interfaces.LumpedVolumeDeclarations;
  replaceable parameter
    IDEAS.Fluid.HeatExchangers.RadiantSlab.BaseClasses.RadiantSlabChar RadSlaCha constrainedby
    IDEAS.Fluid.HeatExchangers.RadiantSlab.BaseClasses.RadiantSlabChar
    "Properties of the floor heating or TABS, if present"
    annotation (choicesAllMatching=true);
  final parameter Modelica.SIunits.Length pipeDiaInt = RadSlaCha.d_a - 2*RadSlaCha.s_r
    "Pipe internal diameter";
  extends IDEAS.Fluid.Interfaces.PartialTwoPortInterface;
  extends IDEAS.Fluid.Interfaces.TwoPortFlowResistanceParameters(
    computeFlowResistance=false,
    dp_nominal=Modelica.Fluid.Pipes.BaseClasses.WallFriction.Detailed.pressureLoss_m_flow(
      m_flow=m_flow_nominal/nParCir,
      rho_a=rho_default,
      rho_b=rho_default,
      mu_a=mu_default,
      mu_b=mu_default,
      length=pipeEqLen/nParCir,
      diameter=pipeDiaInt,
      roughness=roughness,
      m_flow_small=m_flow_small/nParCir));
  parameter Modelica.SIunits.Area A_floor "Floor/tabs surface area";
  parameter Integer nDiscr(min=1) = 1
    "Number of series discretisations along the flow direction"
    annotation(Evaluate=true);
  parameter Real nParCir(min=1) = 1 "Number of parallel circuits in the tabs"
    annotation(Evaluate=true);
  parameter Modelica.SIunits.Length roughness(min=0) = 2.5e-5
    "Absolute roughness of pipe, with a default for a smooth steel pipe"
    annotation(Dialog(tab="Flow resistance"));
  parameter Modelica.SIunits.Length L_floor = A_floor^(1/2)
    "Floor length - along the pipe direction"
    annotation(Dialog(tab="Flow resistance"));
  parameter Real N_pipes = A_floor/L_floor/RadSlaCha.T - 1
    "Number of parallel pipes in the slab"
annotation(Dialog(tab="Flow resistance"));
  parameter Modelica.SIunits.Length pipeBendEqLen = 2*(N_pipes-1)*(2.267*RadSlaCha.T/2/pipeDiaInt+6.18)*pipeDiaInt
    "Pipe bends equivalent length, default according to Fox and McDonald (chapter 8.7, twice the linearized losses of a 90 degree bend)"
annotation(Dialog(tab="Flow resistance"));
  parameter Modelica.SIunits.Length pipeEqLen = pipeBendEqLen + (L_floor-2*RadSlaCha.T)*N_pipes
    "Total pipe equivalent length, default assuming 180 dg turns starting at RadSlaCha.T from the end of the slab"
annotation(Dialog(tab="Flow resistance"));
  parameter Modelica.SIunits.MassFlowRate m_flowMin = m_flow_nominal*0.5
    "Minimal flowrate when in operation - used for validity check"
    annotation(Dialog(group="Nominal condition"));

  final parameter Modelica.SIunits.ThermalInsulance R_r_val=RadSlaCha.T*log(RadSlaCha.d_a
      /pipeDiaInt)/(2*Modelica.Constants.pi*RadSlaCha.lambda_r)
    "Fix resistance value of thermal conduction through pipe wall * surface of floor between 2 pipes (see RadSlaCha documentation)";
  //Calculation of the resistance from the outer pipe wall to the center of the tabs / floorheating. eqn 4-25 Koschenz
  final parameter Modelica.SIunits.ThermalInsulance R_x_val=RadSlaCha.T*(log(RadSlaCha.T
      /(3.14*RadSlaCha.d_a)) + corr)/(2*Modelica.Constants.pi*RadSlaCha.lambda_b)
    "Fix resistance value of thermal conduction from pipe wall to layer";
  final parameter Real corr = if RadSlaCha.tabs then 0 else
    sum( -(RadSlaCha.alp2/RadSlaCha.lambda_b * RadSlaCha.T - 2*3.14*s)/(RadSlaCha.alp2/RadSlaCha.lambda_b * RadSlaCha.T + 2*3.14*s)*exp(-4*3.14*s/RadSlaCha.T*RadSlaCha.S_2)/s for s in 1:10) "correction factor for the floor heating according to Multizone Building modeling with Type56 and TRNBuild (see documentation). 
    If tabs is used, corr=0 - fixme: deprecated?";

  parameter Boolean from_dp = false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(tab="Advanced"));
  parameter Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(Evaluate=true, Dialog(tab="Advanced"));
  parameter Boolean linearized = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Evaluate=true, Dialog(tab="Advanced"));
  parameter Boolean useSimplifiedRt = m_flowMin/A_floor > 5/3600
    "Use a simplified calculation for Rt? default: if specific mass flow rate is higher than 5 kg/hm2 (see Koschenz p.25)"
    annotation(Evaluate=true, Dialog(tab="Assumptions"));
  parameter Modelica.SIunits.ThermalInsulance R_c = 1/(RadSlaCha.lambda_b/RadSlaCha.S_1 + RadSlaCha.lambda_b/RadSlaCha.S_2)
    "Specific thermal resistivity of (parallel) slabs connected to top and bottom of tabs"
    annotation(Dialog(group="Thermal"));

  Modelica.SIunits.Temperature[nDiscr] Tin = cat(1, {senTemIn.T}, vol[1:nDiscr-1].heatPort.T);
  Modelica.SIunits.Power[nDiscr] Q "Thermal power going into tabs";
  //For high flow rates see [Koshenz, 2000] eqn 4.37 in between
  // for laminar flow Nu_D = 4 is assumed: correlation for heat transfer constant heat flow and constant wall temperature
  Modelica.SIunits.ThermalInsulance R_w_val= IDEAS.Utilities.Math.Functions.spliceFunction(
    x=rey-(reyHi+reyLo)/2,
    pos=RadSlaCha.T^0.13/8/Modelica.Constants.pi*abs((pipeDiaInt/(m_flowSpLimit*L_r)))^0.87,
    neg=RadSlaCha.T/(4*Medium.thermalConductivity(sta_default)*Modelica.Constants.pi),
    deltax=(reyHi-reyLo)/2)
    "Flow dependent resistance value of convective heat transfer inside pipe for both turbulent and laminar heat transfer.";
  Modelica.SIunits.ThermalInsulance R_t
    "Total equivalent specific resistivity as defined by Koschenz in eqn 4-59";
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b[nDiscr] heatPortEmb
    "Port to the core of a floor heating/concrete activation"
    annotation (Placement(transformation(extent={{-10,90},{10,110}}),
        iconTransformation(extent={{-10,90},{10,110}})));
  //Reynold number Re = ( (m_flow / rho / A) * D * rho )  / mu / numParCir.
  Modelica.SIunits.ReynoldsNumber rey=
    m_flow/nParCir/A_pipe*pipeDiaInt/mu_default "Reynolds number";

  IDEAS.Fluid.MixingVolumes.MixingVolume[nDiscr] vol(each nPorts=2, each m_flow_nominal = m_flow_nominal, each V=m/nDiscr/rho_default,
    redeclare each package Medium = Medium,
    each p_start=p_start,
    each T_start=T_start,
    each X_start=X_start,
    each C_start=C_start,
    each C_nominal=C_nominal,
    each allowFlowReversal=allowFlowReversal,
    each mSenFac=mSenFac,
    each m_flow_small=m_flow_small,
    each final prescribedHeatFlowRate=true,
    each energyDynamics=energyDynamics,
    each massDynamics=massDynamics)
    annotation (Placement(transformation(extent={{-50,0},{-70,20}})));

  IDEAS.Fluid.FixedResistances.ParallelFixedResistanceDpM res(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    final dp_nominal=dp_nominal,
    final use_dh=true,
    allowFlowReversal=allowFlowReversal,
    from_dp=from_dp,
    homotopyInitialization=homotopyInitialization,
    linearized=linearized,
    dp(nominal=L_r*10),
    computeFlowResistance=computeFlowResistance,
    final nParCir=nParCir,
    final dh=pipeDiaInt,
    final ReC=reyHi)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  IDEAS.Fluid.Sensors.Temperature senTemIn(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-110,18},{-90,38}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow[nDiscr] heatFlowWater
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow[nDiscr] heatFlowSolid
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Modelica.Blocks.Math.Gain[nDiscr] negate(each k=-1)
    annotation (Placement(transformation(extent={{-56,36},{-48,44}})));
  Modelica.Blocks.Sources.RealExpression[nDiscr] Q_tabs(y=Q)
    annotation (Placement(transformation(extent={{-100,50},{-72,70}})));

protected
  final parameter Modelica.SIunits.Length L_r=A_floor/RadSlaCha.T/nParCir
    "Length of one of the parallel circuits";
  final parameter Modelica.SIunits.Area A_pipe=
    Modelica.Constants.pi/4*pipeDiaInt^2
    "Pipe internal cross section surface area";
  final parameter Medium.ThermodynamicState sta_default=
     Medium.setState_pTX(T=Medium.T_default, p=Medium.p_default, X=Medium.X_default);
  final parameter Modelica.SIunits.Density rho_default = Medium.density(sta_default);
  final parameter Modelica.SIunits.DynamicViscosity mu_default = Medium.dynamicViscosity(sta_default)
    "Dynamic viscosity at nominal condition";
  final parameter Modelica.SIunits.SpecificHeatCapacity cp_default = Medium.specificHeatCapacityCp(sta_default)
    "Heat capacity at nominal condition";
  final parameter Modelica.SIunits.MassFlowRate m_flow_nominal_pos = abs(m_flow_nominal)
    "Absolute value of nominal flow rate";
  final parameter Modelica.SIunits.MassFlowRate m_flow_turbulent =  mu_default*pipeDiaInt/4*Modelica.Constants.pi*reyHi
    "Turbulent flow if |m_flow| >= m_flow_turbulent";
  final parameter Modelica.SIunits.Pressure dp_nominal_pos = abs(dp_nominal)
    "Absolute value of nominal pressure";
  final parameter Modelica.SIunits.ReynoldsNumber reyLo=2700
    "Reynolds number where transition to turbulence starts"
    annotation(Evaluate=true);
  final parameter Modelica.SIunits.ReynoldsNumber reyHi=4000
    "Reynolds number where transition to turbulence ends"
    annotation(Evaluate=true);
  final parameter Real deltaXR = m_flow_nominal/A_floor*cp_default/1000
    "Transition threshold for regularization function";
  final parameter Modelica.SIunits.ThermalInsulance R_w_val_min=
  IDEAS.Utilities.Math.Functions.spliceFunction(x=m_flowMin/nParCir/A_pipe*pipeDiaInt/mu_default-(reyHi+reyLo)/2,
    pos=RadSlaCha.T^0.13/8/Modelica.Constants.pi*abs((pipeDiaInt/(m_flow_nominal/A_floor*L_r)))^0.87,
    neg=RadSlaCha.T/(4*Medium.thermalConductivity(sta_default)*Modelica.Constants.pi),
    deltax=(reyHi-reyLo)/2)
    "Lowest value for R_w that is expected for the set mass flow rate";
  final parameter Modelica.SIunits.Mass m(start=1) = A_pipe*L_r*rho_default
    "Mass of medium";
  Real m_flowSp(unit="kg/(m2.s)")=port_a.m_flow/A_floor
    "mass flow rate per unit floor area";
  Real m_flowSpLimit = IDEAS.Utilities.Math.Functions.smoothMax(m_flowSp, m_flow_nominal/A_floor/100, m_flow_nominal/A_floor/100)
    "Specific mass flow rate regularized for no flow conditions";

initial equation
   assert(m_flowMin/A_floor*Medium.specificHeatCapacityCp(sta_default)*(R_w_val_min + R_r_val + R_x_val)*nDiscr >= 0.5,
     "Model is not valid for the set nominal and minimal mass flow rate, discretisation in multiple parts is required");
  if RadSlaCha.tabs then
    assert(RadSlaCha.S_1 > 0.3*RadSlaCha.T, "Thickness of the concrete or screed layer above the tubes is smaller than 0.3 * the tube interdistance. 
    The model is not valid for this case");
    assert(RadSlaCha.S_2 > 0.3*RadSlaCha.T, "Thickness of the concrete or screed layer under the tubes is smaller than 0.3 * the tube interdistance. 
      The model is not valid for this case");
  else
    assert(RadSlaCha.alp2 < 1.212, "In order to use the floor heating model, RadSlaCha.alp2 need to be < 1.212");
    assert(RadSlaCha.d_a/2 < RadSlaCha.S_2, "In order to use the floor heating model, RadSlaCha.alp2RadSlaCha.d_a/2 < RadSlaCha.S_2 needs to be true");
    assert(RadSlaCha.S_1/RadSlaCha.T <0.3, "In order to use the floor heating model, RadSlaCha.S_1/RadSlaCha.T <0.3 needs to be true");
  end if;

equation
  // simplify expression for sufficiently large mass flow rates
  if useSimplifiedRt then
    // Koschenz eq 4-60
    R_t = (IDEAS.Utilities.Math.Functions.inverseXRegularized(2*m_flowSpLimit*cp_default*nDiscr, deltaXR) + R_w_val + R_r_val + R_x_val);
  else
    // Koschenz eq 4-59
    R_t = (IDEAS.Utilities.Math.Functions.inverseXRegularized(m_flowSpLimit*cp_default*nDiscr*(1-exp(-1/((R_w_val+R_r_val+R_x_val+R_c)*m_flowSpLimit*cp_default*nDiscr))), deltaXR)-R_c);
  end if;
  // no smoothmin since this undershoots for near-zero values
  Q = (Tin - heatPortEmb.T)*min(1/R_t*A_floor/nDiscr, abs(m_flow)*cp_default);

  connect(res.port_b, port_b) annotation (Line(
         points={{40,0},{100,0}},
       color={0,127,255},
       smooth=Smooth.None));
  connect(port_a, vol[1].ports[1]) annotation (Line(
       points={{-100,0},{-58,0}},
       color={0,127,255},
              smooth=Smooth.None));
  connect(res.port_a, vol[nDiscr].ports[2]) annotation (Line(
       points={{20,0},{-62,0}},
       color={0,127,255},
       smooth=Smooth.None));

  for i in 2:nDiscr loop
    connect(vol[i-1].ports[2], vol[i].ports[1]) annotation (Line(
      points={{-62,0},{-58,0}},
      color={0,127,255},
      smooth=Smooth.None));
  end for;

  connect(senTemIn.port, port_a) annotation (Line(
      points={{-100,18},{-100,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heatFlowWater.port, vol.heatPort) annotation (Line(
      points={{-20,40},{-20,10},{-50,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heatFlowWater.Q_flow, negate.y) annotation (Line(
      points={{-40,40},{-47.6,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(negate.u, Q_tabs.y) annotation (Line(
      points={{-56.8,40},{-60,40},{-60,60},{-70.6,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heatFlowSolid.Q_flow, Q_tabs.y) annotation (Line(
      points={{-40,80},{-60,80},{-60,60},{-70.6,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heatFlowSolid.port, heatPortEmb) annotation (Line(
      points={{-20,80},{0,80},{0,100}},
      color={191,0,0},
      smooth=Smooth.None));

   annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),
         graphics={
        Ellipse(
          extent={{-20,22},{20,-20}},
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-95,6},{106,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-102,-4},{-2,6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-20,22},{20,-20}},
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-80,60},{80,-60}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-66,60},{-66,-60}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{66,60},{66,-60}},
          color={0,0,0},
          smooth=Smooth.None),
        Polygon(
          points={{-66,60},{-66,-60},{66,-60},{-66,60}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Forward)}),
    Documentation(info="<html>
<p>
Dynamic model of an embedded pipe for a concrete core activation. 
This model is based on (Koschenz, 2000). 
In addition the model provides the options to simulate the concrete 
core activation as if there were multiple parallel branches. 
This affects the pressure drop calculation and also the thermal calculations.
</p>
<h4>Assumptions and limitations</h4>
<p>
The model has a limited validity range. 
Its validity will be checked using assert statements. 
Possibly the discretization needs to be 
increased using parameter <code>nDiscr</code>.
An alternative is to increase <code>m_flow_min</code>, 
but this limits the validity range of the model.
</p>
<h4>Typical use and important parameters</h4>
<p>
The embeddedPipe model is to be used together with an InternalWall component. 
Multiple InternalWalls may be required if the EmbeddedPipe is discretized (using <code>nDiscr</code>).
</p>
<p>
Following parameters need to be set:
</p>
<ul>
<li>RadSlaCha is a record with all the parameters of the geometry, materials and even number of discretization layers in the nakedTabs model.</li>
<li>mFlow_min is used to check the validity of the operating conditions and is by default half of the nominal mass flow rate.</li>
<li><code>A_floor</code> is the surface area of (one side of) the Thermally Activated Building part (TAB). </li>
<li><code>nDiscr</code> can be used for discretizing the EmbeddedPipe along the flow direction. This may be necessary to be in the validity range of the model.</li>
<li><code>nParCir</code> can be used for calculating the pressure drops as if there were multiple EmbeddedPipes connected in parallel. The total mass flow rate is then split over multiple circuits and the pressure drop is calculated accordingly.</li>
<li><code>R_C</code> is the thermal resistivity from the center of the tabs to the zones. Note that the upper and lower resistivities need to be calculated as if they were in parallel. This parameter has a default value based on RadSlaCha but it may be improved if necessary. The impact of the value of this parameter on the model performance is low except in cases of very low mass flow rates.</li>
</ul>
<h4>Options</h4>
<p>
By default pressure drops are not calculated (<code>dp = 0</code>). 
These can be enabled by setting parameter <code>computeFlowResistance = true</code>. 
Pressure drops are then calculated by default by making an estimate of the total pipe length. 
This pressure drop can be a large underestimation of the real pressure drop. 
The used pipe lengths can be changed in the Pressure drop tab.
Parameter <code>dp_nominal</code> can be used to override the default calculation.
</p>
<h4>Validation </h4>
<p>
A limited verification has been performed in IDEAS.Fluid.HeatExchangers.RadiantSlab.Examples.EmbeddedPipeVerification.
</p>
<h4>References</h4>
<p>[Koshenz, 2000] - Koschenz, Markus, and Beat Lehmann. 2000. <i>Thermoaktive Bauteilsysteme - Tabs</i>. D&uuml;bendorf: EMPA D&uuml;bendorf. </p>
<p>[TRNSYS, 2007] - Multizone Building modeling with Type 56 and TRNBuild.</p>
</html>", revisions="<html>
<p><ul>
<li>2015 November, Filip Jorissen: Revised implementation for small flow rates: v3: replaced SmoothMin by min function</li>
<li>2015 November, Filip Jorissen: Revised implementation for small flow rates: v2</li>
<li>2015 November, Filip Jorissen: Revised implementation for small flow rates</li>
<li>2015, Filip Jorissen: Revised implementation</li>
<li>2014 March, Filip Jorissen: IDEAS baseclasses</li>
<li>2013 May, Roel De Coninck: documentation</li>
<li>2012 April, Roel De Coninck: rebasing on common Partial_Emission</li>
<li>2011, Roel De Coninck: first version and validation</li>
</ul></p>
</html>"));
end EmbeddedPipe;
