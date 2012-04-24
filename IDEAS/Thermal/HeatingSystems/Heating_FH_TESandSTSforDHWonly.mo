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
    annotation (Placement(transformation(extent={{118,-14},{134,2}})));

  IDEAS.Thermal.Components.Emission.EmbeddedPipeDynTOut[
                                                  nZones] emission(
    each medium = medium,
    FHChars = FHChars,
    m_flowMin = m_flowNom)
    annotation (Placement(transformation(extent={{142,-14},{158,4}})));

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
    dTSupRetNom=dTSupRetNom) constrainedby
    Thermal.Control.HPControl_HeatingCurve_Strat(
    heatingCurve(timeFilter=timeFilter),
    TTankTop=TSto[posTTop],
    TTankBot=TSto[posTBot],
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
        extent={{17,-19},{-17,19}},
        rotation=0,
        origin={-11,-23})));

protected
  Thermal.Components.BaseClasses.DomesticHotWater dHW(
    medium=medium,
    TDHWSet=TDHWSet,
    TCold=TDHWCold,
    VDayAvg=nOcc*0.045,
    profileType=3)
    annotation (Placement(transformation(extent={{-56,-28},{-46,-12}})));

  IDEAS.BaseClasses.Control.Hyst_NoEvent_Var_HEATING[
                               nZones] heatingControl
    "onoff controller for the pumps of the radiator circuits"
    annotation (Placement(transformation(extent={{94,22},{114,42}})));
  Thermal.Components.BaseClasses.IdealMixer idealMixer(mFlowMin=0.01, pumpCold(
        m=5))
    annotation (Placement(transformation(extent={{88,-18},{108,4}})));
  Thermal.Components.BaseClasses.IsolatedPipe pipeDHW(medium=medium, m=1)
    annotation (Placement(transformation(extent={{-36,-48},{-48,-36}})));
  Thermal.Components.BaseClasses.IsolatedPipe pipeMixer(medium=medium, m=1)
    annotation (Placement(transformation(extent={{50,-80},{62,-68}})));
  Thermal.Components.BaseClasses.IsolatedPipe[nZones] pipeEmission(each medium=
        medium, each m=1)
    annotation (Placement(transformation(extent={{166,-10},{178,2}})));
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
      points={{32,-14},{30,-14},{16,-14},{16,-23},{6,-23}},
      color={255,0,0},
      smooth=Smooth.Bezier));
  connect(solarThermal.flowPort_a, tesTank.flowPorts[nbrNodes+1])
                                                       annotation (Line(
      points={{32,-18},{32,-18},{24,-18},{24,-20},{18,-23},{6,-23}},
      color={255,0,0},
      smooth=Smooth.Bezier));

// connections that are function of the number of circuits
for i in 1:nZones loop
  connect(idealMixer.flowPortMixed, pumpRad[i].flowPort_a);
  connect(pipeEmission[i].flowPort_b, pipeMixer.flowPort_b);
end for;

// general connections for any configuration

    connect(emission.heatPortCon, heatPortCon) annotation (Line(
      points={{151.6,4},{151.6,80},{-100,80},{-100,20}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(emission.heatPortRad, heatPortRad) annotation (Line(
      points={{154.8,4},{154,44},{154,84},{-100,84},{-100,-20}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(pumpRad.flowPort_b,emission. flowPort_a)
                                                annotation (Line(
      points={{134,-6},{138,-6},{142,-5}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(tesTank.flowPorts[posOutHP], pumpSto.flowPort_a)    annotation (Line(
      points={{6,-23},{6,-60},{-36,-60}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(fixedTemperature.port, tesTank.heatExchEnv) annotation (Line(
      points={{-122,40},{-36,40},{-36,-23},{-21.54,-23}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(dHW.flowPortHot, tesTank.flowPort_a) annotation (Line(
      points={{-51,-12},{-51,-4},{-11,-4}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(TSensor, heatingControl.u) annotation (Line(
      points={{-96,-60},{-96,26},{93,26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heatingControl.y, pumpRad.m_flowSet) annotation (Line(
      points={{114.6,32},{126,32},{126,2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSet, heatingControl.uLow) annotation (Line(
      points={{0,-90},{0,72},{80,72},{80,40},{93.2,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dHW.flowPortCold, pipeDHW.flowPort_b) annotation (Line(
      points={{-51,-28},{-51,-42},{-48,-42}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(pipeDHW.flowPort_a, tesTank.flowPort_b) annotation (Line(
      points={{-36,-42},{-11,-42}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(idealMixer.flowPortCold, pipeMixer.flowPort_b) annotation (Line(
      points={{98,-18},{98,-74},{62,-74}},
      color={255,0,0},
      smooth=Smooth.None));

  connect(pumpSto.flowPort_b, heater.flowPort_a)    annotation (Line(
      points={{-52,-60},{-68,-60},{-68,-4},{-72,-4}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(fixedTemperature.port, heater.heatPort) annotation (Line(
      points={{-122,40},{-112,40},{-112,32},{-82,32},{-82,8}},
      color={191,0,0},
      smooth=Smooth.None));

    connect(emission.heatPortEmb, heatPortEmb) annotation (Line(
      points={{143.12,4},{142,4},{142,76},{-100,76},{-100,60}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(HPControl.THeaCur, idealMixer.TMixedSet) annotation (Line(
      points={{-123.4,-6},{-108,-6},{-108,18},{98,18},{98,4.66}},
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
      points={{166,-4},{163,-4},{163,-5},{158,-5}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(heater.flowPort_b, tesTank.flowPorts[2]) annotation (Line(
      points={{-72,0},{-62,0},{-62,10},{6,10},{6,-23}},
      color={255,0,0},
      smooth=Smooth.None));

  connect(heater.flowPort_b, idealMixer.flowPortHot) annotation (Line(
      points={{-72,0},{-66,0},{-66,16},{80,16},{80,-7},{88,-7}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(pipeMixer.flowPort_a, heater.flowPort_a) annotation (Line(
      points={{50,-74},{-68,-74},{-68,-4},{-72,-4}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(TTop, solarThermal.TSafety) annotation (Line(
      points={{22,-4},{31.2,-4},{31.2,-4.2}},
      color={0,0,127},
      smooth=Smooth.Bezier));
  connect(TBot, solarThermal.TLow) annotation (Line(
      points={{22,-8},{31.4,-8},{31.4,-8.6}},
      color={0,0,127},
      smooth=Smooth.Bezier));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-150,-100},
            {200,100}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-150,-100},{200,100}})));
end Heating_FH_TESandSTSforDHWonly;
