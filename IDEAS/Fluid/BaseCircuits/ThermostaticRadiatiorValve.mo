within IDEAS.Fluid.BaseCircuits;
model ThermostaticRadiatiorValve
  "Simple TRV model approximated by a P-control action"

  //Extensions
  extends Interfaces.PartialValveCircuit(
    redeclare Actuators.Valves.TwoWayQuickOpening    flowRegulator);
  extends Interfaces.ValveParametersTop;
  Modelica.Blocks.Interfaces.RealInput u1 "measurement signal"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-40,110})));
  annotation(Dialog(group = "Thermostatic valve parameters",
                    enable = (CvData==IDEAS.Fluid.Types.CvTypes.Kv)));
  Modelica.Blocks.Continuous.LimPID PID(controllerType=Modelica.Blocks.Types.SimpleController.P,
      k=1) annotation (Placement(transformation(extent={{6,52},{26,72}})));
equation
  connect(PID.u_m, u1) annotation (Line(
      points={{16,50},{16,44},{-28,44},{-28,80},{-40,80},{-40,110}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(u, PID.u_s) annotation (Line(
      points={{0,108},{0,62},{4,62}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(PID.y, flowRegulator.y) annotation (Line(
      points={{27,62},{34,62},{34,38},{0,38},{0,32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(flowRegulator.y_actual, power) annotation (Line(
      points={{5,27},{40,27},{40,108}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
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
        Rectangle(
          extent={{-4,44},{4,36}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{0,100},{6,80},{0,60}},
          color={0,255,128},
          smooth=Smooth.None),
        Line(
          points={{0,-60},{0,-40}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-10,-40},{10,-40}},
          color={0,0,127},
          smooth=Smooth.None),
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
        Text(
          extent={{4,44},{24,24}},
          lineColor={0,0,127},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          textString="T"),
        Line(
          points={{-40,100},{-16,86},{0,60}},
          color={255,0,0},
          smooth=Smooth.None)}));
end ThermostaticRadiatiorValve;
