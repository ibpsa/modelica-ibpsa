within IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting;
model FunctionalIcingFactor
  "Estimate the frosting supression using a function"
  extends BaseClasses.PartialIcingFactor;

  replaceable function icingFactor =
      IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.Functions.partialIcingFactor
    constrainedby
    IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.Functions.partialIcingFactor
    "Replaceable function to calculate current icing factor"
    annotation(choicesAllMatching=true);

  Modelica.Blocks.Routing.RealPassThrough pasThrTEvaIn
    "Enable usage of bus variables in function call";
  Modelica.Blocks.Routing.RealPassThrough pasThrTEvaOut
    "Enable usage of bus variables in function call";
  Modelica.Blocks.Routing.RealPassThrough pasThrMasFlowEva
    "Enable usage of bus variables in function call";

equation
  iceFac =icingFactor(
    pasThrTEvaIn.y,
    pasThrTEvaOut.y,
    pasThrMasFlowEva.y);
  connect(pasThrTEvaOut.u, sigBus.TEvaOutMea);
  connect(pasThrTEvaIn.u, sigBus.TEvaInMea);
  connect(pasThrMasFlowEva.u, sigBus.m_flowEvaMea);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{-151,147},{149,107}},
          textColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name"),
        Ellipse(
          lineColor = {108,88,49},
          fillColor = {255,215,136},
          fillPattern = FillPattern.Solid,
          extent = {{-100,-100},{100,100}}),
        Text(
          textColor={108,88,49},
          extent={{-90.0,-90.0},{90.0,90.0}},
          textString="f")}),                                     Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html><ul>
  <li>
    <i>November 26, 2018&#160;</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>", info="<html>
<p>
  Model using functional approaches for calculation of the icing factor.
  The replaceable function uses the inputs on the evaporator side to calculate
  the resulting icing factor.
</p>
<p>
  For more information on the <code>iceFac</code>, see the documentation of <a href=
  \"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialRefrigerantCycle\">
  IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialRefrigerantCycle</a>
</p>
</html>"));
end FunctionalIcingFactor;
