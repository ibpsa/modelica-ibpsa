within IBPSA.Fluid.HeatPumps.BlackBoxData.Frosting;
model FunctionalApproach
  "Estimate the frosting supression using a function"
  extends BaseClasses.PartialIceFac;

  replaceable function iceFunc =
      IBPSA.Fluid.HeatPumps.BlackBoxData.Frosting.Functions.PartialBaseFct
    constrainedby
    IBPSA.Fluid.HeatPumps.BlackBoxData.Frosting.Functions.PartialBaseFct "Replaceable function to calculate current icing factor" annotation(choicesAllMatching=true);

  Modelica.Blocks.Routing.RealPassThrough passThroughTEvaIn;
  Modelica.Blocks.Routing.RealPassThrough passThroughTEvaOut;
  Modelica.Blocks.Routing.RealPassThrough passThroughMFlowEva;

equation
  iceFac = iceFunc(passThroughTEvaIn.y, passThroughTEvaOut.y, passThroughMFlowEva.y);
  connect(passThroughTEvaOut.u, sigBus.TEvaOutMea);
  connect(passThroughTEvaIn.u, sigBus.TEvaInMea);
  connect(passThroughMFlowEva.u, sigBus.m_flowEvaMea);
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
    <i>November 26, 2018&#160;</i> by Fabian Wüllhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">#577</a>)
  </li>
</ul>
</html>", info="<html>
<p>
  Model for calculation of the icing factor. The replaceable function
  uses the inputs to calculate the resulting icing factor.
</p>
</html>"));
end FunctionalApproach;
