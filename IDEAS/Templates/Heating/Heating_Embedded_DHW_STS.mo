within IDEAS.Templates.Heating;
model Heating_Embedded_DHW_STS
  "Hydraulic heating with embedded emission, DHW (with STS), no TES for heating"
  // fixme: no solar system is implemeted so far (adapt documentation)
  replaceable parameter
    IDEAS.Fluid.HeatExchangers.RadiantSlab.BaseClasses.RadiantSlabChar[nEmbPorts] RadSlaCha constrainedby
    IDEAS.Fluid.HeatExchangers.RadiantSlab.BaseClasses.RadiantSlabChar
    "Properties of the floor heating or TABS, if present";
   parameter Modelica.SIunits.Area AEmb[nEmbPorts]
    "surface of each embedded circuit";
   extends IDEAS.Templates.Heating.Interfaces.Partial_HydraulicHeating(
    final isHea=true,
    final isCoo=false,
    final nConvPorts=nZones,
    final nRadPorts=nZones,
    final nTemSen=nZones,
    final nEmbPorts=nZones,
    nLoads=1,
    nZones=1,
    minSup=true,
    TSupMin=273.15 + 25,
    redeclare IDEAS.Fluid.HeatExchangers.RadiantSlab.EmbeddedPipe emission[
      nEmbPorts](
      redeclare each package Medium = Medium,
      m_flow_nominal=m_flow_nominal,
      m_flowMin=m_flow_nominal/3,
      RadSlaCha=RadSlaCha,
      A_floor=AEmb,
      each nParCir=1),
    redeclare Controls.ControlHeating.Ctrl_Heating_DHW ctrl_Heating(
      TDHWSet=TDHWSet,
      TColdWaterNom=TColdWaterNom,
      dTHPTankSet=dTHPTankSet),
    heater(m_flow_nominal=sum(m_flow_nominal) + m_flow_nominal_stoHX),
    pumpRad(each riseTime=100));
  // --- Domestic Hot Water (DHW) Parameters
  parameter Integer nOcc = 1 "Number of occupants";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal_DHW = nOcc*dHW.VDayAvg*983/(3600*24)*10
    "nominal mass flow rate of DHW";
  parameter Modelica.SIunits.Temperature TDHWSet(max=273.15 + 60) = 273.15 + 45
    "DHW temperature setpoint";
  parameter Modelica.SIunits.Temperature TColdWaterNom=273.15 + 10
    "Nominal tap (cold) water temperature";
  // --- Storage Tank Parameters
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal_stoHX = m_flow_nominal_DHW * (TDHWSet - TColdWaterNom)/dTHPTankSet
    "nominal mass flow rate of HX of storage tank";
  parameter SI.TemperatureDifference dTHPTankSet(min=1)=2
    "Difference between tank setpoint and heat pump setpoint";
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
  // --- Storage tank and hydraulic circuit connect to its heat exchanger
  IDEAS.Fluid.Movers.FlowControlled_m_flow pumpSto(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal_stoHX,
    tau=30,
    filteredSpeed=true,
    riseTime=100) "Pump for loading the storage tank"
    annotation (Placement(transformation(extent={{-30,-56},{-44,-44}})));
  IDEAS.Fluid.Storage.StorageTank_OneIntHX tesTank(
    port_a(m_flow(start=0)),
    nbrNodes=nbrNodes,
    redeclare package Medium = Medium,
    redeclare package MediumHX = Medium,
    heightTank=1.8,
    volumeTank=volumeTank,
    T_start={323.15 for i in 1:nbrNodes},
    m_flow_nominal_HX=m_flow_nominal_stoHX)
                                           annotation (Placement(transformation(
        extent={{-14,-20},{14,20}},
        rotation=0,
        origin={-12,0})));
  // --- Domestic Hot Water and its hydraulic circuit
  replaceable IDEAS.Fluid.Taps.BalancedTap dHW(
    TDHWSet=TDHWSet,
    profileType=3,
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal_DHW,
    VDayAvg=nOcc*0.045) constrainedby IDEAS.Fluid.Taps.Interfaces.BalancedTap(
                                            redeclare package Medium = Medium,
      TDHWSet=TDHWSet) annotation (Placement(transformation(
        extent={{-9,5},{9,-5}},
        rotation=-90,
        origin={-47,1})));
  IDEAS.Fluid.FixedResistances.InsulatedPipe pipeDHW(redeclare package Medium =  Medium, m=1,
    UA=10,
    m_flow_nominal=m_flow_nominal_DHW)
    annotation (Placement(transformation(extent={{-28,-32},{-44,-26}})));
  Fluid.Sources.FixedBoundary       absolutePressure1(
                                                     redeclare package Medium =
        Medium, use_T=false,
    nPorts=1)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=90,
        origin={8,-42})));
  // --- Result (Output) variables
  Modelica.SIunits.Temperature[nbrNodes] TSto=tesTank.nodes.heatPort.T;
  Modelica.SIunits.Temperature TTankTopSet;
  Modelica.SIunits.Temperature TTankBotIn;
  Modelica.SIunits.MassFlowRate m_flowDHW;
  Modelica.SIunits.Power QDHW;
  Modelica.SIunits.Temperature TDHW;
  Real SOCTank;
  // --- Temperature sensors
  Fluid.Sensors.TemperatureTwoPort senTemSto_top(redeclare package Medium =
        Medium, m_flow_nominal=sum(m_flow_nominal))
    "Temperature at the top outlet of the storage tank (port_a)"
    annotation (Placement(transformation(extent={{-24,18},{-32,26}})));
  Fluid.Sensors.TemperatureTwoPort senTemSto_bot(redeclare package Medium =
        Medium, m_flow_nominal=sum(m_flow_nominal))
    "Temperature at the bottom inlet of the storage tank (port_b)"
    annotation (Placement(transformation(extent={{-6,-34},{-16,-24}})));
  Fluid.Sensors.TemperatureTwoPort senTemStoHX_out(redeclare package Medium =
        Medium, m_flow_nominal=sum(m_flow_nominal))
    "Temperature at the outlet of the storage tank heat exchanger (port_bHX)"
    annotation (Placement(transformation(extent={{-66,-54},{-78,-42}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow prescribedHeatFlow1[
    nRadPorts](each Q_flow=0)
    annotation (Placement(transformation(extent={{-140,-32},{-160,-12}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow prescribedHeatFlow[
    nConvPorts](each Q_flow=0)
    annotation (Placement(transformation(extent={{-142,8},{-162,28}})));
  Modelica.Blocks.Math.Gain gain(k=m_flow_nominal_stoHX) annotation (Placement(
        transformation(
        extent={{-8,-8},{8,8}},
        rotation=270,
        origin={-80,-8})));
equation
  QHeaSys = -sum(emission.heatPortEmb.Q_flow) + QDHW;
  P[1] = heater.PEl + pumpSto.P + sum(pumpRad.P);
  Q[1] = 0;
  // Result variables
  TTankTopSet = ctrl_Heating.TTopSet;
  TDHW = dHW.TDHW_actual;
  TTankBotIn = senTemSto_bot.T;
  m_flowDHW = dHW.idealSource.m_flow_in;
  SOCTank = ctrl_Heating.SOC;
  QDHW = -dHW.pipe_HeatPort.heatPort.Q_flow;
  connect(pumpSto.port_a, tesTank.portHXLower) annotation (Line(
      points={{-30,-50},{-26,-50},{-26,-16.9231}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipeDHW.heatPort, fixedTemperature.port) annotation (Line(
      points={{-36,-27.8},{-56,-27.8},{-56,-68},{-102,-68},{-102,-12},{-127,-12},
          {-127,-14}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pumpSto.heatPort, fixedTemperature.port) annotation (Line(
      points={{-37,-54.08},{-26,-54.08},{-26,-68},{-102,-68},{-102,-12},{-127,-12},
          {-127,-14}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(tesTank.heatExchEnv, fixedTemperature.port) annotation (Line(
      points={{-2.66667,-1.53846},{16,-1.53846},{16,-68},{-102,-68},{-102,-12},
          {-127,-12},{-127,-14}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(emission[:].heatPortEmb[1], heatPortEmb[:]) annotation (Line(
      points={{135,44},{134,44},{134,98},{-180,98},{-180,60},{-190,60},{-190,60},
          {-200,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(dHW.port_cold, pipeDHW.port_b) annotation (Line(
      points={{-47,-8},{-47,-29},{-44,-29}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(tesTank.T[posTTop], ctrl_Heating.TTankTop) annotation (Line(
      points={{2,4.61538},{18,4.61538},{18,80},{-176,80},{-176,64},{-160,64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tesTank.T[posTBot], ctrl_Heating.TTankBot) annotation (Line(
      points={{2,4.61538},{10,4.61538},{10,4},{18,4},{18,80},{-176,80},{-176,60},
          {-160,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dHW.port_hot,senTemSto_top. port_b) annotation (Line(
      points={{-47,10},{-47,22},{-32,22}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemSto_top.port_a, tesTank.port_a) annotation (Line(
      points={{-24,22},{6,22},{6,16.9231},{2,16.9231}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipeDHW.port_a,senTemSto_bot. port_b) annotation (Line(
      points={{-28,-29},{-16,-29}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemSto_bot.port_a, tesTank.port_b) annotation (Line(
      points={{-6,-29},{4,-29},{4,-16.9231},{2,-16.9231}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(absolutePressure1.ports[1], tesTank.port_b) annotation (Line(
      points={{8,-36},{8,-28},{4,-28},{4,-16.9231},{2,-16.9231}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(tesTank.portHXUpper, pipeSupply.port_a) annotation (Line(
      points={{-26,-7.69231},{-30,-7.69231},{-30,-8},{-36,-8},{-36,58},{-16,58}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pumpSto.port_b, senTemStoHX_out.port_a) annotation (Line(
      points={{-44,-50},{-56,-50},{-56,-48},{-66,-48}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemStoHX_out.port_b, heater.port_a) annotation (Line(
      points={{-78,-48},{-106,-48},{-106,16},{-114,16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(prescribedHeatFlow1.port, heatPortRad) annotation (Line(
      points={{-160,-22},{-180,-22},{-180,-20},{-200,-20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedHeatFlow.port, heatPortCon) annotation (Line(
      points={{-162,18},{-180,18},{-180,20},{-200,20}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(ctrl_Heating.onOff, gain.u)
    annotation (Line(points={{-142,62},{-80,62},{-80,1.6}}, color={0,0,127}));
  connect(gain.y, pumpSto.m_flow_in) annotation (Line(points={{-80,-16.8},{-80,
          -38},{-36.86,-38},{-36.86,-42.8}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-100},{200,
            100}})),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-200,-100},{200,
            100}})),
    Documentation(info="<html>
<p>
This example model illustrates how heating systems may be used.
Its implementation may not reflect best modelling practices.
</p>
</html>", revisions="<html>
<ul>
<li>
January 23, 2017 by Filip Jorissen and Glenn Reynders:<br/>
Revised implementation and documentation.
</li>
<li>2013 June, Roel De Coninck: minor edits and documentation</li>
<li>2012-2013, Roel De Coninck: many minor and major revisions</li>
<li>2011, Roel De Coninck: first version</li>
</ul>
</html>"),
    __Dymola_Commands(file="Resources/Scripts/Dymola/Templates/Heating/Examples/Heating_Embedded_DHW_STS.mos"
        "Simulate and plot"));
end Heating_Embedded_DHW_STS;
