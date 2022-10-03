within IBPSA.Fluid.HeatPumps.BlackBoxData.BaseClasses;
partial model PartialHeatPumpBlackBox
  extends PartialBlackBox;
equation
  connect(iceFacCalc.iceFac, sigBus.icefacHPMea) annotation (Line(points={{-79,
          -42},{-72,-42},{-72,-28},{-102,-28},{-102,104},{1,104}}, color={0,0,
          127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Documentation(info="<html>
  <p>Partial black-box data for heat pumps. Specifies <code>iceFacHPMea</code>
  in addition to basic equations.</p>
</html>", revisions="<html><ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
</ul>
</html>"));
end PartialHeatPumpBlackBox;
