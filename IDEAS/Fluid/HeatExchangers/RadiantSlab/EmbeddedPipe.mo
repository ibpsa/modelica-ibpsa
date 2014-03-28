within IDEAS.Fluid.HeatExchangers.RadiantSlab;
model EmbeddedPipe
  "Embedded pipe model based on prEN 15377 and (Koschenz, 2000), water capacity lumped to TOut"
  import IDEAS;

  extends
    IDEAS.Fluid.HeatExchangers.RadiantSlab.Interfaces.Partial_EmbeddedPipe;

  // General model parameters ////////////////////////////////////////////////////////////////
  // in partial: parameter SI.MassFlowRate m_flowMin "Minimal flowrate when in operation";
  final parameter Modelica.SIunits.Length L_r=FHChars.A_Floor/FHChars.T
    "Length of the circuit";

  // Resistances ////////////////////////////////////////////////////////////////
  // there is no R_z in the model because I explicitly simulate the dynamics of the water
  // SI.ThermalResistance R_z "Flowrate dependent thermal resistance of pipe length";
  Modelica.SIunits.ThermalInsulance R_w
    "Flow dependent resistance of convective heat transfer inside pipe, only valid if turbulent flow (see assert in initial equation)";
  //Real R_w_debug[2]={(FHChars.d_a - 2*FHChars.s_r), (m_flowSp * L_r)};
  final parameter Modelica.SIunits.ThermalInsulance R_r=FHChars.T*log(FHChars.d_a
      /(FHChars.d_a - 2*FHChars.s_r))/(2*Modelica.Constants.pi*FHChars.lambda_r)
    "Fix resistance of thermal conduction through pipe wall";

  //Calculation of the resistance from the outer pipe wall to the center of the tabs / floorheating.
  final parameter Real corr = if FHChars.tabs then 0 else sum( -(FHChars.alp2/FHChars.lambda_b * FHChars.T - 2*3.14*s)/(FHChars.alp2/FHChars.lambda_b * FHChars.T + 2*3.14*s)*exp(-4*3.14*s/FHChars.T*FHChars.S_2)/s for s in 1:100)
    "correction factor for the floor heating. If tabs is used, corr=0";
 // parameter Real test = FHChars.T*log(FHChars.T /(3.14*FHChars.d_a));
  final parameter Modelica.SIunits.ThermalInsulance R_x=FHChars.T*(log(FHChars.T
      /(3.14*FHChars.d_a)) + corr)/(2*3.14*FHChars.lambda_b)
    "Fix resistance of thermal conduction from pipe wall to layer";

  // Auxiliary parameters and variables ////////////////////////////////////////////////////////////////
  final parameter Modelica.SIunits.Mass mMedium=Modelica.Constants.pi/4*(
      FHChars.d_a - 2*FHChars.s_r)^2*L_r*Medium.density_pTX(Medium.p_default, Medium.T_default, Medium.X_default)
    "Mass of the water in the tube";

  final parameter Real rey=
    m_flowMin*(FHChars.d_a - 2*FHChars.s_r)*Medium.density(state_default)/(
    Medium.dynamicViscosity(state_default)*Modelica.Constants.pi/4*(FHChars.d_a - 2*FHChars.s_r)^2)
    "Fix Reynolds number for assert of turbulent flow";
  Real m_flowSp=flowPort_a.m_flow/FHChars.A_Floor "in kg/s.m2";
  Real m_flowMinSp=m_flowMin/FHChars.A_Floor "in kg/s.m2";
  Modelica.SIunits.Velocity flowSpeed=flowPort_a.m_flow/Medium.density(state_default)/(Modelica.Constants.pi
      /4*(FHChars.d_a - 2*FHChars.s_r)^2);

  Modelica.Thermal.HeatTransfer.Components.ThermalConductor resistance_x(G=
        FHChars.A_Floor/R_x) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={46,0})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor resistance_r(G=
        FHChars.A_Floor/R_r) annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={12,0})));
  IDEAS.HeatTransfer.VariableThermalConductor resistance_w annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-20,0})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature theta_w
    "Average temperature in the pipe" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-54,0})));

  //fixme: update documentation regarding information about used values for density and viscosity
protected
  constant Medium.ThermodynamicState state_default= Medium.setState_pTX(Medium.p_default, TInitial, Medium.X_default)
    "Default state for calculation of density, viscosity, ...";
  Medium.ThermodynamicState state_medium
    "State of the medium in the control volume";
public
  Modelica.Blocks.Sources.RealExpression conductance(y=FHChars.A_Floor/R_w)
    "Floor heating conductance"
    annotation (Placement(transformation(extent={{-76,14},{-40,34}})));
  Modelica.Blocks.Sources.RealExpression T_water(y=Medium.temperature(
        state_medium)) "Average water temperature"
    annotation (Placement(transformation(extent={{-98,-10},{-78,10}})));
