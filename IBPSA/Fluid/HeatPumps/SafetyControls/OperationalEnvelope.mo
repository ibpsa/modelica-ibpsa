within IBPSA.Fluid.HeatPumps.SafetyControls;
block OperationalEnvelope
  "Block which computes an error if the current values are outside of the given operatinal envelope"
  extends BaseClasses.PartialSafetyControlWithErrors;
  extends BaseClasses.BoundaryMapIcon(final iconMin=-70, final iconMax=70);
  parameter Boolean use_opeEnv
    "False to allow HP to run out of operational envelope" annotation(choices(checkBox=true));
  parameter Modelica.Units.SI.TemperatureDifference dTHyst=5
    "Temperature difference used for both upper and lower hysteresis in the operational envelope."
    annotation (Dialog(
      tab="Safety Control",
      group="Operational Envelope",
      enable=use_opeEnv));
    Modelica.Blocks.Math.UnitConversions.To_degC toDegCT_ret_co annotation (
      extent=[-88,38; -76,50], Placement(transformation(extent={{-100,40},{-80,
            60}})));
  Modelica.Blocks.Math.UnitConversions.To_degC toDegCT_flow_ev annotation (
      extent=[-88,38; -76,50], Placement(transformation(extent={{-100,80},{-80,
            100}})));
  BaseClasses.BoundaryMap boundaryMap(
    final tableUpp=tableUpp,
    final use_opeEnvFroRec=use_opeEnvFroRec,
    final dataTable=dataTable,
    final dx=dTHyst) if use_opeEnv
    annotation (Placement(transformation(extent={{-62,38},{2,102}})));
  Modelica.Blocks.Sources.BooleanConstant booConOpeEnv(final k=true) if not
    use_opeEnv
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));

equation
  connect(ySet,swiErr.u1)  annotation (Line(points={{-136,20},{32,20},{32,8},{
          78,8}}, color={0,0,127}));

  connect(modeSet, modeOut) annotation (Line(points={{-136,-20},{-114,-20},{
          -114,-52},{110,-52},{110,-20},{130,-20}}, color={255,0,255}));
  connect(sigBusHP.TEvaInMea, toDegCT_flow_ev.u) annotation (Line(
      points={{-129,-69},{-108,-69},{-108,90},{-102,90}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(boundaryMap.x_in, toDegCT_flow_ev.y)
    annotation (Line(points={{-66.48,89.2},{-66.48,90},{-79,90}},
                                                        color={0,0,127}));
  connect(boundaryMap.y_in, toDegCT_ret_co.y)
    annotation (Line(points={{-66.48,50.8},{-72.74,50.8},{-72.74,50},{-79,50}},
                                                          color={0,0,127}));
  connect(sigBusHP.TConOutMea, toDegCT_ret_co.u) annotation (Line(
      points={{-129,-69},{-102,-69},{-102,50}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(booleanPassThrough.u, booConOpeEnv.y) annotation (Line(
      points={{38,0},{6,0},{6,-30},{1,-30}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(boundaryMap.noErr, booleanPassThrough.u) annotation (Line(
      points={{5.2,70},{24,70},{24,0},{38,0}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  annotation (Diagram(coordinateSystem(extent={{-120,-120},{120,120}})), Icon(
        coordinateSystem(extent={{-120,-120},{120,120}})),
    Documentation(revisions="<html><ul>
  <li>
    <i>November 26, 2018&#160;</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">#577</a>)
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
