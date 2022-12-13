within IBPSA.Fluid.Chillers.BlackBoxData.BaseClasses;
partial model PartialChillerBlackBox
  "Partial black-box model of vapour compression cycles used for chiller applications"
  extends IBPSA.Fluid.HeatPumps.BlackBoxData.BaseClasses.PartialBlackBox;

equation
  connect(iceFacCal.iceFac, sigBus.iceFacChiMea) annotation (Line(points={{-79,
          -42},{-72,-42},{-72,-26},{-102,-26},{-102,104},{1,104}}, color={0,0,
          127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  annotation (Icon(graphics={Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}),
      Documentation(
  info="<html>
<p>Partial model for calculation of electrical power <code>P_el</code>, 
condenser heat flow <code>QCon</code> and evaporator heat flow <code>QEva</code> 
based on the values in the sigBus for a chiller.</p>
</html>"));
end PartialChillerBlackBox;
