within IBPSA.Fluid.HeatPumps.Examples.BaseClasses;
partial model PartialOneRoomRadiator
  "Simple room model with radiator, without a heat pump"
  extends Modelica.Icons.Example;
  replaceable package MediumA =
      IBPSA.Media.Air "Medium model for air";
  replaceable package MediumW =
      IBPSA.Media.Water "Medium model for water";

  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal=20000
    "Nominal heat flow rate of radiator";
  parameter Modelica.Units.SI.Temperature TRadSup_nominal=273.15 + 50
    "Radiator nominal supply water temperature";
  parameter Modelica.Units.SI.Temperature TRadRet_nominal=273.15 + 45
    "Radiator nominal return water temperature";
  parameter Modelica.Units.SI.MassFlowRate mHeaPum_flow_nominal=Q_flow_nominal/
      4200/5 "Heat pump nominal mass flow rate";
  parameter Modelica.Units.SI.Volume V=6*10*3 "Room volume";
  parameter Modelica.Units.SI.MassFlowRate mA_flow_nominal=V*1.2*6/3600
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.HeatFlowRate QRooInt_flow=4000
    "Internal heat gains of the room";
//------------------------------------------------------------------------------//

  IBPSA.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = MediumA,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mA_flow_nominal,
    V=V)
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G=20000/40)
    "Thermal conductance with the ambient"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHea
    "Prescribed heat flow"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heaCap(C=2*V*1.2*1006)
    "Heat capacity for furniture and walls"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  Modelica.Blocks.Sources.CombiTimeTable timTab(
      extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
      smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
      table=[-6*3600, 0;
              8*3600, QRooInt_flow;
             18*3600, 0]) "Time table for internal heat gain"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  IBPSA.Fluid.HeatExchangers.Radiators.RadiatorEN442_2 rad(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    Q_flow_nominal=Q_flow_nominal,
    T_a_nominal=TRadSup_nominal,
    T_b_nominal=TRadRet_nominal,
    m_flow_nominal=mHeaPum_flow_nominal,
    T_start=TRadSup_nominal)     "Radiator"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  IBPSA.Fluid.Sensors.TemperatureTwoPort temSup(
    redeclare package Medium = MediumW,
    m_flow_nominal=mHeaPum_flow_nominal,
    T_start=TRadSup_nominal)            "Supply water temperature"
      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-70,-20})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temRoo
    "Room temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        origin={-40,30})));

//----------------------------------------------------------------------------//

  IBPSA.Fluid.Movers.FlowControlled_m_flow pumHeaPum(
    redeclare package Medium = MediumW,
    m_flow_nominal=mHeaPum_flow_nominal,
    m_flow_start=0.85,
    T_start=TRadSup_nominal,
    nominalValuesDefineDefaultPressureCurve=true,
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) "Pump for radiator side"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-70,-110})));
//----------------------------------------------------------------------------//

  IBPSA.Fluid.Sensors.TemperatureTwoPort temRet(
    redeclare package Medium = MediumW,
    m_flow_nominal=mHeaPum_flow_nominal,
    T_start=TRadSup_nominal) "Return water temperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,-20})));

//------------------------------------------------------------------------------------//

  IBPSA.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource(
        "modelica://IBPSA/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data reader"
    annotation (Placement(transformation(extent={{-220,40},{-200,60}})));
  IBPSA.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-160,40},{-140,60}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TOut
    "Outside temperature"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));

//--------------------------------------------------------------------------------------//

  IBPSA.Fluid.Movers.FlowControlled_m_flow pumHeaPumSou(
    redeclare package Medium = MediumW,
    m_flow_start=0.85,
    m_flow_nominal=mHeaPum_flow_nominal,
    nominalValuesDefineDefaultPressureCurve=true,
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Pump for heat pump source side" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-30,-180})));
  Modelica.Blocks.Logical.Hysteresis hysHea(uLow=273.15 + 19, uHigh=273.15 + 21)
    "Hysteresis controller for heating" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}}, origin={-190,-40})));
  Modelica.Blocks.Logical.Not not2 "If lower than hysteresis, heating demand"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        origin={-150,-40})));
  Modelica.Blocks.Math.BooleanToReal booToReaPumCon(realTrue=
        mHeaPum_flow_nominal, y(start=0)) "Pump signal" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-110,-110})));
  Modelica.Blocks.Math.BooleanToReal booToReaPum1(
    realTrue=1,
    y(start=0))
    "Pump signal" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={40,-110})));
  IBPSA.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = MediumW,
    T=281.15,
    nPorts=1) "Fluid source on source side"
    annotation (Placement(transformation(extent={{-80,-210},{-60,-190}})));
  IBPSA.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = MediumW,
    T=283.15) "Fluid sink on source side"
    annotation (Placement(transformation(extent={{80,-210},{60,-190}})));
  IBPSA.Fluid.Sources.Boundary_pT preSou(
    redeclare package Medium = MediumW,
    T=TRadSup_nominal,
    nPorts=1)
    "Source for pressure and to account for thermal expansion of water"
    annotation (Placement(transformation(extent={{90,-130},{70,-110}})));

  Modelica.Blocks.Math.BooleanToReal booToReaPumEva(realTrue=1, y(start=0))
    "Pump signal" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-110,-180})));
  Modelica.Blocks.Logical.Hysteresis hysCoo(uLow=273.15 + 22, uHigh=273.15 + 24)
    "Hysteresis controller for cooling" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}}, origin={-190,-70})));
  Modelica.Blocks.Logical.Or  or1 "Either heating or cooling"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        origin={-106,-54})));
