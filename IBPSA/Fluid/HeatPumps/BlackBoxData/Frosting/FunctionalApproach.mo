within IBPSA.Fluid.HeatPumps.BlackBoxData.Frosting;
model FunctionalApproach
  "Estimate the frosting supression using a function"
  extends BaseClasses.PartialIceFac;

  replaceable function iceFacFun =
      IBPSA.Fluid.HeatPumps.BlackBoxData.Frosting.Functions.PartialBaseFct
    constrainedby
    IBPSA.Fluid.HeatPumps.BlackBoxData.Frosting.Functions.PartialBaseFct
    "Replaceable function to calculate current icing factor"
    annotation(choicesAllMatching=true);

  Modelica.Blocks.Routing.RealPassThrough pasThrTEvaIn;
  Modelica.Blocks.Routing.RealPassThrough pasThrTEvaOut;
  Modelica.Blocks.Routing.RealPassThrough pasThrMFlowEva;

equation
  iceFac =iceFacFun(
    pasThrTEvaIn.y,
    pasThrTEvaOut.y,
    pasThrMFlowEva.y);
  connect(pasThrTEvaOut.u, sigBus.TEvaOutMea);
  connect(pasThrTEvaIn.u, sigBus.TEvaInMea);
  connect(pasThrMFlowEva.u, sigBus.m_flowEvaMea);
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
  Model for calculation of the icing factor. The replaceable function
  uses the inputs to calculate the resulting icing factor.
</p>
</html>"));
end FunctionalApproach;
