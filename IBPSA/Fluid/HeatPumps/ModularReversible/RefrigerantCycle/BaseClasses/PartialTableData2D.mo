within IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses;
partial model PartialTableData2D
  "Partial model with components for TableData2D approach for heat pumps and chillers"
  parameter Modelica.Blocks.Types.Smoothness smoothness=
    Modelica.Blocks.Types.Smoothness.LinearSegments
    "Smoothness of table interpolation";
  parameter Modelica.Blocks.Types.Extrapolation extrapolation=
    Modelica.Blocks.Types.Extrapolation.LastTwoPoints
    "Extrapolation of data outside the definition range";
  parameter Boolean use_TEvaOutForTab=true
    "=true to use evaporator outlet temperature, false for inlet";
  parameter Boolean use_TConOutForTab=true
    "=true to use condenser outlet temperature, false for inlet";
  Modelica.Blocks.Tables.CombiTable2Ds tabPEle(
    final tableOnFile=false,
    final tableName="NoName",
    final fileName="NoName",
    final verboseRead=true,
    final smoothness=smoothness,
    final u1(unit="K", displayUnit="degC"),
    final u2(unit="K", displayUnit="degC"),
    final y(unit="W", displayUnit="kW"),
    final extrapolation=extrapolation) "Electrical power consumption table" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={90,50})));
  Modelica.Blocks.Tables.CombiTable2Ds tabQUse_flow(
    final tableOnFile=false,
    final tableName="NoName",
    final fileName="NoName",
    final verboseRead=true,
    final smoothness=smoothness,
    final u1(unit="K", displayUnit="degC"),
    final u2(unit="K", displayUnit="degC"),
    final y(unit="W", displayUnit="kW"),
    final extrapolation=extrapolation) "Table for useful heat flow rate"
                                       annotation (Placement(transformation(
          extent={{-10,-10},{10,10}}, rotation=-90,
        origin={50,50})));
  Modelica.Blocks.Math.Product ySetTimScaFac
    "Create the product of the scaling factor and relative compressor speed"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-60,50})));


  Modelica.Blocks.Math.Product scaFacTimPel "Scale electrical power consumption"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,2})));
  Modelica.Blocks.Math.Product scaFacTimQUse_flow "Scale useful heat flow rate"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,2})));
  Modelica.Blocks.Sources.Constant constScaFac
    "Calculates correction of table output based on scaling factor"
    annotation (Placement(
        transformation(extent={{-10,-10},{10,10}}, rotation=0,
        origin={-90,70})));


  Modelica.Blocks.Routing.RealPassThrough reaPasThrTEvaIn if not use_TEvaOutForTab
    "Used to enable conditional bus connection" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-50,90})));
  Modelica.Blocks.Routing.RealPassThrough reaPasThrTConIn if not use_TConOutForTab
    "Used to enable conditional bus connection" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={50,90})));
  Modelica.Blocks.Routing.RealPassThrough reaPasThrTEvaOut if use_TEvaOutForTab
    "Used to enable conditional bus connection" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-10,90})));
  Modelica.Blocks.Routing.RealPassThrough reaPasThrTConOut if use_TConOutForTab
    "Used to enable conditional bus connection" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={90,90})));
protected
  parameter Real perDevMasFloCon
    "Percent of deviation of nominal mass flow rate at condenser in percent";
  parameter Real perDevMasFloEva
    "Percent of deviation of nominal mass flow rate at evaporator in percent";
  parameter Modelica.Blocks.Types.ExternalCombiTable2D tabIdeQUse_flow=
      Modelica.Blocks.Types.ExternalCombiTable2D(
      "NoName",
      "NoName",
      tabQUse_flow.table,
      smoothness,
      extrapolation,
      false) "External table object for nominal useful side conditions";
  parameter Modelica.Blocks.Types.ExternalCombiTable2D tabIdePEle=
      Modelica.Blocks.Types.ExternalCombiTable2D(
      "NoName",
      "NoName",
      tabPEle.table,
      smoothness,
      extrapolation,
      false) "External table object for nominal electrical power consumption";
initial algorithm
  assert(perDevMasFloCon < 10,
    "In " + getInstanceName() + ": The deviation of the given mCon_flow_nominal to the table data is " +
      String(perDevMasFloCon) + " %. Carefully check results,
      you are extrapolating the table data.",
    AssertionLevel.warning);
  assert(perDevMasFloEva < 10,
    "In " + getInstanceName() + ": The deviation of the given mEva_flow_nominal to the table data is " +
      String(perDevMasFloEva) + " %. Carefully check results,
      you are extrapolating the table data.",
    AssertionLevel.warning);

equation
  connect(constScaFac.y, ySetTimScaFac.u2)
    annotation (Line(points={{-79,70},{-66,70},{-66,62}}, color={0,0,127}));
  connect(scaFacTimPel.u2, ySetTimScaFac.y) annotation (Line(points={{-46,14},{
          -46,20},{-60,20},{-60,39}},
                                  color={0,0,127}));
  connect(tabQUse_flow.y, scaFacTimQUse_flow.u1) annotation (Line(points={{50,39},
          {50,32},{46,32},{46,14}}, color={0,0,127}));
  connect(scaFacTimQUse_flow.u2, ySetTimScaFac.y) annotation (Line(points={{34,14},
          {34,20},{-60,20},{-60,39}}, color={0,0,127}));
  connect(tabPEle.y, scaFacTimPel.u1) annotation (Line(points={{90,39},{90,26},{
          -34,26},{-34,14}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -120},{120,120}})),
    Documentation(info="<html>
<p>
  Partial model for equations and componenents used in both heat pump
  and chiller models using two-dimensional data.
</p>
</html>", revisions="<html>
<ul><li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li></ul>
</html>"),
    Icon(coordinateSystem(extent={{-120,-120},{120,120}})));
end PartialTableData2D;