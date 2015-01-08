within IDEAS.Fluid.BaseCircuits;
model PumpSupplydP

  //Extensions
  extends Interfaces.PartialFlowCircuit(redeclare Movers.FlowMachine_dp
      flowRegulator);
  extends Interfaces.PumpParameters;

equation
  connect(flowRegulator.P, power) annotation (Line(
      points={{11,28},{40,28},{40,108}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(u, flowRegulator.dp_in) annotation (Line(
      points={{0,108},{0,70},{0,32},{-0.2,32}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Documentation(info="<html><p>
            This model is the base circuit implementation of a pressure head controlled pump and makes use of <a href=\"modelica://IDEAS.Fluid.Movers.FlowMachine_dp\">IDEAS.Fluid.Movers.FlowMachine_dp</a>. The flow can be regulated by changing the Kv value of the balancing valve.
            </p><p>Note that an hydronic optimization might be necessary to obtain a meaningfull value for the Kv parameter.</p></html>"), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
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
        Ellipse(
          extent={{-20,80},{20,40}},
          lineColor={0,0,255},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
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
          textString="dP"),
        Polygon(
          points={{-10,10},{-10,-10},{10,0},{-10,10}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-10,-60},
          rotation=360),
        Polygon(
          points={{-10,10},{-10,-10},{10,0},{-10,10}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={10,-60},
          rotation=180),
        Line(
          points={{0,-60},{0,-44}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{-6,-44},{6,-44}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{0,100},{4,86},{0,70}},
          color={0,255,128},
          smooth=Smooth.None),
        Line(
          points={{70,100},{76,80},{74,60}},
          color={255,0,0},
          smooth=Smooth.None),
        Ellipse(
          extent={{72,62},{76,58}},
          lineColor={255,0,0},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid)}));
end PumpSupplydP;
