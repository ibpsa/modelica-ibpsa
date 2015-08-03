within IDEAS.Fluid.BaseCircuits;
model HeatExchanger
  //Extensions
  extends Interfaces.PartialBaseCircuit(
    measureSupplyT=true,
    includePipes=true);
  extends IDEAS.Fluid.Interfaces.FourPortFlowResistanceParameters;

  //Parameters
  parameter Real efficiency=0.9 "Efficiency of the heat exchanger";

  //Interfaces
  Modelica.Blocks.Interfaces.RealOutput senT1
    "Temperature of the supply line on the primary side" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,108}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-54,106})));
  Modelica.Blocks.Interfaces.RealOutput massFlow1
    "Massflow at the primary side" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-80,108}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-80,108})));
  Modelica.Blocks.Interfaces.RealOutput massFlow2
    "Massflow on the secondary side" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,108}), iconTransformation(
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
        origin={40,20})));

  IDEAS.Fluid.Sensors.TemperatureTwoPort senTemRet1(
    redeclare package Medium =Medium,
    tau=tauTSensor,
    m_flow_nominal=m_flow_nominal)
    "Return temperature measurement of the primary side"
    annotation (Placement(transformation(extent={{-50,6},{-30,26}})));

  IDEAS.Fluid.Sensors.MassFlowRate senMasFlo1(
    redeclare package Medium=Medium) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-56,40})));

  FixedResistances.InsulatedPipe pipeSupply2(
    UA=UA,
    m=m/2,
    dp_nominal=dp,
    energyDynamics=energyDynamics,
    massDynamics=massDynamics,
    dynamicBalance=dynamicBalance,
    m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium) if includePipes
    "Supply pipe on the secondary side" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={16,20})), choicesAllMatching=true);
  FixedResistances.InsulatedPipe pipeReturn2(
    UA=UA,
    m=m/2,
    dp_nominal=dp,
    energyDynamics=energyDynamics,
    massDynamics=massDynamics,
    dynamicBalance=dynamicBalance,
    m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium) if includePipes
    "Supply pipe on the secondary side" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={28,-60})), choicesAllMatching=true);
equation
  connect(senT1, senT1) annotation (Line(
      points={{-40,108},{-40,108}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pipeSupply.port_b, senMasFlo1.port_a) annotation (Line(
      points={{-70,60},{-46,60},{-46,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senMasFlo2.port_b, senTemSup.port_a) annotation (Line(
      points={{50,20},{56,20},{56,60},{60,60}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(pipeReturn.port_a, hex.port_b1) annotation (Line(
      points={{-30,-60},{-6,-60},{-6,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senMasFlo2.port_a, pipeSupply2.port_b) annotation (Line(
      points={{30,20},{26,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hex.port_b2, pipeSupply2.port_a) annotation (Line(
      points={{6,10},{6,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hex.port_a2, pipeReturn2.port_b) annotation (Line(
      points={{6,-10},{6,-60},{18,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipeReturn2.port_a, port_a2) annotation (Line(
      points={{38,-60},{100,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipeSupply2.heatPort, heatPort) annotation (Line(
      points={{16,16},{16,-100},{0,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pipeReturn2.heatPort, heatPort) annotation (Line(
      points={{28,-64},{28,-78},{16,-78},{16,-100},{0,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(senMasFlo2.m_flow, massFlow2) annotation (Line(
      points={{40,31},{40,31},{40,108}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senMasFlo1.m_flow, massFlow1) annotation (Line(
      points={{-56,51},{-56,88},{-80,88},{-80,108}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senTemRet1.T, senT1) annotation (Line(
      points={{-40,27},{-40,108}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(senMasFlo1.port_b, senTemRet1.port_a) annotation (Line(
      points={{-66,40},{-72,40},{-72,16},{-50,16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemRet1.port_b, hex.port_a1) annotation (Line(
      points={{-30,16},{-6,16},{-6,10}},
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
