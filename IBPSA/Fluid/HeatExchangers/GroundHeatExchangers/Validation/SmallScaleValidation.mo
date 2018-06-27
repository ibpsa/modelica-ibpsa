within IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Validation;
model SmallScaleValidation
  extends Modelica.Icons.Example;
  package Medium = IBPSA.Media.Water;

  parameter Modelica.SIunits.Temperature T_start = 273.15 + 23;

  parameter Modelica.SIunits.ThermalResistance R1 = 3.86
    "First resistance in resistance-capacitance model of measurement apparatus";
  parameter Modelica.SIunits.ThermalResistance R2 = 27.8
    "Second resistance in resistance-capacitance model of measurement apparatus";
  parameter Modelica.SIunits.HeatCapacity C = 325
    "Capacitance in resistance-capacitance model of measurement apparatus";
  BorefieldOneUTube borHol(redeclare package Medium = Medium, borFieDat=
        borFieDat,
    tLoaAgg=5,
    TMedGro=T_start)       "Borehole"
    annotation (Placement(transformation(extent={{-12,-76},{14,-44}})));

  IBPSA.Fluid.Movers.FlowControlled_m_flow
                                        pum(
    redeclare package Medium = Medium,
    m_flow_nominal=borFieDat.conDat.mBor_flow_nominal,
    T_start=T_start,
    addPowerToMedium=false,
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    annotation (Placement(transformation(extent={{-20,90},{-40,70}})));
  Sensors.TemperatureTwoPort TBorFieIn(redeclare package Medium = Medium,
      m_flow_nominal=borFieDat.conDat.mBorFie_flow_nominal,
    T_start=T_start)
    "Inlet temperature of the borefield"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Sensors.TemperatureTwoPort TBorFieOut(redeclare package Medium = Medium,
      m_flow_nominal=borFieDat.conDat.mBorFie_flow_nominal,
    T_start=T_start) "Outlet temperature of the borefield"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  IBPSA.Fluid.HeatExchangers.GroundHeatExchangers.Data.BorefieldData.SmallScale_validation borFieDat "Borefield data"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  IBPSA.Fluid.Sources.Boundary_ph sin(redeclare package Medium =
        Medium, nPorts=1) "Sink"
    annotation (Placement(transformation(extent={{88,50},{68,70}})));
  Modelica.Blocks.Sources.Constant mFlo(k=borFieDat.conDat.mBor_flow_nominal)
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Modelica.Blocks.Sources.Constant TSoi(k=T_start)
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
  IBPSA.Fluid.HeatExchangers.HeaterCooler_u hea(
    redeclare package Medium = Medium,
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=borFieDat.conDat.mBor_flow_nominal,
    m_flow(start=borFieDat.conDat.mBor_flow_nominal),
    T_start=T_start,
    dp_nominal=10,
    Q_flow_nominal=1,
    p_start=100000)
    annotation (Placement(transformation(extent={{20,90},{0,70}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=10.06)
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Sensors.TemperatureTwoPort TMeaIn(
    redeclare package Medium = Medium,
    m_flow_nominal=borFieDat.conDat.mBorFie_flow_nominal,
    T_start=T_start)
    "Inlet temperature of the measurement apparatus" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,34})));
  Sensors.TemperatureTwoPort TMeaOut(
    redeclare package Medium = Medium,
    m_flow_nominal=borFieDat.conDat.mBorFie_flow_nominal,
    T_start=T_start)
    "Outlet temperature of the measurment apparatus" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,34})));
  MixingVolumes.MixingVolume vol(redeclare package Medium = Medium, nPorts=2,
    m_flow_nominal=borFieDat.conDat.mBor_flow_nominal,
    V=8.2e-6)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-50,0})));
  MixingVolumes.MixingVolume vol1(redeclare package Medium = Medium, nPorts=2,
    m_flow_nominal=borFieDat.conDat.mBor_flow_nominal,
    V=8.2e-6)
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={50,0})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor thermalResistor(R=R1/2)
    annotation (Placement(transformation(extent={{10,0},{30,20}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor thermalResistor1(R=R1/2)
    annotation (Placement(transformation(extent={{-30,0},{-10,20}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor thermalResistor2(R=R2)
    annotation (Placement(transformation(extent={{-30,-30},{-10,-10}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heatCapacitor(C=C,
      der_T(fixed=true))
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={10,-20})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature
    annotation (Placement(transformation(extent={{-88,-30},{-68,-10}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=T_start)
    annotation (Placement(transformation(extent={{-124,-30},{-104,-10}})));
equation
  connect(TBorFieIn.port_b, borHol.port_a)
    annotation (Line(points={{-40,-60},{-12,-60}}, color={0,127,255}));
  connect(borHol.port_b, TBorFieOut.port_a)
    annotation (Line(points={{14,-60},{40,-60}},          color={0,127,255}));
  connect(mFlo.y, pum.m_flow_in)
    annotation (Line(points={{-79,60},{-30,60},{-30,68}}, color={0,0,127}));
  connect(TSoi.y, borHol.TSoi) annotation (Line(points={{-39,-90},{-32,-90},{
          -32,-50.4},{-14.6,-50.4}}, color={0,0,127}));
  connect(hea.port_b, pum.port_a)
    annotation (Line(points={{0,80},{-20,80}},         color={0,127,255}));
  connect(realExpression.y, hea.u) annotation (Line(points={{21,60},{40,60},{40,
          74},{22,74}},    color={0,0,127}));
  connect(TMeaOut.port_b, vol1.ports[1])
    annotation (Line(points={{60,24},{60,2}}, color={0,127,255}));
  connect(vol1.ports[2], TBorFieOut.port_b) annotation (Line(points={{60,-2},{60,
          -2},{60,-60}},          color={0,127,255}));
  connect(TMeaIn.port_a, vol.ports[1])
    annotation (Line(points={{-60,24},{-60,2}}, color={0,127,255}));
  connect(vol.ports[2], TBorFieIn.port_a)
    annotation (Line(points={{-60,-2},{-60,-2},{-60,-60}}, color={0,127,255}));
  connect(TMeaIn.port_b, pum.port_b) annotation (Line(points={{-60,44},{-60,44},
          {-60,80},{-40,80}}, color={0,127,255}));
  connect(thermalResistor.port_b, vol1.heatPort)
    annotation (Line(points={{30,10},{40,10},{50,10}}, color={191,0,0}));
  connect(thermalResistor.port_a, thermalResistor1.port_b)
    annotation (Line(points={{10,10},{-10,10}}, color={191,0,0}));
  connect(thermalResistor1.port_b, heatCapacitor.port) annotation (Line(points={
          {-10,10},{0,10},{0,-20},{1.77636e-015,-20}}, color={191,0,0}));
  connect(heatCapacitor.port, thermalResistor2.port_b)
    annotation (Line(points={{0,-20},{-4,-20},{-10,-20}}, color={191,0,0}));
  connect(thermalResistor1.port_a, vol.heatPort)
    annotation (Line(points={{-30,10},{-42,10},{-50,10}}, color={191,0,0}));
  connect(prescribedTemperature.port, thermalResistor2.port_a)
    annotation (Line(points={{-68,-20},{-68,-20},{-30,-20}}, color={191,0,0}));
  connect(realExpression1.y, prescribedTemperature.T)
    annotation (Line(points={{-103,-20},{-90,-20}}, color={0,0,127}));
  connect(hea.port_a, TMeaOut.port_a)
    annotation (Line(points={{20,80},{60,80},{60,44}}, color={0,127,255}));
  connect(TMeaOut.port_a, sin.ports[1]) annotation (Line(points={{60,44},{60,44},
          {60,60},{68,60}}, color={0,127,255}));
  annotation (__Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/HeatExchangers/GroundHeatExchangers/Validation/SandboxValidation.mos"
        "Simulate and Plot"), Diagram(graphics={Rectangle(
          extent={{-64,24},{64,-40}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid), Text(
          extent={{-34,-40},{36,-34}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Heat losses through measurement apparatus",
          textStyle={TextStyle.Bold})}));
end SmallScaleValidation;