initial equation
  assert(rey > 2700,
    "The minimal flowrate leads to laminar flow.  Adapt the model (specifically R_w) to these conditions");
  assert(m_flowMinSp*Medium.specificHeatCapacityCp(state_default)*(R_w + R_r + R_x) >= 0.5,
    "Model is not valid, division in n parts is required");
  if FHChars.tabs then
    assert(FHChars.S_1 > 0.3*FHChars.T, "Thickness of the concrete or screed layer above the tubes is smaller than 0.3 * the tube interdistance. 
    The model is not valid for this case");
    assert(FHChars.S_2 > 0.3*FHChars.T, "Thickness of the concrete or screed layer under the tubes is smaller than 0.3 * the tube interdistance. 
      The model is not valid for this case");
  else
    assert(FHChars.alp2 < 1.212, "In order to use the floor heating model, FHChars.alp2 need to be < 1.212");
    assert(FHChars.d_a/2 < FHChars.S_2, "In order to use the floor heating model, FHChars.alp2FHChars.d_a/2 < FHChars.S_2 needs to be true");
    assert(FHChars.S_1/FHChars.T <0.3, "In order to use the floor heating model, FHChars.S_1/FHChars.T <0.3 needs to be true");
  end if;

  //fixme: write this without algorithm?
algorithm
  if noEvent(abs(flowPort_a.m_flow) > m_flowMin/10) then
    hIn := inStream(flowPort_a.h_outflow);
    hMean := (hIn + hOut)/2;
    R_w := FHChars.T^0.13/8/Modelica.Constants.pi*abs(((FHChars.d_a - 2*FHChars.s_r)
      /(m_flowSp*L_r)))^0.87;
    //assert(noEvent(flowSpeed >= 0.05), "Attention, flowSpeed in the floorheating is smaller than 0.05 m/s");
    //assert(noEvent(flowSpeed <= 0.5), "Attention, flowSpeed in the floorheating is larger than 0.5 m/s");
  else
    hIn := hOut;
    hMean := hOut;
    R_w := FHChars.T/(200*(FHChars.d_a - 2*FHChars.s_r)*Modelica.Constants.pi);
  end if;

equation
  // fixme: X_default ok? -> mention in documentation
  state_medium=Medium.setState_phX(flowPort_a.p, hMean, Medium.X_default);

  // mass balance
  flowPort_a.m_flow + flowPort_b.m_flow = 0;

  // no pressure drop
  flowPort_a.p = flowPort_b.p;

  // energy balance
  //fixme: is this approximation correct? can a mixingvolume be used instead?
  // the mass is lumped to hOut!  TOut will be DIFFERENT from TMean (when there is a flowrate)
  inStream(flowPort_a.h_outflow)*flowPort_a.m_flow + flowPort_b.h_outflow*flowPort_b.m_flow + theta_w.port.Q_flow = mMedium*der(hOut);

  //fixme: only for one-directional flow -> ok in documentation?
  //fixme: zero flow ok?
  //fixme: line below is not ok for reversed flow
  flowPort_a.h_outflow=hOut;
  flowPort_a.h_outflow=flowPort_b.h_outflow;
  flowPort_a.Xi_outflow=flowPort_b.Xi_outflow;
  flowPort_a.C_outflow=flowPort_b.C_outflow;

  connect(resistance_r.port_b, resistance_x.port_a) annotation (Line(
      points={{22,-1.22465e-015},{29,-1.22465e-015},{29,1.22465e-015},{36,
          1.22465e-015}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(resistance_w.port_b, resistance_r.port_a) annotation (Line(
      points={{-10,-1.22465e-015},{-4,-1.22465e-015},{-4,1.22465e-015},{2,
          1.22465e-015}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(theta_w.port, resistance_w.port_a) annotation (Line(
      points={{-44,0},{-38,0},{-38,1.22465e-015},{-30,1.22465e-015}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(resistance_x.port_b, heatPortEmb) annotation (Line(
      points={{56,-1.22465e-015},{62,-1.22465e-015},{62,62},{-50,62},{-50,58}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(T_water.y, theta_w.T) annotation (Line(
      points={{-77,0},{-66,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conductance.y, resistance_w.G) annotation (Line(
      points={{-38.2,24},{-36,24},{-36,6},{-30.8,6}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{140,
            60}}),
            graphics),
    Icon(graphics),
    Documentation(info="<html>
<p><b>Description</b> </p>
<p>Dynamic model of an embedded pipe for a concrete core activation or a floor heating element. This&nbsp;model&nbsp;is&nbsp;based&nbsp;on&nbsp;the&nbsp;norm&nbsp;prEN&nbsp;15377&nbsp;for&nbsp;the&nbsp;nomenclature&nbsp;but&nbsp;relies&nbsp;more&nbsp;on&nbsp;the&nbsp;background&nbsp;as&nbsp;developed&nbsp;in&nbsp;(Koschenz,&nbsp;2000).&nbsp;The R_x for the floor heating is calculated according to the TRNSYS guide lines (TRNSYS, 2007)  There&nbsp;is&nbsp;one&nbsp;major&nbsp;deviation:&nbsp;instead&nbsp;of&nbsp;calculating&nbsp;R_z&nbsp;(to&nbsp;get&nbsp;the&nbsp;mean&nbsp;water&nbsp;temperature&nbsp;in&nbsp;the&nbsp;tube&nbsp;from&nbsp;the&nbsp;supply&nbsp;temperature&nbsp;and&nbsp;flowrate),&nbsp;this&nbsp;mean&nbsp;water&nbsp;temperatue&nbsp;is&nbsp;modelled&nbsp;specifically,&nbsp;based&nbsp;on&nbsp;the&nbsp;mass&nbsp;of&nbsp;the&nbsp;water&nbsp;in&nbsp;the&nbsp;system.<code><font style=\"color: #006400; \">&nbsp;&nbsp;</font></code></p>
<p>The water&nbsp;mass is lumped&nbsp;to&nbsp;TOut.&nbsp;&nbsp;This&nbsp;seems&nbsp;to&nbsp;give&nbsp;the&nbsp;best&nbsp;results (see validation).&nbsp;&nbsp;When&nbsp;lumping&nbsp;to&nbsp;TMean&nbsp;there&nbsp;are&nbsp;additional&nbsp;algebraic&nbsp;constraints&nbsp;to&nbsp;be&nbsp;imposed&nbsp;on&nbsp;TOut&nbsp;which&nbsp;is&nbsp;not so elegant.&nbsp;For most simulations, TOut&nbsp;is&nbsp;more&nbsp;important&nbsp;(influences&nbsp;efficiencies&nbsp;of&nbsp;heat&nbsp;pumps,&nbsp;storage&nbsp;stratification&nbsp;etc.)</p>
<p>This model gives&nbsp;exactly&nbsp;the&nbsp;same&nbsp;results&nbsp;as&nbsp;the&nbsp;norm&nbsp;in&nbsp;both&nbsp;dynamic&nbsp;and&nbsp;static&nbsp;results,&nbsp;but&nbsp;is&nbsp;also&nbsp;able&nbsp;to&nbsp;cope&nbsp;with&nbsp;no-flow&nbsp;conditions.</p>
<p><h4>Assumptions and limitations </h4></p>
<p><ol>
<li>Dynamic model, can be used for situations with variable or no flow rates and sudden changes in supply temperauture&nbsp;</li>
<li>Nomenclature&nbsp;from&nbsp;EN&nbsp;15377.</li>
<li>Water mass is lumped to TOut</li>
</ol></p>
<p><h4>Model use</h4></p>
<p>The embeddedPipe model is to be used together with a <a href=\"modelica://IDEAS.Thermal.Components.Emission.NakedTabs\">NakedTabs</a> in a <a href=\"modelica://IDEAS.Thermal.Components.Emission.Tabs\">Tabs</a> model, or the heatPortEmb can be used to couple it to a structure similar to NakedTabs in a building element. </p>
<p>Configuration&nbsp;of&nbsp;the&nbsp;model&nbsp;can&nbsp;be&nbsp;tricky:&nbsp;the&nbsp;speed&nbsp;of&nbsp;the&nbsp;fluid&nbsp;(flowSpeed)&nbsp;is&nbsp;influencing&nbsp;the&nbsp;convective&nbsp;resistance&nbsp;(R_w)&nbsp;and&nbsp;therefore&nbsp;these&nbsp;2&nbsp;configurations&nbsp;are&nbsp;NOT&nbsp;the&nbsp;same:</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1.&nbsp;10&nbsp;m2&nbsp;of&nbsp;floor&nbsp;with&nbsp;100&nbsp;kg/h&nbsp;flowrate&nbsp;(m_flowSp&nbsp;=&nbsp;10&nbsp;kg/h/m2)</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.&nbsp;1&nbsp;m2&nbsp;of&nbsp;floor&nbsp;heating&nbsp;with&nbsp;10&nbsp;kg/h&nbsp;flowrate&nbsp;(m_flowSp&nbsp;=&nbsp;10&nbsp;kg/h/m2)</p>
<p><br/>The following parameters have to be set:</p>
<p><ul>
<li>FHChars is a record with all the parameters of the geometry, materials and even number of discretization layers in the nakedTabs model. Attention, this record also specifies the <u>floor surface</u>.</li>
<li>mFlow_min is used to check the validity of the operating conditions.</li>
</ul></p>
<p><br/>The validity range of the model is largely checked by assert() statements. When the mass flow rate is too low, discretization of the model is a solution to obtain models in the validity range again. </p>
<p>About&nbsp;the&nbsp;number&nbsp;of&nbsp;elements&nbsp;in&nbsp;the&nbsp;floor&nbsp;construction&nbsp;(see <a href=\"modelica://IDEAS.Thermal.Components.Emission.NakedTabs\">IDEAS.Thermal.Components.Emission.NakedTabs</a>):&nbsp;this&nbsp;seems&nbsp;to&nbsp;have&nbsp;an&nbsp;important&nbsp;impact&nbsp;on&nbsp;the&nbsp;results.&nbsp;&nbsp;1&nbsp;capacity&nbsp;above&nbsp;and&nbsp;below&nbsp;is&nbsp;clearly&nbsp;not&nbsp;enough.&nbsp;&nbsp;No&nbsp;detailed&nbsp;sensitivity&nbsp;study&nbsp;made,&nbsp;but&nbsp;it&nbsp;seems&nbsp;that&nbsp;3&nbsp;capacities&nbsp;on&nbsp;each&nbsp;side&nbsp;were&nbsp;needed&nbsp;in&nbsp;my&nbsp;tests&nbsp;to&nbsp;get&nbsp;good&nbsp;results.</p>
<p><h4>Validation </h4></p>
<p>Validation&nbsp;of&nbsp;the&nbsp;model&nbsp;is&nbsp;not&nbsp;evident&nbsp;with&nbsp;the&nbsp;data&nbsp;in&nbsp;(Koschenz,&nbsp;2000):</p>
<p><ul>
<li>4.5.1&nbsp;is&nbsp;very&nbsp;strange:&nbsp;the&nbsp;results&nbsp;seem&nbsp;to&nbsp;be&nbsp;obtained&nbsp;with&nbsp;1m2&nbsp;and&nbsp;12&nbsp;kg/h&nbsp;total&nbsp;flowrate,&nbsp;but&nbsp;this&nbsp;leads&nbsp;to&nbsp;very&nbsp;low&nbsp;flowSpeed&nbsp;value&nbsp;(although&nbsp;Reynolds&nbsp;number&nbsp;is&nbsp;still&nbsp;high)&nbsp;and&nbsp;an&nbsp;alpha&nbsp;convection&nbsp;of&nbsp;only&nbsp;144&nbsp;W/m2K&nbsp;==&GT;&nbsp;I&nbsp;exclude&nbsp;this&nbsp;case&nbsp;explicitly&nbsp;with&nbsp;an&nbsp;assert&nbsp;statement&nbsp;on&nbsp;the&nbsp;flowSpeed</li>
<li>4.6&nbsp;is&nbsp;ok&nbsp;and&nbsp;I&nbsp;get&nbsp;exactly&nbsp;the&nbsp;same&nbsp;results,&nbsp;but&nbsp;this&nbsp;leads&nbsp;to&nbsp;extremely&nbsp;low&nbsp;supply&nbsp;temperatures&nbsp;in&nbsp;order&nbsp;to&nbsp;reach&nbsp;20&nbsp;W/m2</li>
<li>4.5.2&nbsp;not&nbsp;tested</li>
</ul></p>
<p><br/>A specific report of this validation can be found in IDEAS/Specifications/Thermal/ValidationEmbeddedPipeModels_20111006.pdf</p>
<p><h4>Examples</h4></p>
<p>See combinations with NakedTabs in a Tabs model. </p>
<p><h4>References</h4></p>
<p>[Koshenz, 2000] - Koschenz, Markus, and Beat Lehmann. 2000. <i>Thermoaktive Bauteilsysteme - Tabs</i>. D&uuml;bendorf: EMPA D&uuml;bendorf. </p>
<p>[TRNSYS, 2007] - Multizone Building modeling with Type 56 and TRNBuild.</p>
</html>", revisions="<html>
<p><ul>
<li>2014 March, Filip Jorissen: IDEAS baseclasses</li>
<li>2013 May, Roel De Coninck: documentation</li>
<li>2012 April, Roel De Coninck: rebasing on common Partial_Emission</li>
<li>2011, Roel De Coninck: first version and validation</li>
</ul></p>
</html>"));
end EmbeddedPipe;
