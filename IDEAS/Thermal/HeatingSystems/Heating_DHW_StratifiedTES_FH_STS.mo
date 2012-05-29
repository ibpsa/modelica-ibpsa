within IDEAS.Thermal.HeatingSystems;
model Heating_DHW_StratifiedTES_FH_STS
  "Hydraulic heating+DHW with TES, FH and STS"
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
    annotation (Placement(transformation(extent={{24,-4},{42,14}})));

  IDEAS.Thermal.Components.Emission.EmbeddedPipeDynTOut[
                                                  nZones] emission(
    each medium = medium,
    FHChars = FHChars,
    m_flowMin = m_flowNom)
    annotation (Placement(transformation(extent={{50,-4},{66,14}})));

  Thermal.Components.BaseClasses.Pump pumpHeater(
    medium=medium,
    useInput=true,
    m_flowNom=sum(m_flowNom),
    m=0,
    dpFix=30000)
    annotation (Placement(transformation(extent={{-44,-84},{-60,-68}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=293.15)
    annotation (Placement(transformation(extent={{-90,26},{-78,38}})));
public
  replaceable Thermal.Control.HPControl_HeatingCurve_Strat HPControl(
    heatingCurve(timeFilter=timeFilter),
    TTankTop=TSto[posTTop],
    TTankBot=TSto[posTBot],
    TTankEmiOut=tesTank.nodes[posOutFH].T,
    DHW=true,
    TDHWSet=TDHWSet,
    TColdWaterNom=TDHWCold,
    dTSupRetNom=dTSupRetNom)
      annotation (Placement(transformation(extent={{-144,-14},{-124,6}})));

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
        origin={-26,-14})));

