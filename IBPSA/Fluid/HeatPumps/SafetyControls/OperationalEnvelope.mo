within IBPSA.Fluid.HeatPumps.SafetyControls;
block OperationalEnvelope
  "Block which computes an error if the current 
  values are outside of the given operatinal envelope"
  extends BaseClasses.PartialSafetyControlWithErrors;
  extends BaseClasses.BoundaryMapIcon(final icoMin=-70, final icoMax=70);

  parameter Modelica.Units.SI.TemperatureDifference dTHyst=5
    "Temperature deadband in the operational envelope"
    annotation (Dialog(
      tab="Safety Control",
      group="Operational Envelope",
      enable=use_opeEnv));
    Modelica.Blocks.Math.UnitConversions.To_degC toDegCTConOutMea
    "Boundary map takes degC as input"
    annotation (
      extent=[-88,38; -76,50],
      Placement(transformation(extent={{-100,40},{-80,60}})));
  Modelica.Blocks.Math.UnitConversions.To_degC toDegCTEvaInMea
    "Boundary map takes degC as input"
  annotation (
      extent=[-88,38; -76,50],
      Placement(transformation(extent={{-100,80},{-80,
            100}})));
  BaseClasses.BoundaryMap bouMap(
    final tabUpp=tabUpp,
    final use_opeEnvFroRec=use_opeEnvFroRec,
    final datTab=datTab,
    final dx=dTHyst)               "Operational boundary map"
    annotation (Placement(transformation(extent={{-62,38},{2,102}})));

equation
  connect(ySet,swiErr.u1)  annotation (Line(points={{-136,20},{66,20},{66,8},{
          78,8}}, color={0,0,127}));

  connect(sigBus.TEvaInMea, toDegCTEvaInMea.u) annotation (Line(
      points={{-125,-71},{-108,-71},{-108,90},{-102,90}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(bouMap.x, toDegCTEvaInMea.y) annotation (Line(points={{-66.48,89.2},
    {-66.48, 90},{-79,90}}, color={0,0,127}));
  connect(bouMap.y, toDegCTConOutMea.y) annotation (Line(points={{-66.48,50.8},
    {-72.74,50.8},{-72.74,50},{-79,50}}, color={0,0,127}));
  connect(sigBus.TConOutMea, toDegCTConOutMea.u) annotation (Line(
      points={{-125,-71},{-102,-71},{-102,50}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(bouMap.noErr, booPasThr.u) annotation (Line(
      points={{5.2,70},{24,70},{24,0},{38,0}},
      color={255,0,255}));
  annotation (Diagram(coordinateSystem(extent={{-120,-120},{120,120}})),
    Documentation(revisions="<html><ul>
  <li>
    <i>November 26, 2018</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>", info="<html>
<p>
  Model for checking if the given condenser return temperature and
  evaporator inlet temperature are in the given boundaries. If not, the
  heat pump will switch off.
</p>
</html>"));
end OperationalEnvelope;
