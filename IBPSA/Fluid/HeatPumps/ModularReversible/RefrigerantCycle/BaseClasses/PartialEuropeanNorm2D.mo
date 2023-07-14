within IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses;
partial model PartialEuropeanNorm2D
  "Partial model with components for EuropeanNorm2D approach for heat pumps and chillers"
  parameter Modelica.Blocks.Types.Smoothness smoothness=
    Modelica.Blocks.Types.Smoothness.LinearSegments
    "Smoothness of table interpolation";
  parameter Modelica.Blocks.Types.Extrapolation extrapolation=
    Modelica.Blocks.Types.Extrapolation.LastTwoPoints
    "Extrapolation of data outside the definition range";
  parameter Boolean use_evaOut
    "=true to use evaporator outlet temperature, false for inlet";
  parameter Boolean use_conOut
    "=true to use condenser outlet temperature, false for inlet";
  Modelica.Blocks.Math.UnitConversions.To_degC TEvaToDegC
    "Table input is in degC"       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-40,60})));
  Modelica.Blocks.Math.UnitConversions.To_degC TConToDegC
    "Table input is in degC"      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,60})));
  Modelica.Blocks.Tables.CombiTable2Ds tabPEle(
    final tableOnFile=false,
    final tableName="NoName",
    final fileName="NoName",
    final verboseRead=true,
    final smoothness=smoothness,
    final u1(unit="degC"),
    final u2(unit="degC"),
    final y(unit="W", displayUnit="kW"),
    final extrapolation=extrapolation) "Electrical power table" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={80,30})));
  Modelica.Blocks.Tables.CombiTable2Ds tabQUse_flow(
    final tableOnFile=false,
    final tableName="NoName",
    final fileName="NoName",
    final verboseRead=true,
    final smoothness=smoothness,
    final u1(unit="degC"),
    final u2(unit="degC"),
    final y(unit="W", displayUnit="kW"),
    final extrapolation=extrapolation) "Table for useful heat flow rate"
                                       annotation (Placement(transformation(
          extent={{-10,-10},{10,10}}, rotation=-90,
        origin={40,30})));
  Modelica.Blocks.Math.Product ySetTimScaFac
    "Create the product of the scaling factor and relative compressor speed"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-70,36})));


  Modelica.Blocks.Math.Product scaFacTimPel "Scale electrical power"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,0})));
  Modelica.Blocks.Math.Product scaFacTimQUse_flow "Scale useful heat flow rate"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,0})));
  Modelica.Blocks.Sources.Constant constScaFac
    "Calculates correction of table output based on scaling factor"
    annotation (Placement(
        transformation(extent={{-10,-10},{10,10}}, rotation=270,
        origin={-80,70})));


  Modelica.Blocks.Routing.RealPassThrough reaPasThrTEvaIn if not use_evaOut
    "Used to enable conditional bus connection" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-50,90})));
  Modelica.Blocks.Routing.RealPassThrough reaPasThrTConIn if not use_conOut
    "Used to enable conditional bus connection" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={40,90})));
  Modelica.Blocks.Routing.RealPassThrough reaPasThrTEvaOut if use_evaOut
    "Used to enable conditional bus connection" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-20,90})));
  Modelica.Blocks.Routing.RealPassThrough reaPasThrTConOut if use_conOut
    "Used to enable conditional bus connection" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={70,90})));
protected
  parameter Real perDevMasFloCon
    "Deviation of nominal mass flow rate at condenser in percent";
  parameter Real perDevMasFloEva
    "Deviation of nominal mass flow rate at evaporator in percent";
  parameter Modelica.Blocks.Types.ExternalCombiTable2D tabIdeQUse_flow=
      Modelica.Blocks.Types.ExternalCombiTable2D(
      "NoName",
      "NoName",
      tabQUse_flow.table,
      smoothness,
      extrapolation,
      false) "External table object for nominal usefule side conditions";
  parameter Modelica.Blocks.Types.ExternalCombiTable2D tabIdePEle=
      Modelica.Blocks.Types.ExternalCombiTable2D(
      "NoName",
      "NoName",
      tabPEle.table,
      smoothness,
      extrapolation,
      false) "External table object for nominal electrical power";
initial algorithm
  assert(perDevMasFloCon < 1,
      "The deviation of the given mCon_flow_nominal to the table data is " +
      String(perDevMasFloCon) + " %. Carefully check results,
      you are extrapolating the table data!",
    AssertionLevel.warning);
  assert(perDevMasFloEva < 1,
    "The deviation of the given mEva_flow_nominal to the table data is " +
      String(perDevMasFloEva) + " %. Carefully check results,
      you are extrapolating the table data!",
    AssertionLevel.warning);


equation
  connect(TConToDegC.y,tabQUse_flow. u1) annotation (Line(points={{60,49},{60,42},
          {46,42}},         color={0,0,127}));
  connect(TEvaToDegC.y,tabQUse_flow. u2) annotation (Line(points={{-40,49},{-40,
          48},{34,48},{34,42}}, color={0,0,127}));
  connect(TEvaToDegC.y,tabPEle. u2) annotation (Line(points={{-40,49},{-40,48},{
          74,48},{74,42}}, color={0,0,127}));
  connect(TConToDegC.y,tabPEle. u1) annotation (Line(points={{60,49},{60,48},{86,
          48},{86,42}},                 color={0,0,127}));
  connect(constScaFac.y, ySetTimScaFac.u2)
    annotation (Line(points={{-80,59},{-80,48},{-76,48}}, color={0,0,127}));
  connect(scaFacTimPel.u2, ySetTimScaFac.y) annotation (Line(points={{-46,12},{-46,
          18},{-70,18},{-70,25}}, color={0,0,127}));
  connect(tabQUse_flow.y, scaFacTimQUse_flow.u1) annotation (Line(points={{40,19},
          {42,19},{42,12},{46,12}}, color={0,0,127}));
  connect(scaFacTimQUse_flow.u2, ySetTimScaFac.y) annotation (Line(points={{34,12},
          {34,18},{-70,18},{-70,25}}, color={0,0,127}));
  connect(tabPEle.y, scaFacTimPel.u1) annotation (Line(points={{80,19},{80,18},{
          -34,18},{-34,12}}, color={0,0,127}));
  connect(reaPasThrTConOut.y, TConToDegC.u) annotation (Line(points={{70,79},{70,
          76},{60,76},{60,72}}, color={0,0,127}));
  connect(TConToDegC.u, reaPasThrTConIn.y) annotation (Line(points={{60,72},{60,
          76},{40,76},{40,79}}, color={0,0,127}));
  connect(reaPasThrTEvaOut.y, TEvaToDegC.u) annotation (Line(points={{-20,79},{-20,
          76},{-40,76},{-40,72}}, color={0,0,127}));
  connect(reaPasThrTEvaIn.y, TEvaToDegC.u) annotation (Line(points={{-50,79},{-50,
          76},{-40,76},{-40,72}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
  Partial model for equations and componenents used in both heat pump
  and chiller models using european norm data in two dimensions.
</p>
</html>", revisions="<html>
<ul><li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li></ul>
</html>"));
end PartialEuropeanNorm2D;
