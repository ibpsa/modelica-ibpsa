within IDEAS.HeatingSystems.Interfaces;
partial model Partial_heating_noSTS
  replaceable package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  extends IDEAS.Interfaces.BaseClasses.HeatingSystem(
    isHea = true,
    isCoo = false,
    nConvPorts = nZones,
    nRadPorts = nZones,
    nTemSen = nZones,
    nEmbPorts=0,
    nLoads=1,
    nZones=1);

  // --- Paramter: General parameters for the design (nominal) conditions and heat curve
  parameter Modelica.SIunits.Power[nZones] QNom(each min=0) = ones(nZones)*5000
    "Nominal power, can be seen as the max power of the emission system per zone";
  parameter Modelica.SIunits.Temperature TSupNom=273.15 + 45
    "Nominal supply temperature";
  parameter Modelica.SIunits.TemperatureDifference dTSupRetNom=10
    "Nominal DT in the heating system";
  parameter Modelica.SIunits.Temperature[nZones] TRoomNom={294.15 for i in 1:
      nZones} "Nominal room temperature";
  parameter Modelica.SIunits.Time timeFilter=43200
    "Time constant for the filter of ambient temperature for computation of heating curve";
  final parameter Modelica.SIunits.MassFlowRate[nZones] m_flow_nominal = QNom/(4180.6*dTSupRetNom)
    "Nominal mass flow rates";

  // --- production components of hydraulic circuit
  replaceable Fluid.Production.Boiler       heater(
    QNom=sum(QNom), redeclare package Medium = Medium,
    m_flow_nominal=sum(m_flow_nominal)) constrainedby
    Fluid.Production.Interfaces.PartialDynamicHeaterWithLosses
    "Heater (boiler, heat pump, ...)"
    annotation (Placement(transformation(extent={{-112,12},{-92,32}})));

  // --- distribution components of hydraulic circuit
  IDEAS.Fluid.Movers.Pump[nZones] pumpRad(
    each useInput=true,
    each m=1,
    m_flow_nominal=m_flow_nominal,
    redeclare each package Medium = Medium)
              annotation (Placement(transformation(extent={{88,46},{112,22}})));

  // --- emission components of hydraulic circuit
  replaceable IDEAS.Fluid.HeatExchangers.Radiators.Radiator[
                                                nZones] emission(
      each TInNom=TSupNom,
      each TOutNom=TSupNom - dTSupRetNom,
      TZoneNom=TRoomNom,
      QNom=QNom,
      each powerFactor=3.37,
    redeclare each package Medium = Medium) constrainedby
    Fluid.HeatExchangers.Interfaces.EmissionTwoPort
    annotation (Placement(transformation(extent={{120,24},{150,44}})));

  Fluid.Valves.Thermostatic3WayValve    idealCtrlMixer(m_flow_nominal=sum(
        m_flow_nominal), redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{28,22},{50,46}})));
  IDEAS.Fluid.FixedResistances.Pipe_Insulated pipeReturn(
    redeclare package Medium = Medium,
    m=1,
    UA=10,
    m_flow_nominal=sum(m_flow_nominal))
           annotation (Placement(transformation(extent={{4,-28},{-16,-36}})));

  IDEAS.Fluid.FixedResistances.Pipe_Insulated pipeSupply(
    redeclare package Medium = Medium,
    m=1,
    UA=10,
    m_flow_nominal=sum(m_flow_nominal))
           annotation (Placement(transformation(extent={{-16,30},{4,38}})));
  IDEAS.Fluid.FixedResistances.Pipe_Insulated[nZones] pipeReturnEmission(
    redeclare each package Medium = Medium,
    each m=1,
    each UA=10,
    m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{90,-28},{70,-36}})));

  // --- boudaries
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=293.15)
    "fixed temperature to simulate heat losses of hydraulic components"
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={-52,8})));
  IDEAS.Fluid.Sources.FixedBoundary absolutePressure(redeclare package Medium
      = Medium, use_T=false,
    nPorts=1)
    annotation (Placement(transformation(extent={{-114,-42},{-94,-22}})));

  // --- controllers
  replaceable Controls.ControlHeating.Ctrl_Heating ctrl_Heating(
    heatingCurve(timeFilter=timeFilter),
    TSupNom=TSupNom,
    dTSupRetNom=dTSupRetNom,
    THeaterSet(start=293.15)) constrainedby
    Controls.ControlHeating.Interfaces.Partial_Ctrl_Heating(
    heatingCurve(timeFilter=timeFilter),
    TSupNom=TSupNom,
    dTSupRetNom=dTSupRetNom)
    "Controller for the heater and the emission set point "
    annotation (Placement(transformation(extent={{-148,38},{-128,58}})));

  replaceable IDEAS.Controls.Control_fixme.Hyst_NoEvent_Var[
                                                nZones] heatingControl(each uLow_val=
        22, each uHigh_val=20)
    "onoff controller for the pumps of the emission circuits"
    annotation (Placement(transformation(extent={{42,-70},{62,-50}})));

  Modelica.Blocks.Sources.RealExpression THigh_val[nZones](y=0.5*ones(nZones))
    "Higher boudary for set point temperature"
    annotation (Placement(transformation(extent={{-18,-62},{20,-42}})));
  Modelica.Blocks.Sources.RealExpression TLow_val[nZones](y=-0.5*ones(nZones))
    "Lower boundary for set point temperature"
    annotation (Placement(transformation(extent={{-18,-80},{20,-60}})));

  Modelica.Blocks.Sources.RealExpression TSet_max(y=max(TSet))
    "maximum value of set point temperature" annotation (Placement(
        transformation(
        extent={{-21,-10},{21,10}},
        rotation=90,
        origin={-160,3})));
  Modelica.Blocks.Math.Add add[nZones](each k1=-1, each k2=+1)
    annotation (Placement(transformation(extent={{-62,-70},{-42,-50}})));

  // --- Interface
  Modelica.Blocks.Interfaces.RealInput TSet[nZones](    final quantity="ThermodynamicTemperature",unit="K",displayUnit="degC")
    "Set point temperature for the zones" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-140,-110}),
                          iconTransformation(
        extent={{-14,-14},{14,14}},
        rotation=90,
        origin={-2,-104})));

  // --- Sensors
  Fluid.Sensors.TemperatureTwoPort senTemEm_in(redeclare package Medium =
        Medium, m_flow_nominal=sum(m_flow_nominal))
    "Inlet temperature of the emission system"
    annotation (Placement(transformation(extent={{56,24},{76,44}})));
  Fluid.Sensors.TemperatureTwoPort senTemHea_out(redeclare package Medium =
        Medium, m_flow_nominal=sum(m_flow_nominal))
    "Outlet temperature of the heater"
    annotation (Placement(transformation(extent={{-62,24},{-42,44}})));

  Fluid.Sensors.TemperatureTwoPort senTemEm_out(redeclare package Medium =
        Medium, m_flow_nominal=sum(m_flow_nominal))
    "Outlet temperature of the emission system" annotation (Placement(
        transformation(
        extent={{8,-8},{-8,8}},
        rotation=0,
        origin={42,-26})));
