within Annex60.Fluid.Examples;
model SimpleHouse
  extends Modelica.Icons.Example;

  package MediumAir = Annex60.Media.Air;
  package MediumWater = Annex60.Media.Water;

  parameter Modelica.SIunits.Area A_wall = 100 "Wall area";
  parameter Modelica.SIunits.Volume V_zone = A_wall*3 "Wall area";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=3*rad.m_flow_nominal
    "Nominal mass flow rate";
  parameter Modelica.SIunits.Pressure dp_nominal=200
    "Pressure drop at nominal mass flow rate";
  parameter Boolean allowFlowReversal=false
    "= false because flow will not reverse in these circuits";

  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor walCap(C=10*A_wall*0.1
        *1000*1000, T(fixed=true)) "Thermal mass of walls"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={142,20})));
  MixingVolumes.MixingVolume zone(
    redeclare package Medium = MediumAir,
    V=V_zone,
    nPorts=2,
    m_flow_nominal=0.01,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Zone air volume"
    annotation (Placement(transformation(extent={{102,120},{82,140}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor convRes(R=1/2/A_wall)
    "Thermal resistance for convective heat transfer with h=2"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={130,54})));
  HeatExchangers.Radiators.RadiatorEN442_2 rad(
    redeclare package Medium = MediumWater,
    Q_flow_nominal=3000,
    T_a_nominal=273.15 + 70,
    T_b_nominal=273.15 + 50,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal=allowFlowReversal) "Radiator"
    annotation (Placement(transformation(extent={{104,-128},{124,-108}})));

  Sources.Boundary_pT bouAir(redeclare package Medium = MediumAir, nPorts=2,
    T=273.15 + 10) "Air boundary with constant temperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,120})));
  Sources.Boundary_pT bouWat(redeclare package Medium = MediumWater, nPorts=1)
    "Pressure bound for water circuit" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={46,-90})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam="modelica://Annex60/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    "Weather data reader"
    annotation (Placement(transformation(extent={{-200,10},{-180,30}})));
  BoundaryConditions.WeatherData.Bus weaBus1 "Weather data bus"
    annotation (Placement(transformation(extent={{-130,10},{-110,30}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor wallRes(R=0.25/
        A_wall/0.04) "Thermal resistor for wall: 25 cm of rockwool"
    annotation (Placement(transformation(extent={{66,20},{86,40}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature Tout
    "Exterior temperature boundary condition"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  HeatExchangers.HeaterCooler_u hea(
    redeclare package Medium = MediumWater,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=1000,
    Q_flow_nominal=5000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=allowFlowReversal)
    annotation (Placement(transformation(extent={{44,-128},{64,-108}})));

  Movers.FlowControlled_m_flow                 pump2(
    redeclare package Medium = MediumWater,
    filteredSpeed=false,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=allowFlowReversal)
    annotation (Placement(transformation(extent={{80,-190},{60,-170}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTemZonAir
    "Zone air temperature sensor"
    annotation (Placement(transformation(extent={{40,140},{20,160}})));
  Actuators.Dampers.VAVBoxExponential vavDam(
    redeclare package Medium = MediumAir,
    m_flow_nominal=0.01,
    dp_nominal=dp_nominal,
    from_dp=true) "Damper" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={0,100})));

  Movers.FlowControlled_dp                 fan2(
    redeclare package Medium = MediumAir,
    m_flow_nominal=0.01,
    dp_nominal=dp_nominal,
    filteredSpeed=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Constant head fan"  annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,100})));
  Modelica.Blocks.Logical.Hysteresis hysAir(uLow=273.15 + 24, uHigh=273.15 + 22)
    "Hysteresis controller for ventilation"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal "Boolean to real"
    annotation (Placement(transformation(extent={{-50,80},{-30,100}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow window
    "Very simple window model"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  HeatExchangers.ConstantEffectiveness hexRec(
    redeclare package Medium1 = MediumAir,
    redeclare package Medium2 = MediumAir,
    m1_flow_nominal=0.01,
    m2_flow_nominal=0.01,
    eps=0.85,
    dp1_nominal=0,
    dp2_nominal=0) "Heat exchanger for heat recuperation"
    annotation (Placement(transformation(extent={{78,94},{48,126}})));
  Modelica.Blocks.Logical.Hysteresis hysRad(uLow=273.15 + 22, uHigh=273.15 + 20)
    "Hysteresis controller for radiator"
    annotation (Placement(transformation(extent={{-74,-116},{-54,-96}})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal1 "Boolean to real"
    annotation (Placement(transformation(extent={{-16,-116},{4,-96}})));
  Modelica.Blocks.Logical.Not not1
    "negation for enabling heating when temperatur is low"
    annotation (Placement(transformation(extent={{-46,-116},{-26,-96}})));
  Modelica.Blocks.Sources.Constant const_m_flow(k=m_flow_nominal)
    "Constant mass flow rate"
    annotation (Placement(transformation(extent={{-4,-166},{16,-146}})));
  Modelica.Blocks.Sources.Constant const_dp(k=200) "Pressure head"
    annotation (Placement(transformation(extent={{-8,124},{12,144}})));

equation
  connect(convRes.port_b, walCap.port)
    annotation (Line(points={{130,44},{130,44},{130,20},{132,20}},
                                                             color={191,0,0}));
  connect(convRes.port_a, zone.heatPort) annotation (Line(points={{130,64},{130,
          126},{102,126},{102,130}}, color={191,0,0}));
  connect(weaDat.weaBus, weaBus1) annotation (Line(
      points={{-180,20},{-180,20},{-120,20}},
      color={255,204,51},
      thickness=0.5));
  connect(wallRes.port_b, walCap.port) annotation (Line(points={{86,30},{132,30},
          {132,20}},            color={191,0,0}));
  connect(Tout.T, weaBus1.TDryBul)
    annotation (Line(points={{-22,30},{-120,30},{-120,20}}, color={0,0,127}));
  connect(Tout.port, wallRes.port_a)
    annotation (Line(points={{0,30},{0,30},{66,30}}, color={191,0,0}));
  connect(hea.port_b, rad.port_a) annotation (Line(points={{64,-118},{84,-118},{
          104,-118}}, color={0,127,255}));
  connect(bouWat.ports[1], hea.port_a) annotation (Line(points={{46,-100},{44,-100},
          {44,-118}}, color={0,127,255}));
  connect(rad.port_b, pump2.port_a) annotation (Line(points={{124,-118},{144,-118},
          {144,-180},{80,-180}}, color={0,127,255}));
  connect(senTemZonAir.port, zone.heatPort) annotation (Line(points={{40,150},{40,
          150},{102,150},{102,130}}, color={191,0,0}));
  connect(vavDam.port_b, fan2.port_a)
    annotation (Line(points={{10,100},{10,100},{20,100}}, color={0,127,255}));
  connect(vavDam.port_a, bouAir.ports[1]) annotation (Line(points={{-10,100},{
          -10,122},{-40,122}}, color={0,127,255}));
  connect(hysAir.y, booleanToReal.u)
    annotation (Line(points={{-59,90},{-59,90},{-52,90}}, color={255,0,255}));
  connect(booleanToReal.y, vavDam.y)
    annotation (Line(points={{-29,90},{0,90},{0,88}}, color={0,0,127}));
  connect(window.port, walCap.port) annotation (Line(points={{0,0},{132,0},{132,
          16},{132,20}}, color={191,0,0}));
  connect(window.Q_flow, weaBus1.HGloHor)
    annotation (Line(points={{-20,0},{-120,0},{-120,20}}, color={0,0,127}));
  connect(bouAir.ports[2], hexRec.port_b1) annotation (Line(points={{-40,118},{-40,
          119.6},{48,119.6}}, color={0,127,255}));
  connect(hexRec.port_a1, zone.ports[1]) annotation (Line(points={{78,119.6},{85,
          119.6},{85,120},{94,120}},      color={0,127,255}));
  connect(fan2.port_b, hexRec.port_a2) annotation (Line(points={{40,100},{44,100},
          {44,100.4},{48,100.4}}, color={0,127,255}));
  connect(hexRec.port_b2, zone.ports[2]) annotation (Line(points={{78,100.4},{90,
          100.4},{90,120}}, color={0,127,255}));
  connect(rad.heatPortCon, zone.heatPort) annotation (Line(points={{112,-110.8},
          {112,-110.8},{112,64},{112,130},{102,130}}, color={191,0,0}));
  connect(rad.heatPortRad, walCap.port) annotation (Line(points={{116,-110.8},{118,
          -110.8},{118,-110},{132,-110},{132,20}}, color={191,0,0}));
  connect(hysAir.u, senTemZonAir.T) annotation (Line(points={{-82,90},{-90,90},{
          -90,150},{20,150}}, color={0,0,127}));
  connect(hysRad.u, hysAir.u) annotation (Line(points={{-76,-106},{-90,-106},{-90,
          90},{-82,90}}, color={0,0,127}));
  connect(not1.y, booleanToReal1.u) annotation (Line(points={{-25,-106},{-22,-106},
          {-18,-106}}, color={255,0,255}));
  connect(not1.u, hysRad.y) annotation (Line(points={{-48,-106},{-52,-106},{-53,
          -106}}, color={255,0,255}));
  connect(booleanToReal1.y, hea.u)
    annotation (Line(points={{5,-106},{42,-106},{42,-112}}, color={0,0,127}));
  connect(hea.port_a, pump2.port_b) annotation (Line(points={{44,-118},{28,-118},
          {28,-120},{28,-172},{28,-180},{60,-180}}, color={0,127,255}));
  connect(const_m_flow.y, pump2.m_flow_in) annotation (Line(points={{17,-156},{70.2,
          -156},{70.2,-168}}, color={0,0,127}));
  connect(const_dp.y, fan2.dp_in) annotation (Line(points={{13,134},{29.8,134},{
          29.8,112}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -200},{200,200}}), graphics={
        Rectangle(
          extent={{-226,74},{30,-42}},
          lineColor={28,108,200},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-180,-88},{174,-198}},
          lineColor={28,108,200},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-140,186},{106,76}},
          lineColor={28,108,200},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-62,160},{-128,178}},
          lineColor={28,108,200},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Ventilation"),
        Rectangle(
          extent={{54,74},{174,-42}},
          lineColor={28,108,200},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{118,-28},{52,-10}},
          lineColor={28,108,200},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Wall"),
        Text(
          extent={{-114,-120},{-180,-102}},
          lineColor={28,108,200},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Heating"),
        Text(
          extent={{-102,36},{-222,64}},
          lineColor={28,108,200},
          fillColor={255,213,170},
          fillPattern=FillPattern.Solid,
          textString="Weather inputs")}),
    experiment(StopTime=1e+06),
    __Dymola_experimentSetupOutput(events=false),
    Documentation(revisions="<html>
<ul>
<li>
September 19, 2015, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model contains a very simple model of a house, 
with a heating system, ventilation and weather boundary conditions. 
It servers as a demonstration case of how the Annex 60 library can be used. 
This model was demonstrated at the joint Annex 60 meeting in Leuven on 18 september 2015.
</p>
</html>"));
end SimpleHouse;
