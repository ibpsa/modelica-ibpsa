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
    annotation (Placement(transformation(extent={{30,-6},{50,14}})));

  IDEAS.Thermal.Components.Emission.Radiator[
                                           nZones] emission(
    each medium = medium,
    each TInNom=TSupNom,
    each TOutNom=TSupNom - dTSupRetNom,
    TZoneNom = TRoomNom,
    QNom=QNom,
    each powerFactor=3.37)
    annotation (Placement(transformation(extent={{70,-6},{90,14}})));

  Thermal.Components.Storage.StorageTank tesTank(
    flowPort_a(m_flow(start=-0.1)),
    medium=medium,
    heightTank=1.8,
    volumeTank=volumeTank,
    TInitial={323.15 for i in 1:nbrNodes})                annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-40,-14})));
  Thermal.Components.BaseClasses.Pump pumpHeater(
    medium=medium,
    useInput=true,
    m_flowNom=sum(m_flowNom),
    m=2)
    annotation (Placement(transformation(extent={{-44,-84},{-60,-68}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=293.15)
    annotation (Placement(transformation(extent={{-90,26},{-78,38}})));
  replaceable Thermal.Control.HPControl_HeatingCurve HPControl(
    heatingCurve(timeFilter=timeFilter),
    TTankTop=tesTank.nodes[1].T,
    TTankBot=tesTank.nodes[posTBot].T,
    DHW=true,
    TDHWSet=TDHWSet,
    TColdWaterNom=TDHWCold,
    dTSupRetNom=dTSupRetNom)
      annotation (Placement(transformation(extent={{-144,-14},{-124,6}})));
  Thermal.Components.BaseClasses.DomesticHotWater dHW(
    medium=medium,
    TDHWSet=TDHWSet,
    TCold=TDHWCold,
    VDayAvg=nOcc*0.045,
    profileType=3)
    annotation (Placement(transformation(extent={{-28,-24},{-8,-4}})));

protected
  IDEAS.BaseClasses.Control.Hyst_NoEvent_Var_HEATING[
                               nZones] heatingControl
    "onoff controller for the pumps of the radiator circuits"
    annotation (Placement(transformation(extent={{30,28},{50,48}})));
  Thermal.Components.BaseClasses.IdealMixer idealMixer(mFlowMin=0.01)
    annotation (Placement(transformation(extent={{-4,-6},{16,16}})));
  Thermal.Components.BaseClasses.IsolatedPipe pipeDHW(medium=medium, m=1)
    annotation (Placement(transformation(extent={{-34,-40},{-22,-28}})));
  Thermal.Components.BaseClasses.IsolatedPipe pipeMixer(medium=medium, m=1)
    annotation (Placement(transformation(extent={{-12,-50},{0,-38}})));

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
  connect(idealMixer.flowPortMixed, pumpRad[i].flowPort_a);
  connect(emission[i].flowPort_b, pipeMixer.flowPort_b);
end for;

// general connections for any configuration

    connect(emission.heatPortCon, heatPortCon) annotation (Line(
      points={{82,14},{82,62},{-100,62},{-100,20}},
      color={191,0,0},
      smooth=Smooth.None));
    connect(emission.heatPortRad, heatPortRad) annotation (Line(
      points={{86,14},{86,64},{-100,64},{-100,-20}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(pumpRad.flowPort_b,emission. flowPort_a)
                                                annotation (Line(
      points={{50,4},{70,4}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(tesTank.flowPort_b, pumpHeater.flowPort_a) annotation (Line(
      points={{-40,-24},{-40,-76},{-44,-76}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(fixedTemperature.port, tesTank.heatExchEnv) annotation (Line(
      points={{-78,32},{-52,32},{-52,-14},{-46.2,-14}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(dHW.flowPortHot, tesTank.flowPort_a) annotation (Line(
      points={{-18,-4},{-18,4},{-40,4},{-40,-4}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(TSensor, heatingControl.u) annotation (Line(
      points={{-96,-60},{-96,32},{29,32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heatingControl.y, pumpRad.m_flowSet) annotation (Line(
      points={{50.6,38},{58,38},{58,22},{40,22},{40,14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSet, heatingControl.uLow) annotation (Line(
      points={{0,-90},{0,68},{22,68},{22,46},{29.2,46}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tesTank.flowPort_a, idealMixer.flowPortHot) annotation (Line(
      points={{-40,-4},{-40,4},{-4,4},{-4,5}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(dHW.flowPortCold, pipeDHW.flowPort_b) annotation (Line(
      points={{-18,-24},{-18,-34},{-22,-34}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(pipeDHW.flowPort_a, tesTank.flowPort_b) annotation (Line(
      points={{-34,-34},{-40,-34},{-40,-24}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(idealMixer.flowPortCold, pipeMixer.flowPort_b) annotation (Line(
      points={{6,-6},{6,-44},{0,-44}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(pipeMixer.flowPort_a, tesTank.flowPort_b) annotation (Line(
      points={{-12,-44},{-40,-44},{-40,-24}},
      color={255,0,0},
      smooth=Smooth.None));

  connect(pumpHeater.flowPort_b, heater.flowPort_a) annotation (Line(
      points={{-60,-76},{-68,-76},{-68,-4},{-72,-4}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(heater.flowPort_b, tesTank.flowPort_a) annotation (Line(
      points={{-72,0},{-68,0},{-68,4},{-40,4},{-40,-4}},
      color={255,0,0},
      smooth=Smooth.None));
  connect(fixedTemperature.port, heater.heatPort) annotation (Line(
      points={{-78,32},{-70,32},{-70,18},{-82,18},{-82,8}},
      color={191,0,0},
      smooth=Smooth.None));

    connect(emission.heatPortEmb, heatPortEmb) annotation (Line(
      points={{71.4,14},{70,14},{70,58},{-66,58},{-66,86},{-100,86},{-100,60}},
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
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-150,
            -100},{200,100}}),
                      graphics), Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-150,-100},{200,100}})));
end Heating_DHW_TES_Radiators;
