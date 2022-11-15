within IBPSA.Fluid.HeatPumps.Validation.BaseClasses;
partial model PartialHeatPumpValidation
  "Validation base case for the reversible heat pump model."
 extends Modelica.Icons.Example;

  replaceable package MediumSin = IBPSA.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
      "Medium of sink side"
      annotation (choicesAllMatching=true);
  replaceable package MediumSou = IBPSA.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
      "Medium of source side"
      annotation (choicesAllMatching=true);
  IBPSA.Fluid.Sources.MassFlowSource_T souSidMassFlowSou(
    use_m_flow_in=true,
    use_T_in=true,
    m_flow=1,
    nPorts=1,
    redeclare final package Medium = MediumSou,
    T=275.15) "Ideal mass flow source at the inlet of the source side"
    annotation (Placement(transformation(extent={{-40,-62},{-20,-42}})));

  IBPSA.Fluid.Sources.Boundary_pT souSidFixedBou(nPorts=1, redeclare package
      Medium = MediumSou) "Fixed boundary at the outlet of the source side"
    annotation (Placement(transformation(
        extent={{-11,11},{11,-11}},
        rotation=0,
        origin={-31,11})));
  IBPSA.Fluid.HeatPumps.ModularReversible heaPum(
    redeclare final package MediumCon = MediumSin,
    redeclare final package MediumEva = MediumSou,
    QUse_flow_nominal=heaPum.vapComCyc.blaBoxHeaPumHea.QUseBlaBox_flow_nominal,

    y_nominal=1,
    final use_safetyControl=false,
    final use_busConnectorOnly=false,
    final use_TSet=false,
    TCon_nominal=303.15,
    dTCon_nominal=5,
    CCon=0,
    GConOut=0,
    GConIns=0,
    TEva_nominal=290.15,
    dTEva_nominal=5,
    mEva_flow_nominal=0.8,
    dpEva_nominal=0,
    dpCon_nominal=0,
    use_conCap=false,
    final use_rev=false,
    CEva=0,
    GEvaOut=0,
    GEvaIns=0,
    TEva_start=290.15,
    use_evaCap=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    TCon_start=303.15,
    redeclare model BlackBoxHeatPumpCooling =
        IBPSA.Fluid.Chillers.BlackBoxData.BaseClasses.NoCooling) "Heat pump"
    annotation (Placement(transformation(
        extent={{-24,-29},{24,29}},
        rotation=270,
        origin={2,-21})));

  IBPSA.Fluid.Sources.Boundary_pT sinSidFixedBou(
    redeclare final package Medium = MediumSin,
    nPorts=1) "Fixed boundary at the outlet of the sink side"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={50,-50})));
  IBPSA.Fluid.Sources.MassFlowSource_T sinSideMassFlowSou(
    use_m_flow_in=true,
    use_T_in=true,
    m_flow=1,
    nPorts=1,
    redeclare final package Medium = MediumSin,
    T=275.15) "Ideal mass flow source at the inlet of the source side"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={30,30})));

  Modelica.Blocks.Math.Gain gainmFlowEva(final k=heaPum.mEva_flow_nominal)
    "Gain to ensure mEva_flow"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Modelica.Blocks.Math.Gain gainmFlowCon(final k=heaPum.mCon_flow_nominal)
    "Gain to ensure mCon_flow"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,50})));
  Modelica.Blocks.Sources.CombiTimeTable tabMea(
    tableOnFile=true,
    tableName="MeasuredData",
    fileName=Modelica.Utilities.Files.loadResource("modelica://IBPSA/Resources/Data/Fluid/HeatPumps/Validation/MeasuredHeatPumpData.txt"),
    columns=2:10,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint)
    "Table with measurement data"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));

  Modelica.Blocks.Interfaces.RealOutput TConOutMea(unit="K", displayUnit="degC")
    "Measured condenser outlet"
    annotation (Placement(transformation(extent={{100,80},{120,100}})));
  Modelica.Blocks.Interfaces.RealOutput TEvaOutMea(unit="K", displayUnit="degC")
    "Measured evaporator outlet"
    annotation (Placement(transformation(extent={{100,0},{120,20}})));
  Modelica.Blocks.Interfaces.RealOutput PElMea(unit="W", displayUnit="kW")
    "Measured electrical power"
    annotation (Placement(transformation(extent={{100,-78},{120,-58}})));
  Modelica.Blocks.Interfaces.RealOutput PElSim(unit="W", displayUnit="kW")
    "Simulated electrical power"
    annotation (Placement(transformation(extent={{100,-102},{120,-82}})));
  Modelica.Blocks.Interfaces.RealOutput TConOutSim(unit="K", displayUnit="degC")
    "Simulated condenser outlet"
    annotation (Placement(transformation(extent={{100,60},{120,80}})));
  Modelica.Blocks.Interfaces.RealOutput TEvaOutSim(unit="K", displayUnit="degC")
    "Simulated evaporator outlet"
    annotation (Placement(transformation(extent={{100,-20},{120,0}})));
  Interfaces.VapourCompressionMachineControlBus sigBus
    "Signal bus of heat pump"
    annotation (Placement(transformation(extent={{0,50},{40,90}}),
        iconTransformation(extent={{0,50},{40,90}})));
