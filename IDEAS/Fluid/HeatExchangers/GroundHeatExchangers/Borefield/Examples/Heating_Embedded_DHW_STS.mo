within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Examples;
model Heating_Embedded_DHW_STS
  "Example and test for heating system with embedded emission, DHW and STS"
  import IDEAS;

  extends Modelica.Icons.Example;

  final parameter Integer nZones=1 "Number of zones";

  parameter
    IDEAS.Fluid.HeatExchangers.Examples.BaseClasses.RadSlaCha_ValidationEmpa[        nZones]
                                       radSlaCha_ValidationEmpa(A_Floor=
        dummyBuilding.AZones)
    annotation (Placement(transformation(extent={{-368,-96},{-348,-76}})));


  Modelica.Blocks.Sources.Pulse[nZones] TOpSet(
    each amplitude=4,
    each width=67,
    each period=86400,
    each offset=289,
    startTime={3600*7,3600*9})
    annotation (Placement(transformation(extent={{-294,-58},{-274,-38}})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Sources.VoltageSource
    voltageSource(
    f=50,
    V=230,
    phi=0) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={232,-74})));
  Modelica.Electrical.QuasiStationary.SinglePhase.Basic.Ground ground
    annotation (Placement(transformation(extent={{222,-112},{242,-92}})));
  IDEAS.Interfaces.BaseClasses.CausalInhomeFeeder dummyInHomeGrid
    annotation (Placement(transformation(extent={{206,-30},{226,-10}})));
  IDEAS.HeatingSystems.Examples.DummyBuilding dummyBuilding(nZones=nZones,
    AZones=ones(nZones)*40,
    VZones=dummyBuilding.AZones*3,
    UA_building=150)
    annotation (Placement(transformation(extent={{-370,-14},{-338,6}})));
  Modelica.Thermal.HeatTransfer.Components.Convection[nZones] convectionTabs
    annotation (Placement(transformation(
        extent={{8,-8},{-8,8}},
        rotation=0,
        origin={-322,2})));
  IDEAS.Fluid.HeatExchangers.Examples.BaseClasses.NakedTabs[nZones] nakedTabs(radSlaCha=
       radSlaCha_ValidationEmpa)
    annotation (Placement(transformation(extent={{-280,-10},{-300,10}})));

  inner IDEAS.SimInfoManager sim(nOcc=3)
    annotation (Placement(transformation(extent={{-240,158},{-220,178}})));
  Modelica.Blocks.Sources.RealExpression[nZones] realExpression(y=11*
        radSlaCha_ValidationEmpa.A_Floor)
    annotation (Placement(transformation(extent={{-354,32},{-334,52}})));
  outer IDEAS.SimInfoManager sim1
    "Simulation information manager for climate data"
    annotation (Placement(transformation(extent={{-220,60},{-200,80}})));
  IDEAS.Electric.BaseClasses.WattsLawPlug
                                    wattsLawPlug(each numPha=1, final nLoads=
        nLoads) if nLoads >= 1
    annotation (Placement(transformation(extent={{140,-30},{160,-10}})));
  replaceable IDEAS.Fluid.Production.Boiler heater(
    QNom=sum(QNom), redeclare package Medium = Medium,
    m_flow_nominal=sum(m_flow_nominal)) constrainedby
    Fluid.Production.Interfaces.PartialDynamicHeaterWithLosses( QNom=sum(QNom), redeclare
      package Medium =                                                                                     Medium,
    m_flow_nominal=sum(m_flow_nominal)) "Heater (boiler, heat pump, ...)"
    annotation (Placement(transformation(extent={{-154,-8},{-134,12}})));
  IDEAS.Fluid.Movers.Pump[nZones] pumpRad(
    each useInput=true,
    each m=1,
    m_flow_nominal=m_flow_nominal,
    redeclare each package Medium = Medium)
              annotation (Placement(transformation(extent={{68,44},{92,20}})));
  IDEAS.Fluid.Valves.Thermostatic3WayValve
                                        idealCtrlMixer(m_flow_nominal=sum(
        m_flow_nominal), redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{14,26},{36,50}})));
  IDEAS.Fluid.FixedResistances.Pipe_Insulated pipeReturn(
    redeclare package Medium = Medium,
    m=1,
    UA=10,
    m_flow_nominal=sum(m_flow_nominal))
           annotation (Placement(transformation(extent={{-18,-108},{-38,-116}})));
  IDEAS.Fluid.FixedResistances.Pipe_Insulated pipeSupply(
    redeclare package Medium = Medium,
    m=1,
    UA=10,
    m_flow_nominal=sum(m_flow_nominal))
           annotation (Placement(transformation(extent={{-36,34},{-16,42}})));
  IDEAS.Fluid.FixedResistances.Pipe_Insulated[nZones] pipeReturnEmission(
    redeclare each package Medium = Medium,
    each m=1,
    each UA=10,
    m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{128,-108},{108,-116}})));
  replaceable IDEAS.Fluid.HeatExchangers.Radiators.Radiator[
                                                nZones] emission(
      each TInNom=TSupNom,
      each TOutNom=TSupNom - dTSupRetNom,
      TZoneNom=TRoomNom,
      QNom=QNom,
      each powerFactor=3.37,
    redeclare each package Medium = Medium) constrainedby
    Fluid.HeatExchangers.Interfaces.EmissionTwoPort
    annotation (Placement(transformation(extent={{100,4},{130,24}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=293.15)
    "fixed temperature to simulate heat losses of hydraulic components"
    annotation (Placement(transformation(
        extent={{7,-7},{-7,7}},
        rotation=-90,
        origin={-147,-41})));
  IDEAS.Fluid.Sources.FixedBoundary absolutePressure(redeclare package Medium
      = Medium, use_T=false,
    nPorts=1)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-126,-134})));
  replaceable IDEAS.Controls.ControlHeating.Ctrl_Heating
                                                   ctrl_Heating(
    heatingCurve(timeFilter=timeFilter),
    TSupNom=TSupNom,
    dTSupRetNom=dTSupRetNom,
    TSupMin=TSupMin,
    minSup=minSup,
    corFac_val=corFac_val,
    THeaterSet(start=293.15)) constrainedby
    Controls.ControlHeating.Interfaces.Partial_Ctrl_Heating(
    heatingCurve(timeFilter=timeFilter),
    TSupNom=TSupNom,
    dTSupRetNom=dTSupRetNom)
    "Controller for the heater and the emission set point "
    annotation (Placement(transformation(extent={{-180,34},{-160,54}})));
  replaceable IDEAS.Controls.Control_fixme.Hyst_NoEvent_Var[
                                                nZones] heatingControl(each uLow_val=
        22, each uHigh_val=20)
    "onoff controller for the pumps of the emission circuits"
    annotation (Placement(transformation(extent={{-160,-100},{-140,-80}})));
  Modelica.Blocks.Sources.RealExpression THigh_val[nZones](y=0.5*ones(nZones))
    "Higher boudary for set point temperature"
    annotation (Placement(transformation(extent={{-194,-82},{-182,-62}})));
  Modelica.Blocks.Sources.RealExpression TLow_val[nZones](y=-0.5*ones(nZones))
    "Lower boundary for set point temperature"
    annotation (Placement(transformation(extent={{-194,-122},{-180,-102}})));
  Modelica.Blocks.Sources.RealExpression TSet_max(y=max(TSet))
    "maximum value of set point temperature" annotation (Placement(
        transformation(
        extent={{-21,-10},{21,10}},
        rotation=270,
        origin={-204,115})));
  Modelica.Blocks.Math.Add add[nZones](each k1=-1, each k2=+1)
    annotation (Placement(transformation(extent={{-194,-98},{-180,-84}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort
                                   senTemEm_in(redeclare package Medium =
        Medium, m_flow_nominal=sum(m_flow_nominal))
    "Inlet temperature of the emission system"
    annotation (Placement(transformation(extent={{42,22},{62,42}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort
                                   senTemHea_out(redeclare package Medium =
        Medium, m_flow_nominal=sum(m_flow_nominal))
    "Outlet temperature of the heater"
    annotation (Placement(transformation(extent={{-82,28},{-62,48}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort
                                   senTemEm_out(redeclare package Medium =
        Medium, m_flow_nominal=sum(m_flow_nominal))
    "Outlet temperature of the emission system" annotation (Placement(
        transformation(
        extent={{8,-8},{-8,8}},
        rotation=0,
        origin={88,-112})));
  IDEAS.Fluid.Movers.Pump_Insulated pumpSto(
    redeclare package Medium = Medium,
    useInput=true,
    UA=1,
    m_flow_nominal=m_flow_nominal_stoHX,
    m=1,
    riseTime=100,
    dpFix=0) "Pump for loading the storage tank"
    annotation (Placement(transformation(extent={{-50,-74},{-64,-62}})));
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
        origin={-32,-20})));
  replaceable IDEAS.Fluid.Domestic_Hot_Water.DHW_ProfileReader dHW(
    TDHWSet=TDHWSet,
    TColdWaterNom=TColdWaterNom,
    profileType=3,
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal_DHW,
    VDayAvg=sim.nOcc*0.045)
                   constrainedby IDEAS.Fluid.Domestic_Hot_Water.partial_DHW(
    redeclare package Medium = Medium,
    TDHWSet=TDHWSet,
    TColdWaterNom=TColdWaterNom) annotation (Placement(transformation(
        extent={{-9,5},{9,-5}},
        rotation=-90,
        origin={-67,-19})));
  IDEAS.Fluid.FixedResistances.Pipe_Insulated pipeDHW(redeclare package Medium
      =                                                                          Medium, m=1,
    UA=10,
    m_flow_nominal=m_flow_nominal_DHW)
    annotation (Placement(transformation(extent={{-48,-52},{-64,-46}})));
  IDEAS.Fluid.Sources.FixedBoundary absolutePressure1(
                                                     redeclare package Medium
      = Medium, use_T=false,
    nPorts=1)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-12,-62})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort
                                   senTemSto_top(redeclare package Medium =
        Medium, m_flow_nominal=sum(m_flow_nominal))
    "Temperature at the top outlet of the storage tank (port_a)"
    annotation (Placement(transformation(extent={{-44,-2},{-52,6}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort
                                   senTemSto_bot(redeclare package Medium =
        Medium, m_flow_nominal=sum(m_flow_nominal))
    "Temperature at the bottom inlet of the storage tank (port_b)"
    annotation (Placement(transformation(extent={{-26,-54},{-36,-44}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort
                                   senTemStoHX_out(redeclare package Medium =
        Medium, m_flow_nominal=sum(m_flow_nominal))
    "Temperature at the outlet of the storage tank heat exchanger (port_bHX)"
    annotation (Placement(transformation(extent={{-86,-74},{-98,-62}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b[nEmbPorts] heatPortEmb
    "Construction nodes for heat gains by embedded layers"
    annotation (Placement(transformation(extent={{-230,30},{-210,50}})));
  Modelica.Electrical.QuasiStationary.MultiPhase.Interfaces.PositivePlug
    plugLoad(m=1) if nLoads >= 1 "Electricity connection to the Inhome feeder"
    annotation (Placement(transformation(extent={{170,-30},{190,-10}})));
  Modelica.Blocks.Interfaces.RealInput[nTemSen] TSensor(final quantity="ThermodynamicTemperature",unit="K",displayUnit="degC", min=0)
    "Sensor temperature"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-224,-80})));
  Modelica.Blocks.Interfaces.RealInput TSet[nZones](    final quantity="ThermodynamicTemperature",unit="K",displayUnit="degC")
    "Set point temperature for the zones" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-210,-128}),
                          iconTransformation(
        extent={{-14,-14},{14,14}},
        rotation=90,
        origin={-2,-104})));
equation
  connect(voltageSource.pin_p, ground.pin) annotation (Line(
      points={{232,-84},{232,-92}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(dummyInHomeGrid.pinSingle, voltageSource.pin_n) annotation (Line(
      points={{226,-20},{232,-20},{232,-64}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(nakedTabs.port_a, convectionTabs.solid) annotation (Line(
      points={{-290,10},{-290,16},{-308,16},{-308,2},{-314,2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(nakedTabs.port_b, convectionTabs.solid) annotation (Line(
      points={{-290,-9.8},{-290,-16},{-308,-16},{-308,2},{-314,2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(dummyBuilding.heatPortEmb, convectionTabs.fluid) annotation (Line(
      points={{-338,2},{-330,2}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(realExpression.y, convectionTabs.Gc) annotation (Line(
      points={{-333,42},{-322,42},{-322,10}},
      color={0,0,127},
      smooth=Smooth.None));
     connect(wattsLawPlug.vi,plugLoad)  annotation (Line(
      points={{160,-20},{180,-20}},
      color={85,170,255},
      smooth=Smooth.None));
    connect(pipeReturnEmission[i].heatPort,fixedTemperature. port) annotation (
        Line(
        points={{118,-108},{118,-88},{-122,-88},{-122,-32},{-147,-32},{-147,-34}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(senTemEm_in.port_b,pumpRad [i].port_a) annotation (Line(
        points={{62,32},{68,32}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(pipeReturnEmission[i].port_b,senTemEm_out. port_a) annotation (Line(
      points={{108,-112},{96,-112}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heatingControl.y,pumpRad. m_flowSet) annotation (Line(
      points={{-139,-90},{80,-90},{80,19.52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fixedTemperature.port,heater. heatPort) annotation (Line(
      points={{-147,-34},{-147,-8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pipeReturn.heatPort,heater. heatPort) annotation (Line(
      points={{-28,-108},{-28,-88},{-122,-88},{-122,-32},{-147,-32},{-147,-8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pipeSupply.heatPort,fixedTemperature. port) annotation (Line(
      points={{-26,34},{-26,22},{-122,22},{-122,-14},{-147,-14},{-147,-34}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pipeReturn.port_b,heater. port_a) annotation (Line(
      points={{-38,-112},{-126,-112},{-126,-2.54545},{-134,-2.54545}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipeSupply.port_b,idealCtrlMixer. port_a1) annotation (Line(
      points={{-16,38},{14,38}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(absolutePressure.ports[1],heater. port_a) annotation (Line(
      points={{-126,-124},{-126,-2.54545},{-134,-2.54545}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(emission.port_b,pipeReturnEmission. port_a) annotation (Line(
      points={{130,14},{136,14},{136,-112},{128,-112}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pumpRad.port_b,emission. port_a) annotation (Line(
      points={{92,32},{96,32},{96,14},{100,14}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TSet_max.y,ctrl_Heating. TRoo_in1) annotation (Line(
      points={{-204,91.9},{-204,44},{-180.889,44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSet,add. u2) annotation (Line(
      points={{-210,-128},{-210,-95.2},{-195.4,-95.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y,heatingControl. u) annotation (Line(
      points={{-179.3,-91},{-166,-91},{-166,-90},{-162,-90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(idealCtrlMixer.port_b,senTemEm_in. port_a) annotation (Line(
      points={{36,38},{40,38},{40,32},{42,32}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heater.port_b,senTemHea_out. port_a) annotation (Line(
      points={{-134,4.72727},{-132,4.72727},{-132,38},{-82,38}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemHea_out.port_b,pipeSupply. port_a) annotation (Line(
      points={{-62,38},{-36,38}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemEm_out.port_b,pipeReturn. port_a) annotation (Line(
      points={{80,-112},{-18,-112}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(idealCtrlMixer.port_a2,pipeReturn. port_a) annotation (Line(
      points={{25,26},{25,20},{26,20},{26,14},{72,14},{72,-112},{-18,-112}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TSensor,add. u1) annotation (Line(
      points={{-224,-80},{-210,-80},{-210,-86.8},{-195.4,-86.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ctrl_Heating.THeaterSet,heater. TSet) annotation (Line(
      points={{-159.556,44},{-145,44},{-145,12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ctrl_Heating.THeaCur,idealCtrlMixer. TMixedSet) annotation (Line(
      points={{-159.556,49},{-146,49},{-146,56},{25,56},{25,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(THigh_val.y,heatingControl. uHigh) annotation (Line(
      points={{-181.4,-72},{-172,-72},{-172,-83.2},{-162,-83.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TLow_val.y,heatingControl. uLow) annotation (Line(
      points={{-179.3,-112},{-172,-112},{-172,-97},{-162,-97}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pumpSto.port_a,tesTank. portHXLower) annotation (Line(
      points={{-50,-68},{-46,-68},{-46,-33.8462}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipeDHW.heatPort,fixedTemperature. port) annotation (Line(
      points={{-56,-52},{-76,-52},{-76,-88},{-122,-88},{-122,-32},{-147,-32},{
          -147,-34}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pumpSto.heatPort,fixedTemperature. port) annotation (Line(
      points={{-56.3,-74},{-46,-74},{-46,-88},{-122,-88},{-122,-32},{-147,-32},
          {-147,-34}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(tesTank.heatExchEnv,fixedTemperature. port) annotation (Line(
      points={{-22.6667,-21.5385},{-4,-21.5385},{-4,-88},{-122,-88},{-122,-32},
          {-147,-32},{-147,-34}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(emission.heatPortEmb,heatPortEmb)  annotation (Line(
      points={{115,24},{114,24},{114,78},{-200,78},{-200,40},{-220,40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(ctrl_Heating.onOff,pumpSto. m_flowSet) annotation (Line(
      points={{-159.556,36.5},{-142,36.5},{-142,28},{-98,28},{-98,-54},{-57,-54},
          {-57,-60.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dHW.port_cold,pipeDHW. port_b) annotation (Line(
      points={{-68.5,-27.3571},{-68.5,-49},{-64,-49}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(tesTank.T[posTTop],ctrl_Heating. TTankTop) annotation (Line(
      points={{-18,-15.3846},{-2,-15.3846},{-2,60},{-196,60},{-196,51.375},{
          -181,51.375}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tesTank.T[posTBot],ctrl_Heating. TTankBot) annotation (Line(
      points={{-18,-15.3846},{-10,-15.3846},{-10,-16},{-2,-16},{-2,60},{-196,60},
          {-196,36.5},{-180.889,36.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dHW.port_hot,senTemSto_top. port_b) annotation (Line(
      points={{-68.5,-9.35714},{-68.5,2},{-52,2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemSto_top.port_a,tesTank. port_a) annotation (Line(
      points={{-44,2},{-14,2},{-14,-3.07692},{-18,-3.07692}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipeDHW.port_a,senTemSto_bot. port_b) annotation (Line(
      points={{-48,-49},{-36,-49}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemSto_bot.port_a,tesTank. port_b) annotation (Line(
      points={{-26,-49},{-16,-49},{-16,-36.9231},{-18,-36.9231}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(absolutePressure1.ports[1],tesTank. port_b) annotation (Line(
      points={{-12,-56},{-12,-48},{-16,-48},{-16,-36.9231},{-18,-36.9231}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(tesTank.portHXUpper,pipeSupply. port_a) annotation (Line(
      points={{-46,-27.6923},{-50,-27.6923},{-50,-28},{-56,-28},{-56,38},{-36,
          38}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pumpSto.port_b,senTemStoHX_out. port_a) annotation (Line(
      points={{-64,-68},{-86,-68}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemStoHX_out.port_b,heater. port_a) annotation (Line(
      points={{-98,-68},{-126,-68},{-126,-2.54545},{-134,-2.54545}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dummyInHomeGrid.nodeSingle, plugLoad) annotation (Line(
      points={{206,-20},{180,-20}},
      color={85,170,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-380,-220},{
            340,180}}), graphics={       Rectangle(
          extent={{-118,10},{68,-84}},
          lineColor={135,135,135},
          lineThickness=1), Text(
          extent={{16,10},{66,0}},
          lineColor={135,135,135},
          lineThickness=1,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="Thermal Energy Storage")}),
    experiment(StopTime=200000, Interval=900),
    __Dymola_experimentSetupOutput,
    Icon(coordinateSystem(extent={{-380,-220},{340,180}})));
end Heating_Embedded_DHW_STS;
