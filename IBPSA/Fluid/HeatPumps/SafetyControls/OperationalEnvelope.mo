within IBPSA.Fluid.HeatPumps.SafetyControls;
model OperationalEnvelope
  "Model which computes an error if the current 
  values are outside of the given operatinal envelope"
  extends BaseClasses.PartialSafetyControlWithErrors;
  extends BaseClasses.BoundaryMapIcon(final icoMin=-70, final icoMax=70);
  parameter Boolean forHeaPum "=true if model is for heat pump, false for chillers";
  parameter Modelica.Units.SI.TemperatureDifference dTHyst=5
    "Temperature deadband in the operational envelope"
    annotation (Dialog(
      tab="Safety Control",
      group="Operational Envelope",
      enable=use_opeEnv));
  BaseClasses.BoundaryMap bouMap(
    final tabUpp=tabUpp,
    final use_opeEnvFroRec=use_opeEnvFroRec,
    final datTab=datTab,
    final dT=dTHyst)               "Operational boundary map"
    annotation (Placement(transformation(extent={{-62,38},{2,102}})));

equation
  connect(ySet,swiErr.u1)  annotation (Line(points={{-136,20},{66,20},{66,8},{
          78,8}}, color={0,0,127}));

  connect(bouMap.noErr, booPasThr.u) annotation (Line(
      points={{5.2,70},{24,70},{24,0},{38,0}},
      color={255,0,255}));
  connect(bouMap.TCon, sigBus.TEvaInMea) annotation (Line(points={{-66.48,82.8},
          {-112,82.8},{-112,-71},{-125,-71}},                   color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(bouMap.TEva, sigBus.TConOutMea) annotation (Line(points={{-67.12,57.2},
          {-74,57.2},{-74,56},{-102,56},{-102,-71},{-125,-71}},
                 color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Diagram(coordinateSystem(extent={{-120,-120},{120,120}})),
    Documentation(revisions="<html><ul>
  <li>
    <i>November 26, 2018</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>", info="<html>
<p>Model to check if the condenser return temperature and evaporator inlet temperature are inside the given boundaries. If not, the heat pump will switch off. </p>
<p>This safety control is mainly based on the operational envelope of the compressor. Refrigerant flowsheet and type will influence these values.</p>
</html>"));
end OperationalEnvelope;
