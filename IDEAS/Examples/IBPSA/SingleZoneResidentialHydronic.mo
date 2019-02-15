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
    massFlowRates={0,0.05},
    redeclare package Medium = Medium,
    m_flow_nominal=rad.m_flow_nominal,
    inputType=IDEAS.Fluid.Types.InputType.Constant,
    constantMassFlowRate=0.05)         "Hydronic pump"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));

  Fluid.Sources.Boundary_pT bou(nPorts=1,
    redeclare package Medium = Medium)
    "Absolute pressure boundary"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Modelica.Blocks.Interfaces.RealInput TSup(start=320)
    "Temperature set point of heater"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={40,120})));
  Modelica.Blocks.Interfaces.RealOutput Q
    "Thermal power use of heater"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput TZone
    "Zone operative temperature"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
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
  connect(bou.ports[1], pump.port_a)
    annotation (Line(points={{-20,-30},{0,-30},{0,-10}}, color={0,127,255}));
  connect(hea.TSet,TSup)
    annotation (Line(points={{22,38},{40,38},{40,120}}, color={0,0,127}));
  connect(hea.Q_flow, Q) annotation (Line(points={{-1,38},{0,38},{0,60},{110,60}},
        color={0,0,127}));
  connect(case900Template.TSensor, TZone) annotation (Line(points={{-59,12},{80,
          12},{80,0},{110,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=31500000,
      __Dymola_NumberOfIntervals=5000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Lsodar"),
    Documentation(info="<html>
<p>
This is a single zone hydronic system model 
for WP 1.2 of IBPSA project 1.
</p>
</html>", revisions="<html>
<ul>
<li>
January 22nd, 2019 by Filip Jorissen:<br/>
Revised implementation by adding external inputs.
</li>
<li>
May 2, 2018 by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
end SingleZoneResidentialHydronic;
