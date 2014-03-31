within IDEAS.HeatingSystems;
model Heating_Embedded_DHW_STS
  "Hydraulic heating with embedded emission, DHW (with STS), no TES for heating"
  import IDEAS.Thermal.Components.Emission.Interfaces.EmissionType;

  extends Interfaces.Partial_HydraulicHeatingSystem(
    floorHeating=true,
    radiators=false,
    final nLoads=1);

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

  Components.BaseClasses.Pump_Insulated[nZones] pumpRad(
    each medium=medium,
    each useInput=true,
    m_flowNom=m_flowNom,
    each m_flowSet(start=0),
    each etaTot=0.7,
    each UA=1,
    each m=0,
    each dpFix=30000)
    annotation (Placement(transformation(extent={{88,20},{108,30}})));

  IDEAS.Thermal.Components.Emission.EmbeddedPipe[nZones] emission(
    each medium=medium,
    m_flowMin=m_flowNom,
    FHChars=FHChars)
    annotation (Placement(transformation(extent={{114,22},{138,38}})));

  Components.BaseClasses.Pump_Insulated pumpSto(
    medium=medium,
    useInput=true,
    m_flowNom=sum(m_flowNom),
    UA=1,
    m=0,
    dpFix=30000) "Pump for loading the storage tank"
    annotation (Placement(transformation(extent={{-34,-64},{-52,-54}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=
        293.15)
    annotation (Placement(transformation(extent={{-162,-52},{-150,-40}})));
public
  replaceable Controls.ControlHeating.Ctrl_Heating_DHW HPControl(
    timeFilter=timeFilter,
    DHW=true,
    TDHWSet=TDHWSet,
    TColdWaterNom=TDHWCold,
    TSupNom=TSupNom,
    dTSupRetNom=dTSupRetNom) constrainedby
    Controls.ControlHeating.Interfaces.Partial_Ctrl_Heating_TES(
    timeFilter=timeFilter,
    DHW=true,
    TDHWSet=TDHWSet,
    TColdWaterNom=TDHWCold,
    TSupNom=TSupNom,
    dTSupRetNom=dTSupRetNom)
    annotation (Placement(transformation(extent={{-162,-12},{-154,-4}})));

  Components.Storage.StorageTank_OneIntHX tesTank(
    flowPort_a(m_flow(start=0)),
    nbrNodes=nbrNodes,
    medium=medium,
    mediumHX=medium,
    heightTank=1.8,
    volumeTank=volumeTank,
    TInitial={323.15 for i in 1:nbrNodes}) annotation (Placement(transformation(
        extent={{-14,-20},{14,20}},
        rotation=0,
        origin={-14,-22})));

  replaceable IDEAS.Thermal.Components.Domestic_Hot_Water.DHW_ProfileReader dHW(
    medium=medium,
    TDHWSet=TDHWSet,
    TCold=TDHWCold,
    VDayAvg=nOcc*0.045,
    profileType=3) constrainedby
    IDEAS.Thermal.Components.Domestic_Hot_Water.partial_DHW(
    medium=medium,
    TDHWSet=TDHWSet,
    TCold=TDHWCold) annotation (Placement(transformation(
        extent={{-9,5},{9,-5}},
        rotation=-90,
        origin={-49,-21})));

protected
  IDEAS.BaseClasses.Control.Hyst_NoEvent_Var_HEATING[nZones] heatingControl
    "onoff controller for the pumps of the radiator circuits"
    annotation (Placement(transformation(extent={{64,74},{72,82}})));
  Components.BaseClasses.Thermostatic3WayValve idealMixer
    annotation (Placement(transformation(extent={{66,16},{80,34}})));
  IDEAS.Thermal.Components.BaseClasses.Pipe pipeDHW(medium=medium, m=1)
    annotation (Placement(transformation(extent={{-34,-46},{-44,-42}})));
  Components.BaseClasses.Pipe_Insulated pipeMixer(
    medium=medium,
    m=1,
    UA=1) annotation (Placement(transformation(extent={{24,-76},{34,-72}})));
  Components.BaseClasses.Pipe_Insulated[nZones] pipeEmission(
    each medium=medium,
    each m=1,
    each UA=1)
    annotation (Placement(transformation(extent={{146,32},{162,38}})));
  // Result variables
public
  Modelica.SIunits.Temperature[nbrNodes] TSto=tesTank.nodes.heatPort.T;
  Modelica.SIunits.Temperature TTankTopSet;
  Modelica.SIunits.Temperature TTankBotIn;
  Modelica.SIunits.MassFlowRate m_flowDHW;
  Modelica.SIunits.Power QDHW;
  Modelica.SIunits.Temperature TDHW;
  Real SOCTank;

  Thermal.Components.Production.SolarThermalSystem_Simple solarThermal(
    medium=medium,
    pump(dpFix=100000, etaTot=0.6),
    ACol=AColTot,
    nCol=1) if solSys
    annotation (Placement(transformation(extent={{56,-2},{36,-22}})));
  Components.BaseClasses.AbsolutePressure absolutePressure(medium=medium, p=
        300000)
    annotation (Placement(transformation(extent={{-24,-62},{-16,-54}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector th1(m=nZones)
    annotation (Placement(transformation(extent={{90,-32},{110,-12}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector th2(m=nZones)
    annotation (Placement(transformation(extent={{108,-32},{128,-12}})));
equation
  HPControl.TTankTop = TSto[posTTop];
  HPControl.TTankBot = TSto[posTBot];

  QHeatTotal = -sum(emission.heatPortEmb.Q_flow) + dHW.m_flowTotal*medium.cp*(
    dHW.TMixed - dHW.TCold);
  THeaterSet = HPControl.THPSet;

  heatingControl.uHigh = TSet + 0.5*ones(nZones);

  P[1] = heater.PEl + pumpSto.PEl + sum(pumpRad.PEl);
  Q[1] = 0;
  TTankTopSet = HPControl.TTopSet;
  TDHW = dHW.TMixed;
  TTankBotIn = tesTank.flowPort_b.h/medium.cp;
  TEmissionIn = idealMixer.flowPortMixed.h/medium.cp;
  TEmissionOut = emission.TOut;
  m_flowEmission = emission.flowPort_a.m_flow;
  m_flowDHW = dHW.m_flowTotal;
  SOCTank = HPControl.SOC;
  QDHW = m_flowDHW*medium.cp*(TDHW - dHW.TCold);

  //STS

  connect(solarThermal.flowPort_b, tesTank.flowPorts[posInSTS]) annotation (
      Line(
      points={{36,-10},{22,-10},{22,-11.2308},{0,-11.2308}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(solarThermal.flowPort_a, tesTank.flowPorts[nbrNodes + 1]) annotation (
     Line(
      points={{36,-6},{22,-6},{22,-11.2308},{0,-11.2308}},
      color={0,0,255},
      smooth=Smooth.None));

  // connections that are function of the number of circuits
  for i in 1:nZones loop
    connect(idealMixer.flowPortMixed, pumpRad[i].flowPort_a) annotation (Line(
        points={{80,25},{88,25}},
        color={0,0,255},
        smooth=Smooth.None));
    connect(pipeEmission[i].flowPort_b, pipeMixer.flowPort_b) annotation (Line(
        points={{162,35},{162,34},{168,34},{168,-74},{34,-74}},
        color={0,0,255},
        smooth=Smooth.None));
  end for;

  // general connections for any configuration

  connect(emission.heatPortCon, heatPortCon) annotation (Line(
      points={{129,38},{129,58},{132,58},{132,98},{-192,98},{-192,20},{-200,20}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(emission.heatPortRad, heatPortRad) annotation (Line(
      points={{133,38},{133,56},{136,56},{136,96},{-188,96},{-188,-20},{-200,-20}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(pumpRad.flowPort_b, emission.flowPort_a) annotation (Line(
      points={{108,25},{114,25}},
      color={0,128,255},
      smooth=Smooth.None));
  connect(fixedTemperature.port, tesTank.heatExchEnv) annotation (Line(
      points={{-150,-46},{2,-46},{2,-23.5385},{-4.66667,-23.5385}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(dHW.flowPortHot, tesTank.flowPort_a) annotation (Line(
      points={{-50.5,-11.3571},{-50.5,-10},{-52,-10},{-52,22},{8,22},{8,-4},{0,
          -4},{0,-5.07692}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(TSensor, heatingControl.u) annotation (Line(
      points={{-204,-60},{-176,-60},{-176,24},{-176,24},{-176,76},{-54,76},{-54,
          77},{64.0889,77}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(heatingControl.y, pumpRad.m_flowSet) annotation (Line(
      points={{72.0889,78},{100.667,78},{100.667,30.125}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(TSet, heatingControl.uLow) annotation (Line(
      points={{0,-104},{0,-66},{16,-66},{16,80},{40,80},{40,81},{64.0889,81}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(dHW.flowPortCold, pipeDHW.flowPort_b) annotation (Line(
      points={{-50.5,-29.3571},{-50.5,-44},{-44,-44}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pipeDHW.flowPort_a, tesTank.flowPort_b) annotation (Line(
      points={{-34,-44},{8,-44},{8,-38},{0,-38},{0,-38.9231}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(idealMixer.flowPortCold, pipeMixer.flowPort_b) annotation (Line(
      points={{73,16},{73,-74},{34,-74}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(fixedTemperature.port, heater.heatPort) annotation (Line(
      points={{-150,-46},{-110,-46},{-110,-10},{-103,-10},{-103,14}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(emission.heatPortEmb, heatPortEmb) annotation (Line(
      points={{119,37.8},{124,37.8},{124,100},{-186,100},{-186,60},{-200,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(HPControl.THeaCur, idealMixer.TMixedSet) annotation (Line(
      points={{-153.822,-10},{-132,-10},{-132,44},{73,44},{73,34}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(HPControl.onOff, pumpSto.m_flowSet) annotation (Line(
      points={{-153.911,-8},{-130,-8},{-130,-48},{-45.4,-48},{-45.4,-53.875}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(HPControl.THPSet, heater.TSet) annotation (Line(
      points={{-153.911,-6},{-134,-6},{-134,40},{-100,40},{-100,34},{-101,34}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.DashDot));

  connect(pipeEmission.flowPort_a, emission.flowPort_b) annotation (Line(
      points={{146,35},{138,35}},
      color={0,128,255},
      smooth=Smooth.None));

  connect(mDHW60C, dHW.mDHW60C) annotation (Line(
      points={{60,-104},{60,-84},{-80,-84},{-80,-20.3571},{-57.6429,-20.3571}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));

  connect(pipeMixer.flowPort_a, heater.flowPort_a) annotation (Line(
      points={{24,-74},{-64,-74},{-64,19.6364},{-90,19.6364}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pumpSto.flowPort_b, heater.flowPort_a) annotation (Line(
      points={{-52,-59},{-64,-59},{-64,19.6364},{-90,19.6364}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(heater.heatPort, fixedTemperature.port) annotation (Line(
      points={{-103,14},{-102,14},{-102,-46},{-150,-46}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(absolutePressure.flowPort, pumpSto.flowPort_a) annotation (Line(
      points={{-24,-58},{-24,-59},{-34,-59}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(tesTank.flowPortHXLower, pumpSto.flowPort_a) annotation (Line(
      points={{-28,-35.8462},{-30,-35.8462},{-30,-59},{-34,-59}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(heater.flowPort_b, idealMixer.flowPortHot) annotation (Line(
      points={{-90,24.9091},{-34,24.9091},{-34,25},{66,25}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(heater.flowPort_b, tesTank.flowPortHXUpper) annotation (Line(
      points={{-90,24.9091},{-34,24.9091},{-34,-29.6923},{-28,-29.6923}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pipeMixer.heatPort, fixedTemperature.port) annotation (Line(
      points={{29,-76},{-118,-76},{-118,-46},{-150,-46}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pumpRad.heatPort, th1.port_a) annotation (Line(
      points={{94,20},{94,4},{100,4},{100,-12}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(th1.port_b, fixedTemperature.port) annotation (Line(
      points={{100,-32},{100,-86},{-118,-86},{-118,-46},{-150,-46}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pipeEmission.heatPort, th2.port_a) annotation (Line(
      points={{154,32},{154,-2},{118,-2},{118,-12}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(th2.port_b, fixedTemperature.port) annotation (Line(
      points={{118,-32},{118,-86},{-118,-86},{-118,-46},{-150,-46}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pumpSto.heatPort, fixedTemperature.port) annotation (Line(
      points={{-39.4,-64},{-39.4,-70},{-118,-70},{-118,-46},{-150,-46}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(tesTank.T[1], solarThermal.TSafety) annotation (Line(
      points={{0,-17.3846},{22,-17.3846},{22,-19.8},{35.2,-19.8}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(tesTank.T[nbrNodes], solarThermal.TLow) annotation (Line(
      points={{0,-17.3846},{22,-17.3846},{22,-15.4},{35.4,-15.4}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));

  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-100},{
            200,100}}), graphics),
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
<li>Connect the heating system to the corresponding heatPorts of a <a href=\"modelica://IDEAS.Interfaces.BaseClasses.Structure\">structure</a>. </li>
<li>Connect <i>TSet</i> and <i>TSensor</i> </li>
<li>Connect <i>plugLoad </i>to an inhome grid. A<a href=\"modelica://IDEAS.Interfaces.BaseClasses.CausalInhomeFeeder\"> dummy inhome grid like this</a> has to be used if no inhome grid is to be modelled. </li>
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
