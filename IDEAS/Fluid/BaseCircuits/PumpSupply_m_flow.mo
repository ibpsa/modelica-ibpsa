within IDEAS.Fluid.BaseCircuits;
model PumpSupply_m_flow "Pump on supply duct"

  //Extensions
  extends Interfaces.PartialPumpCircuit(redeclare Movers.FlowMachine_m_flow
      flowRegulator(motorCooledByFluid=motorCooledByFluid,
        motorEfficiency=motorEfficiency,
        hydraulicEfficiency=hydraulicEfficiency));

equation
  connect(u, flowRegulator.m_flow_in) annotation (Line(
      points={{0,108},{0,70},{0,72},{-0.2,72}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(flowRegulator.P, power) annotation (Line(
      points={{11,68},{40,68},{40,108}},
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
        graphics));
end PumpSupply_m_flow;
