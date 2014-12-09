within IDEAS.Fluid.BaseCircuits;
model BalancingValve
  //Extensions
  extends Interfaces.Circuit;
  extends IDEAS.Fluid.Actuators.BaseClasses.ValveParameters(
    CvData=IDEAS.Fluid.Types.CvTypes.Kv,
    Kv=KV);

  //Parameters
  parameter Real KV "Fixed KV value of the balancing valve";

  //Components
  IDEAS.Fluid.Actuators.Valves.TwoWayLinear val1(
    redeclare package Medium = Medium,
    CvData=CvData,
    Kv=Kv,
    rhoStd=rhoStd,
    m_flow_nominal=m_flow_nominal) annotation (Placement(transformation(extent={{10,-70},{-10,-50}})));

  Modelica.Blocks.Sources.Constant hlift(k=1)
    "Constant opening of the balancing valve"
    annotation (Placement(transformation(extent={{-38,-20},{-18,0}})));

equation
  connect(val1.port_b, port_b2) annotation (Line(
      points={{-10,-60},{-100,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hlift.y, val1.y) annotation (Line(
      points={{-17,-10},{0,-10},{0,-48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pipeSupply.port_b, port_b1) annotation (Line(
      points={{-60,60},{100,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(val1.port_a, pipeReturn.port_b) annotation (Line(
      points={{10,-60},{60,-60}},
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
