within Annex60.Fluid.FixedResistances.Examples;
model ComparisonDpDh
  "Compare series connection of different FixedResistances. "
  extends Modelica.Icons.Example;

 package Medium = Annex60.Media.Air;
  Annex60.Fluid.Sources.Boundary_ph sou(
   redeclare package Medium = Medium,
    p(displayUnit="Pa") = 101335,
    use_p_in=true,
    nPorts=3)                         annotation (Placement(transformation(
          extent={{-60,90},{-40,110}})));
  Annex60.Fluid.Sources.Boundary_ph sin(
    redeclare package Medium = Medium,
    nPorts=2,
    use_p_in=false,
    p=101325)                         annotation (Placement(transformation(
          extent={{120,90},{100,110}})));

  Annex60.Fluid.Sources.Boundary_ph sin2(            redeclare package Medium
      =        Medium,
    nPorts=2,
    use_p_in=false,
    p=101325)                         annotation (Placement(transformation(
          extent={{120,50},{100,70}})));
  Annex60.Fluid.Sources.Boundary_ph sou1(            redeclare package Medium
      =        Medium,
    p(displayUnit="Pa") = 101335,
    use_p_in=true,
    nPorts=2)                         annotation (Placement(transformation(
          extent={{-58,50},{-38,70}})));
    Modelica.Blocks.Sources.Ramp P(
      duration=1,
    height=p_diff,
    offset=101325 - p_diff/2)
                 annotation (Placement(transformation(extent={{-100,90},{-80,
            110}})));
  Annex60.Fluid.Sensors.MassFlowRate senMasFlo_dpSer(redeclare package Medium
      = Medium) "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{60,90},{80,110}})));
  Annex60.Fluid.Sensors.MassFlowRate senMasFlo_dhSer(redeclare package Medium
      = Medium) "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  Annex60.Fluid.Sensors.MassFlowRate senMasFlo_dpSin(redeclare package Medium
      = Medium) "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{34,-20},{54,0}})));
  Annex60.Fluid.Sensors.MassFlowRate senMasFlo_dhSin(redeclare package Medium
      = Medium) "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{34,-60},{54,-40}})));
  Annex60.Utilities.Diagnostics.AssertEquality assertEquality_dp(threShold=1E-1)
    annotation (Placement(transformation(extent={{120,0},{140,20}})));
  Annex60.Utilities.Diagnostics.AssertEquality assertEquality_dh(threShold=1E-1)
    annotation (Placement(transformation(extent={{120,-34},{140,-14}})));
  FixedResistance_dp res_dpSer1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=500,
    deltaM=0.0057/8)
    annotation (Placement(transformation(extent={{-20,90},{0,110}})));
  FixedResistance_dp res_dpSer2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=500,
    deltaM=0.0057/8)
    annotation (Placement(transformation(extent={{20,90},{40,110}})));
  FixedResistance_dh res_dhSer1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dh=0.1,
    dp_nominal=500)
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  FixedResistance_dh res_dhSer2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dh=0.1,
    dp_nominal=500)
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  FixedResistance_dp res_dpSin(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=1000,
    deltaM=0.0057/8)
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  FixedResistance_dh res_dhSin(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dh=0.1,
    dp_nominal=1000)
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=8
    "Nominal mass flow rate";
  parameter Real p_diff=10 "Pressure difference in ramp";
equation
  connect(P.y, sou.p_in) annotation (Line(
      points={{-79,100},{-72,100},{-72,108},{-62,108}},
      color={0,0,127}));
  connect(P.y, sou1.p_in) annotation (Line(
      points={{-79,100},{-70,100},{-70,68},{-60,68}},
      color={0,0,127}));
  connect(senMasFlo_dpSer.port_b, sin.ports[1]) annotation (Line(points={{80,100},
          {90,100},{90,102},{100,102}}, color={0,127,255}));
  connect(senMasFlo_dhSer.port_b, sin2.ports[1]) annotation (Line(points={{80,60},
          {90,60},{90,62},{100,62}}, color={0,127,255}));
  connect(senMasFlo_dpSer.m_flow, assertEquality_dp.u1) annotation (Line(points=
         {{70,111},{70,122},{96,122},{96,16},{118,16}}, color={0,0,127}));
  connect(sou1.ports[1], res_dhSer1.port_a) annotation (Line(points={{-38,62},{-30,
          62},{-30,60},{-20,60}}, color={0,127,255}));
  connect(res_dhSer1.port_b, res_dhSer2.port_a)
    annotation (Line(points={{0,60},{12,60},{20,60}}, color={0,127,255}));
  connect(res_dhSer2.port_b, senMasFlo_dhSer.port_a)
    annotation (Line(points={{40,60},{50,60},{60,60}}, color={0,127,255}));
  connect(sou.ports[1], res_dpSer1.port_a) annotation (Line(points={{-40,
          102.667},{-30,100},{-20,100}},
                                color={0,127,255}));
  connect(res_dpSer1.port_b, res_dpSer2.port_a)
    annotation (Line(points={{0,100},{20,100}}, color={0,127,255}));
  connect(res_dpSer2.port_b, senMasFlo_dpSer.port_a)
    annotation (Line(points={{40,100},{66,100},{60,100}}, color={0,127,255}));
  connect(senMasFlo_dhSer.m_flow, assertEquality_dh.u1) annotation (Line(points=
         {{70,71},{70,80},{90,80},{90,-18},{118,-18}}, color={0,0,127}));
  connect(senMasFlo_dhSin.m_flow, assertEquality_dh.u2) annotation (Line(points=
         {{44,-39},{44,-30},{96,-30},{118,-30}}, color={0,0,127}));
  connect(res_dpSin.port_a, sou.ports[2]) annotation (Line(points={{-20,-10},{-32,
          -10},{-32,100},{-40,100}}, color={0,127,255}));
  connect(res_dpSin.port_b, senMasFlo_dpSin.port_a)
    annotation (Line(points={{0,-10},{34,-10}}, color={0,127,255}));
  connect(senMasFlo_dpSin.port_b, sin.ports[2]) annotation (Line(points={{54,-10},
          {86,-10},{86,98},{100,98}}, color={0,127,255}));
  connect(res_dhSin.port_a, sou1.ports[2]) annotation (Line(points={{-20,-50},{-38,
          -50},{-38,58}}, color={0,127,255}));
  connect(res_dhSin.port_b, senMasFlo_dhSin.port_a)
    annotation (Line(points={{0,-50},{34,-50}}, color={0,127,255}));
  connect(senMasFlo_dpSin.m_flow, assertEquality_dp.u2)
    annotation (Line(points={{44,1},{44,4},{118,4}}, color={0,0,127}));
  connect(senMasFlo_dhSin.port_b, sin2.ports[2])
    annotation (Line(points={{54,-50},{100,-50},{100,58}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},
            {160,160}})),
experiment(StartTime=-1, StopTime=3),
__Dymola_Commands(file="Resources/Scripts/Dymola/Fluid/FixedResistances/Examples/ComparisonDpDh.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>Example to compare behaviour of FixedResistance_dh and FixedResistance_dp. </p>
<p>The current parameters for pressure drop and nominal mass flow rate emulate a DN100 pipe of 10 m. The pressure drop at nominal mass flow rate (ca. 8 kg/s) is 100 Pa/m.</p>
</html>", revisions="<html>
<ul>
<li>July 7, 2016 by Bram van der Heijde:<br>First implementation</li>
</ul>
</html>"),
    __Dymola_experimentSetupOutput);
end ComparisonDpDh;
