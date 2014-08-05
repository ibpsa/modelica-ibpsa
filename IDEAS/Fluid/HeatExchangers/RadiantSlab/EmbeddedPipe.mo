within IDEAS.Fluid.HeatExchangers.RadiantSlab;
model EmbeddedPipe
  "Embedded pipe model based on prEN 15377 and (Koschenz, 2000), water capacity lumped to TOut"
  import IDEAS;
  extends IDEAS.Fluid.HeatExchangers.Interfaces.EmissionTwoPort;
  replaceable parameter
    IDEAS.Fluid.HeatExchangers.RadiantSlab.BaseClasses.RadiantSlabChar RadSlaCha constrainedby
    IDEAS.Fluid.HeatExchangers.RadiantSlab.BaseClasses.RadiantSlabChar
    "Properties of the floor heating or TABS, if present"
    annotation (choicesAllMatching=true);
  extends IDEAS.Fluid.Interfaces.Partials.PipeTwoPort(
  final m=Modelica.Constants.pi/4*(RadSlaCha.d_a - 2*RadSlaCha.s_r)^2*L_r*Medium.density_pTX(Medium.p_default, Medium.T_default, Medium.X_default),
  res(use_dh=true, dh= if RadSlaCha.tabs then pipeDiaInt else 1),
  final dp_nominal=if RadSlaCha.tabs and use_dp then Modelica.Fluid.Pipes.BaseClasses.WallFriction.Detailed.pressureLoss_m_flow(
      m_flow=m_flow_nominal/nParCir,
      rho_a=rho_default,
      rho_b=rho_default,
      mu_a=mu_default,
      mu_b=mu_default,
      length=pipeEqLen/nParCir,
      diameter=RadSlaCha.d_a - 2*RadSlaCha.s_r,
      roughness=roughness,
      m_flow_small=m_flow_small/nParCir) else 0);

  // General model parameters ////////////////////////////////////////////////////////////////
  // in partial: parameter SI.MassFlowRate m_flowMin "Minimal flowrate when in operation";
  final parameter Modelica.SIunits.Length L_r=A_floor/RadSlaCha.T/nParCir
    "Length of the circuit";
  parameter Boolean use_dp = false "Set to true to calculate pressure drop";
  parameter Modelica.SIunits.Length roughness(min=0) = 2.5e-5
    "Absolute roughness of pipe, with a default for a smooth steel pipe"
    annotation(Dialog(tab="Pressure drop"));
  final parameter Real pipeDiaInt = RadSlaCha.d_a - 2*RadSlaCha.s_r
    "Pipe internal diameter";
  parameter Modelica.SIunits.Length L_floor = A_floor^(1/2)
    "Floor length - along the pipe direction"
    annotation(Dialog(tab="Pressure drop"));
  parameter Real N_pipes = A_floor/L_floor/RadSlaCha.T - 1
    "Number of parallel pipes in the slab"
annotation(Dialog(tab="Pressure drop"));
  parameter Modelica.SIunits.Length pipeBendEqLen = 2*(N_pipes-1)*(2.48*RadSlaCha.T/2/pipeDiaInt+3.20)*pipeDiaInt
    "Pipe bends equivalent length, default according to Fox and McDonald"
annotation(Dialog(tab="Pressure drop"));
  parameter Modelica.SIunits.Length pipeEqLen = pipeBendEqLen + (L_floor-2*RadSlaCha.T)*N_pipes
    "Total pipe equivalent length, default assuming 180 dg turns starting at RadSlaCha.T from the end of the slab"
