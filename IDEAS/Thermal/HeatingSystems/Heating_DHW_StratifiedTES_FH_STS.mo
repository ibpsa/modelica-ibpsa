within IDEAS.Thermal.HeatingSystems;
model Heating_DHW_StratifiedTES_FH_STS
  "Hydraulic heating+DHW with TES, FH and STS"
  import IDEAS.Thermal.Components.Emission.Interfaces.EmissionType;

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
  parameter Integer posOutFH(max=nbrNodes) = integer(ceil(nbrNodes/2));
  parameter Boolean solSys(fixed=true) = true;

protected
  Thermal.Components.BaseClasses.Pump[nZones] pumpRad(
    each medium=medium,
    each useInput=true,
    m_flowNom=m_flowNom,
    each m_flowSet(fixed=true, start=0),
    each m=0,
    each dpFix=30000,
    each etaTot=0.7)
    annotation (Placement(transformation(extent={{54,46},{78,22}})));

  IDEAS.Thermal.Components.Emission.EmbeddedPipe[ nZones] emission(
    each medium = medium,
    FHChars = FHChars,
    m_flowMin = m_flowNom)
    annotation (Placement(transformation(extent={{88,18},{120,50}})));

  Thermal.Components.BaseClasses.Pump pumpHeater(
    medium=medium,
    useInput=true,
    m_flowNom=sum(m_flowNom),
    m=0,
    dpFix=30000)
    annotation (Placement(transformation(extent={{-52,-26},{-68,-42}})));
public
  replaceable Thermal.Control.HPControl_HeatingCurve_Strat HPControl(
    heatingCurve(timeFilter=timeFilter),
    TTankTop=TSto[posTTop],
    TTankBot=TSto[posTBot],
    TTankEmiOut=tesTank.nodes[posOutFH].T,
    DHW=true,
    TDHWSet=TDHWSet,
    TColdWaterNom=TDHWCold,
    TSupNom=TSupNom,
    dTSupRetNom=dTSupRetNom) constrainedby Thermal.Control.PartialHPControl(
    heatingCurve(timeFilter=timeFilter),
    TTankTop=TSto[posTTop],
    TTankBot=TSto[posTBot],
    DHW=true,
    TDHWSet=TDHWSet,
    TColdWaterNom=TDHWCold,
    TSupNom=TSupNom,
    dTSupRetNom=dTSupRetNom)
      annotation (choicesAllMatching=true, Placement(transformation(extent={{-158,
            -18},{-138,2}})));

  Thermal.Components.Storage.StorageTank tesTank(
    flowPort_a(m_flow(start=0)),
    nbrNodes=nbrNodes,
    medium=medium,
    heightTank=1.8,
    volumeTank=volumeTank,
    TInitial={323.15 for i in 1:nbrNodes})                annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-40,8})));

protected
  replaceable IDEAS.Thermal.Components.Domestic_Hot_Water.DHW_ProfileReader
                                                              dHW(
    medium=medium,
    TDHWSet=TDHWSet,
    TCold=TDHWCold,
    VDayAvg=nOcc*0.045,
    profileType=3) constrainedby
    IDEAS.Thermal.Components.Domestic_Hot_Water.partial_DHW(
      medium=medium,
      TDHWSet=TDHWSet,
      TCold=TDHWCold)
    annotation (choicesAllMatching=true, Placement(transformation(extent={{20,-2},
            {0,18}})));

  IDEAS.BaseClasses.Control.Hyst_NoEvent_Var_HEATING[
                               nZones] heatingControl
    "onoff controller for the pumps of the radiator circuits"
    annotation (Placement(transformation(extent={{16,-76},{46,-46}})));
  Components.BaseClasses.Thermostatic3WayValve
                                            idealMixer(mFlowMin=0.01, pumpCold(
        m=5))
    annotation (Placement(transformation(extent={{28,22},{50,46}})));
  IDEAS.Thermal.Components.BaseClasses.Pipe   pipeDHW(medium=medium, m=1)
    annotation (Placement(transformation(extent={{-36,-40},{-48,-28}})));
  IDEAS.Thermal.Components.BaseClasses.Pipe   pipeMixer(medium=medium, m=1)
    annotation (Placement(transformation(extent={{-8,-40},{4,-28}})));
  IDEAS.Thermal.Components.BaseClasses.Pipe[  nZones] pipeEmission(each medium=
        medium, each m=1)
    annotation (Placement(transformation(extent={{128,28},{140,40}})));
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
    annotation (Placement(transformation(extent={{80,80},{60,100}})));
  Modelica.Blocks.Interfaces.RealOutput TTop "TES top temperature"              annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=0,
        origin={145,125})));
  Modelica.Blocks.Interfaces.RealOutput TBot "TES top temperature"             annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=0,
        origin={145,115})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=293.15)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-52,100})));
