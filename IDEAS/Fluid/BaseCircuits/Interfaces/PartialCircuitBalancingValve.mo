within IDEAS.Fluid.BaseCircuits.Interfaces;
partial model PartialCircuitBalancingValve

  //Extensions
  extends ValveParametersBot(
      rhoStdBot=Medium.density_pTX(101325, 273.15+4, Medium.X_default));
  extends PartialBaseCircuit(senTem(redeclare package Medium = Medium,
        m_flow_nominal=m_flow_nominal), pipeReturn(dp_nominal=0));

  //Components
  Modelica.Blocks.Sources.Constant const(k=1)
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  replaceable Actuators.Valves.TwoWayLinear balancingValve(
        Kv=KvBot,
        Av=AvBot,
        Cv=CvBot,
        rhoStd=rhoStdBot,
        deltaM=deltaMBot,
        CvData=IDEAS.Fluid.Types.CvTypes.Kv,
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dpFixed_nominal=if includePipes then dp else 0)
                                             constrainedby
    Actuators.BaseClasses.PartialTwoWayValve
    annotation (Placement(transformation(extent={{10,-70},{-10,-50}})));

equation
  if not includePipes then
    connect(balancingValve.port_b, port_b2);
  end if;

  connect(balancingValve.port_b, pipeReturn.port_a) annotation (Line(
      points={{-10,-60},{-70,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(const.y, balancingValve.y) annotation (Line(
      points={{-19,-40},{0,-40},{0,-48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(port_a2, balancingValve.port_a) annotation (Line(
      points={{100,-60},{10,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(graphics));
end PartialCircuitBalancingValve;
