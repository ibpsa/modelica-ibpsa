within IDEAS.Examples.IBPSA;
model SingleZoneResidentialHydronic
  "Single zone residential hydronic example model"
  extends Modelica.Icons.Example;
  package Medium = IDEAS.Media.Water;
  Buildings.Validation.Cases.Case900Template case900Template
    "Case 900 BESTEST model"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  inner BoundaryConditions.SimInfoManager       sim
    "Simulation information manager for climate data"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Fluid.HeatExchangers.Radiators.RadiatorEN442_2 rad(
    redeclare package Medium = Medium,
    T_a_nominal=273.15 + 70,
    T_b_nominal=273.15 + 50,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    Q_flow_nominal=2000) "Radiator"
                             annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-30,10})));
  Fluid.HeatExchangers.Heater_T hea(redeclare package Medium = Medium,
      m_flow_nominal=pump.m_flow_nominal,
    dp_nominal=0) "Ideal heater"
    annotation (Placement(transformation(extent={{20,20},{0,40}})));
  Fluid.Movers.FlowControlled_m_flow pump(
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    use_inputFilter=false,
    inputType=IDEAS.Fluid.Types.InputType.Stages,
    massFlowRates={0,0.05},
    redeclare package Medium = Medium,
    m_flow_nominal=rad.m_flow_nominal) "Hydronic pump"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Modelica.Blocks.Math.BooleanToInteger booToInt(integerTrue=1, integerFalse=2)
    "Boolean to integer conversion"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Modelica.Blocks.Logical.Hysteresis hys(uLow=21, uHigh=23)
    "Hysteresis controller"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Modelica.Thermal.HeatTransfer.Celsius.TemperatureSensor senTem
    "Temperature sensor"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Modelica.Blocks.Sources.Constant TSet(k=273.15 + 70) "Temperature set point"
    annotation (Placement(transformation(extent={{68,20},{48,40}})));

  Fluid.Sources.Boundary_pT bou(nPorts=1, redeclare package Medium = Medium)
    "Absolute pressure boundary"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
equation
  connect(rad.heatPortCon, case900Template.gainCon) annotation (Line(points={{-37.2,
          12},{-48,12},{-48,7},{-60,7}}, color={191,0,0}));
  connect(rad.heatPortRad, case900Template.gainRad) annotation (Line(points={{-37.2,
          8},{-46,8},{-46,4},{-60,4}}, color={191,0,0}));
  connect(hea.port_b, rad.port_a)
    annotation (Line(points={{0,30},{-30,30},{-30,20}}, color={0,127,255}));
  connect(pump.port_a, rad.port_b)
    annotation (Line(points={{0,-10},{-30,-10},{-30,0}}, color={0,127,255}));
  connect(pump.port_b, hea.port_a) annotation (Line(points={{20,-10},{40,-10},{40,
          30},{20,30}}, color={0,127,255}));
  connect(hys.y, booToInt.u)
    annotation (Line(points={{21,70},{38,70}}, color={255,0,255}));
  connect(senTem.port, case900Template.gainCon) annotation (Line(points={{-40,70},
          {-56,70},{-56,7},{-60,7}}, color={191,0,0}));
  connect(senTem.T, hys.u)
    annotation (Line(points={{-20,70},{-2,70}}, color={0,0,127}));
  connect(booToInt.y, pump.stage) annotation (Line(points={{61,70},{74,70},{74,6},
          {10,6},{10,2}}, color={255,127,0}));
  connect(TSet.y, hea.TSet) annotation (Line(points={{47,30},{44,30},{44,38},{22,
          38}}, color={0,0,127}));
  connect(bou.ports[1], pump.port_a)
    annotation (Line(points={{-20,-30},{0,-30},{0,-10}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=31500000,
      __Dymola_NumberOfIntervals=5000,
      __Dymola_Algorithm="Lsodar"),
    Documentation(info="<html>
<p>
This is a single zone hydronic system model 
for WP 1.2 of IBPSA project 1.
</p>
</html>", revisions="<html>
<ul>
<li>
May 2, 2018 by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
end SingleZoneResidentialHydronic;
