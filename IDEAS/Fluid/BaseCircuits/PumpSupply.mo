within IDEAS.Fluid.BaseCircuits;
model PumpSupply "Pump on supply duct"

  //Parameters
  parameter Boolean filteredSpeed=true
    "= true, if speed is filtered with a 2nd order CriticalDamping filter"
    annotation(Dialog(tab="Dynamics", group="Filtered speed"));
  parameter Modelica.SIunits.Time riseTime=30
    "Rise time of the filter (time to reach 99.6 % of the speed)"
    annotation(Dialog(tab="Dynamics", group="Filtered speed",enable=filteredSpeed));
  parameter Modelica.Blocks.Types.Init init=Modelica.Blocks.Types.Init.InitialOutput
    "Type of initialization (no init/steady state/initial state/initial output)"
    annotation(Dialog(tab="Dynamics", group="Filtered speed",enable=filteredSpeed));

  //Extensions
  extends Interfaces.PartialPumpCircuit(redeclare
      IDEAS.Fluid.Movers.FlowControlled_m_flow
      flowRegulator(
        filteredSpeed=filteredSpeed,
        riseTime=riseTime,
        init=init,
        motorCooledByFluid=motorCooledByFluid),
        final realInput = false, final booleanInput = true);

  Modelica.Blocks.Math.BooleanToReal booleanToReal(realTrue=m_flow_nominal)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-30,100})));
equation
  connect(flowRegulator.P, power) annotation (Line(
      points={{11,68},{40,68},{40,108}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(booleanToReal.y, flowRegulator.m_flow_in) annotation (Line(points={{-41,
          100},{-50,100},{-50,80},{-0.2,80},{-0.2,72}}, color={0,0,127}));
  connect(u1, booleanToReal.u) annotation (Line(points={{0,108},{0,108},{0,100},
          {-18,100}}, color={255,0,255}));
    annotation(Dialog(group="Pump parameters"),
              Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),           Documentation(
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
end PumpSupply;