annotation(Dialog(tab="Pressure drop"));
  parameter Modelica.SIunits.MassFlowRate m_flowMin = m_flow_nominal*0.5
    "Minimal flowrate when in operation - used for determining required series discretisation";

  parameter Real nParCir
    "Number of parallel equally sized circuits in the tabs";

  parameter Modelica.SIunits.Area A_floor "Floor/tabs surface area";

  parameter Boolean lamFlo = false
    "Set to true if heat transfer correlations for laminar flow need to be used";

  final parameter Modelica.SIunits.Area A_pipe=
    Modelica.Constants.pi/4*pipeDiaInt^2
    "Pipe internal cross section surface area";

  // Resistances ////////////////////////////////////////////////////////////////
  // there is no R_z in the model because the dynamics of the water is explicitly simulated
  // SI.ThermalResistance R_z "Flowrate dependent thermal resistance of pipe length";
  Modelica.SIunits.ThermalInsulance R_w_val
    "Flow dependent resistance value of convective heat transfer inside pipe, only valid if turbulent flow (see assert in initial equation)";
  final parameter Modelica.SIunits.ThermalInsulance R_r_val=RadSlaCha.T*log(RadSlaCha.d_a
      /(RadSlaCha.d_a - 2*RadSlaCha.s_r))/(2*Modelica.Constants.pi*RadSlaCha.lambda_r)
    "Fix resistance value of thermal conduction through pipe wall * surface of floor between 2 pipes (see RadSlaCha documentation)";

  //Calculation of the resistance from the outer pipe wall to the center of the tabs / floorheating.
  final parameter Real corr = if RadSlaCha.tabs then 0 else
    sum( -(RadSlaCha.alp2/RadSlaCha.lambda_b * RadSlaCha.T - 2*3.14*s)/(RadSlaCha.alp2/RadSlaCha.lambda_b * RadSlaCha.T + 2*3.14*s)*exp(-4*3.14*s/RadSlaCha.T*RadSlaCha.S_2)/s for s in 1:10) "correction factor for the floor heating according to Multizone Building modeling with Type56 and TRNBuild (see documentation). 
    If tabs is used, corr=0";
  final parameter Modelica.SIunits.ThermalInsulance R_x_val=RadSlaCha.T*(log(RadSlaCha.T
      /(3.14*RadSlaCha.d_a)) + corr)/(2*3.14*RadSlaCha.lambda_b)
    "Fix resistance value of thermal conduction from pipe wall to layer";

  // Auxiliary parameters and variables ////////////////////////////////////////////////////////////////

  Modelica.SIunits.Velocity flowSpeed=port_a.m_flow/nParCir/rho_default/A_pipe
    "flow speed through the pipe";
  //Reynold number Re = ( (m_flow / rho / A) * D * rho )  / mu / numParCir.
  final parameter Modelica.SIunits.ReynoldsNumber reyMin=
    m_flowMin/nParCir/A_pipe*pipeDiaInt/mu_default
    "Reynolds at minimum mass flow rate";
  final parameter Modelica.SIunits.ReynoldsNumber reyNom=
    m_flow_nominal/nParCir/A_pipe*pipeDiaInt/mu_default
    "Reynolds number at nominal mass flow rate";
  Real m_flowSp(unit="kg/(m2.s)")=port_a.m_flow/A_floor
    "mass flow rate per unit floor area";
  Real m_flowMinSp(unit="kg/(m2.s)")=m_flowMin/A_floor
    "minimum mass flow rate per unit floor area";

  Modelica.Thermal.HeatTransfer.Components.ThermalConductor R_x(G=
        A_floor/R_x_val) "Thermal conductor from pipe wall to layer"
         annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={56,24})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor R_r(G=
        A_floor/R_r_val) "Thermal conductor of pipe wall"
        annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={22,24})));

  //fixme: update documentation regarding information about used values for density and viscosity
   //copied from Buildings.Fluid.FixedResistances.BaseClasses.Pipe
protected
  parameter Modelica.SIunits.Density rho_default = Medium.density(state_default);
  parameter Modelica.SIunits.DynamicViscosity mu_default = Medium.dynamicViscosity(state_default)
    "Dynamic viscosity at nominal condition";

  parameter Medium.ThermodynamicState state_default= Medium.setState_pTX(Medium.p_default, T_start, Medium.X_default)
    "Default state for calculation of density, viscosity, ...";

  // Interface
public
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heatPortEmb
    "Port to the core of a floor heating/concrete activation"
    annotation (Placement(transformation(extent={{-10,90},{10,110}}),
        iconTransformation(extent={{-10,90},{10,110}})));

  Modelica.Blocks.Sources.RealExpression G_w_val(y=A_floor/R_w_val)
    "Value of the G_w_val of the convective heat transfer inside pipe"
    annotation (Placement(transformation(extent={{-92,40},{-36,60}})));
  Modelica.Thermal.HeatTransfer.Components.Convection R_w
    annotation (Placement(transformation(extent={{-22,14},{-2,34}})));
