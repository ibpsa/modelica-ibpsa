within IDEAS.Thermal.HeatingSystems;
model Heating_FH_TESandSTSforDHWonly
  "Hydraulic heating with FH, TES and STS only for DHW"
  import IDEAS.Thermal.Components.Emission.Interfaces.EmissionType;

  extends Thermal.HeatingSystems.Partial_HydraulicHeatingSystem(
    final emissionType=EmissionType.FloorHeating,
    nLoads=1);

  parameter Modelica.SIunits.Volume volumeTank=0.25;
  parameter Modelica.SIunits.Area AColTot=1 "TOTAL collector area";
  parameter Integer nbrNodes=10 "Number of nodes in the tank";
  parameter Integer posTTop(max=nbrNodes) = 1
    "Position of the top temperature sensor";
  parameter Integer posTBot(max=nbrNodes) = nbrNodes-2
    "Position of the bottom temperature sensor";
  parameter Integer posOutHP(max=nbrNodes+1) = if solSys then nbrNodes-1 else nbrNodes+1
    "Position of extraction of TES to HP";
  parameter Integer posInSTS( max=nbrNodes) = nbrNodes-1
    "Position of injection of STS in TES";
  parameter Boolean solSys(fixed=true) = false;

  Components.BaseClasses.Pump_Insulated[
                                      nZones] pumpRad(
    each medium=medium,
    each useInput=true,
    m_flowNom=m_flowNom,
    each m_flowSet(start=0),
    each etaTot=0.7,
    UA=1,
    each m=0,
    each dpFix=30000)
    annotation (Placement(transformation(extent={{94,-4},{110,12}})));

  IDEAS.Thermal.Components.Emission.EmbeddedPipeDynTOut[
                                                  nZones] emission(
    each medium = medium,
    FHChars = FHChars,
    m_flowMin = m_flowNom)
    annotation (Placement(transformation(extent={{120,-4},{136,14}})));

  Components.BaseClasses.Pump_Insulated pumpSto(
    medium=medium,
    useInput=true,
    m_flowNom=sum(m_flowNom),
    UA=1,
    m=0,
    dpFix=30000) "Pump for loading the storage tank"
    annotation (Placement(transformation(extent={{-34,-68},{-50,-52}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=293.15)
    annotation (Placement(transformation(extent={{-134,34},{-122,46}})));
public
  replaceable Thermal.Control.HPControl_SepDHW_Emission HPControl(
    timeFilter=timeFilter,
    TTankTop=TSto[posTTop],
    TTankBot=TSto[posTBot],
    DHW=true,
    TDHWSet=TDHWSet,
    TColdWaterNom=TDHWCold,
    TSupNom=TSupNom,
    dTSupRetNom=dTSupRetNom) constrainedby Thermal.Control.PartialHPControl(
    timeFilter=timeFilter,
    TTankTop=TSto[posTTop],
    TTankBot=TSto[posTBot],
    DHW=true,
    TDHWSet=TDHWSet,
    TColdWaterNom=TDHWCold,
    TSupNom=TSupNom,
    dTSupRetNom=dTSupRetNom)
      annotation (choicesAllMatching=true, Placement(transformation(extent={{-162,
            -12},{-142,8}})));

  Components.Storage.StorageTank_OneIntHX tesTank(
    flowPort_a(m_flow(start=0)),
    nbrNodes=nbrNodes,
    medium=medium,
    mediumHX=medium,
    heightTank=1.8,
    volumeTank=volumeTank,
    TInitial={323.15 for i in 1:nbrNodes})                annotation (Placement(
        transformation(
        extent={{-17,-19},{17,19}},
        rotation=0,
        origin={-11,-23})));

  replaceable IDEAS.Thermal.Components.DHW.DHW_ProfileReader  dHW(
    medium=medium,
    TDHWSet=TDHWSet,
    TCold=TDHWCold,
    VDayAvg=nOcc*0.045,
    profileType=3) constrainedby IDEAS.Thermal.Components.DHW.partial_DHW(
      medium=medium,
      TDHWSet=TDHWSet,
      TCold=TDHWCold)
    annotation (choicesAllMatching = true, Placement(transformation(extent={{-56,-32},
            {-46,-16}})));

protected
  IDEAS.BaseClasses.Control.Hyst_NoEvent_Var_HEATING[
                               nZones] heatingControl
    "onoff controller for the pumps of the radiator circuits"
    annotation (Placement(transformation(extent={{64,30},{84,50}})));
  Thermal.Components.BaseClasses.IdealMixer idealMixer
    annotation (Placement(transformation(extent={{66,-6},{86,16}})));
  IDEAS.Thermal.Components.BaseClasses.Pipe   pipeDHW(medium=medium, m=1)
    annotation (Placement(transformation(extent={{-36,-48},{-48,-36}})));
  Components.BaseClasses.Pipe_Insulated       pipeMixer(medium=medium, m=1,
    UA=1)
    annotation (Placement(transformation(extent={{24,-82},{36,-70}})));
  Components.BaseClasses.Pipe_Insulated[      nZones] pipeEmission(each medium=
        medium, each m=1,
    UA=1)
    annotation (Placement(transformation(extent={{146,0},{158,12}})));
  // Result variables
public
  Modelica.SIunits.Temperature[nbrNodes] TSto=tesTank.nodes.heatPort.T;
  Modelica.SIunits.Temperature TTankTopSet;
  Modelica.SIunits.Temperature TTankBotIn;
  Modelica.SIunits.MassFlowRate m_flowDHW;
  Modelica.SIunits.Power QDHW;
  Real SOCTank;

  Thermal.Components.Production.SolarThermalSystem_Simple solarThermal(
    medium=medium,
    pump(dpFix=100000, etaTot=0.6),
    ACol=AColTot,
    nCol=1) if solSys
    annotation (Placement(transformation(extent={{58,-22},{38,-2}})));
  Modelica.Blocks.Interfaces.RealOutput TTop "TES top temperature"              annotation (Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=0,
        origin={22,-4})));
  Modelica.Blocks.Interfaces.RealOutput TBot "TES top temperature"             annotation (Placement(transformation(
        extent={{-4,4},{4,-4}},
        rotation=0,
        origin={22,-8})));
  Components.BaseClasses.AbsolutePressure absolutePressure(medium=medium, p=300000)
    annotation (Placement(transformation(extent={{-14,-64},{-6,-56}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector thermalCollector(m=
        nZones)
    annotation (Placement(transformation(extent={{92,-32},{112,-12}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector thermalCollector1(m=
       nZones)
    annotation (Placement(transformation(extent={{142,-32},{162,-12}})));
equation
  QHeatTotal = -sum(emission.heatPortEmb.Q_flow) + dHW.m_flowTotal * medium.cp * (dHW.TMixed - dHW.TCold);
  THeaterSet = HPControl.THPSet;

  heatingControl.uHigh = TSet + 0.5 * ones(nZones);

  P[1] = heater.PEl + pumpSto.PEl + sum(pumpRad.PEl);
  Q[1] = 0;
  TTankTopSet = HPControl.TTopSet;
  TDHW = dHW.TMixed;
  TTankBotIn = tesTank.flowPort_b.h / medium.cp;
  TEmissionIn = idealMixer.flowPortMixed.h / medium.cp;
  TEmissionOut = emission.TOut;
  m_flowEmission = emission.flowPort_a.m_flow;
  m_flowDHW = dHW.m_flowTotal;
  SOCTank = HPControl.SOC;
  QDHW = m_flowDHW * medium.cp * ( TDHW - dHW.TCold);

//STS
  TTop = TSto[1];
  TBot = TSto[nbrNodes];

  connect(solarThermal.flowPort_b, tesTank.flowPorts[posInSTS])
                                                       annotation (Line(
      points={{38,-14},{38,-14},{16,-14},{16,-12.7692},{6,-12.7692}},
      color={0,128,255},
      smooth=Smooth.Bezier));
  connect(solarThermal.flowPort_a, tesTank.flowPorts[nbrNodes+1])
                                                       annotation (Line(
      points={{38,-18},{38,-18},{24,-18},{24,-20},{18,-23},{6,-12.7692}},
      color={0,128,255},
      smooth=Smooth.Bezier));

// connections that are function of the number of circuits
for i in 1:nZones loop
  connect(idealMixer.flowPortMixed, pumpRad[i].flowPort_a);
  connect(pipeEmission[i].flowPort_b, pipeMixer.flowPort_b);
end for;

// general connections for any configuration

    connect(emission.heatPortCon, heatPortCon) annotation (Line(
      points={{130,14},{130,14},{130,52},{-192,52},{-192,20},{-200,20}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(emission.heatPortRad, heatPortRad) annotation (Line(
      points={{132.667,14},{134,44},{134,50},{-188,50},{-188,-20},{-200,-20}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(pumpRad.flowPort_b,emission. flowPort_a)
                                                annotation (Line(
      points={{110,4},{120,4},{120,-0.625}},
      color={0,128,255},
      smooth=Smooth.None));
  connect(fixedTemperature.port, tesTank.heatExchEnv) annotation (Line(
      points={{-122,40},{2,40},{2,-24.4615},{0.333333,-24.4615}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(dHW.flowPortHot, tesTank.flowPort_a) annotation (Line(
      points={{-56,-27.4286},{-56,-10},{-46,-10},{-46,-2},{-12,-2},{-12,
          -6.92308},{6,-6.92308}},
      color={0,128,255},
      smooth=Smooth.None));
  connect(TSensor, heatingControl.u) annotation (Line(
      points={{-204,-60},{-176,-60},{-176,24},{-56,24},{-56,37.5},{64.2222,37.5}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(heatingControl.y, pumpRad.m_flowSet) annotation (Line(
      points={{84.2222,40},{104.133,40},{104.133,12.2}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(TSet, heatingControl.uLow) annotation (Line(
      points={{0,-104},{0,47.5},{64.2222,47.5}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(dHW.flowPortCold, pipeDHW.flowPort_b) annotation (Line(
      points={{-46,-27.4286},{-46,-42},{-48,-42}},
      color={0,128,255},
      smooth=Smooth.None));
  connect(pipeDHW.flowPort_a, tesTank.flowPort_b) annotation (Line(
      points={{-36,-42},{-23.415,-42},{-23.415,-39.0769},{6,-39.0769}},
      color={0,128,255},
      smooth=Smooth.None));
  connect(idealMixer.flowPortCold, pipeMixer.flowPort_b) annotation (Line(
      points={{76,-6},{76,-76},{36,-76}},
      color={0,128,255},
      smooth=Smooth.None));
  connect(fixedTemperature.port, heater.heatPort)       annotation (Line(
      points={{-122,40},{-112,40},{-112,32},{-103,32},{-103,14}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(emission.heatPortEmb, heatPortEmb) annotation (Line(
      points={{123.333,13.775},{122,13.775},{122,60},{-192,60},{-192,60},{-200,
          60},{-200,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(HPControl.THeaCur, idealMixer.TMixedSet) annotation (Line(
      points={{-141.556,-7},{-136,-7},{-136,18},{76,18},{76,16}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(HPControl.onOff, pumpSto.m_flowSet)    annotation (Line(
      points={{-141.778,-2},{-130,-2},{-130,-48},{-44.1333,-48},{-44.1333,-51.8}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(HPControl.THPSet, heater.TSet) annotation (Line(
      points={{-141.778,3},{-120,3},{-120,34},{-101,34}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.DashDot));
  connect(pipeEmission.flowPort_a, emission.flowPort_b) annotation (Line(
      points={{146,6},{135,6},{135,10.625},{136,10.625}},
      color={0,128,255},
      smooth=Smooth.None));

  connect(TTop, solarThermal.TSafety) annotation (Line(
      points={{22,-4},{37.2,-4},{37.2,-4.2}},
      color={0,0,127},
      smooth=Smooth.Bezier,
      pattern=LinePattern.DashDot));
  connect(TBot, solarThermal.TLow) annotation (Line(
      points={{22,-8},{37.4,-8},{37.4,-8.6}},
      color={0,0,127},
      smooth=Smooth.Bezier,
      pattern=LinePattern.DashDot));
  connect(mDHW60C, dHW.mDHW60C) annotation (Line(
      points={{60,-104},{60,-84},{-80,-84},{-80,-16},{-51,-16}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(pipeMixer.flowPort_a, heater.flowPort_a) annotation (Line(
      points={{24,-76},{-64,-76},{-64,19.6364},{-90,19.6364}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pumpSto.flowPort_b, heater.flowPort_a) annotation (Line(
      points={{-50,-60},{-64,-60},{-64,19.6364},{-90,19.6364}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(heater.heatPort, fixedTemperature.port) annotation (Line(
      points={{-103,14},{-102,14},{-102,40},{-122,40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(absolutePressure.flowPort, pumpSto.flowPort_a) annotation (Line(
      points={{-14,-60},{-34,-60}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(tesTank.flowPortHXLower, pumpSto.flowPort_a) annotation (Line(
      points={{-28,-36.1538},{-30,-36.1538},{-30,-60},{-34,-60}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(heater.flowPort_b, idealMixer.flowPortHot) annotation (Line(
      points={{-90,24.9091},{-34,24.9091},{-34,5},{66,5}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(heater.flowPort_b, tesTank.flowPortHXUpper) annotation (Line(
      points={{-90,24.9091},{-34,24.9091},{-34,-30.3077},{-28,-30.3077}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pipeMixer.heatPort, fixedTemperature.port) annotation (Line(
      points={{30,-82},{30,-82},{-118,-82},{-118,40},{-122,40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pumpRad.heatPort, thermalCollector.port_a) annotation (Line(
      points={{98.8,-4},{98.8,-8},{102,-8},{102,-12}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalCollector.port_b, fixedTemperature.port) annotation (Line(
      points={{102,-32},{102,-86},{-118,-86},{-118,40},{-122,40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pipeEmission.heatPort, thermalCollector1.port_a) annotation (Line(
      points={{152,0},{152,-12}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalCollector1.port_b, fixedTemperature.port) annotation (Line(
      points={{152,-32},{152,-86},{-118,-86},{-118,40},{-122,40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pumpSto.heatPort, fixedTemperature.port) annotation (Line(
      points={{-38.8,-68},{-38.8,-70},{-118,-70},{-118,40},{-122,40}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-200,
            -100},{200,100}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-200,-100},{200,100}})));
end Heating_FH_TESandSTSforDHWonly;