equation

  connect(souSidMassFlowSou.ports[1], heaPum.port_a2) annotation (Line(points={{
          -20,-52},{-18,-52},{-18,-45},{-12.5,-45}}, color={0,127,255}));
  connect(heaPum.port_b2, souSidFixedBou.ports[1]) annotation (Line(points={{-12.5,
          3},{-16,3},{-16,11},{-20,11}}, color={0,127,255}));
  connect(heaPum.port_b1, sinSidFixedBou.ports[1]) annotation (Line(points={{16.5,
          -45},{16.5,-50},{40,-50}}, color={0,127,255}));
  connect(heaPum.port_a1, sinSideMassFlowSou.ports[1]) annotation (Line(points={
          {16.5,3},{16.5,12},{30,12},{30,20}}, color={0,127,255}));
  connect(gainmFlowEva.y, souSidMassFlowSou.m_flow_in)
    annotation (Line(points={{-59,-30},{-42,-30},{-42,-44}}, color={0,0,127}));
  connect(sinSideMassFlowSou.m_flow_in, gainmFlowCon.y)
    annotation (Line(points={{38,42},{38,50},{21,50}}, color={0,0,127}));
  connect(tabMea.y[5], gainmFlowEva.u) annotation (Line(points={{-79,90},{-74,90},
          {-74,26},{-88,26},{-88,-30},{-82,-30}}, color={0,0,127}));
  connect(tabMea.y[7], gainmFlowCon.u) annotation (Line(points={{-79,90},{-74,90},
          {-74,50},{-2,50}}, color={0,0,127}));
  connect(tabMea.y[6], heaPum.ySet) annotation (Line(points={{-79,90},{-74,90},{
          -74,26},{6.83333,26},{6.83333,6.84}}, color={0,0,127}));
  connect(tabMea.y[9], souSidMassFlowSou.T_in) annotation (Line(points={{-79,90},
          {-74,90},{-74,26},{-88,26},{-88,-48},{-42,-48}}, color={0,0,127}));
  connect(sinSideMassFlowSou.T_in, tabMea.y[1]) annotation (Line(points={{34,42},
          {34,66},{-74,66},{-74,90},{-79,90}}, color={0,0,127}));
  connect(tabMea.y[2], TConOutMea)
    annotation (Line(points={{-79,90},{110,90}}, color={0,0,127}));
  connect(tabMea.y[8], TEvaOutMea) annotation (Line(points={{-79,90},{92,90},{92,
          10},{110,10}}, color={0,0,127}));
  connect(tabMea.y[3], PElMea) annotation (Line(points={{-79,90},{92,90},{92,-68},
          {110,-68}}, color={0,0,127}));
  connect(heaPum.sigBus, sigBus) annotation (Line(
      points={{-7.425,2.76},{-6,2.76},{-6,44},{-8,44},{-8,70},{20,70}},
      color={255,204,51},
      thickness=0.5));
  connect(TConOutSim, sigBus.TConOutMea) annotation (Line(points={{110,70},{80,70},
          {80,70},{20,70}},     color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(TEvaOutSim, sigBus.TEvaOutMea) annotation (Line(points={{110,-10},{76,
          -10},{76,70},{20,70}},
                         color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(PElSim, sigBus.PelMea) annotation (Line(points={{110,-92},{82,-92},{
          82,70},{20,70}},           color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}})),
    experiment(Tolerance=1e-6, StopTime=3600),
    Documentation(info="<html>
    <p>Partial model for the validation of different modular heat pump approaches 
    based on measured data of a brine-to-water heat pump at the Institute for 
    Energy Efficient Building and Indoor Climate.</p>
    <p>If questions regarding the data or model 
    arises, please raise an issue and link Fabian Wuellhorst.</p>
</html>",
      revisions="<html><ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
</ul>
</html>"));
end PartialHeatPumpValidation;
