within IBPSA.Fluid.MassExchangers.Validation;
model Humidifier_X
  "Model that demonstrates the ideal humidifier/dehumidifier model, configured as steady-state"
  extends Modelica.Icons.Example;
  package Medium = IBPSA.Media.Air;
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=0.1
    "Nominal mass flow rate";
  parameter Modelica.SIunits.MassFlowRate mWat_flow_nominal = 4e-4
    "Maximum humidification or dehumidification ratio";

  IBPSA.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    use_T_in=false,
    p(displayUnit="Pa"),
    T=293.15,
    nPorts=3) "Sink"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},rotation=180,origin={150,30})));
  IBPSA.Fluid.MassExchangers.Humidifier_X hum(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=6000,
    mWat_flow_maxDehumidification=0,
    mWat_flow_maxHumidification=mWat_flow_nominal,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Steady-state model with capacity limitation"
    annotation (Placement(transformation(extent={{40,110},{60,130}})));
  Sources.MassFlowSource_T sou1(
    redeclare package Medium = Medium,
    nPorts=1,
    m_flow=m_flow_nominal,
    T=293.15) "Flow source"
    annotation (Placement(transformation(extent={{-40,110},{-20,130}})));
  Sources.MassFlowSource_T sou2(
    redeclare package Medium = Medium,
    nPorts=1,
    m_flow=m_flow_nominal,
    T=293.15) "Flow source"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Sources.MassFlowSource_T sou3(
    redeclare package Medium = Medium,
    nPorts=1,
    m_flow=m_flow_nominal,
    T=293.15) "Flow source"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Modelica.Blocks.Sources.CombiTimeTable XSet(
    tableOnFile=false,
    table=[
      0.0,  0.01;
      1*180,0.012;
      2*180,0.015;
      3*180,0.01;
      4*180,0.008;
      5*180,0.004;
      6*180,0.01],
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Set point for humidity"
    annotation (Placement(transformation(extent={{-20,160},{0,180}})));
  IBPSA.Fluid.Sensors.MassFractionTwoPort senHum(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    tau=0) "Mass fraction sensor"
    annotation (Placement(transformation(extent={{80,110},{100,130}})));
  IBPSA.Fluid.MassExchangers.Humidifier_X dem(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=6000,
    mWat_flow_maxHumidification=0,
    mWat_flow_maxDehumidification=-mWat_flow_nominal,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Steady-state model with capacity limitation"
    annotation (Placement(transformation(extent={{38,20},{58,40}})));
  IBPSA.Fluid.Sensors.MassFractionTwoPort senDem(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    tau=0) "Mass fraction sensor"
    annotation (Placement(transformation(extent={{78,20},{98,40}})));
  IBPSA.Fluid.MassExchangers.Humidifier_X humDeh(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=6000,
    mWat_flow_maxHumidification=mWat_flow_nominal,
    mWat_flow_maxDehumidification=-mWat_flow_nominal,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
                     "Steady-state model with capacity limitation"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  IBPSA.Fluid.Sensors.MassFractionTwoPort senHumDem(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    tau=0) "Mass fraction sensor"
    annotation (Placement(transformation(extent={{80,-60},{100,-40}})));
equation
  connect(sou1.ports[1], hum.port_a)
    annotation (Line(points={{-20,120},{10,120},{40,120}}, color={0,127,255}));
  connect(XSet.y[1], hum.X_w) annotation (Line(points={{1,170},{20,170},{20,126},
          {38,126}}, color={0,0,127}));
  connect(hum.port_b, senHum.port_a)
    annotation (Line(points={{60,120},{80,120}}, color={0,127,255}));
  connect(sou2.ports[1], dem.port_a)
    annotation (Line(points={{-20,30},{10,30},{38,30}}, color={0,127,255}));
  connect(sou3.ports[1], humDeh.port_a)
    annotation (Line(points={{-20,-50},{40,-50}},          color={0,127,255}));
  connect(dem.port_b, senDem.port_a)
    annotation (Line(points={{58,30},{68,30},{78,30}}, color={0,127,255}));
  connect(humDeh.port_b, senHumDem.port_a)
    annotation (Line(points={{60,-50},{80,-50}},          color={0,127,255}));
  connect(senHum.port_b, sin.ports[1]) annotation (Line(points={{100,120},{112,
          120},{128,120},{128,32.6667},{140,32.6667}},
                                                  color={0,127,255}));
  connect(senDem.port_b, sin.ports[2])
    annotation (Line(points={{98,30},{120,30},{140,30}}, color={0,127,255}));
  connect(senHumDem.port_b, sin.ports[3]) annotation (Line(points={{100,-50},{
          120,-50},{128,-50},{128,27.3333},{140,27.3333}},
                                                       color={0,127,255}));
  connect(XSet.y[1], dem.X_w) annotation (Line(points={{1,170},{20,170},{20,36},
          {36,36}}, color={0,0,127}));
  connect(XSet.y[1], humDeh.X_w) annotation (Line(points={{1,170},{20,170},{20,-44},
          {38,-44}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,
            -100},{200,200}})),
    __Dymola_Commands(file= "modelica://IBPSA/Resources/Scripts/Dymola/Fluid/MassExchangers/Validation/Humidifier_X.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Model that demonstrates the use of an ideal humidifier or
dehumidifier. The different models vary in who they limit their
maximum humidificiation or dehumidification mass flow rate.
</p>
</html>", revisions="<html>
<ul>
<li>
May 3, 2017, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(
      StopTime=1080,
      Tolerance=1e-6));
end Humidifier_X;
