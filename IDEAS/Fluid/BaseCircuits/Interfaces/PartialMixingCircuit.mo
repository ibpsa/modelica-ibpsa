within IDEAS.Fluid.BaseCircuits.Interfaces;
model PartialMixingCircuit "Partial for a circuit containing a three way valve"
  extends IDEAS.Fluid.BaseCircuits.Interfaces.PartialCircuitBalancingValve;

  //Parameters
  parameter SI.Mass mMix=1 "Mass of fluid inside the mixing valve"
  annotation(Dialog(group = "Mixing valve"));
  parameter SI.Mass mPipe=1 "Mass of fluid inside the middle pipe"
  annotation(Dialog(group = "Mixing valve"));
  parameter Modelica.SIunits.Pressure dpMixPipe=0
    "Pressure drop over the middle single pipe"
    annotation(Dialog(group = "Mixing valve"));

  replaceable IDEAS.Fluid.Actuators.BaseClasses.PartialThreeWayValve partialThreeWayValve
  constrainedby IDEAS.Fluid.Actuators.BaseClasses.PartialThreeWayValve
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Modelica.Blocks.Interfaces.RealInput y "Three way valve position setpoint"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,104})));
equation
  connect(partialThreeWayResistance.port_1, pipeSupply.port_b) annotation (Line(
      points={{-10,60},{-70,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(partialThreeWayResistance.port_2, senTem.port_a) annotation (Line(
      points={{10,60},{60,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(partialThreeWayResistance.port_3, balancingValve.port_a) annotation (
      Line(
      points={{0,50},{0,-60},{-18,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(partialThreeWayValve.y, y) annotation (Line(
      points={{0,72},{0,104}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
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
          points={{0,40},{0,-60}},
          color={0,0,255},
          smooth=Smooth.None)}), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics));
end PartialMixingCircuit;
