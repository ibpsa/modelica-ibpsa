within IDEAS.HeatingSystems;
model Heating_Embedded_combiTES_DHW_STS
  "Hydraulic heating for embedded emission, with combiTES and STS"
  import IDEAS.Thermal.Components.Emission.Interfaces.EmissionType;

  extends Interfaces.Partial_HydraulicHeatingSystem(
    floorHeating=true,
    radiators=false,
    final nLoads=1);

  parameter Modelica.SIunits.Volume volumeTank=0.25;
  parameter Modelica.SIunits.Area AColTot=1 "TOTAL collector area";
  parameter Integer nbrNodes=4 "Number of nodes in the tank";
  parameter Integer posTTop(max=nbrNodes) = 1
    "Position of the top temperature sensor";
  parameter Integer posTBot(max=nbrNodes) = nbrNodes - 1
    "Position of the bottom temperature sensor";
  parameter Integer posOutFH(max=nbrNodes) = integer(ceil(nbrNodes/2));
  parameter Boolean solSys(fixed=true) = true;

protected
  Thermal.Components.BaseClasses.Pump[nZones] pumpRad(
    each medium=medium,
    each useInput=true,
    m_flowNom=m_flowNom,
    each m=0,
    each etaTot=0.7,
    each dpFix=30000,
    each m_flowSet(fixed=false, start=0))
    annotation (Placement(transformation(extent={{54,46},{78,22}})));

  IDEAS.Thermal.Components.Emission.EmbeddedPipe[nZones] emission(
    each medium=medium,
    FHChars=FHChars,
    m_flowMin=m_flowNom)
    annotation (Placement(transformation(extent={{88,18},{120,50}})));

  Thermal.Components.BaseClasses.Pump pumpHeater(
    medium=medium,
    useInput=true,
    m_flowNom=sum(m_flowNom),
    m=0,
    dpFix=30000)
    annotation (Placement(transformation(extent={{-52,-26},{-68,-42}})));
public
  replaceable Controls.ControlHeating.Ctrl_Heating_combiTES HPControl(
    heatingCurve(timeFilter=timeFilter),
    TTankEmiOut=tesTank.nodes[posOutFH].T,
    DHW=true,
    TDHWSet=TDHWSet,
    TColdWaterNom=TDHWCold,
    TSupNom=TSupNom,
    dTSupRetNom=dTSupRetNom) constrainedby
    Controls.ControlHeating.Interfaces.Partial_Ctrl_Heating_TES(
    heatingCurve(timeFilter=timeFilter),
    DHW=true,
    TDHWSet=TDHWSet,
    TColdWaterNom=TDHWCold,
    TSupNom=TSupNom,
    dTSupRetNom=dTSupRetNom)
    annotation (Placement(transformation(extent={{-158,-18},{-138,2}})));

  Thermal.Components.Storage.StorageTank tesTank(
    flowPort_a(m_flow(start=0)),
    nbrNodes=nbrNodes,
    medium=medium,
    heightTank=1.8,
    volumeTank=volumeTank,
    TInitial={323.15 for i in 1:nbrNodes}) annotation (Placement(transformation(
        extent={{12,-18},{-12,18}},
        rotation=0,
        origin={-38,0})));

