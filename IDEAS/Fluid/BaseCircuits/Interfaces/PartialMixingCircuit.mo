within IDEAS.Fluid.BaseCircuits.Interfaces;
model PartialMixingCircuit "Partial for a circuit containing a three way valve"

  //Extensions
  extends ValveParametersTop(
    rhoStdTop=Medium.density_pTX(101325, 273.15+4, Medium.X_default));
  extends IDEAS.Fluid.BaseCircuits.Interfaces.PartialCircuitBalancingValve;

  //Parameters
  parameter Real fraKTop(min=0, max=1) = 0.7
    "Fraction Kv(port_3->port_2)/Kv(port_1->port_2)";
  parameter Real[2] lTop(each min=0, each max=1) = {0.01, 0.01}
    "Valve leakage, l=Kv(y=0)/Kv(y=1)";

  //Components
  replaceable IDEAS.Fluid.Actuators.BaseClasses.PartialThreeWayValve partialThreeWayValve
  constrainedby IDEAS.Fluid.Actuators.BaseClasses.PartialThreeWayValve(
    redeclare package Medium = Medium,
    final CvData=IDEAS.Fluid.Types.CvTypes.Kv,
    final Kv=KvTop,
    final deltaM=deltaMTop,
    final m_flow_nominal=m_flow_nominal,
    final fraK=fraKTop,
    final l=lTop)
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));

  Modelica.Blocks.Interfaces.RealInput y "Three way valve position setpoint"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,104})));
equation
  connect(partialThreeWayValve.y, y) annotation (Line(
      points={{0,72},{0,104}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(partialThreeWayValve.port_2, senTem.port_a) annotation (Line(
      points={{10,60},{60,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(partialThreeWayValve.port_3, port_a2) annotation (Line(
      points={{0,50},{0,0},{70,0},{70,-60},{100,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipeSupply.port_b, partialThreeWayValve.port_1) annotation (Line(
      points={{-70,60},{-10,60}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                         graphics={
        Polygon(
          points={{-20,70},{-20,50},{0,60},{-20,70}},
          lineColor={0,0,127},
          smooth=Smooth.None,
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{20,70},{20,50},{0,60},{20,70}},
          lineColor={0,0,127},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{0,40},{0,60}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{0,100},{-6,80},{0,60}},
          color={0,255,128},
          smooth=Smooth.None),
        Polygon(
          points={{-10,10},{-10,-10},{10,0},{-10,10}},
          lineColor={0,0,127},
          smooth=Smooth.None,
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          origin={0,50},
          rotation=90),
        Line(
          points={{0,40},{0,0},{60,0},{60,-60}},
          color={0,0,255},
          smooth=Smooth.None)}), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics));
end PartialMixingCircuit;
