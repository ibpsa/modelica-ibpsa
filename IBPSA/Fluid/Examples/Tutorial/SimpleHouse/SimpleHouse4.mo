within IBPSA.Fluid.Examples.Tutorial.SimpleHouse;
model SimpleHouse4 "Heating model"
  extends SimpleHouse3;

  parameter Modelica.Units.SI.HeatFlowRate QHea_nominal=3000
    "Nominal capacity of heating system";
  parameter Modelica.Units.SI.MassFlowRate mWat_flow_nominal=0.1
    "Nominal mass flow rate for water loop";
  parameter Boolean constantSourceHeater=true
    "To enable/disable the connection between the constant source and heater";

  HeatExchangers.Radiators.RadiatorEN442_2 rad(
    redeclare package Medium = MediumWater,
    T_a_nominal=333.15,
    T_b_nominal=313.15,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal=false,
    Q_flow_nominal=3000)                          "Radiator"
    annotation (Placement(transformation(extent={{110,-110},{130,-90}})));
  HeatExchangers.HeaterCooler_u heaWat(
    redeclare package Medium = MediumWater,
    m_flow_nominal=mWat_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=false,
    dp_nominal=5000,
    Q_flow_nominal=QHea_nominal) "Heater for water circuit"
    annotation (Placement(transformation(extent={{60,-110},{80,-90}})));
  Movers.FlowControlled_m_flow pump(
    redeclare package Medium = MediumWater,
    use_inputFilter=false,
    m_flow_nominal=mWat_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=false,
    nominalValuesDefineDefaultPressureCurve=true,
    inputType=IBPSA.Fluid.Types.InputType.Constant)
                                         "Pump"
    annotation (Placement(transformation(extent={{110,-180},{90,-160}})));
  Sources.Boundary_pT bouWat(redeclare package Medium = MediumWater, nPorts=1)
    "Pressure bound for water circuit" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={10,-170})));
  Modelica.Blocks.Sources.Constant const(k=1)
    annotation (Placement(transformation(extent={{80,-80},{60,-60}})));
equation
  connect(heaWat.port_b,rad. port_a) annotation (Line(points={{80,-100},{110,-100}},
                       color={0,127,255}));
  connect(rad.port_b,pump. port_a) annotation (Line(points={{130,-100},{148,-100},
          {148,-170},{110,-170}},color={0,127,255}));
  connect(heaWat.port_a,pump. port_b) annotation (Line(points={{60,-100},{49.75,
          -100},{49.75,-170},{90,-170}},  color={0,127,255}));
  connect(rad.heatPortCon, zone.heatPort) annotation (Line(points={{118,-92.8},
          {118,140},{110,140}},color={191,0,0}));
  connect(rad.heatPortRad, walCap.port) annotation (Line(points={{122,-92.8},{122,
          -30},{132,-30},{132,1.77636e-15},{140,1.77636e-15}}, color={191,0,0}));
  if constantSourceHeater then
    connect(const.y, heaWat.u) annotation (Line(points={{59,-70},{50,-70},{50,-94},
          {58,-94}}, color={0,0,127}));
  end if;
  connect(bouWat.ports[1], pump.port_b)
    annotation (Line(points={{20,-170},{90,-170}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-240,
            -220},{200,200}})),
    experiment(StopTime=1e+06),
    Documentation(revisions="<html>
<ul>
<li>
September 4, 2023, by Jelger Jansen:<br/>
First implementation.
</li>
</ul>
</html>"));
end SimpleHouse4;
