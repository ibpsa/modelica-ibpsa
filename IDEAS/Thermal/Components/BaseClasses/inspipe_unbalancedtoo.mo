within IDEAS.Thermal.Components.BaseClasses;
model inspipe_unbalancedtoo "Pipe with heat exchange"

  extends Thermal.Components.Interfaces.Partials.TwoPort;
  parameter SI.ThermalConductance UA "Thermal conductance of the insulation";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort_internal
    annotation (Placement(transformation(extent={{-10,-36},{10,-16}},
          rotation=0)));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(G=
        UA) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-62})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a1
    annotation (Placement(transformation(extent={{-10,-108},{10,-88}})));
equation
  // energy exchange with medium
  Q_flow = heatPort_internal.Q_flow;
  // defines heatPort's temperature
  heatPort_internal.T = T;
  // pressure drop = none
  flowPort_a.p = flowPort_b.p;
  connect(thermalConductor.port_a, port_a1) annotation (Line(
      points={{-6.12323e-016,-72},{-6.12323e-016,-86},{0,-86},{0,-98}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(thermalConductor.port_b, heatPort_internal) annotation (Line(
      points={{6.12323e-016,-52},{0,-52},{0,-26}},
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
  Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={
        Text(extent={{-150,100},{150,40}}, textString="%name"),
        Polygon(
          points={{-10,-90},{-10,-40},{0,-20},{10,-40},{10,-90},{-10,-90}},
          lineColor={255,0,0},
          fillPattern=FillPattern.Forward,
          fillColor={255,255,255}),
                              Rectangle(
          extent={{-100,20},{100,-20}},
          lineColor={255,255,255},
          fillColor={85,170,255},
          fillPattern=FillPattern.HorizontalCylinder)}),
                            Diagram(coordinateSystem(preserveAspectRatio=true,
                   extent={{-100,-100},{100,100}}),
                                    graphics));
end inspipe_unbalancedtoo;
