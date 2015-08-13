within IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.BoreHoles.BaseClasses.Examples;
model internalHEXUTube
  "Comparison of the effective borehole thermal resistance  from the thermal network of Bauer et al. with the resistance calculated by singleUTubeResistances (ref)"
  extends Modelica.Icons.Example;
  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  InternalHEXUTube intHex(
    redeclare package Medium = Medium,
    soi=IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.SoilData.WetSand_validation(),
    fil=IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.FillingData.Bentonite_validation(),
    gen=IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.Data.GeneralData.SandBox_validation(),
    m1_flow_nominal=intHex.gen.m_flow_nominal_bh,
    m2_flow_nominal=intHex.gen.m_flow_nominal_bh,
    dp1_nominal=10,
    dp2_nominal=10,
    T_start=285.15)
    annotation (Placement(transformation(extent={{-10,-12},{10,10}})));
  Modelica.Thermal.HeatTransfer.Celsius.FixedTemperature fixedTemperature(T=12)
    annotation (Placement(transformation(extent={{-22,30},{-2,50}})));
  Sources.MassFlowSource_T boundary(nPorts=1,
    redeclare package Medium = Medium,
    m_flow=intHex.gen.m_flow_nominal_bh,
    T=293.15)
    annotation (Placement(transformation(extent={{-48,-4},{-28,16}})));
  Sources.MassFlowSource_T boundary1(nPorts=1,
    redeclare package Medium = Medium,
    m_flow=intHex.gen.m_flow_nominal_bh,
    T=293.15)
    annotation (Placement(transformation(extent={{54,4},{34,-16}})));
  Sources.FixedBoundary bou(nPorts=2, redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-48,-34},{-28,-14}})));
  Real Rb_sim = ((senTem.T + senTem1.T)/2 - intHex.port.T)/max(-intHex.port.Q_flow / intHex.gen.hSeg,1);
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTem(redeclare package Medium =
        Medium, m_flow_nominal=intHex.gen.m_flow_nominal_bh)
    annotation (Placement(transformation(extent={{16,0},{28,12}})));
  IDEAS.Fluid.Sensors.TemperatureTwoPort senTem1(redeclare package Medium =
        Medium, m_flow_nominal=intHex.gen.m_flow_nominal_bh)
    annotation (Placement(transformation(extent={{-28,-12},{-16,0}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=Rb_sim)
    annotation (Placement(transformation(extent={{-10,-58},{10,-38}})));
  Modelica.Blocks.Sources.Constant Rb_ref(k=0.229206)
    annotation (Placement(transformation(extent={{-10,-80},{10,-60}})));
  Modelica.Blocks.Math.Add error(k2=-1)
    annotation (Placement(transformation(extent={{22,-70},{42,-50}})));
equation

  connect(fixedTemperature.port, intHex.port)
    annotation (Line(points={{-2,40},{0,40},{0,10}}, color={191,0,0}));
  connect(boundary1.ports[1], intHex.port_a2)
    annotation (Line(points={{34,-6},{22,-6},{10,-6}}, color={0,127,255}));
  connect(boundary.ports[1], intHex.port_a1)
    annotation (Line(points={{-28,6},{-19,6},{-10,6}}, color={0,127,255}));
  connect(bou.ports[1], senTem.port_b) annotation (Line(points={{-28,-22},{70,-22},
          {70,6},{28,6}}, color={0,127,255}));
  connect(senTem.port_a, intHex.port_b1)
    annotation (Line(points={{16,6},{14,6},{10,6}}, color={0,127,255}));
  connect(senTem1.port_a, bou.ports[2]) annotation (Line(points={{-28,-6},{-28,-26},
          {-28,-26}}, color={0,127,255}));
  connect(senTem1.port_b, intHex.port_b2)
    annotation (Line(points={{-16,-6},{-13,-6},{-10,-6}}, color={0,127,255}));
  connect(realExpression.y, error.u1) annotation (Line(points={{11,-48},{14,-48},
          {14,-54},{20,-54}}, color={0,0,127}));
  connect(Rb_ref.y, error.u2) annotation (Line(points={{11,-70},{14,-70},{14,-66},
          {20,-66}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
    experiment(StopTime=100000),
    __Dymola_experimentSetupOutput(events=false));
end internalHEXUTube;
