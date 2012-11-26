within IDEAS.Thermal.Components.BaseClasses;
model Pipe "Pipe without heat exchange"

  extends Thermal.Components.Interfaces.Partials.TwoPort;

equation
  Q_flow = 0;
  // pressure drop = none
  flowPort_a.p = flowPort_b.p;
annotation (Documentation(info="<HTML>
Pipe without heat exchange.<br>
Thermodynamic equations are defined by Partials.TwoPortMass(Q_flow = 0).<br>
<b>Note:</b> Setting parameter m (mass of medium within pipe) to zero
leads to neglection of temperature transient cv*m*der(T).
</HTML>"),
  Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-40},{100,40}}),
                    graphics={
        Line(
          points={{-68,20},{-68,-20}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-60,20},{-60,-20}},
          color={100,100,100},
          smooth=Smooth.None),
        Line(
          points={{60,20},{60,-20}},
          color={100,100,100},
          smooth=Smooth.None),
        Line(
          points={{68,20},{68,-20}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-68,0},{-100,0}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{68,0},{100,0}},
          color={0,0,127},
          smooth=Smooth.None),
        Line(
          points={{-60,0},{60,0}},
          color={100,100,100},
          smooth=Smooth.None)}),                            Diagram(
        coordinateSystem(preserveAspectRatio=true, extent={{-100,-40},{100,40}}),
                                                                    graphics));
end Pipe;