initial equation
   assert(reyMin > 2700 or lamFlo,
     "The minimal flowrate leads to laminar flow. This is not valid when using the turbulent flow model. Set lamFlo to true if you want to use a laminar flow model");
   assert(reyNom < 4000 or not lamFlo,
     "The nominal flowrate leads to turbulent flow. This is not valid when using the laminar flow model.  Set lamFlo to false if you want to use a turbulent flow model");

   assert(m_flowMinSp*Medium.specificHeatCapacityCp(state_default)*(R_w_val + R_r_val + R_x_val) >= 0.5,
     "Model is not valid, division in n parts is required");
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
  //For high flow rates see [Koshenz, 2000] eqn 4.37
  //For low or zero mass flow rate an average convective heat transfer coefficient h = 200 for laminar flow is used.
  //based on [Koshenz, 2000] figure 4.5
  R_w_val = if noEvent(abs(port_a.m_flow) > m_flowMin/10) then
  if lamFlo then
      RadSlaCha.T/(4*Medium.thermalConductivity(state_default)*Modelica.Constants.pi)
    else
  RadSlaCha.T^0.13/8/Modelica.Constants.pi*abs((pipeDiaInt/(m_flowSp*L_r)))^0.87 else
      RadSlaCha.T/(200*pipeDiaInt*Modelica.Constants.pi);
                  //assumes Nu_D = 4: between constant heat flow and constant wall temperature

  connect(R_r.port_b, R_x.port_a) annotation (Line(
      points={{32,24},{46,24}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(R_x.port_b, heatPortEmb) annotation (Line(
      points={{66,24},{72,24},{72,100},{0,100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(R_w.fluid, R_r.port_a) annotation (Line(
      points={{-2,24},{12,24}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vol.heatPort, R_w.solid) annotation (Line(
      points={{-44,10},{-32,10},{-32,24},{-22,24}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(G_w_val.y, R_w.Gc) annotation (Line(
      points={{-33.2,50},{-12,50},{-12,34}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),
            graphics),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),
         graphics={Line(
          points={{-90,0},{-80,0},{-80,-60},{-60,-60},{-60,80},{-40,80},{-40,
              -60},{-20,-60},{-20,80},{0,80},{0,-60},{20,-60},{20,80},{40,80},{
              40,-60},{60,-60},{60,80},{80,80},{80,0},{100,0}},
          color={0,0,255},
          smooth=Smooth.None)}),
    Documentation(info="<html>
<p><b>Description</b> </p>
<p>Dynamic model of an embedded pipe for a concrete core activation or a floor heating element. This&nbsp;model&nbsp;is&nbsp;based&nbsp;on&nbsp;the&nbsp;norm&nbsp;prEN&nbsp;15377&nbsp;for&nbsp;the&nbsp;nomenclature&nbsp;but&nbsp;relies&nbsp;more&nbsp;on&nbsp;the&nbsp;background&nbsp;as&nbsp;developed&nbsp;in&nbsp;(Koschenz,&nbsp;2000).&nbsp;The R_x_val for the floor heating is calculated according to the TRNSYS guide lines (TRNSYS, 2007)  There&nbsp;is&nbsp;one&nbsp;major&nbsp;deviation:&nbsp;instead&nbsp;of&nbsp;calculating&nbsp;R_z&nbsp;(to&nbsp;get&nbsp;the&nbsp;mean&nbsp;water&nbsp;temperature&nbsp;in&nbsp;the&nbsp;tube&nbsp;from&nbsp;the&nbsp;supply&nbsp;temperature&nbsp;and&nbsp;flowrate),&nbsp;this&nbsp;mean&nbsp;water&nbsp;temperatue&nbsp;is&nbsp;modelled&nbsp;specifically,&nbsp;based&nbsp;on&nbsp;the&nbsp;mass&nbsp;of&nbsp;the&nbsp;water&nbsp;in&nbsp;the&nbsp;system.<code><font style=\"color: #006400; \">&nbsp;&nbsp;</font></code></p>
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
<p>Configuration&nbsp;of&nbsp;the&nbsp;model&nbsp;can&nbsp;be&nbsp;tricky:&nbsp;the&nbsp;speed&nbsp;of&nbsp;the&nbsp;fluid&nbsp;(flowSpeed)&nbsp;is&nbsp;influencing&nbsp;the&nbsp;convective&nbsp;resistance&nbsp;(R_w_val)&nbsp;and&nbsp;therefore&nbsp;these&nbsp;2&nbsp;configurations&nbsp;are&nbsp;NOT&nbsp;the&nbsp;same:</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1.&nbsp;10&nbsp;m2&nbsp;of&nbsp;floor&nbsp;with&nbsp;100&nbsp;kg/h&nbsp;flowrate&nbsp;(m_flowSp&nbsp;=&nbsp;10&nbsp;kg/h/m2)</p>
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.&nbsp;1&nbsp;m2&nbsp;of&nbsp;floor&nbsp;heating&nbsp;with&nbsp;10&nbsp;kg/h&nbsp;flowrate&nbsp;(m_flowSp&nbsp;=&nbsp;10&nbsp;kg/h/m2)</p>
<p><br/>The following parameters have to be set:</p>
<p><ul>
<li>RadSlaCha is a record with all the parameters of the geometry, materials and even number of discretization layers in the nakedTabs model. Attention, this record also specifies the <u>floor surface</u>.</li>
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
