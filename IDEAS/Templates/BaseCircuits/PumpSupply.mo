within IDEAS.Templates.BaseCircuits;
model PumpSupply

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
      massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
      addPowerToMedium=false,
      allowFlowReversal=true),                  final useBalancingValve=true,
    balancingValve(show_T=true),
    booleanInput = true,
    realInput = false);

  Modelica.Blocks.Math.BooleanToReal booleanToReal(realTrue=m_flow_nominal)
    annotation (Placement(transformation(extent={{-30,70},{-10,90}})));
equation
  connect(flowRegulator.P, power) annotation (Line(
      points={{11,68},{40,68},{40,108}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(booleanToReal.y, flowRegulator.m_flow_in)
    annotation (Line(points={{-9,80},{-0.2,80},{-0.2,72}},  color={0,0,127}));
  connect(booleanToReal.u, u2) annotation (Line(points={{-32,80},{-36,80},{-40,80},
          {-40,108},{0,108}}, color={255,0,255}));
  annotation (Documentation(info="<html><p>
            This model is the base circuit implementation of a pressure head controlled pump and makes use of <a href=\"modelica://IDEAS.Fluid.Movers.FlowMachine_dp\">IDEAS.Fluid.Movers.FlowMachine_dp</a>. The flow can be regulated by changing the Kv value of the balancing valve.
            </p><p>Note that an hydronic optimization might be necessary to obtain a meaningfull value for the Kv parameter.</p></html>"), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
        Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Polygon(
          points={{-10,10},{-10,-22},{22,-6},{-10,10}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-2,66},
          rotation=360),
        Text(
          extent={{-10,70},{8,50}},
          lineColor={0,0,255},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          textString="dP")}));
end PumpSupply;
