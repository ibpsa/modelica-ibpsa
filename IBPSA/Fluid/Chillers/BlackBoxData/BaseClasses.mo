within IBPSA.Fluid.Chillers.BlackBoxData;
package BaseClasses "Package with partial classes of Performance Data"
  partial model PartialChillerBlackBox
    "Partial black box model of vapour compression cycles used for chiller applications"
    extends IBPSA.Fluid.HeatPumps.BlackBoxData.BaseClasses.PartialBlackBox;

  equation
    connect(iceFacCalc.iceFac, sigBus.iceFacChiMea) annotation (Line(points={{
            -79,-42},{-72,-42},{-72,-26},{-102,-26},{-102,104},{1,104}}, color=
            {0,0,127}), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}},
        horizontalAlignment=TextAlignment.Left));
    annotation (Icon(graphics={   Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),   Text(
            extent={{-57.5,-35},{57.5,35}},
            lineColor={0,0,255},
            pattern=LinePattern.Dash,
            textString="%name
",          origin={-3.5,-15},
            rotation=180)}), Documentation(info="<html>
<p><span style=\"font-family: (Default);\">Partial model for calculation of electrical power P_el, condenser heat flow QCon and evaporator heat flow QEva based on the values in the sigBus for a chiller.</span></p>
</html>"));
  end PartialChillerBlackBox;
annotation (Icon(graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),
        Ellipse(
          extent={{-30.0,-30.0},{30.0,30.0}},
          lineColor={128,128,128},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}), Documentation(revisions="<html><ul>
  <li>
    <i>May 22, 2019&#160;</i> by Julian Matthes:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/715\">#715</a>)
  </li>
</ul>
</html>", info="<html>
<p>
  This package contains base classes for the package <a href=
  \"modelica://IBPSA.Fluid.HeatPumps.BaseClasses.PerformanceData\">IBPSA.Fluid.Chillers.BaseClasses.PerformanceData</a>.
</p>
</html>"));
end BaseClasses;
