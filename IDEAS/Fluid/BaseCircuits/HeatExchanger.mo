within IDEAS.Fluid.BaseCircuits;
model HeatExchanger
  //Extensions
  extends Interfaces.Circuit;
  extends IDEAS.Fluid.Interfaces.FourPortFlowResistanceParameters;

  //Parameters
  parameter Real efficiency=0.9 "Efficiency of the heat exchanger";

  //Interfaces
  Modelica.Blocks.Interfaces.RealOutput senT1
    "Temperature of the supply line on the primary side" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,106}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-54,106})));
  Modelica.Blocks.Interfaces.RealOutput senMassFlow1
    "Massflow at the primary side" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-82,106}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-82,106})));
  Modelica.Blocks.Interfaces.RealOutput senMassFlow2
    "Massflow at the secondary side" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={80,106}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={78,106})));
  Modelica.Blocks.Interfaces.RealOutput senT2
    "Temperature of the supply line on the secondary side" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,106}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={48,106})));

  //Components
  IDEAS.Fluid.HeatExchangers.ConstantEffectiveness hex(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    m1_flow_nominal=m_flow_nominal,
    m2_flow_nominal=m_flow_nominal,
    eps=efficiency,
    dp1_nominal=dp1_nominal,
    from_dp1=from_dp1,
    linearizeFlowResistance1=linearizeFlowResistance1,
    allowFlowReversal1=allowFlowReversal1,
    deltaM1=deltaM1,
    dp2_nominal=dp2_nominal,
    from_dp2=from_dp2,
    linearizeFlowResistance2=linearizeFlowResistance2,
    allowFlowReversal2=allowFlowReversal2,
    deltaM2=deltaM2) annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={0,0})));

  IDEAS.Fluid.Sensors.MassFlowRate senMasFlo2(
    redeclare package Medium=Medium) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={60,34})));

  IDEAS.Fluid.Sensors.TemperatureTwoPort senTem1(
    redeclare package Medium =Medium,
    m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-36,0},{-16,20}})));

  IDEAS.Fluid.Sensors.TemperatureTwoPort senTem2(
    redeclare package Medium=Medium,
    m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{18,24},{38,44}})));

  IDEAS.Fluid.Sensors.MassFlowRate senMasFlo1(
    redeclare package Medium=Medium) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-70,32})));

equation
  connect(senMasFlo2.port_b, port_b1) annotation (Line(
      points={{70,34},{74,34},{74,60},{100,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTem1.T, senT1) annotation (Line(
      points={{-26,21},{-26,52},{-40,52},{-40,106}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senTem1.port_b, hex.port_a1) annotation (Line(
      points={{-16,10},{-6,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senMasFlo2.m_flow, senMassFlow2) annotation (Line(
      points={{60,45},{60,80},{80,80},{80,106}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hex.port_b2, senTem2.port_a) annotation (Line(
      points={{6,10},{6,34},{18,34}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTem2.port_b, senMasFlo2.port_a) annotation (Line(
      points={{38,34},{50,34}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTem2.T, senT2) annotation (Line(
      points={{28,45},{28,80},{40,80},{40,106}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senMasFlo1.m_flow, senMassFlow1) annotation (Line(
      points={{-70,43},{-70,80},{-82,80},{-82,106}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senTem1.port_a, senMasFlo1.port_b) annotation (Line(
      points={{-36,10},{-80,10},{-80,32}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_b2, hex.port_b1) annotation (Line(
      points={{-100,-60},{-6,-60},{-6,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senT1, senT1) annotation (Line(
      points={{-40,106},{-40,102},{-40,102},{-40,106}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pipeSupply.port_b, senMasFlo1.port_a) annotation (Line(
      points={{-60,60},{-52,60},{-52,32},{-60,32}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hex.port_a2, pipeReturn.port_b) annotation (Line(
      points={{6,-10},{6,-60},{60,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Documentation(info="<html><p>
  This model is the base circuit implementation of heat exchanger in a pressurized circuit. An heat exchanger can disconnect two hydraulic circuits in wich the flow needs to be controlled.</p></html>"),Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
          Rectangle(
          extent={{-42,76},{44,-76}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Line(
          points={{-42,76},{44,-76}},
          color={0,0,0},
          smooth=Smooth.None),
        Polygon(
          points={{-42,76},{-42,-76},{44,-76},{-42,76}},
          lineColor={0,0,127},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Forward),
        Line(
          points={{78,100},{84,80},{82,60}},
          color={255,0,0},
          smooth=Smooth.None),
        Ellipse(
          extent={{80,62},{84,58}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{48,100},{54,80},{52,60}},
          color={255,0,0},
          smooth=Smooth.None),
        Ellipse(
          extent={{50,62},{54,58}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-54,100},{-48,80},{-50,60}},
          color={255,0,0},
          smooth=Smooth.None),
        Ellipse(
          extent={{-52,62},{-48,58}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-82,100},{-76,80},{-78,60}},
          color={255,0,0},
          smooth=Smooth.None),
        Ellipse(
          extent={{-80,62},{-76,58}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid)}));
end HeatExchanger;
