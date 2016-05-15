within IDEAS.Templates.Heating;
model Heating_Embedded_DHW_STS
  "Hydraulic heating with embedded emission, DHW (with STS), no TES for heating"
  // fixme: no solar system is implemeted so far (adapt documentation)
  replaceable parameter
    IDEAS.Fluid.HeatExchangers.RadiantSlab.BaseClasses.RadiantSlabChar[nEmbPorts] RadSlaCha constrainedby
    IDEAS.Fluid.HeatExchangers.RadiantSlab.BaseClasses.RadiantSlabChar
    "Properties of the floor heating or TABS, if present";
   parameter Modelica.SIunits.Area AEmb[nEmbPorts]
    "surface of each embedded circuit";
   extends IDEAS.Templates.Heating.Interfaces.Partial_HydraulicHeating(
    final isHea=true,
    final isCoo=false,
    final nConvPorts=nZones,
    final nRadPorts=nZones,
    final nTemSen=nZones,
    final nEmbPorts=nZones,
    nLoads=1,
    nZones=1,
    minSup=true,
    TSupMin=273.15 + 25,
    redeclare IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe emission[
      nEmbPorts](
      redeclare each package Medium = Medium,
      m_flow_nominal=m_flow_nominal,
      m_flowMin=m_flow_nominal/3,
      RadSlaCha=RadSlaCha,
      A_floor=AEmb,
      nParCir=1),
    redeclare Controls.ControlHeating.Ctrl_Heating_DHW ctrl_Heating(
      TDHWSet=TDHWSet,
      TColdWaterNom=TColdWaterNom,
      dTHPTankSet=dTHPTankSet),
    heater(m_flow_nominal=sum(m_flow_nominal) + m_flow_nominal_stoHX),
    pumpRad(riseTime=100, dpFix=0));
  // --- Domestic Hot Water (DHW) Parameters
  parameter Integer nOcc = 1 "Number of occupants";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal_DHW = nOcc*dHW.VDayAvg*983/(3600*24)*10
    "nominal mass flow rate of DHW";
  parameter Modelica.SIunits.Temperature TDHWSet(max=273.15 + 60) = 273.15 + 45
    "DHW temperature setpoint";
  parameter Modelica.SIunits.Temperature TColdWaterNom=273.15 + 10
    "Nominal tap (cold) water temperature";
  // --- Storage Tank Parameters
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal_stoHX = m_flow_nominal_DHW * (TDHWSet - TColdWaterNom)/dTHPTankSet
    "nominal mass flow rate of HX of storage tank";
  parameter SI.TemperatureDifference dTHPTankSet(min=1)=2
    "Difference between tank setpoint and heat pump setpoint";
  parameter Modelica.SIunits.Volume volumeTank=0.25;
  parameter Modelica.SIunits.Area AColTot=1 "TOTAL collector area";
  parameter Integer nbrNodes=10 "Number of nodes in the tank";
  parameter Integer posTTop(max=nbrNodes) = 1
    "Position of the top temperature sensor";
  parameter Integer posTBot(max=nbrNodes) = nbrNodes - 2
    "Position of the bottom temperature sensor";
  parameter Integer posOutHP(max=nbrNodes + 1) = if solSys then nbrNodes - 1
     else nbrNodes + 1 "Position of extraction of TES to HP";
  parameter Integer posInSTS(max=nbrNodes) = nbrNodes - 1
    "Position of injection of STS in TES";
  parameter Boolean solSys(fixed=true) = false;
  // --- Storage tank and hydraulic circuit connect to its heat exchanger
  IDEAS.Fluid.Movers.FlowControlled_m_flow pumpSto(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal_stoHX,
    tau=30,
    filteredSpeed=true,
    riseTime=100) "Pump for loading the storage tank"
    annotation (Placement(transformation(extent={{-30,-56},{-44,-44}})));
  IDEAS.Fluid.Storage.StorageTank_OneIntHX tesTank(
    port_a(m_flow(start=0)),
    nbrNodes=nbrNodes,
    redeclare package Medium = Medium,
    redeclare package MediumHX = Medium,
    heightTank=1.8,
    volumeTank=volumeTank,
    T_start={323.15 for i in 1:nbrNodes},
    m_flow_nominal_HX=m_flow_nominal_stoHX)
                                           annotation (Placement(transformation(
        extent={{-14,-20},{14,20}},
        rotation=0,
        origin={-12,0})));
  // --- Domestic Hot Water and it hydraulic circuit
  replaceable IDEAS.Fluid.Taps.BalancedTap dHW(
    TDHWSet=TDHWSet,
    profileType=3,
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal_DHW,
    VDayAvg=nOcc*0.045) constrainedby IDEAS.Fluid.Taps.Interfaces.BalancedTap(
                                            redeclare package Medium = Medium,
      TDHWSet=TDHWSet) annotation (Placement(transformation(
        extent={{-9,5},{9,-5}},
        rotation=-90,
        origin={-47,1})));
  IDEAS.Fluid.FixedResistances.InsulatedPipe pipeDHW(redeclare package Medium
      =                                                                          Medium, m=1,
    UA=10,
    m_flow_nominal=m_flow_nominal_DHW)
    annotation (Placement(transformation(extent={{-28,-32},{-44,-26}})));
  Fluid.Sources.FixedBoundary       absolutePressure1(
                                                     redeclare package Medium
      = Medium, use_T=false,
    nPorts=1)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=90,
        origin={8,-42})));
  // --- Result (Output) variables
  Modelica.SIunits.Temperature[nbrNodes] TSto=tesTank.nodes.heatPort.T;
  Modelica.SIunits.Temperature TTankTopSet;
  Modelica.SIunits.Temperature TTankBotIn;
  Modelica.SIunits.MassFlowRate m_flowDHW;
  Modelica.SIunits.Power QDHW;
  Modelica.SIunits.Temperature TDHW;
  Real SOCTank;
  // --- Temperature sensors
  Fluid.Sensors.TemperatureTwoPort senTemSto_top(redeclare package Medium =
        Medium, m_flow_nominal=sum(m_flow_nominal))
    "Temperature at the top outlet of the storage tank (port_a)"
    annotation (Placement(transformation(extent={{-24,18},{-32,26}})));
  Fluid.Sensors.TemperatureTwoPort senTemSto_bot(redeclare package Medium =
        Medium, m_flow_nominal=sum(m_flow_nominal))
    "Temperature at the bottom inlet of the storage tank (port_b)"
    annotation (Placement(transformation(extent={{-6,-34},{-16,-24}})));
  Fluid.Sensors.TemperatureTwoPort senTemStoHX_out(redeclare package Medium =
        Medium, m_flow_nominal=sum(m_flow_nominal))
    "Temperature at the outlet of the storage tank heat exchanger (port_bHX)"
    annotation (Placement(transformation(extent={{-66,-54},{-78,-42}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow prescribedHeatFlow1[
    nRadPorts](Q_flow=0)
    annotation (Placement(transformation(extent={{-140,-32},{-160,-12}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow prescribedHeatFlow[
    nConvPorts](Q_flow=0)
    annotation (Placement(transformation(extent={{-142,8},{-162,28}})));
  Modelica.Blocks.Math.Gain gain(k=m_flow_nominal_stoHX) annotation (Placement(
        transformation(
        extent={{-8,-8},{8,8}},
        rotation=270,
        origin={-80,-8})));
equation
  QHeaSys = -sum(emission.heatPortEmb.Q_flow) + QDHW;
  P[1] = heater.PEl + pumpSto.P + sum(pumpRad.PEl);
  Q[1] = 0;
  // Result variables
  TTankTopSet = ctrl_Heating.TTopSet;
  TDHW = dHW.TDHW_actual;
  TTankBotIn = senTemSto_bot.T;
  m_flowDHW = dHW.idealSource.m_flow_in;
  SOCTank = ctrl_Heating.SOC;
  QDHW = -dHW.pipe_HeatPort.heatPort.Q_flow;
  connect(pumpSto.port_a, tesTank.portHXLower) annotation (Line(
      points={{-30,-50},{-26,-50},{-26,-16.9231}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipeDHW.heatPort, fixedTemperature.port) annotation (Line(
      points={{-36,-27.8},{-56,-27.8},{-56,-68},{-102,-68},{-102,-12},{-127,-12},
          {-127,-14}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pumpSto.heatPort, fixedTemperature.port) annotation (Line(
      points={{-37,-54.08},{-26,-54.08},{-26,-68},{-102,-68},{-102,-12},{-127,-12},
          {-127,-14}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(tesTank.heatExchEnv, fixedTemperature.port) annotation (Line(
      points={{-2.66667,-1.53846},{16,-1.53846},{16,-68},{-102,-68},{-102,-12},
          {-127,-12},{-127,-14}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(emission.heatPortEmb, heatPortEmb) annotation (Line(
      points={{135,44},{134,44},{134,98},{-180,98},{-180,60},{-190,60},{-190,60},
          {-200,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(dHW.port_cold, pipeDHW.port_b) annotation (Line(
      points={{-47,-8},{-47,-29},{-44,-29}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(tesTank.T[posTTop], ctrl_Heating.TTankTop) annotation (Line(
      points={{2,4.61538},{18,4.61538},{18,80},{-176,80},{-176,64},{-160,64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tesTank.T[posTBot], ctrl_Heating.TTankBot) annotation (Line(
      points={{2,4.61538},{10,4.61538},{10,4},{18,4},{18,80},{-176,80},{-176,60},
          {-160,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dHW.port_hot,senTemSto_top. port_b) annotation (Line(
      points={{-47,10},{-47,22},{-32,22}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemSto_top.port_a, tesTank.port_a) annotation (Line(
      points={{-24,22},{6,22},{6,16.9231},{2,16.9231}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipeDHW.port_a,senTemSto_bot. port_b) annotation (Line(
      points={{-28,-29},{-16,-29}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemSto_bot.port_a, tesTank.port_b) annotation (Line(
      points={{-6,-29},{4,-29},{4,-16.9231},{2,-16.9231}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(absolutePressure1.ports[1], tesTank.port_b) annotation (Line(
      points={{8,-36},{8,-28},{4,-28},{4,-16.9231},{2,-16.9231}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(tesTank.portHXUpper, pipeSupply.port_a) annotation (Line(
      points={{-26,-7.69231},{-30,-7.69231},{-30,-8},{-36,-8},{-36,58},{-16,58}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pumpSto.port_b, senTemStoHX_out.port_a) annotation (Line(
      points={{-44,-50},{-56,-50},{-56,-48},{-66,-48}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemStoHX_out.port_b, heater.port_a) annotation (Line(
      points={{-78,-48},{-106,-48},{-106,16},{-114,16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(prescribedHeatFlow1.port, heatPortRad) annotation (Line(
      points={{-160,-22},{-180,-22},{-180,-20},{-200,-20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedHeatFlow.port, heatPortCon) annotation (Line(
      points={{-162,18},{-180,18},{-180,20},{-200,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(ctrl_Heating.onOff, gain.u)
    annotation (Line(points={{-142,62},{-80,62},{-80,1.6}}, color={0,0,127}));
  connect(gain.y, pumpSto.m_flow_in) annotation (Line(points={{-80,-16.8},{-80,
          -38},{-36.86,-38},{-36.86,-42.8}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-100},{200,
            100}})),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-200,-100},{200,
            100}})),
    Documentation(info="<html>
<p><b>Description</b> </p>
<p>Multi-zone Hydraulic heating system with <a href=\"modelica://IDEAS.Thermal.Components.Emission.EmbeddedPipe\">embedded pipe</a> emission system (TABS). There is no thermal energy storage tank for the heating, but the domestic hot water (DHW) system has a storage tank with internal heat exchanger. An optional solar thermal system is foreseen to (pre)heat the DHW storage tank.. A schematic hydraulic scheme is given below:</p>
<p><img src=\"modelica://IDEAS/../Specifications/Thermal/images/HydraulicScheme_Heating_Embedded_DHW_STS.png\"/></p>
<p>For multizone systems, the components <i>pumpRad</i>, <i>emission</i> and <i>pipeReturn</i> are arrays of size <i>nZones</i>. In this model, the <i>emission</i> is a an embedded pipe, the <i>heater</i> is a replaceable component and can be a boiler or heat pump or anything that extends from <a href=\"modelica://IDEAS.Thermal.Components.Production.Interfaces.PartialDynamicHeaterWithLosses\">PartialDynamicHeaterWithLosses</a>.</p>
<p>There are two controllers in the model (not represented in the hydraulic scheme): one for the heater set temperature and control signal of the pump for charging the DHW storage tank (<a href=\"modelica://IDEAS.Thermal.Control.Ctrl_Heating_DHW\">Ctrl_Heating_DHW</a>), and another one for the on/off signal of <i>pumpRad</i> (= thermostat). The system is controlled based on a temperature measurement in each zone, a set temperature for each zone, temperature measurements in the storage tank and a general heating curve (not per zone). The heater will produce hot water at a temperature slightly above the required temperature, depending on the heat demand (space heating or DHW). The <i>idealMixer</i> will mix the supply flow rate with return water to reach the heating curve set point. Right after the <i>idealMixer</i>, the flow is splitted in <i>nZones</i> flows and each <i>pumpRad</i> will set the flowrate in the zonal distribution circuit based on the zone temperature and set point. </p>
<p>A solar thermal system is connected to the DHW storage tank (if <i>solSys</i>=true), but this connection should be improved: a second internal heat exchanger should be foreseen for this heat source. </p>
<p>The heat losses of the heater and all the pipes are connected to a central fix temperature. </p>
<p><h4>Assumptions and limitations </h4></p>
<p><ol>
<li>Controllers try to limit or avoid events for faster simulation</li>
<li>Single heating curve for all zones</li>
<li>Heat emitted through <i>heatPortEmb</i> (to the core of a building construction layer or a <a href=\"modelica://IDEAS.Thermal.Components.Emission.NakedTabs\">nakedTabs</a>)</li>
<li>All pumps are on/off</li>
<li>No priority: both pumps can run simultaneously (could be improved).</li>
</ol></p>
<p><h4>Model use</h4></p>
<p><ol>
<li>Connect the heating system to the corresponding heatPorts of a <a href=\"modelica://IDEAS.Templates.Interfaces.BaseClasses.Structure\">structure</a>. </li>
<li>Connect <i>TSet</i> and <i>TSensor</i> </li>
<li>Connect <i>plugLoad </i>to an inhome grid. A<a href=\"modelica://IDEAS.Templates.Interfaces.BaseClasses.CausalInhomeFeeder\"> dummy inhome grid like this</a> has to be used if no inhome grid is to be modelled. </li>
<li>Set all parameters that are required. </li>
<li>Not all parameters of the sublevel components are ported to the uppermost level. Therefore, it might be required to modify these components deeper down the hierarchy. </li>
</ol></p>
<p><h4>Validation </h4></p>
<p>This is a system level model, no validation performed. If the solar thermal system is used, the controller of the heat pump might be unsufficient, and the internal heat exchanger in the storage tank should be reconfigured (only in top of tank). To be correct, a second internal heat exchanger should be foreseen to connect the primary circuit of the solar thermal system to the tank. </p>
<p>This system (without solar thermal system, so <i>solSys</i>=false) is used in De Coninck et al. (2013) and more information can be found in that paper.</p>
<p><h4>Example </h4></p>
<p>An example of the use of this model can be found in<a href=\"modelica://IDEAS.Thermal.HeatingSystems.Examples.Heating_Embedded\"> IDEAS.Thermal.HeatingSystems.Examples.Heating_Embedded</a>.</p>
</html>", revisions="<html>
<p><ul>
<li>2013 June, Roel De Coninck: minor edits and documentation</li>
<li>2012-2013, Roel De Coninck: many minor and major revisions</li>
<li>2011, Roel De Coninck: first version</li>
</ul></p>
</html>"));
end Heating_Embedded_DHW_STS;