protected
  replaceable IDEAS.Thermal.Components.Domestic_Hot_Water.DHW_ProfileReader dHW(
    medium=medium,
    TDHWSet=TDHWSet,
    TCold=TDHWCold,
    VDayAvg=nOcc*0.045,
    profileType=3) constrainedby
    IDEAS.Thermal.Components.Domestic_Hot_Water.partial_DHW(
    medium=medium,
    TDHWSet=TDHWSet,
    TCold=TDHWCold)
    annotation (Placement(transformation(extent={{20,-2},{0,18}})));

  IDEAS.BaseClasses.Control.Hyst_NoEvent_Var_HEATING[nZones] heatingControl
    "onoff controller for the pumps of the radiator circuits"
    annotation (Placement(transformation(extent={{16,-76},{46,-46}})));
  Components.BaseClasses.Thermostatic3WayValve idealMixer(m=5, mFlowMin=0.01)
    annotation (Placement(transformation(extent={{28,22},{50,46}})));
  IDEAS.Thermal.Components.BaseClasses.Pipe pipeDHW(medium=medium, m=1)
    annotation (Placement(transformation(extent={{-36,-40},{-48,-28}})));
  IDEAS.Thermal.Components.BaseClasses.Pipe pipeMixer(medium=medium, m=1)
    annotation (Placement(transformation(extent={{-8,-40},{4,-28}})));
  IDEAS.Thermal.Components.BaseClasses.Pipe[nZones] pipeEmission(each medium=
        medium, each m=1)
    annotation (Placement(transformation(extent={{128,28},{140,40}})));
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
    annotation (Placement(transformation(extent={{18,68},{-2,88}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=
        293.15) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-52,100})));
protected
  IDEAS.Thermal.Components.BaseClasses.Pipe pipeDHW1(medium=medium, m=1)
    annotation (Placement(transformation(extent={{-8,-30},{4,-18}})));