equation
  P[1] = heater.PEl + sum(pumpRad.PEl);
  Q[1] = 0;
    // connections that are function of the number of circuits
  for i in 1:nZones loop
    connect(pipeReturnEmission[i].heatPort, fixedTemperature.port) annotation (
        Line(
        points={{80,-28},{80,-4},{-52,-4},{-52,2}},
        color={191,0,0},
        smooth=Smooth.None));
    connect(senTemEm_in.port_b, pumpRad[i].port_a) annotation (Line(
        points={{76,34},{88,34}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(pipeReturnEmission[i].port_b, senTemEm_out.port_a) annotation (Line(
      points={{70,-32},{58,-32},{58,-26},{50,-26}},
      color={0,127,255},
      smooth=Smooth.None));
  end for;

  // general connections for any configuration

  connect(heatingControl.y, pumpRad.m_flowSet) annotation (Line(
      points={{63,-60},{100,-60},{100,21.52}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(fixedTemperature.port, heater.heatPort) annotation (Line(
      points={{-52,2},{-52,-4},{-105,-4},{-105,12}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(pipeReturn.heatPort, heater.heatPort) annotation (Line(
      points={{-6,-28},{-6,-4},{-105,-4},{-105,12}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(THigh_val.y, heatingControl.uHigh) annotation (Line(
      points={{21.9,-52},{30,-52},{30,-53.2},{40,-53.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TLow_val.y, heatingControl.uLow) annotation (Line(
      points={{21.9,-70},{30,-70},{30,-67},{40,-67}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pipeSupply.heatPort, fixedTemperature.port) annotation (Line(
      points={{-6,30},{-6,-4},{-52,-4},{-52,2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(ctrl_Heating.THeaterSet, heater.TSet) annotation (Line(
      points={{-127.556,48},{-103,48},{-103,32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pipeReturn.port_b, heater.port_a) annotation (Line(
      points={{-16,-32},{-78,-32},{-78,17.4545},{-92,17.4545}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipeSupply.port_b, idealCtrlMixer.port_a1) annotation (Line(
      points={{4,34},{28,34}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(absolutePressure.ports[1], heater.port_a) annotation (Line(
      points={{-94,-32},{-78,-32},{-78,17.4545},{-92,17.4545}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(emission.port_b, pipeReturnEmission.port_a) annotation (Line(
      points={{150,34},{156,34},{156,-32},{90,-32}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pumpRad.port_b, emission.port_a) annotation (Line(
      points={{112,34},{120,34}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(TSet_max.y, ctrl_Heating.TRoo_in1) annotation (Line(
      points={{-160,26.1},{-160,48},{-149.111,48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSensor, add.u1) annotation (Line(
      points={{-204,-60},{-78,-60},{-78,-54},{-64,-54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSet, add.u2) annotation (Line(
      points={{-140,-110},{-140,-66},{-64,-66}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, heatingControl.u) annotation (Line(
      points={{-41,-60},{40,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ctrl_Heating.THeaCur, idealCtrlMixer.TMixedSet) annotation (Line(
      points={{-127.556,53},{39,53},{39,46}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(idealCtrlMixer.port_b, senTemEm_in.port_a) annotation (Line(
      points={{50,34},{56,34}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(heater.port_b, senTemHea_out.port_a) annotation (Line(
      points={{-92,24.7273},{-78,24.7273},{-78,34},{-62,34}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemHea_out.port_b, pipeSupply.port_a) annotation (Line(
      points={{-42,34},{-16,34}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(senTemEm_out.port_b, pipeReturn.port_a) annotation (Line(
      points={{34,-26},{26,-26},{26,-32},{4,-32}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(idealCtrlMixer.port_a2, pipeReturn.port_a) annotation (Line(
      points={{39,22},{39,8},{20,8},{20,-32},{4,-32}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -100},{200,100}}), graphics));
end Partial_heating_noSTS;
