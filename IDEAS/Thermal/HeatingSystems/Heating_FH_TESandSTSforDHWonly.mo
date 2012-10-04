within IDEAS.Thermal.HeatingSystems;
model Heating_FH_TESandSTSforDHWonly
  "Hydraulic heating with FH, TES and STS only for DHW"
  import IDEAS.Thermal.Components.Emission.Auxiliaries.EmissionType;

  extends Thermal.HeatingSystems.Partial_HydraulicHeatingSystem(
    final emissionType=EmissionType.FloorHeating,
    nLoads=1);

  parameter Modelica.SIunits.Volume volumeTank=0.25;
  parameter Modelica.SIunits.Area AColTot=1 "TOTAL collector area";
  parameter Integer nbrNodes=4 "Number of nodes in the tank";
  parameter Integer posTTop(max=nbrNodes) = 1
    "Position of the top temperature sensor";
  parameter Integer posTBot(max=nbrNodes) = nbrNodes-1
    "Position of the bottom temperature sensor";
  parameter Integer posOutHP(max=nbrNodes) = if solSys then nbrNodes-1 else nbrNodes
    "Position of extraction of TES to HP";
  parameter Integer posInSTS( max=nbrNodes) = nbrNodes-1
    "Position of injection of STS in TES";
  parameter Boolean solSys(fixed=true) = false;

