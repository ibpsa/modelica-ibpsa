within IDEAS.Thermal.Components.BaseClasses;
model inspipe_unbalanced "Pipe with heat exchange, incl. thermal conductance"

  extends Thermal.Components.Interfaces.Partials.TwoPort;
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor ins(G=
        UA) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-20})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort annotation (
      Placement(transformation(extent={{-10,-60},{10,-40}}), iconTransformation(
          extent={{-10,-60},{10,-40}})));
  parameter SI.ThermalConductance UA "Thermal conductance of the insulation";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a1
    annotation (Placement(transformation(extent={{-10,8},{10,28}})));
equation
  // energy exchange with medium
  Q_flow + port_a1.Q_flow = 0;
  // defines heatPort's temperature
  port_a1.T = T;
  // pressure drop = none
  flowPort_a.p = flowPort_b.p;
  connect(ins.port_b, heatPort) annotation (Line(
      points={{-1.83697e-015,-30},{0,-30},{0,-50}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(ins.port_a, port_a1) annotation (Line(
      points={{1.83697e-015,-10},{0,-10},{0,18}},
      color={191,0,0},
      smooth=Smooth.None));
annotation (Documentation(info="<HTML>
Pipe with heat exchange.<br>
Thermodynamic equations are defined by Partials.TwoPort.<br>
Q_flow is defined by heatPort.Q_flow.<br>
<b>Note:</b> Setting parameter m (mass of medium within pipe) to zero
leads to neglection of temperature transient cv*m*der(T).<br>
<b>Note:</b> Injecting heat into a pipe with zero massflow causes
temperature rise defined by storing heat in medium's mass.
</HTML>"),
  Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
                    graphics={
        Text(extent={{-144,102},{156,42}}, textString="%name"),
                              Rectangle(
          extent={{-100,20},{100,-20}},
          lineColor={255,255,255},
          fillColor={85,170,255},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{-100,40},{100,20}},
          lineColor={0,0,255},
          fillPattern=FillPattern.Backward,
          fillColor={186,89,76}),
        Rectangle(
          extent={{-100,-20},{100,-40}},
          lineColor={0,0,255},
          fillPattern=FillPattern.Backward,
          fillColor={186,89,76})}),
                            Diagram(coordinateSystem(preserveAspectRatio=true,
                   extent={{-100,-100},{100,100}}),
                                    graphics));
end inspipe_unbalanced;