protected
  IDEAS.Thermal.Components.BaseClasses.Pipe   pipeDHW1(
                                                      medium=medium, m=1)
    annotation (Placement(transformation(extent={{-8,-30},{4,-18}})));
equation
  QHeatTotal = -sum(emission.heatPortEmb.Q_flow) + dHW.m_flowTotal * medium.cp * (dHW.TMixed - dHW.TCold);
  THeaterSet = HPControl.THPSet;

  heatingControl.uHigh = TSet + 0.5 * ones(nZones);

  P[1] = heater.PEl + pumpHeater.PEl + sum(pumpRad.PEl);
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

  connect(solarThermal.flowPort_b, tesTank.flowPorts[3])
                                                       annotation (Line(
      points={{60,88},{-20,88},{-20,13.3846},{-50,13.3846}},
      color={0,128,255},
      smooth=Smooth.None));
  connect(solarThermal.flowPort_a, tesTank.flowPorts[nbrNodes+1])
                                                       annotation (Line(
      points={{60,84},{-24,84},{-24,13.3846},{-50,13.3846}},
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

  connect(pumpRad.flowPort_b,emission. flowPort_a)
                                                annotation (Line(
      points={{78,34},{86,34},{86,24},{88,24}},
      color={0,128,255},
      smooth=Smooth.None));
  connect(tesTank.flowPort_b, pumpHeater.flowPort_a) annotation (Line(
      points={{-50,-0.461538},{-50,-34},{-52,-34}},
      color={0,128,255},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(dHW.flowPortHot, tesTank.flowPort_a) annotation (Line(
      points={{20,3.71429},{20,50},{-40,50},{-40,16.4615},{-50,16.4615}},
      color={0,128,255},
      smooth=Smooth.None));
  connect(TSensor, heatingControl.u) annotation (Line(
      points={{-204,-60},{-204,-64.75},{16.3333,-64.75}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heatingControl.y, pumpRad.m_flowSet) annotation (Line(
      points={{46.3333,-61},{66,-61},{66,22},{66,22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSet, heatingControl.uLow) annotation (Line(
      points={{0,-104},{0,-49.75},{16.3333,-49.75}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pipeDHW.flowPort_a, tesTank.flowPort_b) annotation (Line(
      points={{-36,-34},{-50,-34},{-50,-0.461538}},
      color={0,128,255},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(idealMixer.flowPortCold, pipeMixer.flowPort_b) annotation (Line(
      points={{39,22},{39,-34},{4,-34}},
      color={0,128,255},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(pipeMixer.flowPort_a, tesTank.flowPort_b) annotation (Line(
      points={{-8,-34},{-50,-34},{-50,-0.461538}},
      color={0,128,255},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));

  connect(pumpHeater.flowPort_b, heater.flowPort_a) annotation (Line(
      points={{-68,-34},{-68,-34},{-76,-34},{-76,19.6364},{-90,19.6364}},
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
      points={{-50,13.3846},{-10,13.3846},{-10,34},{28,34}},
      color={0,128,255},
      smooth=Smooth.None));
  connect(heater.flowPort_b, tesTank.flowPorts[2]) annotation (Line(
      points={{-90,24.9091},{-76,24.9091},{-76,34},{-24,34},{-24,13.3846},{-50,
          13.3846}},
      color={0,128,255},
      smooth=Smooth.None));

  connect(TTop, solarThermal.TSafety) annotation (Line(
      points={{145,125},{16,125},{16,97.8},{59.2,97.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TBot, solarThermal.TLow) annotation (Line(
      points={{145,115},{18,115},{18,93.4},{59.4,93.4}},
      color={0,0,127},
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
      points={{-46.6667,7.23077},{-52,7.23077},{-52,94}},
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

  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-200,
            -100},{200,100}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-200,-100},{200,100}})));
end Heating_DHW_StratifiedTES_FH_STS;
