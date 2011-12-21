within IDEAS.Thermal.Components.BaseClasses;
model IsolatedPipe "Pipe without heat exchange"

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
  Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Rectangle(
          extent={{-90,20},{90,-20}},
          lineColor={255,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid), Text(extent={{-150,100},{150,40}},
            textString="%name")}),                          Diagram(
        coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}),                                             graphics));
end IsolatedPipe;
