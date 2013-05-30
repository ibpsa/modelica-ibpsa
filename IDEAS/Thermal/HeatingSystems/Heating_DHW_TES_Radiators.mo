within IDEAS.Thermal.HeatingSystems;
model Heating_DHW_TES_Radiators "Hydraulic heating+DHW with TES and radiators"
  import IDEAS.Thermal.Components.Emission.Interfaces.EmissionType;

  extends Thermal.HeatingSystems.Partial_HydraulicHeatingSystem(
    final emissionType=EmissionType.Radiators,
    nLoads=1);

  parameter Modelica.SIunits.Volume volumeTank=0.25;
  parameter Integer nbrNodes=5 "Number of nodes in the tank";
  parameter Integer posTBot(max=nbrNodes) = nbrNodes-1
    "Position of the bottom temperature sensor";

  Thermal.Components.BaseClasses.Pump[nZones] pumpRad(
    each medium=medium,
    each useInput=true,
    m_flowNom=m_flowNom,
    each m=5)
    annotation (Placement(transformation(extent={{54,46},{78,22}})));

  IDEAS.Thermal.Components.Emission.Radiator[
                                           nZones] emission(
    each medium = medium,
    each TInNom=TSupNom,
    each TOutNom=TSupNom - dTSupRetNom,
    TZoneNom = TRoomNom,
    QNom=QNom,
    each powerFactor=3.37)
    annotation (Placement(transformation(extent={{88,18},{118,38}})));

  Thermal.Components.Storage.StorageTank tesTank(
    flowPort_a(m_flow(start=-0.1)),
    medium=medium,
    heightTank=1.8,
    volumeTank=volumeTank,
    TInitial={323.15 for i in 1:nbrNodes})                annotation (Placement(
        transformation(
        extent={{7.99999,-11},{-7.99999,11}},
        rotation=0,
        origin={-42,7})));
  Thermal.Components.BaseClasses.Pump pumpHeater(
    medium=medium,
    useInput=true,
    m_flowNom=sum(m_flowNom),
    m=2)
    annotation (Placement(transformation(extent={{-52,-26},{-68,-42}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=293.15)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-52,100})));

  replaceable Thermal.Control.HPControl_HeatingCurve HPControl(
    heatingCurve(timeFilter=timeFilter),
    TTankTop=tesTank.nodes[1].T,
    TTankBot=tesTank.nodes[posTBot].T,
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
  replaceable IDEAS.Thermal.Components.DHW.DHW_ProfileReader  dHW(
    medium=medium,
    TDHWSet=TDHWSet,
    TCold=TDHWCold,
    VDayAvg=nOcc*0.045,
    profileType=3)  constrainedby IDEAS.Thermal.Components.DHW.partial_DHW(
      medium=medium,
      TDHWSet=TDHWSet,
      TCold=TDHWCold)
    annotation (choicesAllMatching=true, Placement(transformation(extent={{9,5},{
            -9,-5}},
        rotation=90,
        origin={9,13})));

  IDEAS.BaseClasses.Control.Hyst_NoEvent_Var_HEATING[
                               nZones] heatingControl
    "onoff controller for the pumps of the radiator circuits"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
  Components.BaseClasses.Thermostatic3WayValve
                                            idealMixer(mFlowMin=0.01)
    annotation (Placement(transformation(extent={{28,22},{50,46}})));
  IDEAS.Thermal.Components.BaseClasses.Pipe   pipeDHW(medium=medium, m=1)
    annotation (Placement(transformation(extent={{-8,-34},{4,-22}})));
  IDEAS.Thermal.Components.BaseClasses.Pipe   pipeMixer(medium=medium, m=1)
    annotation (Placement(transformation(extent={{-8,-40},{4,-28}})));

  // Result variables

  Modelica.SIunits.Temperature TTankTop;
  Modelica.SIunits.Temperature TTankBot;
  Modelica.SIunits.Temperature TTankTopSet;
  Modelica.SIunits.Temperature TTankBotIn;
  Modelica.SIunits.MassFlowRate m_flowDHW;
  Real SOCTank;

equation
  QHeatTotal = -sum(emission.heatPortCon.Q_flow) -sum(emission.heatPortRad.Q_flow) + dHW.m_flowTotal * medium.cp * (dHW.TMixed - dHW.TCold);
  THeaterSet = HPControl.THPSet;

  heatingControl.uHigh = TSet + 0.5 * ones(nZones);

  P[1] = heater.PEl;
  Q[1] = 0;
  TTankTop = HPControl.TTankTop;
  TTankBot = HPControl.TTankBot;
  TTankTopSet = HPControl.TTopSet;
  TDHW = dHW.TMixed;
  TTankBotIn = tesTank.flowPort_b.h / medium.cp;
  TEmissionIn = idealMixer.flowPortMixed.h / medium.cp;
  TEmissionOut = emission.TOut;
  m_flowEmission = emission.flowPort_a.m_flow;
  m_flowDHW = dHW.m_flowTotal;
  SOCTank = HPControl.SOC;

// connections that are function of the number of circuits
for i in 1:nZones loop
  connect(idealMixer.flowPortMixed, pumpRad[i].flowPort_a)  annotation (Line(
      points={{50,34},{54,34}},
      color={0,128,255},
      smooth=Smooth.None));
  connect(emission[i].flowPort_b, pipeMixer.flowPort_b)  annotation (Line(
      points={{118,34.25},{130,34.25},{130,-34},{4,-34}},
      color={0,128,255},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
end for;

// general connections for any configuration

    connect(emission.heatPortCon, heatPortCon) annotation (Line(
      points={{106.75,38},{106.75,66},{-178,66},{-178,20},{-200,20}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(emission.heatPortRad, heatPortRad) annotation (Line(
      points={{111.75,38},{114,60},{114,68},{-180,68},{-180,-20},{-200,-20}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(pumpRad.flowPort_b,emission. flowPort_a)
                                                annotation (Line(
      points={{78,34},{83,34},{83,21.75},{88,21.75}},
      color={0,128,255},
      smooth=Smooth.None));
  connect(tesTank.flowPort_b, pumpHeater.flowPort_a) annotation (Line(
      points={{-50,-2.30769},{-50,-34},{-52,-34}},
      color={0,128,255},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(fixedTemperature.port, tesTank.heatExchEnv) annotation (Line(
      points={{-52,94},{-52,6.15385},{-47.3333,6.15385}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(dHW.flowPortHot, tesTank.flowPort_a) annotation (Line(
      points={{10.5,22.6429},{10.5,34},{-50,34},{-50,16.3077}},
      color={0,128,255},
      smooth=Smooth.None));
  connect(heatingControl.y, pumpRad.m_flowSet) annotation (Line(
      points={{40.2222,-70},{66,-70},{66,22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSet, heatingControl.uLow) annotation (Line(
      points={{0,-104},{0,-62.5},{20.2222,-62.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tesTank.flowPort_a, idealMixer.flowPortHot) annotation (Line(
      points={{-50,16.3077},{-40,16.3077},{-40,34},{28,34}},
      color={0,128,255},
      smooth=Smooth.None));
  connect(dHW.flowPortCold, pipeDHW.flowPort_b) annotation (Line(
      points={{10.5,4.64286},{10.5,-28},{4,-28}},
      color={0,128,255},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(pipeDHW.flowPort_a, tesTank.flowPort_b) annotation (Line(
      points={{-8,-28},{-50,-28},{-50,-2.30769}},
      color={0,128,255},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(idealMixer.flowPortCold, pipeMixer.flowPort_b) annotation (Line(
      points={{39,22},{39,-34},{4,-34}},
      color={0,128,255},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(pipeMixer.flowPort_a, tesTank.flowPort_b) annotation (Line(
      points={{-8,-34},{-50,-34},{-50,-2.30769}},
      color={0,128,255},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));

  connect(pumpHeater.flowPort_b, heater.flowPort_a) annotation (Line(
      points={{-68,-34},{-76,-34},{-76,19.6364},{-90,19.6364}},
      color={0,128,255},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(heater.flowPort_b, tesTank.flowPort_a) annotation (Line(
      points={{-90,24.9091},{-76,24.9091},{-76,34},{-50,34},{-50,16.3077}},
      color={0,128,255},
      smooth=Smooth.None));
  connect(fixedTemperature.port, heater.heatPort) annotation (Line(
      points={{-52,94},{-52,72},{-103,72},{-103,14}},
      color={191,0,0},
      smooth=Smooth.None));

    connect(emission.heatPortEmb, heatPortEmb) annotation (Line(
      points={{94.25,37.75},{90,37.75},{90,70},{-200,70},{-200,60}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(HPControl.THeaCur, idealMixer.TMixedSet) annotation (Line(
      points={{-137.556,-13},{-128,-13},{-128,56},{39,56},{39,46}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HPControl.onOff, pumpHeater.m_flowSet) annotation (Line(
      points={{-137.778,-8},{-122,-8},{-122,-54},{-60,-54},{-60,-42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HPControl.THPSet, heater.TSet) annotation (Line(
      points={{-137.778,-3},{-125.85,-3},{-125.85,28},{-113.7,28},{-113.7,34},{
          -101,34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mDHW60C, dHW.mDHW60C) annotation (Line(
      points={{60,-104},{60,13.6429},{17.6429,13.6429}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSensor, heatingControl.u) annotation (Line(
      points={{-204,-60},{-122,-60},{-122,-72.5},{20.2222,-72.5}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-200,
            -100},{200,100}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-200,-100},{200,100}})));
end Heating_DHW_TES_Radiators;
