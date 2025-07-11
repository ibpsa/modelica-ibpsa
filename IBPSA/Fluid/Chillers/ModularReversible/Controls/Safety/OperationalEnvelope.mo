within IBPSA.Fluid.Chillers.ModularReversible.Controls.Safety;
model OperationalEnvelope
  "Indicates if the chiller operation is within a defined envelope"
  extends
    HeatPumps.ModularReversible.Controls.Safety.BaseClasses.PartialOperationalEnvelope;
  Modelica.Blocks.Logical.Not notCoo "=true for heating" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,0})));
equation
    if use_TEvaOutHea then
    connect(bouMapHea.TUseSid, sigBus.TEvaOutMea) annotation (Line(points={{-81.4,
            54},{-104,54},{-104,-61},{-119,-61}},                       color={0,
            0,127}));
  else
    connect(bouMapHea.TUseSid, sigBus.TEvaInMea) annotation (Line(points={{-81.4,
            54},{-104,54},{-104,-61},{-119,-61}},                       color={0,
            0,127}));
  end if;
  if use_TConOutCoo then
    connect(bouMapCoo.TAmbSid, sigBus.TConOutMea) annotation (Line(points={{-81.6,
            -34},{-104,-34},{-104,-61},{-119,-61}},
                                                color={0,0,127}));
  else
    connect(bouMapCoo.TAmbSid, sigBus.TConInMea) annotation (Line(points={{-81.6,
            -34},{-104,-34},{-104,-61},{-119,-61}},
                                                color={0,0,127}));
  end if;
  if use_TConOutHea then
    connect(bouMapHea.TAmbSid, sigBus.TConOutMea) annotation (Line(points={{-81.6,
            46},{-104,46},{-104,-60},{-106,-60},{-106,-61},{-119,-61}},
                                                color={0,0,127}));
  else
    connect(bouMapHea.TAmbSid, sigBus.TConInMea) annotation (Line(points={{-81.6,
            46},{-104,46},{-104,-60},{-112,-60},{-112,-61},{-119,-61}},
                                                color={0,0,127}));
  end if;
  if use_TEvaOutCoo then
    connect(bouMapCoo.TUseSid, sigBus.TEvaOutMea) annotation (Line(points={{-81.4,
            -26},{-104,-26},{-104,-60},{-112,-60},{-112,-61},{-119,-61}},
                                                      color={0,0,127}));
  else
    connect(bouMapCoo.TUseSid, sigBus.TEvaInMea) annotation (Line(points={{-81.4,
            -26},{-104,-26},{-104,-60},{-112,-60},{-112,-61},{-119,-61}},
                                                      color={0,0,127}));
  end if;
  connect(notCoo.y, swiHeaCoo.u2)
    annotation (Line(points={{-59,0},{-6,0}}, color={255,0,255}));
  connect(notCoo.u, sigBus.coo) annotation (Line(points={{-82,0},{-96,0},{-96,
          -60},{-104,-60},{-104,-61},{-119,-61}},
                       color={255,0,255}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
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
<p>
  Model to check if the operating conditions of a chiller are inside
  the given boundaries. If not, the heat pump or chiller will switch off.
</p>
<p>
  Read the documentation of
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.Controls.Safety.BaseClasses.PartialOperationalEnvelope\">
  IBPSA.Fluid.HeatPumps.ModularReversible.Controls.Safety.BaseClasses.PartialOperationalEnvelope</a>
  for more information.
</p>

</html>"));
end OperationalEnvelope;