equation
  connect(theCon.port_b, vol.heatPort) annotation (Line(
      points={{40,50},{50,50},{50,30},{60,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(preHea.port, vol.heatPort) annotation (Line(
      points={{40,80},{50,80},{50,30},{60,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(heaCap.port, vol.heatPort) annotation (Line(
      points={{70,50},{50,50},{50,30},{60,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(timTab.y[1], preHea.Q_flow) annotation (Line(
      points={{1,80},{20,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSup.port_b, rad.port_a) annotation (Line(
      points={{-70,-10},{-70,0},{0,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(temRoo.port, vol.heatPort) annotation (Line(
      points={{-30,30},{60,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(rad.heatPortCon, vol.heatPort) annotation (Line(
      points={{8,7.2},{8,30},{60,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(rad.heatPortRad, vol.heatPort) annotation (Line(
      points={{12,7.2},{12,30},{60,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-200,50},{-150,50}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus.TDryBul, TOut.T) annotation (Line(
      points={{-150,50},{-22,50}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(TOut.port, theCon.port_a) annotation (Line(
      points={{0,50},{20,50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(hysHea.y, not2.u)
    annotation (Line(points={{-179,-40},{-162,-40}}, color={255,0,255}));
  connect(temRoo.T, hysHea.u) annotation (Line(points={{-51,30},{-220,30},{-220,
          -40},{-202,-40}}, color={0,0,127}));
  connect(pumHeaPum.port_b, temSup.port_a)
    annotation (Line(points={{-70,-100},{-70,-30}},color={0,127,255}));
  connect(temRet.port_a, rad.port_b)
    annotation (Line(points={{60,-10},{60,0},{20,0}},     color={0,127,255}));
  connect(booToReaPumCon.y, pumHeaPum.m_flow_in)
    annotation (Line(points={{-99,-110},{-82,-110}}, color={0,0,127}));
  connect(sou.ports[1], pumHeaPumSou.port_a) annotation (Line(points={{-60,-200},
          {-30,-200},{-30,-190}}, color={0,127,255}));
  connect(preSou.ports[1], temRet.port_b) annotation (Line(points={{70,-120},{60,
          -120},{60,-30}}, color={0,127,255}));
  connect(booToReaPumEva.y, pumHeaPumSou.m_flow_in)
    annotation (Line(points={{-99,-180},{-42,-180}}, color={0,0,127}));
  connect(hysCoo.y, or1.u2) annotation (Line(points={{-179,-70},{-124,-70},{
          -124,-62},{-118,-62}}, color={255,0,255}));
  connect(or1.y, booToReaPum1.u)
    annotation (Line(points={{-95,-54},{40,-54},{40,-98}}, color={255,0,255}));
  connect(not2.y, or1.u1) annotation (Line(points={{-139,-40},{-126,-40},{-126,
          -54},{-118,-54}}, color={255,0,255}));
  connect(hysCoo.u, temRoo.T) annotation (Line(points={{-202,-70},{-220,-70},{
          -220,30},{-51,30}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
Example that simulates one room equipped with a radiator. Hot water is produced
by a <i>24</i> kW nominal capacity heat pump. The source side water temperature to the
heat pump is constant at <i>10</i>&deg;C.
</p>
<p>
The heat pump is turned on when the room temperature falls below
<i>19</i>&deg;C and turned
off when the room temperature rises above <i>21</i>&deg;C.
</p>
</html>", revisions="<html>
<ul>
<li>
July 22, 2021, by Michael Wetter:<br/>
Removed assignments <code>pumHeaPum(y_start=1)</code> and <code>pumHeaPumSou(y_start=1)</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1498\">#1498</a>.
</li>
<li>
April 21, 2021, by Michael Wetter:<br/>
Corrected error in calculation of design mass flow rate.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2458\">#2458</a>.
</li>
<li>
May 2, 2019, by Jianjun Hu:<br/>
Replaced fluid source. This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1072\"> #1072</a>.
</li>
<li>
March 3, 2017, by Michael Wetter:<br/>
Changed mass flow test to use a hysteresis as a threshold test
can cause chattering.
</li>
<li>
January 27, 2017, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-240,-220},{100,
            100}})),
    __Dymola_Commands(file=
     "modelica://IBPSA/Resources/Scripts/Dymola/Fluid/HeatPumps/Examples/ScrollWaterToWater_OneRoomRadiator.mos"
        "Simulate and plot"),
    experiment(
      StopTime=172800,
      Tolerance=1e-08));
end PartialOneRoomRadiator;
