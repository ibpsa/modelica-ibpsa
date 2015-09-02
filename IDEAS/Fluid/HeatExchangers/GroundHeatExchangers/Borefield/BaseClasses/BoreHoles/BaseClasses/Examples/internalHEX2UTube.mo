within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.BoreHoles.BaseClasses.Examples;
model internalHEX2UTube
  "Comparison of the effective borehole thermal resistance from the thermal network of Bauer et al. with the resistance calculated by doubleUTubeResistances (ref)"

  extends Modelica.Icons.Example;
  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  InternalHEX2UTube intHex(
    redeclare package Medium = Medium,
    m1_flow_nominal=intHex.gen.m_flow_nominal_bh,
    m2_flow_nominal=intHex.gen.m_flow_nominal_bh,
    dp1_nominal=10,
    dp2_nominal=10,
    m3_flow_nominal=intHex.gen.m_flow_nominal_bh,
    m4_flow_nominal=intHex.gen.m_flow_nominal_bh,
    dp3_nominal=10,
    dp4_nominal=10,
    soi=IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.SoilData.SoilTrt(),
    fil=IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.FillingData.FillingTrt(),
    gen=IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.GeneralData.GeneralTrt2(),
    dynFil=true,
    T_start=285.15)
    annotation (Placement(transformation(extent={{-10,-12},{10,10}})));
  Modelica.Thermal.HeatTransfer.Celsius.FixedTemperature fixedTemperature(T=12)
    annotation (Placement(transformation(extent={{-22,30},{-2,50}})));
  Sources.MassFlowSource_T boundary(nPorts=2,
    redeclare package Medium = Medium,
    m_flow=intHex.gen.m_flow_nominal_bh,
    T=293.15)
    annotation (Placement(transformation(extent={{-48,0},{-28,20}})));
  Sources.MassFlowSource_T boundary1(nPorts=2,
    redeclare package Medium = Medium,
    m_flow=intHex.gen.m_flow_nominal_bh,
    T=288.15)
    annotation (Placement(transformation(extent={{54,4},{34,-16}})));
  Sources.FixedBoundary bou(nPorts=4, redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-60,-14},{-40,-34}})));
  Real Rb_sim = ((senTem.T + senTem1.T + senTem2.T + senTem3.T)/4 - intHex.port.T)/max(-intHex.port.Q_flow / intHex.gen.hSeg,1);
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTem(redeclare package Medium =
        Medium, m_flow_nominal=intHex.gen.m_flow_nominal_bh)
    annotation (Placement(transformation(extent={{16,2},{28,14}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTem1(redeclare package Medium =
        Medium, m_flow_nominal=intHex.gen.m_flow_nominal_bh)
    annotation (Placement(transformation(extent={{-24,-12},{-36,0}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=Rb_sim)
    annotation (Placement(transformation(extent={{-10,-58},{10,-38}})));
  Modelica.Blocks.Sources.Constant Rb_ref(k=0.0677701)
    annotation (Placement(transformation(extent={{-10,-80},{10,-60}})));
  Modelica.Blocks.Math.Add error(k2=-1)
    annotation (Placement(transformation(extent={{22,-70},{42,-50}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTem2(redeclare package Medium =
        Medium, m_flow_nominal=intHex.gen.m_flow_nominal_bh)
    annotation (Placement(transformation(extent={{-14,-22},{-26,-10}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTem3(
                                                redeclare package Medium =
        Medium, m_flow_nominal=intHex.gen.m_flow_nominal_bh)
    annotation (Placement(transformation(extent={{16,-22},{28,-10}})));
equation

  connect(fixedTemperature.port, intHex.port)
    annotation (Line(points={{-2,40},{0,40},{0,10}}, color={191,0,0}));
  connect(boundary.ports[1], intHex.port_a1)
    annotation (Line(points={{-28,12},{-10,12},{-10,8}},
                                                       color={0,127,255}));
  connect(bou.ports[1], senTem.port_b) annotation (Line(points={{-40,-27},{70,-27},
          {70,8},{28,8}}, color={0,127,255}));
  connect(senTem.port_a, intHex.port_b1)
    annotation (Line(points={{16,8},{10,8}},        color={0,127,255}));
  connect(realExpression.y, error.u1) annotation (Line(points={{11,-48},{14,-48},
          {14,-54},{20,-54}}, color={0,0,127}));
  connect(Rb_ref.y, error.u2) annotation (Line(points={{11,-70},{14,-70},{14,-66},
          {20,-66}}, color={0,0,127}));

  connect(boundary.ports[2], intHex.port_a3) annotation (Line(points={{-28,8},{-22,
          8},{-14,8},{-14,-3.2},{-10,-3.2}}, color={0,127,255}));
  connect(boundary1.ports[1], intHex.port_a4)
    annotation (Line(points={{34,-8},{22,-8},{10,-8}}, color={0,127,255}));
  connect(boundary1.ports[2], intHex.port_a2) annotation (Line(points={{34,-4},{
          30,-4},{30,3},{10,3}}, color={0,127,255}));
  connect(intHex.port_b2, senTem1.port_a) annotation (Line(points={{-10,3},{-16,
          3},{-16,2},{-20,2},{-20,-6},{-24,-6}}, color={0,127,255}));
  connect(senTem1.port_b, bou.ports[2])
    annotation (Line(points={{-36,-6},{-40,-6},{-40,-25}}, color={0,127,255}));
  connect(intHex.port_b4, senTem2.port_a) annotation (Line(points={{-10,-8.5},{-12,
          -8.5},{-12,-8},{-14,-8},{-14,-16}}, color={0,127,255}));
  connect(senTem2.port_b, bou.ports[3]) annotation (Line(points={{-26,-16},{-34,
          -16},{-34,-23},{-40,-23}}, color={0,127,255}));
  connect(intHex.port_b3, senTem3.port_a) annotation (Line(points={{10,-3.1},{12,
          -3.1},{12,-4},{16,-4},{16,-16}}, color={0,127,255}));
  connect(senTem3.port_b, bou.ports[4]) annotation (Line(points={{28,-16},{32,-16},
          {32,-21},{-40,-21}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})));
end internalHEX2UTube;
