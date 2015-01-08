within IDEAS.Fluid.BaseCircuits;
model PumpSupply "Pump on supply duct"
  //Extensions
  extends Interfaces.PartialPumpCircuit(
      redeclare Movers.FlowMachine_Nrpm flowRegulator);
  extends Interfaces.PumpParameters;

  parameter Modelica.SIunits.Conversions.NonSIunits.AngularVelocity_rpm
    N_nominal = 1500 "Nominal rotational speed for flow characteristic"
    annotation(Dialog(group="Pump parameters"));

  //Interfaces

  //Components

  Sensors.TemperatureTwoPort senTem
    annotation (Placement(transformation(extent={{60,10},{80,30}})));
equation
  connect(port_b2, pipeReturn.port_b) annotation (Line(
      points={{-100,-60},{-90,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTem.port_b, port_b1) annotation (Line(
      points={{80,20},{86,20},{86,60},{100,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(u, flowRegulator.Nrpm) annotation (Line(
      points={{0,108},{0,32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(flowRegulator.P, power) annotation (Line(
      points={{11,28},{40,28},{40,108}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
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
        Line(
          points={{60,60},{100,60}},
          color={0,0,127},
          smooth=Smooth.None)}));
end PumpSupply;
