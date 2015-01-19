within IDEAS.Fluid.BaseCircuits;
model PumpSupply_dp

  //Extensions
  extends Interfaces.PartialPumpCircuit(redeclare Movers.FlowMachine_dp
      flowRegulator(motorCooledByFluid=motorCooledByFluid,
        motorEfficiency=motorEfficiency,
        hydraulicEfficiency=hydraulicEfficiency), final useBalancingValve=true);

equation
  connect(flowRegulator.P, power) annotation (Line(
      points={{11,68},{40,68},{40,108}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(u, flowRegulator.dp_in) annotation (Line(
      points={{0,108},{0,70},{0,72},{-0.2,72}},
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
        Text(
          extent={{-10,70},{8,50}},
          lineColor={0,0,255},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          textString="dP")}));
end PumpSupply_dp;
