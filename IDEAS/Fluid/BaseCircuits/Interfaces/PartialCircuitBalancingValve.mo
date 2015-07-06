within IDEAS.Fluid.BaseCircuits.Interfaces;
partial model PartialCircuitBalancingValve

  // Extensions ----------------------------------------------------------------

  extends ValveParametersReturn;
  extends PartialBaseCircuit( pipeReturn(dp_nominal=0));

  // Parameter -----------------------------------------------------------------

  parameter Boolean useBalancingValve=false
    "Set to true to include a balancing valve"
    annotation(Dialog(group = "Settings"));

  // Components ----------------------------------------------------------------

//protected
  FixedResistances.FixedResistanceDpM       balancingValve(
        final deltaM=deltaMReturn,
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=m_flow_nominal^2/KvReturn^2*1e5,
    allowFlowReversal=false) if                            useBalancingValve
    annotation (Placement(transformation(extent={{10,-70},{-10,-50}})));

equation
  if not useBalancingValve then
    if includePipes then
      connect(pipeReturn.port_a, port_a2);
    else
      if measureReturnT then
        connect(senTemRet.port_a, port_a2);
      else
        connect(port_b2, port_a2);
      end if;
    end if;
  else
    if not includePipes then
      if measureReturnT then
        connect(senTemRet.port_a, balancingValve.port_b);
      end if;
    end if;
  end if;

  if not measureReturnT then
    if includePipes then
      connect(pipeReturn.port_b, port_b2);
    else
      if useBalancingValve then
        connect(balancingValve.port_b, port_b2);
      end if;
    end if;
  end if;

  connect(balancingValve.port_b, pipeReturn.port_a) annotation (Line(
      points={{-10,-60},{-30,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_a2, balancingValve.port_a) annotation (Line(
      points={{100,-60},{10,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(graphics={
        Polygon(
          points={{-20,-50},{-20,-70},{0,-60},{-20,-50}},
          lineColor={0,0,127},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=useBalancingValve),
        Polygon(
          points={{20,-50},{20,-70},{0,-60},{20,-50}},
          lineColor={0,0,127},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=useBalancingValve),
        Line(
          points={{0,-60},{0,-40}},
          color={0,0,127},
          smooth=Smooth.None,
          visible=useBalancingValve),
        Line(
          points={{-10,-40},{10,-40}},
          color={0,0,127},
          smooth=Smooth.None,
          visible=useBalancingValve)}));
end PartialCircuitBalancingValve;
