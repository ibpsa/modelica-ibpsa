within IDEAS.Fluid.BaseCircuits;
model PumpSupplyM "Pump on supply duct"

  //Extensions
  extends Interfaces.PartialPumpCircuit(redeclare Movers.FlowMachine_m_flow
      flowRegulator);
  extends Interfaces.PumpParameters;

equation
  connect(port_b2, pipeReturn.port_b) annotation (Line(
      points={{-100,-60},{-90,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(u, flowRegulator.m_flow_in) annotation (Line(
      points={{0,108},{0,70},{0,32},{-0.2,32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(flowRegulator.P, power) annotation (Line(
      points={{11,28},{40,28},{40,108}},
      color={0,0,127},
      smooth=Smooth.None));
    annotation(Dialog(group="Pump parameters"),
              Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Documentation(
            info="<html><p>
            This model is the base circuit implementation of a mass-flow controlled pump and makes use of <a href=\"modelica://IDEAS.Fluid.Movers.FlowMachine_m_flow\">IDEAS.Fluid.Movers.FlowMachine_m_flow</a>.
</p></html>",
            revisions="<html>
<p><ul>
<li>November 2014 by Filip Jorissen:<br> 
Initial version</li>
</ul></p>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Ellipse(extent={{-20,80},{20,40}},lineColor={0,0,127},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{0,100},{4,86},{0,70}},
          color={0,255,128},
          smooth=Smooth.None),
        Polygon(
          points={{-12,76},{-12,44},{20,60},{-12,76}},
          lineColor={0,0,127},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end PumpSupplyM;