protected
  Thermal.Components.BaseClasses.Pump[nZones] pumpRad(
    each medium=medium,
    each useInput=true,
    m_flowNom=m_flowNom,
    each m_flowSet(fixed=true, start=0),
    each m=0,
    each dpFix=30000,
    each etaTot=0.7)
    annotation (Placement(transformation(extent={{98,-36},{114,-20}})));

  IDEAS.Thermal.Components.Emission.EmbeddedPipeDynTOut[
                                                  nZones] emission(
    each medium = medium,
    FHChars = FHChars,
    m_flowMin = m_flowNom)
    annotation (Placement(transformation(extent={{128,-36},{144,-18}})));

  Thermal.Components.BaseClasses.Pump pumpSto(
    medium=medium,
    useInput=true,
    m_flowNom=sum(m_flowNom),
    m=0,
    dpFix=30000) "Pump for loading the storage tank"
    annotation (Placement(transformation(extent={{-36,-68},{-52,-52}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=293.15)
    annotation (Placement(transformation(extent={{-134,34},{-122,46}})));
public
  replaceable Thermal.Control.HPControl_SepDHW_Emission HPControl(
    heatingCurve(timeFilter=timeFilter),
    TTankTop=TSto[posTTop],
    TTankBot=TSto[posTBot],
    DHW=true,
    TDHWSet=TDHWSet,
    TColdWaterNom=TDHWCold,
    dTSupRetNom=dTSupRetNom) constrainedby Thermal.Control.PartialHPControl(
    heatingCurve(timeFilter=timeFilter),
    TTankTop=TSto[posTTop],
    TTankBot=TSto[posTBot],
    DHW=true,
    TDHWSet=TDHWSet,
    TColdWaterNom=TDHWCold,
    dTSupRetNom=dTSupRetNom)
      annotation (choicesAllMatching=true, Placement(transformation(extent={{-144,-14},{-124,6}})));

  Thermal.Components.Storage.StorageTank tesTank(
    flowPort_a(m_flow(start=0)),
    nbrNodes=nbrNodes,
    medium=medium,
    heightTank=1.8,
    volumeTank=volumeTank,
    TInitial={323.15 for i in 1:nbrNodes})                annotation (Placement(
        transformation(
        extent={{17,-19},{-17,19}},
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
    annotation (choicesAllMatching = true, Placement(transformation(extent={{-56,-28},{-46,-12}})));

protected
  IDEAS.BaseClasses.Control.Hyst_NoEvent_Var_HEATING[
                               nZones] heatingControl
    "onoff controller for the pumps of the radiator circuits"
    annotation (Placement(transformation(extent={{64,30},{84,50}})));
  Thermal.Components.BaseClasses.IdealMixer idealMixer
    annotation (Placement(transformation(extent={{66,-12},{86,10}})));
  Thermal.Components.BaseClasses.IsolatedPipe pipeDHW(medium=medium, m=1)
    annotation (Placement(transformation(extent={{-36,-48},{-48,-36}})));
  Thermal.Components.BaseClasses.IsolatedPipe pipeMixer(medium=medium, m=1)
    annotation (Placement(transformation(extent={{50,-80},{62,-68}})));
  Thermal.Components.BaseClasses.IsolatedPipe[nZones] pipeEmission(each medium=
        medium, each m=1)
    annotation (Placement(transformation(extent={{164,-32},{176,-20}})));
  // Result variables
public
  output Modelica.SIunits.Temperature[nbrNodes] TSto=tesTank.nodes.heatPort.T;
  output Modelica.SIunits.Temperature TTankTopSet;
  output Modelica.SIunits.Temperature TTankBotIn;
  output Modelica.SIunits.MassFlowRate m_flowDHW;
  output Modelica.SIunits.Power QDHW;
  output Real SOCTank;

  Thermal.Components.Production.SolarThermalSystem_Simple solarThermal(
    medium=medium,
    pump(dpFix=100000, etaTot=0.6),
    ACol=AColTot,
    nCol=1) if solSys
    annotation (Placement(transformation(extent={{52,-22},{32,-2}})));
  Modelica.Blocks.Interfaces.RealOutput TTop "TES top temperature"              annotation (Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=0,
        origin={22,-4})));
  Modelica.Blocks.Interfaces.RealOutput TBot "TES top temperature"             annotation (Placement(transformation(
        extent={{-4,4},{4,-4}},
        rotation=0,
        origin={22,-8})));
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
      points={{32,-14},{30,-14},{16,-14},{16,-23},{-0.8,-23}},
      color={0,128,255},
      smooth=Smooth.Bezier));
  connect(solarThermal.flowPort_a, tesTank.flowPorts[nbrNodes+1])
                                                       annotation (Line(
      points={{32,-18},{32,-18},{24,-18},{24,-20},{18,-23},{-0.8,-23}},
      color={0,128,255},
      smooth=Smooth.Bezier));

// connections that are function of the number of circuits
for i in 1:nZones loop
  connect(idealMixer.flowPortMixed, pumpRad[i].flowPort_a);
  connect(pipeEmission[i].flowPort_b, pipeMixer.flowPort_b);
end for;

// general connections for any configuration

    connect(emission.heatPortCon, heatPortCon) annotation (Line(
      points={{137.6,-18},{130,4},{130,30},{-200,30},{-200,20}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(emission.heatPortRad, heatPortRad) annotation (Line(
      points={{140.8,-18},{134,22},{134,28},{-180,28},{-180,-20},{-200,-20}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(pumpRad.flowPort_b,emission. flowPort_a)
                                                annotation (Line(
      points={{114,-28},{128,-28},{128,-27}},
      color={0,128,255},
      smooth=Smooth.None));
  connect(tesTank.flowPorts[posOutHP], pumpSto.flowPort_a)    annotation (Line(
      points={{-0.8,-23},{-0.8,-60},{-36,-60}},
      color={0,128,255},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(fixedTemperature.port, tesTank.heatExchEnv) annotation (Line(
      points={{-122,40},{-36,40},{-36,-23},{-21.54,-23}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(dHW.flowPortHot, tesTank.flowPort_a) annotation (Line(
      points={{-51,-12},{-51,-4},{-10.66,-4}},
      color={0,128,255},
      smooth=Smooth.None));
  connect(TSensor, heatingControl.u) annotation (Line(
      points={{-196,-60},{-176,-60},{-176,24},{-56,24},{-56,34},{63,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heatingControl.y, pumpRad.m_flowSet) annotation (Line(
      points={{84.6,40},{106,40},{106,-20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSet, heatingControl.uLow) annotation (Line(
      points={{0,-90},{0,72},{46,72},{46,48},{63.2,48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dHW.flowPortCold, pipeDHW.flowPort_b) annotation (Line(
      points={{-51,-28},{-51,-42},{-48,-42}},
      color={0,128,255},
      smooth=Smooth.None));
  connect(pipeDHW.flowPort_a, tesTank.flowPort_b) annotation (Line(
      points={{-36,-42},{-11,-42}},
      color={0,128,255},
      smooth=Smooth.None));
  connect(idealMixer.flowPortCold, pipeMixer.flowPort_b) annotation (Line(
      points={{76,-7.6},{76,-74},{62,-74}},
      color={0,128,255},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));

  connect(pumpSto.flowPort_b, heater.flowPort_a)    annotation (Line(
      points={{-52,-60},{-68,-60},{-68,-4},{-72,-4}},
      color={0,128,255},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(fixedTemperature.port, heater.heatPort) annotation (Line(
      points={{-122,40},{-112,40},{-112,32},{-82,32},{-82,8}},
      color={191,0,0},
      smooth=Smooth.None));

    connect(emission.heatPortEmb, heatPortEmb) annotation (Line(
      points={{129.12,-18},{124,-18},{124,58},{-200,58},{-200,60}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(HPControl.THeaCur, idealMixer.TMixedSet) annotation (Line(
      points={{-123.4,-6},{-108,-6},{-108,18},{76,18},{76,10.66}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HPControl.onOff, pumpSto.m_flowSet)    annotation (Line(
      points={{-123.4,-2},{-114,-2},{-114,-48},{-44,-48},{-44,-52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HPControl.THPSet, heater.TSet) annotation (Line(
      points={{-123.4,2},{-104,2},{-104,-2},{-92.6,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pipeEmission.flowPort_a, emission.flowPort_b) annotation (Line(
      points={{164,-26},{143,-26},{143,-27},{144,-27}},
      color={0,128,255},
      smooth=Smooth.None));
  connect(heater.flowPort_b, tesTank.flowPorts[2]) annotation (Line(
      points={{-72,0},{-62,0},{-62,10},{-0.8,10},{-0.8,-23}},
      color={0,128,255},
      smooth=Smooth.None));

  connect(heater.flowPort_b, idealMixer.flowPortHot) annotation (Line(
      points={{-72,0},{-66,0},{-66,16},{58,16},{58,-2},{70,-2},{70,-1}},
      color={0,128,255},
      smooth=Smooth.None));
  connect(pipeMixer.flowPort_a, heater.flowPort_a) annotation (Line(
      points={{50,-74},{-68,-74},{-68,-4},{-72,-4}},
      color={0,128,255},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(TTop, solarThermal.TSafety) annotation (Line(
      points={{22,-4},{31.2,-4},{31.2,-4.2}},
      color={0,0,127},
      smooth=Smooth.Bezier));
  connect(TBot, solarThermal.TLow) annotation (Line(
      points={{22,-8},{31.4,-8},{31.4,-8.6}},
      color={0,0,127},
      smooth=Smooth.Bezier));
  connect(mDHW60C, dHW.mDHW60C) annotation (Line(
      points={{120,-90},{120,-76},{-80,-76},{-80,-20},{-56.3,-20}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-200,
            -100},{200,100}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-200,-100},{200,100}})));
end Heating_FH_TESandSTSforDHWonly;
