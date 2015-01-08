within IDEAS.Fluid.BaseCircuits;
model BalancingValve
  //Extensions
  extends Interfaces.PartialCircuitBalancingValve;
equation
  if not includePipes then
    if not measureSupplyT then
      connect(port_a1, port_b1);
    else
      connect(port_a1, senTem.port_a);
      connect(port_b1, senTem.port_b);
    end if;
  end if;

  if includePipes then
    if not measureSupplyT then
      connect(port_a1, pipeSupply.port_a);
      connect(port_b1, pipeSupply.port_b);
    end if;
  end if;

  connect(pipeSupply.port_b, senTem.port_a) annotation (Line(
      points={{-70,60},{-20,60},{-20,20},{60,20}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Documentation(info="<html><p>
  This model is the base circuit implementation of a simple balancing valve. The valve is modelled using the <a href=\"modelica://IDEAS.Fluid.Actuators.Valves.TwoWayLinear\">IDEAS.Fluid.Actuators.Valves.TwoWayLinear</a> model with a constant opening of 1. <p>The valve is characterized by a fixed Kv value.</p></html>"), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Polygon(
          points={{-20,-50},{-20,-70},{0,-60},{-20,-50}},
          lineColor={0,0,127},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{20,-50},{20,-70},{0,-60},{20,-50}},
          lineColor={0,0,127},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{0,-60},{0,-40}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-10,-40},{10,-40}},
          color={0,0,127},
          smooth=Smooth.None)}));
end BalancingValve;
