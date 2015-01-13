within IDEAS.Fluid.BaseCircuits;
model BalancingValve
  //Extensions
  extends Interfaces.PartialCircuitBalancingValve(final useBalancingValve=true);
equation
  if not includePipes then
    if not measureSupplyT then
      connect(port_a1, port_b1);
    else
      connect(senTemSup.port_a, port_a1) annotation (Line(
      points={{60,60},{-100,60}},
      color={0,127,255},
      smooth=Smooth.None));
    end if;
  end if;

  if includePipes then
    if not measureSupplyT then
      connect(port_b1, pipeSupply.port_b);
    end if;
  end if;

  annotation (Documentation(info="<html><p>
  This model is the base circuit implementation of a simple balancing valve. The valve is modelled using the <a href=\"modelica://IDEAS.Fluid.Actuators.Valves.TwoWayLinear\">IDEAS.Fluid.Actuators.Valves.TwoWayLinear</a> model with a constant opening of 1. <p>The valve is characterized by a fixed Kv value.</p></html>"), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics));
end BalancingValve;