protected
  Thermal.Components.BaseClasses.DomesticHotWater dHW(
    medium=medium,
    TDHWSet=TDHWSet,
    TCold=TDHWCold,
    VDayAvg=nOcc*0.045,
    profileType=3)
    annotation (Placement(transformation(extent={{-56,-22},{-46,-6}})));

  IDEAS.BaseClasses.Control.Hyst_NoEvent_Var_HEATING[
                               nZones] heatingControl
    "onoff controller for the pumps of the radiator circuits"
    annotation (Placement(transformation(extent={{30,28},{50,48}})));
  Thermal.Components.BaseClasses.IdealMixer idealMixer(mFlowMin=0.01, pumpCold(
        m=5))
    annotation (Placement(transformation(extent={{-4,-6},{16,16}})));
  Thermal.Components.BaseClasses.IsolatedPipe pipeDHW(medium=medium, m=1)
    annotation (Placement(transformation(extent={{-36,-40},{-48,-28}})));
  Thermal.Components.BaseClasses.IsolatedPipe pipeMixer(medium=medium, m=1)
    annotation (Placement(transformation(extent={{-12,-50},{0,-38}})));
  Thermal.Components.BaseClasses.IsolatedPipe[nZones] pipeEmission(each medium=
        medium, each m=1)
    annotation (Placement(transformation(extent={{76,0},{88,12}})));
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
    annotation (Placement(transformation(extent={{-14,-82},{6,-62}})));
  Modelica.Blocks.Interfaces.RealOutput TTop "TES top temperature"              annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=0,
        origin={41,-47})));
  Modelica.Blocks.Interfaces.RealOutput TBot "TES top temperature"             annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=0,
        origin={41,-59})));
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
      points={{6,-74},{20,-74},{20,-14},{-16,-14}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(solarThermal.flowPort_a, tesTank.flowPorts[nbrNodes+1])
                                                       annotation (Line(
      points={{6,-78},{24,-78},{24,-14},{-16,-14}},
      color={255,0,0},
      smooth=Smooth.None));

// connections that are function of the number of circuits
for i in 1:nZones loop
  connect(idealMixer.flowPortMixed, pumpRad[i].flowPort_a);
  connect(pipeEmission[i].flowPort_b, pipeMixer.flowPort_b);
end for;

// general connections for any configuration

    connect(emission.heatPortCon, heatPortCon) annotation (Line(
      points={{59.6,14},{59.6,62},{-100,62},{-100,20}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(emission.heatPortRad, heatPortRad) annotation (Line(
      points={{62.8,14},{62.8,64},{-100,64},{-100,-20}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(pumpRad.flowPort_b,emission. flowPort_a)
                                                annotation (Line(
      points={{42,5},{50,5}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(tesTank.flowPort_b, pumpHeater.flowPort_a) annotation (Line(
      points={{-26,-24},{-26,-76},{-44,-76}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(fixedTemperature.port, tesTank.heatExchEnv) annotation (Line(
      points={{-78,32},{-36,32},{-36,-14},{-32.2,-14}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(dHW.flowPortHot, tesTank.flowPort_a) annotation (Line(
      points={{-51,-6},{-51,4},{-26,4},{-26,-4}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(TSensor, heatingControl.u) annotation (Line(
      points={{-96,-60},{-96,32},{29,32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heatingControl.y, pumpRad.m_flowSet) annotation (Line(
      points={{50.6,38},{54,38},{54,22},{33,22},{33,14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSet, heatingControl.uLow) annotation (Line(
      points={{0,-90},{0,68},{22,68},{22,46},{29.2,46}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dHW.flowPortCold, pipeDHW.flowPort_b) annotation (Line(
      points={{-51,-22},{-51,-34},{-48,-34}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(pipeDHW.flowPort_a, tesTank.flowPort_b) annotation (Line(
      points={{-36,-34},{-36,-24},{-26,-24}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(idealMixer.flowPortCold, pipeMixer.flowPort_b) annotation (Line(
      points={{6,-6},{6,-44},{0,-44}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(pipeMixer.flowPort_a, tesTank.flowPort_b) annotation (Line(
      points={{-12,-44},{-26,-44},{-26,-24}},
      color={255,0,0},
      smooth=Smooth.None));

  connect(pumpHeater.flowPort_b, heater.flowPort_a) annotation (Line(
      points={{-60,-76},{-68,-76},{-68,-4},{-72,-4}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(fixedTemperature.port, heater.heatPort) annotation (Line(
      points={{-78,32},{-70,32},{-70,18},{-82,18},{-82,8}},
      color={191,0,0},
      smooth=Smooth.None));

    connect(emission.heatPortEmb, heatPortEmb) annotation (Line(
      points={{51.12,14},{70,14},{70,58},{-66,58},{-66,86},{-100,86},{-100,60}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(HPControl.THeaCur, idealMixer.TMixedSet) annotation (Line(
      points={{-123.4,-6},{-112,-6},{-112,44},{6,44},{6,16.66}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HPControl.onOff, pumpHeater.m_flowSet) annotation (Line(
      points={{-123.4,-2},{-116,-2},{-116,-44},{-52,-44},{-52,-68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HPControl.THPSet, heater.TSet) annotation (Line(
      points={{-123.4,2},{-104,2},{-104,-2},{-92.6,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pipeEmission.flowPort_a, emission.flowPort_b) annotation (Line(
      points={{76,6},{71,6},{71,5},{66,5}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(tesTank.flowPorts[posOutFH], idealMixer.flowPortHot) annotation (Line(
      points={{-16,-14},{-16,5},{-4,5}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(heater.flowPort_b, tesTank.flowPorts[2]) annotation (Line(
      points={{-72,0},{-62,0},{-62,10},{-16,10},{-16,-14}},
      color={255,0,0},
      smooth=Smooth.None));

  connect(TTop, solarThermal.TSafety) annotation (Line(
      points={{41,-47},{16,-47},{16,-64.2},{6.8,-64.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TBot, solarThermal.TLow) annotation (Line(
      points={{41,-59},{18,-59},{18,-68.6},{6.6,-68.6}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-150,
            -100},{200,100}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-150,-100},{200,100}})));
end Heating_DHW_StratifiedTES_FH_STS;
