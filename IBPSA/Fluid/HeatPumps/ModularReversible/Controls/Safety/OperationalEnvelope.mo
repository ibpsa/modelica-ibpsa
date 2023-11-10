within IBPSA.Fluid.HeatPumps.ModularReversible.Controls.Safety;
model OperationalEnvelope
  "Indicates if the heat pump operation is within a defined envelope"
  extends BaseClasses.PartialOperationalEnvelope;
equation
  if use_TUseSidOut then
    connect(bouMapCoo.TUseSid, sigBus.TConOutMea) annotation (Line(points={{-84.2,
          -38},{-104,-38},{-104,-73},{-119,-73}},   color={0,0,127}));
    connect(bouMapHea.TUseSid, sigBus.TConOutMea) annotation (Line(points={{-84.2,
          82},{-94,82},{-94,-72},{-104,-72},{-104,-73},{-119,-73}},     color={0,
            0,127}));
  else
    connect(bouMapCoo.TUseSid, sigBus.TConInMea) annotation (Line(points={{-84.2,
          -38},{-104,-38},{-104,-73},{-119,-73}},   color={0,0,127}));
    connect(bouMapHea.TUseSid, sigBus.TConInMea) annotation (Line(points={{-84.2,
          82},{-94,82},{-94,-72},{-104,-72},{-104,-73},{-119,-73}},     color={0,
            0,127}));
  end if;
  if use_TAmbSidOut then
    connect(bouMapHea.TAmbSid, sigBus.TEvaOutMea) annotation (Line(points={{-84.8,
          58},{-94,58},{-94,-73},{-119,-73}},   color={0,0,127}));
    connect(bouMapCoo.TAmbSid, sigBus.TEvaOutMea) annotation (Line(points={{-84.8,
          -62},{-104,-62},{-104,-73},{-119,-73}},     color={0,0,127}));
  else
    connect(bouMapHea.TAmbSid, sigBus.TEvaInMea) annotation (Line(points={{-84.8,
          58},{-94,58},{-94,-73},{-119,-73}},   color={0,0,127}));
    connect(bouMapCoo.TAmbSid, sigBus.TEvaInMea) annotation (Line(points={{-84.8,
          -62},{-104,-62},{-104,-73},{-119,-73}},     color={0,0,127}));
  end if;
  connect(swiHeaCoo.u2, sigBus.hea) annotation (Line(points={{-6,0},{-92,0},{-92,
          -73},{-119,-73}}, color={255,0,255}), Text(
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
  Model to check if the operating conditions of a heat pump are inside
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
