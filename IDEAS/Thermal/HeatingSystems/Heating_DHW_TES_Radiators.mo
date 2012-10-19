within IDEAS.Thermal.HeatingSystems;
model Heating_DHW_TES_Radiators "Hydraulic heating+DHW with TES and radiators"
  import IDEAS.Thermal.Components.Emission.Auxiliaries.EmissionType;

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
    annotation (Placement(transformation(extent={{88,18},{120,50}})));

  Thermal.Components.Storage.StorageTank tesTank(
    flowPort_a(m_flow(start=-0.1)),
    medium=medium,
    heightTank=1.8,
    volumeTank=volumeTank,
    TInitial={323.15 for i in 1:nbrNodes})                annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-40,8})));
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
    dTSupRetNom=dTSupRetNom) constrainedby Thermal.Control.PartialHPControl(
    heatingCurve(timeFilter=timeFilter),
    TTankTop=TSto[posTTop],
    TTankBot=TSto[posTBot],
    DHW=true,
    TDHWSet=TDHWSet,
    TColdWaterNom=TDHWCold,
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
    annotation (choicesAllMatching=true, Placement(transformation(extent={{20,-2},
            {0,18}})));

protected
  IDEAS.BaseClasses.Control.Hyst_NoEvent_Var_HEATING[
                               nZones] heatingControl
    "onoff controller for the pumps of the radiator circuits"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
  Thermal.Components.BaseClasses.IdealMixer idealMixer(mFlowMin=0.01)
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
      points={{45.6,34},{54,34}},
      color={0,128,255},
      smooth=Smooth.None));
  connect(emission[i].flowPort_b, pipeMixer.flowPort_b)  annotation (Line(
      points={{120,34},{130,34},{130,-34},{4,-34}},
      color={0,128,255},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
end for;

// general connections for any configuration

    connect(emission.heatPortCon, heatPortCon) annotation (Line(
      points={{107.2,50},{107.2,58},{108,58},{108,66},{-178,66},{-178,20},{-200,
          20}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(emission.heatPortRad, heatPortRad) annotation (Line(
      points={{113.6,50},{114,60},{114,68},{-180,68},{-180,-20},{-200,-20}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(pumpRad.flowPort_b,emission. flowPort_a)
                                                annotation (Line(
      points={{78,34},{88,34}},
      color={0,128,255},
      smooth=Smooth.None));
  connect(tesTank.flowPort_b, pumpHeater.flowPort_a) annotation (Line(
      points={{-40,-2},{-40,-34},{-52,-34}},
      color={0,128,255},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(fixedTemperature.port, tesTank.heatExchEnv) annotation (Line(
      points={{-52,94},{-52,8},{-46.2,8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(dHW.flowPortHot, tesTank.flowPort_a) annotation (Line(
      points={{10,18},{10,34},{-39.8,34},{-39.8,18}},
      color={0,128,255},
      smooth=Smooth.None));
  connect(heatingControl.y, pumpRad.m_flowSet) annotation (Line(
      points={{40.2,-64},{66,-64},{66,22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSet, heatingControl.uLow) annotation (Line(
      points={{0,-96},{0,-62},{19.2,-62}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tesTank.flowPort_a, idealMixer.flowPortHot) annotation (Line(
      points={{-39.8,18},{-40,26},{-40,34},{32.4,34}},
      color={0,128,255},
      smooth=Smooth.None));
  connect(dHW.flowPortCold, pipeDHW.flowPort_b) annotation (Line(
      points={{10,-2},{10,-28},{4,-28}},
      color={0,128,255},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(pipeDHW.flowPort_a, tesTank.flowPort_b) annotation (Line(
      points={{-8,-28},{-40,-28},{-40,-2}},
      color={0,128,255},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(idealMixer.flowPortCold, pipeMixer.flowPort_b) annotation (Line(
      points={{39,26.8},{39,-34},{4,-34}},
      color={0,128,255},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(pipeMixer.flowPort_a, tesTank.flowPort_b) annotation (Line(
      points={{-8,-34},{-40,-34},{-40,-2}},
      color={0,128,255},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));

  connect(pumpHeater.flowPort_b, heater.flowPort_a) annotation (Line(
      points={{-68,-34},{-76,-34},{-76,-4},{-90,-4}},
      color={0,128,255},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(heater.flowPort_b, tesTank.flowPort_a) annotation (Line(
      points={{-90,0},{-76,0},{-76,34},{-39.8,34},{-39.8,18}},
      color={0,128,255},
      smooth=Smooth.None));
  connect(fixedTemperature.port, heater.heatPort) annotation (Line(
      points={{-52,94},{-52,72},{-100,72},{-100,8}},
      color={191,0,0},
      smooth=Smooth.None));

    connect(emission.heatPortEmb, heatPortEmb) annotation (Line(
      points={{90.24,50},{90,50},{90,70},{-200,70},{-200,60}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(HPControl.THeaCur, idealMixer.TMixedSet) annotation (Line(
      points={{-137.4,-10},{-128,-10},{-128,56},{39,56},{39,46.72}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HPControl.onOff, pumpHeater.m_flowSet) annotation (Line(
      points={{-137.4,-6},{-122,-6},{-122,-54},{-60,-54},{-60,-42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HPControl.THPSet, heater.TSet) annotation (Line(
      points={{-137.4,-2},{-110.6,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mDHW60C, dHW.mDHW60C) annotation (Line(
      points={{60,-96},{60,8},{20.6,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSensor, heatingControl.u) annotation (Line(
      points={{-196,-60},{-122,-60},{-122,-76},{19,-76}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-200,
            -100},{200,100}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-200,-100},{200,100}})));
end Heating_DHW_TES_Radiators;
