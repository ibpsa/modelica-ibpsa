within IBPSA.Fluid.Movers.Validation.BaseClasses;
model ComparePower
  "Base class for validation models that compare power estimation methods"

  package Medium = IBPSA.Media.Water "Medium model";

  replaceable parameter IBPSA.Fluid.Movers.Data.Generic per
    constrainedby IBPSA.Fluid.Movers.Data.Generic
    "Performance records"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal =
    per.peak.V_flow * rho_default
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.PressureDifference dp_nominal =
    per.peak.dp
    "Nominal pressure drop";
  final parameter Modelica.Units.SI.Density rho_default=
    Medium.density_pTX(
      p=Medium.p_default,
      T=Medium.T_default,
      X=Medium.X_default) "Default medium density";

  replaceable IBPSA.Fluid.Movers.SpeedControlled_y mov1(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    addPowerToMedium=false,
    use_inputFilter=false)
    constrainedby IBPSA.Fluid.Movers.BaseClasses.PartialFlowMachine
    "Mover (fan or pump)"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  replaceable IBPSA.Fluid.Movers.SpeedControlled_y mov2(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    addPowerToMedium=false,
    use_inputFilter=false)
    constrainedby IBPSA.Fluid.Movers.BaseClasses.PartialFlowMachine
    "Mover (fan or pump)"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  replaceable IBPSA.Fluid.Movers.SpeedControlled_y mov3(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    addPowerToMedium=false,
    use_inputFilter=false)
    constrainedby IBPSA.Fluid.Movers.BaseClasses.PartialFlowMachine
    "Mover (fan or pump)"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));

  Buildings.Fluid.Actuators.Dampers.Exponential damExp1(
    redeclare final package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    use_inputFilter=false,
    dpDamper_nominal=dp_nominal/2,
    y_start=1,
    dpFixed_nominal=dp_nominal) "Damper"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Buildings.Fluid.Actuators.Dampers.Exponential damExp2(
    redeclare final package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    use_inputFilter=false,
    dpDamper_nominal=dp_nominal/2,
    y_start=1,
    dpFixed_nominal=dp_nominal) "Damper"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Buildings.Fluid.Actuators.Dampers.Exponential damExp3(
    redeclare final package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    use_inputFilter=false,
    dpDamper_nominal=dp_nominal/2,
    y_start=1,
    dpFixed_nominal=dp_nominal) "Damper"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));

  IBPSA.Fluid.Sources.Boundary_pT sou(
    redeclare final package Medium = Medium,
    nPorts=3)
    "Source"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  IBPSA.Fluid.Sources.Boundary_pT sin(
    redeclare final package Medium = Medium,
    nPorts=3)
    "Sink" annotation (Placement(transformation(extent={{100,-10},{80,10}})));
  IBPSA.Fluid.Sensors.MassFlowRate masFloRat(redeclare package Medium = Medium)
    "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  IBPSA.Fluid.Sensors.RelativePressure relPre(redeclare package Medium = Medium)
    "Pressure difference sensor"
                annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        origin={-30,10})));
  Modelica.Blocks.Sources.Ramp ramSpe(
    height=1,
    duration=60,
    startTime=20) "Ramp signal for mover speed"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Modelica.Blocks.Sources.Ramp ramDam(
    height=-1,
    duration=60,
    offset=1,
    startTime=120) "Ramp signal for damper position"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));

equation
  connect(sou.ports[1], mov1.port_a)
    annotation (Line(points={{-80,-1.33333},{-80,40},{-40,40}},
                                                         color={0,127,255}));
  connect(mov1.port_b, masFloRat.port_a)
    annotation (Line(points={{-20,40},{0,40}}, color={0,127,255}));
  connect(relPre.port_a, mov1.port_b) annotation (Line(
      points={{-20,10},{-16,10},{-16,40},{-20,40}},
      color={0,127,255},
      pattern=LinePattern.Dot));
  connect(relPre.port_b, mov1.port_a) annotation (Line(
      points={{-40,10},{-44,10},{-44,40},{-40,40}},
      color={0,127,255},
      pattern=LinePattern.Dot));
  connect(ramSpe.y, mov1.y)
    annotation (Line(points={{-59,80},{-30,80},{-30,52}}, color={0,0,127}));
  connect(sou.ports[2], mov2.port_a)
    annotation (Line(points={{-80,0},{-80,-30},{-40,-30}}, color={0,127,255}));
  connect(sou.ports[3], mov3.port_a) annotation (Line(points={{-80,1.33333},{-78,
          1.33333},{-78,0},{-80,0},{-80,-70},{-40,-70}}, color={0,127,255}));
  connect(masFloRat.port_b, damExp1.port_a)
    annotation (Line(points={{20,40},{40,40}}, color={0,127,255}));
  connect(damExp1.port_b, sin.ports[1]) annotation (Line(points={{60,40},{80,40},
          {80,-1.33333}},color={0,127,255}));
  connect(ramDam.y, damExp1.y)
    annotation (Line(points={{21,80},{50,80},{50,52}}, color={0,0,127}));
  connect(mov2.port_b, damExp2.port_a)
    annotation (Line(points={{-20,-30},{40,-30}}, color={0,127,255}));
  connect(damExp2.port_b, sin.ports[2])
    annotation (Line(points={{60,-30},{80,-30},{80,0}}, color={0,127,255}));
  connect(mov3.port_b, damExp3.port_a)
    annotation (Line(points={{-20,-70},{40,-70}}, color={0,127,255}));
  connect(damExp3.port_b, sin.ports[3]) annotation (Line(points={{60,-70},{80,-70},
          {80,1.33333}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ComparePower;