equation

  HPControl.TTankTop = TSto[posTTop];
  HPControl.TTankBot = TSto[posTBot];

  QHeatTotal = -sum(emission.heatPortEmb.Q_flow) + dHW.m_flowTotal*medium.cp*(
    dHW.TMixed - dHW.TCold);
  THeaterSet = HPControl.THPSet;

  heatingControl.uHigh = TSet + 0.5*ones(nZones);

  P[1] = heater.PEl + pumpHeater.PEl + sum(pumpRad.PEl);
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

  connect(solarThermal.flowPort_b, tesTank.flowPorts[3]) annotation (Line(
      points={{-2,76},{-20,76},{-20,9.69231},{-50,9.69231}},
      color={0,128,255},
      smooth=Smooth.None));
  connect(solarThermal.flowPort_a, tesTank.flowPorts[nbrNodes + 1]) annotation (
     Line(
      points={{-2,72},{-24,72},{-24,9.69231},{-50,9.69231}},
      color={0,128,255},
      smooth=Smooth.None));

  // connections that are function of the number of circuits
  for i in 1:nZones loop
    connect(idealMixer.flowPortMixed, pumpRad[i].flowPort_a) annotation (Line(
        points={{50,34},{54,34}},
        color={0,128,255},
        smooth=Smooth.None));
    connect(pipeEmission[i].flowPort_b, pipeMixer.flowPort_b) annotation (Line(
        points={{140,34},{152,34},{152,-34},{4,-34}},
        color={0,128,255},
        pattern=LinePattern.Dash,
        smooth=Smooth.None));
  end for;

  // general connections for any configuration

  connect(emission.heatPortCon, heatPortCon) annotation (Line(
      points={{108,50},{108,62},{-200,62},{-200,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(emission.heatPortRad, heatPortRad) annotation (Line(
      points={{113.333,50},{113.333,64},{-200,64},{-200,-20}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(pumpRad.flowPort_b, emission.flowPort_a) annotation (Line(
      points={{78,34},{86,34},{86,24},{88,24}},
      color={0,128,255},
      smooth=Smooth.None));
  connect(tesTank.flowPort_b, pumpHeater.flowPort_a) annotation (Line(
      points={{-50,-15.2308},{-50,-34},{-52,-34}},
      color={0,128,255},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(dHW.flowPortHot, tesTank.flowPort_a) annotation (Line(
      points={{20,3.71429},{20,50},{-40,50},{-40,15.2308},{-50,15.2308}},
      color={0,128,255},
      smooth=Smooth.None));
  connect(TSensor, heatingControl.u) annotation (Line(
      points={{-204,-60},{-204,-64.75},{16.3333,-64.75}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heatingControl.y, pumpRad.m_flowSet) annotation (Line(
      points={{46.3333,-61},{66,-61},{66,22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSet, heatingControl.uLow) annotation (Line(
      points={{0,-104},{0,-49.75},{16.3333,-49.75}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pipeDHW.flowPort_a, tesTank.flowPort_b) annotation (Line(
      points={{-36,-34},{-50,-34},{-50,-15.2308}},
      color={0,128,255},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(idealMixer.flowPortCold, pipeMixer.flowPort_b) annotation (Line(
      points={{39,22},{39,-34},{4,-34}},
      color={0,128,255},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(pipeMixer.flowPort_a, tesTank.flowPort_b) annotation (Line(
      points={{-8,-34},{-50,-34},{-50,-15.2308}},
      color={0,128,255},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));

  connect(pumpHeater.flowPort_b, heater.flowPort_a) annotation (Line(
      points={{-68,-34},{-76,-34},{-76,19.6364},{-90,19.6364}},
      color={0,128,255},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));

  connect(emission.heatPortEmb, heatPortEmb) annotation (Line(
      points={{94.6667,49.6},{70,49.6},{70,60},{-200,60}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(HPControl.THeaCur, idealMixer.TMixedSet) annotation (Line(
      points={{-137.556,-13},{-126,-13},{-126,58},{39,58},{39,46}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HPControl.onOff, pumpHeater.m_flowSet) annotation (Line(
      points={{-137.778,-8},{-126,-8},{-126,-50},{-60,-50},{-60,-42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HPControl.THPSet, heater.TSet) annotation (Line(
      points={{-137.778,-3},{-125.85,-3},{-125.85,28},{-113.7,28},{-113.7,34},{
          -101,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pipeEmission.flowPort_a, emission.flowPort_b) annotation (Line(
      points={{128,34},{124,34},{124,44},{120,44}},
      color={0,128,255},
      smooth=Smooth.None));
  connect(tesTank.flowPorts[posOutFH], idealMixer.flowPortHot) annotation (Line(
      points={{-50,9.69231},{-10,9.69231},{-10,34},{28,34}},
      color={0,128,255},
      smooth=Smooth.None));
  connect(heater.flowPort_b, tesTank.flowPorts[2]) annotation (Line(
      points={{-90,24.9091},{-76,24.9091},{-76,34},{-24,34},{-24,9.69231},{-50,
          9.69231}},
      color={0,128,255},
      smooth=Smooth.None));

  connect(mDHW60C, dHW.mDHW60C) annotation (Line(
      points={{60,-104},{60,-36},{120,-36},{120,18},{10,18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heater.heatPort, fixedTemperature.port) annotation (Line(
      points={{-103,14},{-103,66},{-52,66},{-52,94}},
      color={191,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(tesTank.heatExchEnv, fixedTemperature.port) annotation (Line(
      points={{-46,-1.38462},{-52,-1.38462},{-52,94}},
      color={191,0,0},
      pattern=LinePattern.None,
      smooth=Smooth.None));
  connect(pumpHeater.flowPort_a, pipeDHW1.flowPort_a) annotation (Line(
      points={{-52,-34},{-40,-34},{-40,-24},{-8,-24}},
      color={0,128,255},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(pipeDHW1.flowPort_b, dHW.flowPortCold) annotation (Line(
      points={{4,-24},{1.77636e-015,-24},{1.77636e-015,3.71429}},
      color={0,128,255},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));

  connect(tesTank.T[1], solarThermal.TSafety) annotation (Line(
      points={{-50,4.15385},{-58,4.15385},{-58,4},{-64,4},{-64,85.8},{-2.8,85.8}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(tesTank.T[nbrNodes], solarThermal.TLow) annotation (Line(
      points={{-50,4.15385},{-58,4.15385},{-58,4},{-64,4},{-64,81.4},{-2.6,81.4}},
      color={0,0,127},
      smooth=Smooth.None));

  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-100},{
            200,100}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-200,-100},{200,
            100}})),
    Documentation(info="<html>
<p><b>Description</b> </p>
<p>Multi-zone hydraulic heating system with <a href=\"modelica://IDEAS.Thermal.Components.Emission.EmbeddedPipe\">embedded pipe</a> emission system (TABS). There is a thermal energy storage tank for the heating AND the domestic hot water (DHW) production. An optional solar thermal system is foreseen to (pre)heat the DHW storage tank.. A schematic hydraulic scheme is to be inserted here:</p>
<p>For multizone systems, the components <i>pumpRad</i>, <i>emission</i> and <i>pipeReturn</i> are arrays of size <i>nZones</i>. In this model, the <i>emission</i> is a an embedded pipe, the <i>heater</i> is a replaceable component and can be a boiler or heat pump or anything that extends from <a href=\"modelica://IDEAS.Thermal.Components.Production.Interfaces.PartialDynamicHeaterWithLosses\">PartialDynamicHeaterWithLosses</a>.</p>
<p>The storage tank is used for buffering space heating and DHW.  A simplification is made: the DHW is connected directly on the buffer, whereas for hygienic reasons, an additional heat exchanger is required. The outlet from the tank towards the space heating is somewhere in the middle of the tank, based on parameer <i>posOutFH</i>.  This ensures that the top of the tank stays hot for DHW while the supply temperature towards the floor heatings can be lower. </p>
<p>There are two controllers in the model (not represented in the hydraulic scheme): one for the heater set temperature and control signal of the pump for charging the storage tank (<a href=\"modelica://IDEAS.Thermal.Control.Ctrl_Heating_combiTES\">Ctrl_Heating_combiTES</a>), and another one for the on/off signal of <i>pumpRad</i> (= thermostat). The system is controlled based on a temperature measurement in each zone, a set temperature for each zone, temperature measurements in the storage tank and a general heating curve (not per zone). The heater will produce hot water at a temperature slightly above the required temperature, depending on the heat demand (space heating or DHW). The <i>idealMixer</i> will mix the supply flow rate with return water to reach the heating curve set point. Right after the <i>idealMixer</i>, the flow is splitted in <i>nZones</i> flows and each <i>pumpRad</i> will set the flowrate in the zonal distribution circuit based on the zone temperature and set point. </p>
<p>A solar thermal system is connected to the DHW storage tank (if <i>solSys</i>=true).</p>
<p>The heat losses of the heater and all the pipes are connected to a central fix temperature. </p>
<p><h4>Assumptions and limitations </h4></p>
<p><ol>
<li>Controllers try to limit or avoid events for faster simulation</li>
<li>Single heating curve for all zones</li>
<li>Heat emitted through <i>heatPortEmb</i> (to the core of a building construction layer or a <a href=\"modelica://IDEAS.Thermal.Components.Emission.NakedTabs\">nakedTabs</a>)</li>
<li>All pumps are on/off</li>
<li>No priority: both pumps can run simultaneously (could be improved).</li>
<li>CombiTES: space heating connections in the lower half, heat pump heats the whole tank.  </li>
<li>Configurable positions of all connections to the storage tank.</li>
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
<p>This is a system level model, no validation performed. To be correct, a DHW heat exchanger should be foreseen. </p>
<p><h4>Example </h4></p>
<p>An example of the use of this model can be found in<a href=\"modelica://IDEAS.Thermal.HeatingSystems.Examples.Heating_Embedded_combiTES_DHW_STS\"> IDEAS.Thermal.HeatingSystems.Examples.Heating_Embedded_combiTES_DHW_STS</a> .</p>
</html>", revisions="<html>
<p>2013 June, Roel De Coninck: minor edits and documentation</p>
<p>2012-2013, Roel De Coninck: many minor and major revisions</p>
<p>2011, Roel De Coninck: first version</p>
</html>"));
end Heating_Embedded_combiTES_DHW_STS;
