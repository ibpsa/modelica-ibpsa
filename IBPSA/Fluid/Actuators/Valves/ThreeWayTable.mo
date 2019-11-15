within IBPSA.Fluid.Actuators.Valves;
model ThreeWayTable
  "Three way valve with table-specified characteristics"
    extends BaseClasses.PartialThreeWayValve(final l={0,0},
      redeclare TwoWayTable res1(final flowCharacteristics=flowCharacteristics1),
      redeclare TwoWayTable res3(final flowCharacteristics=flowCharacteristics3));

  parameter Data.Generic flowCharacteristics1 "Table with flow characteristics"     annotation (choicesAllMatching=true, Placement(transformation(extent={{-90,80},
            {-70,100}})));
  parameter Data.Generic flowCharacteristics3 "Table with flow characteristics"     annotation (choicesAllMatching=true, Placement(transformation(extent={{-50,80},
            {-30,100}})));
equation
  connect(inv.y, res3.y) annotation (Line(points={{-62.6,46},{20,46},{20,-50},{
          12,-50}},      color={0,0,127}));
  connect(y_actual, inv.u2) annotation (Line(points={{50,70},{88,70},{88,34},{
          -68,34},{-68,41.2}},
                         color={0,0,127}));
  connect(y_actual, res1.y) annotation (Line(points={{50,70},{88,70},{88,34},{
          -50,34},{-50,12}},
        color={0,0,127}));
  annotation (defaultComponentName="val",
Documentation(info="<html>
<p>Three way valve with table-specified opening characteristics. A separate characteristic for each path (port_1/port_ 2 and port_3/port_2) is used.</p>
<p>The parameters <span style=\"font-family: Courier New;\">flowCharacteristics1</span> and <span style=\"font-family: Courier New;\">flowCharacteristics3</span> declare tables of the form </p>
<table cellspacing=\"0\" cellpadding=\"2\" border=\"1\"><tr>
<td><p><i>y</i></p></td>
<td><p>0</p></td>
<td><p>...</p></td>
<td><p>1</p></td>
</tr>
<tr>
<td><p><i>&phi;</i></p></td>
<td><p><i>l</i></p></td>
<td><p>...</p></td>
<td><p>1</p></td>
</tr>
</table>
<p><br><br><br>Further details can be found in the model <a href=\"modelica://IBPSA.Fluid.Actuators.TwoWayTable\">IBPSA.Fluid.Actuators.TwoWayTable</a>. </p>
<p>This model is based on the partial valve model <a href=\"modelica://IBPSA.Fluid.Actuators.BaseClasses.PartialThreeWayValve\">IBPSA.Fluid.Actuators.BaseClasses.PartialThreeWayValve</a> and <a href=\"modelica://IBPSA.Fluid.Actuators.TwoWayTable\">IBPSA.Fluid.Actuators.TwoWayTable</a>.</p>
</html>",
revisions="<html>
<ul>
<li>November 15, 2019, by Alexander K&uuml;mpel:<br>First implementation. </li>
</ul>
</html>"));
end ThreeWayTable;
